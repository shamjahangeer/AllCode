CREATE OR REPLACE PACKAGE Pkg_Post_Daf_Process AS
  /************************************************************************
  * Package:     pkg_post_daf_process
  * Description: This package/stored pocedure is used to extract data from
  *              target tables into temporary order item shipment table of
  *        delivery scorecard application.
  *
  * Procedures:  p_extract_scd_data
  *          p_create_param_local_rec
  *              p_insert_tois_rec
  *        p_extract_billings
  *        p_extract_backlog
  *-----------------------------------------------------------------------
  * Revisions Log:
  * 1.0   02/10/2000  A. Orbeta   Original Version
  * 1.1 05/06/2000  A. Orbeta Added new fields for Elec. Gearbox
  * 1.2 09/28/2000  A. Orbeta   Removed logic that bypass record if
  *                   product_code is '9964' and part_nbr is
  *                '000000000'
  * 1.3   01/11/2001 Alex/Faisal  Changed product_busns_line_code to product
  *                   _busns_line_id AND product_busns_line_fnctn_code
  *               to product_busns_line_fnctn_id AND the logic
  *               to derive the busns_ids instead of code.
  * 1.4  02/12/2001 Faisal        Added new field PROFIT_CENTER_ABBR_NM
  * 1.5  02/16/2001 Alex/F. Hafiz Added new fields for fiscal dates using amp_sched_date
  * 1.6  04/10/2001 Alex        SCD re-write.
  * 1.7  02/08/2001 Jeff DeLong  Add cost fields
  * 1.8  05/31/2002 A.Orbeta      Assign value to remaining_qty_to_ship.
  * 1.9  07/30/2002 A.Orbeta      Populate heirarchy_ columns.
  * 1.10 11/11/2002 A.Orbeta    Populate DATA_SOURCE_DESC AND SALES_ columns.
  * 1.11 12/04/2002 A. Orbeta     Add SBMT_SOLD_TO_CUSTOMER_ID column.
  * 1.12 01/28/2003 A. Orbeta     Add INVOICE_NBR column.
  * 1.13 06/13/2003 A. Orbeta   Set credit_hold_on_date to booking date if
  *                     _on_date is null _off_date is not null.
  *      06/10/2004       Removed reference to RYC ADR-313.
  *    08/11/2004       Set backlog schedule_date to beg_of_time if
  *                 null and cust_request_date is not null.
  *    10/11/2004       Add Item Booked Dt field.
  *      12/16/2004         Alpha Part project.
  *    04/27/2005       Remove DELETE_IND in COPORATE_PARTS select.
  *    12/30/2005       Add source_id and data_src_id columns.
  *      01/17/2006         Remove PART_NBR column.
  *      06/16/2006       Set MRP_Group_Cde = '*' if value is null. Filter
  *                   enhancement - phase III.
  *      09/07/2006       Add DISTR_SHIP_WHEN_AVAIL_IND field.
  --     11/10/2008          Add fields for Consolidated Cust Ships changes.
  --     10/06/2009          Add COSB exclusion code logic for backlog.
  --     11/02/2009          Add SAP profit center.
  ************************************************************************/

  PROCEDURE p_extract_scd_data(vin_batch_id   IN BILLING_TGT.BATCH_ID%TYPE,
                               vic_scd_org    IN BILLING_TGT.SCORECARD_ORG_CODE%TYPE,
                               vic_data_src   IN VARCHAR2,
                               vin_commit_cnt IN NUMBER,
                               vion_result    IN OUT NUMBER);
END Pkg_Post_Daf_Process;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Post_Daf_Process AS
  tois          TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
  tgt           BILLING_TGT%ROWTYPE;
  vgc_job_id    TEMP_ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE;
  k_beg_of_time DATE := TO_DATE('00010101', 'YYYYMMDD');
  vgc_errmsg    VARCHAR2(500);
  vgn_errno     NUMBER;
  ue_critical_db_error EXCEPTION;

  /************************************************************************
  * Procedure  : p_create_param_local_rec
  * Description: Create the control record in delivery_parameter_local
  *        table for shipments and opens.
  ************************************************************************/
  PROCEDURE p_create_param_local_rec(vin_batch_id IN BILLING_TGT.BATCH_ID%TYPE,
                                     vic_scd_org  IN BILLING_TGT.SCORECARD_ORG_CODE%TYPE,
                                     vic_data_src IN VARCHAR2,
                                     vion_result  IN OUT NUMBER) IS

    vlc_ships DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;
    vlc_opens DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;
    vln_cnt   NUMBER;
  BEGIN
    vion_result := 0;

    -- get the original E171 control record
    IF vic_data_src = 'SCD' THEN
      SELECT DECODE(TOT_NBR_JAN_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_JAN_SHPTS) ||
             DECODE(TOT_NBR_FEB_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_FEB_SHPTS) ||
             DECODE(TOT_NBR_MAR_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_MAR_SHPTS) ||
             DECODE(TOT_NBR_APR_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_APR_SHPTS) ||
             DECODE(TOT_NBR_MAY_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_MAY_SHPTS) ||
             DECODE(TOT_NBR_JUN_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_JUN_SHPTS) ||
             DECODE(TOT_NBR_JUL_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_JUL_SHPTS) ||
             DECODE(TOT_NBR_AUG_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_AUG_SHPTS) ||
             DECODE(TOT_NBR_SEP_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_SEP_SHPTS) ||
             DECODE(TOT_NBR_OCT_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_OCT_SHPTS) ||
             DECODE(TOT_NBR_NOV_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_NOV_SHPTS) ||
             DECODE(TOT_NBR_DEC_SHPTS,
                    NULL,
                    '0000000000',
                    TOT_NBR_DEC_SHPTS),
             DECODE(GRAND_TOT_OPENS, NULL, '0000000000', GRAND_TOT_OPENS)
        INTO vlc_ships, vlc_opens
        FROM DAF00013_CTLS_V
       WHERE BATCH_ID = vin_batch_id;
      /*
          obsoleted
          ELSIF vic_data_src = 'RYC' THEN
            SELECT decode(TOT_NBR_JAN_SHPTS,null,'0000000000',TOT_NBR_JAN_SHPTS) ||
               decode(TOT_NBR_FEB_SHPTS,null,'0000000000',TOT_NBR_FEB_SHPTS) ||
               decode(TOT_NBR_MAR_SHPTS,null,'0000000000',TOT_NBR_MAR_SHPTS) ||
                 decode(TOT_NBR_APR_SHPTS,null,'0000000000',TOT_NBR_APR_SHPTS) ||
               decode(TOT_NBR_MAY_SHPTS,null,'0000000000',TOT_NBR_MAY_SHPTS) ||
               decode(TOT_NBR_JUN_SHPTS,null,'0000000000',TOT_NBR_JUN_SHPTS) ||
                 decode(TOT_NBR_JUL_SHPTS,null,'0000000000',TOT_NBR_JUL_SHPTS) ||
               decode(TOT_NBR_AUG_SHPTS,null,'0000000000',TOT_NBR_AUG_SHPTS) ||
               decode(TOT_NBR_SEP_SHPTS,null,'0000000000',TOT_NBR_SEP_SHPTS) ||
                 decode(TOT_NBR_OCT_SHPTS,null,'0000000000',TOT_NBR_OCT_SHPTS) ||
               decode(TOT_NBR_NOV_SHPTS,null,'0000000000',TOT_NBR_NOV_SHPTS) ||
               decode(TOT_NBR_DEC_SHPTS,null,'0000000000',TOT_NBR_DEC_SHPTS)
                 ,decode(GRAND_TOT_OPENS,null,'0000000000',GRAND_TOT_OPENS)
            INTO   vlc_ships, vlc_opens
            FROM   DAF00313_CTLS_V
            WHERE  BATCH_ID = vin_batch_id;
      */
    END IF;

    -- create control record for shipment
    vln_cnt := 0;
    SELECT COUNT(*)
      INTO vln_cnt
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD' || vic_scd_org || 'SHIPS';

    IF vln_cnt = 0 THEN
      INSERT INTO DELIVERY_PARAMETER_LOCAL
        (PARAMETER_ID,
         DML_ORACLE_ID,
         DML_TMSTMP,
         PARAMETER_UPDATE_TYPE,
         PARAMETER_FIELD,
         PARAMETER_DESCRIPTION)
      VALUES
        ('SCD' || vic_scd_org || 'SHIPS',
         vgc_job_id,
         SYSDATE,
         '1',
         vlc_ships,
         'NBR SHIPS BY MONTH');
    END IF;

    -- create control record for opens
    vln_cnt := 0;
    SELECT COUNT(*)
      INTO vln_cnt
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD' || vic_scd_org || 'OPENS';

    IF vln_cnt = 0 THEN
      INSERT INTO DELIVERY_PARAMETER_LOCAL
        (PARAMETER_ID,
         DML_ORACLE_ID,
         DML_TMSTMP,
         PARAMETER_UPDATE_TYPE,
         PARAMETER_FIELD,
         PARAMETER_DESCRIPTION)
      VALUES
        ('SCD' || vic_scd_org || 'OPENS',
         vgc_job_id,
         SYSDATE,
         '1',
         vlc_opens,
         'NBR OF OPENS');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_CREATE_PARAM_LOCAL_REC - ' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
  END;

  PROCEDURE p_get_part_um(vion_result IN OUT NUMBER) IS
    vlc_io_status  VARCHAR2(20);
    vln_io_sqlcode NUMBER;
    vlc_io_sqlerrm VARCHAR2(260);
  BEGIN
    vion_result := 0;
    Cor_Corporate_Parts_Cur.get_part_uom(vlc_io_status,
                                         vln_io_sqlcode,
                                         vlc_io_sqlerrm,
                                         tois.PART_UM,
                                         tois.PART_KEY_ID);
    IF vlc_io_status = 'FOUND' THEN
      NULL;
    ELSIF vlc_io_status = 'NOT_FOUND' THEN
      tois.PART_UM := NULL;
    ELSE
      RAISE_APPLICATION_ERROR(-20101,
                              vlc_io_sqlerrm ||
                              ' in Cor_Corporate_Parts_Cur.get_part_uom in');
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      tois.PART_UM := NULL;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_get_part_um - ' || vgc_job_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
  END;

  PROCEDURE p_get_cosb_exclusion_cde(vion_result IN OUT NUMBER,
                                     i_org_id    IN VARCHAR2) IS
    v_io_status       VARCHAR2(20);
    v_io_sqlcode      NUMBER;
    v_io_sqlerrm      VARCHAR2(260);
    v_customer_key_id ADR43_BACKLOGS.SHIP_TO_CUSTOMER_KEY_ID%TYPE;
    v_customer_nbr    TEMP_ORDER_ITEM_SHIPMENT.SBMT_CUSTOMER_ACCT_NBR%TYPE;
  BEGIN
    vion_result := 0;
    -- get customer key id
    v_customer_nbr := tois.PURCHASE_BY_ACCOUNT_BASE ||
                      tois.SHIP_TO_ACCOUNT_SUFFIX;
    IF v_customer_nbr IS NULL THEN
      v_customer_nbr := '9999999900';
    END IF;
    cor_source.cor_customer.get_customer_key_id(v_io_status,
                                                v_io_sqlcode,
                                                v_io_sqlerrm,
                                                v_customer_key_id,
                                                i_org_id,
                                                v_customer_nbr,
                                                44 -- US 0048 i_src_system
                                               ,
                                                'B' --i_cust_number_type
                                               ,
                                                'GC' -- i_point_in_time_flag
                                               ,
                                                'MIN' -- i_dist_channel
                                                );
    IF v_io_status = 'OK' THEN
      NULL;
    ELSIF v_io_status = 'NOT_FOUND' THEN
      v_customer_key_id := 0;
    ELSE
      RAISE_APPLICATION_ERROR(-20101,
                              v_io_sqlerrm ||
                              ' in cor_customer.get_customer_key_id in');
    END IF;

    -- get exclusion code
    SSA_SOURCE.SSAC1911_RECORD_EXCLUSION(0 -- GC
                                        ,
                                         tois.product_code,
                                         i_org_id,
                                         v_customer_key_id,
                                         tois.local_currency_billed_amount,
                                         tois.part_key_id,
                                         tois.remaining_qty_to_ship,
                                         NULL,
                                         NULL,
                                         NULL,
                                         NULL,
                                         tois.costed_sales_exclusion_cde);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      tois.PART_UM := NULL;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_cosb_exclusion_cde - ' || vgc_job_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
  END;

  PROCEDURE p_get_SAP_PC(vion_result IN OUT NUMBER) IS

  BEGIN
    vion_result := 0;
    SELECT SAP_PROFIT_CENTER_CDE
      INTO tois.SAP_PROFIT_CENTER_CDE
      FROM GBL_MGE_PROFIT_CENTERS gmpc, GBL_MGE_PROFIT_CENTER_RELS gmpcr
     WHERE gmpc.MGE_PROFIT_CENTER_ID = gmpcr.MGE_PROFIT_CENTER_ID
       AND gmpcr.ORGANIZATION_ID = '0048' -- for US only
       AND INDUSTRY_BUSINESS_CDE = tois.INDUSTRY_BUSINESS_CODE
       AND COMPETENCY_BUSINESS_CDE = tois.PRODUCT_BUSNS_LINE_FNCTN_ID
       AND mge_profit_center_abbrev_id = tois.PROFIT_CENTER_ABBR_NM;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      tois.SAP_PROFIT_CENTER_CDE := NULL;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_get_part_um - ' || vgc_job_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
  END;

  /************************************************************************
  * Procedure  : p_insert_tois_rec
  * Description: Insert new record into temp_order_itemp_shipment table.
  ************************************************************************/
  PROCEDURE p_insert_tois_rec(vion_result IN OUT NUMBER) IS
  BEGIN
    vion_result := 0;

    /* Insert the new record */
    INSERT INTO TEMP_ORDER_ITEM_SHIPMENT
      (TEMP_SHIP_SEQ,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DML_ORACLE_ID,
       DML_TMSTMP,
       PURCHASE_BY_ACCOUNT_BASE,
       SHIP_TO_ACCOUNT_SUFFIX,
       ORGANIZATION_KEY_ID,
       ACCOUNTING_ORG_KEY_ID,
       PRODCN_CNTRLR_CODE,
       ITEM_QUANTITY,
       RESRVN_LEVEL_1,
       RESRVN_LEVEL_5,
       RESRVN_LEVEL_9,
       QUANTITY_RELEASED,
       QUANTITY_SHIPPED,
       ISO_CURRENCY_CODE_1,
       LOCAL_CURRENCY_BILLED_AMOUNT,
       EXTENDED_BOOK_BILL_AMOUNT,
       UNIT_PRICE,
       CUSTOMER_REQUEST_DATE,
       AMP_SCHEDULE_DATE,
       RELEASE_DATE,
       AMP_SHIPPED_DATE,
       NBR_WINDOW_DAYS_EARLY,
       NBR_WINDOW_DAYS_LATE,
       INVENTORY_LOCATION_CODE,
       INVENTORY_BUILDING_NBR,
       CONTROLLER_UNIQUENESS_ID,
       ACTUAL_SHIP_LOCATION,
       ACTUAL_SHIP_BUILDING_NBR,
       ORDER_BOOKING_DATE,
       ORDER_RECEIVED_DATE,
       ORDER_TYPE_ID,
       REGTRD_DATE,
       REPORTED_AS_OF_DATE,
       PURCHASE_ORDER_DATE,
       PURCHASE_ORDER_NBR,
       PRODCN_CNTLR_EMPLOYEE_NBR,
       PART_PRCR_SRC_ORG_KEY_ID,
       TEAM_CODE,
       STOCK_MAKE_CODE,
       PRODUCT_CODE,
       PRODUCT_LINE_CODE,
       WW_ACCOUNT_NBR_BASE,
       WW_ACCOUNT_NBR_SUFFIX,
       CUSTOMER_FORECAST_CODE,
       A_TERRITORY_NBR,
       CUSTOMER_REFERENCE_PART_NBR,
       CUSTOMER_EXPEDITE_DATE,
       NBR_OF_EXPEDITES,
       ORIGINAL_EXPEDITE_DATE,
       CURRENT_EXPEDITE_DATE,
       EARLIEST_EXPEDITE_DATE,
       SCHEDULE_ON_CREDIT_HOLD_DATE,
       SCHEDULE_OFF_CREDIT_HOLD_DATE,
       CUSTOMER_CREDIT_HOLD_IND,
       CUSTOMER_ON_CREDIT_HOLD_DATE,
       TEMP_HOLD_IND,
       TEMP_HOLD_ON_DATE,
       TEMP_HOLD_OFF_DATE,
       CUSTOMER_TYPE_CODE,
       INDUSTRY_CODE,
       PRODUCT_BUSNS_LINE_ID,
       PRODUCT_BUSNS_LINE_FNCTN_ID,
       ZERO_PART_PROD_CODE,
       CUSTOMER_ACCT_TYPE_CDE,
       MFR_ORG_KEY_ID,
       MFG_CAMPUS_ID,
       MFG_BUILDING_NBR,
       REMAINING_QTY_TO_SHIP,
       INDUSTRY_BUSINESS_CODE,
       SBMT_PART_NBR,
       SBMT_CUSTOMER_ACCT_NBR,
       PROFIT_CENTER_ABBR_NM,
       BRAND_ID,
       SCHD_TYCO_MONTH_OF_YEAR_ID,
       SCHD_TYCO_QUARTER_ID,
       SCHD_TYCO_YEAR_ID,
       BATCH_ID,
       SUBMITTED_ORGANIZATION_ID,
       SUBMITTED_INVENTORY_ORG_ID,
       SBMT_PART_PROCUREMENT_ORG_ID,
       SBMT_MANUFACTURING_ORG_ID,
       PRIME_WORLDWIDE_CUSTOMER_ID,
       SBMT_PART_PRCR_SRC_ORG_ID,
       HIERARCHY_CUSTOMER_IND,
       HIERARCHY_CUSTOMER_ORG_ID,
       HIERARCHY_CUSTOMER_BASE_ID,
       HIERARCHY_CUSTOMER_SUFX_ID,
       PART_UM,
       SALES_OFFICE_CDE,
       SALES_GROUP_CDE,
       DATA_SOURCE_DESC,
       SBMT_SOLD_TO_CUSTOMER_ID,
       INVOICE_NBR,
       PART_KEY_ID,
       SOURCE_ID,
       DATA_SRC_ID,
       MRP_GROUP_CDE,
       DISTR_SHIP_WHEN_AVAIL_IND,
       CONSOLIDATION_INDICATOR_CDE,
       CONSOLIDATION_DT,
       COSTED_SALES_EXCLUSION_CDE,
       SAP_PROFIT_CENTER_CDE)
    VALUES
      (TEMP_SHIPMENT_SEQ.NEXTVAL,
       tois.AMP_ORDER_NBR,
       tois.ORDER_ITEM_NBR,
       tois.SHIPMENT_ID,
       vgc_job_id,
       SYSDATE,
       tois.PURCHASE_BY_ACCOUNT_BASE,
       tois.SHIP_TO_ACCOUNT_SUFFIX,
       tois.ORGANIZATION_KEY_ID,
       tois.ACCOUNTING_ORG_KEY_ID,
       tois.PRODCN_CNTRLR_CODE,
       tois.ITEM_QUANTITY,
       tois.RESRVN_LEVEL_1,
       tois.RESRVN_LEVEL_5,
       tois.RESRVN_LEVEL_9,
       tois.QUANTITY_RELEASED,
       tois.QUANTITY_SHIPPED,
       tois.ISO_CURRENCY_CODE_1,
       tois.LOCAL_CURRENCY_BILLED_AMOUNT,
       tois.EXTENDED_BOOK_BILL_AMOUNT,
       tois.UNIT_PRICE,
       tois.CUSTOMER_REQUEST_DATE,
       tois.AMP_SCHEDULE_DATE,
       tois.RELEASE_DATE,
       tois.AMP_SHIPPED_DATE,
       tois.NBR_WINDOW_DAYS_EARLY,
       tois.NBR_WINDOW_DAYS_LATE,
       tois.INVENTORY_LOCATION_CODE,
       tois.INVENTORY_BUILDING_NBR,
       tois.CONTROLLER_UNIQUENESS_ID,
       tois.ACTUAL_SHIP_LOCATION,
       tois.ACTUAL_SHIP_BUILDING_NBR,
       tois.ORDER_BOOKING_DATE,
       tois.ORDER_RECEIVED_DATE,
       tois.ORDER_TYPE_ID,
       tois.REGTRD_DATE,
       tois.REPORTED_AS_OF_DATE,
       tois.PURCHASE_ORDER_DATE,
       tois.PURCHASE_ORDER_NBR,
       tois.PRODCN_CNTLR_EMPLOYEE_NBR,
       tois.PART_PRCR_SRC_ORG_KEY_ID,
       tois.TEAM_CODE,
       tois.STOCK_MAKE_CODE,
       tois.PRODUCT_CODE,
       tois.PRODUCT_LINE_CODE,
       tois.WW_ACCOUNT_NBR_BASE,
       tois.WW_ACCOUNT_NBR_SUFFIX,
       tois.CUSTOMER_FORECAST_CODE,
       tois.A_TERRITORY_NBR,
       tois.CUSTOMER_REFERENCE_PART_NBR,
       tois.CUSTOMER_EXPEDITE_DATE,
       tois.NBR_OF_EXPEDITES,
       tois.ORIGINAL_EXPEDITE_DATE,
       tois.CURRENT_EXPEDITE_DATE,
       tois.EARLIEST_EXPEDITE_DATE,
       tois.SCHEDULE_ON_CREDIT_HOLD_DATE,
       tois.SCHEDULE_OFF_CREDIT_HOLD_DATE,
       tois.CUSTOMER_CREDIT_HOLD_IND,
       tois.CUSTOMER_ON_CREDIT_HOLD_DATE,
       tois.TEMP_HOLD_IND,
       tois.TEMP_HOLD_ON_DATE,
       tois.TEMP_HOLD_OFF_DATE,
       tois.CUSTOMER_TYPE_CODE,
       tois.INDUSTRY_CODE,
       tois.PRODUCT_BUSNS_LINE_ID,
       tois.PRODUCT_BUSNS_LINE_FNCTN_ID,
       tois.ZERO_PART_PROD_CODE,
       tois.CUSTOMER_ACCT_TYPE_CDE,
       tois.MFR_ORG_KEY_ID,
       tois.MFG_CAMPUS_ID,
       tois.MFG_BUILDING_NBR,
       tois.REMAINING_QTY_TO_SHIP,
       tois.INDUSTRY_BUSINESS_CODE,
       tois.SBMT_PART_NBR,
       tois.SBMT_CUSTOMER_ACCT_NBR,
       tois.PROFIT_CENTER_ABBR_NM,
       tois.BRAND_ID,
       tois.SCHD_TYCO_MONTH_OF_YEAR_ID,
       tois.SCHD_TYCO_QUARTER_ID,
       tois.SCHD_TYCO_YEAR_ID,
       tois.BATCH_ID,
       tois.SUBMITTED_ORGANIZATION_ID,
       tois.SUBMITTED_INVENTORY_ORG_ID,
       tois.SBMT_PART_PROCUREMENT_ORG_ID,
       tois.SBMT_MANUFACTURING_ORG_ID,
       tois.PRIME_WORLDWIDE_CUSTOMER_ID,
       tois.SBMT_PART_PRCR_SRC_ORG_ID,
       tois.HIERARCHY_CUSTOMER_IND,
       tois.HIERARCHY_CUSTOMER_ORG_ID,
       tois.HIERARCHY_CUSTOMER_BASE_ID,
       tois.HIERARCHY_CUSTOMER_SUFX_ID,
       tois.PART_UM,
       tois.SALES_OFFICE_CDE,
       tois.SALES_GROUP_CDE,
       tois.DATA_SOURCE_DESC,
       tois.SBMT_SOLD_TO_CUSTOMER_ID,
       tois.INVOICE_NBR,
       tois.PART_KEY_ID,
       '0048' -- since only US is the remaining Org using ADR-13 then just hard code
      ,
       1 -- these two field values so no need to change the ADR-13 programs
      ,
       tois.MRP_GROUP_CDE,
       tois.DISTR_SHIP_WHEN_AVAIL_IND,
       tois.CONSOLIDATION_INDICATOR_CDE,
       tois.CONSOLIDATION_DT,
       NVL(tois.costed_sales_exclusion_cde, 0),
       tois.SAP_PROFIT_CENTER_CDE);

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_INSERT_TOIS_REC - ' || vgc_job_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
  END;

  /************************************************************************
  * Procedure  : p_extract_billings
  * Description: Extract billings records and populate into temp_order
  *        _item_shipment table.
  ************************************************************************/
  PROCEDURE p_extract_billings(vin_batch_id   IN BILLING_TGT.BATCH_ID%TYPE,
                               vin_commit_cnt NUMBER,
                               vion_result    IN OUT NUMBER) IS

    CURSOR cur_billings IS
      SELECT SCORECARD_ORG_CODE,
             AMP_ORDER_NBR,
             ORDER_ITEM_NBR,
             SHIPMENT_ID,
             PURCHASE_BY_ACCOUNT_BASE,
             SHIP_TO_ACCOUNT_SUFFIX,
             CO_ORG_CODE,
             NVL(PRODCN_CNTRLR_CODE, '*'),
             ROUND(ITEM_QUANTITY, 0),
             RESRVN_LEVEL_1,
             RESRVN_LEVEL_5,
             RESRVN_LEVEL_9,
             ROUND(QUANTITY_RELEASED, 0),
             ROUND(QUANTITY_SHIPPED, 0),
             ISO_CURRENCY_CODE_1,
             LOCAL_CURRENCY_BILLED_AMOUNT,
             EXTENDED_BOOK_BILL_AMOUNT,
             NVL(UNIT_PRICE, 0),
             CUSTOMER_REQUEST_DATE,
             AMP_SCHEDULE_DATE,
             RELEASE_DATE,
             AMP_SHIPPED_DATE,
             NBR_WINDOW_DAYS_EARLY,
             NBR_WINDOW_DAYS_LATE,
             NVL(INVENTORY_LOCATION_CODE, '*'),
             NVL(INVENTORY_BUILDING_NBR, '*'),
             NVL(INVENTORY_ORG_CODE, '*'),
             NVL(ACTUAL_SHIP_LOCATION, '*'),
             NVL(ACTUAL_SHIP_BUILDING_NBR, '*'),
             ORDER_BOOKING_DATE,
             ORDER_RECEIVED_DATE,
             ORDER_TYPE_ID,
             REGTRD_DATE,
             REPORTED_AS_OF_DATE,
             PURCHASE_ORDER_DATE,
             PURCHASE_ORDER_NBR,
             NVL(PRODCN_CNTLR_EMPLOYEE_NBR, '*'),
             NVL(PART_PRCMT_SOURCE_ORG_CODE, '*'),
             NVL(TEAM_CODE, '*'),
             NVL(STOCK_MAKE_CODE, '*'),
             NVL(PRODUCT_CODE, '*'),
             NVL(INTRNTNL_PRODUCT_LINE_CODE, '*'),
             NVL(WW_ACCOUNT_NBR_BASE, '*'),
             NVL(WW_ACCOUNT_NBR_SUFFIX, '*'),
             CUSTOMER_FORECAST_CODE,
             NVL(A_TERRITORY_NBR, '*'),
             CUSTOMER_REFERENCE_PART_NBR,
             CUSTOMER_EXPEDITE_DATE,
             NBR_OF_EXPEDITES,
             ORIGINAL_EXPEDITE_DATE,
             CURRENT_EXPEDITE_DATE,
             EARLIEST_EXPEDITE_DATE,
             SCHEDULE_ON_CREDIT_HOLD_DATE,
             SCHEDULE_OFF_CREDIT_HOLD_DATE,
             CUSTOMER_CREDIT_HOLD_IND,
             CUSTOMER_ON_CREDIT_HOLD_DATE,
             TEMP_HOLD_IND,
             TEMP_HOLD_ON_DATE,
             TEMP_HOLD_OFF_DATE,
             CUSTOMER_TYPE_CODE,
             NVL(INDUSTRY_CODE, '*'),
             PRODUCT_BUSNS_LINE_ID,
             NVL(PRODUCT_BUSNS_LINE_FNCTN_ID, '*'),
             NVL(ZERO_PART_PRODUCT_CODE, '*'),
             TRADE_OR_INTERCO_CODE,
             NVL(MFG_DIV_ORG_CODE, '*'),
             NVL(MFG_CAMPUS_ID, '*'),
             NVL(MFG_BUILDING_NBR, '*'),
             NULL,
             INDUSTRY_BUSINESS_CODE,
             SBMT_PART_NBR,
             SBMT_CUSTOMER_ACCT_NBR,
             NVL(PROFIT_CENTER_ABBR_NM, '*'),
             BRAND_ID,
             SCHD_TYCO_MONTH_OF_YEAR_ID,
             SCHD_TYCO_QUARTER_ID,
             SCHD_TYCO_YEAR_ID,
             BATCH_ID,
             PRI_WW_ACCOUNT_NBR_BASE || PRI_WW_ACCOUNT_NBR_SUFFIX,
             INVOICE_NBR,
             a.PART_KEY_ID,
             DISTR_SHIP_WHEN_AVAIL_IND,
             CONSOLIDATION_INDICATOR_CDE,
             CONSOLIDATION_DT
        FROM BILLING_TGT a
       WHERE BATCH_ID = vin_batch_id
         AND (TRANSACTION_TYPE_CDE IS NULL OR TRANSACTION_TYPE_CDE = 'S0')
         AND NOT (PURCHASE_BY_ACCOUNT_BASE IS NULL OR
              SHIP_TO_ACCOUNT_SUFFIX IS NULL);

    vln_commit_cnt NUMBER := 0;
    vlc_org_id     GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE;
  BEGIN
    vion_result := 0;

    -- process all billings records
    OPEN cur_billings;
    LOOP
      tois := NULL;

      FETCH cur_billings
        INTO tgt.SCORECARD_ORG_CODE,
             tois.AMP_ORDER_NBR,
             tois.ORDER_ITEM_NBR,
             tois.SHIPMENT_ID,
             tois.PURCHASE_BY_ACCOUNT_BASE,
             tois.SHIP_TO_ACCOUNT_SUFFIX,
             tgt.CO_ORG_CODE,
             tois.PRODCN_CNTRLR_CODE,
             tois.ITEM_QUANTITY,
             tois.RESRVN_LEVEL_1,
             tois.RESRVN_LEVEL_5,
             tois.RESRVN_LEVEL_9,
             tois.QUANTITY_RELEASED,
             tois.QUANTITY_SHIPPED,
             tois.ISO_CURRENCY_CODE_1,
             tois.LOCAL_CURRENCY_BILLED_AMOUNT,
             tois.EXTENDED_BOOK_BILL_AMOUNT,
             tois.UNIT_PRICE,
             tois.CUSTOMER_REQUEST_DATE,
             tois.AMP_SCHEDULE_DATE,
             tois.RELEASE_DATE,
             tois.AMP_SHIPPED_DATE,
             tois.NBR_WINDOW_DAYS_EARLY,
             tois.NBR_WINDOW_DAYS_LATE,
             tois.INVENTORY_LOCATION_CODE,
             tois.INVENTORY_BUILDING_NBR,
             tgt.INVENTORY_ORG_CODE,
             tois.ACTUAL_SHIP_LOCATION,
             tois.ACTUAL_SHIP_BUILDING_NBR,
             tois.ORDER_BOOKING_DATE,
             tois.ORDER_RECEIVED_DATE,
             tois.ORDER_TYPE_ID,
             tois.REGTRD_DATE,
             tois.REPORTED_AS_OF_DATE,
             tois.PURCHASE_ORDER_DATE,
             tois.PURCHASE_ORDER_NBR,
             tois.PRODCN_CNTLR_EMPLOYEE_NBR,
             tgt.PART_PRCMT_SOURCE_ORG_CODE,
             tois.TEAM_CODE,
             tois.STOCK_MAKE_CODE,
             tois.PRODUCT_CODE,
             tgt.INTRNTNL_PRODUCT_LINE_CODE,
             tois.WW_ACCOUNT_NBR_BASE,
             tois.WW_ACCOUNT_NBR_SUFFIX,
             tois.CUSTOMER_FORECAST_CODE,
             tois.A_TERRITORY_NBR,
             tois.CUSTOMER_REFERENCE_PART_NBR,
             tois.CUSTOMER_EXPEDITE_DATE,
             tois.NBR_OF_EXPEDITES,
             tois.ORIGINAL_EXPEDITE_DATE,
             tois.CURRENT_EXPEDITE_DATE,
             tois.EARLIEST_EXPEDITE_DATE,
             tois.SCHEDULE_ON_CREDIT_HOLD_DATE,
             tois.SCHEDULE_OFF_CREDIT_HOLD_DATE,
             tois.CUSTOMER_CREDIT_HOLD_IND,
             tois.CUSTOMER_ON_CREDIT_HOLD_DATE,
             tois.TEMP_HOLD_IND,
             tois.TEMP_HOLD_ON_DATE,
             tois.TEMP_HOLD_OFF_DATE,
             tois.CUSTOMER_TYPE_CODE,
             tois.INDUSTRY_CODE,
             tois.PRODUCT_BUSNS_LINE_ID,
             tois.PRODUCT_BUSNS_LINE_FNCTN_ID,
             tois.ZERO_PART_PROD_CODE,
             tgt.TRADE_OR_INTERCO_CODE,
             tgt.MFG_DIV_ORG_CODE,
             tois.MFG_CAMPUS_ID,
             tois.MFG_BUILDING_NBR,
             tois.REMAINING_QTY_TO_SHIP,
             tois.INDUSTRY_BUSINESS_CODE,
             tois.SBMT_PART_NBR,
             tois.SBMT_CUSTOMER_ACCT_NBR,
             tois.PROFIT_CENTER_ABBR_NM,
             tois.BRAND_ID,
             tois.SCHD_TYCO_MONTH_OF_YEAR_ID,
             tois.SCHD_TYCO_QUARTER_ID,
             tois.SCHD_TYCO_YEAR_ID,
             tois.BATCH_ID,
             tois.PRIME_WORLDWIDE_CUSTOMER_ID,
             tois.INVOICE_NBR,
             tois.PART_KEY_ID,
             tois.DISTR_SHIP_WHEN_AVAIL_IND,
             tois.CONSOLIDATION_INDICATOR_CDE,
             tois.CONSOLIDATION_DT;

      EXIT WHEN(cur_billings%NOTFOUND);

      IF scdCommonBatch.GetOrgKeyIDV3(tgt.SCORECARD_ORG_CODE,
                                      tois.AMP_SHIPPED_DATE,
                                      tois.ORGANIZATION_KEY_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetShipToOrgID(tgt.SCORECARD_ORG_CODE, vlc_org_id) THEN
        IF scdCommonBatch.GetOrgKeyIDV4(vlc_org_id,
                                        tois.AMP_SHIPPED_DATE,
                                        tois.ACCOUNTING_ORG_KEY_ID) THEN
          NULL;
        END IF;
      ELSE
        tois.ACCOUNTING_ORG_KEY_ID := 0;
      END IF;

      IF scdCommonBatch.GetOrgIDV3(tgt.INVENTORY_ORG_CODE,
                                   tois.AMP_SHIPPED_DATE,
                                   tois.CONTROLLER_UNIQUENESS_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetMfgOrgKeyID(tgt.MFG_DIV_ORG_CODE,
                                       tois.MFR_ORG_KEY_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetOrgKeyIDV3(tgt.PART_PRCMT_SOURCE_ORG_CODE,
                                      tois.AMP_SHIPPED_DATE,
                                      tois.PART_PRCR_SRC_ORG_KEY_ID) THEN
        NULL;
      END IF;

      tois.SUBMITTED_ORGANIZATION_ID    := tgt.SCORECARD_ORG_CODE;
      tois.PRODUCT_LINE_CODE            := tgt.INTRNTNL_PRODUCT_LINE_CODE;
      tois.CUSTOMER_ACCT_TYPE_CDE       := tgt.TRADE_OR_INTERCO_CODE;
      tois.SUBMITTED_INVENTORY_ORG_ID   := tgt.INVENTORY_ORG_CODE;
      tois.SBMT_PART_PROCUREMENT_ORG_ID := tgt.PART_PRCMT_SOURCE_ORG_CODE;
      tois.SBMT_MANUFACTURING_ORG_ID    := tgt.MFG_DIV_ORG_CODE;
      tois.SBMT_PART_PRCR_SRC_ORG_ID    := tgt.PART_PRCMT_SOURCE_ORG_CODE;
      tois.HIERARCHY_CUSTOMER_IND       := 0;
      tois.HIERARCHY_CUSTOMER_ORG_ID    := vlc_org_id;
      tois.HIERARCHY_CUSTOMER_BASE_ID   := tois.PURCHASE_BY_ACCOUNT_BASE;
      tois.HIERARCHY_CUSTOMER_SUFX_ID   := tois.SHIP_TO_ACCOUNT_SUFFIX;
      tois.SALES_OFFICE_CDE             := '*';
      tois.SALES_GROUP_CDE              := '*';
      tois.SBMT_SOLD_TO_CUSTOMER_ID     := SUBSTR(tois.SBMT_CUSTOMER_ACCT_NBR,
                                                  1,
                                                  8);
      tois.MRP_GROUP_CDE                := '*';

      -- assign data source
      IF tois.BRAND_ID = 2 THEN
        tois.DATA_SOURCE_DESC := 'RYCADR313';
      ELSE
        tois.DATA_SOURCE_DESC := 'TYCOADR13';
      END IF;

      -- derive credit hold on date
      IF NVL(tois.SCHEDULE_OFF_CREDIT_HOLD_DATE, k_beg_of_time) !=
         k_beg_of_time AND tois.SCHEDULE_ON_CREDIT_HOLD_DATE IS NULL THEN
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE := tois.ORDER_BOOKING_DATE;
      END IF;

      -- get PART_UM
      p_get_part_um(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      -- get SAP profit ctr
      p_get_SAP_PC(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      -- insert record to temp_order_item_shipment table
      p_insert_tois_rec(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      vln_commit_cnt := vln_commit_cnt + 1;
      IF vln_commit_cnt >= vin_commit_cnt THEN
        COMMIT;
        vln_commit_cnt := 0;
      END IF;

    END LOOP;
    COMMIT;
    CLOSE cur_billings;

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_errno;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS - ' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || vgc_errmsg);
      ROLLBACK;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS - ' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_billings;

  /************************************************************************
  * Procedure  : p_extract_backlog
  * Description: Extract backlog records and populate into temp_order_item
  *        _shipment table.
  ************************************************************************/
  PROCEDURE p_extract_backlog(vin_batch_id   IN BILLING_TGT.BATCH_ID%TYPE,
                              vin_commit_cnt NUMBER,
                              vion_result    IN OUT NUMBER) IS

    CURSOR cur_backlog IS
      SELECT SCORECARD_ORG_CODE,
             AMP_ORDER_NBR,
             ORDER_ITEM_NBR,
             SHIPMENT_ID,
             PURCHASE_BY_ACCOUNT_BASE,
             SHIP_TO_ACCOUNT_SUFFIX,
             CO_ORG_CODE,
             NVL(PRODCN_CNTRLR_CODE, '*'),
             ROUND(ITEM_QUANTITY, 0),
             RESRVN_LEVEL_1,
             RESRVN_LEVEL_5,
             RESRVN_LEVEL_9,
             ROUND(QUANTITY_RELEASED, 0),
             0, --round(QUANTITY_SHIPPED,0),
             ISO_CURRENCY_CODE_1,
             LOCAL_CURRENCY_BILLED_AMOUNT,
             EXTENDED_BOOK_BILL_AMOUNT,
             NVL(UNIT_PRICE, 0),
             CUSTOMER_REQUEST_DATE,
             AMP_SCHEDULE_DATE,
             RELEASE_DATE,
             AMP_SHIPPED_DATE,
             NBR_WINDOW_DAYS_EARLY,
             NBR_WINDOW_DAYS_LATE,
             NVL(INVENTORY_LOCATION_CODE, '*'),
             NVL(INVENTORY_BUILDING_NBR, '*'),
             NVL(INVENTORY_ORG_CODE, '*'),
             NVL(ACTUAL_SHIP_LOCATION, '*'),
             NVL(ACTUAL_SHIP_BUILDING_NBR, '*'),
             ORDER_BOOKING_DATE,
             ORDER_RECEIVED_DATE,
             ORDER_TYPE_ID,
             REGTRD_DATE,
             REPORTED_AS_OF_DATE,
             PURCHASE_ORDER_DATE,
             PURCHASE_ORDER_NBR,
             NVL(PRODCN_CNTLR_EMPLOYEE_NBR, '*'),
             NVL(PART_PRCMT_SOURCE_ORG_CODE, '*'),
             NVL(TEAM_CODE, '*'),
             NVL(STOCK_MAKE_CODE, '*'),
             NVL(PRODUCT_CODE, '*'),
             NVL(INTRNTNL_PRODUCT_LINE_CODE, '*'),
             NVL(WW_ACCOUNT_NBR_BASE, '*'),
             NVL(WW_ACCOUNT_NBR_SUFFIX, '*'),
             CUSTOMER_FORECAST_CODE,
             NVL(A_TERRITORY_NBR, '*'),
             CUSTOMER_REFERENCE_PART_NBR,
             CUSTOMER_EXPEDITE_DATE,
             NBR_OF_EXPEDITES,
             ORIGINAL_EXPEDITE_DATE,
             CURRENT_EXPEDITE_DATE,
             EARLIEST_EXPEDITE_DATE,
             SCHEDULE_ON_CREDIT_HOLD_DATE,
             SCHEDULE_OFF_CREDIT_HOLD_DATE,
             CUSTOMER_CREDIT_HOLD_IND,
             CUSTOMER_ON_CREDIT_HOLD_DATE,
             TEMP_HOLD_IND,
             TEMP_HOLD_ON_DATE,
             TEMP_HOLD_OFF_DATE,
             CUSTOMER_TYPE_CODE,
             NVL(INDUSTRY_CODE, '*'),
             PRODUCT_BUSNS_LINE_ID,
             NVL(PRODUCT_BUSNS_LINE_FNCTN_ID, '*'),
             NVL(ZERO_PART_PRODUCT_CODE, '*'),
             TRADE_OR_INTERCO_CODE,
             NVL(MFG_DIV_ORG_CODE, '*'),
             NVL(MFG_CAMPUS_ID, '*'),
             NVL(MFG_BUILDING_NBR, '*'),
             REMAINING_QTY_TO_SHIP,
             INDUSTRY_BUSINESS_CODE,
             SBMT_PART_NBR,
             SBMT_CUSTOMER_ACCT_NBR,
             NVL(PROFIT_CENTER_ABBR_NM, '*'),
             BRAND_ID,
             SCHD_TYCO_MONTH_OF_YEAR_ID,
             SCHD_TYCO_QUARTER_ID,
             SCHD_TYCO_YEAR_ID,
             BATCH_ID,
             PRI_WW_ACCOUNT_NBR_BASE || PRI_WW_ACCOUNT_NBR_SUFFIX,
             a.PART_KEY_ID,
             DISTR_SHIP_WHEN_AVAIL_IND
        FROM BACKLOG_TGT a
       WHERE BATCH_ID = vin_batch_id
         AND (TRANSACTION_TYPE_CDE IS NULL OR TRANSACTION_TYPE_CDE = 'B0')
         AND NOT (PURCHASE_BY_ACCOUNT_BASE IS NULL OR
              SHIP_TO_ACCOUNT_SUFFIX IS NULL)
         AND (resrvn_level_1 + resrvn_level_5 + resrvn_level_9 +
             quantity_released) > 0;

    vln_commit_cnt NUMBER := 0;
    vlc_org_id     GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE;
  BEGIN
    vion_result := 0;

    -- process all backlog records
    OPEN cur_backlog;
    LOOP
      tois := NULL;

      FETCH cur_backlog
        INTO tgt.SCORECARD_ORG_CODE,
        tois.AMP_ORDER_NBR,
        tois.ORDER_ITEM_NBR,
        tois.SHIPMENT_ID,
        tois.PURCHASE_BY_ACCOUNT_BASE,
        tois.SHIP_TO_ACCOUNT_SUFFIX,
        tgt.CO_ORG_CODE,
        tois.PRODCN_CNTRLR_CODE,
        tois.ITEM_QUANTITY,
        tois.RESRVN_LEVEL_1,
        tois.RESRVN_LEVEL_5,
        tois.RESRVN_LEVEL_9,
        tois.QUANTITY_RELEASED,
        tois.QUANTITY_SHIPPED,
        tois.ISO_CURRENCY_CODE_1,
        tois.LOCAL_CURRENCY_BILLED_AMOUNT,
        tois.EXTENDED_BOOK_BILL_AMOUNT,
        tois.UNIT_PRICE,
        tois.CUSTOMER_REQUEST_DATE,
        tois.AMP_SCHEDULE_DATE,
        tois.RELEASE_DATE,
        tois.AMP_SHIPPED_DATE,
        tois.NBR_WINDOW_DAYS_EARLY,
        tois.NBR_WINDOW_DAYS_LATE,
        tois.INVENTORY_LOCATION_CODE,
        tois.INVENTORY_BUILDING_NBR,
        tgt.INVENTORY_ORG_CODE,
        tois.ACTUAL_SHIP_LOCATION,
        tois.ACTUAL_SHIP_BUILDING_NBR,
        tois.ORDER_BOOKING_DATE,
        tois.ORDER_RECEIVED_DATE,
        tois.ORDER_TYPE_ID,
        tois.REGTRD_DATE,
        tois.REPORTED_AS_OF_DATE,
        tois.PURCHASE_ORDER_DATE,
        tois.PURCHASE_ORDER_NBR,
        tois.PRODCN_CNTLR_EMPLOYEE_NBR,
        tgt.PART_PRCMT_SOURCE_ORG_CODE,
        tois.TEAM_CODE,
        tois.STOCK_MAKE_CODE,
        tois.PRODUCT_CODE,
        tgt.INTRNTNL_PRODUCT_LINE_CODE,
        tois.WW_ACCOUNT_NBR_BASE,
        tois.WW_ACCOUNT_NBR_SUFFIX,
        tois.CUSTOMER_FORECAST_CODE,
        tois.A_TERRITORY_NBR,
        tois.CUSTOMER_REFERENCE_PART_NBR,
        tois.CUSTOMER_EXPEDITE_DATE,
        tois.NBR_OF_EXPEDITES,
        tois.ORIGINAL_EXPEDITE_DATE,
        tois.CURRENT_EXPEDITE_DATE,
        tois.EARLIEST_EXPEDITE_DATE,
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE,
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE,
        tois.CUSTOMER_CREDIT_HOLD_IND,
        tois.CUSTOMER_ON_CREDIT_HOLD_DATE,
        tois.TEMP_HOLD_IND,
        tois.TEMP_HOLD_ON_DATE,
        tois.TEMP_HOLD_OFF_DATE,
        tois.CUSTOMER_TYPE_CODE,
        tois.INDUSTRY_CODE,
        tois.PRODUCT_BUSNS_LINE_ID,
        tois.PRODUCT_BUSNS_LINE_FNCTN_ID,
        tois.ZERO_PART_PROD_CODE,
        tgt.TRADE_OR_INTERCO_CODE,
        tgt.MFG_DIV_ORG_CODE,
        tois.MFG_CAMPUS_ID,
        tois.MFG_BUILDING_NBR,
        tois.REMAINING_QTY_TO_SHIP,
        tois.INDUSTRY_BUSINESS_CODE,
        tois.SBMT_PART_NBR,
        tois.SBMT_CUSTOMER_ACCT_NBR,
        tois.PROFIT_CENTER_ABBR_NM,
        tois.BRAND_ID,
        tois.SCHD_TYCO_MONTH_OF_YEAR_ID,
        tois.SCHD_TYCO_QUARTER_ID,
        tois.SCHD_TYCO_YEAR_ID,
        tois.BATCH_ID,
        tois.PRIME_WORLDWIDE_CUSTOMER_ID,
        tois.PART_KEY_ID,
        tois.DISTR_SHIP_WHEN_AVAIL_IND;

      EXIT WHEN(cur_backlog%NOTFOUND);

      IF scdCommonBatch.GetOrgKeyIDV3(tgt.SCORECARD_ORG_CODE,
                                      tois.REPORTED_AS_OF_DATE,
                                      tois.ORGANIZATION_KEY_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetShipToOrgID(tgt.SCORECARD_ORG_CODE, vlc_org_id) THEN
        IF scdCommonBatch.GetOrgKeyIDV4(vlc_org_id,
                                        tois.REPORTED_AS_OF_DATE,
                                        tois.ACCOUNTING_ORG_KEY_ID) THEN
          NULL;
        END IF;
      ELSE
        tois.ACCOUNTING_ORG_KEY_ID := 0;
      END IF;

      IF scdCommonBatch.GetOrgIDV3(tgt.INVENTORY_ORG_CODE,
                                   tois.REPORTED_AS_OF_DATE,
                                   tois.CONTROLLER_UNIQUENESS_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetMfgOrgKeyID(tgt.MFG_DIV_ORG_CODE,
                                       tois.MFR_ORG_KEY_ID) THEN
        NULL;
      END IF;

      IF scdCommonBatch.GetOrgKeyIDV3(tgt.PART_PRCMT_SOURCE_ORG_CODE,
                                      tois.REPORTED_AS_OF_DATE,
                                      tois.PART_PRCR_SRC_ORG_KEY_ID) THEN
        NULL;
      END IF;

      tois.SUBMITTED_ORGANIZATION_ID    := tgt.SCORECARD_ORG_CODE;
      tois.PRODUCT_LINE_CODE            := tgt.INTRNTNL_PRODUCT_LINE_CODE;
      tois.CUSTOMER_ACCT_TYPE_CDE       := tgt.TRADE_OR_INTERCO_CODE;
      tois.SUBMITTED_INVENTORY_ORG_ID   := tgt.INVENTORY_ORG_CODE;
      tois.SBMT_PART_PROCUREMENT_ORG_ID := tgt.PART_PRCMT_SOURCE_ORG_CODE;
      tois.SBMT_MANUFACTURING_ORG_ID    := tgt.MFG_DIV_ORG_CODE;
      tois.SBMT_PART_PRCR_SRC_ORG_ID    := tgt.PART_PRCMT_SOURCE_ORG_CODE;
      tois.REMAINING_QTY_TO_SHIP        := tois.RESRVN_LEVEL_1 +
                                           tois.RESRVN_LEVEL_5 +
                                           tois.RESRVN_LEVEL_9 +
                                           tois.QUANTITY_RELEASED;
      tois.HIERARCHY_CUSTOMER_IND       := 0;
      tois.HIERARCHY_CUSTOMER_ORG_ID    := vlc_org_id;
      tois.HIERARCHY_CUSTOMER_BASE_ID   := tois.PURCHASE_BY_ACCOUNT_BASE;
      tois.HIERARCHY_CUSTOMER_SUFX_ID   := tois.SHIP_TO_ACCOUNT_SUFFIX;
      tois.SALES_OFFICE_CDE             := '*';
      tois.SALES_GROUP_CDE              := '*';
      tois.SBMT_SOLD_TO_CUSTOMER_ID     := SUBSTR(tois.SBMT_CUSTOMER_ACCT_NBR,
                                                  1,
                                                  8);
      tois.MRP_GROUP_CDE                := '*';

      -- assign data source
      IF tois.BRAND_ID = 2 THEN
        tois.DATA_SOURCE_DESC := 'RYCADR313';
      ELSE
        tois.DATA_SOURCE_DESC := 'TYCOADR13';
      END IF;

      -- derive credit hold on date
      IF NVL(tois.SCHEDULE_OFF_CREDIT_HOLD_DATE, k_beg_of_time) !=
         k_beg_of_time AND tois.SCHEDULE_ON_CREDIT_HOLD_DATE IS NULL THEN
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE := tois.ORDER_BOOKING_DATE;
      END IF;

      -- set schedule date to beg_time if null and request_date is not null
      IF tois.AMP_SCHEDULE_DATE IS NULL THEN
        IF tois.CUSTOMER_REQUEST_DATE IS NOT NULL THEN
          tois.AMP_SCHEDULE_DATE := k_beg_of_time;
        END IF;
      END IF;

      -- get PART_UM
      p_get_part_um(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      -- get COSB exclusion code
      p_get_cosb_exclusion_cde(vion_result, vlc_org_id);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      -- get SAP profit ctr
      p_get_SAP_PC(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      -- insert record to temp_order_item_shipment table
      p_insert_tois_rec(vion_result);
      IF vion_result <> 0 THEN
        EXIT;
      END IF;

      vln_commit_cnt := vln_commit_cnt + 1;
      IF vln_commit_cnt >= vin_commit_cnt THEN
        COMMIT;
        vln_commit_cnt := 0;
      END IF;

    END LOOP;
    COMMIT;
    CLOSE cur_backlog;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BACKLOG -' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_backlog;

  /************************************************************************
  * Procedure  : p_extract_scd_data
  * Description: Extract billings AND backlog records from target table and
  *        create the control record in deliver_parameter_local table.
  ************************************************************************/
  PROCEDURE p_extract_scd_data(vin_batch_id   IN BILLING_TGT.BATCH_ID%TYPE,
                               vic_scd_org    IN BILLING_TGT.SCORECARD_ORG_CODE%TYPE,
                               vic_data_src   IN VARCHAR2,
                               vin_commit_cnt IN NUMBER,
                               vion_result    IN OUT NUMBER) IS

  BEGIN
    vion_result := 0;
    vgc_job_id  := 'SCDU' || vic_scd_org || '00';

    -- create control records
    p_create_param_local_rec(vin_batch_id,
                             vic_scd_org,
                             vic_data_src,
                             vion_result);
    IF vion_result <> 0 THEN
      GOTO end_process;
    END IF;

    -- extract billings records
    p_extract_billings(vin_batch_id, vin_commit_cnt, vion_result);
    IF vion_result <> 0 THEN
      GOTO end_process;
    END IF;

    -- no backlog/opens if '0S'
    IF vic_scd_org = '0S' THEN
      GOTO end_process;
    END IF;

    -- extract backlog/opens records
    p_extract_backlog(vin_batch_id, vin_commit_cnt, vion_result);

    <<end_process>>
    NULL;
  END;
END Pkg_Post_Daf_Process;
/
