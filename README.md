# Liquibase Demo 

This project is used to show the power of Liquibase to manage Devops change in SQL database

# Application version


 | Version  |  Description |
| ------------ | ------------ |
| v1.0.0 |The version v1.0.0 only creates a table PERSONNE with 2 columns nom and prenom and populates this table  |
| v1.1.0 | The version 1.1.0 creates a TABLE ville and add the town (VILLE) where the person (Table PERSONNE) lives.|   

#  liquibase command

This is the command use by liquibase to manage his changeset :

 | Command  |  Description |
| ------------ | ------------ |
| liquibase update | the command update all the changesets of the project to release a new version v1.1.0  |
| liquibase rollback v1.0.0 | the command is used to rollback to the previous version v1.0.0 if we already deployed the v1.1.0  |
| liquibase rollbackCount 15 | the command is used to remove the 15 changeset.  |