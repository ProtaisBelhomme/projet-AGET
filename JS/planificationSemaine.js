// Fichier Javascript/Jquery pour créer les la liste des créneaux d'une semaine
// du projet EDTAutomatic (moteur de recuit simulé écrit en Julia)
// Auteur : Philippe Belhomme
// Date de création : lundi 31 janvier 2022 (isolement Covid...)
// Date de modification : mardi 15 février 2022

/* ------------------------
-- Fonctions utilitaires --
-------------------------*/

// Fonction qui fabrique (et retourne) la chaine html d'un créneau
function fabriqueCreneauHTML(uuid, type, matiere, prof, lieu, public, duree, onglet) {
    ch = "<div id='" + uuid + "' class='creneau' ";
    ch += "data-type='" + type + "' data-matiere='" + matiere + "' ";
    ch += "data-prof='" + prof + "' data-lieu='" + lieu + "' ";
    ch += "data-public='" + public + "' data-duree='" + duree + "' ";
    ch += "data-onglet='" + onglet + "'>";
    ch += "<b>" + type + "&nbsp;" + matiere + "</b><br>";
    ch += prof + "<br>" + lieu + "<br>";
    ch += public + "<br>" + duree + "</div>";
    return ch;
}

// Fonction qui lit et retourne les données d'un créneau à partir du formulaire
// en supprimant les espaces inutiles (trim)
function attributsFromFormulaire() {
    return {
        "type": $("#type").val().trim(),
        "matiere": $("#matiere").val().trim(),
        "prof": $("#prof").val().trim(),
        "lieu": $("#lieu").val().trim(),
        "public": $("#public").val().trim(),
        "duree": $("#duree").val().trim()
    }
}

// Fonction qui permet de remplir le formulaire avec les données fournies
function remplitFormulaire(type, matiere, prof, lieu, public, duree, uuid) {
    $("#type").val(type);  $("#matiere").val(matiere);  $("#prof").val(prof);
    $("#lieu").val(lieu);  $("#public").val(public);    $("#duree").val(duree);
    $("#uuid").val(uuid);
}

// Fonction qui lit les attributs d'un créneau à partir de son uuid
function attributsFromUUID(uuid) {
    return {
        "type": $("#"+uuid).attr("data-type"),
        "matiere": $("#"+uuid).attr("data-matiere"),
        "prof": $("#"+uuid).attr("data-prof"),
        "lieu": $("#"+uuid).attr("data-lieu"),
        "public": $("#"+uuid).attr("data-public"),
        "duree": $("#"+uuid).attr("data-duree"),
        "onglet": $("#"+uuid).attr("data-onglet")
    }
}

// Fonction qui fabrique un JSON à partir des infos d'un créneau (son uuid)
function fromAttrToJSON(numeroSemaine, nomOnglet, uuid) {
    return {
        week: numeroSemaine,
        tab: nomOnglet,
        uuid: uuid,
        data: attributsFromUUID(uuid)
    };
}

// Fonction activée après le 'drop' d'un créneau ; compatible corbeille/onglets
function dropCreneau(event, ui, idZoneDuDrop) {
    /* Si la zone d'arrivée est le prévisionnel, positionne la zone sur
       l'onglet actif et retrouve son nom pour la sauvegarde en BDD */
    if (idZoneDuDrop == "#previsionnel") {
        // Recherche le numéro de l'onglet actif (commence à 0)
        var numeroOnglet = $("#previsionnel").tabs("option", "active");
        idZoneDuDrop = "#previsionnel-" + numeroOnglet;
        // Recherche le nom de l'onglet actif
        var nomOnglet = $("#previsionnel a")[numeroOnglet].text;
    }
    else {
        var nomOnglet = "corbeille";
    }
    // Récupère l'identifiant du créneau déplacé
    var uuid = ui.draggable[0].id;
    // Le déplace dans la bonne zone (mais il est mal positionné, en vrac...)
    $("#"+uuid).appendTo(idZoneDuDrop);
    // Récupère les informations du créneau depuis son uuid
    let {type, matiere, prof, lieu, public, duree, onglet} = attributsFromUUID(uuid);
    // Mais 'onglet' est l'ancienne position du créneau ; doit être mis à jour
    onglet = nomOnglet
    // Enregistre le nom de l'onglet dans l'un des attributs du créneau
    $("#"+uuid).attr("data-onglet", onglet);
    // Construit le code du <div> qui sera injecté dans la zone d'arrivée
    ch = fabriqueCreneauHTML(uuid, type, matiere, prof, lieu, public, duree, onglet);
    // Supprime le créneau mal positionné de sa zone dans le DOM...
    $("#"+uuid).remove();
    // puis le réinjecte dans le DOM, mais cette fois il a une position correcte
    $(idZoneDuDrop).append(ch);
    // Rend cette élément du DOM à nouveau "draggable"
    $("#"+uuid).draggable({
        opacity: 0.5,
        revert: "invalid"        // retour à sa position si zone non dropable
    });
    // Lui donne la classe "corbeille" s'il se trouve dedans, sinon la retire
    if (idZoneDuDrop == "#corbeille") {
        $("#"+uuid).addClass('corbeille');
    }
    else {
        $("#"+uuid).removeClass('corbeille');
    }

    // Réenregistre ce créneau dans la BDD via un appel à une API julia (UPDATE)
    var numeroSemaine = $("#laSemaine").val();
    // Requête AJAX pour déplacer le créneau (onglet <--> corbeille)
    var url = "http://localhost:8000/moveCreneau?creneau="+uuid;
    url += "&zone=" + nomOnglet + "&numSemaine=" + numeroSemaine;
    $.ajax({url: url});
}



// Fonction qui fabrique un nouveau créneau à partir des infos du formulaire
function fabriqueCreneauFromFormulaire() {
    // Récupère les informations du créneau (vérifie si oubli...)
    let {type, matiere, prof, lieu, public, duree} = attributsFromFormulaire();
    if (type == "" || matiere == "" || prof == "" ||
        lieu == "" || public == ""  || duree == "") {
        alert("Il manque des informations !");
        return;
    }
    //vérifie que [ et ] ne sont pas contenue dans les champs, ce qui empecherait de lire le JSON
    if (type.includes("[") || type.includes("]") ||
    matiere.includes("[") || matiere.includes("]") ||
    prof.includes("[") || prof.includes("]") ||
    lieu.includes("[") || lieu.includes("]") ||
    public.includes("[") || public.includes("]") ||
    duree.includes("[") || duree.includes("]")){
		alert("Caractères interdits: '[' et ']'");
		return;
	}
	
    //Vérification pour voir si les heures sont bien découpées par périodes de 15 minutes et d'une durée max de 4h
    if (duree != "15" && duree != "30" && duree != "45" && duree != "60" && 
        duree != "75" && duree != "90" && duree != "105" && duree != "120" && 
        duree != "135" && duree != "150" && duree != "165" && duree != "180" && 
        duree != "195" && duree != "210" && duree != "225" && duree != "240" && 
        duree != "255" && duree != "270" && duree != "285" && duree != "300"){
        alert("La durée ne correspond pas, elle doit être découpée par période de 15 minutes (exemple: 15, 30, 45, 60...) pour une durée max de 5 heures(300 minutes).");
        return;
    }
    
    	try{
            verifClasseExiste(lieu).then(
            setTimeout(function () {
                if (ok == "true"){
                
                        matiere = matiere.charAt(0).toUpperCase() + matiere.slice(1).toLowerCase();
                        prof = prof.charAt(0).toUpperCase() + prof.slice(1).toLowerCase();
                        public = public.charAt(0).toUpperCase() + public.slice(1).toLowerCase();
                        creeCreneau(type.toUpperCase(), matiere, prof, lieu.toUpperCase(), public, duree);
                        return;
            }else{
                alert("Une ou plusieurs des salles inscrites n'existe(nt) pas." )
            }
            }, 1000)
        );
            
        }catch(e){
            alert(e);
        }

    	

	
			
	     
    }

    async function verifClasseExiste(lieu){
        const words = lieu.replace(/ /g,'').split(',');

        var i;
        ok=false;
        var temp;
        var url;
        for (i=0; i<words.length; i++){
            temp = words[i].toUpperCase();
            url = "http://localhost:8000/CheckSalles?nomSalles="+temp;
            $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
                if (data == "]") {
                    return;
                }
                obj = JSON.parse(data);
            }); 

                // Balaye tous les éléments du tableau
                setTimeout(function () {
                    for (var i = 0; i<obj.length; i++) {
                        ok = obj[i]["OkOuPasOk"];
                        
                    }
                    
                }, 500);

                
        }
        setTimeout(function () {
            return 1;
        }, 700);
    }

    //fonction qui permet d'afficher les onglets à partir du fichier .cfg | non fonctionnel
    function creerLesOnglets(){
    	var number=-1;
    	var url = "http://localhost:8000/recherchePere";
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
            	if (number >=0){
	                var grandPere = obj[i]["grandPere"];
	                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
	                ch = fabriqueUnOnglet(grandPere, number);
            	}
                number= number+1;
            }
        }); 
    }

    //fonction qui fabrique un des onglets de creerLesOngletq
    function fabriqueUnOnglet(grandPere, number){
    	if (number == 0){
	    	var select = document.getElementById("departements");
	        var el = document.createElement("li");
	        el.setAttribute("class", "ui-tabs-tab ui-corner-top ui-state-default ui-tab ui-tabs-active ui-state-active");
	        el.setAttribute("role","tab");
	        el.setAttribute("tabindex", number.toString());
	        el.setAttribute("aria-controls", "previsionnel-"+number.toString());
	        var number2 = number+1;
	        el.setAttribute("aria-labelledby", "ui-id-"+number2.toString());
	        el.setAttribute("aria-selected", "true");
	        el.setAttribute("aria-expanded", "true");
	        var a = document.createElement('a'); 
	        a.setAttribute("id","ui-id-"+number2.toString());
	        a.setAttribute("class","ui-tabs-anchor");
	        var link = document.createTextNode(grandPere);
	        a.appendChild(link); 
	        a.title = "#"+grandPere; 
	        a.href = "#previsionnel-"+number.toString(); 
	        a.setAttribute("tabindex", "-1");
	        el.appendChild(a);
	        select.appendChild(el);

	        var select2 = document.getElementById("previsionnel");
	        var el2 = document.createElement("div");
	        el2.setAttribute("id", "previsionnel-"+number.toString());
	        el2.setAttribute("class", "ui-tabs-panel ui-corner-bottom ui-widget-content");
	        el2.setAttribute("aria-labelledby", "ui-id-"+number2.toString());
	        el2.setAttribute("role", "tabpanel");
	        el2.setAttribute("aria-hidden", "false");
	        select2.appendChild(el2);	
		}else{
			var select = document.getElementById("departements");
	        var el = document.createElement("li");
	        el.setAttribute("class", "ui-tabs-tab ui-corner-top ui-state-default ui-tab");
	        el.setAttribute("role","tab");
	        el.setAttribute("tabindex", "-"+number.toString());
	        el.setAttribute("aria-controls", "previsionnel-"+number.toString());
	        var number2 = number+1;
	        el.setAttribute("aria-labelledby", "ui-id-"+number2.toString());
	        el.setAttribute("aria-selected", "false");
	        el.setAttribute("aria-expanded", "false");
	        var a = document.createElement('a'); 
	        a.setAttribute("id","ui-id-"+number2.toString());
	        a.setAttribute("class","ui-tabs-anchor");
	        var link = document.createTextNode(grandPere);
	        a.appendChild(link); 
	        a.title = "#"+grandPere; 
	        a.href = "#previsionnel-"+number.toString(); 
	        a.setAttribute("tabindex", "-1");
	        el.appendChild(a);
	        select.appendChild(el);

	        var select2 = document.getElementById("previsionnel");
	        var el2 = document.createElement("div");
	        el2.setAttribute("id", "previsionnel-"+number.toString());
	        el2.setAttribute("class", "ui-tabs-panel ui-corner-bottom ui-widget-content");
	        el2.setAttribute("aria-labelledby", "ui-id-"+number2.toString());
	        el2.setAttribute("role", "tabpanel");
	        el2.setAttribute("aria-hidden", "true");
	        el2.setAttribute("style", "display: none;");
	        select2.appendChild(el2);
		}	        
	}

/*
    function fabriqueOngletsDep(){
        var select = document.getElementById("departements");
        var el = document.createElement("li");
        var a = document.createElement('a'); 
        var link = document.createTextNode("GIM-1A-FI");
        a.appendChild(link); 
        a.title = "#GIM-1A-FI"; 
        a.href = "#previsionnel-0"; 
        el.appendChild(a);
        select.appendChild(el);

        var select2 = document.getElementById("previsionnel");
        var el2 = document.createElement("div");
        el2.setAttribute("id", "previsionnel-0");
        select2.appendChild(el2);
        
    }
*/

 //fonction qui remplit la liste des profs
    function afficherProf(){
        var url = "http://localhost:8000/selectProf";
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
                var nomProf = obj[i]["nomProf"];
                
                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
                ch = fabriqueListeProf(nomProf);
            }
        }); 
    }
    //insère chaque prof dans la liste
    function fabriqueListeProf(nomProf){
        var select = document.getElementById("prof");
        var optn = nomProf;
        var el = document.createElement("option");
        el.textContent = optn;
        el.value = optn;
        select.appendChild(el);
        
    }

    //fonction qui remplit la liste des salles
    function afficherSalles(){
        var url = "http://localhost:8000/selectSalles";
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
                var nomSalle = obj[i]["nomSalle"];
                
                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
                ch = fabriqueListeSalle(nomSalle);
            }
        }); 
    }
    //insère chaque salle dans la liste
    function fabriqueListeSalle(nomSalle){
        var select = document.getElementById("lieu");
        var optn = nomSalle;
        var el = document.createElement("option");
        el.textContent = optn;
        el.value = optn;
        select.appendChild(el);
        
    }

    
     //fonction qui remplit la liste des publics
    function afficherPublic(){
        var url = "http://localhost:8000/selectPublic";
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
                var groupes = obj[i]["groupes"];
                
                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel

                ch = fabriqueListePublic(groupes);
            }
        }); 
    }
    //insère chaque public dans la liste
    function fabriqueListePublic(groupes){
        var select = document.getElementById("public");
        var optn = groupes;
        var el = document.createElement("option");
        el.textContent = optn;
        el.value = optn;
        select.appendChild(el);
        
    }


/* Fonction qui crée un objet <div> associé au nouveau créneau. Le paramètre
   zone sert à savoir si la duplication s'est faite dans la corbeille ou pas */
function creeCreneau(type, matiere, prof, lieu, public, duree, zone="") {
    // Génère un UUID pour identifier ce nouveau créneau
    var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
        return v.toString(16);
    });
    // Vérifie si la création se fait dans le prévisionnel (quand zone == "")
    // Sinon zone devrait forcément être "#corbeille"
    if (zone == "") {
        // Recherche le numéro de l'onglet actif
        var numeroOnglet = $("#previsionnel").tabs("option", "active");
        zone = "#previsionnel-" + numeroOnglet;
        // Recherche le nom de l'onglet actif
        var nomOnglet = $("#previsionnel a")[numeroOnglet].text;
    }
    // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
    ch = fabriqueCreneauHTML(uuid, type, matiere, prof, lieu, public, duree, nomOnglet);
    // Ajoute le créneau au bon endroit (onglet ou corbeille)
    $(zone).append(ch);
    if (zone == "#corbeille") {        // il a été dupliqué depuis la corbeille
        $("#"+uuid).addClass("corbeille");   // il acquiert la classe corbeille
        var nomOnglet = "corbeille";         // et on retient son nom
    }
    // Rend ce nouvel élément du DOM "draggable"
    $("#"+uuid).draggable({ 
        opacity: 0.5,
        revert: "invalid"
    });
    // Enregistre le nom de l'onglet dans l'un des attributs du créneau
    $("#"+uuid).attr("data-onglet", nomOnglet);
    // Sauvegarde ce créneau dans la BDD via un appel à une API julia
    numeroSemaine = $("#laSemaine").val();
    jsonObj = fromAttrToJSON(numeroSemaine, nomOnglet, uuid);
    // Requête AJAX pour envoyer le créneau à sauvegarder
    var url = "http://localhost:8000/insertCreneau?creneau=";
    url += JSON.stringify(jsonObj);
    $.ajax({url: url}).done(function() {
        // TODO: réactiver le bouton Créer (ou sa callback)
    });
}

/* -------------------------------------------------------------
-- Fonction appelée quand la page web est entièrement chargée --
--------------------------------------------------------------*/
$(document).ready(function() {
    // Désactive tous les éléments du formulaire par défaut et le bouton '+'
    
	ok = false;
    $("#formulaire").children().hide();
    afficherProf();
    afficherSalles();
    afficherPublic();
    
    //creerLesOnglets();
    // Permet de mettre en oeuvre le système d'onglets de jquery-ui
    $( "#previsionnel" ).tabs();

    // Rend la corbeille "droppable"
    $("#corbeille").droppable({
        accept: ".creneau",         // la corbeille n'accepte que des créneaux
        drop: function(event, ui) {
            dropCreneau(event, ui, "#corbeille");
        }
    });
    // Rend le système de tabs "droppable" (tous les onglets seront impactés)
    $("#previsionnel").droppable({
        accept: ".corbeille",         // que ceux venant de la corbeille
        drop: function(event, ui) {
            dropCreneau(event, ui, "#previsionnel");
        } 
    });
    remplirCreneaux();
	if ($("#laSemaine").val()>0 && $("#laSemaine").val()<53){
    		$('#btAjoutCreneau').show(); 
    }else{
    		$('#btAjoutCreneau').hide();
    }
    // Action après saisie/changement de numéro de semaine
    $("#laSemaine").on("change", function() {
    	remplirCreneaux();
    	if ($("#laSemaine").val()>0 && $("#laSemaine").val()<53){
    		$('#btAjoutCreneau').show(); 
    	}else{
    		$('#btAjoutCreneau').hide();
    	}
    });


   

    function remplirCreneaux(){
        // Efface tous les éléments du DOM qui ont la classe 'creneau'
        $(".creneau").each(function () {
            var obj = $(this)[0];
            obj.remove();
        });
        $('#btAjoutCreneau').hide();         // cache le bouton '+'
        var numeroSemaine = $("#laSemaine").val();
        // Requête AJAX pour charger les créneaux de la semaine choisie
        var url = "http://localhost:8000/selectCreneaux?semaine="+numeroSemaine;
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
                var uuid = obj[i]["uuid"];
                var typeDeCours = obj[i]["typeDeCours"];
                var nomModule = obj[i]["nomModule"];
                var prof = obj[i]["prof"];
                var salles = obj[i]["salles"];
                var groupe = obj[i]["groupe"];
                var dureeEnMin = obj[i]["dureeEnMin"];
                var tab = obj[i]["tab"];
                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
                ch = fabriqueCreneauHTML(uuid, typeDeCours, nomModule, prof,
                                        salles, groupe, dureeEnMin, tab);
                // Détermine dans quelle zone il va falloir insérer le créneau
                if (tab == "corbeille") {
                    var zone = "#corbeille";
                }
                else {
                    // En fonction de la valeur de 'tab' il faudra déterminer
                    // dans quel onglet le créneau doit se placer.
                    for (var t=0; t<$('#previsionnel ul li').length; t++) {
                        if (tab == $("#previsionnel a")[t].text) {
                            var zone = "#previsionnel-" + t;
                        }
                    }
                }
                // Ajoute le créneau au bon endroit (onglet ou corbeille)
                $(zone).append(ch);
                if (zone == "#corbeille") {       // il appartenait à la corbeille
                    $("#"+uuid).addClass("corbeille");    // il acquiert sa classe
                }
                else {
                    $("#"+uuid).removeClass("corbeille"); // sinon la retire
                }
                // Rend ce nouvel élément du DOM "draggable"
                $("#"+uuid).draggable({
                    opacity: 0.5,
                    revert: "invalid"
                });
            }
            /* En plaçant cette ligne ici le bouton '+' ne sera montré que
               lorsque la requête AJAX (qui est asynchrone) sera terminée. */
            $('#btAjoutCreneau').show();         // montre le bouton '+'
        });
    }

//lance le moteur recuit simule quand on appuit sur le bouton correspondant
$("#lancerMot").on("click", function(){
	numSemaine = $("#laSemaine").val();
	var result = prompt("Nombre de tour(s) souhaité(s) (max: 10):");
	try{
		if (parseInt(result) <= 10 && parseInt(result) > 0){
			var url2 ="http://localhost:8000/lancerMoteur?numSemaine="+numSemaine+"&nbEDTCalcules="+result;
			$.ajax({url: url2});
		}else{
			alert("la valeur doit être contenue entre 1 et 10.");
		}
	}catch(e){
		alert("Il ne faut qu'un nombre! Pas d'autres caractères!");
	}
});

//permet de supprimer un prof quand on appuit sur le bouton correspondant
$("#supProf").on("click", function(){
	var myWindow = window.open("popup.html", "", "width=600,height=500,top=200,left=360");
	
});

//permet de creer le cvs prévisionnel quand on appuit sur le bouton correspondant
$("#makeCSV").on("click", function() {
		numSemaine = $("#laSemaine").val().toString();
		var url2 = "http://localhost:8000/createanddeleteCsv?numSemaine="+numSemaine; 
		var id;
		var url;
		$.ajax({url: url2});
		var corb= 0;
		var url3;
        var url = "http://localhost:8000/selectCreneaux?semaine="+numSemaine;
        $.getJSON( url, function( data ) {
            // Récupère l'objet JSON (en fait un tableau de JSON)
            // Mais s'il est vide la chaîne retournée est ']' ; donc quitter !
            if (data == "]") {
                return;
            }
            obj = JSON.parse(data);
            // Balaye tous les éléments du tableau
            for (var i = 0; i<obj.length; i++) {
                var uuid = obj[i]["uuid"];
                var typeDeCours = obj[i]["typeDeCours"];
                var nomModule = obj[i]["nomModule"];
                var prof = obj[i]["prof"];
                var salles = obj[i]["salles"];
                var groupe = obj[i]["groupe"];
                var dureeEnMin = obj[i]["dureeEnMin"];
                var tab = obj[i]["tab"];
                // Construit le code du <div> qui sera injecté dans la zone du prévisionnel
                ch = fabriqueCreneauHTML(uuid, typeDeCours, nomModule, prof,
                                        salles, groupe, dureeEnMin, tab);
                url3 = url = "http://localhost:8000/createCsv?numSemaine="+numSemaine+"&matiere="+nomModule+"&typeCr="+typeDeCours+"&duree="+dureeEnMin.toString()+"&professeur="+prof+"&salleDeCours="+salles+"&public="+groupe.toUpperCase()
                $.ajax({url: url3});               
                
			}
		});
		alert("Création CSV prévisionnel finie!");
	});


	//permet d'ajouter un professeur quand on appuit sur le bouton correspondant
	$("#addProf").on("click", function() {
        var result = prompt("Nom de famille du nouveau Professeur:");
        if(result.trim() != ""){
            var nom = result.charAt(0).toUpperCase() + result.slice(1).toLowerCase();  
            nom = nom.replace(" ", '-');
            var url = "http://localhost:8000/ajoutProf?nomProf="+ nom;
        $.ajax({url: url});
        alert("La personne a été ajouté");
        location.reload();
        }else{
            alert("La zone ne doit pas être vide.");
            return;
        }
    });

    $("#addSalle").on("click", function() {
        var result = prompt("Nom de la nouvelle salle:");
        if(result.trim() != ""){
            var nom = result.toUpperCase();  
            nom = nom.replace(" ", '-');
            var url = "http://localhost:8000/ajoutSalle?nomSalle="+ nom;
        $.ajax({url: url});
        alert("La salle a été ajouté");
        location.reload();
        }else{
            alert("La zone ne doit pas être vide.");
            return;
        }
    });


$("#supSalle").on("click", function(){
	var myWindow = window.open("popup2.html", "", "width=600,height=500,top=200,left=360");
	
});
	
    // Action après clic sur bouton "+"
    $('#btAjoutCreneau').on('click', function(e) {
        // Vérifie qu'il y a bien un numéro de semaine entre 1 et 52 sinon sort
        var numSemaine = parseInt($("#laSemaine").val());
        if (isNaN(numSemaine) || numSemaine < 1 || numSemaine > 52) {
            alert("Saisissez un numéro de semaine entre 1 et 52 !");
            return;
        }
        $("#formulaire").children().show();  // montre le formulaire mais...
        $('#btAjoutCreneau').hide();         // cache le bouton '+'
        $('#btModifier').hide();             // cache le bouton 'Modifier'
    });

    // Action après clic sur bouton "Annuler"
    $('#btAnnuler').on('click', function(e) {
        $("#formulaire").children().hide();
        $('#btAjoutCreneau').show();;        // montre le bouton '+'
    });

    // Action après clic sur bouton "Créer"
    $('#btCreer').on('click', function(e) {
        fabriqueCreneauFromFormulaire();
        $('#btModifier').hide();             // désactive le bouton Modifier
    });

    // Action après clic sur bouton "Modifier"
    $('#btModifier').on('click', function(e) {
        // Récupère les nouvelles informations du créneau (vérifie si oubli...)
        let {type, matiere, prof, lieu, public, duree} = attributsFromFormulaire();
        var uuid    = $("#uuid").val();         // trim inutile car champ caché
        if (type == "" || matiere == "" || prof == "" ||
            lieu == "" || public == ""  || duree == "") {
            alert("Il manque des informations !")
            return;
        }
         //vérifie que [ et ] ne sont pas contenue dans les champs, ce qui empecherait de lire le JSON
	    if (type.includes("[") || type.includes("]") ||
		    matiere.includes("[") || matiere.includes("]") ||
		    prof.includes("[") || prof.includes("]") ||
		    lieu.includes("[") || lieu.includes("]") ||
		    public.includes("[") || public.includes("]") ||
		    duree.includes("[") || duree.includes("]")){
				alert("Caractères interdits: '[' et ']'");
				return;
		}
		
        //Vérification pour voir si les heures sont bien découpées par périodes de 15 minutes et d'une durée max de 4h
    if (duree != "15" && duree != "30" && duree != "45" && duree != "60" && 
        duree != "75" && duree != "90" && duree != "105" && duree != "120" && 
        duree != "135" && duree != "150" && duree != "165" && duree != "180" && 
        duree != "195" && duree != "210" && duree != "225" && duree != "240" && 
        duree != "255" && duree != "270" && duree != "285" && duree != "300"){
        alert("La durée ne correspond pas, elle doit être découpée par période de 15 minutes (exemple: 15, 30, 45, 60...) pour une durée max de 5 heures(300 minutes).");
        return;
    }
    
    try{
            verifClasseExiste(lieu).then(
            setTimeout(function () {
                if (ok == "true"){
                
                        matiere = matiere.charAt(0).toUpperCase() + matiere.slice(1).toLowerCase();
                        prof = prof.charAt(0).toUpperCase() + prof.slice(1).toLowerCase();
                        type = type.toUpperCase();
                        lieu = lieu.toUpperCase();
                        // Fabrique le texte "html" du créneau puis l'affiche (donc sans <div>)
                        ch = "<b>" + type + "&nbsp;" + matiere + "</b><br>";
                        ch += prof + "<br>" + lieu + "<br>";
                        ch += public + "<br>" + duree;
                        $("#"+uuid).html(ch);
                        // Change tous ses attributs pour qu'ils correspondent aux données
                        // sauf le nom de l'onglet qui restera le même.
                        $("#"+uuid).attr("data-type", type);
                        $("#"+uuid).attr("data-matiere", matiere);
                        $("#"+uuid).attr("data-prof", prof);
                        $("#"+uuid).attr("data-lieu", lieu);
                        $("#"+uuid).attr("data-public", public);
                        $("#"+uuid).attr("data-duree", duree);
                        // Efface le contenu des champs du formulaire
                        remplitFormulaire("", "", "", "", "", "", "");
                        // Désactive le bouton Modifier et remet le bouton Créer
                        $('#btModifier').hide();
                        $('#btCreer').show();
                        // Ré-enregistre ce créneau via un appel à une API julia (UPDATE)
                        var numeroSemaine = $("#laSemaine").val();
                        // La MAJ gardera l'onglet/corbeille inchangé
                        var nomOnglet = $("#"+uuid).attr("data-onglet");
                        var jsonObj = fromAttrToJSON(numeroSemaine, nomOnglet, uuid);
                        // Requête AJAX pour modifier le créneau
                        var url = "http://localhost:8000/updateCreneau?creneau=";
                        url += JSON.stringify(jsonObj);
                        $.ajax({url: url});
            }else{
                alert("Une ou plusieurs des salles inscrites n'existe(nt) pas. " )
            }
            }, 1000)
        );
            
        }catch(e){
            alert(e);
        }
    //S'il ne s'agit pas du mot info, alors on ne transforme que la première lettre en majuscule.
    
    });

    /*----------------------------------------
    -- Actions si clic droit sur un créneau --
    ----------------------------------------*/
    // Trouvé sur le site :
    // https://makitweb.com/custom-right-click-context-menu-with-jquery/
    // Show custom context menu
    $('#previsionnel, #corbeille').on('contextmenu', function (e) {
        // Retrouve l'uuid du créneau ayant reçu le clic droit et le place
        // dans le champ caché du formulaire (pour le rendre accessible)
        // ATTENTION : si on clique dans le titre en gras l'id est VIDE !!!
        // Dans ce cas il faudra prendre l'id du parent
        var idTrouve = e.target.id;
        if (idTrouve == "") {
            idTrouve = e.target.parentElement.id;
        }
        $("#uuid").val(idTrouve);        // remplit le champ caché
        
        // Affiche le menu contextuel (voir code html pour la liste des <li>)
        $(".context-menu").toggle(100).css({
            top: e.pageY + 5 + "px",
            left: e.pageX + "px"
        });
        // Disable default context menu (OBLIGATOIRE !)
        return false;
    });

    // Cache le context menu après un clic en dehors (sinon reste à l'écran...)
    $(document).on('contextmenu click', function() {
        $(".context-menu").hide();
    });

    // Disable context-menu from custom menu
    $('.context-menu').on('contextmenu', function() {
        return false;
    });

    /*-----------------------------------------------------------------
    -- Traite l'action du sous-menu après clic droit dans un créneau --
    -----------------------------------------------------------------*/
    $('.context-menu li').click(function(e) {
        // Retrouve l'uuid du créneau cliqué
        var uuid = $("#uuid").val();
        // Cache le menu contextuel
        $(".context-menu").hide();
        // Récupère le nom de l'action choisie dans le menu contextuel
        var action = $(this).find("span:nth-child(1)").attr("id");
        
        // Demande de suppression du créneau (du DOM en fait)
        if (action == "actionSupprimer") {
            $("#"+uuid).remove();
            // Requête AJAX pour supprimer le créneau de la BDD
            $.ajax({url: "http://localhost:8000/deleteCreneau?creneau="+uuid});
        }
        
        // Demande de copie du créneau (il apparaîtra juste à côté).
        // Ce nouveau créneau aura forcément un nouvel uuid
        if (action == "actionDupliquer") {
            let {type, matiere, prof, lieu, public, duree} = attributsFromUUID($("#uuid").val());
            // Regarde si le 'parent' de l'objet est la corbeille
            var zone = "";              // valeur par défaut, donc onglet actif
            if ($("#"+uuid).parent().attr("id") == "corbeille") {
                zone = "#corbeille";
            }
            creeCreneau(type, matiere, prof, lieu, public, duree, zone);
        }
        // Demande de modification du créneau (via le formulaire).
        if (action == "actionModifier") {
            // Récupère les données du créneau cliqué            
            let {type, matiere, prof, lieu, public, duree} = attributsFromUUID(uuid);
            // (Ré)affiche tous les éléments du formulaire
            $("#formulaire").children().show();
            // Remplit le formulaire avec les données du créneau cliqué
            remplitFormulaire(type, matiere, prof, lieu, public, duree, uuid);
        }        
    });
});
