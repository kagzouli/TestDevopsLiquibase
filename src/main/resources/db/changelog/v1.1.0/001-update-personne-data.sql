--liquibase formatted sql

--changeset yourname:001-update-personne-data
--labels: v1.1.0
--context: all
--comment: Update PERSONNE table

UPDATE PERSONNE  SET prenom = 'NewPrenom4'  WHERE nom = 'Nom4';

--rollback UPDATE PERSONNE  SET prenom = 'Prenom4'  WHERE nom = 'Nom4';