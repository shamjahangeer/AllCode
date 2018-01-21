spool siwls_migpreconfig.lst

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION =  '^CCE_DB_SCHEMA_VERSION^',
version_date = TO_DATE('^CCE_DB_SCHEMA_DATE^', 'MM/DD/YYYY HH24:MI')
WHERE object_type in 
('PRECONFIG', 'VIEWS', 'PACKAGES', 'TRIGGERS', 'TEMPTABLES', 'ADMIN');

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION = '^CCE_PROD_BUILD_ID^',
version_date = TO_DATE('^CCE_PROD_BUILD_DATE^', 'MM/DD/YYYY HH24:MI')
WHERE object_type = 'Communication Convergence Engine (CCE)';

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION = '^CCE_PLTF_BUILD_ID^',
version_date = TO_DATE('^CCE_PLTF_BUILD_DATE^', 'MM/DD/YYYY HH24:MI')
WHERE object_type = 'FRAMEWORK';

UPDATE CCE_SCHEMA_VERSIONING
SET VERSION = '^CCE_PRODUCT^',
version_date = TO_DATE('^CCE_DB_SCHEMA_DATE^', 'MM/DD/YYYY HH24:MI')
WHERE object_type = 'PRODUCT';

DECLARE 
  l_dummy INTEGER;
  l_object_type CONSTANT cce_schema_versioning.object_type%TYPE := 'PATCH';
BEGIN
  SELECT 1
  INTO   l_dummy
  FROM   cce_schema_versioning
  WHERE  object_type = l_object_type
  AND    ROWNUM = 1;
  
  UPDATE cce_schema_versioning
  SET    version =  '^CCE_DB_SCHEMA_VERSION^',
         version_date = TO_DATE('^CCE_DB_SCHEMA_DATE^', 'MM/DD/YYYY HH24:MI')
  WHERE  object_type = l_object_type;      
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN     
         INSERT INTO cce_schema_versioning (object_type, 
                                            version, 
                                            version_date, 
                                            version_desc)
         SELECT l_object_type,
                version, 
                version_date, 
                version_desc
         FROM   cce_schema_versioning
         WHERE  object_type = 'ADMIN';                         
END;
/

spool off 
--Disable vendor modify trigger as the update script updates Vendor.
ALTER TRIGGER CCE_VENDOR_MOD_CHECK DISABLE;

@@siwlspreconfigupd.sql

ALTER TRIGGER CCE_VENDOR_MOD_CHECK ENABLE;

@@si_pre_mig.sql

spool siwls_migpreconfig2.lst

spool off 

@@siwlsrefpreconfig.sql

@@siwls_was_update.sql

@@si_post_mig.sql

commit;

DECLARE
  l_time NUMBER;
BEGIN
  l_time := cce_util#pkg.datetoms(SYSDATE);
  
  EXCEPTION 
    WHEN OTHERS THEN NULL;
END;
/

spool siwls_migpreconfig3.lst

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

PROMPT Begin CR LTUSR00046256 release 1.2 on 07/28/2010 

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

PROMPT End CR LTUSR00046339 release 1.2 on 08/02/2010 

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
 VALUES (73,500094,'2');
      
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


