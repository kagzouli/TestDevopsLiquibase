--liquibase formatted sql

--changeset yourname:002-create-ville-table
--labels: v1.1.0
--context: all
--comment: Create TABLE VILLE to store VILLE information
CREATE TABLE VILLE (
    id INT AUTO_INCREMENT,
    nom VARCHAR(128),
    PRIMARY KEY (id)
);

--rollback DROP TABLE IF EXISTS VILLE;