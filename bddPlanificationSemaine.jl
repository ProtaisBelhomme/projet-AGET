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
   # Crée la table (TODO: devrait être vidée chaque année !)
   SQLite.execute(db, reqCreation)
end

function creeFichierEtTablePROF()
#= Fonction qui devrait être appelée une seule fois, pour créer la BDD
   contenant tous les profs.  =#
   reqCreation = """CREATE TABLE IF NOT EXISTS professeurs (
       uuid VARCHAR(36) PRIMARY KEY NOT NULL,
       nomProf VARCHAR(30)
   )"""
   # Ouvre la base de données (mais si le fichier n'existe pas il est créé)
   db = SQLite.DB(NOM_DATABASE_EDT)
   # Crée la table (TODO: devrait être vidée chaque année !)
   SQLite.execute(db, reqCreation)
end

function inserePROF(id, nom)
    req = """ INSERT INTO professeurs VALUES("$id", "$nom") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

function getprofidmax()
  req = """ SELECT max(uuid) from professeurs """
  rep = DataFrame(DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req))
  return rep
end

function createCSVcreneau(numSemaine, matiere, typeCr, duree, professeur, salleDeCours, public)
  nom = "s"*string(numSemaine)*".csv"
  df = DataFrame(semaine = [numSemaine], JourduCours = "",  matiere = [matiere], typeCr = [typeCr], numApogee = "numApogee", heure = "", duree = [duree], professeur = [professeur], salleDeCours = [salleDeCours], public = [public])
  CSV.write("creneau\\"*nom, df, header = false, append = true, delim=';')
end

function deleteandcreateCSVcreneau(numSemaine)
  nom = "s"*string(numSemaine)*".csv"
  rm("creneau\\"*nom)
  touch("creneau\\"*nom)
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

function insererProf(nomProf)
    r = getprofidmax()
    r = chop(string(r[:, "max(uuid)"]), head = 2, tail = 2)
    r = string(r)
    r = Base.parse(Int, r)
    r = r + 1
    req = """ INSERT INTO professeurs VALUES("$r", "$nomProf") """
    DBInterface.execute(SQLite.DB(NOM_DATABASE_EDT), req)
end

#= Fonction qui affiche les données de la table prof =#
function selectDonneesprof()
    r = """ select * from professeurs """
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