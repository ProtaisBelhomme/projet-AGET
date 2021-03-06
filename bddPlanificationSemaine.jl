# Projet : AUTOMATIC-EDT
# Auteur : Philippe Belhomme
# Date Création : mercredi 09 février 2022
# Date Modification : mardi 15 février 2022
# Langage : Julia

# Module : bddPlanificationSemaine
# Gestion de la BDD qui enregistre les créneaux prévus à l'emploi du temps.
# Les créneaux font partie d'une promo ou bien sont dans une corbeille.

include("CONSTANTES.jl")        # pour importer les constantes du système
using SQLite
using CSV
using DataFrames

# Variables globales/CONSTANTES
NOM_DATABASE_EDT = "bddAutomaticEDT.sql"

#Réinitialise toutes les données, vidant la base de toutes informations
function viderToutesInfos()
  creeFichierEtTableBDD()
  rm("PLANNINGS", recursive=true)
  mkdir("PLANNINGS")
  rm("PLANNINGS_CALCULES", recursive=true)
  mkdir("PLANNINGS_CALCULES")
end

#créer la table previsionnelEDT si elle n'existe pas
function creeFichierEtTableBDD()
#= Fonction qui devrait être appelée une seule fois, pour créer la BDD
   contenant tous les créneaux inscrits dans le prévisionnel. Certains seront
   associés à une promo (ex : GIM-1A-FI) alors que d'autres seront dans la
   "corbeille" =#
   reqCreation = """CREATE TABLE IF NOT EXISTS previsionnelEDT (
       uuid VARCHAR(36) PRIMARY KEY NOT NULL,
       numSemaine INTEGER,
       tab VARCHAR(15),
       typeDeCours VARCHAR(20),
       nomModule VARCHAR(20),
       prof VARCHAR(20),
       salles VARCHAR(40),
       groupe VARCHAR(20),
       dureeEnMin INTEGER,
       nomDuJour VARCHAR(20) DEFAULT "",
       horaire VARCHAR(20) DEFAULT "",
       salleRetenue VARCHAR(20) DEFAULT ""
   )"""
   # Ouvre la base de données (mais si le fichier n'existe pas il est créé)
   db = SQLite.DB(NOM_DATABASE_EDT)
   reqsup = """DROP TABLE IF EXISTS previsionnelEDT"""
   SQLite.execute(db, reqsup)
   # Crée la table (TODO: devrait être vidée chaque année !)
   SQLite.execute(db, reqCreation)
end

#Supprime un prof de la table depuis la page de planning semaine(popup)
function supprimerProf(nomProf)
    req = """ DELETE FROM professeurs where nomProf = "$nomProf" """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#supprime une salle de la table depuis la page de planning semaine(popup2)
function supprimerSalle(nomSalle)
    req = """ DELETE FROM salles where nomSalle = "$nomSalle" """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#supprime et recréé la table des professeurs
function creeFichierEtTablePROF()
#= Fonction qui devrait être appelée une seule fois, pour créer la BDD
   contenant tous les profs.  =#
   db = SQLite.DB(NOM_DATABASE_EDT)
   reqsup = """DROP TABLE IF EXISTS professeurs"""
   SQLite.execute(db, reqsup)
   reqCreation = """CREATE TABLE IF NOT EXISTS professeurs (
       nomProf VARCHAR(30) PRIMARY KEY NOT NULL
   )"""
   # Ouvre la base de données (mais si le fichier n'existe pas il est créé)
   SQLite.execute(db, reqCreation)
end

#supprime et recréé la table des salles
function creeFichierEtTableSalles()
#= Fonction qui devrait être appelée une seule fois, pour créer la BDD
   contenant toutes les salles.  =#
   db = SQLite.DB(NOM_DATABASE_EDT)
   reqsup = """DROP TABLE IF EXISTS salles"""
   SQLite.execute(db, reqsup)
   reqCreation = """CREATE TABLE IF NOT EXISTS salles (
       nomSalle VARCHAR(30) PRIMARY KEY NOT NULL
   )"""
   # Ouvre la base de données (mais si le fichier n'existe pas il est créé)
   SQLite.execute(db, reqCreation)
end

# insere un prof dans la base
function inserePROF(id, nom)
    req = """ INSERT INTO professeurs VALUES("$id", "$nom") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end


# remplit le csv previsionnel
function createCSVcreneau(numSemaine, matiere, typeCr, duree, professeur, salleDeCours, public)
  nom = "s"*string(numSemaine)*".csv"
  df = DataFrame(semaine = [numSemaine], JourduCours = "",  matiere = [matiere], typeCr = [typeCr],
  numApogee = "numApogee", heure = "", duree = [duree], professeur = [professeur], salleDeCours = [salleDeCours], public = [public])
  CSV.write("PLANNINGS\\"*nom, df, header = false, append = true, delim=';')
end

# creer le csv previsionnel et supprime l'ancien s'il existe
function deleteandcreateCSVcreneau(numSemaine)
  nom = "s"*string(numSemaine)*".csv"
  try
  rm("PLANNINGS\\"*nom)
  catch e
  print(e)
  end
  touch("PLANNINGS\\"*nom)
end

#= Fonction qui insère un créneau dans la base de données =#
function insereCreneauBDD(id, ns, tab, type, nm, pr, s, gr, duree, ndj="", h="", sR="")
    req = """ INSERT INTO previsionnelEDT VALUES("$id", $ns, "$tab", "$type",
          "$nm", "$pr", "$s", "$gr", $duree, "$ndj", "$h", "$sR") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#= Fonction qui supprime un créneau de la base de données =#
function supprimeCreneauBDD(id)
    req = """ DELETE FROM previsionnelEDT where uuid = "$id" """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#= Fonction qui met à jour un créneau dans la base de données =#
function updateCreneauBDD(id, ns, tab, type, nm, pr, s, gr, duree, ndj="", h="", sR="")
    req = """ UPDATE previsionnelEDT SET numSemaine=$ns, tab="$tab",
                     typeDeCours="$type", nomModule="$nm", prof="$pr",
                     salles="$s", groupe="$gr", dureeEnMin=$duree,
                     nomDuJour="$ndj", horaire="$h", salleRetenue="$sR"
              WHERE uuid="$id" """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#= Fonction qui déplace un créneau (son 'tab' change) dans la base de données =#
function moveCreneauBDD(id, tab, numSemaine)
    req = """ UPDATE previsionnelEDT SET tab="$tab", numSemaine=$numSemaine
              WHERE uuid="$id" """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#= Fonction qui lit tous les créneaux d'une semaine précisée plus tous les
   créneaux de la corbeille dans la base de données =#
function selectCreneauxBDD(numSemaine)
    r = """ select * from previsionnelEDT
            WHERE (numSemaine="$numSemaine" or tab="corbeille") """
    df = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), r))
    return df
end 

#= Fonction qui affiche les données de la table =#
function afficheDonnees()
    r = """ select * from previsionnelEDT """
    df = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), r))
    println(df)
end

# insere un prof depuis la page de semaine
function insererProf(nomProf)
    req = """ INSERT INTO professeurs VALUES("$nomProf") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
    creeFichierDatPourProfOuSalle(nomProf, "Création du prof : ")
end

#vérifie l'existence d'UNE salle
function checkExistanceSalles(nomSalles)
      print(nomSalles*"\n")
      r = """ select nomSalle from salles """
      df = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), r))
      df.str_sub_number = string.(df.nomSalle)
      print(df.str_sub_number)
      print("\n")
        if (nomSalles in df.str_sub_number)
             print("ok!")
             df2 = DataFrame(OkOuPasOk=true)
             return df2
        end
      print("pas ok!")
      df2 = DataFrame(OkOuPasOk=false)
      return df2
      
end

#Insere une salle dans la base depuis page planning semaine
function insererSalle(nomSalle)
    req = """ INSERT INTO salles VALUES("$nomSalle") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
    creeFichierDatPourProfOuSalle(nomSalle, "Création de la Salle : ")
end

# insere un prof depuis le moteur
function insererProfdepuisMoteur(nomProf)
    req = """ INSERT INTO professeurs VALUES("$nomProf") """
    try
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req) 
    catch
      print("Ce professeur existe déjà!")
    end
end

#= Fonction qui récupère les données de la table prof =#
function selectDonneesprof()
    r = """ select * from professeurs ORDER BY nomProf"""
    df = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), r))
    return df
end

#Fonction qui récupère les données de la table des salles
function selectDonneesSalles()
    r = """ select * from salles ORDER BY nomSalle"""
    df = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), r))
    return df
end

### PROGRAMME PRINCIPAL
# ----> Création de la table au départ après avoir effacé le fichier
# (puis commenter les deux lignes suivantes) 
#creeFichierEtTableBDD()
#afficheDonnees()
#creeFichierEtTablePROF()
#inserePROF("1","Belhomme") 
#inserePROF("2","Lanchon")
#inserePROF("3","Lepesteur")
#inserePROF("4","Libine")
#inserePROF("5","Roubaud")
#inserePROF("6","Samyn")
#= insereCreneauBDD("dhhkhgh655865FDFDG", 38, "GIM-1A-FI", "CM", "Maths",
                 "lanchon", "B1,B6,AmphiC", "promo1", 90)
insereCreneauBDD("fhggfh555HGFGFG344", 38, "corbeille", "TP", "INFO1",
                 "belhomme", "C3,C4,B2", "TP11", 180)
afficheDonnees()
supprimeCreneauBDD("fhggfh555HGFGFG344")
afficheDonnees()
updateCreneauBDD("dhhkhgh655865FDFDG", 38, "GIM-2A-FI", "CM", "MATH2",
                 "pignoux", "B1", "promo2", 60)
afficheDonnees() =#
#creeFichierEtTablePROF()
#creeFichierEtTableSalles()
#checkExistanceSalles("C2")




#POUR VIDER BASE ET DONNEES INTERNE!!!!!
#NE SURTOUT PAS LANCER LE SERVEUR SI LA LIGNE CI-DESSOUS N'EST PAS EN COMMENTAIRE!!!!!
#viderToutesInfos()