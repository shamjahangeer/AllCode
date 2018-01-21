CREATE OR REPLACE PACKAGE SCDHOLIDAY 
AS

/*
**********************************************************************************************************
* PACKAGE:     SCDHOLIDAY                                    
* DESCRIPTION:                                                      
* PROCEDURES:  Insert_Holiday_Parm                                 
*              UPDATE_HOLIDAY_PARM
*              DELETE_HOLIDAY_PARM
*              VALIDATE_HOLIDAY_PARM
*              GetLatestOrgKeyID
* AUTHOR:      
* MODIFICATION LOG:                                                 
*                                                                   
*  Date       Programmer       Description
*  --------   ----------       ------------------------------------------------
*  07/10/2012 Kumar Emany      Modified insert_holiday_parm, update_holiday_parm, delete_holiday_parm, 
*                              validate_holiday_parm Procedure to validate database_source_ID
*                              
**********************************************************************************************************
*/

PROCEDURE Insert_Holiday_Parm
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, iAmpID        IN  VARCHAR2
, iDataSourceId IN  VARCHAR2
, oErrorNumber  OUT VARCHAR2
, oErrorDesc    OUT VARCHAR2 );

PROCEDURE UPDATE_HOLIDAY_PARM
( iReportingOrg   IN  VARCHAR2
, iBldgNbr        IN  VARCHAR2
, iLocationCde    IN  VARCHAR2
, iHolidayDt      IN  VARCHAR2
, iKeyBldgNbr     IN  VARCHAR2
, iKeyLocationCde IN  VARCHAR2
, iKeyHolidayDt   IN  VARCHAR2
, iAmpID          IN  VARCHAR2
, iDataSourceId   IN  VARCHAR2
, oErrorNumber    OUT VARCHAR2
, oErrorDesc      OUT VARCHAR2 );

PROCEDURE DELETE_HOLIDAY_PARM
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, oErrorNumber  OUT VARCHAR2
, oErrorDesc	OUT VARCHAR2 );
 
PROCEDURE VALIDATE_HOLIDAY_PARM
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, iAmpID        IN  VARCHAR2
, oValid        OUT VARCHAR2
, oErrorNumber	OUT VARCHAR2
, oErrorDesc	OUT VARCHAR2 );
		
PROCEDURE GetLatestOrgKeyID
( iGlobalID    IN  VARCHAR2
, oCoOrgKeyID  OUT VARCHAR2
, oErrorNumber OUT VARCHAR2
, oErrorDesc   OUT VARCHAR2 );

END SCDHOLIDAY;
/

-- ===========================================================================================================
CREATE OR REPLACE PACKAGE BODY SCDHOLIDAY 
AS

 already_exists_00 EXCEPTION;
 sap_source_record EXCEPTION;

PROCEDURE Verify_Plant_00
( iReportingOrg	IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, iDataSourceId IN  VARCHAR2
, oPlantMsg     OUT VARCHAR2) 
AS
 
 l_cnt NUMBER(3):=0;
  
BEGIN

   oPlantMsg := NULL;
   IF iLocationCde = '00' THEN
      SELECT COUNT(*)
      INTO   l_cnt
      FROM   scorecard_holiday
      WHERE  building_nbr          = iBldgNbr 
      AND    location_code        <> '00'
      AND    company_org_key_id    = TO_NUMBER(iReportingOrg)
      AND    co_holiday_date       = TO_DATE(iHolidayDt,'YYYY-MM-DD')
      AND    UPPER(data_source_id) = UPPER(iDataSourceId)                   -- Added 07/10/2012 Kumar
      ;
      IF l_cnt > 0 THEN
         oPlantMsg := 'Plant/Loc';
      END IF;
   ELSE
      SELECT COUNT(*)
      INTO   l_cnt
      FROM   scorecard_holiday
      WHERE  building_nbr          = iBldgNbr 
      AND    location_code         = '00'
      AND    company_org_key_id    = TO_NUMBER(iReportingOrg)
      AND    co_holiday_date       = TO_DATE(iHolidayDt,'YYYY-MM-DD')
      AND    UPPER(data_source_id) = UPPER(iDataSourceId)                   -- Added 07/10/2012 Kumar
      ;
      IF l_cnt > 0 THEN
         oPlantMsg := 'whole Plant/00';
      END IF;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || 'in (scdHoliday.Verify_Plant_00');

END Verify_Plant_00;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE Insert_Holiday_Parm
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, iAmpID        IN  VARCHAR2
, iDataSourceId IN  VARCHAR2
, oErrorNumber  OUT VARCHAR2
, oErrorDesc    OUT VARCHAR2 )
AS

 ln_ExistingCount NUMBER(2) := 0;
 l_plant_msg      VARCHAR2(20);
 already_exists   EXCEPTION;
  
BEGIN

   oErrorNumber   := '0';
   oErrorDesc     := '';

   SELECT COUNT(*) 
   INTO   ln_ExistingCount 
   FROM   SCD.scorecard_holiday
   WHERE  building_nbr	        = iBldgNbr 
   AND    location_code	        = iLocationCde 
   AND    company_org_key_id    = TO_NUMBER(iReportingOrg) 
   AND    co_holiday_date       = TO_DATE(iHolidayDt,'YYYY-MM-DD')
   AND    UPPER(data_source_id) = UPPER(iDataSourceId)              -- 07/10/2012 Kumar
   ;
   
   IF ln_ExistingCount = 0 THEN
   
      -- check if plant/loc or plant/00 level param exist 
      -- Verify_Plant_00(iReportingOrg, iBldgNbr, iLocationCde, iHolidayDt, l_plant_msg);
      
      Verify_Plant_00
         ( iReportingOrg => iReportingOrg
         , iBldgNbr      => iBldgNbr
         , iLocationCde  => iLocationCde
         , iHolidayDt    => iHolidayDt
         , iDataSourceId => iDataSourceId
         , oPlantMsg     => l_plant_msg );

      IF l_plant_msg IS NOT NULL THEN
         RAISE ALREADY_EXISTS_00;
      END IF;

      INSERT INTO SCD.SCORECARD_HOLIDAY
             ( BUILDING_NBR
             , LOCATION_CODE
             , CO_HOLIDAY_DATE
             , DML_ORACLE_ID
             , DML_TMSTMP
             , COMPANY_ORG_KEY_ID
             , DATA_SOURCE_ID )
      VALUES ( iBldgNbr
             , iLocationCde
             , TO_DATE(iHolidayDt, 'YYYY-MM-DD')
             , UPPER(iAmpID)
             , SYSDATE
             , iReportingOrg
             , UPPER(iDataSourceId) );
         
   ELSE
      RAISE ALREADY_EXISTS;
   END IF;
   COMMIT;

EXCEPTION
   WHEN ALREADY_EXISTS THEN
      oErrorNumber := '-12';
      oErrorDesc   := 'Add Error: A holiday parameter already exists for that building, location and date.  (scdHoliday.Insert_Holiday_Parm)';
   WHEN ALREADY_EXISTS_00 THEN
      oErrorNumber := '-13';
      oErrorDesc   := 'Add Error: A holiday '||l_plant_msg||' level parameter already exists for that building, location and date. (scdHoliday.Insert_Holiday_Parm)';
   WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdHoliday.Insert_Holiday_Parm)';
      
END Insert_Holiday_Parm;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE Update_Holiday_Parm
( iReportingOrg   IN  VARCHAR2
, iBldgNbr        IN  VARCHAR2
, iLocationCde    IN  VARCHAR2
, iHolidayDt      IN  VARCHAR2
, iKeyBldgNbr     IN  VARCHAR2
, iKeyLocationCde IN  VARCHAR2
, iKeyHolidayDt   IN  VARCHAR2
, iAmpID          IN  VARCHAR2
, iDataSourceId   IN  VARCHAR2
, oErrorNumber    OUT VARCHAR2
, oErrorDesc      OUT VARCHAR2 )
AS
 
 l_plant_msg    VARCHAR2(20);

BEGIN

   oErrorNumber := '0';
   oErrorDesc   := '';

   -- Check whether the record source is SAP Added 07/10/2012 Kumar
   IF UPPER(iDataSourceId) = 'SAP' THEN
      RAISE SAP_SOURCE_RECORD;
   END IF;

   -- check if plant/loc or plant/00 level param exist 
   -- Verify_Plant_00(iReportingOrg, iBldgNbr, iLocationCde, iHolidayDt, l_plant_msg);

      Verify_Plant_00
         ( iReportingOrg => iReportingOrg
         , iBldgNbr      => iBldgNbr
         , iLocationCde  => iLocationCde
         , iHolidayDt    => iHolidayDt
         , iDataSourceId => iDataSourceId
         , oPlantMsg     => l_plant_msg );

   IF l_plant_msg IS NOT NULL THEN
      RAISE ALREADY_EXISTS_00;
   END IF;
   
   UPDATE SCD.scorecard_holiday 
   SET    BUILDING_NBR	     = iBldgNbr
        , LOCATION_CODE	     = iLocationCde
        , CO_HOLIDAY_DATE    = TO_DATE(iHolidayDt, 'YYYY-MM-DD')
        , COMPANY_ORG_KEY_ID = iReportingOrg
        , DML_ORACLE_ID	     = UPPER(iAmpID)
        , DML_TMSTMP         = SYSDATE
        , DATA_SOURCE_ID     = iDataSourceId
   WHERE  building_nbr          = iKeyBldgNbr 
   AND    location_code	        = iKeyLocationCde 
   AND    company_org_key_id    = TO_NUMBER(iReportingOrg) 
   AND    co_holiday_date       = TO_DATE(iKeyHolidayDt,'YYYY-MM-DD')
   AND    UPPER(data_source_id) = UPPER(iDataSourceId)              -- 07/10/2012 Kumar
   ;

EXCEPTION
   WHEN  SAP_SOURCE_RECORD THEN
      oErrorNumber := '-15';
      oErrorDesc   := 'Update Error: Data Source is SAP, Cannot be updated.  (scdHoliday.Update_Holiday_Parm)';
   WHEN ALREADY_EXISTS_00 THEN
      oErrorNumber := '-14';
      oErrorDesc   := 'Update Error: A holiday '||l_plant_msg||' level parameter already exists for that building, location and date. (scdHoliday.Update_Holiday_Parm)';
   WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      IF oErrorNumber = '-1' THEN
         oErrorDesc := 'Update Error: A Holiday Must Contain a Unique Combination of Building, Location and Date. (scdHoliday.Update_Holiday_Parm)';
      ELSE
         oErrorDesc := SQLERRM || ' (scdHoliday.Update_Holiday_Parm)';
      END IF;
      
END Update_Holiday_Parm;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE Delete_Holiday_Parm
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, oErrorNumber  OUT VARCHAR2
, oErrorDesc	OUT VARCHAR2 )
AS

 l_sap_rec_cnt NUMBER := NULL;
 
BEGIN

   oErrorNumber := '0';
   oErrorDesc   := '';
   
   -- Check whether the record source is SAP Added 07/10/2012 Kumar
   SELECT COUNT(*)
   INTO   l_sap_rec_cnt
   FROM   SCD.scorecard_holiday
   WHERE  building_nbr	        = iBldgNbr 
   AND    location_code	        = iLocationCde 
   AND    co_holiday_date       = TO_DATE(iHolidayDt,'YYYY-MM-DD')
   AND    company_org_key_id    = TO_NUMBER(iReportingOrg)
   AND    UPPER(data_source_id) = 'SAP';                              -- 07/10/2012 Kumar
   
   IF l_sap_rec_cnt <> 0 THEN
      RAISE SAP_SOURCE_RECORD;
   END IF;
   
   DELETE FROM SCD.scorecard_holiday
   WHERE  building_nbr	         = iBldgNbr 
   AND    location_code	         = iLocationCde 
   AND    co_holiday_date        = TO_DATE(iHolidayDt,'YYYY-MM-DD')
   AND    company_org_key_id     = TO_NUMBER(iReportingOrg)
   AND    UPPER(data_source_id) <> 'SAP';

EXCEPTION
   WHEN  SAP_SOURCE_RECORD THEN
      oErrorNumber := '-15';
      oErrorDesc   := 'Delete Error: Data Source is SAP, Cannot be deleted.  (scdHoliday.Delete_Holiday_Parm)';
   WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdHoliday.Delete_Holiday_Parm)';
      
END Delete_Holiday_Parm;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE Validate_Holiday_Parm
( iReportingOrg IN  VARCHAR2
, iBldgNbr      IN  VARCHAR2
, iLocationCde  IN  VARCHAR2
, iHolidayDt    IN  VARCHAR2
, iAmpID        IN  VARCHAR2
, oValid        OUT VARCHAR2
, oErrorNumber	OUT VARCHAR2
, oErrorDesc	OUT VARCHAR2 )
AS

 lSatShipInd SCORECARD_WEEKEND_SHIP.SAT_SHIP_IND%TYPE;
 lSunShipInd SCORECARD_WEEKEND_SHIP.SUN_SHIP_IND%TYPE;
 lDayOfWeek  VARCHAR2(1);

 l_sap_rec_cnt NUMBER := NULL;
 
BEGIN

   oErrorNumber := '0';
   oErrorDesc   := '';
   oValid       := 'T';
   
   -- Check whether the record source is SAP Added 07/10/2012 Kumar
   SELECT COUNT(*)
   INTO   l_sap_rec_cnt
   FROM   SCD.scorecard_holiday
   WHERE  building_nbr	        = iBldgNbr 
   AND    location_code	        = iLocationCde 
   AND    co_holiday_date       = TO_DATE(iHolidayDt,'YYYY-MM-DD')
   AND    company_org_key_id    = TO_NUMBER(iReportingOrg)
   AND    UPPER(data_source_id) = 'SAP';
      
   IF l_sap_rec_cnt <> 0 THEN
      RAISE SAP_SOURCE_RECORD;
   END IF;
   
   SELECT TO_CHAR(TO_DATE(iHolidayDt,'YYYY-MM-DD'), 'D') 
   INTO   lDayOfWeek
   FROM   DUAL;
   
   IF lDayOfWeek <> '7' -- not Sat
      AND lDayOfWeek <> '1' -- not Sun
   THEN
      -- not weekend
      GOTO end_proc;
   END IF;
   
   SELECT NVL(SAT_SHIP_IND, 'N'), NVL(SUN_SHIP_IND, 'N')
   INTO   lSatShipInd, lSunShipInd
   FROM   scorecard_weekend_ship
   WHERE  building_nbr  = iBldgNbr
   AND    location_code = iLocationCde;
   
   IF lSatShipInd = 'N' AND lDayOfWeek = '7' THEN
      oErrorNumber := '-1';
      oErrorDesc   := 'Invalid entry. Plant/Building AND Location entered does not ship on Saturday';
      oValid       := 'F';
      GOTO end_proc;
   END IF;
   
   IF lSunShipInd = 'N' AND lDayOfWeek = '1' THEN
      oErrorNumber := '-1';
      oErrorDesc   := 'Invalid entry. Plant/Building AND Location entered does not ship on Sunday';
      oValid := 'F';
      GOTO end_proc;
   END IF;
   
   <<end_proc>>
   NULL;
   
EXCEPTION
   WHEN  SAP_SOURCE_RECORD THEN
      oErrorNumber := '-15';
      oErrorDesc   := 'Invalid entry. Data Source is SAP.  (scdHoliday.Validate_Holiday_Parm)';
      oValid := 'F';
   WHEN NO_DATA_FOUND THEN
      IF lDayOfWeek = '7' -- is Sat
         OR lDayOfWeek = '1' -- is Sun
      THEN
         oErrorNumber := '-1';
         oErrorDesc := 'Invalid entry. Plant/Building AND Location entered does not ship on Weekend';
         oValid := 'F';
      END IF;

   WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdHoliday.Validate_Holiday_Parm)';
      
END Validate_Holiday_Parm;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE GetLatestOrgKeyID
( iGlobalID    IN  VARCHAR2
, oCoOrgKeyID  OUT VARCHAR2
, oErrorNumber OUT VARCHAR2
, oErrorDesc   OUT VARCHAR2 )
AS		

BEGIN

   oErrorNumber := '0';
   oErrorDesc := '';		
   
   -- get company org key id if possible based from last preference log
   SELECT NVL(TO_CHAR(od2.organization_key_id), '')
   INTO   oCoOrgKeyID
   FROM   organizations_dmn od
        , organizations_dmn od2
        , scorecard_user_preferences sup  
   WHERE  od.organization_id          = sup.organization_id
   AND    od.record_status_cde        = 'C'
   AND    od.company_organization_id  = od2.organization_id
   AND    od2.record_status_cde       = 'C'
   AND    sup.scd_user_preferences_id = (SELECT MAX(scd_user_preferences_id) 
                                         FROM   scorecard_user_preferences
                                         WHERE	asoc_global_id = TO_NUMBER(iGlobalID));

   -- if company org key id not available then try the most recent company if any
   IF oCoOrgKeyID = '' THEN
      SELECT NVL(TO_CHAR(org_kid),'')
      INTO   oCoOrgKeyID
      FROM   (SELECT sup.scd_user_preferences_id, so.organization_key_id org_kid
              FROM   scorecard_user_preferences sup
                   , scorecard_organizations    so
                   , scorecard_org_types        sot
              WHERE  asoc_global_id = TO_NUMBER(iGlobalID)
              AND    organization_type_desc LIKE 'COMPANY%'
              AND    so.organization_type_id   = sot.organization_type_id
              AND    sup.organization_type_id  = so.organization_type_id
              AND    sup.organization_id       = so.organization_id
              ORDER BY 1 DESC)
      WHERE ROWNUM <= 1;
   END IF;		
	
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      oCoOrgKeyID	:= '';
   WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdHoliday.GetLatestOrgKeyID)';
      
END GETLATESTORGKEYID;	
	
END SCDHOLIDAY;
/

-- ===========================================================================================================
