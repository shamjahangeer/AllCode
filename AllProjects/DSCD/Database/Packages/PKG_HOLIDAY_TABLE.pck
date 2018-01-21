CREATE OR REPLACE PACKAGE PKG_HOLIDAY_TABLE 
AS

/*
**********************************************************************************************************
* PACKAGE:     pkg_holiday_table                                           
* DESCRIPTION: Contains procedures for maintaining the SCORECARD_HOLIDAY_TABLE.                                    
*                                                                          
* PROCEDURES:  p_monthly_purge                                                            
*              p_holiday_load
*                                                                          
* AUTHOR:      John Fassano  , Computer Aid Inc,      July, 1996           
*  Revisions Log:                                                          
* 1.0                                 
*       
* MODIFICATION LOG:                                                 
*                                                                   
*  Rev Date       Programmer       Description
*  --- ---------- ----------       -----------------------------------------------------------------------
*  1.3 10/17/2012 Kumar Emany      SAP is sending a complete file and many of them are being rejected 
*                                     which is fillng up SCD.SCORECARD_PROCESS_LOG, retain only 2 days
*                                     worth of error log
*  1.2 07/10/2012 Kumar Emany      1. a) Modified p_monthly_purge to delete records WHERE database_source_id = 'SCD'
*                                     b) Modified p_holiday_load to add database_source_id to the INSERT
*                                  2. Added PROCEDURE P_SAP_NON_WORKING_DAYS_LOAD to populated SAP Holidays
*                                     from GBL_CURRENT.factory_non_working_days
*  1.1 01/18/2006 A. Orbeta        Remove PART_NBR column.                		
*  1.0 04/06/2001 F. Hafiz         DSCD RE-WRITE
**********************************************************************************************************
*/

PROCEDURE P_MONTHLY_PURGE 
( vic_job_id       IN LOAD_MSG.DML_ORACLE_ID%TYPE
, vin_commit_count IN NUMBER
, vion_result      IN OUT NUMBER );

PROCEDURE P_HOLIDAY_LOAD 
( vic_job_id  IN CHAR
, vion_result IN OUT NUMBER );

PROCEDURE P_SAP_NON_WORKING_DAYS_LOAD
( vion_result      IN OUT NUMBER );

END PKG_HOLIDAY_TABLE;
/

-- ===========================================================================================================
CREATE OR REPLACE PACKAGE BODY PKG_HOLIDAY_TABLE 
AS

 scd_holiday          SCORECARD_HOLIDAY%ROWTYPE;
 vgc_job_id           LOAD_MSG.DML_ORACLE_ID%TYPE;
 ue_critical_db_error EXCEPTION;
 vgn_sql_result       NUMBER;
 vgn_commit_count     NUMBER;

/*
**********************************************************************************************************
* PROCEDURE:   p_monthly_purge                                             
* DESCRIPTION: Deletes all SCORECARD_HOLIDAY rows older than the data retention limit.  The retention date         
*               is calculated using the SCD02MTHS parameter in the DELIVERY_PARAMETER table.    
**********************************************************************************************************
*/

PROCEDURE p_monthly_purge
( vic_job_id       IN LOAD_MSG.DML_ORACLE_ID%TYPE
, vin_commit_count IN NUMBER
, vion_result      IN OUT NUMBER)
AS

 CURSOR scd_holiday_row (purge_date DATE) IS
  SELECT ROWID
  FROM   scorecard_holiday
  WHERE  (co_holiday_date <= purge_date)
  AND    (ROWNUM          <= vin_commit_count)
  AND    data_source_id    = 'SCD';             -- Added 07/10/2012 Kumar, Do not delete records marked as SAP 

 action             CHAR;
 commit_count       NUMBER := 0;
 num_rows_processed NUMBER := 0;
 retain_months      NUMBER := 0;
 discard_count      NUMBER;
 m_purge_date       DATE;
 hol_rowid          ROWID;
 sql_result         NUMBER;

BEGIN
   
   vgc_job_id := vic_job_id;
   
   SELECT parameter_field
   INTO   retain_months
   FROM   delivery_parameter
   WHERE  parameter_id = 'SCD02MTHS';
   
   /* Calculate Purge Date */
   m_purge_date := LAST_DAY(ADD_MONTHS(SYSDATE, retain_months * -1));
   
   OPEN scd_holiday_row (m_purge_date);
   LOOP
      FETCH scd_holiday_row
      INTO hol_rowid;
      
      EXIT WHEN (scd_holiday_row%NOTFOUND);
      
      DELETE FROM scorecard_holiday WHERE ROWID = hol_rowid;
      
      num_rows_processed := num_rows_processed + 1;
      
      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
         COMMIT;
         CLOSE scd_holiday_row;
         OPEN scd_holiday_row (m_purge_date);
      END IF;
   END LOOP;
   CLOSE scd_holiday_row;
   
   /* Do one last commit */
   COMMIT;
   
   /* Enter results into load_msg file */
   INSERT INTO LOAD_MSG
          ( LOAD_MSG_SEQ
          , DML_ORACLE_ID
          , DML_TMSTMP
          , ORGANIZATION_KEY_ID -- ADDED SCORECARD_ORG_CODE
          , AMP_ORDER_NBR
          , ORDER_ITEM_NBR
          , SHIPMENT_ID
          , DATABASE_LOAD_DATE
          , AMP_SHIPPED_DATE
          , AMP_SCHEDULE_DATE
          , PART_KEY_ID
          , STATUS
          , NBR_DETAILS_INSERTED
          , NBR_DETAILS_MODIFIED
          , NBR_DETAILS_DELETED
          , NBR_SMRYS_INSERTED
          , NBR_SMRYS_MODIFIED
          , NBR_SMRYS_DELETED )
   VALUES ( LOAD_MSG_SEQ.NextVal
          , vgc_job_id
          , SYSDATE
          , NULL
          , NULL
          , NULL
          , NULL
          , m_purge_date
          , NULL
          , NULL
          , NULL
          , '****'
          , NULL
          , NULL
          , num_rows_processed
          , NULL
          , NULL
          , NULL );

EXCEPTION
   WHEN UE_CRITICAL_DB_ERROR THEN
      vion_result := vgn_sql_result;
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  '|| sqlerrm(vion_result));
      ROLLBACK;
      COMMIT;   /* Commit the error msg */

   WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  '|| sqlerrm(vion_result));
      COMMIT;   /* Commit the error msg */

END P_MONTHLY_PURGE;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE P_HOLIDAY_LOAD 
( vic_job_id  IN CHAR
, vion_result IN OUT NUMBER) 
AS

 /* LOCAL VARIABLES */
 hldy                    SCORECARD_HOLIDAY%ROWTYPE;
 tmp_hldy                TEMP_SCORECARD_HOLIDAY%ROWTYPE;
 wkend                   SCORECARD_WEEKEND_SHIP%ROWTYPE;
 vln_organization_key_id ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE;
 
 vln_temp_rows_bypassed  NUMBER:= 0;
 vln_nbr_rows_inserted   NUMBER:= 0;
 vln_temp_rows_processed NUMBER:= 0;
 
 vln_log_line            NUMBER:= 0;
 vln_sql_error           CHAR (70);
 
 current_date            DATE;
 
 weekend_cnt             NUMBER := 0;
 
 work_day                BOOLEAN := TRUE;

 CURSOR CUR_TEMP_HOLIDAY  IS
  SELECT building_nbr, location_code, co_holiday_date
  FROM   temp_scorecard_holiday
  ORDER BY building_nbr, location_code;

BEGIN
   
   /** tanveer 7/8/98 - made change to only process US data. All other countries will be keyed in through the GUI **/
   
   /* TO GET KEY_ID FROM ORG_DMN TABLE ALONG WITH AN ORG_ID */
   SELECT organization_key_id
   INTO   vln_organization_key_id
   FROM   organizations_dmn
   WHERE  organization_id = '0048'
   AND    record_status_cde = 'C';
   
   /* DELETE SCORECARD HOLIDAY ROWS */
   DELETE FROM scorecard_holiday
   WHERE company_org_key_id = vln_organization_key_id
   AND    data_source_id     = 'SCD';             -- Added 07/10/2012 Kumar, Do not delete records marked as SAP 
   
   OPEN cur_temp_holiday;
   
   /* PROCESS TEMP HOLIDAY TABLE LOOP */
   LOOP
      FETCH cur_temp_holiday
      INTO  tmp_hldy.building_nbr, tmp_hldy.location_code, tmp_hldy.co_holiday_date;      
      EXIT WHEN (cur_temp_holiday%NOTFOUND);
      
      vln_temp_rows_processed  :=  vln_temp_rows_processed + 1;
      
      /* BYPASS TEMP ROWS FOR WEEKENDS THAT ARE NOT SPECIFIED AS WORK DAYS BASED ON THE SCORECARD_WEEKEND_SHIP TABLE */
      BEGIN
         weekend_cnt := 0;
         work_day    := TRUE;
         IF TO_CHAR(TMP_HLDY.co_holiday_date, 'D') = '7' THEN
            SELECT COUNT(*)
            INTO   weekend_cnt
            FROM   scorecard_weekend_ship
            WHERE  (building_nbr = TMP_HLDY.building_nbr )
            AND    ((location_code = TMP_HLDY.location_code) OR (location_code = '*'))
            AND    (sat_ship_ind = 'Y');
            
            IF weekend_cnt = 0  THEN
               work_day               := FALSE;
               vln_temp_rows_bypassed := vln_temp_rows_bypassed + 1;
               DBMS_OUTPUT.PUT_LINE('BYPASSED:  ' || TMP_HLDY.BUILDING_NBR || TMP_HLDY.LOCATION_CODE || TMP_HLDY.CO_HOLIDAY_DATE);
            END IF;
         END IF;
         
         IF TO_CHAR(TMP_HLDY.co_holiday_date, 'D') = '1' THEN
            SELECT COUNT(*)
            INTO   weekend_cnt
            FROM   scorecard_weekend_ship
            WHERE  (building_nbr = TMP_HLDY.building_nbr)
            AND    ((location_code = TMP_HLDY.location_code) OR  (location_code = '*'))
            AND    (sun_ship_ind = 'Y');
            
            IF weekend_cnt = 0  THEN
               work_day := FALSE;
               vln_temp_rows_bypassed := vln_temp_rows_bypassed + 1;
               DBMS_OUTPUT.PUT_LINE('BYPASSED:  ' || TMP_HLDY.BUILDING_NBR || TMP_HLDY.LOCATION_CODE || TMP_HLDY.CO_HOLIDAY_DATE);
            END IF;
         END IF;
      END;
      
      /* INSERT TEMP ROWS INTO SCORECARD_HOLIDAY IF VALID */
      BEGIN
         IF work_day THEN
            INSERT INTO SCD.SCORECARD_HOLIDAY
                   ( COMPANY_ORG_KEY_ID
                   , BUILDING_NBR
                   , LOCATION_CODE
                   , CO_HOLIDAY_DATE
                   , DML_ORACLE_ID
                   , DML_TMSTMP
                   , DATA_SOURCE_ID )
            VALUES ( vln_organization_key_id -- ADDED
                   , TMP_HLDY.building_nbr
                   , TMP_HLDY.location_code
                   , TMP_HLDY.co_holiday_date
                   , vic_job_id
                   , SYSDATE
                   , 'SCD' );
            VLN_NBR_ROWS_INSERTED  :=  VLN_NBR_ROWS_INSERTED + 1;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            vion_result :=  SQLCODE;
            DBMS_OUTPUT.PUT_LINE('SQL_ERROR:  ' || SQLERRM(VION_RESULT));
      END;
   
   END LOOP;
   CLOSE cur_temp_holiday;
   COMMIT;
   
   /* ENTER RESULTS INTO PROCESS LOG  */
   
   vln_log_line := vln_log_line + 1;
   
   INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
   VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
      'P_HOLIDAY_LOAD',
      VIC_JOB_ID,
      SYSDATE,
      VLN_LOG_LINE,
      ('**** '  ||  VLN_TEMP_ROWS_PROCESSED   ||  ' TEMPS PROCESSED'));

   vln_log_line := vln_log_line + 1;

   INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
      SCD_PROCESS_NAME,
      DML_ORACLE_ID,
      DML_TMSTMP,
      SCD_PROCESS_LINE,
      SCD_PROCESS_TEXT)
   VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
      'P_HOLIDAY_LOAD',
      VIC_JOB_ID,
      SYSDATE,
      VLN_LOG_LINE,
      ('**** '  ||  VLN_TEMP_ROWS_BYPASSED   ||  ' TEMPS BYPASSED'));

   vln_log_line := vln_log_line + 1;

   INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
      SCD_PROCESS_NAME,
      DML_ORACLE_ID,
      DML_TMSTMP,
      SCD_PROCESS_LINE,
      SCD_PROCESS_TEXT)
   VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
      'P_HOLIDAY_LOAD',
      VIC_JOB_ID,
      SYSDATE,
      VLN_LOG_LINE,
      ('**** '  ||  VLN_NBR_ROWS_INSERTED   ||  ' HOLIDAYS INSERTED'));

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      vion_result :=  SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_HOLIDAY_LOAD');
      DBMS_OUTPUT.PUT_LINE('SQL_ERROR:  ' || SQLERRM(VION_RESULT));
      vln_sql_error := SQLERRM(vion_result);
      vln_log_line := vln_log_line + 1;
      
      INSERT INTO SCORECARD_PROCESS_LOG
         (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
         (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_HOLIDAY_LOAD',
         VIC_JOB_ID,
         SYSDATE,
         VLN_LOG_LINE,
         ('DBER  ' ||  SUBSTR (VLN_SQL_ERROR, 1, 70)));
         
      VLN_LOG_LINE := VLN_LOG_LINE + 1;
      
      INSERT INTO SCORECARD_PROCESS_LOG
         (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
         (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_HOLIDAY_LOAD',
         VIC_JOB_ID,
         SYSDATE,
         VLN_LOG_LINE,
         ('DBER  ' ||  'TEMP ROWS:  '  ||  VLN_TEMP_ROWS_PROCESSED));
      COMMIT;

END P_HOLIDAY_LOAD;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE P_SAP_NON_WORKING_DAYS_LOAD
( vion_result      IN OUT NUMBER )
AS

 -- Load org_id 0048 as 1056
 CURSOR fnw_cur IS
  SELECT DECODE (company_cde, '0048', '1056', company_cde) company_cde
       , plant_id, plant_location_id, non_working_dt
  FROM   GBL_CURRENT.factory_non_working_days
  -- WHERE  TRUNC(non_working_dt) >= TRUNC(SYSDATE)
  ;

 v_org_key_id        ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE := 0;
 v_invalid_comp_cnt  NUMBER                                     := 0;
 
 v_weekend_cnt       NUMBER                                     := 0;
 v_work_day          BOOLEAN                                    := TRUE;
 v_invaid_date_cnt   NUMBER                                     := 0;
 
 v_ins_upd_cnt       NUMBER                                     := 0; 
 
 v_recs_processed    NUMBER                                     := 0; 
 v_log_cnt           NUMBER                                     := 0; 

 v_section           VARCHAR2(500)                              := NULL;
 v_msg               VARCHAR2(500)                              := NULL;
 
 INVALID_COMP_CDE    EXCEPTION;
 INVALID_PLANT_ID    EXCEPTION;
 INVALID_WORK_DT     EXCEPTION;
 
BEGIN  

   -- SAP is sending a complete file and many of them are being rejected 
   -- which is fillng up SCD.SCORECARD_PROCESS_LOG, retain only 2 days
   -- worth of error log
   
   v_section := 'Delete SCORECARD_PROCESS_LOG records that are <= SYSDATE -2';
   DELETE FROM SCD.SCORECARD_PROCESS_LOG
   WHERE  scd_process_name = 'P_SAP_NON_WORKING_DAYS_LOAD'
   AND    TRUNC(dml_tmstmp) <= TRUNC(SYSDATE) -2;
   
   -- GBL_CURRENT.factory_non_working_days gets a complete refresh, 
   -- delete all future records from scorecard_holiday table
   
   v_section := 'Delete SAP records that are >= SYSDATE';
   DELETE FROM SCD.SCORECARD_HOLIDAY
   WHERE  data_source_id = 'SAP'
   AND    TRUNC(co_holiday_date) >= TRUNC(SYSDATE);
   COMMIT;
   
   FOR fnw_rec IN fnw_cur 
   LOOP
      
      v_recs_processed := v_recs_processed + 1;
      
      v_org_key_id      := NULL;

      BEGIN

         v_section := 'Validate FACTORY_NON_WORKING_DAYS.company_cde:    company_cde/plant_id/Date - ' || FNW_REC.company_cde ||'/'|| FNW_REC.plant_id ||'/'|| FNW_REC. non_working_dt;
         IF NOT SCDCOMMONBATCH.GetOrgKeyIDV2 ( iOrgID => FNW_REC.company_cde, oOrgKeyID => v_org_key_id ) THEN
            v_invalid_comp_cnt := v_invalid_comp_cnt + 1;
            v_msg              := 'Invalid company_cde: ' || FNW_REC.company_cde;
            RAISE INVALID_COMP_CDE;
         END IF;
         
         -- BYPASS Rows for weekends that are not specified as work days based on the scorecard_weekend_ship table
         v_weekend_cnt := 0;
         v_work_day    := TRUE;
         IF TO_CHAR(FNW_REC.non_working_dt, 'D') = '7' THEN
            SELECT COUNT(*)
            INTO   v_weekend_cnt
            FROM   SCD.scorecard_weekend_ship
            WHERE  building_nbr = FNW_REC.plant_id
            AND    sat_ship_ind = 'Y';
            
            IF v_weekend_cnt = 0  THEN
               v_work_day        := FALSE;
               v_invaid_date_cnt := v_invaid_date_cnt + 1;    
               RAISE INVALID_WORK_DT;
            END IF;
         END IF;
         
         v_weekend_cnt := 0;
         v_work_day    := TRUE;
         IF TO_CHAR(FNW_REC.non_working_dt, 'D') = '1' THEN
            SELECT COUNT(*)
            INTO   v_weekend_cnt
            FROM   scorecard_weekend_ship
            WHERE  building_nbr = FNW_REC.plant_id
            AND    sun_ship_ind = 'Y';
            
            IF v_weekend_cnt = 0  THEN
               v_work_day := FALSE;
               v_invaid_date_cnt := v_invaid_date_cnt + 1;
               RAISE INVALID_WORK_DT;
            END IF;
         END IF;

         BEGIN
            IF v_work_day THEN
               -- If a record already exists in SCORECARD_HOLIDAY table for FNW_REC.company_cde, FNW_REC.plant_id, FNW_REC.non_working_dt
               -- then update DATA_SOURCE_ID as SAP
               -- else create a new record
               
               MERGE INTO SCD.SCORECARD_HOLIDAY
               USING DUAL ON ( building_nbr           = FNW_REC.plant_id              AND
                               TRUNC(co_holiday_date) = TRUNC(FNW_REC.non_working_dt) AND
                               company_org_key_id     = v_org_key_id                  AND
                               location_code          = FNW_REC.plant_location_id  )
               WHEN MATCHED THEN
                  UPDATE 
                     SET DATA_SOURCE_ID = 'SAP'
                       , DML_ORACLE_ID  = USER
                       , DML_TMSTMP     = SYSDATE
               WHEN NOT MATCHED THEN
                  INSERT ( BUILDING_NBR
                         , LOCATION_CODE
                         , CO_HOLIDAY_DATE
                         , DML_ORACLE_ID
                         , DML_TMSTMP
                         , COMPANY_ORG_KEY_ID
                         , DATA_SOURCE_ID )
                  VALUES ( FNW_REC.plant_id
                         , FNW_REC.plant_location_id
                         , FNW_REC.non_working_dt
                         , USER
                         , SYSDATE
                         , v_org_key_id
                         , 'SAP' );
               v_ins_upd_cnt := v_ins_upd_cnt + SQL%ROWCOUNT;

            END IF;
         END;
         
      EXCEPTION
         WHEN INVALID_COMP_CDE OR INVALID_PLANT_ID OR INVALID_WORK_DT THEN
            INSERT INTO SCD.SCORECARD_PROCESS_LOG
                   ( SCD_PROCESS_LOG_SEQ
                   , SCD_PROCESS_NAME
                   , DML_ORACLE_ID
                   , DML_TMSTMP
                   , SCD_PROCESS_LINE
                   , SCD_PROCESS_TEXT )
            VALUES ( SCD_PROCESS_LOG_SEQ.NEXTVAL
                   , 'P_SAP_NON_WORKING_DAYS_LOAD'
                   , USER
                   , SYSDATE
                   , 0
                   , SUBSTR(v_msg, 1, 80) );
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_section||' - '||SQLERRM);
      END;

   END LOOP;
   COMMIT;

   /* Enter Results Into Process Log  */
   
   v_log_cnt := v_log_cnt + 1;
   INSERT INTO SCD.SCORECARD_PROCESS_LOG
          ( SCD_PROCESS_LOG_SEQ
          , SCD_PROCESS_NAME
          , DML_ORACLE_ID
          , DML_TMSTMP
          , SCD_PROCESS_LINE
          , SCD_PROCESS_TEXT )
   VALUES ( SCD_PROCESS_LOG_SEQ.NEXTVAL
          , 'P_SAP_NON_WORKING_DAYS_LOAD'
          , USER
          , SYSDATE
          , v_log_cnt
          , ('**** '  ||  v_recs_processed   ||  ' Records Processed'));

   v_log_cnt := v_log_cnt + 1;
   INSERT INTO SCD.SCORECARD_PROCESS_LOG
          ( SCD_PROCESS_LOG_SEQ
          , SCD_PROCESS_NAME
          , DML_ORACLE_ID
          , DML_TMSTMP
          , SCD_PROCESS_LINE
          , SCD_PROCESS_TEXT )
   VALUES ( SCD_PROCESS_LOG_SEQ.NEXTVAL
          , 'P_SAP_NON_WORKING_DAYS_LOAD'
          , USER
          , SYSDATE
          , v_log_cnt
          , ('**** '  || (v_invalid_comp_cnt+v_invaid_date_cnt) ||  ' Records Bypassed'));

   v_log_cnt := v_log_cnt + 1;
   INSERT INTO SCD.SCORECARD_PROCESS_LOG
          ( SCD_PROCESS_LOG_SEQ
          , SCD_PROCESS_NAME
          , DML_ORACLE_ID
          , DML_TMSTMP
          , SCD_PROCESS_LINE
          , SCD_PROCESS_TEXT )
   VALUES ( SCD_PROCESS_LOG_SEQ.NEXTVAL
          , 'P_SAP_NON_WORKING_DAYS_LOAD'
          , USER
          , SYSDATE
          , v_log_cnt
          , ('**** '  || v_ins_upd_cnt ||  ' Records Inserted/Updated'));

   -- DBMS_OUTPUT.PUT_LINE( '**** '  ||  v_recs_processed   ||  ' Records Processed');
   -- DBMS_OUTPUT.PUT_LINE( '**** '  || (v_invalid_comp_cnt+v_invaid_date_cnt) ||  ' Records Bypassed');
   -- DBMS_OUTPUT.PUT_LINE( '**** '  || v_ins_upd_cnt ||  ' Records Inserted/Updated');

EXCEPTION
   WHEN OTHERS THEN
      vion_result :=  SQLCODE;
      DBMS_OUTPUT.PUT_LINE('SQL_ERROR:  ' || SQLERRM(VION_RESULT));

END P_SAP_NON_WORKING_DAYS_LOAD;

END PKG_HOLIDAY_TABLE;
/