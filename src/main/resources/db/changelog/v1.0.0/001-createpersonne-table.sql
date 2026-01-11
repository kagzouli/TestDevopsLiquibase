--changeset yourname:001-create-personne-table
--labels: v1.0.0
--context: all
CREATE TABLE PERSONNE (
    id INT AUTO_INCREMENT,
    nom VARCHAR(64),
    prenom VARCHAR(64),
    PRIMARY KEY (id)
);

INSERT INTO PERSONNE VALUES ('Nom1', 'Prenom1');
INSERT INTO PERSONNE VALUES ('Nom2', 'Prenom2');
INSERT INTO PERSONNE VALUES ('Nom3', 'Prenom3');
INSERT INTO PERSONNE VALUES ('Nom4', 'Prenom4');

--rollback DROP TABLE PERSONNE;