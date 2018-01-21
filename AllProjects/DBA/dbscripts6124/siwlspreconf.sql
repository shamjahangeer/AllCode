INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (43, '9118', 'Media File missing in NAS', 'Place Media File'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (44, '9115', 'Unsupported Media format type',
             'Configure Media format type '
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (45, '9116',
             'Asset id length exceeds Specification defined size',
             'Use Metadata editor'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (46, '9117', 'XML Schema Missing in Server Profile location',
             'Place the Metadata in correct profile location'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (47, '9202', 'Content FileSize Validation Error',
             'Check the file size in NAS'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (48, '9205', 'File Size Error', 'File Size Error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (49, '9206', 'Checksum error ', 'File check sum error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (50, '9207', 'XML Validation Error', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (51, '9208', 'Content Type Error', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (52, '9500',
             'Workflow not configured  Criteria failed not able ',
             'Criteria not defined shall use default workflow'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (53, '9501', 'Transcoder not reachable',
             'Not able to reach agility transcoder'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (54, '9502', 'Transcode: Preset id is wrong or not configured',
             'Check Profile of transcoder'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (56, '9209', 'Metadata Check Error', 'Metadata Check for ADI Tags'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (9, '4000', 'System Resource Error- Spool to Copy Move Failed', NULL
            )
/
INSERT INTO cce_error_code_info (error_id,
                                 ERROR_CODE,
                                 error_short_desc,
                                 error_long_desc)
VALUES (81, '4001', 'System Resource Error Package not moved properly', NULL)
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (58, '9600',
             'Publishing System Failed',
             'NOT ABLE TO PUBLISH'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (59, '9601', 'ASPERA TRANSFER FAILED',
             'File -Dir Transfer using Aspera Failed'
            )
/

INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (12, '9100', 'Metadata File Not Found',
             'The metadata XML file is not found in the specified location'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (13, '9101', 'Schema not found',
             'The schema specified in the Metadata XML file could not be located'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (14, '9102', 'Unsupported Metadata',
             'The Metadata format is not supported (ex. ADI 2.0)'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (15, '9104', 'Mandatory tag missing',
             'Mandatory metadata tag missing in the Metadata XML file'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (16, '9105', 'Package is Duplicate of prev Version',
             'The provider version in the xml is less than that of its predecessor.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (17, '9106', 'Vendor not found',
             'The vendor specified in Metadata file could not be found in CCE_VENDOR_INFO table'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (18, '9107',
             'Merge Conflict Previous Version not ingested /ERRO',
             'The previous package version is in an invalid state to do the merge.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (19, '9108', 'Asset not matching',
             'The package or title asset class is having a different asset Id than its predecessor'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (20, '9109', 'Content tag missing',
             'The content tag could not be located inside the Metadata file to update its location'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (21, '9110', 'Unable to Reject package',
             'The Metadata file could not be moved to the error directory'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (22, '9111', 'Merge Conflict Previous Version Manually Edited',
             'Previous Version Manually edited.Merge cant be done automatically.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (23, '9114', 'Doctype tag Missing',
             'The DocType tag is missing in the Metadata XML'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (32, '9012', 'NAS Disk Space Error', 'Check NAS is Mounted'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (24, '9200', 'Rating Validation Error', 'Rating Validation Error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (10, '9023', 'Catcher Not Reachable', 'Contact EAMS Admin'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (11, '9103', 'Metadata not Well Formed',
             'The XML tags are not well formed in the Metadata XML file.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (25, '9204', 'MetaInfo Validation Error',
             'Metadata Info Validation Error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (26, '9201', 'Studio Validation Error', 'Studio error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (27, '9020', 'DM Not Reachable', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (28, '9021', 'NAS Not Reachable', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (57, '9022', 'ODES Not Reachable', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (30, '9300', 'Unstable Install Error', NULL
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (29, '9000', 'Database Connection Failure',
             'Database configuration in Datasource error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (31, '9001', 'SQL ERROR', 'Contact DBA'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (34, '9002', 'Application Error', 'Check WPS Choreographer'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (33, '9024', 'BPM errors', 'Check WPS DB'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (35, '9010', 'SMTP Not configured', 'Check EAMS Config'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (36, '9011', 'SMS Gateway Error', 'Configure SMS gateway'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (39, '9051', 'EAMS Agent FAILED to COPY',
             'Check Permissions on NAS'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (38, '9013', 'EAMS Disk Error', 'EAMS Disk may be Full'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (37, '9050', 'EAMS Agent Not responding',
             'Check EAMS_AGENT_URL Configuration in EAMS Network element'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (40, '9052', 'EAMS Agent FAILED to UNZIP',
             'zip file may be corrupt'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (41, '9112',
             'Not able to update package ( all versions inactive',
             'Use Metadata editor '
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (42, '9113', 'Metadata Parsing Error',
             'Not able to parse Metadata'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE,
             error_short_desc,
             error_long_desc
            )
     VALUES (61, '9251',
             'Asset Not Present mentioned by Publication Profile',
             'Publication Profile Media Format not present in Package'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (62, '9203', 'Licensing Date Validation Error',
             'Start and End Date License date validation failed'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (64, '9252', 'Fill EM Specific fields',
             'Fill Values for EM Specific Fields in the Metadata'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (65, '9210', 'CSV Format Error -Category Error',
             'Check the CSV in EAMS NE PROFILE'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (66, '9552', 'Transcoder Internal Error',
             'Transcoder Internal Error'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (67, '9551', 'Transcode: Error while doing the Transcoding',
             'Job Failure after successful submission.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (68, '9700', 'Encrypt:The input,output file not writable',
             'Job Failure after successful submission.'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (69, '9701', 'Encryption Server not reachable',
             'Not able to reach WIN ENCRYPTOR'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (70, '9702', 'Profile Configuration Mismatch',
             'Check WIN DRM PROFILE'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (71, '9603', 'Cannot Execute RSYNC Command',
             'RSYNC Command execution failed'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc,
             error_long_desc
            )
     VALUES (72, '9604', 'Cannot Deliver Content to VELOCIX',
             'Cannot Deliver Content to Velocix'
            )
/
INSERT INTO cce_error_code_info
            (error_id, ERROR_CODE, error_short_desc, error_long_desc
            )
     VALUES (73, '9605', 'SFTP To EM Failed', 'SFTP Failed'
            )
/
INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (74,'9250','Transformation Rule Failed','Transformation Rule Failed')
/   
INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (75,'9253','Transformation Error','Transformation Error')
/   
INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (76,'1001','QA Package Error','QA Package Error');

INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (
    82, '9553', 'Manual Transcode', 'Transcode has to be done manually')
/

INSERT INTO cce_error_code_info (error_id,
                                 ERROR_CODE,
                                 error_short_desc,
                                 error_long_desc)
VALUES (83, '9751', 'Manual Encrypt', 'Encryption has to be done manually')
/    

INSERT INTO cce_error_code_info (error_id, 
                                 error_code, 
                                 error_short_desc, 
                                 error_long_desc) 
VALUES (84, 
        '9119', 
        'Transformation Rules Error', 
        'Exception during excution of Transformation Rules')
/        

INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (
    85,
    '9120 ',
    'Close Captioned File not present',
    'Close Captioned File not present')
/

INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (
    86,
    9504,
    'Media info error',
    'Could not obtain media parameters using mediainfo')
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

INSERT INTO cce_error_code_info (
           error_id,
           ERROR_CODE,
           error_short_desc,
           error_long_desc)
   VALUES (
    104,
    '15201',
    'Role Recognition Service Error',
    'MetaDataParsing Failure');

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
      'Unknown File foramat(UnKnownExtension)');

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
      'PerlService  return failure(Unsupported special characters)');

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
      'Unable to find a matching Local Catcher');

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
 'Unable to move the package to the Local Catcher');
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

COMMIT; 

PROMPT Begin CR-47750 for the release 1.2.1

DECLARE
V_ERROR_ID NUMBER;
BEGIN
SELECT MAX(ERROR_ID)+1
INTO V_ERROR_ID 
FROM CCE_ERROR_CODE_INFO;

INSERT INTO CCE_ERROR_CODE_INFO(
			 error_id,error_code,
			 error_short_desc,
			 error_long_desc)
	 VALUES (
	  V_ERROR_ID,
	  '15100',
	  'Discovery Service Error',
	  'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/

COMMIT;
PROMPT -- inserting error_id into the cce_error_code_info for errorcode 15202
DECLARE
V_ERROR_ID NUMBER;
BEGIN
SELECT MAX(ERROR_ID)+1
INTO V_ERROR_ID 
FROM CCE_ERROR_CODE_INFO;

INSERT INTO CCE_ERROR_CODE_INFO(
			 error_id,error_code,
			 error_short_desc,
			 error_long_desc)
	 VALUES (
	  V_ERROR_ID,
	  '15202',
	  'Role Recognition Service Error',
	  'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
PROMPT -- inserting error_id into the cce_error_code_info for errorcode 15302
DECLARE
V_ERROR_ID NUMBER;
BEGIN
SELECT MAX(ERROR_ID)+1
INTO V_ERROR_ID 
FROM CCE_ERROR_CODE_INFO;

  INSERT INTO CCE_ERROR_CODE_INFO(
			 error_id,error_code,
			 error_short_desc,
			 error_long_desc)
	 VALUES (
	  V_ERROR_ID,
	  '15302',
	  'Normalization Service Error',
	  'Invalid or Empty Context Data');

  EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;
END;
/
COMMIT;
PROMPT -- inserting error_id into the cce_error_code_info for errorcode 15602
DECLARE
V_ERROR_ID NUMBER;
BEGIN
SELECT MAX(ERROR_ID)+1
INTO V_ERROR_ID 
FROM CCE_ERROR_CODE_INFO;

   INSERT INTO CCE_ERROR_CODE_INFO(
			 error_id,error_code,
			 error_short_desc,
			 error_long_desc)
	 VALUES (
	V_ERROR_ID,
	'15602',
	'Workflow Identification Error',
	'No Matching Local Catcher');
	EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;

END;
/
COMMIT;

PROMPT -- inserting error_id into the cce_error_code_info for errorcode 15802
DECLARE
V_ERROR_ID NUMBER;
BEGIN
SELECT MAX(ERROR_ID)+1
INTO V_ERROR_ID 
FROM CCE_ERROR_CODE_INFO;

   INSERT INTO CCE_ERROR_CODE_INFO(
			 error_id,error_code,
			 error_short_desc,
			 error_long_desc)
	 VALUES (
	V_ERROR_ID,
	'15802',
	'Convertor Service Error',
	'Internal Convertor  Error (Missing Property File)');
	EXCEPTION
     WHEN DUP_VAL_ON_INDEX THEN NULL;

END;
/
COMMIT;
PROMPT End CR-47750 for the release 1.2.1

INSERT INTO eams_polling_jobs (
           job_name,
           impl_class,
           job_interval,
           job_interval_unit,
           reset_on_startup,
           job_id)
   VALUES (
    'TandbergMonitorJob',
    'com.motorola.eams.publish.jobs.TandbergMonitorJob',
    1,
    2,
    'Y',
    1);
    
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

INSERT INTO eams_polling_jobs (
           job_id,
           job_name,
           impl_class,
           job_interval,
           job_interval_unit,
           reset_on_startup)
   VALUES (
    4,
    'PublicCatherPollingJob',
    'com.motorola.eams.discovery.EAMSPublicCatcherPollingJob',
    10,
    1,
    'Y')
/

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

COMMIT;    

PROMPT INSERT INTO eams_workstep
INSERT INTO eams_workstep (
         workstep_id,
         workstep_name,
         status,
         create_time,
         create_by,
         last_modify_time,
         last_modify_by)
   VALUES (
    1, 'Resource Discovery', 'ACTIVE', 1212121, 'SISUPERUSR', NULL, NULL)
/

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
    1212121,
    'SISUPERUSR',
    NULL,
    NULL)
/

INSERT INTO eams_workstep (
         workstep_id,
         workstep_name,
         status,
         create_time,
         create_by,
         last_modify_time,
         last_modify_by)
   VALUES (
    3, 'Resource Normalization', 'ACTIVE', 1212121, 'SISUPERUSR', NULL, NULL)
/

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
    'Resource Analysis',
    'ACTIVE',
    1212121,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'Workflow Identification',
    'ACTIVE',
    1212121,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'Package Ingestion',
    'ACTIVE',
    1212121,
    'SISUPERUSR',
    NULL,
    NULL)
/

INSERT INTO eams_workstep (
         workstep_id,
         workstep_name,
         status,
         create_time,
         create_by,
         last_modify_time,
         last_modify_by)
   VALUES (7, 'Autodetect', 'ACTIVE', 1212121, 'SISUPERUSR', NULL, NULL)
/

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
    NULL)
/

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
    'Metadata Conversion',
    'ACTIVE',
    1212121,
    'SISUPERUSR',
    NULL,
    NULL)
/

COMMIT;

PROMPT INSERT INTO eams_rulegroup
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
    'INACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    NULL)
/

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
    NULL)
/

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
    NULL)
/

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
    NULL)
/

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
    NULL)
/

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
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    NULL)
/

COMMIT;

PROMPT INSERT INTO eams_resource_role 

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'INACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'INACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'INACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKSTEP',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/

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
    'WORKFLOW',
    'ACTIVE',
    1279366786397,
    'SISUPERUSR',
    NULL,
    NULL)
/    

COMMIT;

-- INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC 

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
1, 2000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
2, 3000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
3, 4000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
4, 5000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
5, 7000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
6, 8000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO eams_workstep_rulegroup_assoc (
               workstep_id,
               rulegroup_id,
               status,
               create_time,
               create_by,
               last_modify_time,
               last_modify_by)
   VALUES (7, 6000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO eams_workstep_rulegroup_assoc (
               workstep_id,
               rulegroup_id,
               status,
               create_time,
               create_by,
               last_modify_time,
               last_modify_by)
   VALUES (8, 4000, 'ACTIVE', 111, NULL, NULL, NULL)
/

INSERT INTO EAMS_WORKSTEP_RULEGROUP_ASSOC ( WORKSTEP_ID, RULEGROUP_ID, STATUS, CREATE_TIME,
CREATE_BY, LAST_MODIFY_TIME, LAST_MODIFY_BY ) VALUES ( 
100, 9000, 'ACTIVE', 111, NULL, NULL, NULL)
/

COMMIT;

-- INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
1, 1, 'ACTIVE', 'MULTIPLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
2, 4, 'ACTIVE', 'SINGLE-RESOURCE') 
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
3, 6, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
4, 13, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
4, 14, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
5, 8, 'ACTIVE', 'SINGLE-RESOURCEGROUP')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
2, 2, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
2, 19, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
4, 9, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
6, 33, 'ACTIVE', 'SINGLE-RESOURCEGROUP')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
100, 10, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
100, 11, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
100, 12, 'ACTIVE', 'SINGLE-RESOURCE')
/
INSERT INTO EAMS_WORKSTEP_ROLE_ASSOC ( WORKSTEP_ID, ROLE_ID, STATUS,
WORKSTEP_TYPE ) VALUES ( 
3, 3, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (3, 25, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (3, 26, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (7, 8, 'ACTIVE', 'SINGLE-RESOURCEGROUP')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (5, 31, 'ACTIVE', 'SINGLE-RESOURCEGROUP')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (8, 23, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (8, 9, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (8, 26, 'ACTIVE', 'SINGLE-RESOURCE')
/

INSERT INTO eams_workstep_role_assoc (
              workstep_id,
              role_id,
              status,
              workstep_type)
   VALUES (4, 23, 'ACTIVE', 'SINGLE-RESOURCE')
/

COMMIT;

--
-- Updates
--

PROMPT LTUSR00040508 release 1.1.1.11
UPDATE cce_vendor_info
SET    vendor_vendorid = 'VERIZON',
       vendor_name = 'VERIZON',
       last_modify_time = (SYSDATE - TO_DATE('19700101', 'yyyymmdd'))*86400*1000,
       last_modify_by = 'SISUPERUSR'
WHERE  vendor_id = 1;

COMMIT;

PROMPT LTUSR00044449 release 1.1.2 
UPDATE cce_field_info
SET    field_max_value = 4000
WHERE  field_display_name = 'Tag Lists';

COMMIT;

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
INSERT INTO CCE_COMP_LOG_LEVEL
( COMP_ID,COMP_DEBUG_LEVEL, COMP_VERSION_NO) VALUES (46,4,'1.0')
/

COMMIT;

PROMPT End CR-46767  release 1.2.1





