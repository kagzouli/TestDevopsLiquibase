-- liquibase formatted sql

-- changeset exakaconsulting:004-add-ville-id-column
ALTER TABLE PERSONNE
ADD COLUMN ville_id INTEGER;

-- rollback ALTER TABLE PERSONNE DROP COLUMN ville_id;


-- changeset exakaconsulting:004-add-fk-personne-ville
ALTER TABLE PERSONNE
ADD CONSTRAINT fk_personne_ville
FOREIGN KEY (ville_id)
REFERENCES VILLE(id);

-- rollback ALTER TABLE PERSONNE DROP CONSTRAINT fk_personne_ville;
