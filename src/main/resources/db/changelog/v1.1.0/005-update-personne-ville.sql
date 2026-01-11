-- liquibase formatted sql

-- changeset exakaconsulting:005-update-personne-ville

UPDATE personne p
JOIN ville v ON v.nom = 'Paris'
SET p.ville_id = v.id
WHERE p.nom = 'Nom1';


UPDATE personne p
JOIN ville v ON v.nom = 'Toulouse'
SET p.ville_id = v.id
WHERE p.nom = 'Nom2';


UPDATE personne p
JOIN ville v ON v.nom = 'Paris'
SET p.ville_id = v.id
WHERE p.nom = 'Nom3';


UPDATE personne p
JOIN ville v ON v.nom = 'Lyon'
SET p.ville_id = v.id
WHERE p.nom = 'Nom4';

-- rollback UPDATE personne SET ville_id = NULL;
