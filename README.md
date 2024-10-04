# CesamSeedEurogermSSRS
Git contenant les rapports SSRS pour Eurogerm

Formule (requete / RndSuite.RndtRq)
Formule - DEC (RndtRqrq) 
Table matière (RndSuite.RndtFmMat)
Table layout (RndSuite.RndtFr)


On declenche le rapport à partir d'une formule
- formule (requête)
  - Spec client (lié à la formule)
 - requete DEC 
  - Spec client (lié au DEC qui est contenu dans la formule)



chaque requete a la meme logique qu'une spec (infocard, infofield) hormis les données des matières situées dans la table FmMat.

Une requête n'a pas de version


Reste à faire 

- Problèmes lié au changement de langue (shortdesc/header_desc qui se modifient, valeur numerique du dosage )
- Remplir champ commentaire qualité (requête disponible)
- Remplir champ pays de commercialisation
- Rajouter les () dans le dosage
- Consolider les conditions d'affichage, avoir le + de shortdesc possible par exemple, trouver une solution pour les ppsg
- Dluo rajouter la condition pour prendre la plus petite valeur
- Optimiser l'affichage (suppression des espaces vides avec condition de visibilité)
- Erreur "out of range" lors de l'ouverture de certaines formules (FM20240604-12)


Rappel : n'oublie pas que ce sont principalement les tables qui sont visées dans ce repertoire, 
il faut remplacer les rndt par les rndv dans le rapport. 



champ Commentaire qualité(tu peux reprendre le fichier commentaire_qualité.sql ) :

-- on recupere la premiere ligne dans les matiere table FmMat(voir colonne level et order dans la table )

-- je regarde si la premiere ligne (materialvalue) est présent dans les specs PMSF (consulter la table rndtfr qui precise le type de spec)

-- Récuperer dans l'infocard  ERP - Information générale le PPSG avec un les clients

-- Recupere le commentaire qualité en lien avec le client lié à la formule.

(probleme :  le client n'est pas sur la meme ligne que le commentaire qualité)

Url d'affichage
https://rdnlopcenter.eurogerm.com/ReportServer/Pages/ReportViewer.aspx?%2fReports%2fCustom%2fFormulationReport&p_ServerName=RDNLOPCENTER\&p_CatalogName=OpcenterRDnL&p_RQ=FM20240416-2&rs:Command=Render&p_TimeZoneId=Romance%20Standard%20Time



formules fonctionnelles : 

-- FM20240528-2 test pour les calculs
--FM20240402-11
--'FM20240523-5' 

--FM20240603-3 client_form
--FM20240528-6 client_dec