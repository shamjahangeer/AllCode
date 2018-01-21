SPOOL /TMP/AMCADMIN_SCRIPT.SQL

PROMPT CREATING THE TABLESPACE FOR THE USER AMCADMIN
CREATE TABLESPACE AMC_DATA_TBS LOGGING DATAFILE '&1/amc_data_tbs' SIZE 10M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
CREATE TABLESPACE AMC_INDEX_TBS LOGGING DATAFILE '&1/amc_index_tbs' SIZE 10M REUSE AUTOEXTEND ON NEXT 10M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO
/
PROMPT CREATING THE TABLESPACE FOR THE USER amcadmin
CREATE USER amcadmin IDENTIFIED BY amcadmin  DEFAULT TABLESPACE AMC_DATA_TBS TEMPORARY TABLESPACE TEMP
/
PROMPT GRANTING PRIVILEAGES TO THE USER amcadmin
GRANT CREATE SESSION, ALTER SESSION, CREATE PROCEDURE,RESOURCE ,CREATE TRIGGER, CREATE TABLE, CREATE VIEW, SELECT ANY TABLE TO amcadmin;
GRANT CREATE SEQUENCE TO amcadmin;
GRANT CREATE SYNONYM TO amcadmin;


SPOOL OFF;


