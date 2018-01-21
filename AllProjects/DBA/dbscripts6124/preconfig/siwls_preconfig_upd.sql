spool siwls_preconfig_upd.lst

PROMPT CI Preconfig Update

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION = '^CCE_PRODUCT^'
WHERE object_type = 'PRODUCT';

ALTER TRIGGER CCE_VENDOR_MOD_CHECK DISABLE;

spool off

@@siwlspreconfigupd.sql

ALTER TRIGGER CCE_VENDOR_MOD_CHECK ENABLE;

@@si_pre_mig.sql

PROMPT Begin CR LTUSR00044685 release 1.1.2 on 04/22/2010 

DELETE cce_user_field_info 
WHERE  field_name = 'Content'
AND    field_xml_tag = 'sfaContent';

COMMIT;

PROMPT End CR LTUSR00044685 release 1.1.2 on 04/22/2010 
    
@@siwlsrefpreconfig.sql
	
@@si_post_mig.sql

@@siwls_was_update.sql

spool siwls_preconfig_upd_part2.lst

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
           ELSE
              SELECT COUNT(*)
              INTO   l_dummy
              FROM   user_indexes
              WHERE  index_name = l_constraint_name;        
              
              IF l_dummy > 0 THEN
                 EXECUTE IMMEDIATE 'DROP INDEX '||l_constraint_name;
              END IF;
           END IF;

           EXECUTE IMMEDIATE 'ALTER TABLE cce_rpt_export_assoc ADD CONSTRAINT '||l_constraint_name||' PRIMARY KEY (export_opt_id, report_id, display_opt_id) USING INDEX TABLESPACE LEAPSTONE_128K_IDX';
  END;
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
-- Pre config data
--

DECLARE
  l_time NUMBER;
BEGIN
  l_time := cce_util#pkg.datetoms(SYSDATE);
  
  EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
/

PROMPT Begin CR LTUSR00046216 release 1.2 on 07/25/2010 

BEGIN
  INSERT INTO CCE_NE_TYPE_INFO (
   NE_TYPE_ID,
   NE_TYPE_VERSION,
            NE_TYPE,
            NE_RSC_TYPE,
            NE_CON_ACES_MNGD_IND,
            NE_SNMP_IND,
            LAST_MODIFY_TIME,
            NE_DESC,
            NE_PROFILE_SUPPORT)
     VALUES (9,'1.0','GATEWAY',2072, 1,0,CCE_UTIL#PKG.DATETOMS(sysdate),'Gateway Systems','N');
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (87, '7050', 'Mezzanine Aspera Transfer Failed', 'Aspera Transfer to Mezzanine Storage Failed');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (88, '7052', 'Mezzanine Copy Failed', 'Copy of Packages to Mezzanine Storage Failed');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (89, '7053', 'Mezzanine Backup Failed', 'Backup of Packages to Mezzanine Storage Failed');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (90, '7054', 'Restoration Failed', 'Restoration from Mezzanine Storage Failed');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (91, '7055', 'Archive Failure', 'Archive from Working Storage Failed');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (92, '7056', 'Config Error', 'Package Life Cycle Manager Configuration Error');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (93, '7099', 'Unknown Error', 'Unknown Error in Package Life Cycle Manager');  

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO EAMS_POLLING_JOBS (
             JOB_NAME,
             IMPL_CLASS,
             JOB_INTERVAL,
             JOB_INTERVAL_UNIT,
             RESET_ON_STARTUP,
             JOB_ID
             )
     VALUES ('MezzanineStorageCleanupJob', 'com.motorola.eams.storage.MezzanineStorageCleanupJob', 1440, 2,'Y',2);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN
  INSERT INTO EAMS_POLLING_JOBS (
             JOB_NAME,
             IMPL_CLASS,
             JOB_INTERVAL,
             JOB_INTERVAL_UNIT,
             RESET_ON_STARTUP,
             JOB_ID
             )
     VALUES ('WorkingStorageCleanupJob', 'com.motorola.eams.storage.WorkingStorageCleanupJob', 1440, 2,'Y',3);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046216 release 1.2 on 07/25/2010 

PROMPT End CR LTUSR00046256 release 1.2 on 07/28/2010 

UPDATE cce_error_code_info 
SET    error_short_desc = 'Package is Duplicate of prev Version' 
WHERE  error_code = 9105;

COMMIT;

PROMPT End CR LTUSR00046256 release 1.2 on 07/28/2010 

PROMPT Begin CR 46750 release 1.2.1 on  09/29/2010

PROMPT -- Begin update the cce_error_code_info for errorid 15203

UPDATE CCE_ERROR_CODE_INFO
SET ERROR_LONG_DESC='Unknown File foramat(UnKnownExtension)'
WHERE ERROR_CODE=15203
/
COMMIT;
PROMPT -- end update the cce_error_code_info for errorid 15203


PROMPT -- Begin update the cce_error_code_info for errorid 15603
 
UPDATE CCE_ERROR_CODE_INFO
SET ERROR_LONG_DESC='Unable to find a matching Local Catcher'
WHERE ERROR_CODE=15603
/
COMMIT;
PROMPT -- end update the cce_error_code_info for errorid 15603

PROMPT -- Begin update the cce_error_code_info for errorid 15701

UPDATE CCE_ERROR_CODE_INFO
SET ERROR_LONG_DESC='Unable to move the package to the Local Catcher'
WHERE ERROR_CODE=15701
/
COMMIT;
PROMPT -- end update the cce_error_code_info for errorid 15701

PROMPT -- Begin update the cce_error_code_info for errorid 15304

UPDATE CCE_ERROR_CODE_INFO
SET ERROR_LONG_DESC='PerlService  return failure(Unsupported special characters)'
WHERE ERROR_CODE=15304
/
COMMIT;
PROMPT -- end update the cce_error_code_info for errorid 15304

PROMPT End CR 46750 release 1.2.1 on  09/29/2010
    
PROMPT Begin CR LTUSR00046339 release 1.2 on 08/02/2010 

BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (73 ,'PNG-Source-Poster' ,'poster' ,
      NULL,'png',NULL ,
      NULL,1253818229723,'SISUPERUSR',
      NULL,NULL,'Y' ,
      'Y','Y' );

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (74 ,'PNG-Source-BoxCover' ,'box cover' ,
      NULL,'png',NULL ,
      NULL,1253818229723,'SISUPERUSR',
     NULL,NULL,'Y' ,
      'Y','Y' );

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
PROMPT  insert script for eams_media_format for release 1.2.1 on 09/28/2010 

BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
          VALUES (75, 'TIF-Poster', 'poster',
				 NULL, 'tif', 'N',
				 NULL, 1253818229723, 'SISUPERUSR', 
				 NULL, NULL, 'Y', 'N', 'Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (76, 'TIF-Box', 'box cover',
		 NULL, 'tif', 'N',
		 NULL, 1253818229723, 'SISUPERUSR',
		 NULL, NULL, 'Y', 'N', 'Y'); 

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (77, 'BMP-Poster', 'poster',
		NULL,'bmp', 'N',
		NULL, 1253818229723, 'SISUPERUSR',
		NULL, NULL, 'Y', 'N', 'Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (78, 'BMP-Box', 'box cover',
		NULL, 'bmp', 'N', 
		NULL, 1253818229723, 'SISUPERUSR',
		NULL, NULL, 'Y', 'N', 'Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (79, 'GIF-Poster', 'poster',
		NULL, 'gif', 'N', 
		NULL, 1253818229723, 'SISUPERUSR', 
		NULL, NULL, 'Y', 'N', 'Y'); 

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (80, 'GIF-Box', 'box cover',
		 NULL, 'gif', 'N', 
		 NULL, 1253818229723, 'SISUPERUSR', 
		 NULL, NULL, 'Y', 'N', 'Y'); 

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 
  INSERT INTO EAMS_MEDIA_FORMAT (
     MEDIA_FORMAT_ID, MEDIA_FORMAT_NAME, MEDIA_FORMAT_TYPE, 
     FORMAT_DESCRIPTION, FILE_EXTN, HDCONTENT, 
     ENCRYPTION_SUPPORT, CREATE_TIME, CREATE_BY, 
     LAST_MODIFY_TIME, LAST_MODIFY_BY, SOURCE_FORMAT, 
     TARGET_FORMAT, METADATA_REQUIRED) 
  VALUES (81,'HDMPG4/H264-TRLMPG','preview',
		'High definition Preview mpg','mpg','Y',
		'N',1253818229723,'SISUPERUSR',
		NULL,NULL,'Y','Y','Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

PROMPT End CR LTUSR00046339 release 1.2 on 08/02/2010 

PROMPT Begin CR 45102 release 1.2.0.4 

prompt Inserting to eams_media_format_info values (56, 500094, 7)
BEGIN 
   INSERT INTO EAMS_MEDIA_FORMAT_INFO (
     MEDIA_FORMAT_ID, FIELD_ID, FIELD_VALUE) 
     VALUES (56, 500094, 7);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

prompt Inserting to eams_media_format_info values (29, 500094, 7)
BEGIN 

  INSERT INTO EAMS_MEDIA_FORMAT_INFO (
     MEDIA_FORMAT_ID, FIELD_ID, FIELD_VALUE) 
     VALUES (29, 500094, 7);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
PROMPT End CR 45102 release 1.2.0.4 

PROMPT  Begin CR LTUSR00045102 release 1.2.1 on 09/28/2010 
BEGIN 
  INSERT INTO eams_media_format_info
     VALUES (56, 500094, 7);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 

  INSERT INTO eams_media_format_info
     VALUES (29, 500094, 7);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 

  INSERT INTO eams_media_format_info 
  VALUES (13, 500094, '6'); 
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 

  INSERT INTO eams_media_format_info 
  VALUES (14, 500094, '6'); 
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
  VALUES (29, 500094, '6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 

  INSERT INTO eams_media_format_info 
VALUES (56, 500094, '6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (38, 500094, '6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (37, 500094, '6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (3,500094,'6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (3,500094,'2');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (56,500094,'6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (6,500094,'2');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (6,500094,'6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (29,500094,'6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
BEGIN 

  INSERT INTO eams_media_format_info 
 VALUES (81,500094,'6');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT  End CR LTUSR00045102 release 1.2.1 on 09/28/2010 

PROMPT Begin CR LTUSR00046356 release 1.2 on 08/03/2010 

PROMPT INSERT INTO eams_workstep
BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      1, 'DISCOVERY', 'ACTIVE', 1279366786397, 'SISUPERUSR', NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      2,
      'ROLE RECOGNITION',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      3, 'NORMALIZATION', 'ACTIVE', 1279366786397, 'SISUPERUSR', NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      4,
      'MEDIA ANALYSIS',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      5,
      'WORKFLOW IDENTIFICATION',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      6,
      'PACKAGE INGESTION',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      100,
      'METADATA CONVERSION',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO eams_rulegroup

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      1000,
      'EAMS_ACQUISITIONRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      2000,
      'EAMS_DISCOVERYRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      3000,
      'EAMS_RESOURCEROLERULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      4000,
      'EAMS_NORMALIZATIONRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      5000,
      'EAMS_RESOURCEANALYSISRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      6000,
      'EAMS_PACKAGECORRELATIONRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      7000,
      'EAMS_PACKAGEINGESTIONRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      8000,
      'EAMS_PACKAGEDISTRIBUTIONRULEGROUP',
      'INACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_rulegroup (
            rulegroup_id,
            rulegroup_name,
            status,
            create_time,
            create_by,
            last_modify_time,
            last_modify_by)
     VALUES (
      9000,
      'EAMS_CONVERSIONRULEGROUP',
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO eams_resource_role 

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      1,
      'INIT',
      'Initial Discovered Resource',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      2,
      'DIR',
      'Directory',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      3,
      'FILE',
      'File',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      4,
      'NAME_NORM_FILE',
      'File Name Normalized',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      5,
      'NAME_NORM_DIR',
      'Direcotory Name Normalized',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      6,
      'METADATA',
      'Metadata Asset Identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      7,
      'MEDIA',
      'Media Asset Identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      8,
      'PACKAGE',
      'Packaged Assets Identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      9,
      'ADI11',
      'Cable labs ADI 1.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      10,
      'FILM20',
      'Film 2.0 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      11,
      'FILM21',
      'Film2.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      12,
      'WBXLS',
      'Warner Brother Excel Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      13,
      'VIDEO',
      'Video Asset Identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      14,
      'IMAGE',
      'Image Asset Identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      15,
      'CC',
      'Closed Caption Asset identified',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      16,
      'CAP',
      'CAP Format Closed captioned',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      17,
      'SCC',
      'SCC Format Closed Captioned',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      18,
      'TXT',
      'Text Closed Captioned',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      19,
      'NORM_METADATA',
      'Normalized Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      20,
      'NORM_FILM20',
      'Normalized Film 2.0',
      NULL,
      'INACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      21,
      'NORM_FILM21',
      'Normalized Film2.1',
      NULL,
      'INACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      22,
      'NORM_WBXLS',
      'Normalized Warner Brother Excel',
      NULL,
      'INACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      23,
      'CONV_ADI11',
      'Converted ADI1.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      24,
      'CONV_SCC',
      'Converted SCC Closed Captioned',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      25,
      'ANALYSED_CONV_ADI11',
      'Analyzed ADI1.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      26,
      'ANALYSED_ADI11',
      'Analyzed ADI1.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      27,
      'ANALYSED_VIDEO',
      'Analyzed Video Asset',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      28,
      'ANALYSED_IMAGE',
      'Analyzed Image Asset',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      29,
      'PC_NORM_ADI11',
      'Normalized ADI1.1 Metadata',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      30,
      'CORR_PACKAGE',
      'Correlated Package',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      31,
      'PACKAGED_CORR',
      'Correlated Package',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      32,
      'WI_CORR_PACKAGE',
      'Workflow Identified Package',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      33,
      'WI_PACKAGED_CORR',
      'Workflow Identified Package',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      34,
      'WI_PACKAGED',
      'Workflow Identified Package',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      35,
      'INGESTED_PACKAGE',
      'Package Distributed to Workflow',
      NULL,
      'ACTIVE',
      1279366786397,
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC 

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  1, 2000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  2, 3000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  3, 4000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  4, 5000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  5, 7000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  6, 8000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
  CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
  100, 9000, 'ACTIVE', 111, NULL, NULL, NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  1, 1, 'ACTIVE', 'MULTIPLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  2, 4, 'ACTIVE', 'SINGLE-RESOURCE') ;
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  3, 6, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  4, 13, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  4, 14, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  5, 8, 'ACTIVE', 'SINGLE-RESOURCEGROUP');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  2, 2, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  2, 19, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  4, 9, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  6, 33, 'ACTIVE', 'SINGLE-RESOURCEGROUP');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  100, 10, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  100, 11, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
  WORKSTEP_TYPE ) VALUES ( 
  100, 12, 'ACTIVE', 'SINGLE-RESOURCE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO EAMS_POLLING_JOBS

BEGIN 
  INSERT INTO EAMS_POLLING_JOBS ( JOB_ID, JOB_NAME, IMPL_CLASS, JOB_INTERVAL, JOB_INTERVAL_UNIT,
  RESET_ON_STARTUP ) VALUES ( 
  4, 'PublicCatherPollingJob', 'com.motorola.eams.discovery.EAMSPublicCatcherPollingJob'
  , 10, 1, 'Y');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT INSERT INTO CCE_LIST_OF_VALUES

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Discovery Work Queue', '16', 16, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Role Recognition Work Queue', '17', 17, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Normalization Work Queue', '18', 18, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Conversion Work Queue', '19', 19, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Resource Analysis Work Queue', '20', 20, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Correlation Work Queue', '21', 21, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Workflow Identification', '22', 22, 1, 'eng', NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_LIST_OF_VALUES ( FIELD_ID, LOV_DISPLAY_VALUE, LOV_STORED_VALUE, LOV_SEQ,
  LOV_DEFAULT_IND, LOV_LANG_CODE, LOV_DESC ) VALUES ( 
  2397, 'Package Distribution Work Queue', '23', 23, 1, 'eng', NULL) ;
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046356 release 1.2 on 08/03/2010 

PROMPT Begin CR LTUSR00046329 release 1.2 on 08/03/2010 
BEGIN 
  INSERT INTO cce_ne_type_info (
            ne_type_id,
            ne_type_version,
            ne_type,
            ne_rsc_type,
            ne_con_aces_mngd_ind,
            ne_snmp_ind,
            ne_commn_type,
            ne_capacity,
            last_modify_time,
            last_publish_time,
            ne_desc,
            ne_num_subscribers,
            ne_snmp_version_no,
            ne_snmp_udp_port_number,
            ne_polling_intrvl_sec,
            ne_polling_timeout_sec,
            ne_polling_retries,
            ne_prov_timeout_sec,
            ne_prov_retries,
            ne_access_timeout_sec,
            ne_almdup_suprsn_intrvl_msec,
            ne_alarm_report_intrvl_secs,
            ne_adtlog_report_intrvl_secs,
            ne_retry_intvl_sec,
            ne_prov_bundle_op_ind,
            ne_prov_twop_commit_ind,
            ne_domain,
            ne_profile_support)
     VALUES (
      10,
      '1.0',
      'CIS',
      2072,
      1,
      0,
      NULL,
      NULL,
      1253886689569,
      NULL,
      'Target Publishing Systems',
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      'N');
     
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

PROMPT End CR LTUSR00046329 release 1.2 on 08/03/2010 

PROMPT Begin CR LTUSR00046418 release 1.2 on 08/05/2010
 
BEGIN 
  INSERT INTO cce_report_def (
            report_id,
            report_name,
            report_disp_name,
            report_desc)
     VALUES (
      15,
      'SEC_UG_SMRY',
      'Security User Group Summary',
      'EAMS Security User Group Summary.');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_rpt_filters (
             report_id,
             rpt_field_name,
             rpt_field_disp_name,
             rpt_field_disp_name2,
             rpt_field_type,
             rpt_field_desc,
             field_resolver_impl,
             rpt_field_seq)
     VALUES (
      15,
      'F_USER_GROUP',
      'User Group',
      NULL,
      'COLLECTION',
      'User Groups',
      NULL,
      1);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_rpt_export_assoc (
              export_opt_id,
              report_id,
              jrxml_file_name,
              display_opt_id)
     VALUES (1, 15, 'SEC_UG_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_rpt_export_assoc (
              export_opt_id,
              report_id,
              jrxml_file_name,
              display_opt_id)
     VALUES (2, 15, 'SEC_UG_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046418 release 1.2 on 08/05/2010 

PROMPT Begin CR LTUSR00046434 release 1.2 on 08/06/2010 

BEGIN 
  INSERT INTO cce_user_field_info (field_id,
                                   field_name,
                                   field_type,
                                   field_display_ind,
                                   field_source,
                                   xml_encode_ind,
                                   system_defined_ind,
                                   field_display_name,
                                   field_runtime_type,
                                   field_input_type,
                                   field_desc,
                                   field_min_value,
                                   field_max_value,
                                   field_default_value,
                                   field_xml_tag,
                                   field_status,
                                   field_max_num_values,
                                   parent_field_id,
                                   last_modify_time)
     VALUES (
      105088,
      'REQUEST_TYPE',
      'STR',
      1,
      1,
      0,
      1,
      'Request Type',
      NULL,
      NULL,
      'Request Type',
      NULL,
      NULL,
      NULL,
      'REQUEST_TYPE',
      NULL,
      NULL,
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046434 release 1.2 on 08/06/2010 

PROMPT Begin CR LTUSR00046440 release 1.2 on 08/06/2010 

BEGIN 
  INSERT INTO cce_user_field_info (
                 field_id,
                 field_name,
                 field_type,
                 field_display_ind,
                 field_source,
                 xml_encode_ind,
                 system_defined_ind,
                 field_display_name,
                 field_desc,
                 field_xml_tag)
     VALUES (
      105086,
      'NEXT_EXEC_JOB',
      'STR',
      1,
      1,
      0,
      0,
      'NEXT EXECUTION JOB',
      'Next Execution Job',
      'NEXT_EXEC_JOB');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
                 error_id,
                 ERROR_CODE,
                 error_short_desc,
                 error_long_desc)
     VALUES (94, '9221', 'Post Transcode QA Error', 'Post Transcode QA Error'
      );

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
                 error_id,
                 ERROR_CODE,
                 error_short_desc,
                 error_long_desc)
     VALUES (
      95,
      '9222',
      'Post Transcode QA SYSTEM ERROR',
      'Errror doing QA for Media In Post Transcode QA');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046440 release 1.2 on 08/06/2010 

PROMPT Begin CR LTUSR00046450 release 1.2 on 08/06/2010

BEGIN
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (3, 3, 'ACTIVE', 'SINGLE-RESOURCE'); 
     
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

UPDATE EAMS_WORKSTEP_ROLE_ASSOC
SET    ROLE_ID = 4
WHERE  ROLE_ID = 3
AND    WORKSTEP_ID = 2;

COMMIT;

PROMPT End CR LTUSR00046450 release 1.2 on 08/06/2010 

PROMPT Begin CR LTUSR00046476 release 1.2 on 08/08/2010 

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '2',
      'PRE_INGEST',
      'Pre Ingest',
      'Provides statistics about Package process',
      '(null)',
      '2',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '1',
      'EAMS_SYS_VIEW',
      'EAMS System View',
      'Provides statistics about EAMS system and processes',
      '(null)',
      '1',
      'NONE',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '9',
      'PKG_VIEW',
      'Packager',
      'Provides statistics about package process',
      '(null)',
      '9',
      'LCR',
      'INACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '3',
      'INGEST_VIEW',
      'Ingest',
      'Provides statistics about ingest process',
      '(null)',
      '3',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '4',
      'QA_VIEW',
      'QA',
      'Provides statistics about QA process',
      '(null)',
      '4',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '5',
      'TRANSCODE_VIEW',
      'Transcode',
      'Provides statistics about Transcode process',
      '(null)',
      '5',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '6',
      'POST_TRANSCODE_QA_VIEW',
      'Post Transcode QA',
      'Provides statistics about Post transcode QA process',
      '(null)',
      '6',
      'LCR',
      'INACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '7',
      'ENCRYPT_VIEW',
      'Encryption',
      'Provides statistics about Encryption process',
      '(null)',
      '7',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard (
           id,
           dboard_name,
           display_name,
           description,
           launch_url,
           display_order,
           layout_type,
           status)
     VALUES (
      '8',
      'PUBLISH_VIEW',
      'Publish',
      'Provides statistics about publish process',
      '(null)',
      '8',
      'LCR',
      'ACTIVE');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '100',
      'EAMS_SYS_VIEW',
      'EAMS Overview',
      'Provides overview of EAMS System',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '201',
      'PUB_CTHR_DIR_STATS_LIVE',
      'Public Catcher Directory Statistics (Live)',
      'Provides statistics on Public Catcher Directories',
      '1',
      '25000',
      'INACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '202',
      'PRE_ING_ASSET_PRGRS',
      'Assets In Progress',
      'Provides details on assets in progress',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '203',
      'PRE_ING_ERR_PKGS',
      'Packages In Error',
      'Provides details on packages in error',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '204',
      'PKG_DISC_STATS_7D',
      'Package Discovery Statistics (Last 7 Days)',
      'Provides statistics on package discovery in last 7 days',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '205',
      'PKG_DISC_STATS_BY_PROV_7D',
      'Package Discovery Statistics By Provider (Last 7 Days)',
      'Provides statistics on package discovery by provider in last 7 days',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '301',
      'RCNTLY_INGTD_PKGS',
      'Recent Ingested Packages',
      'Provides details about recently ingested packages',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '302',
      'RCNT_ING_FAILURES',
      'Recent Ingestion Failures',
      'Provides details about recent ingestion failures',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '303',
      'INGST_BY_PROVIDER',
      'Ingest By Provider',
      'Provides statistics by Provider',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '304',
      'INGST_BY_CATCHER',
      'Ingest By Catcher',
      'Provides statistics by Catcher',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '305',
      'INGST_STATS_TODAY',
      'Ingest Statistics (Today)',
      'Provides statistics on ingest as of today',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '306',
      'INGST_FAIL_BY_PROVIDER_7D',
      'Failures By Provider (Last 7 Days)',
      'Provides details about failures by each provider since 30 days',
      '6',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '307',
      'ING_ARV_FAIL_7D',
      'Package Arrival  And  Failure Rate (Last 7 Days)',
      'Provides details about package arrival and failure rate since 30 days',
      '7',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '308',
      'ING_PROC_RATE_7D',
      'Ingest Completion Rate (Last 7 Days)',
      'Provides statistics on  ingestion completion rate',
      '8',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '309',
      'INGST_AVG_PROC_RATE_7D',
      'Ingest Average Processing Time (Last 7 Days)',
      'Provides statistics on Average processing time since 30 days',
      '9',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '310',
      'INGST_STATS_STAGES',
      'Packages In Various Stages (Live Statistics)',
      'Provides ingest statistics on various stages',
      '10',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '401',
      'RCNT_QA_ASSETS',
      'Recent Assets In QA Process',
      'Recent Assets in QA Process',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '402',
      'RCNT_QA_FAILURES',
      'Recent QA Failures',
      'Recent QA Failures',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '403',
      'QA_STATS_BY_PROVIDER_7D',
      'QA Statistics By Provider (Last 7 Days)',
      'Provides QA process statistics grouped by provider for last 7 days',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '404',
      'QA_STATS_BY_QA_SYS_7D',
      'QA Statistics By QA Systems (Last 7 Days)',
      'Displays the QA process statistics grouped by QA sub systems for last 7 days',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '405',
      'QA_SUB_FAIL_RATE_7D',
      'QA Submission And Failure  Rate (Last 7 Days)',
      'Provides statistics of submission and failure rate for last 7 days',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '501',
      'RCNT_ASSETS_TRANS',
      'Recent Assets In Transcode Process',
      'Recent assets in Transcode Process',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '502',
      'RCNT_TRANS_FAIL',
      'Recent Transcode Failures',
      'Recent Transcode failures',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '503',
      'TRANS_BY_PROVIDER_7D',
      'Transcode Statistics By Provider (Last 7 Days)',
      'Provides Transcode process statistics grouped by provider for last 7 days',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '504',
      'STATS_BY_TRANS_SYS_7D',
      'Transcode Statistics By Sub Systems (Last 7 Days)',
      'Provides Transcode sub-system statistics for last 7 days',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '505',
      'TRANS_SUB_FAIL_RATE_7D',
      'Transcoding Submission And Failure Rate (Last 7 Days)',
      'Provides statistics of submission and failure rate of Transcode Process for last 7 days',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '701',
      'RCNT_ASSETS_ENCRYPT',
      'Recent Assets In Encryption Process',
      'Recent assets in Encryption Process',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '702',
      'RCNT_ENCRYPT_FAIL',
      'Recent Encryption Failures',
      'Recent Encryption failures',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '703',
      'ENCRYPT_BY_PROVIDER_7D',
      'Encryption Statistics By Provider (Last 7 Days)',
      'Provides Encryption process statistics grouped by provider for last 7 days',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '704',
      'STATS_BY_ENCRYPT_SYS_7D',
      'Encryption Statistics By Sub Systems (Last 7 Days)',
      'Provides Encrypt sub-system statistics for last 7 days',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '705',
      'ENCRYPT_SUB_FAIL_RATE_7D',
      'Encryption Submission And Failure Rate (Last 7 Days)',
      'Provides statistics of submission and failure rate of Encryption Process for last 7 days',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '801',
      'RCNT_PKGS_PUB',
      'Recent Packages Being Published',
      'Provides packages that are being published',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '802',
      'RCNT_PUB_FAIL',
      'Recent Publish Failures',
      'Provides recent publish failures',
      '2',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '803',
      'PUB_PROG_BY_TRGT_PLATFORM',
      'Publish Progress By Target Platforms (Last 7 Days)',
      'Provides statistics based on target platforms for the last 7 days',
      '3',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '804',
      'PUB_BY_PROVIDER_7D',
      'Published By Provider (Last 7 Days)',
      'Provides publish statistics baased on provider for the last 7 days',
      '4',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '805',
      'PUB_ARV_FAIL_RATE_7D',
      'Arrival And Failure Rate (Last 7 Days)',
      'Provides arrival and failure rate of publish process for the past 7 days',
      '5',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '806',
      'PUB_COMPLETION_RATE_7D',
      'Publish Completion Rate (Last 7 Days)',
      'Provides the statistics on publishing rate for the pastt 7 days',
      '6',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item (
            widget_id,
            widget_name,
            display_name,
            description,
            display_order,
            refresh_period,
            status)
     VALUES (
      '901',
      'CATCHER_SUMMARY',
      'Catcher Summary',
      'Provides statistics of catcher',
      '1',
      '25000',
      'ACTIVE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('100', '1');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('201', '2');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('202', '2');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('203', '2');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('204', '2');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('205', '2');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('301', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('302', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('303', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('304', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('305', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('306', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('307', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('308', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('309', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('310', '3');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('401', '4');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('402', '4');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('403', '4');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('404', '4');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('405', '4');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('501', '5');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('502', '5');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('503', '5');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('504', '5');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('505', '5');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('701', '7');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('702', '7');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('703', '7');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('704', '7');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('705', '7');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('801', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('802', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('803', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('804', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('805', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('806', '8');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_dboard_item_assoc (widget_id, dboard_id
               )
     VALUES ('901', '9');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046476 release 1.2 on 08/08/2010 

PROMPT Begin CR LTUSR00046493 release 1.2 on 08/09/2010 

BEGIN
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 8, 'PKG_SMRY_STS.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 5, 'PUB_PND_GRD.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 7, 'PEND_CONT_EXPRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 12, 'CONT_PROC_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  1, 13, 'CC_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  2, 13, 'CC_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 13, 'CC_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  1, 14, 'INVTRY_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  2, 14, 'INVTRY_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 14, 'INVTRY_STS_SMRY.jasper', 1);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO CCE_RPT_EXPORT_ASSOC ( EXPORT_OPT_ID, REPORT_ID, JRXML_FILE_NAME,
  DISPLAY_OPT_ID ) VALUES ( 
  3, 15, 'SEC_UG_SMRY.jasper', 1); 

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
 
COMMIT;

PROMPT End CR LTUSR00046493 release 1.2 on 08/09/2010

PROMPT Begin CR LTUSR00046452 release 1.2 on 08/12/2010 

BEGIN 
  INSERT INTO cce_item_category (
             item_category_id,
             item_category_version,
             item_category_name,
             item_category_status_code,
             lang_code,
             display_seq,
             vendor_id,
             start_date,
             ic_source_ind,
             ic_valid_ind,
             create_time,
             create_by,
             leaf_ind,
             ic_eu_display_ind,
             child_ic_display_seq_type,
             child_item_display_seq_type,
             ic_resolution,
             ic_class_type,
             ic_content_type,
             ic_category,
             ic_asset_class,
             ic_rating,
             restricted_ind,
             ic_provider_id,
             ic_provider_code,
             ic_provider_version,
             ic_provider_name,
             ic_provider_desc,
             ic_provider_usage_type,
             item_category_desc,
             item_cat_icon_image_name,
             end_date,
             last_modify_time,
             last_modify_by)
     VALUES (
      0,
      '0.0',
      'PREINGEST',
      2,
      'eng',
      1,
      1,
      1278403819370,
      2,
      1,
      1278403819370,
      'SISUPERUSR',
      1,
      1,
      1,
      1,
      NULL,
      NULL,
      41,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      NULL,
      
      2,
      NULL,
      NULL,
      NULL,
      1278457276600,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
  
UPDATE EAMS_RULEGROUP 
SET    STATUS = 'ACTIVE' 
WHERE  RULEGROUP_ID = 8000;

UPDATE EAMS_RULEGROUP 
SET    STATUS ='INACTIVE' 
WHERE  RULEGROUP_ID = 1000;

UPDATE CCE_ITEM_CATEGORY 
SET    VENDOR_ID = 1 
WHERE  ITEM_CATEGORY_ID = 0
AND    ITEM_CATEGORY_VERSION = '0.0';

COMMIT;

PROMPT End CR LTUSR00046452 release 1.2 on 08/12/2010 

PROMPT Begin CR LTUSR00046574 release 1.2 on 08/13/2010 

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      100,
      '15100',
      'Discovery Service Error',
      'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      101,
      '15101',
      'Discovery Service Error',
      'Not able to invoke Discovery Perl Service');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      102,
      '15102',
      'Discovery Service Error',
      'Unable to Move Discovered Package');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      103,
      '15200',
      'Role Recognition Service Error',
      'Internal Role Recognizer Error (Missing Property file or Invalid Profile)');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      104,
      '15201',
      'Role Recognition Service Error',
      'No Such Resource Found to Recognize');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      105,
      '15202',
      'Role Recognition Service Error',
      'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      106,
      '15300',
      'Normalization Service Error',
      'Unable to perform Normalization or unsupported resource to perform character normalization');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      107,
      '15301',
      'Normalization Service Error',
      'No Such Resource Found to Normalize');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      108,
      '15302',
      'Normalization Service Error',
      'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      109,
      '15400',
      'Resource Analysis Service Error',
      'Internal Resource Analyser  Error (Missing Property File)');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      110,
      '15401',
      'Resource Analysis Service Error',
      'No Such Resource Found to analyze');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      111,
      '15402',
      'Resource Analysis Service Error',
      'Unable to reach Media Info or Error while processing Media Info');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      112,
      '15403',
      'Resource Analysis Service Error',
      'Invalid or Empty Context Data OR Unable to recognize Profile');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      113,
      '15500',
      'Correlation Service Error',
      'Internal Correlation  Error');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      114,
      '15501',
      'Correlation Service Error',
      'No Such Resource Found to Correlate');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      115,
      '15502',
      'Correlation Service Error',
      'Invalid or Empty Context Data OR Unable to recognize Profile');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      116,
      '15600',
      'Workflow Identification Error',
      'Invalid or Empty Context Data OR Unable to identify Workflow');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      117,
      '15601',
      'Workflow Identification Error',
      'More than one matching local catcher');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      118,
      '15602',
      'Workflow Identification Error',
      'No Matching Local Catcher');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      119,
      '15700',
      'Package Distribution Error',
      'No Such Resource Found to distribute');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      120,
      '15701',
      'Package Distribution Error',
      'Failed the Package Distribution to target catcher');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      121,
      '15702',
      'Package Distribution Error',
      'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      122,
      '15800',
      'Convertor Service Error',
      'ConvertService not able to Convert');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      123,
      '15801',
      'Convertor Service Error',
      'ContextData is Null OR Convertor service didnt recieve correct InputPath/OutputPath');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      124,
      '15802',
      'Convertor Service Error',
      'Internal Convertor  Error (Missing Property File)');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      125,
      '15900',
      'Profile Selection Error',
      'Internal Profile Selector Service  Error');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      126,
      '15901',
      'Profile Selection Error',
      'ContextData is Null OR Profile service didnt recieve correct request');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      127,
      '15902',
      'Profile Selection Error',
      'Invalid or Empty Context Data');
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

PROMPT End CR LTUSR00046574 release 1.2 on 08/13/2010 

PROMPT Begin CR LTUSR00046577 release 1.2 on 08/13/2010 

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_disp_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by)
     VALUES (
      36,
      'PKGPROPERTY',
      'Package Property File',
      NULL,
      'ACTIVE',
      cce_util#pkg.datetoms (SYSDATE),
      'SISUPERUSR',
      NULL,
      NULL);
      
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;

PROMPT End CR LTUSR00046577 release 1.2 on 08/13/2010 

PROMPT Begin CR LTUSR00046578 release 1.2 on 08/13/2010 

UPDATE eams_polling_jobs
	SET job_interval = 5
 WHERE job_id = 4;

COMMIT;

PROMPT End CR LTUSR00046578 release 1.2 on 08/13/2010 

PROMPT Begin CR LTUSR00046652 release 1.2 on 08/18/2010 

BEGIN 
   INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (
      8,
      'Post Conversion Normalization',
      'ACTIVE',
      1212121,
      'SISUPERUSR',
      NULL,
      NULL);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep (
           workstep_id,
           workstep_name,
           status,
           create_time,
           create_by,
           last_modify_time,
           last_modify_by)
     VALUES (7, 'Autodetect', 'ACTIVE', 1212121, 'SISUPERUSR', NULL, NULL);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_rulegroup_assoc (
                 workstep_id,
                 rulegroup_id,
                 status,
                 create_time,
                 create_by,
                 last_modify_time,
                 last_modify_by)
     VALUES (8, 4000, 'ACTIVE', 111, NULL, NULL, NULL);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_rulegroup_assoc (
                 workstep_id,
                 rulegroup_id,
                 status,
                 create_time,
                 create_by,
                 last_modify_time,
                 last_modify_by)
     VALUES (7, 6000, 'ACTIVE', 111, NULL, NULL, NULL);

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Metadata Conversion'
 WHERE workstep_id = 100
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Resource Discovery'
 WHERE workstep_id = 1
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Resource Normalization'
 WHERE workstep_id = 3
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Resource Analysis'
 WHERE workstep_id = 4
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Workflow Identification'
 WHERE workstep_id = 5
/

UPDATE eams_workstep
 SET create_time = 1212121, workstep_name = 'Package Ingestion'
 WHERE workstep_id = 6
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (3, 25, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (3, 26, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (7, 8, 'ACTIVE', 'SINGLE-RESOURCEGROUP');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (5, 31, 'ACTIVE', 'SINGLE-RESOURCEGROUP');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (8, 23, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (8, 9, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (8, 26, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_workstep_role_assoc (
                workstep_id,
                role_id,
                status,
                workstep_type)
     VALUES (4, 23, 'ACTIVE', 'SINGLE-RESOURCE');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_resource_role (
              role_id,
              role_name,
              role_type,
              status,
              create_time,
              create_by,
              last_modify_time,
              last_modify_by,
              role_disp_name)
     VALUES (
      36,
      'PKGPROPERTY',
      NULL,
      'ACTIVE',
      1281631733000,
      'SISUPERUSR',
      NULL,
      NULL,
      'Package Property File');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

PROMPT End CR LTUSR00046652 release 1.2 on 08/18/2010 

PROMPT Begin CR LTUSR00046666 release 1.2 on 08/19/2010 

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (3, 9, 'ACTIVE', 'SINGLE-RESOURCE')
/

COMMIT;

PROMPT End CR LTUSR00046666 release 1.2 on 08/19/2010 

PROMPT Begin CR LTUSR00046715 release 1.2 on 08/24/2010 

BEGIN 
  INSERT INTO eams_polling_jobs (
             job_id,
             job_name,
             impl_class,
             job_interval,
             job_interval_unit,
             reset_on_startup)
     VALUES (
      5,
      'NeStatusMonitorJob',
      'com.motorola.eams.rm.jobs.NeStatusMonitorJob',
      5,
      2,
      'Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_polling_jobs (
             job_id,
             job_name,
             impl_class,
             job_interval,
             job_interval_unit,
             reset_on_startup)
     VALUES (
      6,
      'JobStatusMonitorJob',
      'com.motorola.eams.rm.jobs.JobStatusMonitorJob',
      5,
      2,
      'Y');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO eams_polling_jobs (
             job_id,
             job_name,
             impl_class,
             job_interval,
             job_interval_unit,
             reset_on_startup)
     VALUES (
      7,
      'PendingJobsHandlerJob',
      'com.motorola.eams.rm.jobs.PendingJobsHandlerJob',
      5,
      2,
      'Y');
    
  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT; 

PROMPT End CR LTUSR00046715 release 1.2 on 08/24/2010 

PROMPT Begin CR LTUSR00046720 release 1.2 on 08/24/2010 

UPDATE eams_resource_role
	SET role_type = 'WORKSTEP'
 WHERE role_id IN
			 (1,
			  2,
			  3,
			  4,
			  5,
			  6,
			  7,
			  9,
			  10,
			  11,
			  12,
			  13,
			  14,
			  15,
			  18,
			  19,
			  20,
			  21,
			  22,
			  23,
			  25,
			  26);

UPDATE eams_resource_role
	SET role_type = 'WORKFLOW'
 WHERE role_id IN (8, 16, 17, 24, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36);

COMMIT;

PROMPT End CR LTUSR00046720 release 1.2 on 08/24/2010 

PROMPT Begin CR LTUSR00046764 release 1.2 on 08/28/2010

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      105,
      '15203',
      'Role Recognition Service Error',
      'Role is not supported');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      105,
      '15204',
      'Role Recognition Service Error',
      'Unknown File foramat(unnownExtension)');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      108,
      '15304',
      'Normalization Service Error',
      'PerlService  return failure(Unsupported special characters)
');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      118,
      '15603',
      'Workflow Identification Error',
      'WorkFlowIdentification : Macthing Catcher not found
');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info (
             error_id,
             ERROR_CODE,
             error_short_desc,
             error_long_desc)
     VALUES (
      124,
      '15803',
      'Convertor Service Error',
      'Profile un-defined in ConvertionService');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   100,
   '15100',
   'Discovery Service Error',
   'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  101,
  '15101',
  'Discovery Service Error',
  'Not able to invoke Discovery Perl Service');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  102,
  '15102',
  'Discovery Service Error',
  'Unable to Move Discovered Package');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   103,
   '15200',
   'Role Recognition Service Error',
   'Internal Role Recognizer Error (Missing Property file or Invalid Profile)');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   104,
   '15201',
   'Role Recognition Service Error',
   'MetaDataParsing Failure');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   105,
   '15202',
   'Role Recognition Service Error',
   'Invalid or Empty Context Data');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   106,
   '15300',
   'Normalization Service Error',
   'Unable to perform Normalization or unsupported resource to perform character normalization');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   107,
   '15301',
   'Normalization Service Error',
   'No Such Resource Found to Normalize');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   108,
   '15302',
   'Normalization Service Error',
   'Invalid or Empty Context Data');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
   109,
   '15400',
   'Resource Analysis Service Error',
   'Internal Resource Analyser  Error (Missing Property File)');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  110,
  '15401',
  'Resource Analysis Service Error',
  'No Such Resource Found to analyze');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  111,
  '15402',
  'Resource Analysis Service Error',
  'Unable to reach Media Info or Error while processing Media Info');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  112,
 '15403',
 'Resource Analysis Service Error',
 'Invalid or Empty Context Data OR Unable to recognize Profile'); 
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  113,
  '15500',
  'Correlation Service Error',
  'Internal Correlation  Error');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
  114,
  '15501',
  'Correlation Service Error',
  'No Such Resource Found to Correlate');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 115,
 '15502',
 'Correlation Service Error',
 'Invalid or Empty Context Data OR Unable to recognize Profile');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 116,
 '15600',
 'Workflow Identification Error',
 'Invalid or Empty Context Data OR Unable to identify Workflow');
 
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 117,
 '15601',
 'Workflow Identification Error',
 'More than one matching local catcher');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 118,
 '15602',
 'Workflow Identification Error',
 'No Matching Local Catcher');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 119,
 '15700',
 'Package Distribution Error',
 'No Such Resource Found to distribute');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 120,
 '15701',
 'Package Distribution Error',
 'Failed the Package Distribution to target catcher');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 121,
 '15702',
 'Package Distribution Error',
 'Invalid or Empty Context Data');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 122,
 '15800',
 'Convertor Service Error',
 'ConvertService not able to Convert');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 123,
 '15801',
 'Convertor Service Error',
 'ContextData is Null OR Convertor service didnt recieve correct InputPath/OutputPath');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 124,
 '15802',
 'Convertor Service Error',
 'Internal Convertor  Error (Missing Property File)');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 125,
 '15900',
 'Profile Selection Error',
 'Internal Profile Selector Service  Error');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 126,
 '15901',
 'Profile Selection Error',
 'ContextData is Null OR Profile service didnt recieve correct request');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

BEGIN 
  INSERT INTO cce_error_code_info(
    error_id,error_code,
    error_short_desc,
    error_long_desc)
  VALUES (
 127,
 '15902',
 'Profile Selection Error',
 'Invalid or Empty Context Data');
 EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

UPDATE cce_error_code_info
 SET  error_long_desc = 'MetaDataParsing Failure'
 WHERE error_id = 104
/

COMMIT;

PROMPT End CR LTUSR00046764 release 1.2 on 08/28/2010 

PROMPT Begin CR LTUSR00046765 release 1.2 on 08/28/2010 

UPDATE eams_polling_jobs
SET    job_interval = 10
WHERE  job_id = 4;

COMMIT;

PROMPT End CR LTUSR00046765 release 1.2 on 08/28/2010 

PROMPT Begin CR LTUSR00046790 release 1.2 on 09/01/2010 

UPDATE EAMS_PROFILE_FIELD_INFO 
SET    FIELD_VALUE = '7' -- ALL-FIOS
WHERE  FIELD_ID = 500094 
AND    FIELD_VALUE IN ('2') -- FIOS
AND    PROFILE_ID IN (SELECT PROFILE_ID 
                      FROM   EAMS_PROFILE 
                      WHERE  MEDIA_TYPE = '4'
                      AND    NE_TYPE_ID = 7);

COMMIT;

PROMPT End CR LTUSR00046790 release 1.2 on 09/01/2010 

PROMPT Begin CR LTUSR00045102 release 1.2.1 on 09/28/2010 

UPDATE EAMS_PROFILE_FIELD_INFO 
SET FIELD_VALUE = '7' -- ALL-FIOS
WHERE FIELD_ID = 500094 
AND FIELD_VALUE IN ('2') -- FIOS
AND PROFILE_ID IN (SELECT PROFILE_ID
				  FROM EAMS_PROFILE
				  WHERE MEDIA_TYPE = '4' 
				  AND NE_TYPE_ID = 7);
				  
COMMIT;	

PROMPT End CR LTUSR00045102 release 1.2.1 on 09/28/2010

PROMPT Begin CR-46767  release 1.2.1

PROMPT -- Insert  into the CCE_EVENT_FILE_CONFIG_DATA
DECLARE
V_EVENT_FILE_CONFIG_INFO_ID NUMBER;
BEGIN
SELECT MAX(EVENT_FILE_CONFIG_INFO_ID)+1
INTO V_EVENT_FILE_CONFIG_INFO_ID 
FROM CCE_EVENT_FILE_CONFIG_DATA;
INSERT INTO CCE_EVENT_FILE_CONFIG_DATA(EVENT_FILE_CONFIG_INFO_ID,
COMP_TYPE,
COMP_TYPE_VERSION_NO,
EVENT_TYPE,
EVENT_FILE_PATH_NAME,
EVENT_FILE_NAME_PREFIX,
EVENT_FILE_COUNT,
EVENT_FILE_OPEN_TIME_PEROD_HRS,
EVENT_FILE_BUFFER_SIZE_KBYTE,
EVENT_FILE_MAX_DAYS,
EVENT_MAX_DISK_SIZE_KBYTE,
EVENT_DATA_OUTQ_MAX_SIZE_KBYTE)
VALUES (V_EVENT_FILE_CONFIG_INFO_ID,11017,'1.0',5,'/var/cce/inst_2/si/logs','EAMSWorkFlowManager',1,24,10000,5,50000,100);
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
PROMPT -- Insert into CCE_COMP_LOG_LEVEL
BEGIN
INSERT INTO CCE_COMP_LOG_LEVEL
( COMP_ID,COMP_DEBUG_LEVEL, COMP_VERSION_NO) VALUES (46,4,'1.0');
EXCEPTION
WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;

PROMPT End CR-46767  release 1.2.1
PROMPT Begin CR-46792  release 1.2.1

UPDATE CCE_FIELD_INFO  
SET FIELD_DISPLAY_NAME='Package Name' ,
    FIELD_PROP='col=3;row=3;'
WHERE FIELD_ENUM_ID=5001;

COMMIT;

UPDATE CCE_FIELD_INFO
SET FIELD_TYPE ='LIST-STR' 
WHERE FIELD_ENUM_ID = 2715;

COMMIT;

UPDATE CCE_FIELD_GROUP_FLD_ASSOC
SET FIELD_PRIVILEGE=2 
WHERE FIELD_GROUP_ID IN (SELECT FIELD_GROUP_ID from CCE_FIELD_GROUP_INFO where FIELD_GROUP_NAME ='ReprocessPackage Filter')
AND FIELD_ID in (SELECT FIELD_ID from CCE_FIELD_INFO WHERE FIELD_ENUM_ID=5001);

COMMIT;

PROMPT End CR-46792  release 1.2.1

PROMPT BEGIN CR-PNG_FOR_VOD release 1.2.1

prompt -- Enable target format support for PNG-Box cover and poster 
UPDATE EAMS_MEDIA_FORMAT 
SET TARGET_FORMAT ='Y'
WHERE media_format_id in(73, 74)
/
COMMIT;
prompt --  Rename PNG-Box to PNG-Source-BoxCover
UPDATE EAMS_MEDIA_FORMAT
SET MEDIA_FORMAT_NAME ='PNG-Source-BoxCover' 
WHERE media_format_id =74 
AND media_format_name = 'PNG-Box'
/
COMMIT;
prompt --  Rename PNG-Poster to PNG-Source-Poster
UPDATE EAMS_MEDIA_FORMAT 
SET MEDIA_FORMAT_NAME ='PNG-Source-Poster' 
WHERE media_format_id =73 
AND media_format_name = 'PNG-Poster'
/
COMMIT;

PROMPT End CR-PNG_FOR_VOD release 1.2.1

PROMPT Begin CR-LTUSR00046602 for release 1.2.3

UPDATE CCE_RPT_FILTERS 
SET RPT_FIELD_TYPE='DCOLLECTION' 
WHERE REPORT_ID=(SELECT REPORT_ID FROM CCE_REPORT_DEF WHERE REPORT_NAME='PKG_SMRY_STS')
AND RPT_FIELD_NAME='F_PACKAGE_VERSION'
/

PROMPT End CR-LTUSR00046602 for release 1.2.3
spool off
