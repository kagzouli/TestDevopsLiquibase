--liquibase formatted sql

--changeset yourname:001-create-personne-table
--labels: v1.0.0
--context: all
--comment: Create PERSONNE table to store person information
CREATE TABLE PERSONNE (
    id INT AUTO_INCREMENT,
    nom VARCHAR(64),
    prenom VARCHAR(64),
    PRIMARY KEY (id)
);

--rollback DROP TABLE IF EXISTS PERSONNE;