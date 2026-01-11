--liquibase formatted sql

--changeset yourname:003-insert-ville-data
--labels: v1.1.0
--context: all
--comment: Insert initial data into VILLE table
INSERT INTO VILLE (nom) VALUES ('Paris');
INSERT INTO VILLE (nom) VALUES ('Lyon');
INSERT INTO VILLE (nom) VALUES ('Marseille');
INSERT INTO VILLE (nom) VALUES ('Toulouse');

--rollback DELETE FROM VILLE WHERE nom IN ('Paris', 'Lyon', 'Marseille', 'Toulouse');