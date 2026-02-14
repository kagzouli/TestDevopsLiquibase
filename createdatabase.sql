-- TABLE CHANGESET : SELECT * FROM DATABASECHANGELOG

-- CREATE DATABASE
CREATE DATABASE testliquibase;

CREATE USER 'liquibase'@'%' IDENTIFIED BY 'liquibase_pass';

-- Grant all privileges on testliquibase database
GRANT ALL PRIVILEGES ON testliquibase.* TO 'liquibase'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;

-- Verify the grant
SHOW GRANTS FOR 'liquibase'@'localhost';