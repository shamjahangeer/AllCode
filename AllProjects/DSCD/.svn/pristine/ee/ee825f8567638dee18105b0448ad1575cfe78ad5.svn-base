CREATE OR REPLACE PACKAGE Scd_Opx_Summary AS
  /************************************************************************
  * Package:     SCD_Opx_Summary
  * Description: Store Opx related procedure or functions    
  *-----------------------------------------------------------------------
  * Revision Log: 
  * 09-02-03  Alex   Orginal version
  ************************************************************************/

  PROCEDURE p_Gen_Weekly_Smry;
  PROCEDURE p_Backout(io_result IN OUT NUMBER);

END Scd_Opx_Summary;
/
CREATE OR REPLACE PACKAGE BODY Scd_Opx_Summary AS

  gio_status  VARCHAR2(20);
  gio_sqlcode VARCHAR2(20);
  gio_sqlerrm VARCHAR2(260);

  g_error_section VARCHAR2(50) := NULL;
  k_commit_cnt    NUMBER(5) := 10000;
  New_Exception EXCEPTION;

  -- rebuild weekly summary
  PROCEDURE p_Gen_Weekly_Smry IS
    CURSOR ois_cur(i_beg_dt IN DATE, i_end_dt IN DATE, i_early_parm NUMBER, i_late_parm NUMBER) IS
      SELECT /*+ NO_INDEX(ois) */
       TYCO_MONTH_OF_YEAR_ID,
       TYCO_QUARTER_ID,
       TYCO_YEAR_ID,
       TYCO_WEEK_OF_YEAR_ID,
       ACTUAL_SHIP_BUILDING_NBR,
       SUM(CASE
             WHEN (SCHEDULE_TO_SHIP_VARIANCE < i_early_parm) OR
                  (SCHEDULE_TO_SHIP_VARIANCE BETWEEN i_early_parm AND - 1 AND
                  CUSTOMER_TYPE_CODE = 'J') THEN
              1
             ELSE
              0
           END) sch_early,
       SUM(CASE
             WHEN (SCHEDULE_TO_SHIP_VARIANCE BETWEEN i_early_parm AND 0 AND
                  NVL(CUSTOMER_TYPE_CODE, 'X') != 'J') OR
                  (SCHEDULE_TO_SHIP_VARIANCE = 0 AND CUSTOMER_TYPE_CODE = 'J') THEN
              1
             ELSE
              0
           END) sch_ontime,
       SUM(CASE
             WHEN SCHEDULE_TO_SHIP_VARIANCE > i_late_parm THEN
              1
             ELSE
              0
           END) sch_late,
       SUM(CASE
             WHEN REQUEST_TO_SHIP_VARIANCE < i_early_parm THEN
              1
             ELSE
              0
           END) req_early,
       SUM(CASE
             WHEN REQUEST_TO_SHIP_VARIANCE BETWEEN i_early_parm AND 0 THEN
              1
             ELSE
              0
           END) req_ontime,
       SUM(CASE
             WHEN REQUEST_TO_SHIP_VARIANCE > i_late_parm THEN
              1
             ELSE
              0
           END) req_late,
       SUM(CASE
             WHEN (RELEASE_TO_SHIP_VARIANCE BETWEEN i_early_parm AND 0 AND
                  NVL(CUSTOMER_TYPE_CODE, 'X') != 'J') OR
                  (RELEASE_TO_SHIP_VARIANCE = 0 AND CUSTOMER_TYPE_CODE = 'J') THEN
              1
             ELSE
              0
           END) rel_ontime,
       SUM(CASE
             WHEN RELEASE_TO_SHIP_VARIANCE > 0 THEN
              1
             ELSE
              0
           END) rel_late,
       COUNT(*) total_recs,
       PRODUCT_BUSNS_LINE_ID,
       PROFIT_CENTER_ABBR_NM,
       MFG_BUILDING_NBR,
       cod.ORGANIZATION_KEY_ID,
       cod.ORGANIZATION_ID,
       cod.REGION_ORGANIZATION_ID,
       INDUSTRY_BUSINESS_CODE
        FROM ORDER_ITEM_SHIPMENT ois,
             DATE_DMN            dd,
             ORGANIZATIONS_DMN   od,
             ORGANIZATIONS_DMN   cod
       WHERE AMP_SHIPPED_DATE BETWEEN i_beg_dt AND i_end_dt
         AND AMP_SHIPPED_DATE = CALENDAR_DT
         AND od.ORGANIZATION_KEY_ID = ois.ORGANIZATION_KEY_ID
         AND AMP_SHIPPED_DATE BETWEEN od.
       EFFECTIVE_FROM_DT
         AND od.EFFECTIVE_TO_DT
         AND od.COMPANY_ORGANIZATION_ID = cod.ORGANIZATION_ID
         AND od. EFFECTIVE_FROM_DT BETWEEN cod.
       EFFECTIVE_FROM_DT
         AND cod.EFFECTIVE_TO_DT
       GROUP BY TYCO_YEAR_ID,
                TYCO_WEEK_OF_YEAR_ID,
                TYCO_MONTH_OF_YEAR_ID,
                TYCO_QUARTER_ID,
                cod.ORGANIZATION_KEY_ID,
                cod.ORGANIZATION_ID,
                cod.REGION_ORGANIZATION_ID,
                ACTUAL_SHIP_BUILDING_NBR,
                PROFIT_CENTER_ABBR_NM,
                PRODUCT_BUSNS_LINE_ID,
                MFG_BUILDING_NBR,
                INDUSTRY_BUSINESS_CODE;
    ois_rec  ois_cur%ROWTYPE;
    dps_rec  SCD_DELIVERY_PERFORMANCE_SMRY%ROWTYPE;
    l_beg_dt DATE;
    l_end_dt DATE;
    Not_Saturday EXCEPTION;
  
  BEGIN
    -- get begin date
    SELECT MIN(AMP_SHIPPED_DATE) INTO l_beg_dt FROM ORDER_ITEM_SHIPMENT;
    -- this date is the first day of 2nd Qtr of Fiscal 2003 which is the oldest complete 
    -- Qtr we could build OPX Weekly SMRY history based from SCD detail table 
    --   l_beg_dt := TO_DATE('2002-12-22','YYYY-MM-DD');
  
    -- get end date
    SELECT MAX(AMP_SHIPPED_DATE) INTO l_end_dt FROM ORDER_ITEM_SHIPMENT;
  
    -- get Days Early and Late parameter
    Scdcommonbatch.GetDSCDDaysParam;
  
    g_error_section := 'Process OIS Cursor';
    OPEN ois_cur(l_beg_dt,
                 l_end_dt,
                 Scdcommonbatch.gDfltDaysEarly,
                 Scdcommonbatch.gDfltDaysLate);
    LOOP
      FETCH ois_cur
        INTO ois_rec;
      EXIT WHEN ois_cur%NOTFOUND;
    
      -- insert record into table
      g_error_section := 'Insert record to DSP_SMRY table';
      INSERT INTO SCD_DELIVERY_PERFORMANCE_SMRY
        (FISCAL_YEAR_ID,
         FISCAL_MONTH_ID,
         FISCAL_QUARTER_ID,
         FISCAL_WEEK_ID,
         ORGANIZATION_KEY_ID,
         ORGANIZATION_ID,
         ACTUAL_SHIP_BUILDING_NBR,
         PROFIT_CENTER_ABBR_NM,
         PRODUCT_BUSNS_LINE_ID,
         TOTAL_SHIPMENT_QTY,
         ONTIME_SHIP_TO_REQUEST_QTY,
         ONTIME_SHIP_TO_SCHEDULE_QTY,
         EARLY_SHIP_TO_REQUEST_QTY,
         EARLY_SHIP_TO_SCHEDULE_QTY,
         LATE_SHIP_TO_REQUEST_QTY,
         LATE_SHIP_TO_SCHEDULE_QTY,
         DML_USER_ID,
         DML_TS,
         LATE_SHIP_TO_RELEASE_QTY,
         ONTIME_SHIP_TO_RELEASE_QTY,
         REGION_ORG_ID,
         MFG_BUILDING_NBR,
         INDUSTRY_BUSINESS_CODE)
      VALUES
        (ois_rec.TYCO_YEAR_ID,
         ois_rec.TYCO_MONTH_OF_YEAR_ID,
         ois_rec.TYCO_QUARTER_ID,
         ois_rec.TYCO_WEEK_OF_YEAR_ID,
         ois_rec.ORGANIZATION_KEY_ID,
         ois_rec.ORGANIZATION_ID,
         ois_rec.ACTUAL_SHIP_BUILDING_NBR,
         ois_rec.PROFIT_CENTER_ABBR_NM,
         ois_rec.PRODUCT_BUSNS_LINE_ID,
         ois_rec.total_recs,
         ois_rec.req_ontime,
         ois_rec.sch_ontime,
         ois_rec.req_early,
         ois_rec.sch_early,
         ois_rec.req_late,
         ois_rec.sch_late,
         USER,
         SYSDATE,
         ois_rec.rel_late,
         ois_rec.rel_ontime,
         ois_rec.REGION_ORGANIZATION_ID,
         ois_rec.MFG_BUILDING_NBR,
         ois_rec.INDUSTRY_BUSINESS_CODE);
    END LOOP;
  
    CLOSE ois_cur;
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || g_error_section);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20102, SQLERRM || ' in ' || g_error_section);
  END p_Gen_Weekly_Smry;

  PROCEDURE p_Backout(io_result IN OUT NUMBER) IS
  BEGIN
    NULL;
  END;

END Scd_Opx_Summary;
/
