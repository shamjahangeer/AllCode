spool sitblmig_tmp2.lst

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION = '^CCE_DB_SCHEMA_VERSION^',
version_date = TO_DATE('^CCE_DB_SCHEMA_DATE^', 'MM/DD/YYYY HH24:MI')
WHERE object_type = 'DDL';

--
-- DB Migration Sequences
--

CREATE OR REPLACE PROCEDURE db_migration_create_sequence
  (in_sequence_name VARCHAR2,
   in_sql VARCHAR2) IS   
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_sequences
  WHERE  sequence_name = in_sequence_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE in_sql;   
END;
/   

PROMPT Creating Sequence 'CCE_SEQ_USER_VENDOR_ID'
BEGIN
  db_migration_create_sequence ('CCE_SEQ_USER_VENDOR_ID',
                                'CREATE SEQUENCE CCE_SEQ_USER_VENDOR_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' NOMAXVALUE  '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '              
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_WF_OP_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_WF_OP_ID',
                                'CREATE SEQUENCE EAMS_SEQ_WF_OP_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 6000 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '      
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_PE_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_PE_ID',
                                'CREATE SEQUENCE EAMS_SEQ_PE_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 420 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_CONF_REPOSITORY_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_CONF_REPOSITORY_ID',
                                'CREATE SEQUENCE EAMS_SEQ_CONF_REPOSITORY_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_AR_MAP_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_AR_MAP_ID',
                                'CREATE SEQUENCE EAMS_SEQ_AR_MAP_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 22 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_RM_POLL_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_RM_POLL_ID',
                                'CREATE SEQUENCE EAMS_SEQ_RM_POLL_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 22 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_CAT_MON_FILE_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_CAT_MON_FILE_ID',
                                'CREATE SEQUENCE EAMS_SEQ_CAT_MON_FILE_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_WORKFLOW_OP_TRANS_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_WORKFLOW_OP_TRANS_ID',
                                'CREATE SEQUENCE EAMS_SEQ_WORKFLOW_OP_TRANS_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_WORKSTEP_TRANS_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_WORKSTEP_TRANS_ID',
                                'CREATE SEQUENCE EAMS_SEQ_WORKSTEP_TRANS_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_RESOURCE_MAP_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_RESOURCE_MAP_ID',
                                'CREATE SEQUENCE EAMS_SEQ_RESOURCE_MAP_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_RESOURCE_ID'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_RESOURCE_ID',
                                'CREATE SEQUENCE EAMS_SEQ_RESOURCE_ID '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

PROMPT Creating Sequence 'EAMS_SEQ_PKG_STORAGE_EVENTS'
BEGIN
  db_migration_create_sequence ('EAMS_SEQ_PKG_STORAGE_EVENTS',
                                'CREATE SEQUENCE EAMS_SEQ_PKG_STORAGE_EVENTS '||CHR(10)||
                                ' INCREMENT BY 1 '||CHR(10)||
                                ' START WITH 1 '||CHR(10)||
                                ' MINVALUE 1 '||CHR(10)||
                                ' NOCYCLE '||CHR(10)||
                                ' CACHE 40 '||CHR(10)||
                                ' ORDER '
                                );
END;
/

--
-- DB Migration Tables
--

PROMPT Create tables

CREATE OR REPLACE PROCEDURE db_migration_create_table 
  (in_table_name VARCHAR2,
   in_sql VARCHAR2) IS   
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = in_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE in_sql;   
END;
/   

PROMPT Creating Table 'EAMS_INGEST_PKG_APP_DATA'
BEGIN
  db_migration_create_table ('EAMS_INGEST_PKG_APP_DATA',
                             'CREATE TABLE EAMS_INGEST_PKG_APP_DATA '||CHR(10)||
                             '( '||CHR(10)||
                             '  ITEM_CATEGORY_ID       NUMBER(10)             NOT NULL, '||CHR(10)||
                             '  ITEM_CATEGORY_VERSION  VARCHAR2(10 BYTE)      NOT NULL, '||CHR(10)||
                             '  CATCHER_ID             NUMBER(10)             NOT NULL, '||CHR(10)||
                             '  APP_DATA_NAME          VARCHAR2(2048 BYTE), '||CHR(10)||
                             '  APP_DATA_VALUE         VARCHAR2(4000 BYTE), '||CHR(10)||
                             '  STATUS                 VARCHAR2(30 BYTE) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128M_DAT');
END;
/

PROMPT Creating Table 'EAMS_PUBLISH_PKG_APP_DATA'
BEGIN
  db_migration_create_table ('EAMS_PUBLISH_PKG_APP_DATA',
                             'CREATE TABLE EAMS_PUBLISH_PKG_APP_DATA '||CHR(10)||
                             '( '||CHR(10)||
                             '  PUBLISH_ID       NUMBER(10) NOT NULL, '||CHR(10)||
                             '  APP_DATA_NAME    VARCHAR2(2048 BYTE), '||CHR(10)||
                             '  APP_DATA_VALUE   VARCHAR2(4000 BYTE), '||CHR(10)||
                             '  STATUS           VARCHAR2(30 BYTE), '||CHR(10)||
                             '  ITEM_CATEGORY_ID       NUMBER(10), '||CHR(10)||
                             '  ITEM_CATEGORY_VERSION  VARCHAR2(10 BYTE), '||CHR(10)||
                             '  NE_ID            NUMBER(11), '||CHR(10)||
                             '  PROFILE_ID       NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128M_DAT');
END;
/

PROMPT Creating Table 'CCE_REPORT_GROUP'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_GROUP';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_REPORT_GROUP '||CHR(10)||
                          '(  '||CHR(10)||
                          '  RPT_GRP_ID NUMBER(3, 0) NOT NULL,  '||CHR(10)||
                          '  RPT_GRP_NAME VARCHAR2(20) NOT NULL,  '||CHR(10)||
                          '  RPT_GRP_DISP_NAME VARCHAR2(200) NOT NULL,  '||CHR(10)||
                          '  RPT_GRP_DESC VARCHAR2(500)  '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'CCE_REPORT_DEF'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_DEF';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_REPORT_DEF  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_ID NUMBER(4) NOT NULL,  '||CHR(10)||
                          '  REPORT_NAME VARCHAR2(20) NOT NULL,  '||CHR(10)||
                          '  REPORT_DISP_NAME VARCHAR2(200) NOT NULL,  '||CHR(10)||
                          '  REPORT_DESC VARCHAR2(500)  '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT  ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'CCE_RPT_GRP_ASSOC'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_GRP_ASSOC';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_RPT_GRP_ASSOC  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_GRP_ID NUMBER(4) NOT NULL,  '||CHR(10)||
                          '  REPORT_ID NUMBER(4) NOT NULL  '||CHR(10)||
                          '  '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'CCE_RPT_FILTERS'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_RPT_FILTERS  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_ID NUMBER(4),  '||CHR(10)||
                          '  RPT_FIELD_NAME VARCHAR2(50) NOT NULL,  '||CHR(10)||
                          '  RPT_FIELD_DISP_NAME VARCHAR2(100) NOT NULL,  '||CHR(10)||
                          '  RPT_FIELD_DISP_NAME2 VARCHAR2(100),  '||CHR(10)||
                          '  RPT_FIELD_TYPE VARCHAR2(20) NOT NULL,  '||CHR(10)||
                          '  RPT_FIELD_DESC VARCHAR2(200) NOT NULL,  '||CHR(10)||
                          '  FIELD_RESOLVER_IMPL VARCHAR2(150), '||CHR(10)||
                          '  RPT_FIELD_SEQ NUMBER DEFAULT 1 NOT NULL '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT  ';                                                    
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'CCE_RPT_EXPORT_OPTIONS'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_OPTIONS';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_RPT_EXPORT_OPTIONS  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  EXPORT_OPT_ID NUMBER(4) NOT NULL,  '||CHR(10)||
                          '  EXPORT_OPT_NAME VARCHAR2(20) NOT NULL,  '||CHR(10)||
                          '  EXPORT_OPT_DISP_NAME VARCHAR2(20) NOT NULL,  '||CHR(10)||
                          '  EXPORT_OPT_DESC VARCHAR2(100)  '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT ';                                                   
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'CCE_RPT_EXPORT_ASSOC'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE TABLE CCE_RPT_EXPORT_ASSOC  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  EXPORT_OPT_ID NUMBER(4) NOT NULL,  '||CHR(10)||
                          '  REPORT_ID NUMBER(4) NOT NULL  '||CHR(10)||
                          ')  '||CHR(10)||
                          'TABLESPACE LEAPSTONE_128K_DAT ';
                                                   
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tables
  WHERE  table_name = l_table_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Table 'EAMS_ENCR_AGENT_TRANS'
BEGIN
  db_migration_create_table ('EAMS_ENCR_AGENT_TRANS',
                             'CREATE TABLE EAMS_ENCR_AGENT_TRANS (  '||CHR(10)||
                             '  TRANSACTIONID          VARCHAR2 (50)  NOT NULL  '||CHR(10)||
                             '  ,CONTENTID              VARCHAR2 (50)  NOT NULL  '||CHR(10)||
                             '  ,STATUSDESCRIPTION      VARCHAR2 (100)  '||CHR(10)||
                             '  ,TRANSACTIONSTARTTIME   NUMBER  '||CHR(10)||
                             '  ,TRANSACTIONENDTIME     NUMBER  '||CHR(10)||
                             '  ,PUBLICKEY              VARCHAR2 (100)  '||CHR(10)||
                             '  ,PRIVATEKEY             VARCHAR2 (100)  '||CHR(10)||
                             '  ,KEYID                  VARCHAR2 (100)  '||CHR(10)||
                             '  ,SEED                   VARCHAR2 (100)  '||CHR(10)||
                             '  ,CONTENTINPUTLOCATION   VARCHAR2 (256)  '||CHR(10)||
                             '  ,CONTENTOUTPUTLOCATION  VARCHAR2 (256) '||CHR(10)||
                             '  ,LICENSEACQUISITIONURL  VARCHAR2 (256) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table EAMS_ENCODE_AGENT_PROFILE_MAP 
BEGIN
  db_migration_create_table ('EAMS_ENCODE_AGENT_PROFILE_MAP',
                             'CREATE TABLE EAMS_ENCODE_AGENT_PROFILE_MAP (  '||CHR(10)||
                             '   EAMS_PROFILE_ID     NUMBER  '||CHR(10)||
                             '  ,ENCODER_SYSTEM_ID   NUMBER        NOT NULL '||CHR(10)||
                             '  ,ENCODER_PROFILE_ID  NUMBER        NOT NULL  '||CHR(10)||
                             '  ,PROFILE_NAME        VARCHAR2 (50) '||CHR(10)||
                             '  ,PROFILE_TYPE        NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table EAMS_ENCODE_AGENT_CONFIG
BEGIN
  db_migration_create_table ('EAMS_ENCODE_AGENT_CONFIG',
                             'CREATE TABLE EAMS_ENCODE_AGENT_CONFIG (  '||CHR(10)||
                             '   FIELDNAME   VARCHAR2 (50)  NOT NULL  '||CHR(10)||
                             '  ,FIELDVALUE  VARCHAR2 (100)  NOT NULL  '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table EAMS_ENCR_AGENT_CONFIG 
BEGIN
  db_migration_create_table ('EAMS_ENCR_AGENT_CONFIG',
                             'CREATE TABLE EAMS_ENCR_AGENT_CONFIG (  '||CHR(10)||
                             '  FIELDNAME   VARCHAR2 (50)  NOT NULL  '||CHR(10)||
                             '  ,FIELDVALUE  VARCHAR2 (100)  NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table EAMS_ENCODE_AGENT_AV_PROFILE 
BEGIN
  db_migration_create_table ('EAMS_ENCODE_AGENT_AV_PROFILE',
                             'CREATE TABLE EAMS_ENCODE_AGENT_AV_PROFILE (  '||CHR(10)||
                             '   AV_PROFILE_ID    NUMBER  '||CHR(10)||
                             '  ,NAME             VARCHAR2 (100)  '||CHR(10)||
                             '  ,VALUE            VARCHAR2 (100) '||CHR(10)||
                             '  ,AV_PROFILE_TYPE  VARCHAR2 (1) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/
 
PROMPT Creating Table EAMS_ENCODE_AGENT_PROF_AV_MAP
BEGIN
  db_migration_create_table ('EAMS_ENCODE_AGENT_PROF_AV_MAP',
                             'CREATE TABLE EAMS_ENCODE_AGENT_PROF_AV_MAP (  '||CHR(10)||
                             '   ENCODER_PROFILE_ID  NUMBER '||CHR(10)||
                             '  ,AV_PROFILE_ID       NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table EAMS_ENCODE_AGENT_TRANS  
BEGIN
  db_migration_create_table ('EAMS_ENCODE_AGENT_TRANS',
                             'CREATE TABLE EAMS_ENCODE_AGENT_TRANS (  '||CHR(10)||
                             '  TRANSACTIONID          VARCHAR2 (50) '||CHR(10)||
                             '  ,CONTENTID              VARCHAR2 (50)  '||CHR(10)||
                             '  ,STATUSDESCRIPTION      VARCHAR2 (100)  '||CHR(10)||
                             '  ,TRANSACTIONSTARTTIME   NUMBER '||CHR(10)||
                             '  ,TRANSACTIONENDTIME     NUMBER  '||CHR(10)||
                             '  ,CONTENTINPUTLOCATION   VARCHAR2 (256) '||CHR(10)||
                             '  ,CONTENTOUTPUTLOCATION  VARCHAR2 (256) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                            );
END;
/

PROMPT Creating Table CCE_USER_VENDOR_ASSOC  
BEGIN
  db_migration_create_table ('CCE_USER_VENDOR_ASSOC',
                             'CREATE TABLE CCE_USER_VENDOR_ASSOC  '||CHR(10)||
                             '(USER_VENDOR_ID NUMBER NOT NULL '||CHR(10)||
                             ',USER_ID    NUMBER        NOT NULL '||CHR(10)||
                             ',VENDOR_ID  NUMBER        NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER       NOT NULL '||CHR(10)||
                             ',START_TIME  NUMBER       NOT NULL '||CHR(10)||
                             ',END_TIME    NUMBER '||CHR(10)||
                             ',STATUS      NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_JOB_DETAILS  
BEGIN
  db_migration_create_table ('QRTZ_JOB_DETAILS',
                             'CREATE TABLE QRTZ_JOB_DETAILS '||CHR(10)||
                             '(JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',DESCRIPTION VARCHAR2(250) NULL '||CHR(10)||
                             ',JOB_CLASS_NAME VARCHAR2(250) NOT NULL '||CHR(10)||
                             ',IS_DURABLE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',IS_STATEFUL VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',REQUESTS_RECOVERY VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',JOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_JOB_LISTENERS  
BEGIN
  db_migration_create_table ('QRTZ_JOB_LISTENERS',
                             'CREATE TABLE QRTZ_JOB_LISTENERS '||CHR(10)||
                             '(JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_LISTENER VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_TRIGGERS  
BEGIN
  db_migration_create_table ('QRTZ_TRIGGERS',
                             'CREATE TABLE QRTZ_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',DESCRIPTION VARCHAR2(250) NULL '||CHR(10)||
                             ',NEXT_FIRE_TIME NUMBER(13) NULL '||CHR(10)||
                             ',PREV_FIRE_TIME NUMBER(13) NULL '||CHR(10)||
                             ',PRIORITY NUMBER(13) NULL '||CHR(10)||
                             ',TRIGGER_STATE VARCHAR2(16) NOT NULL '||CHR(10)||
                             ',TRIGGER_TYPE VARCHAR2(8) NOT NULL '||CHR(10)||
                             ',START_TIME NUMBER(13) NOT NULL '||CHR(10)||
                             ',END_TIME NUMBER(13) NULL '||CHR(10)||
                             ',CALENDAR_NAME VARCHAR2(200) NULL '||CHR(10)||
                             ',MISFIRE_INSTR NUMBER(2) NULL '||CHR(10)||
                             ',JOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_SIMPLE_TRIGGERS  
BEGIN
  db_migration_create_table ('QRTZ_SIMPLE_TRIGGERS',
                             'CREATE TABLE QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',REPEAT_COUNT NUMBER(7) NOT NULL '||CHR(10)||
                             ',REPEAT_INTERVAL NUMBER(12) NOT NULL '||CHR(10)||
                             ',TIMES_TRIGGERED NUMBER(10) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_CRON_TRIGGERS  
BEGIN
  db_migration_create_table ('QRTZ_CRON_TRIGGERS',
                             'CREATE TABLE QRTZ_CRON_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',CRON_EXPRESSION VARCHAR2(120) NOT NULL '||CHR(10)||
                             ',TIME_ZONE_ID VARCHAR2(80) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_BLOB_TRIGGERS  
BEGIN
  db_migration_create_table ('QRTZ_BLOB_TRIGGERS',
                             'CREATE TABLE QRTZ_BLOB_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',BLOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_TRIGGER_LISTENERS  
BEGIN
  db_migration_create_table ('QRTZ_TRIGGER_LISTENERS',
                             'CREATE TABLE QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                             '(TRIGGER_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_LISTENER VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_CALENDARS  
BEGIN
  db_migration_create_table ('QRTZ_CALENDARS',
                             'CREATE TABLE QRTZ_CALENDARS '||CHR(10)||
                             '(CALENDAR_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',CALENDAR BLOB NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_PAUSED_TRIGGER_GRPS  
BEGIN
  db_migration_create_table ('QRTZ_PAUSED_TRIGGER_GRPS',
                             'CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                             '(TRIGGER_GROUP  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_PAUSED_TRIGGER_GRPS  
BEGIN
  db_migration_create_table ('QRTZ_PAUSED_TRIGGER_GRPS',
                             'CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                             '(TRIGGER_GROUP  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_FIRED_TRIGGERS  
BEGIN
  db_migration_create_table ('QRTZ_FIRED_TRIGGERS',
                             'CREATE TABLE QRTZ_FIRED_TRIGGERS  '||CHR(10)||
                             '(ENTRY_ID VARCHAR2(95) NOT NULL '||CHR(10)||
                             ',TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',INSTANCE_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',FIRED_TIME NUMBER(13) NOT NULL '||CHR(10)||
                             ',PRIORITY NUMBER(13) NOT NULL '||CHR(10)||
                             ',STATE VARCHAR2(16) NOT NULL '||CHR(10)||
                             ',JOB_NAME VARCHAR2(200) NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NULL '||CHR(10)||
                             ',IS_STATEFUL VARCHAR2(1) NULL '||CHR(10)||
                             ',REQUESTS_RECOVERY VARCHAR2(1) NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_SCHEDULER_STATE  
BEGIN
  db_migration_create_table ('QRTZ_SCHEDULER_STATE',
                             'CREATE TABLE QRTZ_SCHEDULER_STATE  '||CHR(10)||
                             '(INSTANCE_NAME VARCHAR2(200) NOT NULL, '||CHR(10)||
                             'LAST_CHECKIN_TIME NUMBER(13) NOT NULL, '||CHR(10)||
                             'CHECKIN_INTERVAL NUMBER(13) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table QRTZ_LOCKS  
BEGIN
  db_migration_create_table ('QRTZ_LOCKS',
                             'CREATE TABLE QRTZ_LOCKS '||CHR(10)||
                             '(LOCK_NAME  VARCHAR2(40) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_MEDIA_FORMAT_INFO  
BEGIN
  db_migration_create_table ('EAMS_MEDIA_FORMAT_INFO',
                             'CREATE TABLE EAMS_MEDIA_FORMAT_INFO '||CHR(10)||
                             '(MEDIA_FORMAT_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_ID NUMBER (10) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2 (4000) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_ASPERA_SUB_INFO  
BEGIN
  db_migration_create_table ('EAMS_ASPERA_SUB_INFO',
                             'CREATE TABLE EAMS_ASPERA_SUB_INFO '||CHR(10)||
                             '(SUBSCRIPTION_ID VARCHAR2 (100) NOT NULL '||CHR(10)||
                             ',SUBSCRIPTION_TYPE VARCHAR2 (100) NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER '||CHR(10)||
                             ',PUBLISH_TYPE VARCHAR2 (100) NOT NULL '||CHR(10)||
                             ',CENTRAL_ADDRESS VARCHAR2 (100) NOT NULL '||CHR(10)||
                             ',OBSERVER_URL VARCHAR2 (256) NOT NULL '||CHR(10)||
                             ',SUBSCRIPTION_TIME_REMAINING NUMBER '||CHR(10)||
                             ',SUBSCRIPTION_REQUIRED VARCHAR2 (1) NOT NULL '||CHR(10)||
                             ',SUBSCRIPTION_START_TIME NUMBER NOT NULL '||CHR(10)||
                             ',NODE_ID VARCHAR2 (10) '||CHR(10)||
                             ',SUBSCRIPTION_STATUS VARCHAR2 (15) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2 (20) NOT NULL '||CHR(10)||
                             ',MODIFY_TIME NUMBER '||CHR(10)||
                             ',MODIFIED_BY VARCHAR2 (20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_RM_NE_LOAD_INFO  
BEGIN
  db_migration_create_table ('EAMS_RM_NE_LOAD_INFO',
                             'CREATE TABLE EAMS_RM_NE_LOAD_INFO '||CHR(10)||
                             '(NE_ID NUMBER(3) NOT NULL '||CHR(10)||
                             ',AVAILABLE_CAPACITY NUMBER(2) NOT NULL '||CHR(10)||
                             ',STATUS NUMBER NOT NULL '||CHR(10)||
                             ',THRESH_HOLD NUMBER(2) '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(100) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_JOB_DETAILS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_JOB_DETAILS',
                             'CREATE TABLE EAMS_QRTZ_JOB_DETAILS '||CHR(10)||
                             '(JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',DESCRIPTION VARCHAR2(250) NULL '||CHR(10)||
                             ',JOB_CLASS_NAME VARCHAR2(250) NOT NULL '||CHR(10)||
                             ',IS_DURABLE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',IS_STATEFUL VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',REQUESTS_RECOVERY VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',JOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_JOB_LISTENERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_JOB_LISTENERS',
                             'CREATE TABLE EAMS_QRTZ_JOB_LISTENERS '||CHR(10)||
                             '(JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_LISTENER VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_TRIGGERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_TRIGGERS',
                             'CREATE TABLE EAMS_QRTZ_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',DESCRIPTION VARCHAR2(250) NULL '||CHR(10)||
                             ',NEXT_FIRE_TIME NUMBER(13) NULL '||CHR(10)||
                             ',PREV_FIRE_TIME NUMBER(13) NULL '||CHR(10)||
                             ',PRIORITY NUMBER(13) NULL '||CHR(10)||
                             ',TRIGGER_STATE VARCHAR2(16) NOT NULL '||CHR(10)||
                             ',TRIGGER_TYPE VARCHAR2(8) NOT NULL '||CHR(10)||
                             ',START_TIME NUMBER(13) NOT NULL '||CHR(10)||
                             ',END_TIME NUMBER(13) NULL '||CHR(10)||
                             ',CALENDAR_NAME VARCHAR2(200) NULL '||CHR(10)||
                             ',MISFIRE_INSTR NUMBER(2) NULL '||CHR(10)||
                             ',JOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_SIMPLE_TRIGGERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_SIMPLE_TRIGGERS',
                             'CREATE TABLE EAMS_QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',REPEAT_COUNT NUMBER(7) NOT NULL '||CHR(10)||
                             ',REPEAT_INTERVAL NUMBER(12) NOT NULL '||CHR(10)||
                             ',TIMES_TRIGGERED NUMBER(10) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_CRON_TRIGGERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_CRON_TRIGGERS',
                             'CREATE TABLE EAMS_QRTZ_CRON_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',CRON_EXPRESSION VARCHAR2(120) NOT NULL '||CHR(10)||
                             ',TIME_ZONE_ID VARCHAR2(80) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_BLOB_TRIGGERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_BLOB_TRIGGERS',
                             'CREATE TABLE EAMS_QRTZ_BLOB_TRIGGERS '||CHR(10)||
                             '(TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',BLOB_DATA BLOB NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_TRIGGER_LISTENERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_TRIGGER_LISTENERS',
                             'CREATE TABLE EAMS_QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                             '(TRIGGER_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_LISTENER VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_CALENDARS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_CALENDARS',
                             'CREATE TABLE EAMS_QRTZ_CALENDARS '||CHR(10)||
                             '(CALENDAR_NAME  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',CALENDAR BLOB NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_PAUSED_TRIGGER_GRPS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_PAUSED_TRIGGER_GRPS',
                             'CREATE TABLE EAMS_QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                             '(TRIGGER_GROUP  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_PAUSED_TRIGGER_GRPS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_PAUSED_TRIGGER_GRPS',
                             'CREATE TABLE EAMS_QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                             '(TRIGGER_GROUP  VARCHAR2(200) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_FIRED_TRIGGERS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_FIRED_TRIGGERS',
                             'CREATE TABLE EAMS_QRTZ_FIRED_TRIGGERS  '||CHR(10)||
                             '(ENTRY_ID VARCHAR2(95) NOT NULL '||CHR(10)||
                             ',TRIGGER_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',TRIGGER_GROUP VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',IS_VOLATILE VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',INSTANCE_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',FIRED_TIME NUMBER(13) NOT NULL '||CHR(10)||
                             ',PRIORITY NUMBER(13) NOT NULL '||CHR(10)||
                             ',STATE VARCHAR2(16) NOT NULL '||CHR(10)||
                             ',JOB_NAME VARCHAR2(200) NULL '||CHR(10)||
                             ',JOB_GROUP VARCHAR2(200) NULL '||CHR(10)||
                             ',IS_STATEFUL VARCHAR2(1) NULL '||CHR(10)||
                             ',REQUESTS_RECOVERY VARCHAR2(1) NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_SCHEDULER_STATE  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_SCHEDULER_STATE',
                             'CREATE TABLE EAMS_QRTZ_SCHEDULER_STATE  '||CHR(10)||
                             '(INSTANCE_NAME VARCHAR2(200) NOT NULL, '||CHR(10)||
                             'LAST_CHECKIN_TIME NUMBER(13) NOT NULL, '||CHR(10)||
                             'CHECKIN_INTERVAL NUMBER(13) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_QRTZ_LOCKS  
BEGIN
  db_migration_create_table ('EAMS_QRTZ_LOCKS',
                             'CREATE TABLE EAMS_QRTZ_LOCKS '||CHR(10)||
                             '(LOCK_NAME  VARCHAR2(40) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_DBOARD_VIEW  
BEGIN
  db_migration_create_table ('EAMS_DBOARD_VIEW',
                             'CREATE TABLE EAMS_DBOARD_VIEW '||CHR(10)||
                             '(ID NUMBER '||CHR(10)||
                             ',NAME VARCHAR(50) '||CHR(10)||
                             ',DISPLAY_NAME VARCHAR (200) '||CHR(10)||
                             ',DESCRIPTION VARCHAR (500) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_PI_JOB_TRANS  
BEGIN
  db_migration_create_table ('EAMS_PI_JOB_TRANS',
                             'CREATE TABLE EAMS_PI_JOB_TRANS '||CHR(10)||
                             '(PI_ID NUMBER NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_TRANS_ID  NUMBER NOT NULL '||CHR(10)||
                             ',JOB_GROUP_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_ID VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',PACKAGE_PRIORITY NUMBER(10) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',LICENSE_START_DATE DATE NOT NULL '||CHR(10)||
                             ',JOB_SUBMISSION_TIME DATE NOT NULL '||CHR(10)||
                             ',LAST_PRIORITIZED_TIME DATE '||CHR(10)||
                             ',LAST_SCHEDULED_TIME DATE '||CHR(10)||
                             ',PRIORITIZATION_COUNT NUMBER '||CHR(10)||
                             ',PRIORITY_REASON_CODE NUMBER  '||CHR(10)||
                             ',USER_PRIORITY NUMBER '||CHR(10)||
                             ',USER_PRIORITIZED_TIME NUMBER '||CHR(10)||
                             ',USER_PRIORITIZED_REMARKS VARCHAR2(500) '||CHR(10)||
                             ',CREATE_TIME NUMBER '||CHR(10)||
                             ',CREATE_BY VARCHAR2(100) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(100) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_CONFIG_REPOSITORY  
BEGIN
  db_migration_create_table ('EAMS_CONFIG_REPOSITORY',
                             'CREATE TABLE EAMS_CONFIG_REPOSITORY '||CHR(10)||
                             '(ID NUMBER NOT NULL '||CHR(10)||
                             ',VERSION VARCHAR2(5) DEFAULT ''1.0'' NOT NULL  '||CHR(10)||
                             ',SVC_NAME VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',FUNCTION_NAME VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',INSTANCE_NAME VARCHAR2(75) '||CHR(10)||
                             ',FILE_NAME VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',FILE_TYPE VARCHAR2(10) NOT NULL '||CHR(10)||
                             ',FILE_CONTENT CLOB '||CHR(10)||
                             ',STATUS NUMBER NOT NULL '||CHR(10)||
                             ',RECORD_CREATE_TIME NUMBER  NOT NULL '||CHR(10)||
                             ',USER_ID NUMBER '||CHR(10)||
                             ',VENDOR_ID NUMBER(10) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',SOURCE NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_ADAPT_ASSET_INFO  
BEGIN
  db_migration_create_table ('EAMS_ADAPT_ASSET_INFO',
                             'CREATE TABLE EAMS_ADAPT_ASSET_INFO '||CHR(10)||
                             '(ADAPT_ASSET_ID VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',FIELD_ID NUMBER(10) NOT NULL  '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table CCE_RPT_DISPLAY_OPTIONS  
BEGIN
  db_migration_create_table ('CCE_RPT_DISPLAY_OPTIONS',
                             'CREATE TABLE CCE_RPT_DISPLAY_OPTIONS '||CHR(10)||
                             '(DISPLAY_OPT_ID NUMBER(4) NOT NULL '||CHR(10)||
                             ',DISPLAY_OPT_NAME VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',DISPLAY_OPT_DISP_NAME VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',DISPLAY_OPT_DESC VARCHAR2(100) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_INGEST_ASSET_ASSET_ASSOC  
BEGIN
  db_migration_create_table ('EAMS_INGEST_ASSET_ASSET_ASSOC',
                             'CREATE TABLE EAMS_INGEST_ASSET_ASSET_ASSOC '||CHR(10)||
                             '(ITEM_CATEGORY_ID         NUMBER(10)           NOT NULL '||CHR(10)||
                             ',ITEM_CATEGORY_VERSION    VARCHAR2(10 BYTE)    NOT NULL '||CHR(10)||
                             ',ASSET_ID                 VARCHAR2(20 BYTE)    NOT NULL '||CHR(10)||
                             ',ASSOC_ASSET_ID           VARCHAR2(20 BYTE)    NOT NULL '||CHR(10)||
                             ',CREATE_TIME              NUMBER               NOT NULL '||CHR(10)||
                             ',CREATE_BY                VARCHAR2(20 BYTE)    NOT NULL '||CHR(10)||
                             ',LAST_MODIFY_TIME         NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY           VARCHAR2(20 BYTE) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_PUBLISH_SUB_STATUS  
BEGIN
  db_migration_create_table ('EAMS_PUBLISH_SUB_STATUS', 
                             'CREATE TABLE EAMS_PUBLISH_SUB_STATUS '||CHR(10)||
                             '(SUB_STATUS_CODE NUMBER(10) NOT NULL '||CHR(10)||
                             ',SUB_STATUS_DESC VARCHAR2(300) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_CATCHER_MONITOR  
BEGIN
  db_migration_create_table ('EAMS_CATCHER_MONITOR', 
                             'CREATE TABLE EAMS_CATCHER_MONITOR '||CHR(10)||
                             '(NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',NE_NAME VARCHAR2(30) '||CHR(10)||
                             ',PKG_PENDING NUMBER NOT NULL '||CHR(10)||
                             ',PKG_IN_PROGRESS NUMBER NOT NULL '||CHR(10)||
                             ',PKG_REJECTED NUMBER NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_AR_MAP_INFO  
BEGIN
  db_migration_create_table ('EAMS_AR_MAP_INFO', 
                             'CREATE TABLE EAMS_AR_MAP_INFO '||CHR(10)||
                             '(AR_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',AR_MAP_NAME VARCHAR2(500) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(50) '||CHR(10)||
                             ',DEFAULT_MAP VARCHAR2(1) DEFAULT ''N'' NOT NULL '||CHR(10)||
                             ',TARGET_PLATFORM VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20 BYTE) NOT NULL '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20 BYTE) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_RM_POLL_STATUS  
BEGIN
  db_migration_create_table ('EAMS_RM_POLL_STATUS', 
                             'CREATE TABLE EAMS_RM_POLL_STATUS '||CHR(10)||
                             '(POLL_ID NUMBER NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_TRANS_ID NUMBER NOT NULL '||CHR(10)||
                             ',OPERATION_ID VARCHAR2(256) NOT NULL '||CHR(10)||
                             ',JOB_ID VARCHAR2(256) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',POLL_COUNT NUMBER '||CHR(10)||
                             ',POLL_START_TIME NUMBER '||CHR(10)||
                             ',LAST_POLL_TIME NUMBER '||CHR(10)||
                             ',POLL_SUCCESS_TIME NUMBER  '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_POLLING_JOBS  
BEGIN
  db_migration_create_table ('EAMS_POLLING_JOBS', 
                             'CREATE TABLE EAMS_POLLING_JOBS '||CHR(10)||
                             '(JOB_ID NUMBER NOT NULL '||CHR(10)||
                             ',JOB_NAME VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',IMPL_CLASS VARCHAR2(256) NOT NULL '||CHR(10)||
                             ',JOB_INTERVAL NUMBER '||CHR(10)||
                             ',JOB_INTERVAL_UNIT NUMBER '||CHR(10)||
                             ',RESET_ON_STARTUP VARCHAR2(1) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_AR_MAP_FIELD_INFO  
BEGIN
  db_migration_create_table ('EAMS_AR_MAP_FIELD_INFO', 
                             'CREATE TABLE EAMS_AR_MAP_FIELD_INFO '||CHR(10)||
                             '(AR_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000 BYTE) '||CHR(10)||
                             ',MAP_TYPE VARCHAR2(50) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_CATCHER_MONITOR_FILES  
BEGIN
  db_migration_create_table ('EAMS_CATCHER_MONITOR_FILES', 
                             'CREATE TABLE EAMS_CATCHER_MONITOR_FILES '||CHR(10)||
                             '(ID NUMBER NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',NE_NAME VARCHAR2(100) '||CHR(10)||
                             ',FILE_NAME VARCHAR2(2000) NOT NULL '||CHR(10)||
                             ',FILE_STATUS VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',FILE_LAST_MOD_TIME NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_WORKFLOW_TRANS_INFO  
BEGIN
  db_migration_create_table ('EAMS_WORKFLOW_TRANS_INFO', 
                             'CREATE TABLE EAMS_WORKFLOW_TRANS_INFO '||CHR(10)||
                             '(WORKFLOW_OP_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) '||CHR(10)||
                             ',CONTEXT_TYPE NUMBER NOT NULL '||CHR(10)||
                             ',CONTEXT_INFO XMLTYPE '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128M_DAT'
                             );
END;
/

PROMPT Creating Table EAMS_INFLIGHT_PACKAGE  
DECLARE
  l_dummy INTEGER;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INFLIGHT_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PUB_TOKEN_ID';
  
  l_sql VARCHAR2(4096) := 'CREATE TABLE EAMS_INFLIGHT_PACKAGE '||CHR(10)||
                          '(ALT_CODE VARCHAR2(50) NOT NULL '||CHR(10)||
                          ',PROVIDER_ID VARCHAR2(20) NOT NULL '||CHR(10)||
                          ',ITEM_CATEGORY_ID NUMBER '||CHR(10)||
                          ',PUBLISH_TOKEN VARCHAR2(256) '||CHR(10)||
                          ',NOTIFICATION_URL VARCHAR2(100) '||CHR(10)||
                          ',INFLIGHT_STATUS VARCHAR2(20) '||CHR(10)||
                          ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                          ',ITEM_CATEGORY_VERSION VARCHAR2(10) '||CHR(10)||
                          ') TABLESPACE EAMS_MOT_128M_DAT';
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'DROP TABLE '||l_table_name;
  EXECUTE IMMEDIATE l_sql;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         BEGIN
           BEGIN
             SELECT 1
             INTO   l_dummy
             FROM   user_tables
             WHERE  table_name = l_table_name;

             EXCEPTION
               WHEN NO_DATA_FOUND THEN 
                    EXECUTE IMMEDIATE l_sql;
           END;
         END;
END;
/

PROMPT Creating Table EAMS_INFLIGHT_PLATFORM_ASSOC  
DECLARE
  l_dummy INTEGER;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INFLIGHT_PLATFORM_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'PUB_TOKEN_ID';
  
  l_sql VARCHAR2(4096) := 'CREATE TABLE EAMS_INFLIGHT_PLATFORM_ASSOC '||CHR(10)||
                          '(ALT_CODE VARCHAR2(50) '||CHR(10)||
                          ',PROVIDER_ID VARCHAR2(50) '||CHR(10)||
                          ',PROFILE_ID NUMBER '||CHR(10)||
                          ',PUBLISH_ID NUMBER '||CHR(10)||
                          ',STATUS  VARCHAR2(50) '||CHR(10)||
                          ',PUBLISH_TOKEN VARCHAR2(256)  '||CHR(10)||
                          ') TABLESPACE EAMS_MOT_128M_DAT';
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'DROP TABLE '||l_table_name;
  EXECUTE IMMEDIATE l_sql;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         BEGIN
           BEGIN
             SELECT 1
             INTO   l_dummy
             FROM   user_tables
             WHERE  table_name = l_table_name;

             EXCEPTION
               WHEN NO_DATA_FOUND THEN 
                    EXECUTE IMMEDIATE l_sql;
           END;
         END;
END;
/

PROMPT Creating Table EAMS_PACKAGE_STORAGE_DETAILS  
BEGIN
  db_migration_create_table ('EAMS_PACKAGE_STORAGE_DETAILS',
                             'CREATE TABLE EAMS_PACKAGE_STORAGE_DETAILS '||CHR(10)||
                             '(ITEM_CATEGORY_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',ITEM_CATEGORY_VERSION VARCHAR2(10) NOT NULL '||CHR(10)||
                             ',STATUS  VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',WORKING_STORAGE_LOCATION  VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ',BACKUP_STORAGE_LOCATION VARCHAR2(4000) '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20)  NOT NULL '||CHR(10)||
                             ',LAST_ACCESSED_TIME  NUMBER NOT NULL '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_STATUS_MODIFY_TIME NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD_USER'
BEGIN
  db_migration_create_table ('EAMS_DBOARD_USER',
                             'CREATE TABLE EAMS_DBOARD_USER '||CHR(10)||
                             '(LOGIN_NAME VARCHAR2(30) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD'
BEGIN
  db_migration_create_table ('EAMS_DBOARD',
                             'CREATE TABLE EAMS_DBOARD '||CHR(10)||
                             '(ID INTEGER NOT NULL '||CHR(10)||
                             ',DBOARD_NAME VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',DISPLAY_NAME VARCHAR2(75) '||CHR(10)||
                             ',DESCRIPTION VARCHAR2(500) '||CHR(10)||
                             ',LAUNCH_URL VARCHAR2(200) '||CHR(10)||
                             ',DISPLAY_ORDER INTEGER '||CHR(10)||
                             ',LAYOUT_TYPE VARCHAR2(30) '||CHR(10)||
                             ',STATUS VARCHAR2(20) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD_ITEM'
DECLARE
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM';
  l_column_name CONSTANT VARCHAR2(30) := 'ID';
  l_dummy INTEGER;
BEGIN
  BEGIN  
    SELECT 1
    INTO   l_dummy
    FROM   user_tab_columns
    WHERE  table_name = l_table_name
    AND    column_name = l_column_name;
    
    EXECUTE IMMEDIATE 'DROP TABLE EAMS_DBOARD_ITEMS_DISP';
    EXECUTE IMMEDIATE 'DROP TABLE EAMS_DBOARD_VIEW_ITEMS_ASSOC';
    EXECUTE IMMEDIATE 'DROP TABLE '||l_table_name;
    
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN NULL;           
  END;

  db_migration_create_table ('EAMS_DBOARD_ITEM',
                             'CREATE TABLE EAMS_DBOARD_ITEM '||CHR(10)||
                             '(WIDGET_ID INTEGER NOT NULL '||CHR(10)||
                             ',WIDGET_NAME VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',DISPLAY_NAME VARCHAR2(100) '||CHR(10)||
                             ',DESCRIPTION CHAR(500) '||CHR(10)||
                             ',DISPLAY_ORDER INTEGER '||CHR(10)||
                             ',REFRESH_PERIOD INTEGER '||CHR(10)||
                             ',STATUS VARCHAR2(20) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD_ITEM_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_DBOARD_ITEM_ASSOC',
                             'CREATE TABLE EAMS_DBOARD_ITEM_ASSOC '||CHR(10)||
                             '(WIDGET_ID INTEGER NOT NULL '||CHR(10)||
                             ',DBOARD_ID INTEGER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD_USR_ITEM_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_DBOARD_USR_ITEM_ASSOC',
                             'CREATE TABLE EAMS_DBOARD_USR_ITEM_ASSOC '||CHR(10)||
                             '(LOGIN_NAME VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',WIDGET_ID INTEGER NOT NULL '||CHR(10)||
                             ',DBOARD_ID INTEGER NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_DBOARD_ITEM_PROPS'
BEGIN
  db_migration_create_table ('EAMS_DBOARD_ITEM_PROPS',
                             'CREATE TABLE EAMS_DBOARD_ITEM_PROPS '||CHR(10)||
                             '(NAME VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',VALUE VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',WIDGET_ID INTEGER NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE',
                             'CREATE TABLE EAMS_RESOURCE  '||CHR(10)||
                             '(RESOURCE_ID NUMBER NOT NULL '||CHR(10)||
                             ',RESOURCE_UID VARCHAR2(256) NOT NULL '||CHR(10)||
                             ',RESOURCE_TYPE VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',RESOURCE_URI VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ',RESOURCE_SIZE NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',RESOURCE_SOURCE NUMBER '||CHR(10)||
                             ',RESOURCE_DEST NUMBER '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CHECKSUM VARCHAR2(1000) '||CHR(10)||
                             ',PACKAGED VARCHAR2(1) '||CHR(10)||
                             ',DISCOVER_TIME NUMBER '||CHR(10)||
                             ',LAST_ERROR_TIME NUMBER '||CHR(10)||
                             ',LAST_ERROR_RESOLVE_TIME NUMBER '||CHR(10)||
                             ',REJECT_TIME NUMBER '||CHR(10)||
                             ',INGEST_TIME NUMBER '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE_INFO'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE_INFO',
                             'CREATE TABLE EAMS_RESOURCE_INFO '||CHR(10)||
                             '(RESOURCE_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_NAME VARCHAR2(500) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE_RESOURCE_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE_RESOURCE_ASSOC',
                             'CREATE TABLE EAMS_RESOURCE_RESOURCE_ASSOC '||CHR(10)||
                             '(PARENT_RESOURCE_ID NUMBER NOT NULL '||CHR(10)||
                             ',RESOURCE_ID NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',ASSOC_TIME NUMBER '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE_ROLE'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE_ROLE',
                             'CREATE TABLE EAMS_RESOURCE_ROLE '||CHR(10)||
                             '(ROLE_ID NUMBER NOT NULL '||CHR(10)||
                             ',ROLE_NAME VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',ROLE_TYPE VARCHAR2(30) '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE_ROLE_MAP'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE_ROLE_MAP',
                             'CREATE TABLE EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                             '(RESOURCE_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',RESOURCE_ID NUMBER NOT NULL '||CHR(10)||
                             ',ROLE_ID NUMBER NOT NULL '||CHR(10)||
                             ',ROLE_TYPE VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RESOURCE_ROLE_MAP_INFO'
BEGIN
  db_migration_create_table ('EAMS_RESOURCE_ROLE_MAP_INFO',
                             'CREATE TABLE EAMS_RESOURCE_ROLE_MAP_INFO '||CHR(10)||
                             '(RESOURCE_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_NAME VARCHAR2(500) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RULEGROUP'
BEGIN
  db_migration_create_table ('EAMS_RULEGROUP',
                             'CREATE TABLE EAMS_RULEGROUP '||CHR(10)||
                             '(RULEGROUP_ID NUMBER NOT NULL, '||CHR(10)||
                             'RULEGROUP_NAME VARCHAR2(256) NOT NULL, '||CHR(10)||
                             'STATUS VARCHAR2(30) NOT NULL, '||CHR(10)||
                             'CREATE_TIME NUMBER NOT NULL, '||CHR(10)||
                             'CREATE_BY VARCHAR2(20), '||CHR(10)||
                             'LAST_MODIFY_TIME NUMBER, '||CHR(10)||
                             'LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WF_RESOURCE_MAP_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_WF_RESOURCE_MAP_ASSOC',
                             'CREATE TABLE EAMS_WF_RESOURCE_MAP_ASSOC '||CHR(10)||
                             '(WORKFLOW_OP_ID NUMBER NOT NULL '||CHR(10)||
                             ',RESOURCE_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',POOLED VARCHAR2(1) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',NEW_WORKFLOW_OP_ID NUMBER '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKFLOW_OP_INFO'
BEGIN
  db_migration_create_table ('EAMS_WORKFLOW_OP_INFO',
                             'CREATE TABLE EAMS_WORKFLOW_OP_INFO '||CHR(10)||
                             '(WORKFLOW_OP_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_NAME VARCHAR2(500) NOT NULL '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKFLOW_OP_TRANS'
BEGIN
  db_migration_create_table ('EAMS_WORKFLOW_OP_TRANS',
                             'CREATE TABLE EAMS_WORKFLOW_OP_TRANS '||CHR(10)||
                             '(WORKFLOW_OP_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_ID NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',TRANS_START_TIME NUMBER '||CHR(10)||
                             ',TRANS_END_TIME NUMBER '||CHR(10)||
                             ',RESOURCE_COUNT NUMBER '||CHR(10)||
                             ',RESOURCE_ERROR_COUNT NUMBER '||CHR(10)||
                             ',RESOURCE_COMPLETED_COUNT NUMBER '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKFLOW_WORKSTEP_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_WORKFLOW_WORKSTEP_ASSOC',
                             'CREATE TABLE EAMS_WORKFLOW_WORKSTEP_ASSOC '||CHR(10)||
                             '(WORKFLOW_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKSTEP_ID NUMBER NOT NULL '||CHR(10)||
                             ',SEQUENCE_NO NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKSTEP'
BEGIN
  db_migration_create_table ('EAMS_WORKSTEP',
                             'CREATE TABLE EAMS_WORKSTEP '||CHR(10)||
                             '(WORKSTEP_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKSTEP_NAME VARCHAR2(256) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKSTEP_ROLE_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_WORKSTEP_ROLE_ASSOC',
                             'CREATE TABLE EAMS_WORKSTEP_ROLE_ASSOC '||CHR(10)||
                             '(WORKSTEP_ID NUMBER NOT NULL '||CHR(10)||
                             ',ROLE_ID NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',WORKSTEP_TYPE VARCHAR2(50) DEFAULT ''SINGLE-RESOURCE'' '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKSTEP_RULEGROUP_ASSOC'
BEGIN
  db_migration_create_table ('EAMS_WORKSTEP_RULEGROUP_ASSOC',
                             'CREATE TABLE EAMS_WORKSTEP_RULEGROUP_ASSOC '||CHR(10)||
                             '(WORKSTEP_ID NUMBER NOT NULL '||CHR(10)||
                             ',RULEGROUP_ID NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKSTEP_TRANS'
BEGIN
  db_migration_create_table ('EAMS_WORKSTEP_TRANS',
                             'CREATE TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                             '(WORKSTEP_TRANS_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_OP_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_STEP_ID NUMBER NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',INBOUND_RESOURCE_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',OUTBOUND_RESOURCE_MAP_ID NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_BY VARCHAR2(20) '||CHR(10)||
                             ',TRANS_START_TIME NUMBER '||CHR(10)||
                             ',TRANS_END_TIME NUMBER '||CHR(10)||
                             ',RESOURCE_COUNT NUMBER '||CHR(10)||
                             ',RESOURCE_ERROR_COUNT NUMBER '||CHR(10)||
                             ',RESOURCE_COMPLETED_COUNT NUMBER '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_WORKSTEP_TRANS_INFO'
BEGIN
  db_migration_create_table ('EAMS_WORKSTEP_TRANS_INFO',
                             'CREATE TABLE EAMS_WORKSTEP_TRANS_INFO '||CHR(10)||
                             '(WORKSTEP_TRANS_ID NUMBER NOT NULL '||CHR(10)||
                             ',FIELD_NAME VARCHAR2(500) '||CHR(10)||
                             ',FIELD_VALUE VARCHAR2(4000) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_PKG_STORAGE_EVENTS'
BEGIN
  db_migration_create_table ('EAMS_PKG_STORAGE_EVENTS',
                             'CREATE TABLE EAMS_PKG_STORAGE_EVENTS '||CHR(10)||
                             '(EVENT_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',ITEM_CATEGORY_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',ITEM_CATEGORY_VERSION VARCHAR2(10) NOT NULL '||CHR(10)||
                             ',EVENT_TIME NUMBER NOT NULL '||CHR(10)||
                             ',EVENT_USER VARCHAR2(20) '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_PKG_STORAGE_EVENT_DETAILS'
BEGIN
  db_migration_create_table ('EAMS_PKG_STORAGE_EVENT_DETAILS',
                             'CREATE TABLE EAMS_PKG_STORAGE_EVENT_DETAILS '||CHR(10)||
                             '(EVENT_ID NUMBER(10) NOT NULL '||CHR(10)||
                             ',EVENT_MESSAGE_KEY VARCHAR2(100) NOT NULL '||CHR(10)||
                             ',EVENT_MESSAGE_VALUE VARCHAR2(500) NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RM_JOB_AUDIT'
BEGIN
  db_migration_create_table ('EAMS_RM_JOB_AUDIT',
                             'CREATE TABLE EAMS_RM_JOB_AUDIT '||CHR(10)||
                             '(JOB_ID VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_TRANS_ID NUMBER NOT NULL '||CHR(10)||
                             ',SLOTS_OCCUPIED NUMBER NOT NULL '||CHR(10)||
                             ',RESPONSE_COUNT NUMBER '||CHR(10)||
                             ',REQUEST_MODE VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',JOB_SUBMISSION_TIME NUMBER NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER '||CHR(10)||
                             ',CREATE_BY VARCHAR2(100) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(100) '||CHR(10)||
                             ',REQUEST_CONTEXT BLOB  NOT NULL '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

PROMPT Creating Table 'EAMS_RM_ASSET_AUDIT'
BEGIN
  db_migration_create_table ('EAMS_RM_ASSET_AUDIT',
                             'CREATE TABLE EAMS_RM_ASSET_AUDIT  '||CHR(10)||
                             '(JOB_ID VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',JOB_GROUP_NAME VARCHAR2(200) NOT NULL '||CHR(10)||
                             ',NE_ID NUMBER NOT NULL '||CHR(10)||
                             ',WORKFLOW_TRANS_ID NUMBER NOT NULL '||CHR(10)||
                             ',REQUEST_ID VARCHAR2(50) NOT NULL '||CHR(10)||
                             ',OP_ID VARCHAR2(50) '||CHR(10)||
                             ',ADAPTER  VARCHAR2(20) NOT NULL '||CHR(10)||
                             ',ASSET_STATUS VARCHAR2(30) NOT NULL '||CHR(10)||
                             ',CREATE_TIME NUMBER '||CHR(10)||
                             ',CREATE_BY VARCHAR2(100) '||CHR(10)||
                             ',LAST_MODIFY_TIME NUMBER '||CHR(10)||
                             ',LAST_MODIFY_BY VARCHAR2(100) '||CHR(10)||
                             ',RESPONSE_CONTEXT BLOB '||CHR(10)||
                             ') TABLESPACE EAMS_MOT_128K_DAT'
                             );
END;
/

--
-- Add columns 
--

PROMPT Add columns

PROMPT Adding column EAMS_WI_ERROR_LOG.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WI_ERROR_LOG';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_ADAPT_ASSET.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_ADAPT_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_QA_ASSET.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_QA_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INGEST_PACKAGE.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_ASSET.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.LAST_STATUS_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';  
  l_default_value VARCHAR2(30) := '1230782400000';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'UPDATE '||l_table_name||' SET '||l_column_name||' = '||l_default_value||' '||
                    'WHERE '||l_column_name||' IS NULL';
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PKG_APP_DATA.STATUS
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'STATUS';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(30)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PKG_APP_DATA.ITEM_CATEGORY_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'ITEM_CATEGORY_ID';
  l_column_datatype CONSTANT VARCHAR2(30) := 'NUMBER(10)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PKG_APP_DATA.ITEM_CATEGORY_VERSION
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'ITEM_CATEGORY_VERSION';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(10)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PKG_APP_DATA.NE_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'NE_ID';
  l_column_datatype CONSTANT VARCHAR2(30) := 'NUMBER(11)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_VENDOR_METADATA_EXTN.REQUIRED
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_VENDOR_METADATA_EXTN';
  l_column_name CONSTANT VARCHAR2(30) := 'REQUIRED';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(1)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT  Expand EAMS_INGEST_PACKAGE.OPERATION_ID to VARCHAR2(256)
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'EAMS_INGEST_PACKAGE'
  AND    column_name = 'OPERATION_ID';
  
  IF l_data_length < 256 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE EAMS_INGEST_PACKAGE MODIFY OPERATION_ID VARCHAR2(256)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand CCE_ITEM_CATEGORY.ITEM_CAT_ICON_IMAGE_NAME to VARCHAR2(256)
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'CCE_ITEM_CATEGORY'
  AND    column_name = 'ITEM_CAT_ICON_IMAGE_NAME';
  
  IF l_data_length < 256 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE CCE_ITEM_CATEGORY MODIFY ITEM_CAT_ICON_IMAGE_NAME VARCHAR2(256)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT ALTER TABLE eams_media_format MODIFY hdcontent DEFAULT 'N';
ALTER TABLE eams_media_format MODIFY hdcontent DEFAULT 'N';

PROMPT Adding column CCE_RPT_FILTERS.RPT_FIELD_SEQ
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS';
  l_column_name CONSTANT VARCHAR2(30) := 'RPT_FIELD_SEQ';  
  l_default_value VARCHAR2(30) := '1';
  l_column_datatype CONSTANT VARCHAR2(128) := 'NUMBER DEFAULT '||l_default_value;  
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PKG_APP_DATA.PROFILE_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'PROFILE_ID';
  l_column_datatype CONSTANT VARCHAR2(30) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_WORKFLOW_TRANS.REPROCESS
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_TRANS';
  l_column_name CONSTANT VARCHAR2(30) := 'REPROCESS';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(1)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_ASSET.MEDIA_FORMAT_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'MEDIA_FORMAT_ID';
  l_column_datatype CONSTANT VARCHAR2(30) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.TARGET_PLATFORM
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'TARGET_PLATFORM';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(100)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_WORKFLOW_TRANS.WORKFLOW_OP_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_TRANS';
  l_column_name CONSTANT VARCHAR2(30) := 'WORKFLOW_OP_ID';
  l_column_datatype CONSTANT VARCHAR2(30) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT  Expand EAMS_INGEST_PACKAGE.REF_ASSET_ID to VARCHAR2(256)
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'EAMS_INGEST_PACKAGE'
  AND    column_name = 'REF_ASSET_ID';
  
  IF l_data_length < 256 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE EAMS_INGEST_PACKAGE MODIFY REF_ASSET_ID VARCHAR2(256)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand EAMS_INGEST_ASSET.REF_ASSET_ID to VARCHAR2(256)
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'EAMS_INGEST_ASSET'
  AND    column_name = 'REF_ASSET_ID';
  
  IF l_data_length < 256 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE EAMS_INGEST_ASSET MODIFY REF_ASSET_ID VARCHAR2(256)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand EAMS_WI_ERROR_LOG.ERROR_STATUS to VARCHAR2(20)
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'EAMS_WI_ERROR_LOG'
  AND    column_name = 'ERROR_STATUS';
  
  IF l_data_length < 20 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE EAMS_WI_ERROR_LOG MODIFY ERROR_STATUS VARCHAR2(20)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand EAMS_WI_ERROR_LOG.ADAPT_ASSET_ID to VARCHAR2(100) FOR THE CR- LTUSR00047138
DECLARE 
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = 'EAMS_WI_ERROR_LOG'
  AND    column_name = 'ADAPT_ASSET_ID';
  
  IF l_data_length < 100 THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE EAMS_WI_ERROR_LOG MODIFY ADAPT_ASSET_ID VARCHAR2(100)';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT Adding column EAMS_MEDIA_FORMAT.SOURCE_FORMAT
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT';
  l_column_name CONSTANT VARCHAR2(30) := 'SOURCE_FORMAT';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(1) DEFAULT ''Y''';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_MEDIA_FORMAT.TARGET_FORMAT
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT';
  l_column_name CONSTANT VARCHAR2(30) := 'TARGET_FORMAT';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(1) DEFAULT ''Y''';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_MEDIA_FORMAT.METADATA_REQUIRED
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT';
  l_column_name CONSTANT VARCHAR2(30) := 'METADATA_REQUIRED';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(1) DEFAULT ''Y''';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column CCE_RPT_EXPORT_ASSOC.JRXML_FILE_NAME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'JRXML_FILE_NAME';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(50)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column CCE_RPT_EXPORT_ASSOC.DISPLAY_OPT_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'DISPLAY_OPT_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER(4) NOT NULL';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_RM_NE_LOAD_INFO.RESERVED_CAPACITY
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_RM_NE_LOAD_INFO';
  l_column_name CONSTANT VARCHAR2(30) := 'RESERVED_CAPACITY';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER(20)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_CONFIG_REPOSITORY.RECORD_CREATE_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'RECORD_CREATE_TIME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER DEFAULT -1 NOT NULL';
  l_reset_default CONSTANT VARCHAR2(80) := 'NUMBER DEFAULT NULL';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' '||l_reset_default;
END;
/

PROMPT Adding column EAMS_CONFIG_REPOSITORY.USER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'USER_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Make column EAMS_CONFIG_REPOSITORY.VENDOR_ID NULLABLE 
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'VENDOR_ID';
  l_column_datatype VARCHAR2(80) := 'NUMBER(10)';
  l_nullable CHAR(1); 
  l_data_length INTEGER;
  l_temp_table VARCHAR2(30);
  l_stmt VARCHAR2(2048);
  l_cnt_vendor_id INTEGER;
  l_cnt_vid_backup INTEGER;
BEGIN
  SELECT nullable,
         data_length
  INTO   l_nullable,
         l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_nullable = 'N' THEN
     l_column_datatype := l_column_datatype||' NULL';
     l_stmt := 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' '||l_column_datatype;
     
     BEGIN     
       EXECUTE IMMEDIATE l_stmt;
       
       EXCEPTION
         WHEN OTHERS THEN 
              IF SQLCODE = -1440 AND l_data_length > 10 THEN
                 l_temp_table := 'tmp_vendor_id_'||TO_CHAR(SYSDATE, 'hh24miss');
                 
                 EXECUTE IMMEDIATE 'CREATE TABLE '||l_temp_table||' AS SELECT ROWID row_id, vendor_id FROM '||l_table_name||
                                   ' WHERE vendor_id IS NOT NULL';
                 
                 EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||l_temp_table INTO l_cnt_vid_backup;
                 
                 SELECT COUNT(*)
                 INTO   l_cnt_vendor_id
                 FROM   eams_config_repository
                 WHERE  vendor_id IS NOT NULL;
                 
                 IF l_cnt_vid_backup = l_cnt_vendor_id THEN
                    EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' NUMBER NULL';
                    
                    UPDATE eams_config_repository
                    SET    vendor_id = NULL
                    WHERE  vendor_id IS NOT NULL;
                    
                    COMMIT;
                    
                    -- dbms_lock.sleep(30);
                    
                    EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' NUMBER(10)';
                    
                    EXECUTE IMMEDIATE 'UPDATE eams_config_repository a SET vendor_id = (SELECT b.vendor_id FROM '||l_temp_table||
                                      ' b WHERE a.ROWID = b.row_id) WHERE ROWID IN (SELECT row_id FROM '||l_temp_table||')';
                                      
                    COMMIT;
                    
                    SELECT COUNT(*)
                    INTO   l_cnt_vendor_id
                    FROM   eams_config_repository
                    WHERE  vendor_id IS NOT NULL;
                    
                    IF l_cnt_vid_backup = l_cnt_vendor_id THEN
                       EXECUTE IMMEDIATE 'DROP TABLE '||l_temp_table;
                    ELSE
                       raise_application_error(-20000, 'Cannot drop temporary table '||l_temp_table||CHR(10)||
                                                       'l_cnt_vid_backup='||l_cnt_vid_backup||' but l_cnt_vendor_id='||l_cnt_vendor_id);
                    END IF;
                 ELSE
                    raise_application_error(-20000, 'l_cnt_vid_backup='||l_cnt_vid_backup||' but l_cnt_vendor_id='||l_cnt_vendor_id);
                 END IF;
              ELSE
                 RAISE; 
              END IF;
     END;
  END IF;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_CONFIG_REPOSITORY.LAST_MODIFY_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_MODIFY_TIME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_CONFIG_REPOSITORY.SOURCE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'SOURCE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT  Expand EAMS_INGEST_PKG_APP_DATA.APP_DATA_VALUE to VARCHAR2(4000)
DECLARE 
  l_data_length_to_be CONSTANT INTEGER := 4000;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'APP_DATA_VALUE';
    
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_data_length < l_data_length_to_be THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' VARCHAR2('||l_data_length_to_be||')';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand EAMS_PUBLISH_PKG_APP_DATA.APP_DATA_VALUE to VARCHAR2(4000)
DECLARE 
  l_data_length_to_be CONSTANT INTEGER := 4000;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PKG_APP_DATA';
  l_column_name CONSTANT VARCHAR2(30) := 'APP_DATA_VALUE';
    
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_data_length < l_data_length_to_be THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' VARCHAR2('||l_data_length_to_be||')';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.CC_TYPE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'CC_TYPE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(20)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Expand multiple columns to VARCHAR2(4000)
DECLARE
  TYPE obj_varchar_tab IS TABLE OF VARCHAR2(128);
    
  l_tables obj_varchar_tab := obj_varchar_tab('EAMS_INGEST_PACKAGE',
                                              'EAMS_INGEST_PACKAGE',                                              
                                              'CCE_ITEM_CATEGORY',
                                              'EAMS_INGEST_ASSET',
                                              'EAMS_INGEST_ASSET',
                                              'EAMS_ADAPT_ASSET',
                                              'EAMS_ADAPT_ASSET',
                                              'EAMS_QA_ASSET',
                                              'EAMS_QA_ASSET',
                                              'EAMS_PUBLISH_ASSET',
                                              'EAMS_PUBLISH_PACKAGE',
                                              'EAMS_PUBLISH_PACKAGE',
                                              'EAMS_WI_ERROR_LOG');
                                              
  l_columns obj_varchar_tab := obj_varchar_tab('INGEST_LOCATION',
                                               'OPERATION_ID',                                              
                                               'ITEM_CATEGORY_NAME',
                                               'ASSET_NAME',
                                               'ASSET_LOCATION',
                                               'ASSET_LOCATION',
                                               'ADAPT_LOCATION',
                                               'ASSET_LOCATION',
                                               'ASSET_NAME',
                                               'PUBLISH_LOCATION',
                                               'PUBLISH_LOCATION',
                                               'OPERATION_ID',
                                               'LOG_LOCATION');                                              

  l_data_types obj_varchar_tab := obj_varchar_tab(' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',                                              
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)',
                                                  ' VARCHAR2(4000)');                                                           
                                              
  l_data_lengths obj_varchar_tab := obj_varchar_tab('4000',
                                                    '4000',                                              
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000',
                                                    '4000');   
                                                   
  l_data_length INTEGER;                                              
BEGIN
  FOR i IN 1..l_tables.COUNT LOOP
      BEGIN      
        SELECT data_length
        INTO   l_data_length
        FROM   user_tab_columns
        WHERE  table_name = l_tables(i)
        AND    column_name = l_columns(i);
        
        dbms_output.put_line('ALTER TABLE '||l_tables(i)||' MODIFY '||l_columns(i)||l_data_types(i));
        
        IF l_data_length < l_data_lengths(i) THEN  
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_tables(i)||' MODIFY '||l_columns(i)||l_data_types(i);
        END IF;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;       
      END;      
  END LOOP i;                       
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.PRODUCTION_STATE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PRODUCTION_STATE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(30)';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'UPDATE eams_publish_package '||CHR(10)||
                          'SET    production_state = CASE status '||CHR(10)||
                          '                          WHEN ''PUBLISHED'' THEN ''UNKNOWN'' '||CHR(10)||
                          '                          WHEN ''MANUAL_EDIT'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''ERROR'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''PUBLISH_PENDING'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''PUBLISH_PROGRESS'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''TRANSFORM_COMPLETE'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''TRANSFORM_PROGRESS'' THEN ''IN_PROGRESS'' '||CHR(10)||
                          '                          WHEN ''REJECTED'' THEN ''TERMINATED'' '||CHR(10)||
                          '                          WHEN ''INACTIVE'' THEN ''NOT_IN_PRODUCTION'' '||CHR(10)||
                          '                          WHEN ''DELETED'' THEN ''NOT_IN_PRODUCTION'' '||CHR(10)||
                          '                          END'||CHR(10)||
                          'WHERE  production_state IS NULL';
BEGIN
  BEGIN 
    SELECT 1     
    INTO   l_dummy
    FROM   user_tab_columns
    WHERE  table_name = l_table_name
    AND    column_name = l_column_name;
    
        
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
  END;
  
  EXECUTE IMMEDIATE l_sql;                                   
  COMMIT;         
  
  BEGIN 
    EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' '||l_column_datatype||' NOT NULL';
    
    EXCEPTION
      WHEN OTHERS THEN
           IF SQLCODE != -1442 THEN
              RAISE;
           END IF;
  END;  
END;
/

DECLARE
  l_time NUMBER;
BEGIN
  l_time := cce_util#pkg.datetoms(SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.PROD_STATE_CHG_TIME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PROD_STATE_CHG_TIME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;  
  l_time NUMBER := cce_util#pkg.datetoms(SYSDATE);
  l_sql VARCHAR2(1024) := 'UPDATE eams_publish_package '||CHR(10)||
                          'SET    prod_state_chg_time = :in_prod_state_chg_time '||CHR(10)||
                          'WHERE  prod_state_chg_time IS NULL';
BEGIN
  BEGIN
    SELECT 1     
    INTO   l_dummy
    FROM   user_tab_columns
    WHERE  table_name = l_table_name
    AND    column_name = l_column_name;
         
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
  END;
  
  EXECUTE IMMEDIATE l_sql USING l_time;                                
  COMMIT;               
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.PROD_STATE_CHG_USER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PROD_STATE_CHG_USER_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;    
  l_sql VARCHAR2(1024) := 'UPDATE eams_publish_package '||CHR(10)||
                          'SET    prod_state_chg_user_id = :in_prod_state_chg_user_id '||CHR(10)||
                          'WHERE  prod_state_chg_user_id IS NULL';
BEGIN
  BEGIN  
    SELECT 1     
    INTO   l_dummy
    FROM   user_tab_columns
    WHERE  table_name = l_table_name
    AND    column_name = l_column_name;
         
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
  END;

  EXECUTE IMMEDIATE l_sql USING 1;                                
  COMMIT;                        
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.PROD_STATE_CHG_REMARKS
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PROD_STATE_CHG_REMARKS';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(300)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.SUB_STATUS_CODE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'SUB_STATUS_CODE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER(10)';
  l_dummy INTEGER;
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

prompt ALTER EAMS_RM_NE_LOAD_INFO MODIFY NE_ID from NUMBER(3) to NUMBER
ALTER TABLE EAMS_RM_NE_LOAD_INFO MODIFY (NE_ID NUMBER);

prompt ALTER EAMS_RM_NE_LOAD_INFO MODIFY AVAILABLE_CAPACITY from NUMBER(2) to NUMBER(20)
ALTER TABLE EAMS_RM_NE_LOAD_INFO MODIFY (AVAILABLE_CAPACITY NUMBER(20)); 
 
prompt ALTER EAMS_RM_NE_LOAD_INFO MODIFY THRESH_HOLD from NUMBER(2) to NUMBER(20)
ALTER TABLE EAMS_RM_NE_LOAD_INFO MODIFY (THRESH_HOLD NUMBER(20));

PROMPT  Expand CCE_FIELD_INFO.FIELD_XML_TAG to VARCHAR2(200)
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'CCE_FIELD_INFO';
  l_column_name CONSTANT VARCHAR2(30) := 'FIELD_XML_TAG';
  l_data_length INTEGER;
  l_length CONSTANT INTEGER := 200;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_data_length < l_length THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' VARCHAR2('||l_length||')';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT  Expand EAMS_WORKFLOW.WORKFLOW_NAME to VARCHAR2(50)
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW';
  l_column_name CONSTANT VARCHAR2(30) := 'WORKFLOW_NAME';
  l_data_length INTEGER;
  l_length CONSTANT INTEGER := 50;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_data_length < l_length THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' VARCHAR2('||l_length||')';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.CC_REQUIRED
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'CC_REQUIRED';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(1)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.CC_EVAL_CRITERIA
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'CC_EVAL_CRITERIA';
  l_column_datatype CONSTANT VARCHAR2(30) := 'VARCHAR2(200)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_QA_ASSET.MEDIA_CONTEXT
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_QA_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'MEDIA_CONTEXT';
  l_column_datatype CONSTANT VARCHAR2(30) := 'XMLTYPE';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT  Expand EAMS_ADAPT_ASSET.ENCRYPTION_SEED to VARCHAR2(4000)
DECLARE 
  l_data_length_to_be CONSTANT INTEGER := 4000;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_ADAPT_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'ENCRYPTION_SEED';
    
  l_data_length INTEGER;
BEGIN
  SELECT data_length
  INTO   l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_data_length < l_data_length_to_be THEN  
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' VARCHAR2('||l_data_length_to_be||')';
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT Adding column EAMS_INGEST_PACKAGE.PACKAGE_PRIORITY
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PACKAGE_PRIORITY';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER(10)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_PUBLISH_PACKAGE.PACKAGE_PRIORITY
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PACKAGE_PRIORITY';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER(10)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.ASSET_FILE_SIZE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'ASSET_FILE_SIZE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'NUMBER';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INGEST_ASSET.ASSET_CHECKSUM
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET';
  l_column_name CONSTANT VARCHAR2(30) := 'ASSET_CHECKSUM';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(1000)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INFLIGHT_PACKAGE.PROVIDER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INFLIGHT_PACKAGE';
  l_column_name CONSTANT VARCHAR2(30) := 'PROVIDER_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(50)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_INFLIGHT_PLATFORM_ASSOC.PROVIDER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_INFLIGHT_PLATFORM_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'PROVIDER_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(50)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_RESOURCE_ROLE.PROVIDER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE';
  l_column_name CONSTANT VARCHAR2(30) := 'ROLE_DISP_NAME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(100) NOT NULL';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Make EAMS_WORKSTEP_TRANS.OUTBOUND_RESOURCE_MAP_ID NULLABLE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS';
  l_column_name CONSTANT VARCHAR2(30) := 'OUTBOUND_RESOURCE_MAP_ID';
  l_column_datatype VARCHAR2(80) := 'NUMBER';
  l_nullable CHAR(1); 
  l_data_length INTEGER;
  l_temp_table VARCHAR2(30);
  l_stmt VARCHAR2(2048);
  l_cnt_vendor_id INTEGER;
  l_cnt_vid_backup INTEGER;
BEGIN
  SELECT nullable,
         data_length
  INTO   l_nullable,
         l_data_length
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  IF l_nullable = 'N' THEN
     l_column_datatype := l_column_datatype||' NULL';
     l_stmt := 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' '||l_column_datatype;
     
     BEGIN     
       EXECUTE IMMEDIATE l_stmt;
     END;
  END IF;
END;
/  

PROMPT Adding column EAMS_RESOURCE.RESOURCE_PROVIDER_ID
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE';
  l_column_name CONSTANT VARCHAR2(30) := 'RESOURCE_PROVIDER_ID';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(256)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Adding column EAMS_RESOURCE.RESOURCE_PROVIDER_NAME
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE';
  l_column_name CONSTANT VARCHAR2(30) := 'RESOURCE_PROVIDER_NAME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(256)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Make EAMS_WF_RESOURCE_MAP_ASSOC.NEW_WORKFLOW_OP_ID NULLABLE
DECLARE 
  idx INTEGER := 1;
  
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WF_RESOURCE_MAP_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'NEW_WORKFLOW_OP_ID';
  l_column_datatype VARCHAR2(80) := 'NUMBER';
  l_nullable CHAR(1); 
  l_data_length INTEGER;
  l_temp_table VARCHAR2(30);
  l_stmt VARCHAR2(2048);
  l_cnt_vendor_id INTEGER;
  l_cnt_vid_backup INTEGER;
  
  PROCEDURE drop_con_and_make_null IS
  
  BEGIN
    FOR rec IN (SELECT b.*
                FROM   user_cons_columns a,
                       user_constraints b    
                WHERE  a.table_name = l_table_name
                AND    column_name = l_column_name
                AND    a.constraint_name = b.constraint_name
                AND    b.constraint_type = 'P') LOOP
                                                  
        EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||rec.constraint_name;                           
    END LOOP rec;
                 
    EXECUTE IMMEDIATE l_stmt;      
  END drop_con_and_make_null;
  
  PROCEDURE execute_it IS
  
  BEGIN
    SELECT nullable,
           data_length
    INTO   l_nullable,
           l_data_length
    FROM   user_tab_columns
    WHERE  table_name = l_table_name
    AND    column_name = l_column_name;
    
    IF l_nullable = 'N' THEN
       l_column_datatype := l_column_datatype||' NULL';
       l_stmt := 'ALTER TABLE '||l_table_name||' MODIFY '||l_column_name||' '||l_column_datatype;
       
       BEGIN     
         EXECUTE IMMEDIATE l_stmt;
         
         EXCEPTION
           WHEN OTHERS THEN               
                IF SQLCODE = -1451 THEN                 
                   drop_con_and_make_null;
                ELSE
                   RAISE;
                END IF;
       END;
    END IF;  
  END execute_it;
    
  PROCEDURE execute_it2 IS
    
  BEGIN
    execute_it;
         
    EXCEPTION
      WHEN OTHERS THEN               
           IF SQLCODE = -1451 AND idx <= 10 THEN
              idx := idx + 1;                
              execute_it2;
           ELSE
              RAISE;
           END IF;
  END execute_it2;  
  
BEGIN
  execute_it2;
END;
/

PROMPT Adding column EAMS_RESOURCE.WORKSTEP_TYPE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_ROLE_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'WORKSTEP_TYPE';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(50) DEFAULT ''SINGLE-RESOURCE'' ';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD '||l_column_name||' '||l_column_datatype;
END;
/

PROMPT Dropping column EAMS_RESOURCE.WORKSTEP_TYPE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_ROLE_ASSOC';
  l_column_name CONSTANT VARCHAR2(30) := 'RESOURCE_POOL';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
  
  EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP COLUMN '||l_column_name;
       
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;         
END;
/

PROMPT Renaming column EAMS_WORKSTEP_TRANS_INFO.FIELD_ID TO FIELD_NAME 
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_INFO';
  l_column_name CONSTANT VARCHAR2(30) := 'FIELD_ID';
  l_new_column_name CONSTANT VARCHAR2(30) := 'FIELD_NAME';
  l_column_datatype CONSTANT VARCHAR2(80) := 'VARCHAR2(500)';
  l_dummy INTEGER;  
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_tab_columns
  WHERE  table_name = l_table_name
  AND    column_name = l_column_name;
       
  EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' RENAME COLUMN '||l_column_name||' TO '||l_new_column_name;
  EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' MODIFY '||l_new_column_name||' '||l_column_datatype;
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
         
END;
/

--
-- Add constraints
--

PROMPT Create constraints CCE_REPORT_GROUP_PK

PROMPT Create constraint
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_GROUP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_REPORT_GROUP  '||CHR(10)||
                          ' ADD CONSTRAINT CCE_REPORT_GROUP_PK PRIMARY KEY   '||CHR(10)||
                          '  (RPT_GRP_ID)  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';

BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_REPORT_DEF_PK
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_DEF_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_REPORT_DEF  '||CHR(10)||
                          ' ADD CONSTRAINT CCE_REPORT_DEF_PK PRIMARY KEY   '||CHR(10)||
                          '  (REPORT_ID)  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_GRP_ASSOC_PK
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_GRP_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_GRP_ASSOC  '||CHR(10)||
                          ' ADD CONSTRAINT CCE_RPT_GRP_ASSOC_PK PRIMARY KEY   '||CHR(10)||
                          '  (REPORT_GRP_ID, REPORT_ID)  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENCR_AGENT_CONFIG'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENCR_AGENT_CONFIG_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCR_AGENT_CONFIG '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENCR_AGENT_CONFIG_PK PRIMARY KEY  '||CHR(10)||
                          '  (FIELDNAME) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';

BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENCR_AGENT_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENCR_AGENT_TRANS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCR_AGENT_TRANS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENCR_AGENT_TRANS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRANSACTIONID,CONTENTID) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENC_AGENT_CONFIG'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENC_AGENT_CONFIG_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCODE_AGENT_CONFIG '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENC_AGENT_CONFIG_PK PRIMARY KEY  '||CHR(10)||
                          '  (FIELDNAME) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENC_AGENT_PROFILE_MAP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENC_AGENT_PROFILE_MAP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCODE_AGENT_PROFILE_MAP '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENC_AGENT_PROFILE_MAP_PK PRIMARY KEY  '||CHR(10)||
                          '  (ENCODER_SYSTEM_ID,ENCODER_PROFILE_ID) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENC_AGENT_AV_PROFILE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENC_AGENT_AV_PROFILE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCODE_AGENT_AV_PROFILE '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENC_AGENT_AV_PROFILE_PK PRIMARY KEY  '||CHR(10)||
                          '  (AV_PROFILE_ID,NAME) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENC_AGENT_PROF_AV_MAP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENC_AGENT_PROF_AV_MAP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCODE_AGENT_PROF_AV_MAP '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENC_AGENT_PROF_AV_MAP_PK PRIMARY KEY  '||CHR(10)||
                          '  (ENCODER_PROFILE_ID,AV_PROFILE_ID) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_ENC_AGENT_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ENC_AGENT_TRANS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ENCODE_AGENT_TRANS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ENC_AGENT_TRANS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRANSACTIONID,CONTENTID) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_JOB_DETAILS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_JOB_DETAILS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_JOB_DETAILS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_JOB_DETAILS_PK PRIMARY KEY  '||CHR(10)||
                          '  (JOB_NAME '||CHR(10)||
                          '  ,JOB_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_JOB_LISTENERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_JOB_LISTENERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_JOB_LISTENERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_JOB_LISTENERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (JOB_NAME '||CHR(10)||
                          '  ,JOB_GROUP '||CHR(10)||
                          '  ,JOB_LISTENER) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_SIMPLE_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_SIMPLE_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_SIMPLE_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_CRON_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_CRON_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_CRON_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_CRON_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_BLOB_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_BLOB_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_BLOB_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_BLOB_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_TRIGGER_LISTENERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_TRIGGER_LISTENERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_TRIGGER_LISTENERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP '||CHR(10)||
                          '  ,TRIGGER_LISTENER) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_CALENDARS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_CALENDARS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_CALENDARS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_CALENDARS_PK PRIMARY KEY '||CHR(10)||
                          '  (CALENDAR_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_PAUSED_TRIGGER_GRPS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_PAUSED_TRIGGER_GRPS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_PAUSED_TRIGGER_GRPS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_FIRED_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_FIRED_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_FIRED_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_FIRED_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (ENTRY_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_SCHEDULER_STATE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_SCHEDULER_STATE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_SCHEDULER_STATE '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_SCHEDULER_STATE_PK PRIMARY KEY  '||CHR(10)||
                          '  (INSTANCE_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'QRTZ_LOCKS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_LOCKS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_LOCKS '||CHR(10)||
                          ' ADD (CONSTRAINT QRTZ_LOCKS_PK PRIMARY KEY  '||CHR(10)||
                          '  (LOCK_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_ASPERA_SUB_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ASPERA_SUB_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ASPERA_SUB_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_ASPERA_SUB_INFO_PK PRIMARY KEY '||CHR(10)||
                          '  (SUBSCRIPTION_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_RM_NE_LOAD_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_NE_LOAD_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_NE_LOAD_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RM_NE_LOAD_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (NE_ID, AVAILABLE_CAPACITY, STATUS) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_EXPORT_OPTIONS_PK
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_OPTIONS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_EXPORT_OPTIONS  '||CHR(10)||
                          ' ADD CONSTRAINT CCE_RPT_EXPORT_OPTIONS_PK PRIMARY KEY   '||CHR(10)||
                          '  (EXPORT_OPT_ID)  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_JOB_DETAILS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_JOB_DETAILS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_JOB_DETAILS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_JOB_DETAILS_PK PRIMARY KEY  '||CHR(10)||
                          '  (JOB_NAME '||CHR(10)||
                          '  ,JOB_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_JOB_LISTENERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_JOB_LISTENERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_JOB_LISTENERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_JOB_LISTENERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (JOB_NAME '||CHR(10)||
                          '  ,JOB_GROUP '||CHR(10)||
                          '  ,JOB_LISTENER) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_SIMPLE_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_SIMPLE_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_SIMPLE_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_CRON_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_CRON_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_CRON_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_CRON_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_BLOB_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_BLOB_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_BLOB_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_BLOB_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_TRIGGER_LISTENERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_TRIGGER_LISTENERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_TRIGGER_LISTENERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_NAME '||CHR(10)||
                          '  ,TRIGGER_GROUP '||CHR(10)||
                          '  ,TRIGGER_LISTENER) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_CALENDARS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_CALENDARS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_CALENDARS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_CALENDARS_PK PRIMARY KEY '||CHR(10)||
                          '  (CALENDAR_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_PAUSED_TRIGGER_GRPS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_PAUSED_TRG_GRPS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_PAUSED_TRIGGER_GRPS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_PAUSED_TRG_GRPS_PK PRIMARY KEY  '||CHR(10)||
                          '  (TRIGGER_GROUP) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_FIRED_TRIGGERS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FIRED_TRIGGERS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_FIRED_TRIGGERS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_FIRED_TRIGGERS_PK PRIMARY KEY  '||CHR(10)||
                          '  (ENTRY_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_SCHEDULER_STATE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_SCHEDULER_STATE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_SCHEDULER_STATE '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_SCHEDULER_STATE_PK PRIMARY KEY  '||CHR(10)||
                          '  (INSTANCE_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_QRTZ_LOCKS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_LOCKS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_LOCKS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_QRTZ_LOCKS_PK PRIMARY KEY  '||CHR(10)||
                          '  (LOCK_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_DBOARD_VIEW'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_VIEW_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_VIEW '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_VIEW_PK PRIMARY KEY  '||CHR(10)||
                          '  (ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_PI_JOB_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PI_JOB_TRANS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PI_JOB_TRANS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_PI_JOB_TRANS_PK PRIMARY KEY  '||CHR(10)||
                          '  (PI_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'CCE_RPT_EXPORT_ASSOC_PK'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_PK'; 
  l_new_column CONSTANT VARCHAR2(30) := 'DISPLAY_OPT_ID';
  l_dummy INTEGER;    
BEGIN
  BEGIN 
    SELECT 1
    INTO   l_dummy
    FROM   user_cons_columns
    WHERE  constraint_name = l_constraint_name
    AND    column_name = l_new_column;    
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           SELECT COUNT(*)
           INTO   l_dummy
           FROM   user_constraints
           WHERE  constraint_name = l_constraint_name;
           
           IF l_dummy > 0 THEN
              EXECUTE IMMEDIATE 'ALTER TABLE cce_rpt_export_assoc DROP CONSTRAINT '||l_constraint_name;
           END IF; 
           
           EXECUTE IMMEDIATE 'ALTER TABLE cce_rpt_export_assoc ADD CONSTRAINT '||l_constraint_name||' PRIMARY KEY (export_opt_id, report_id, display_opt_id) USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
  END;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_CATCHER_MONITOR'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CATCHER_MONITOR_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CATCHER_MONITOR '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_CATCHER_MONITOR_PK PRIMARY KEY  '||CHR(10)||
                          '  (NE_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_AR_MAP_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_AR_MAP_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_AR_MAP_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_AR_MAP_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (AR_MAP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_RM_POLL_STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_POLL_STATUS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_POLL_STATUS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RM_POLL_STATUS_PK PRIMARY KEY  '||CHR(10)||
                          '  (POLL_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_POLLING_JOBS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_POLLING_JOBS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_POLLING_JOBS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_POLLING_JOBS_PK PRIMARY KEY  '||CHR(10)||
                          '  (JOB_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_AR_MAP_FIELD_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_AR_MAP_FIELD_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_AR_MAP_FIELD_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_AR_MAP_FIELD_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (AR_MAP_ID, FIELD_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_CATCHER_MONITOR_FILES'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CATCHER_MONITOR_FILES_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CATCHER_MONITOR_FILES '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_CATCHER_MONITOR_FILES_PK PRIMARY KEY  '||CHR(10)||
                          '  (ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_WORKFLOW_TRANS_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_TRANS_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_TRANS_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKFLOW_TRANS_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKFLOW_OP_ID, FIELD_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE EAMS_MOT_8M_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_INFLIGHT_PACKAGE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_INFLIGHT_PACKAGE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_INFLIGHT_PACKAGE '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_INFLIGHT_PACKAGE_PK PRIMARY KEY  '||CHR(10)||
                          '  (ALT_CODE, PROVIDER_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE EAMS_MOT_8M_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_INFLIGHT_PLATFORM_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_INF_PLATFORM_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_INFLIGHT_PLATFORM_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_INF_PLATFORM_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (ALT_CODE, PROVIDER_ID, PUBLISH_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE EAMS_MOT_8M_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_PACKAGE_STORAGE_DETAILS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_DETAILS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PACKAGE_STORAGE_DETAILS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_PKG_STORAGE_DETAILS_PK  PRIMARY KEY  '||CHR(10)||
                          '  (ITEM_CATEGORY_ID, ITEM_CATEGORY_VERSION) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD_USER'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_USER_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_USER '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_USER_PK PRIMARY KEY  '||CHR(10)||
                          '  (LOGIN_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_PK PRIMARY KEY  '||CHR(10)||
                          '  (ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD_ITEM'
DECLARE 
  l_table_name VARCHAR2(30);
  l_column_name CONSTANT VARCHAR2(30) := 'ID';
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_ITEM_PK PRIMARY KEY  '||CHR(10)||
                          '  (WIDGET_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  BEGIN 
    SELECT table_name
    INTO   l_table_name
    FROM   user_cons_columns
    WHERE  constraint_name = l_constraint_name
    AND    column_name = l_column_name;
    
    EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' RENAME CONSTRAINT '||l_constraint_name||' TO '||l_table_name||'_PK';
    EXECUTE IMMEDIATE 'ALTER INDEX '||l_constraint_name||' RENAME TO '||l_table_name||'_PK';
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN NULL;
  END;
  
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD_ITEM_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_ITEM_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (WIDGET_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD_USR_ITEM_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_USR_ITEM_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_USR_ITEM_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_USR_ITEM_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (LOGIN_NAME, WIDGET_ID, DBOARD_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_DBOARD_ITEM_PROPS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_PROPS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM_PROPS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_DBOARD_ITEM_PROPS_PK PRIMARY KEY  '||CHR(10)||
                          '  (NAME, WIDGET_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RESOURCE_PK PRIMARY KEY  '||CHR(10)||
                          '  (RESOURCE_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RESOURCE_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (RESOURCE_ID, FIELD_NAME, FIELD_VALUE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE_RESOURCE_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RES_RESOURCE_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_RESOURCE_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RES_RESOURCE_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (RESOURCE_ID, PARENT_RESOURCE_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE_ROLE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RESOURCE_ROLE_PK PRIMARY KEY  '||CHR(10)||
                          '  (ROLE_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE_ROLE_MAP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RESOURCE_ROLE_MAP_PK PRIMARY KEY  '||CHR(10)||
                          '  (RESOURCE_MAP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RESOURCE_ROLE_MAP_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RESOURCE_ROLE_MAP_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (RESOURCE_MAP_ID, FIELD_NAME, FIELD_VALUE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RULEGROUP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RULEGROUP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RULEGROUP '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RULEGROUP_PK PRIMARY KEY  '||CHR(10)||
                          '  (RULEGROUP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKFLOW_OP_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_OP_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_OP_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKFLOW_OP_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKFLOW_OP_ID, FIELD_NAME, FIELD_VALUE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKFLOW_OP_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_OP_TRANS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_OP_TRANS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKFLOW_OP_TRANS_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKFLOW_OP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKFLOW_WORKSTEP_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WF_WORKSTEP_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_WORKSTEP_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WF_WORKSTEP_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_ID, WORKFLOW_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKSTEP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKSTEP_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKSTEP_ROLE_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_ROLE_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_ROLE_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKSTEP_ROLE_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_ID, ROLE_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKSTEP_RULEGROUP_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_RULEGRP_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_RULEGROUP_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKSTEP_RULEGRP_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_ID, RULEGROUP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKSTEP_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKSTEP_TRANS_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_TRANS_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WORKSTEP_TRANS_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_INFO_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS_INFO '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WORKSTEP_TRANS_INFO_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKSTEP_TRANS_ID, FIELD_NAME, FIELD_VALUE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_PKG_STORAGE_EVENTS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_EVENTS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PKG_STORAGE_EVENTS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_PKG_STORAGE_EVENTS_PK PRIMARY KEY  '||CHR(10)||
                          '  (EVENT_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_PKG_STORAGE_EVENT_DETAILS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_EVENT_DET_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PKG_STORAGE_EVENT_DETAILS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_PKG_STORAGE_EVENT_DET_PK PRIMARY KEY  '||CHR(10)||
                          '  (EVENT_ID, EVENT_MESSAGE_KEY) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_WF_RESOURCE_MAP_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WF_RESOURCE_MAP_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WF_RESOURCE_MAP_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_WF_RESOURCE_MAP_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (WORKFLOW_OP_ID, RESOURCE_MAP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'EAMS_RM_JOB_AUDIT'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_JOB_AUDIT_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_JOB_AUDIT '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_RM_JOB_AUDIT_PK PRIMARY KEY '||CHR(10)||
                          '  (JOB_ID, JOB_GROUP_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_REPORT_GROUP_UK1
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_GROUP_UK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_REPORT_GROUP  '||CHR(10)||
                          'ADD CONSTRAINT CCE_REPORT_GROUP_UK1 UNIQUE  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  RPT_GRP_NAME  '||CHR(10)||
                          ')  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_REPORT_DEF_UK1
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_REPORT_DEF_UK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_REPORT_DEF  '||CHR(10)||
                          'ADD CONSTRAINT CCE_REPORT_DEF_UK1 UNIQUE  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_NAME  '||CHR(10)||
                          ')  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_EXPORT_OPTIONS_UK1
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_OPTIONS_UK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_EXPORT_OPTIONS  '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_EXPORT_OPTIONS_UK1 UNIQUE  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  EXPORT_OPT_NAME  '||CHR(10)||
                          ')  '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

-- Constraint CCE_RPT_FILTERS_UK was added on 11/26/2009 based on Pradheep's request 
PROMPT Create constraints CCE_RPT_FILTERS_UK
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_FILTERS '||CHR(10)||
                          ' ADD (CONSTRAINT CCE_RPT_FILTERS_UK UNIQUE  '||CHR(10)||
                          '  (REPORT_ID '||CHR(10)||
                          '  ,RPT_FIELD_NAME) USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Primary Key on 'CCE_USER_VENDOR_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_USER_VENDOR_ASSOC_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_USER_VENDOR_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT CCE_USER_VENDOR_ASSOC_PK PRIMARY KEY  '||CHR(10)||
                          '  (USER_VENDOR_ID) USING INDEX TABLESPACE EAMS_MOT_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_MEDIA_FORMAT_INFO_PK'
DECLARE
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT_INFO_PK';
  l_new_column CONSTANT VARCHAR2(30) := 'FIELD_VALUE';
  l_dummy INTEGER;
BEGIN
  BEGIN
    SELECT 1
    INTO   l_dummy
    FROM   user_cons_columns
    WHERE  constraint_name = l_constraint_name
    AND    column_name = l_new_column;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           BEGIN 
             SELECT 1
             INTO   l_dummy
             FROM   user_constraints
             WHERE  constraint_name = l_constraint_name;
           
             EXECUTE IMMEDIATE 'ALTER TABLE eams_media_format_info DROP CONSTRAINT '||l_constraint_name;
             
             EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;              
           END;
           
           BEGIN 
             SELECT 1
             INTO   l_dummy
             FROM   user_indexes
             WHERE  index_name = l_constraint_name;
           
             EXECUTE IMMEDIATE 'DROP INDEX '||l_constraint_name;
             
             EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;              
           END;           
                       
           EXECUTE IMMEDIATE 'ALTER TABLE eams_media_format_info ADD CONSTRAINT '||l_constraint_name||' PRIMARY KEY (media_format_id, field_id,field_value) USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
  END;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_CONFIG_REPOSITORY'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CONFIG_REPOSITORY '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_CONFIG_REPOSITORY_PK PRIMARY KEY  '||CHR(10)||
                          '  (ID, VERSION) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'CCE_RPT_DISPLAY_OPTIONS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_DISPLAY_OPTIONS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_DISPLAY_OPTIONS '||CHR(10)||
                          ' ADD (CONSTRAINT CCE_RPT_DISPLAY_OPTIONS_PK PRIMARY KEY  '||CHR(10)||
                          '  (DISPLAY_OPT_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Add COLUMN VERSION TO CONSTRAINT 'EAMS_CONFIG_REPOSITORY_PK'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY'; 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY_PK'; 
  l_new_column CONSTANT VARCHAR2(30) := 'VERSION';
  l_dummy INTEGER;    
BEGIN
  BEGIN 
    SELECT 1
    INTO   l_dummy
    FROM   user_cons_columns
    WHERE  constraint_name = l_constraint_name
    AND    column_name = l_new_column;    
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name;
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD CONSTRAINT '||l_constraint_name||' PRIMARY KEY (ID, VERSION) USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
  END;
END;
/  

PROMPT Creating PRIMARY KEY ON 'EAMS_INGEST_ASSET_ASSET_ASSOC'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_INGEST_ASSET_ASSET_ASS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_INGEST_ASSET_ASSET_ASSOC '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_INGEST_ASSET_ASSET_ASS_PK PRIMARY KEY  '||CHR(10)||
                          '  (ITEM_CATEGORY_ID, ITEM_CATEGORY_VERSION,ASSET_ID,ASSOC_ASSET_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating PRIMARY KEY ON 'EAMS_PUBLISH_SUB_STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_SUB_STATUS_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PUBLISH_SUB_STATUS '||CHR(10)||
                          ' ADD (CONSTRAINT EAMS_PUBLISH_SUB_STATUS_PK PRIMARY KEY  '||CHR(10)||
                          '  (SUB_STATUS_CODE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT -- Check and rebuild unique constraint of EAMS_QA_ASSET
DECLARE 
  l_constraint_exists BOOLEAN := FALSE;
  l_diff_definition BOOLEAN := FALSE;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_QA_ASSET'; 
  l_a_column CONSTANT VARCHAR2(30) := 'ITEM_CATEGORY_ID';
  l_constraint_name VARCHAR2(30);
  l_sql VARCHAR2(1024);    
BEGIN
  BEGIN 
    SELECT a.constraint_name
    INTO   l_constraint_name
    FROM   user_constraints a,
           user_cons_columns b
    WHERE  a.table_name = l_table_name
    AND    b.table_name = l_table_name
    AND    constraint_type = 'U'
    AND    a.constraint_name = b.constraint_name
    AND    column_name = l_a_column;    
    
    l_constraint_exists := TRUE;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           l_constraint_name := l_table_name||'_UK';    
  END;
  
  IF l_constraint_exists THEN 
     FOR rec IN (SELECT column_name
                 FROM   (SELECT 'ITEM_CATEGORY_ID' column_name
                         FROM   dual
                         UNION  ALL 
                         SELECT 'ITEM_CATEGORY_VERSION' column_name
                         FROM   dual
                         UNION  ALL 
                         SELECT 'PROVIDER_ASSET_ID' column_name
                         FROM   dual
                         UNION  ALL 
                         SELECT 'NE_ID' column_name
                         FROM   dual
                         UNION  ALL 
                         SELECT 'PROFILE_ID' column_name
                         FROM   dual
                         UNION  ALL 
                         SELECT 'WORKFLOW_TRANS_ID' column_name
                         FROM   dual) 
                 MINUS         
                 SELECT column_name
                 FROM   user_cons_columns
                 WHERE  constraint_name = l_constraint_name) LOOP
         l_diff_definition := TRUE;        
         EXIT;
     END LOOP rec;  
     
     IF l_diff_definition THEN
        EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name;
     END IF;
  END IF;
  
  FOR rec IN (SELECT a.index_name
              FROM   user_indexes a,
                     user_ind_columns b
              WHERE  uniqueness = 'UNIQUE'
              AND    a.table_name = l_table_name
              AND    a.index_name = b.index_name
              AND    column_name = l_a_column) LOOP
                                          
      FOR inn IN (SELECT column_name
                  FROM   (SELECT 'ITEM_CATEGORY_ID' column_name
                          FROM   dual
                          UNION  ALL 
                          SELECT 'ITEM_CATEGORY_VERSION' column_name
                          FROM   dual
                          UNION  ALL 
                          SELECT 'PROVIDER_ASSET_ID' column_name
                          FROM   dual
                          UNION  ALL 
                          SELECT 'NE_ID' column_name
                          FROM   dual
                          UNION  ALL 
                          SELECT 'PROFILE_ID' column_name
                          FROM   dual
                          UNION  ALL 
                          SELECT 'WORKFLOW_TRANS_ID' column_name
                          FROM   dual) 
                  MINUS         
                  SELECT column_name
                  FROM   user_ind_columns 
                  WHERE  index_name = rec.index_name) LOOP
          l_diff_definition := TRUE;        
          EXIT;
      END LOOP inn;  
      
      IF l_diff_definition THEN
         EXECUTE IMMEDIATE 'DROP INDEX '||rec.index_name;
         l_diff_definition := FALSE;
      END IF;
                   
  END LOOP rec;  
  
  BEGIN 
    SELECT a.constraint_name
    INTO   l_constraint_name
    FROM   user_constraints a,
           user_cons_columns b
    WHERE  a.table_name = l_table_name
    AND    b.table_name = l_table_name
    AND    constraint_type = 'U'
    AND    a.constraint_name = b.constraint_name
    AND    column_name = l_a_column;    
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD CONSTRAINT '||l_constraint_name||' '||
                             'UNIQUE (ITEM_CATEGORY_ID, ITEM_CATEGORY_VERSION, PROVIDER_ASSET_ID, NE_ID, PROFILE_ID, WORKFLOW_TRANS_ID) '||
                             'USING INDEX TABLESPACE EAMS_MOT_128K_IDX';  
  END;    
END;
/

PROMPT -- Check and rebuild unique constraint of EAMS_ADAPT_ASSET
DECLARE 
  l_constraint_exists BOOLEAN := FALSE;
  l_diff_definition BOOLEAN := FALSE;
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_ADAPT_ASSET'; 
  l_a_column CONSTANT VARCHAR2(30) := 'ITEM_CATEGORY_ID';
  l_constraint_name VARCHAR2(30);
  l_sql VARCHAR2(1024);    
BEGIN
  BEGIN 
    SELECT a.constraint_name
    INTO   l_constraint_name
    FROM   user_constraints a,
           user_cons_columns b
    WHERE  a.table_name = l_table_name
    AND    b.table_name = l_table_name
    AND    constraint_type = 'U'
    AND    a.constraint_name = b.constraint_name
    AND    column_name = l_a_column;    
    
    l_constraint_exists := TRUE;
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           l_constraint_name := l_table_name||'_UK';    
  END;
  
  IF l_constraint_exists THEN 
     FOR rec IN (SELECT 'ITEM_CATEGORY_ID' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'ITEM_CATEGORY_VERSION' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'PROVIDER_ASSET_ID' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'ADAPT_ASSET_ID' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'NE_ID' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'PROFILE_ID' column_name
                 FROM   dual
                 UNION  ALL 
                 SELECT 'WORKFLOW_TRANS_ID' column_name
                 FROM   dual 
                 MINUS         
                 SELECT column_name
                 FROM   user_cons_columns 
                 WHERE  constraint_name = l_constraint_name) LOOP
         l_diff_definition := TRUE;        
         EXIT;
     END LOOP rec;  
     
     IF l_diff_definition THEN
        EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name;
     END IF;
  END IF;
  
  FOR rec IN (SELECT a.index_name
              FROM   user_indexes a,
                     user_ind_columns b
              WHERE  uniqueness = 'UNIQUE'
              AND    a.table_name = l_table_name
              AND    a.index_name = b.index_name
              AND    column_name = l_a_column) LOOP
                                          
      FOR inn IN (SELECT 'ITEM_CATEGORY_ID' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'ITEM_CATEGORY_VERSION' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'PROVIDER_ASSET_ID' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'ADAPT_ASSET_ID' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'NE_ID' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'PROFILE_ID' column_name
                  FROM   dual
                  UNION  ALL 
                  SELECT 'WORKFLOW_TRANS_ID' column_name
                  FROM   dual 
                  MINUS         
                  SELECT column_name
                  FROM   user_ind_columns 
                  WHERE  index_name = rec.index_name) LOOP
          l_diff_definition := TRUE;        
          EXIT;
      END LOOP inn;  
      
      IF l_diff_definition THEN
         EXECUTE IMMEDIATE 'DROP INDEX '||rec.index_name;
         l_diff_definition := FALSE;
      END IF;
                   
  END LOOP rec;  
  
  BEGIN 
    SELECT a.constraint_name
    INTO   l_constraint_name
    FROM   user_constraints a,
           user_cons_columns b
    WHERE  a.table_name = l_table_name
    AND    b.table_name = l_table_name
    AND    constraint_type = 'U'
    AND    a.constraint_name = b.constraint_name
    AND    column_name = l_a_column;    
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD CONSTRAINT '||l_constraint_name||' '||
                             'UNIQUE (ITEM_CATEGORY_ID, ITEM_CATEGORY_VERSION, PROVIDER_ASSET_ID, ADAPT_ASSET_ID, NE_ID,PROFILE_ID,WORKFLOW_TRANS_ID) '||
                             ' USING INDEX TABLESPACE EAMS_MOT_128K_IDX';      
  END;    
END;
/

PROMPT Creating Unique Key on 'EAMS_DBOARD_VIEW'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_VIEW_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_VIEW '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_DBOARD_VIEW_UK UNIQUE '||CHR(10)||
                          '( '||CHR(10)||
                          '  NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'EAMS_ADAPT_ASSET_INFO'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ADAPT_ASSET_INFO_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ADAPT_ASSET_INFO '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_ADAPT_ASSET_INFO_UK UNIQUE '||CHR(10)||
                          '(ADAPT_ASSET_ID, FIELD_ID, FIELD_VALUE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'CCE_RPT_DISPLAY_OPTIONS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_DISPLAY_OPTIONS_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_DISPLAY_OPTIONS '||CHR(10)||
                          'ADD (CONSTRAINT CCE_RPT_DISPLAY_OPTIONS_UK UNIQUE '||CHR(10)||
                          '(DISPLAY_OPT_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'EAMS_POLLING_JOBS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_POLLING_JOBS_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_POLLING_JOBS '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_POLLING_JOBS_UK UNIQUE '||CHR(10)||
                          '(JOB_NAME, IMPL_CLASS) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'EAMS_RESOURCE_ROLE_MAP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_RESOURCE_ROLE_MAP_UK UNIQUE '||CHR(10)||
                          '(RESOURCE_ID, ROLE_ID, ROLE_TYPE) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'EAMS_RULEGROUP'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RULEGROUP_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RULEGROUP '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_RULEGROUP_UK UNIQUE '||CHR(10)||
                          '(RULEGROUP_NAME) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Unique Key on 'EAMS_WORKSTEP_TRANS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_UK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          'ADD (CONSTRAINT EAMS_WORKSTEP_TRANS_UK UNIQUE '||CHR(10)||
                          '(WORKFLOW_STEP_ID, WORKFLOW_OP_ID, INBOUND_RESOURCE_MAP_ID) '||CHR(10)||
                          'USING INDEX TABLESPACE LEAPSTONE_128K_IDX)';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating UNIQUE KEY ON 'EAMS_WORKFLOW_PROFILE_ASSOC_UK'
DECLARE
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_PROFILE_ASSOC';
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_PROFILE_ASSOC_UK';
  l_new_column CONSTANT VARCHAR2(30) := 'JOB_ID';
  l_dummy INTEGER;
BEGIN
  BEGIN
    SELECT 1
    INTO   l_dummy
    FROM   user_cons_columns
    WHERE  constraint_name = l_constraint_name
    AND    column_name = l_new_column;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           BEGIN 
             SELECT 1
             INTO   l_dummy
             FROM   user_constraints
             WHERE  constraint_name = l_constraint_name;
           
             EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name;
             
             EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;              
           END;
           
           BEGIN 
             SELECT 1
             INTO   l_dummy
             FROM   user_indexes
             WHERE  index_name = l_constraint_name;
           
             EXECUTE IMMEDIATE 'DROP INDEX '||l_constraint_name;
             
             EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;              
           END;           
                       
           EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' ADD CONSTRAINT '||l_constraint_name||' UNIQUE (WORKFLOW_ID, PROFILE_ID, JOB_ID) USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
  END;
END;
/

PROMPT Create constraints CCE_RPT_GRP_ASSOC_CCE_REP_FK2
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_GRP_ASSOC_CCE_REP_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_GRP_ASSOC  '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_GRP_ASSOC_CCE_REP_FK2 FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_GRP_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_REPORT_GROUP  '||CHR(10)||
                          '(  '||CHR(10)||
                          'RPT_GRP_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_FILTERS_CCE_REPOR_FK1
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS_CCE_REPOR_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_FILTERS  '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_FILTERS_CCE_REPOR_FK1 FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_REPORT_DEF  '||CHR(10)||
                          '(  '||CHR(10)||
                          'REPORT_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_EXPORT_ASSOC_CCE_R_FK1
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_CCE_R_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_EXPORT_ASSOC  '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_EXPORT_ASSOC_CCE_R_FK1 FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  REPORT_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_REPORT_DEF  '||CHR(10)||
                          '(  '||CHR(10)||
                          'REPORT_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create constraints CCE_RPT_EXPORT_ASSOC_CCE_R_FK2
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_CCE_R_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_EXPORT_ASSOC  '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_EXPORT_ASSOC_CCE_R_FK2 FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  EXPORT_OPT_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_RPT_EXPORT_OPTIONS  '||CHR(10)||
                          '(  '||CHR(10)||
                          'EXPORT_OPT_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'CCE_USER_VENDOR_ASSOC_FK'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_USER_VENDOR_ASSOC_FK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_USER_VENDOR_ASSOC  '||CHR(10)||
                          'ADD CONSTRAINT CCE_USER_VENDOR_ASSOC_FK FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  USER_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_USER  '||CHR(10)||
                          '(  '||CHR(10)||
                          'USER_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'CCE_USER_VENDOR_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_USER_VENDOR_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_USER_VENDOR_ASSOC  '||CHR(10)||
                          'ADD CONSTRAINT CCE_USER_VENDOR_ASSOC_FK1 FOREIGN KEY  '||CHR(10)||
                          '(  '||CHR(10)||
                          '  VENDOR_ID  '||CHR(10)||
                          ')  '||CHR(10)||
                          'REFERENCES CCE_VENDOR_INFO  '||CHR(10)||
                          '(  '||CHR(10)||
                          'VENDOR_ID  '||CHR(10)||
                          ')';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_JOB_LISTENERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_JOB_LISTENERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_JOB_LISTENERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_JOB_LISTENERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_JOB_DETAILS '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_JOB_DETAILS '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_SIMPLE_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_SIMPLE_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_SIMPLE_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_CRON_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_CRON_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_CRON_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_CRON_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_BLOB_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_BLOB_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_BLOB_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_BLOB_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'QRTZ_TRIGGER_LISTENERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'QRTZ_TRIGGER_LISTENERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                          'ADD CONSTRAINT QRTZ_TRIGGER_LISTENERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_MEDIA_FORMAT_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_MEDIA_FORMAT_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_MEDIA_FORMAT_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  MEDIA_FORMAT_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_MEDIA_FORMAT '||CHR(10)||
                          '( '||CHR(10)||
                          '  MEDIA_FORMAT_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_PUBLISH_ASSET_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_ASSET_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PUBLISH_ASSET '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PUBLISH_ASSET_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  MEDIA_FORMAT_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_MEDIA_FORMAT '||CHR(10)||
                          '( '||CHR(10)||
                          '  MEDIA_FORMAT_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

/*
-- removed on 08/02/2010, requested by Maheswar
PROMPT Creating Foreign Key 'EAMS_RM_NE_LOAD_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_NE_LOAD_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_NE_LOAD_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RM_NE_LOAD_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID  '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_NETWORK_ELEMENT '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/
*/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_JOB_LISTENERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_JOB_LISTENERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_JOB_LISTENERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_JOB_LISTENERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_JOB_DETAILS '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_JOB_DETAILS '||CHR(10)||
                          '( '||CHR(10)||
                          '  JOB_NAME,JOB_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_SIMPLE_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_SIMPLE_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_SIMPLE_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_SIMPLE_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_CRON_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_CRON_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_CRON_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_CRON_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_BLOB_TRIGGERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_BLOB_TRIGGERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_BLOB_TRIGGERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_BLOB_TRIGGERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key on 'EAMS_QRTZ_TRG_LISTENERS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_TRG_LISTENERS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_QRTZ_TRIGGER_LISTENERS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_QRTZ_TRG_LISTENERS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_QRTZ_TRIGGERS '||CHR(10)||
                          '( '||CHR(10)||
                          '  TRIGGER_NAME,TRIGGER_GROUP '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

/*
-- removed on 08/02/2010, requested by Maheswar
PROMPT Creating Foreign Key 'EAMS_PI_JOB_TRANS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PI_JOB_TRANS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PI_JOB_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PI_JOB_TRANS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_NETWORK_ELEMENT '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/
*/

PROMPT Creating Foreign Key 'EAMS_PI_JOB_TRANS_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PI_JOB_TRANS_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PI_JOB_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PI_JOB_TRANS_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  WORKFLOW_TRANS_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKFLOW_TRANS '||CHR(10)||
                          '( '||CHR(10)||
                          '  WORKFLOW_TRANS_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'CCE_RPT_EXPORT_ASSOC_CCE_R_FK3'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_CCE_R_FK3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE CCE_RPT_EXPORT_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT CCE_RPT_EXPORT_ASSOC_CCE_R_FK3 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'DISPLAY_OPT_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_RPT_DISPLAY_OPTIONS '||CHR(10)||
                          '( '||CHR(10)||
                          'DISPLAY_OPT_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_PUBLISH_PACKAGE_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PUBLISH_PACKAGE_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PUBLISH_PACKAGE '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PUBLISH_PACKAGE_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  SUB_STATUS_CODE '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_PUBLISH_SUB_STATUS '||CHR(10)||
                          '( '||CHR(10)||
                          '  SUB_STATUS_CODE '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_AR_MAP_FIELD_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_AR_MAP_FIELD_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_AR_MAP_FIELD_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_AR_MAP_FIELD_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  FIELD_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_FIELD_INFO '||CHR(10)||
                          '( '||CHR(10)||
                          '  FIELD_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_CATCHER_MONITOR_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CATCHER_MONITOR_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CATCHER_MONITOR '||CHR(10)||
                          'ADD CONSTRAINT EAMS_CATCHER_MONITOR_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_NETWORK_ELEMENT '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RM_POLL_STATUS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_POLL_STATUS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_POLL_STATUS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RM_POLL_STATUS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_NETWORK_ELEMENT '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_CATCHER_MONITOR_FILES_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CATCHER_MONITOR_FILES_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CATCHER_MONITOR_FILES '||CHR(10)||
                          'ADD CONSTRAINT EAMS_CATCHER_MONITOR_FILES_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_NETWORK_ELEMENT '||CHR(10)||
                          '( '||CHR(10)||
                          '  NE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKFLOW_TRANS_INFO_FK1'
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_TRANS_INFO';
  l_r_constraint_name CONSTANT VARCHAR2(30) := 'CCE_UFIELD_INFO_FLDID_PK';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_TRANS_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKFLOW_TRANS_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'FIELD_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_USER_FIELD_INFO '||CHR(10)||
                          '( '||CHR(10)||
                            'FIELD_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  table_name = l_table_name
  AND    constraint_type = 'R'
  AND    r_constraint_name = l_r_constraint_name;  
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_INF_PLATFORM_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_INF_PLATFORM_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_INFLIGHT_PLATFORM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_INF_PLATFORM_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  ALT_CODE, '||CHR(10)||
                          '  PROVIDER_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_INFLIGHT_PACKAGE '||CHR(10)||
                          '( '||CHR(10)||
                          '  ALT_CODE, '||CHR(10)||
                          '  PROVIDER_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;END;
/

PROMPT Creating Foreign Key 'EAMS_INF_PLATFORM_ASSOC_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_INF_PLATFORM_ASSOC_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_INFLIGHT_PLATFORM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_INF_PLATFORM_ASSOC_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  PUBLISH_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_PUBLISH_PACKAGE '||CHR(10)||
                          '( '||CHR(10)||
                          '  PUBLISH_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_ITEM_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_ITEM_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  DBOARD_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD '||CHR(10)||
                          '( '||CHR(10)||
                          '  ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_ITEM_ASSOC_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_ASSOC_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_ITEM_ASSOC_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD_ITEM '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_USR_ITEM_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_USR_ITEM_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_USR_ITEM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_USR_ITEM_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  LOGIN_NAME '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD_USER '||CHR(10)||
                          '( '||CHR(10)||
                          '  LOGIN_NAME '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_USR_ITEM_ASSOC_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_USR_ITEM_ASSOC_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_USR_ITEM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_USR_ITEM_ASSOC_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD_ITEM_ASSOC '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_USR_ITEM_ASSOC_FK3'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_USR_ITEM_ASSOC_FK3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_USR_ITEM_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_USR_ITEM_ASSOC_FK3 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  DBOARD_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD '||CHR(10)||
                          '( '||CHR(10)||
                          '  ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_DBOARD_ITEM_PROPS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_DBOARD_ITEM_PROPS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_DBOARD_ITEM_PROPS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_DBOARD_ITEM_PROPS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_DBOARD_ITEM '||CHR(10)||
                          '( '||CHR(10)||
                          '  WIDGET_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_TRANS_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_TRANS_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_TRANS_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKSTEP_TRANS '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_TRANS_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RES_RESOURCE_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RES_RESOURCE_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_RESOURCE_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RES_RESOURCE_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RESOURCE_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RESOURCE_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RESOURCE_ROLE_MAP_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RESOURCE_ROLE_MAP_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RESOURCE_ROLE_MAP_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RESOURCE_ROLE_MAP_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'ROLE_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE_ROLE '||CHR(10)||
                          '( '||CHR(10)||
                            'ROLE_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_ROLE_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_ROLE_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_ROLE_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_ROLE_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKSTEP '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WF_RES_MAP_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WF_RES_MAP_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WF_RESOURCE_MAP_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WF_RES_MAP_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_RES_ROLE_MAP_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RES_ROLE_MAP_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_RES_ROLE_MAP_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKFLOW_OP_INFO_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_OP_INFO_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_OP_INFO '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKFLOW_OP_INFO_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKFLOW_OP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKFLOW_OP_TRANS '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKFLOW_OP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_RG_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_RG_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_RULEGROUP_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_RG_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKSTEP '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_RG_ASSOC_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_RG_ASSOC_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_RULEGROUP_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_RG_ASSOC_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'RULEGROUP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RULEGROUP '||CHR(10)||
                          '( '||CHR(10)||
                            'RULEGROUP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_TRANS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_TRANS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKFLOW_STEP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKSTEP '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_TRANS_FK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_FK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_TRANS_FK2 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKFLOW_OP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKFLOW_OP_TRANS '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKFLOW_OP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WF_WORKSTEP_ASSOC_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WF_WORKSTEP_ASSOC_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_WORKSTEP_ASSOC '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WF_WORKSTEP_ASSOC_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_WORKSTEP '||CHR(10)||
                          '( '||CHR(10)||
                            'WORKSTEP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_TRANS_FK3'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_FK3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_TRANS_FK3 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'OUTBOUND_RESOURCE_MAP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_WORKSTEP_TRANS_FK4'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_FK4';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_WORKSTEP_TRANS_FK4 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'INBOUND_RESOURCE_MAP_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_RESOURCE_ROLE_MAP '||CHR(10)||
                          '( '||CHR(10)||
                            'RESOURCE_MAP_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_PKG_STORAGE_DETAILS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_DETAILS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PACKAGE_STORAGE_DETAILS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PKG_STORAGE_DETAILS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                            'ITEM_CATEGORY_ID, '||CHR(10)||
                            'ITEM_CATEGORY_VERSION '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_ITEM_CATEGORY '||CHR(10)||
                          '( '||CHR(10)||
                            'ITEM_CATEGORY_ID, '||CHR(10)||
                            'ITEM_CATEGORY_VERSION '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_PKG_STORAGE_EVENTS_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_EVENTS_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PKG_STORAGE_EVENTS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PKG_STORAGE_EVENTS_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  ITEM_CATEGORY_ID, '||CHR(10)||
                          '  ITEM_CATEGORY_VERSION '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES CCE_ITEM_CATEGORY '||CHR(10)||
                          '( '||CHR(10)||
                          '  ITEM_CATEGORY_ID, '||CHR(10)||
                          '  ITEM_CATEGORY_VERSION '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating Foreign Key 'EAMS_PKG_STORAGE_EVENT_DET_FK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_EVENT_DET_FK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PKG_STORAGE_EVENT_DETAILS '||CHR(10)||
                          'ADD CONSTRAINT EAMS_PKG_STORAGE_EVENT_DET_FK1 FOREIGN KEY '||CHR(10)||
                          '( '||CHR(10)||
                          '  EVENT_ID '||CHR(10)||
                          ') '||CHR(10)||
                          'REFERENCES EAMS_PKG_STORAGE_EVENTS '||CHR(10)||
                          '( '||CHR(10)||
                          '  EVENT_ID '||CHR(10)||
                          ') ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

-- removed on 08/02/2010, requested by Maheswar
PROMPT Drop Foreign Key on 'EAMS_RM_NE_LOAD_INFO_FK1'
DECLARE
  l_dummy INTEGER;
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_cons_columns
  WHERE  constraint_name = 'EAMS_RM_NE_LOAD_INFO_FK1'
  AND    column_name = 'NE_ID';
  
  EXECUTE IMMEDIATE 'ALTER TABLE EAMS_RM_NE_LOAD_INFO DROP CONSTRAINT EAMS_RM_NE_LOAD_INFO_FK1';
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         NULL;
END;
/

-- removed on 08/02/2010, requested by Maheswar
PROMPT Drop Foreign Key on 'EAMS_PI_JOB_TRANS_FK1'
DECLARE
  l_dummy INTEGER;
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_cons_columns
  WHERE  constraint_name = 'EAMS_PI_JOB_TRANS_FK1'
  AND    column_name = 'NE_ID';
  
  EXECUTE IMMEDIATE 'ALTER TABLE EAMS_PI_JOB_TRANS DROP CONSTRAINT EAMS_PI_JOB_TRANS_FK1';
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN 
         NULL;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKFLOW_TRANS.REPROCESS'
DECLARE 
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_TRANS ADD CONSTRAINT EAMS_WORKFLOW_TRANS_CK1 CHECK (REPROCESS IN (''Y'', ''N'') OR REPROCESS IS NULL)';
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_cons_columns a,
         user_constraints b
  WHERE  a.table_name = 'EAMS_WORKFLOW_TRANS'
  AND    b.table_name = 'EAMS_WORKFLOW_TRANS'
  AND    a.constraint_name = b.constraint_name
  AND    b.constraint_type = 'C'
  AND    column_name = 'REPROCESS'
  AND    ROWNUM = 1;  
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint 'EAMS_ASPERA_SUB_INFO_CK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ASPERA_SUB_INFO_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ASPERA_SUB_INFO ADD CONSTRAINT EAMS_ASPERA_SUB_INFO_CK1  '||CHR(10)||
                          'CHECK (SUBSCRIPTION_STATUS IN (''ACTIVE'', ''INACTIVE'', ''EXPIRED'')) ';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint 'EAMS_ASPERA_SUB_INFO_CK2'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_ASPERA_SUB_INFO_CK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_ASPERA_SUB_INFO ADD CONSTRAINT EAMS_ASPERA_SUB_INFO_CK2  '||CHR(10)||
                          'CHECK (SUBSCRIPTION_REQUIRED IN (''Y'', ''N''))';                        
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint 'EAMS_RM_NE_LOAD_INFO_CK1'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_NE_LOAD_INFO_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_NE_LOAD_INFO ADD CONSTRAINT EAMS_RM_NE_LOAD_INFO_CK1 CHECK (STATUS IN (1, 0))';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

DECLARE 
  l_old_ck BOOLEAN := FALSE;
  l_search_condition VARCHAR2(32000);
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WI_ERR_STATUS_CHECK';
  l_sql VARCHAR2(2048) := 'ALTER TABLE EAMS_WI_ERROR_LOG DROP CONSTRAINT EAMS_WI_ERR_STATUS_CHECK';    
BEGIN
  BEGIN 
    SELECT search_condition
    INTO   l_search_condition
    FROM   user_constraints
    WHERE  constraint_name = l_constraint_name;
    
    IF l_search_condition NOT LIKE '%MANUAL_ASSIGNED%' THEN
       l_old_ck := TRUE;
    END IF;
       
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           l_old_ck := NULL;         
  END;
  
  IF l_old_ck THEN
     EXECUTE IMMEDIATE l_sql;
  END IF;
  
  IF NVL(l_old_ck, TRUE) THEN     
     l_sql := 'ALTER TABLE EAMS_WI_ERROR_LOG ADD CONSTRAINT EAMS_WI_ERR_STATUS_CHECK '||CHR(10)||
              'CHECK (ERROR_STATUS IN (''ERROR'',''ASSIGNED'',''PROGRESS'',''RESOLVED'',''REJECTED'',''MANUAL_ASSIGNED'',''MANUAL_COMPLETED'',''MANUAL_PROCEED'',''MANUAL_REJECTED''))';

     EXECUTE IMMEDIATE l_sql;  
  END IF; 
END;
/

PROMPT Creating check constraint 'EAMS_WI_STATUS_CHECK'
DECLARE 
  l_old_ck BOOLEAN := FALSE;
  l_search_condition VARCHAR2(32000);
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_WI_ERROR_LOG';
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WI_STATUS_CHECK';
  l_new_ck_values VARCHAR2(80) := '%CORRELATION_ERROR%';
  l_sql VARCHAR2(2048) := 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name;    
BEGIN
  BEGIN 
    SELECT search_condition
    INTO   l_search_condition
    FROM   user_constraints
    WHERE  constraint_name = l_constraint_name;
    
    IF l_search_condition NOT LIKE l_new_ck_values THEN
       l_old_ck := TRUE;
    END IF;
       
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           l_old_ck := NULL;         
  END;
  
  IF l_old_ck THEN
     EXECUTE IMMEDIATE l_sql;
  END IF;
  
  IF NVL(l_old_ck, TRUE) THEN     
     l_sql := 'ALTER TABLE EAMS_WI_ERROR_LOG ADD CONSTRAINT EAMS_WI_STATUS_CHECK '||CHR(10)||
              'CHECK (STATUS IN (''ADMIN_ERROR'', '||CHR(10)||
              '                  ''NOTIFY_ERROR'', '||CHR(10)||
              '                  ''SCHEDULE_ERROR'', '||CHR(10)||
              '                  ''COPY_ERROR'', '||CHR(10)||
              '                  ''INGEST_ERROR'', '||CHR(10)||
              '                  ''VALIDATE_ERROR'', '||CHR(10)||
              '                  ''QA_ERROR'', '||CHR(10)||
              '                  ''TRANSFORM_ERROR'', '||CHR(10)||
              '                  ''TRANSCODE_ERROR'', '||CHR(10)||
              '                  ''ENCRYPT_ERROR'', '||CHR(10)||
              '                  ''PUBLISH_ERROR'', '||CHR(10)||
              '                  ''DELETE_ERROR'', '||CHR(10)||
              '                  ''INSTALL_ERROR'', '||CHR(10)||
              '                  ''REPROCESS_ERROR'', '||CHR(10)||
              '                  ''WORKFLOW_ERROR'',  '||CHR(10)||
              '                  ''MANUAL_QA'', '||CHR(10)||
              '                  ''MANUAL_TRANSCODE'', '||CHR(10)||
              '                  ''MANUAL_ENCRYPT'', '||CHR(10)||
              '                  ''MANUAL_PUBLISH'', '||CHR(10)||
              '                  ''DISCOVERY_ERROR'', '||CHR(10)||
              '                  ''ROLE_RECOGNIZE_ERROR'', '||CHR(10)||
              '                  ''CONVERSION_ERROR'', '||CHR(10)||
              '                  ''NORMALIZE_ERROR'', '||CHR(10)||
              '                  ''RESOURCE_ANALYSIS_ERROR'', '||CHR(10)||
              '                  ''WORKFLOW_IDENT_ERROR'', '||CHR(10)||
              '                  ''PACKAGE_DISTRIB_ERROR'', '||CHR(10)||
              '                  ''CORRELATION_ERROR'', '||CHR(10)||
              '                  ''PACKAGE_STORAGE_ERROR'', '||CHR(10)||
              '                  ''POST_TRANSCODEQA_ERROR'')) ';

     EXECUTE IMMEDIATE l_sql;  
  END IF; 
END;
/

PROMPT Creating check constraint on 'EAMS_MEDIA_FORMAT.SOURCE_FORMAT'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_MEDIA_FORMAT ADD CONSTRAINT EAMS_MEDIA_FORMAT_CK1 '||CHR(10)||
                          'CHECK (SOURCE_FORMAT IN (''Y'', ''N''))';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_MEDIA_FORMAT.TARGET_FORMAT'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT_CK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_MEDIA_FORMAT ADD CONSTRAINT EAMS_MEDIA_FORMAT_CK2 '||CHR(10)||
                          'CHECK (TARGET_FORMAT IN (''Y'', ''N''))';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_MEDIA_FORMAT.METADATA_REQUIRED'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_MEDIA_FORMAT_CK3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_MEDIA_FORMAT ADD CONSTRAINT EAMS_MEDIA_FORMAT_CK3 '||CHR(10)||
                          'CHECK (METADATA_REQUIRED IN (''Y'', ''N''))';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Make EAMS_CONFIG_REPOSITORY.INSTANCE_NAME NULLABLE
DECLARE 
  l_table_name CONSTANT VARCHAR2(30) := 'EAMS_CONFIG_REPOSITORY';
  l_column_name CONSTANT VARCHAR2(30) := 'INSTANCE_NAME';
  l_constraint_name VARCHAR2(30);
  l_search_condition VARCHAR2(32000);
BEGIN
  SELECT a.search_condition,
         a.constraint_name
  INTO   l_search_condition,
         l_constraint_name
  FROM   user_constraints a,
         user_cons_columns b
  WHERE  a.table_name = l_table_name
  AND    b.table_name = l_table_name
  AND    constraint_type = 'C'
  AND    a.constraint_name = b.constraint_name
  AND    column_name = l_column_name
  AND    position IS NULL;
  
  IF l_search_condition = '"INSTANCE_NAME" IS NOT NULL' THEN
     EXECUTE IMMEDIATE 'ALTER TABLE '||l_table_name||' DROP CONSTRAINT '||l_constraint_name; 
  END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

PROMPT Creating check constraint on 'EAMS_INGEST_ASSET.CC_TYPE'
DECLARE   
  l_old_ck BOOLEAN := FALSE;
  l_not_null_ck BOOLEAN := FALSE;
  l_search_condition VARCHAR2(32000);
  l_constraint_name VARCHAR2(30);
  l_sql VARCHAR2(2048);    
BEGIN  
  BEGIN 
    SELECT constraint_name,
           search_condition
    INTO   l_constraint_name,
           l_search_condition
    FROM   user_constraints
    WHERE  constraint_name IN ('EAMS_INGEST_ASSET_CK1', 'EAMS_ING_CCTYPE_CHECK');
    
    IF l_search_condition NOT LIKE '%NONE%' THEN
       l_old_ck := TRUE;
    END IF;
       
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           l_old_ck := NULL;         
  END;
  
  IF l_old_ck THEN
     l_sql := 'ALTER TABLE EAMS_INGEST_ASSET DROP CONSTRAINT '||l_constraint_name;  
     EXECUTE IMMEDIATE l_sql;
  END IF;
  

  UPDATE eams_ingest_asset
  SET    cc_type = 'OTHER'
  WHERE  cc_type IS NULL;
  
  COMMIT;
    
  IF NVL(l_old_ck, TRUE) THEN     
     l_sql := 'ALTER TABLE EAMS_INGEST_ASSET ADD CONSTRAINT EAMS_INGEST_ASSET_CK1 '||CHR(10)||
              'CHECK (CC_TYPE IN(''EMBED'',''CCFILE'',''OTHER'', ''NONE''))';

     EXECUTE IMMEDIATE l_sql;  
  END IF; 
    
  FOR rec IN (SELECT search_condition 
              FROM   user_constraints a,
                     user_cons_columns b
              WHERE  a.table_name = 'EAMS_INGEST_ASSET'
              AND    constraint_type = 'C'
              AND    a.constraint_name = b.constraint_name
              AND    column_name = 'CC_TYPE') LOOP
              
      IF rec.search_condition = '"CC_TYPE" IS NOT NULL' THEN
         l_not_null_ck := TRUE;
      END IF; 
      
  END LOOP rec;
  
  IF NOT l_not_null_ck THEN
     l_sql := 'ALTER TABLE EAMS_INGEST_ASSET MODIFY CC_TYPE VARCHAR2(20) NOT NULL';
     
     EXECUTE IMMEDIATE l_sql;  
  END IF;  
END;
/

PROMPT Creating check constraint on 'EAMS_PUBLISH_PACKAGE.PRODUCTION_STATE'
DECLARE 
  l_exist BOOLEAN := FALSE; 
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PUBLISH_PACKAGE ADD CONSTRAINT EAMS_PUBLISH_PACKAGE_CK1 '||CHR(10)||
                          'CHECK (PRODUCTION_STATE IN (''IN_PROGRESS'',''IN_PRODUCTION'',''NOT_IN_PRODUCTION'', ''TERMINATED'', ''UNKNOWN''))';
BEGIN
  FOR rec IN (SELECT b.search_condition
              FROM   user_cons_columns a,
                     user_constraints b
              WHERE  a.table_name = 'EAMS_PUBLISH_PACKAGE'
              AND    b.table_name = 'EAMS_PUBLISH_PACKAGE'
              AND    a.constraint_name = b.constraint_name
              AND    b.constraint_type = 'C'
              AND    column_name = 'PRODUCTION_STATE') LOOP
              
      IF rec.search_condition NOT LIKE '%"PRODUCTION_STATE" IS NOT NULL%' THEN
         l_exist := TRUE;
      END IF;
       
  END LOOP rec;
  
  IF NOT l_exist THEN
     EXECUTE IMMEDIATE l_sql;     
  END IF;  
END;
/

PROMPT Creating check constraint on 'EAMS_AR_MAP_FIELD_INFO.MAP_TYPE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_AR_MAP_FIELD_INFO_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_AR_MAP_FIELD_INFO ADD (CONSTRAINT EAMS_AR_MAP_FIELD_INFO_CK1 '||CHR(10)||
                          'CHECK (MAP_TYPE IN (''INPUT'',''OUTPUT''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_AR_MAP_INFO.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_AR_MAP_INFO_CK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_AR_MAP_INFO ADD (CONSTRAINT EAMS_AR_MAP_INFO_CK2 '||CHR(10)||
                          'CHECK (STATUS IN(''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RM_POLL_STATUS.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RM_POLL_STATUS_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RM_POLL_STATUS ADD (CONSTRAINT EAMS_RM_POLL_STATUS_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''INIT'',''STARTED'',''PROGRESS'',''COMPLETED'',''ERROR'',''DELETED''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_CATCHER_MONITOR_FILES.FILE_STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_CATCHER_MONITOR_FILES_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_CATCHER_MONITOR_FILES ADD (CONSTRAINT EAMS_CATCHER_MONITOR_FILES_CK1 '||CHR(10)||
                          'CHECK (FILE_STATUS IN (''PENDING'',''ERROR'',''IN_PROGRESS''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Recreating check constraint 'EAMS_PUB_ASSET_STATUS_CHECK'
DECLARE 
  l_old_ck BOOLEAN := FALSE;
  l_search_condition VARCHAR2(32000);
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PUB_ASSET_STATUS_CHECK';
  l_sql VARCHAR2(2048) := 'ALTER TABLE EAMS_PUBLISH_ASSET DROP CONSTRAINT EAMS_PUB_ASSET_STATUS_CHECK';    
BEGIN
  BEGIN 
    SELECT search_condition
    INTO   l_search_condition
    FROM   user_constraints
    WHERE  constraint_name = l_constraint_name;
    
    IF l_search_condition NOT LIKE '%REJECTED%' THEN
       l_old_ck := TRUE;
    END IF;
       
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           l_old_ck := NULL;         
  END;
  
  IF l_old_ck THEN
     EXECUTE IMMEDIATE l_sql;
  END IF;
  
  IF NVL(l_old_ck, TRUE) THEN     
     l_sql := 'ALTER TABLE EAMS_PUBLISH_ASSET ADD CONSTRAINT EAMS_PUB_ASSET_STATUS_CHECK  '||CHR(10)||
              'CHECK (STATUS IN(''PUBLISH_PENDING'',''PUBLISH_PROGRESS'',''PUBLISHED'',''DELETED'',''ERROR'', ''REJECTED'')) ';

     EXECUTE IMMEDIATE l_sql;  
  END IF; 
END;
/

PROMPT Creating check constraint on 'EAMS_PACKAGE_STORAGE_DETAILS.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_PKG_STORAGE_DETAILS_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_PACKAGE_STORAGE_DETAILS ADD (CONSTRAINT EAMS_PKG_STORAGE_DETAILS_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''NEW'', '||CHR(10)||
                          '                  ''BACKUP_PROGRESS'', '||CHR(10)||
                          '                  ''BACKUP_COMPLETE'', '||CHR(10)||
                          '                  ''BACKUP_ERROR'', '||CHR(10)||
                          '                  ''ARCHIVED'', '||CHR(10)||
                          '                  ''RESTORE_PROGRESS'', '||CHR(10)||
                          '                  ''RESTORE_COMPLETE'', '||CHR(10)||
                          '                  ''RESTORE_ERROR'', '||CHR(10)||
                          '                  ''MARKED_FOR_DELETION'', '||CHR(10)||
                          '                  ''DELETED''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

--
-- Create indexes
--

PROMPT Creating indexes

PROMPT Create indexes on different tables for column LAST_STATUS_MODIFY_TIME
DECLARE 
  l_dummy INTEGER;
  l_column_name CONSTANT VARCHAR2(30) := 'LAST_STATUS_MODIFY_TIME';   
  
  PROCEDURE create_index 
    (in_table_name VARCHAR2) IS 
    
  BEGIN
    SELECT 1
    INTO   l_dummy
    FROM   user_ind_columns a,
           (SELECT index_name
            FROM   user_ind_columns
            WHERE  table_name = in_table_name
            GROUP  BY index_name
            HAVING COUNT(*) = 1) b
    WHERE  table_name = in_table_name
    AND    column_name = l_column_name
    AND    column_position = 1
    AND    a.index_name = b.index_name;    
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           EXECUTE IMMEDIATE 'CREATE INDEX '||in_table_name||'_LSMT_IDX ON '||in_table_name||'('||l_column_name||
                             ') TABLESPACE EAMS_MOT_128K_IDX';
  END create_index;
BEGIN
  create_index('EAMS_ADAPT_ASSET');
  create_index('EAMS_WI_ERROR_LOG');
  create_index('EAMS_QA_ASSET');
  create_index('EAMS_INGEST_ASSET');
  create_index('EAMS_INGEST_PACKAGE');
  create_index('EAMS_PUBLISH_ASSET');
  create_index('EAMS_PUBLISH_PACKAGE');  
END;
/

PROMPT Create index CCE_RPT_FILTERS_INDEX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS_INDEX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX CCE_RPT_FILTERS_INDEX1 ON CCE_RPT_FILTERS (RPT_FIELD_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Create index CCE_RPT_FILTERS_INDEX2
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_RPT_FILTERS_INDEX2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX CCE_RPT_FILTERS_INDEX2 ON CCE_RPT_FILTERS (RPT_FIELD_TYPE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_J_REQ_RECOVERY_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_J_REQ_RECOVERY_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_J_REQ_RECOVERY_IDX1 ON QRTZ_JOB_DETAILS (REQUESTS_RECOVERY) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_T_NEXT_FIRE_TIME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_T_NEXT_FIRE_TIME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_T_NEXT_FIRE_TIME_IDX1 ON QRTZ_TRIGGERS (NEXT_FIRE_TIME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_T_STATE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_T_STATE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_T_STATE_IDX1 ON QRTZ_TRIGGERS (TRIGGER_STATE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_T_NFT_ST_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_T_NFT_ST_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_T_NFT_ST_IDX1 ON QRTZ_TRIGGERS (NEXT_FIRE_TIME,TRIGGER_STATE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_T_VOLATILE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_T_VOLATILE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_T_VOLATILE_IDX1 ON QRTZ_TRIGGERS (IS_VOLATILE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_TRIG_NAME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_TRIG_NAME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_TRIG_NAME_IDX1 ON QRTZ_FIRED_TRIGGERS (TRIGGER_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_TRIG_GROUP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_TRIG_GROUP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_TRIG_GROUP_IDX1 ON QRTZ_FIRED_TRIGGERS (TRIGGER_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_TRIG_NM_GP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_TRIG_NM_GP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_TRIG_NM_GP_IDX1 ON QRTZ_FIRED_TRIGGERS (TRIGGER_NAME,TRIGGER_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_TRIG_VOLATILE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_TRIG_VOLATILE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_TRIG_VOLATILE_IDX1 ON QRTZ_FIRED_TRIGGERS (IS_VOLATILE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_TRIG_INST_NAME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_TRIG_INST_NAME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_TRIG_INST_NAME_IDX1 ON QRTZ_FIRED_TRIGGERS (INSTANCE_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_JOB_NAME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_JOB_NAME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_JOB_NAME_IDX1 ON QRTZ_FIRED_TRIGGERS (JOB_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_JOB_GROUP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_JOB_GROUP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_JOB_GROUP_IDX1 ON QRTZ_FIRED_TRIGGERS (JOB_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_JOB_STATEFUL_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_JOB_STATEFUL_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_JOB_STATEFUL_IDX1 ON QRTZ_FIRED_TRIGGERS (IS_STATEFUL) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX QRTZ_FT_JOB_REQ_RECOVERY_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'QRTZ_FT_JOB_REQ_RECOVERY_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX QRTZ_FT_JOB_REQ_RECOVERY_IDX1 ON QRTZ_FIRED_TRIGGERS (REQUESTS_RECOVERY) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_J_REQ_RECOVERY_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_J_REQ_RECOVERY_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_J_REQ_RECOVERY_IDX1 ON EAMS_QRTZ_JOB_DETAILS (REQUESTS_RECOVERY) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_J_REQ_RECOVERY_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_J_REQ_RECOVERY_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_J_REQ_RECOVERY_IDX1 ON EAMS_QRTZ_JOB_DETAILS (REQUESTS_RECOVERY) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_T_NEXT_FIRE_TME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_T_NEXT_FIRE_TME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_T_NEXT_FIRE_TME_IDX1 ON EAMS_QRTZ_TRIGGERS (NEXT_FIRE_TIME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_T_STATE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_T_STATE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_T_STATE_IDX1 ON EAMS_QRTZ_TRIGGERS (TRIGGER_STATE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_T_NFT_ST_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_T_NFT_ST_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_T_NFT_ST_IDX1 ON EAMS_QRTZ_TRIGGERS (NEXT_FIRE_TIME,TRIGGER_STATE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_T_VOLATILE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_T_VOLATILE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_T_VOLATILE_IDX1 ON EAMS_QRTZ_TRIGGERS (IS_VOLATILE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_TRIG_NAME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_TRIG_NAME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_TRIG_NAME_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (TRIGGER_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_TRIG_GROUP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_TRIG_GROUP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_TRIG_GROUP_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (TRIGGER_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_TRIG_NM_GP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_TRIG_NM_GP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_TRIG_NM_GP_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (TRIGGER_NAME,TRIGGER_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_TRG_VOLATILE_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_TRG_VOLATILE_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_TRG_VOLATILE_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (IS_VOLATILE) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_TRG_INST_NAM_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_TRG_INST_NAM_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_TRG_INST_NAM_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (INSTANCE_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_JOB_NAME_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_JOB_NAME_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_JOB_NAME_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (JOB_NAME) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_JOB_GROUP_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_JOB_GROUP_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_JOB_GROUP_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (JOB_GROUP) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_JOB_STATEFUL_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_JOB_STATEFUL_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_JOB_STATEFUL_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (IS_STATEFUL) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX EAMS_QRTZ_FT_JOB_REQ_REC_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_QRTZ_FT_JOB_REQ_REC_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_QRTZ_FT_JOB_REQ_REC_IDX1 ON EAMS_QRTZ_FIRED_TRIGGERS (REQUESTS_RECOVERY) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating INDEX CCE_RPT_EXPORT_ASSOC_IDX1
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_IDX1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX CCE_RPT_EXPORT_ASSOC_IDX1 ON CCE_RPT_EXPORT_ASSOC (REPORT_ID) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         BEGIN
           EXECUTE IMMEDIATE l_sql;
           
           EXCEPTION
             WHEN OTHERS THEN
                  IF SQLCODE != -1408 THEN
                     RAISE;
                  END IF;
         END;         
END;
/

PROMPT Creating INDEX CCE_RPT_EXPORT_ASSOC_IDX2
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_IDX2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX CCE_RPT_EXPORT_ASSOC_IDX2 ON CCE_RPT_EXPORT_ASSOC (DISPLAY_OPT_ID) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         BEGIN
           EXECUTE IMMEDIATE l_sql;
           
           EXCEPTION
             WHEN OTHERS THEN
                  IF SQLCODE != -1408 THEN
                     RAISE;
                  END IF;
         END;         
END;
/

PROMPT Creating INDEX CCE_RPT_EXPORT_ASSOC_IDX3
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_RPT_EXPORT_ASSOC_IDX3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX CCE_RPT_EXPORT_ASSOC_IDX3 ON CCE_RPT_EXPORT_ASSOC (EXPORT_OPT_ID) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         BEGIN
           EXECUTE IMMEDIATE l_sql;
           
           EXCEPTION
             WHEN OTHERS THEN
                  IF SQLCODE != -1408 THEN
                     RAISE;
                  END IF;
         END;         
END;
/

PROMPT Creating INDEX EAMS_WF_TR_INF_IDX
DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'EAMS_WF_TR_INF_IDX';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'CREATE INDEX EAMS_WF_TR_INF_IDX ON EAMS_WORKFLOW_TRANS_INFO (FIELD_ID) TABLESPACE LEAPSTONE_128K_IDX';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         BEGIN
           EXECUTE IMMEDIATE l_sql;
           
           EXCEPTION
             WHEN OTHERS THEN
                  IF SQLCODE != -1408 THEN
                     RAISE;
                  END IF;
         END;         
END;
/

DECLARE 
  l_index_name CONSTANT VARCHAR2(30) := 'CCE_USER_LOGINNAME_UIDX';
  l_dummy INTEGER;    
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_indexes
  WHERE  index_name = l_index_name;
  
  EXECUTE IMMEDIATE 'DROP INDEX '||l_index_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN NULL;
END;
/

--
-- Tablespace migration
--

PROMPT Tablespace Migration
DECLARE  
  TYPE obj_varchar_tab IS TABLE OF VARCHAR2(30);
  
  l_data_tablespace CONSTANT VARCHAR2(30) := 'EAMS_MOT_128M_DAT';
  l_index_tablespace CONSTANT VARCHAR2(30) := 'EAMS_MOT_8M_IDX';
  
  l_tablespace_name VARCHAR2(30);
  l_idx_ts_clause VARCHAR2(80);
  
  l_dummy INTEGER;
  l_stmt VARCHAR2(1024);
  
  l_tables obj_varchar_tab := obj_varchar_tab('EAMS_PUBLISH_PACKAGE',
                                              'EAMS_WI_ERROR_LOG',                                              
                                              'EAMS_ADAPT_ASSET',
                                              'EAMS_PUBLISH_ASSET',
                                              'EAMS_INGEST_PACKAGE',
                                              'EAMS_INGEST_ASSET',
                                              'EAMS_WORKFLOW_TRANS',
                                              'EAMS_INGEST_PKG_APP_DATA',
                                              'EAMS_PUBLISH_PKG_APP_DATA',
                                              'EAMS_ENCR_AGENT_TRANS',
                                              'EAMS_ENCODE_AGENT_TRANS');
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   dba_tablespaces a
  WHERE  tablespace_name = l_data_tablespace;
  
  FOR i IN 1..l_tables.COUNT LOOP
      BEGIN 
        SELECT tablespace_name
        INTO   l_tablespace_name
        FROM   user_tables
        WHERE  table_name = l_tables(i);
        
        IF l_tablespace_name != l_data_tablespace THEN
           l_stmt := 'ALTER TABLE '||l_tables(i)||' MOVE TABLESPACE '||l_data_tablespace;
           
           EXECUTE IMMEDIATE l_stmt;    
        END IF;
        
        EXCEPTION
          WHEN NO_DATA_FOUND THEN NULL;
      END;      
  END LOOP rec;
  
  -- Move the xmltype lob segments  
  FOR rec IN (SELECT b.tablespace_name,
                     a.table_name,
                     a.column_name
              FROM   user_tab_columns a,
                     user_lobs b       
              WHERE  data_type = 'XMLTYPE'
              AND    a.table_name = b.table_name
              AND    'SYS_NC000'||(a.column_id + 1)||'$' = b.column_name
              AND    b.tablespace_name != l_data_tablespace) LOOP              
      l_stmt := 'ALTER TABLE '||rec.table_name||' MOVE LOB('||rec.column_name||'.xmldata) STORE AS (TABLESPACE '||l_data_tablespace||')';
      
      EXECUTE IMMEDIATE l_stmt;
  END LOOP rec;
  
  BEGIN
    SELECT 1
    INTO   l_dummy
    FROM   dba_tablespaces a
    WHERE  tablespace_name = l_index_tablespace;
    
    l_idx_ts_clause := 'TABLESPACE '||l_index_tablespace;
    
    FOR rec IN (SELECT index_name
                FROM   user_indexes
                WHERE  table_name IN ('EAMS_PUBLISH_PACKAGE',
                                      'EAMS_WI_ERROR_LOG',                                              
                                      'EAMS_ADAPT_ASSET',
                                      'EAMS_PUBLISH_ASSET',
                                      'EAMS_INGEST_PACKAGE',
                                      'EAMS_INGEST_ASSET',
                                      'EAMS_WORKFLOW_TRANS',
                                      'EAMS_INGEST_PKG_APP_DATA',
                                      'EAMS_PUBLISH_PKG_APP_DATA',
                                      'EAMS_ENCR_AGENT_TRANS',
                                      'EAMS_ENCODE_AGENT_TRANS')
                AND    tablespace_name != l_index_tablespace
                AND    index_type != 'LOB') LOOP
                
        l_stmt := 'ALTER INDEX '||rec.index_name||' REBUILD '||l_idx_ts_clause;
        
        EXECUTE IMMEDIATE l_stmt;      
                
    END LOOP rec;                    
    
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN
           l_idx_ts_clause := NULL;
  END;
  
  FOR rec IN (SELECT index_name
              FROM   user_indexes
              WHERE  status = 'UNUSABLE') LOOP
              
      l_stmt := 'ALTER INDEX '||rec.index_name||' REBUILD '||l_idx_ts_clause;
      
      EXECUTE IMMEDIATE l_stmt;      
  END LOOP rec;
  
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
         raise_application_error (-20000, 'Tablespace '||l_data_tablespace||' does not exist, TS migration abort.');             
END;
/                                              

PROMPT Creating check constraint on 'EAMS_RESOURCE.RESOURCE_TYPE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE ADD (CONSTRAINT EAMS_RESOURCE_CK1 '||CHR(10)||
                          'CHECK (RESOURCE_TYPE IN (''FILE'',''DIR''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_CK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE ADD (CONSTRAINT EAMS_RESOURCE_CK2 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE.PACKAGED'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_CK3';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE ADD (CONSTRAINT EAMS_RESOURCE_CK3 '||CHR(10)||
                          'CHECK (PACKAGED IN (''Y'',''N''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE_RESOURCE_ASSOC.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RES_RESOURCE_ASSOC_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_RESOURCE_ASSOC ADD (CONSTRAINT EAMS_RES_RESOURCE_ASSOC_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE_ROLE.ROLE_TYPE'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE ADD (CONSTRAINT EAMS_RESOURCE_ROLE_CK1 '||CHR(10)||
                          'CHECK (ROLE_TYPE IN (''WORKFLOW'',''WORKSTEP''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE_ROLE.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_CK2';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE ADD (CONSTRAINT EAMS_RESOURCE_ROLE_CK2 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE_ROLE_MAP.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP ADD (CONSTRAINT EAMS_RESOURCE_ROLE_MAP_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RESOURCE_ROLE_MAP.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RESOURCE_ROLE_MAP_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RESOURCE_ROLE_MAP ADD (CONSTRAINT EAMS_RESOURCE_ROLE_MAP_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_RULEGROUP.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_RULEGROUP_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_RULEGROUP ADD (CONSTRAINT EAMS_RULEGROUP_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKFLOW_OP_TRANS.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKFLOW_OP_TRANS_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_OP_TRANS ADD (CONSTRAINT EAMS_WORKFLOW_OP_TRANS_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''STARTED'',''PROGRESS'',''COMPLETED'',''ERROR'',''SUSPENDED'',''CANCELLED''))) ';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKFLOW_WORKSTEP_ASSOC.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WF_WORKSTEP_ASSOC_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKFLOW_WORKSTEP_ASSOC ADD (CONSTRAINT EAMS_WF_WORKSTEP_ASSOC_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';                          
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKSTEP.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP ADD (CONSTRAINT EAMS_WORKSTEP_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';                       
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/
        
PROMPT Creating check constraint on 'EAMS_WORKSTEP_ROLE_ASSOC'
DECLARE
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_ROLE_ASSOC_CK1';
  l_dummy INTEGER;
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_ROLE_ASSOC ADD (CONSTRAINT EAMS_WORKSTEP_ROLE_ASSOC_CK1 '||CHR(10)||
                          'CHECK (WORKSTEP_TYPE IN (''SINGLE-RESOURCE'',''SINGLE-RESOURCEGROUP'',''MULTIPLE-RESOURCE'',''MULTIPLE-RESOURCEGROUP''))) ';
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKSTEP_RULEGROUP_ASSOC.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_RG_ASSOC_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_RULEGROUP_ASSOC ADD (CONSTRAINT EAMS_WORKSTEP_RG_ASSOC_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''ACTIVE'',''INACTIVE''))) ';                
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/

PROMPT Creating check constraint on 'EAMS_WORKSTEP_TRANS.STATUS'
DECLARE 
  l_constraint_name CONSTANT VARCHAR2(30) := 'EAMS_WORKSTEP_TRANS_CK1';
  l_dummy INTEGER;  
  l_sql VARCHAR2(1024) := 'ALTER TABLE EAMS_WORKSTEP_TRANS ADD (CONSTRAINT EAMS_WORKSTEP_TRANS_CK1 '||CHR(10)||
                          'CHECK (STATUS IN (''STARTED'',''PROGRESS'',''COMPLETED'',''ERROR'',''SUSPENDED'',''CANCELLED''))) ';              
BEGIN
  SELECT 1     
  INTO   l_dummy
  FROM   user_constraints
  WHERE  constraint_name = l_constraint_name;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         EXECUTE IMMEDIATE l_sql;
END;
/
        
spool off
/