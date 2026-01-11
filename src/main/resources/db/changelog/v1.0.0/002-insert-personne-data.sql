--liquibase formatted sql

--changeset yourname:002-insert-personne-data
--labels: v1.0.0
--context: all
--comment: Insert initial data into PERSONNE table
INSERT INTO PERSONNE (nom, prenom) VALUES ('Nom1', 'Prenom1');
INSERT INTO PERSONNE (nom, prenom) VALUES ('Nom2', 'Prenom2');
INSERT INTO PERSONNE (nom, prenom) VALUES ('Nom3', 'Prenom3');
INSERT INTO PERSONNE (nom, prenom) VALUES ('Nom4', 'Prenom4');

--rollback DELETE FROM PERSONNE WHERE nom IN ('Nom1', 'Nom2', 'Nom3', 'Nom4');