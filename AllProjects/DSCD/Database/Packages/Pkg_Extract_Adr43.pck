CREATE OR REPLACE PACKAGE SCD_SOURCE.PKG_EXTRACT_ADR43
AS

/*
**********************************************************************************************************
*  Package:  pkg_Extract_ADR43
*  Description: This package/stored pocedure is used to extract data from
*               ADR43 target tables into temp_order_item_shipment table.
*
*  Procedures:  p_extract_scd_data
*               p_create_param_local_rec
*               p_insert_tois_rec
*               p_extract_billings
*               p_extract_backlog
*               p_extract_deliveries
*  ----------------------------------------------------------------------------------------------------------

* Revisions Log:

*      Date       Programmer  Description
*      --------   ----------  ------------------------------------------------
* 1.0  02/10/2000 A. Orbeta   Original Version
* 1.1  04/27/2001 A. Orbeta   DSCD rewrite
* 1.2  06/18/2001 A. Orbeta   Added logic to ignore data with stock transport (V) AND special charges (ZSPC).
* 1.3  07/09/2001 A. Orbeta   Added logic to ignore records with sbmt_sales_stat_category_cde='MV'.
* 1.4  07/26/2001 A. Orbeta   Changed logic on updating hold_orders tbl.
* 1.5  09/21/2001 A. Orbeta   Changed logic to use data_src_id instead of org_code.
* 1.6  10/12/2001 A. Orbeta   Changed order_booking_date AND regtrd_date to use customer_order_recv_dt instead of transaction_dt
* 1.7  10/16/2001 A. Orbeta   Changed logic on 'JIT' indicator column.
* 1.8  10/17/2001 A. Orbeta   Fixed logic error on sched_credit_hold_date.
* 1.9  11/06/2001 A. Orbeta   Modify logic so that delivery_block and chedit_check_status is not set to null when _hold_off_date is set.
* 1.10 12/05/2001 A. Orbeta   Remove logic to derive hold/off hold dates.
* 1.11 12/11/2001 A. Orbeta   Change logic to derive brand_id value.
* 1.12 03/25/2002 A. Orbeta   Add new hierarchy_ columns for profit center  reporting.
* 1.13 04/03/2002 A. Orbeta   Add logic to ignore re-billed records.
* 1.14 04/03/2002 J. DeLong   Add Cost fields.
* 1.15 05/01/2002 A. Orbeta   Modify logic to derive on/off hold dates to include schedule_line_nbr.
* 1.16 07/39/2002 A. Orbeta   Set sched_date = current_sched_date for SAP   backlogs instead of orig_sched_date.
* 1.17 08/19/2002 A. Orbeta   Set RESRVN_LEVEL_5 = 0 for shipments
* 1.18 08/22/2002 A. Orbeta   Set sched_date = current_sched_date for ALL backlogs instead of orig_sched_date.
* 1.19 08/26/2002 A. Orbeta   Add _schedule_date columns.
* 1.20 11/19/2002 A. Orbeta   Add logic to ignore shipment records with BILLING_TYPE_CDE = 'IV' AND SALES_DOC_TYPE_CDE = 'C'
* 1.21 11/21/2002 A. Orbeta   Set to '*' if SALES_ columns value is null.
* 1.22 12/04/2002 A. Orbeta   Add SBMT_SOLD_TO_CUSTOMER_ID column.
* 1.23 01/15/2003 A. Orbeta   Add columns for Germany's SAP implementation.
* 1.24 06/06/2003 A. Orbeta   Change logic on setting cust_hold_ind = 'H'' to only limit to 'B' and 'C' instead of all.
* 1.25 06/20/2003 A. Orbeta   Add new columns for Japan (S1) enchancments.
* 1.26 10/14/2003 A. Orbeta   Add Third Party Drop-Ships Ind columns.
* 1.27 03/09/2004 A. Orbeta   Add filter to exclude records with 'ZPRJ' or 'ZREW' values in SBMT_SALES_STAT_CATEGORY_CDE - MA/COM.
* 1.28 03/16/2004 A. Orbeta   Change logic to ignore billing records with BILLING_TYPE_CDE = 'IV' - MA/COM.
* 1.29 05/07/2004 A. Orbeta   Add new columns for Replenishment Lead Time enhancement - SAP.
* 1.30 11/16/2004 A. Orbeta   Add 2 new fields for TEPS Ultimate end customer.
* 1.31 12/07/2004 A. Orbeta   Standardize Make Stock value; Add MRP Group Code and COMPLETE_DELIVERY_IND fields.
* 1.32 01/10/2005 A. Orbeta   Alpha Part project.
* 1.33 03/11/2005 A. Orbeta   Add temporary exclusion logic for TEPS.
* 1.34 04/11/2005 A. Orbeta   Modify exclusion for Material Type and add item category code in ('ZT1D','ZSRO','ZS3P')
* 1.35 09/22/2005 A. Orbeta   Add new column PLANNED_INSTALLATION_CMPL_DT
* 1.36 12/30/2005 A. Orbeta   Add source_id and data_src_id columns.
* 1.37 01/17/2006 A. Orbeta   Remove PART_NBR column.
* 1.38 06/16/2006 A. Orbeta   Set MRP_Group_Cde = '*' if value is null. Filter enhancement - phase III.
* 1.39 07/16/2007 A. Orbeta   Add DISTR_SHIP_WHEN_AVAIL_IND field.
* 1.40 10/09/2009 A. Orbeta   Add COSB exclusion code logic for backlog.
* 1.41 11/02/2009 A. Orbeta   Add SAP profit center.
* 1.42 01/26/2010 A. Orbeta   Add Storage Location ID AND Sales Territory code.
* 1.43 08/25/2010 A. Orbeta   Add TMS Days Qty field.
* 1.44 12/22/2010 A. Orbeta   Exclude shipments for ADC orgs using parameter.
* 1.45 12/27/2010 A. Orbeta   Add Physical Bldg.
* 1.46 01/12/2011 A. Orbeta   Add Forecast Prime Partner fields for Sched Agrmt phase 2.
* 1.46 07/06/2011 Kumar Emany Add TELAG 1535 fields and pricing_condition_type_cde to p_insert_tois_rec, p_extract_billings, p_extract_deliveries, p_extract_backlog
*      08/29/2011 A. Orbeta   Add planned_goods_issue_dt as part of 1535 changes.
*      01/04/2011 M. Feenstra Add SCHEDULE_LINE_CATEGORY_CDE and INITIAL_REQUEST_DT.
*      01/10/2011 M. Feenstra Add CUSTOMER_ON_CREDIT_HOLD_DATE and CUSTOMER_OFF_CREDIT_HOLD_DATE.
*      03/22/2012 Kumar Emany Modified p_extract_deliveries to exclude ZVEN records
*      04/02/2012 M. Feenstra Added MATERIAL_AVAILABILITY_DT to ORDER_ITEM_OPEN.
*      06/12/2012 M. Feenstra Added INITIAL_REQUEST_QTY and MATERIAL_AVAILABILITY_DT.
*      11/05/2012 Kumar Emany Modified p_insert_tois_rec, p_extract_billings, p_extract_deliveries, p_extract_backlog
*                             Proceudres to add BILLING_TYPE_CDE, CUST_PUR_ORD_LINE_ITEM_NBR_ID, EXPEDITE_INDICATOR_CDE,
*                             EXPEDITE_STATUS_DESC, SAP_DELIVERY_TYPE_CDE, SHIPMENT_NUMBER_ID Columns for 2012 Q1 Enhancements
* 1.47 02/25/2013 A. Orbeta   Add logic to include 'LP' and 'LU' SBMT_SALES_STAT_CATEGORY_CDE for backlog.
* 1.48 05/17/2013 Reddi       Added column 'MODIFIED_CUSTOMER_REQUEST_DT' to Delivery ScoreCard
* 1.49 09/03/2013 Reddi       Added column 'CUSTOMER_REQUESTED_EXPEDITE_DT' to Delivery ScoreCard
***********************************************************************************************************
*/

PROCEDURE p_extract_scd_data(vin_batch_id   IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                             vic_org_id     IN TEMP_ORDER_ITEM_SHIPMENT.SALES_ORGANIZATION_ID%TYPE,
                             vin_commit_cnt IN NUMBER,
                             vioc_org_code  IN OUT VARCHAR2,
                             vion_result    IN OUT NUMBER);

END PKG_EXTRACT_ADR43;
/



CREATE OR REPLACE PACKAGE BODY SCD_SOURCE.PKG_EXTRACT_ADR43
AS

 tois                       TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
 vgc_job_id                 TEMP_ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE;
 vgn_batch_id               TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE;
 vgn_hierarchy_customer_ind TEMP_ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_IND%TYPE;
 vgc_oi_sl_ind              DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE := NULL;
 vgc_SCHEDULE_LINE_NBR      SCORECARD_HOLD_ORDERS.SCHEDULE_LINE_NBR%TYPE;
 New_Exception EXCEPTION;

 TYPE CommonFldsType IS RECORD(
   REPORTING_ORGANIZATION_ID ADR43_BILLINGS.REPORTING_ORGANIZATION_ID%TYPE,
   ORDER_NBR                 ADR43_BILLINGS.ORDER_NBR%TYPE,
   ORDER_ITEM_NBR            ADR43_BILLINGS.ORDER_ITEM_NBR%TYPE,
   SCHEDULE_LINE_NBR         ADR43_BILLINGS.SCHEDULE_LINE_NBR%TYPE,
   DELIVERY_BLOCK_CDE        ADR43_BILLINGS.DELIVERY_BLOCK_CDE%TYPE,
   CREDIT_CHECK_STATUS_CDE   ADR43_BILLINGS.CREDIT_CHECK_STATUS_CDE%TYPE,
   DATA_PROCESSED_DT         ADR43_BILLINGS.DATA_PROCESSED_DT%TYPE,
   DATA_SOURCE_DESC          ADR43_BILLINGS.DATA_SOURCE_DESC%TYPE);

 adr43Comm CommonFldsType;

  /************************************************************************
  * Procedure  : p_create_param_local_rec
  * Description: Create the control record in delivery_parameter_local
  *     table for shipments and opens.
  ************************************************************************/

  PROCEDURE p_create_param_local_rec(vin_batch_id IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                                     vic_scd_org  IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                                     vion_result  IN OUT NUMBER) IS

    vlc_ships DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;
    vlc_opens DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;
    vln_cnt   NUMBER := 0;

  BEGIN

    vion_result := 0;

    -- get the original F82? control record
    SELECT DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '01',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '02',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '03',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '04',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '05',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '06',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '07',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '08',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '09',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '10',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '11',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000') ||
           DECODE(SUBSTR(SBMT_PROCESS_DT, 5, 2),
                  '12',
                  SBMT_SHIPMENT_TRANS_S0_CNT,
                  '0000000000'),
           DECODE(SBMT_BACKLOG_TRANS_B0_CNT,
                  NULL,
                  '0000000000',
                  SBMT_BACKLOG_TRANS_B0_CNT)
      INTO vlc_ships, vlc_opens
      FROM DAF.DAF00043_CTLS_V
     WHERE batch_id = vin_batch_id;

    -- create control record for shipment
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

  END p_create_param_local_rec;

  /************************************************************************
  * Procedure  : p_ins_scd_hold_orders_rec
  * Description: Insert/Update record in scorecard_hold_orders table.
    ************************************************************************/

  PROCEDURE p_ins_scd_hold_orders_rec(vion_result IN OUT NUMBER) IS

    vln_cnt                       NUMBER := 0;
    vld_TEMP_HOLD_ON_DATE         TEMP_ORDER_ITEM_SHIPMENT.TEMP_HOLD_ON_DATE%TYPE;
    vld_SCHED_ON_CREDIT_HOLD_DATE TEMP_ORDER_ITEM_SHIPMENT.SCHEDULE_ON_CREDIT_HOLD_DATE%TYPE;
    vlc_DELIVERY_BLOCK_CDE        TEMP_ORDER_ITEM_SHIPMENT.DELIVERY_BLOCK_CDE%TYPE := NULL;
    vlc_CREDIT_CHECK_STATUS_CDE   TEMP_ORDER_ITEM_SHIPMENT.CREDIT_CHECK_STATUS_CDE%TYPE := NULL;

  BEGIN

    vion_result := 0;
    IF vgc_oi_sl_ind = 'I' THEN
      vgc_SCHEDULE_LINE_NBR := '*';
    ELSE
      vgc_SCHEDULE_LINE_NBR := adr43Comm.SCHEDULE_LINE_NBR;
    END IF;

    BEGIN
      SELECT schedule_on_credit_hold_date,
             temp_hold_on_date,
             delivery_block_cde,
             credit_check_status_cde
        INTO vld_SCHED_ON_CREDIT_HOLD_DATE,
             vld_TEMP_HOLD_ON_DATE,
             vlc_DELIVERY_BLOCK_CDE,
             vlc_CREDIT_CHECK_STATUS_CDE
        FROM scorecard_hold_orders
       WHERE REPORTING_ORGANIZATION_ID =
             adr43Comm.REPORTING_ORGANIZATION_ID
         AND ORDER_NBR = adr43Comm.ORDER_NBR
         AND ORDER_ITEM_NBR = adr43Comm.ORDER_ITEM_NBR
         AND SCHEDULE_LINE_NBR = vgc_SCHEDULE_LINE_NBR;
      vln_cnt := 1;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vln_cnt := 0;
      WHEN OTHERS THEN
        vion_result := SQLCODE;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('p_ins_scd_hold_orders_rec - ' || vgc_job_id ||
                             ' BATCH ID=' || vgn_batch_id);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
        RETURN;
    END;

    IF vln_cnt = 0 THEN
      IF adr43Comm.DELIVERY_BLOCK_CDE IS NOT NULL AND
         adr43Comm.DELIVERY_BLOCK_CDE != 'CH' THEN
        tois.TEMP_HOLD_ON_DATE := adr43Comm.DATA_PROCESSED_DT;
      END IF;

      IF adr43Comm.DELIVERY_BLOCK_CDE = 'CH' OR
         adr43Comm.CREDIT_CHECK_STATUS_CDE IN ('B', 'C') THEN
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE := adr43Comm.DATA_PROCESSED_DT;
      END IF;

      IF tois.TEMP_HOLD_ON_DATE IS NULL AND
         tois.SCHEDULE_ON_CREDIT_HOLD_DATE IS NULL THEN
        RETURN;
      END IF;

      INSERT INTO SCORECARD_HOLD_ORDERS
        (REPORTING_ORGANIZATION_ID,
         ORDER_NBR,
         ORDER_ITEM_NBR,
         SCHEDULE_LINE_NBR,
         DELIVERY_BLOCK_CDE,
         CREDIT_CHECK_STATUS_CDE,
         SCHEDULE_ON_CREDIT_HOLD_DATE,
         TEMP_HOLD_ON_DATE,
         DML_TS,
         DML_USER_ID)
      VALUES
        (adr43Comm.REPORTING_ORGANIZATION_ID,
         adr43Comm.ORDER_NBR,
         adr43Comm.ORDER_ITEM_NBR,
         vgc_SCHEDULE_LINE_NBR,
         adr43Comm.DELIVERY_BLOCK_CDE,
         adr43Comm.CREDIT_CHECK_STATUS_CDE,
         tois.SCHEDULE_ON_CREDIT_HOLD_DATE,
         tois.TEMP_HOLD_ON_DATE,
         SYSDATE,
         vgc_job_id);
    ELSE
      tois.SCHEDULE_ON_CREDIT_HOLD_DATE := vld_SCHED_ON_CREDIT_HOLD_DATE;
      tois.TEMP_HOLD_ON_DATE            := vld_TEMP_HOLD_ON_DATE;

      IF vld_TEMP_HOLD_ON_DATE IS NOT NULL AND
         (adr43Comm.DELIVERY_BLOCK_CDE IS NULL OR
         adr43Comm.DELIVERY_BLOCK_CDE = 'CH') THEN
        tois.TEMP_HOLD_OFF_DATE := adr43Comm.DATA_PROCESSED_DT;
      END IF;

      IF vld_SCHED_ON_CREDIT_HOLD_DATE IS NOT NULL THEN
        IF INSTR(adr43Comm.DATA_SOURCE_DESC, 'SAP') = 0 -- non-SAP
           AND (adr43Comm.DELIVERY_BLOCK_CDE != 'CH' OR
                adr43Comm.DELIVERY_BLOCK_CDE IS NULL) THEN
          tois.SCHEDULE_OFF_CREDIT_HOLD_DATE := adr43Comm.DATA_PROCESSED_DT;
        ELSE
          -- for SAP
          IF (vlc_DELIVERY_BLOCK_CDE = 'CH' AND
             (adr43Comm.DELIVERY_BLOCK_CDE != 'CH' OR
             adr43Comm.DELIVERY_BLOCK_CDE IS NULL)) OR
             (vlc_CREDIT_CHECK_STATUS_CDE IN ('B', 'C') AND
             (adr43Comm.CREDIT_CHECK_STATUS_CDE IS NULL OR
             adr43Comm.CREDIT_CHECK_STATUS_CDE NOT IN ('B', 'C'))) THEN
            tois.SCHEDULE_OFF_CREDIT_HOLD_DATE := adr43Comm.DATA_PROCESSED_DT;
          END IF;
        END IF;
      END IF;

      IF tois.TEMP_HOLD_OFF_DATE IS NULL AND
         tois.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NULL THEN
        RETURN;
      END IF;

      IF adr43Comm.DELIVERY_BLOCK_CDE IS NULL THEN
        NULL;
      ELSE
        vlc_DELIVERY_BLOCK_CDE := adr43Comm.DELIVERY_BLOCK_CDE;
      END IF;

      IF adr43Comm.CREDIT_CHECK_STATUS_CDE IS NULL OR
         adr43Comm.CREDIT_CHECK_STATUS_CDE NOT IN ('B', 'C') THEN
        NULL;
      ELSE
        vlc_CREDIT_CHECK_STATUS_CDE := adr43Comm.CREDIT_CHECK_STATUS_CDE;
      END IF;

      UPDATE SCORECARD_HOLD_ORDERS
         SET DELIVERY_BLOCK_CDE            = vlc_DELIVERY_BLOCK_CDE,
             CREDIT_CHECK_STATUS_CDE       = vlc_CREDIT_CHECK_STATUS_CDE,
             SCHEDULE_OFF_CREDIT_HOLD_DATE = tois.SCHEDULE_OFF_CREDIT_HOLD_DATE,
             TEMP_HOLD_OFF_DATE            = tois.TEMP_HOLD_OFF_DATE,
             DML_TS                        = SYSDATE,
             DML_USER_ID                   = vgc_job_id
       WHERE REPORTING_ORGANIZATION_ID =
             adr43Comm.REPORTING_ORGANIZATION_ID
         AND ORDER_NBR = adr43Comm.ORDER_NBR
         AND ORDER_ITEM_NBR = adr43Comm.ORDER_ITEM_NBR
         AND SCHEDULE_LINE_NBR = vgc_SCHEDULE_LINE_NBR;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_ins_scd_hold_orders_rec - ' || vgc_job_id ||
                           ' BATCH ID=' || vgn_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_ins_scd_hold_orders_rec;

  /************************************************************************
  * Procedure  : p_get_scd_hold_orders_rec
  * Description: Get record from scorecard_hold_orders table.
  ************************************************************************/

  PROCEDURE p_get_scd_hold_orders_rec(vion_result IN OUT NUMBER) IS

    vld_SCHED_ON_CREDIT_HOLD_DATE  DATE;
    vld_TEMP_HOLD_ON_DATE          DATE;
    vld_SCHED_OFF_CREDIT_HOLD_DATE DATE;
    vld_TEMP_HOLD_OFF_DATE         DATE;
    vlc_DELIVERY_BLOCK_CDE         SCORECARD_HOLD_ORDERS.DELIVERY_BLOCK_CDE%TYPE;
    vlc_CREDIT_CHECK_STATUS_CDE    SCORECARD_HOLD_ORDERS.CREDIT_CHECK_STATUS_CDE%TYPE;

  BEGIN

    vion_result := 0;

    IF vgc_oi_sl_ind = 'I' THEN
      vgc_SCHEDULE_LINE_NBR := '*';
    ELSE
      vgc_SCHEDULE_LINE_NBR := adr43Comm.SCHEDULE_LINE_NBR;
    END IF;

    SELECT SCHEDULE_OFF_CREDIT_HOLD_DATE,
           SCHEDULE_ON_CREDIT_HOLD_DATE,
           TEMP_HOLD_ON_DATE,
           TEMP_HOLD_OFF_DATE,
           DELIVERY_BLOCK_CDE,
           CREDIT_CHECK_STATUS_CDE
      INTO vld_SCHED_OFF_CREDIT_HOLD_DATE,
           vld_SCHED_ON_CREDIT_HOLD_DATE,
           vld_TEMP_HOLD_ON_DATE,
           vld_TEMP_HOLD_OFF_DATE,
           vlc_DELIVERY_BLOCK_CDE,
           vlc_CREDIT_CHECK_STATUS_CDE
      FROM SCORECARD_HOLD_ORDERS
     WHERE REPORTING_ORGANIZATION_ID = adr43Comm.REPORTING_ORGANIZATION_ID
       AND ORDER_NBR = adr43Comm.ORDER_NBR
       AND ORDER_ITEM_NBR = adr43Comm.ORDER_ITEM_NBR
       AND SCHEDULE_LINE_NBR = vgc_SCHEDULE_LINE_NBR;

    IF SQL%FOUND THEN
      tois.SCHEDULE_ON_CREDIT_HOLD_DATE := vld_SCHED_ON_CREDIT_HOLD_DATE;
      tois.TEMP_HOLD_ON_DATE            := vld_TEMP_HOLD_ON_DATE;
      tois.DELIVERY_BLOCK_CDE           := vlc_DELIVERY_BLOCK_CDE;
      tois.CREDIT_CHECK_STATUS_CDE      := vlc_CREDIT_CHECK_STATUS_CDE;

      IF vld_SCHED_ON_CREDIT_HOLD_DATE IS NOT NULL AND
         vld_SCHED_OFF_CREDIT_HOLD_DATE IS NULL THEN
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE := adr43Comm.DATA_PROCESSED_DT;
      ELSE
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE := vld_SCHED_OFF_CREDIT_HOLD_DATE;
      END IF;

      IF vld_TEMP_HOLD_ON_DATE IS NOT NULL AND
         vld_TEMP_HOLD_OFF_DATE IS NULL THEN
        tois.TEMP_HOLD_OFF_DATE := adr43Comm.DATA_PROCESSED_DT;
      ELSE
        tois.TEMP_HOLD_OFF_DATE := vld_TEMP_HOLD_OFF_DATE;
      END IF;
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      NULL;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_ins_scd_hold_orders_rec - ' || vgc_job_id ||
                           ' BATCH ID=' || vgn_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_get_scd_hold_orders_rec;

  /************************************************************************
  * Procedure  : p_get_data_src_id
  * Description: Get data source id AND hierarchy_cust_ind from ADR43_* table.
  ************************************************************************/

  PROCEDURE p_get_data_src_id(vin_batch_id      IN NUMBER,
                              vion_data_src_id  IN OUT NUMBER,
                              von_hier_cust_ind OUT NUMBER,
                              von_s1_ind        OUT NUMBER,
                              vion_result       IN OUT NUMBER) IS

  BEGIN
    SELECT TO_CHAR(DATA_SRC_ID), HIERARCHY_CUSTOMER_IND, S1_IND
      INTO vion_data_src_id, von_hier_cust_ind, von_s1_ind
      FROM ADR43_BILLINGS a, COSTED_ADR43_SUBMISSIONS b
     WHERE BATCH_ID = vin_batch_id
       AND b.data_source_id = a.data_src_id
       AND b.source_id = a.source_id
       AND b.expiration_dt IS NULL
       AND ROWNUM <= 1;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT TO_CHAR(DATA_SRC_ID), HIERARCHY_CUSTOMER_IND, S1_IND
          INTO vion_data_src_id, von_hier_cust_ind, von_s1_ind
          FROM ADR43_BACKLOGS a, COSTED_ADR43_SUBMISSIONS b
         WHERE BATCH_ID = vin_batch_id
           AND b.data_source_id = a.data_src_id
           AND b.source_id = a.source_id
           AND b.expiration_dt IS NULL
           AND ROWNUM <= 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            SELECT TO_CHAR(DATA_SRC_ID), HIERARCHY_CUSTOMER_IND, S1_IND
              INTO vion_data_src_id, von_hier_cust_ind, von_s1_ind
              FROM ADR43_DELIVERIES a, COSTED_ADR43_SUBMISSIONS b
             WHERE BATCH_ID = vin_batch_id
               AND b.data_source_id = a.data_src_id
               AND b.source_id = a.source_id
               AND b.expiration_dt IS NULL
               AND ROWNUM <= 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              vion_result := SQLCODE;
              ROLLBACK;
              DBMS_OUTPUT.PUT_LINE('p_get_data_src_id - ' || vgc_job_id ||
                                   ' BATCH ID=' || vgn_batch_id);
              DBMS_OUTPUT.PUT_LINE('SQL ERROR: Data Source ID could not be determine.');
            WHEN OTHERS THEN
              vion_result := SQLCODE;
              ROLLBACK;
              DBMS_OUTPUT.PUT_LINE('p_get_data_src_id3 - ' || vgc_job_id ||
                                   ' BATCH ID=' || vgn_batch_id);
              DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vion_result));
          END;
        WHEN OTHERS THEN
          vion_result := SQLCODE;
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('p_get_data_src_id1 - ' || vgc_job_id ||
                               ' BATCH ID=' || vgn_batch_id);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vion_result));
      END;
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_get_data_src_id2 - ' || vgc_job_id ||
                           ' BATCH ID=' || vgn_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vion_result));

  END p_get_data_src_id;

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
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       PURCHASE_BY_ACCOUNT_BASE,
       SHIP_TO_ACCOUNT_SUFFIX,
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
       A_TERRITORY_NBR,
       CUSTOMER_REFERENCE_PART_NBR,
       SCHEDULE_ON_CREDIT_HOLD_DATE,
       SCHEDULE_OFF_CREDIT_HOLD_DATE,
       CUSTOMER_CREDIT_HOLD_IND,
       CUSTOMER_ON_CREDIT_HOLD_DATE,
       CUSTOMER_OFF_CREDIT_HOLD_DATE,
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
       SOLD_TO_CUSTOMER_ID,
       INVOICE_NBR,
       DELIVERY_BLOCK_CDE,
       CREDIT_CHECK_STATUS_CDE,
       SALES_ORGANIZATION_ID,
       DISTRIBUTION_CHANNEL_CDE,
       ORDER_DIVISION_CDE,
       ITEM_DIVISION_CDE,
       MATL_ACCOUNT_ASGN_GRP_CDE,
       DATA_SOURCE_DESC,
       BATCH_ID,
       PRIME_WORLDWIDE_CUSTOMER_ID,
       SALES_DOCUMENT_TYPE_CDE,
       MATERIAL_TYPE_CDE,
       DROP_SHIPMENT_IND,
       SALES_OFFICE_CDE,
       SALES_GROUP_CDE,
       SBMT_PART_PRCR_SRC_ORG_ID,
       HIERARCHY_CUSTOMER_IND,
       HIERARCHY_CUSTOMER_ORG_ID,
       HIERARCHY_CUSTOMER_BASE_ID,
       HIERARCHY_CUSTOMER_SUFX_ID,
       PART_UM,
       SBMT_ORIGINAL_SCHEDULE_DT,
       SBMT_CURRENT_SCHEDULE_DT,
       SBMT_SOLD_TO_CUSTOMER_ID,
       TYCO_CTRL_DELIVERY_HOLD_ON_DT,
       TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
       TYCO_CTRL_DELIVERY_BLOCK_CDE,
       PICK_PACK_WORK_DAYS_QTY,
       LOADING_NBR_OF_WORK_DAYS_QTY,
       TRSP_LEAD_TIME_DAYS_QTY,
       TRANSIT_TIME_DAYS_QTY,
       DELIVERY_ITEM_CATEGORY_CDE,
       DELIVERY_IN_PROCESS_QTY,
       ORDER_HEADER_BILLING_BLOCK_CDE,
       ITEM_BILLING_BLOCK_CDE,
       FIXED_DATE_QUANTITY_IND,
       SAP_BILL_TO_CUSTOMER_ID,
       DELIVERY_DOCUMENT_NBR_ID,
       DELIVERY_DOCUMENT_ITEM_NBR_ID,
       MISC_LOCAL_FLAG_CDE_1,
       MISC_LOCAL_CDE_1,
       MISC_LOCAL_CDE_2,
       MISC_LOCAL_CDE_3,
       CUSTOMER_DATE_BASIS_CDE,
       ACTUAL_DATE_BASIS_CDE,
       SHIP_DATE_DETERMINATION_CDE,
       CUST_ORD_REQ_RESET_REASON_CDE,
       CUST_ORD_REQ_RESET_REASON_DT,
       CUSTOMER_ORDER_EDI_TYPE_CDE,
       ULTIMATE_END_CUSTOMER_ID,
       ULTIMATE_END_CUST_ACCT_GRP_CDE,
       MRP_GROUP_CDE,
       COMPLETE_DELIVERY_IND,
       PART_KEY_ID,
       PLANNED_INSTALLATION_CMPL_DT,
       SOURCE_ID,
       DATA_SRC_ID,
       DISTR_SHIP_WHEN_AVAIL_IND,
       COSTED_SALES_EXCLUSION_CDE,
       SAP_PROFIT_CENTER_CDE,
       STORAGE_LOCATION_ID,
       SALES_TERRITORY_CDE,
       REQUESTED_ON_DOCK_DT,
       SCHEDULED_ON_DOCK_DT,
       SHIP_TO_CUSTOMER_KEY_ID,
       SOLD_TO_CUSTOMER_KEY_ID,
       HIERARCHY_CUSTOMER_KEY_ID,
       ULTIMATE_END_CUSTOMER_KEY_ID,
       BILL_OF_LADING_ID,
       SBMT_FWD_AGENT_VENDOR_ID,
       FWD_AGENT_VENDOR_KEY_ID,
       INTL_COMMERCIAL_TERMS_CDE,
       INTL_CMCL_TERM_ADDITIONAL_DESC,
       SHIPPING_TRSP_CATEGORY_CDE,
       HEADER_CUST_ORDER_RECEIVED_DT,
       SBMT_SCHD_AGR_CANCEL_IND_CDE,
       SCHD_AGR_CANCEL_INDICATOR_CDE,
       CONSUMED_SA_ORDER_ITEM_NBR_ID,
       CONSUMED_SA_ORDER_NUMBER_ID,
       SBMT_SB_CNSN_ITRST_PRTNCUST_ID,
       SB_CNSN_ITRST_PRTN_CUST_KEY_ID,
       SHIPPING_CONDITIONS_CDE,
       SBMT_ZI_CNSN_STK_PRTN_CUST_ID,
       ZI_CNSN_STK_PRTN_CUST_KEY_ID,
       SBMT_SALES_TERRITORY_CDE,
       SBMT_SALES_OFFICE_CDE,
       SBMT_SALES_GROUP_CDE,
       SCHEDULE_LINE_NBR,
       SBMT_SCHEDULE_LINE_NBR,
       TRSP_MGE_TRANSIT_TIME_DAYS_QTY,
       DISCONTINUED_OPERATIONS_CDE,
       ACTUAL_SHIP_FROM_BUILDING_ID,
       SBMT_FCST_PP_CUST_ACCT_NBR,
       FCST_PRM_PRTN_CUSTOMER_KEY_ID,
       FCST_PRM_PRTN_CUST_ACCT_NBR,
       FCST_PRM_PRTN_ACCT_GROUP_CDE,
       ORDER_RECEIVED_DT,
       ORDER_CREATED_BY_NTWK_USER_ID,
       DELIVERY_DOC_CREATION_DT,
       DELIVERY_DOC_CREATION_TM,
       DLVR_DOC_CRET_BY_NTWK_USER_ID,
       PRICING_CONDITION_TYPE_CDE,
       PLANNED_GOODS_ISSUE_DT,
       SCHEDULE_LINE_CATEGORY_CDE,
       INITIAL_REQUEST_DT,
       INITIAL_REQUEST_QTY,
       DOC_ISO_CURRENCY_CDE,
       DOC_CURRENCY_AMT,
       MATERIAL_AVAILABILITY_DT,
       CUST_PUR_ORD_LINE_ITEM_NBR_ID, -- Kumar 11/06/2012 Added below 6 Columns for 2012 Q1 Enhancements
       BILLING_TYPE_CDE,
       SAP_DELIVERY_TYPE_CDE,
       SHIPMENT_NUMBER_ID,
       EXPEDITE_INDICATOR_CDE,
       EXPEDITE_STATUS_DESC,
       MODIFIED_CUSTOMER_REQUEST_DT,
       CUSTOMER_REQUESTED_EXPEDITE_DT) -- RB
    VALUES
      (TEMP_SHIPMENT_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       tois.ORGANIZATION_KEY_ID,
       tois.AMP_ORDER_NBR,
       tois.ORDER_ITEM_NBR,
       tois.SHIPMENT_ID,
       tois.PURCHASE_BY_ACCOUNT_BASE,
       tois.SHIP_TO_ACCOUNT_SUFFIX,
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
       tois.A_TERRITORY_NBR,
       tois.CUSTOMER_REFERENCE_PART_NBR,
       tois.SCHEDULE_ON_CREDIT_HOLD_DATE,
       tois.SCHEDULE_OFF_CREDIT_HOLD_DATE,
       tois.CUSTOMER_CREDIT_HOLD_IND,
       tois.CUSTOMER_ON_CREDIT_HOLD_DATE,
       tois.CUSTOMER_OFF_CREDIT_HOLD_DATE,
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
       tois.SOLD_TO_CUSTOMER_ID,
       tois.INVOICE_NBR,
       tois.DELIVERY_BLOCK_CDE,
       tois.CREDIT_CHECK_STATUS_CDE,
       tois.SALES_ORGANIZATION_ID,
       tois.DISTRIBUTION_CHANNEL_CDE,
       tois.ORDER_DIVISION_CDE,
       tois.ITEM_DIVISION_CDE,
       tois.MATL_ACCOUNT_ASGN_GRP_CDE,
       tois.DATA_SOURCE_DESC,
       tois.BATCH_ID,
       tois.PRIME_WORLDWIDE_CUSTOMER_ID,
       tois.SALES_DOCUMENT_TYPE_CDE,
       tois.MATERIAL_TYPE_CDE,
       tois.DROP_SHIPMENT_IND,
       tois.SALES_OFFICE_CDE,
       tois.SALES_GROUP_CDE,
       tois.SBMT_PART_PRCR_SRC_ORG_ID,
       tois.HIERARCHY_CUSTOMER_IND,
       tois.HIERARCHY_CUSTOMER_ORG_ID,
       tois.HIERARCHY_CUSTOMER_BASE_ID,
       tois.HIERARCHY_CUSTOMER_SUFX_ID,
       tois.PART_UM,
       tois.SBMT_ORIGINAL_SCHEDULE_DT,
       tois.SBMT_CURRENT_SCHEDULE_DT,
       tois.SBMT_SOLD_TO_CUSTOMER_ID,
       tois.TYCO_CTRL_DELIVERY_HOLD_ON_DT,
       tois.TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
       tois.TYCO_CTRL_DELIVERY_BLOCK_CDE,
       tois.PICK_PACK_WORK_DAYS_QTY,
       tois.LOADING_NBR_OF_WORK_DAYS_QTY,
       tois.TRSP_LEAD_TIME_DAYS_QTY,
       tois.TRANSIT_TIME_DAYS_QTY,
       tois.DELIVERY_ITEM_CATEGORY_CDE,
       tois.DELIVERY_IN_PROCESS_QTY,
       tois.ORDER_HEADER_BILLING_BLOCK_CDE,
       tois.ITEM_BILLING_BLOCK_CDE,
       tois.FIXED_DATE_QUANTITY_IND,
       tois.SAP_BILL_TO_CUSTOMER_ID,
       tois.DELIVERY_DOCUMENT_NBR_ID,
       tois.DELIVERY_DOCUMENT_ITEM_NBR_ID,
       tois.MISC_LOCAL_FLAG_CDE_1,
       tois.MISC_LOCAL_CDE_1,
       tois.MISC_LOCAL_CDE_2,
       tois.MISC_LOCAL_CDE_3,
       tois.CUSTOMER_DATE_BASIS_CDE,
       tois.ACTUAL_DATE_BASIS_CDE,
       tois.SHIP_DATE_DETERMINATION_CDE,
       tois.CUST_ORD_REQ_RESET_REASON_CDE,
       tois.CUST_ORD_REQ_RESET_REASON_DT,
       tois.CUSTOMER_ORDER_EDI_TYPE_CDE,
       tois.ULTIMATE_END_CUSTOMER_ID,
       tois.ULTIMATE_END_CUST_ACCT_GRP_CDE,
       tois.MRP_GROUP_CDE,
       tois.COMPLETE_DELIVERY_IND,
       tois.PART_KEY_ID,
       tois.PLANNED_INSTALLATION_CMPL_DT,
       tois.SOURCE_ID,
       tois.DATA_SRC_ID,
       tois.DISTR_SHIP_WHEN_AVAIL_IND,
       NVL(tois.COSTED_SALES_EXCLUSION_CDE, 0),
       tois.SAP_PROFIT_CENTER_CDE,
       tois.STORAGE_LOCATION_ID,
       tois.SALES_TERRITORY_CDE,
       tois.REQUESTED_ON_DOCK_DT,
       tois.SCHEDULED_ON_DOCK_DT,
       tois.SHIP_TO_CUSTOMER_KEY_ID,
       tois.SOLD_TO_CUSTOMER_KEY_ID,
       tois.HIERARCHY_CUSTOMER_KEY_ID,
       tois.ULTIMATE_END_CUSTOMER_KEY_ID,
       tois.BILL_OF_LADING_ID,
       tois.SBMT_FWD_AGENT_VENDOR_ID,
       tois.FWD_AGENT_VENDOR_KEY_ID,
       tois.INTL_COMMERCIAL_TERMS_CDE,
       tois.INTL_CMCL_TERM_ADDITIONAL_DESC,
       tois.SHIPPING_TRSP_CATEGORY_CDE,
       tois.HEADER_CUST_ORDER_RECEIVED_DT,
       tois.SBMT_SCHD_AGR_CANCEL_IND_CDE,
       tois.SCHD_AGR_CANCEL_INDICATOR_CDE,
       tois.CONSUMED_SA_ORDER_ITEM_NBR_ID,
       tois.CONSUMED_SA_ORDER_NUMBER_ID,
       tois.SBMT_SB_CNSN_ITRST_PRTNCUST_ID,
       tois.SB_CNSN_ITRST_PRTN_CUST_KEY_ID,
       tois.SHIPPING_CONDITIONS_CDE,
       tois.SBMT_ZI_CNSN_STK_PRTN_CUST_ID,
       tois.ZI_CNSN_STK_PRTN_CUST_KEY_ID,
       tois.SBMT_SALES_TERRITORY_CDE,
       tois.SBMT_SALES_OFFICE_CDE,
       tois.SBMT_SALES_GROUP_CDE,
       tois.SCHEDULE_LINE_NBR,
       tois.SBMT_SCHEDULE_LINE_NBR,
       tois.TRSP_MGE_TRANSIT_TIME_DAYS_QTY,
       tois.DISCONTINUED_OPERATIONS_CDE,
       tois.ACTUAL_SHIP_FROM_BUILDING_ID,
       tois.SBMT_FCST_PP_CUST_ACCT_NBR,
       tois.FCST_PRM_PRTN_CUSTOMER_KEY_ID,
       tois.FCST_PRM_PRTN_CUST_ACCT_NBR,
       tois.FCST_PRM_PRTN_ACCT_GROUP_CDE,
       tois.ORDER_RECEIVED_DT,
       tois.ORDER_CREATED_BY_NTWK_USER_ID,
       tois.DELIVERY_DOC_CREATION_DT,
       tois.DELIVERY_DOC_CREATION_TM,
       tois.DLVR_DOC_CRET_BY_NTWK_USER_ID,
       tois.PRICING_CONDITION_TYPE_CDE,
       tois.PLANNED_GOODS_ISSUE_DT,
       tois.SCHEDULE_LINE_CATEGORY_CDE,
       tois.INITIAL_REQUEST_DT,
       tois.INITIAL_REQUEST_QTY,
       tois.DOC_ISO_CURRENCY_CDE,
       tois.DOC_CURRENCY_AMT,
       tois.MATERIAL_AVAILABILITY_DT,
       tois.CUST_PUR_ORD_LINE_ITEM_NBR_ID,
       tois.BILLING_TYPE_CDE,
       tois.SAP_DELIVERY_TYPE_CDE,
       tois.SHIPMENT_NUMBER_ID,
       tois.EXPEDITE_INDICATOR_CDE,
       tois.EXPEDITE_STATUS_DESC,
       tois.MODIFIED_CUSTOMER_REQUEST_DT,
       tois.CUSTOMER_REQUESTED_EXPEDITE_DT);  -- RB

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      -- ROLLBACK;
    -- DBMS_OUTPUT.PUT_LINE('P_INSERT_TOIS_REC - '||vgc_job_id||' BATCH ID='||vgn_batch_id||' RECORD_BATCH ID='||adr43.BATCH_RECORD_ID);
    -- DBMS_OUTPUT.PUT_LINE('SQL ERROR:  '|| SQLERRM(vion_result));

  END p_insert_tois_rec;

  /************************************************************************
  * Procedure  : p_extract_billings
  * Description: Extract billings records and populate into temp_order
  *     _item_shipment table.
  ************************************************************************/

  PROCEDURE p_extract_billings(vin_batch_id   IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                               vin_commit_cnt NUMBER,
                               vion_result    IN OUT NUMBER) IS

    CURSOR cur_billings IS
      SELECT *
        FROM ADR43_BILLINGS
       WHERE BATCH_ID = vin_batch_id
         AND SALES_TRANSACTION_TYPE_CDE = 'S0'
         AND (NVL(SALES_DOC_TYPE_CDE, 'x') != 'V' AND
             NVL(MATERIAL_TYPE_CDE, 'x') != 'ZSPC')
         AND NVL(SBMT_SALES_STAT_CATEGORY_CDE, 'x') NOT IN
             ('MV', 'ZPRJ', 'ZREW')
         AND NVL(RE_BILLED_CDE, 'x') != 'Y'
         AND NVL(BILLING_TYPE_CDE, 'x') != 'IV'
      -- AND NOT (ORGANIZATION_ID IN ('1296','1335','1336','1473') AND DELIVERY_ITEM_CATEGORY_CDE IN ('L2W'))
       ORDER BY REPORTING_ORGANIZATION_ID, PART_KEY_ID;

    vln_commit_cnt           NUMBER := 0;
    vln_nbr_window_days_late TEMP_ORDER_ITEM_SHIPMENT.NBR_WINDOW_DAYS_LATE%TYPE;
    adr43                    ADR43_BILLINGS%ROWTYPE;

  BEGIN

    vion_result := 0;

    BEGIN
      SELECT TO_NUMBER(PARAMETER_FIELD, '99')
        INTO vln_NBR_WINDOW_DAYS_LATE
        FROM DELIVERY_PARAMETER
       WHERE PARAMETER_ID = 'DED359';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vln_nbr_window_days_late := 0;
      WHEN OTHERS THEN
        vion_result := SQLCODE;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS - ' || vgc_job_id ||
                             ' BATCH ID=' || vin_batch_id);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
        RETURN;
    END;

    -- process all billings records
    OPEN cur_billings;
    LOOP
      BEGIN
        FETCH cur_billings
          INTO adr43;
        EXIT WHEN(cur_billings%NOTFOUND);

        tois := NULL;

        -- derive tois.ORGANIZATION_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.ORGANIZATION_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.ORGANIZATION_KEY_ID) THEN
          NULL;
        END IF;

        tois.AMP_ORDER_NBR            := adr43.ORDER_NBR;
        tois.ORDER_ITEM_NBR           := adr43.ORDER_ITEM_NBR;
        tois.SHIPMENT_ID              := adr43.SCHEDULE_LINE_NBR;
        tois.PURCHASE_BY_ACCOUNT_BASE := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID,1,8);
        tois.SHIP_TO_ACCOUNT_SUFFIX   := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID,9,2);

        -- derive tois.ACCOUNTING_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.SHIP_TO_ACCT_ORGANIZATION_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.ACCOUNTING_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.PRODCN_CNTRLR_CODE             := NVL(adr43.PLANNER_CDE, '*');
        tois.ITEM_QUANTITY                  := ROUND(adr43.CUSTOMER_ORDER_ITEM_QTY, 0);
        tois.RESRVN_LEVEL_1                 := 0;
        tois.RESRVN_LEVEL_5                 := 0;
        tois.RESRVN_LEVEL_9                 := 0;
        tois.QUANTITY_RELEASED              := 0;
        tois.QUANTITY_SHIPPED               := ROUND(adr43.SHIPPED_QTY, 0);
        tois.ISO_CURRENCY_CODE_1            := adr43.ORG_TYPE_CO_ISO_CURRENCY_CDE;
        tois.LOCAL_CURRENCY_BILLED_AMOUNT   := adr43.LINE_ITEM_LOCAL_CURRENCY_AMT;
        tois.EXTENDED_BOOK_BILL_AMOUNT      := adr43.LINE_ITEM_US_DOLLAR_AMT;
        tois.UNIT_PRICE                     := 0;
        tois.CUSTOMER_REQUEST_DATE          := adr43.CUSTOMER_REQUEST_DT;
        tois.AMP_SCHEDULE_DATE              := adr43.ORIGINAL_SCHEDULE_DT;
        tois.RELEASE_DATE                   := adr43.SCHEDULE_RELEASED_SHIP_DT;
        tois.AMP_SHIPPED_DATE               := adr43.SHIPMENT_DT;
        tois.NBR_WINDOW_DAYS_EARLY          := adr43.DAYS_ERL_DLVR_WINDOW_QTY;
        tois.REQUESTED_ON_DOCK_DT           := adr43.REQUESTED_ON_DOCK_DT;
        tois.SCHEDULED_ON_DOCK_DT           := adr43.SCHEDULED_ON_DOCK_DT;
        tois.SHIP_TO_CUSTOMER_KEY_ID        := adr43.SHIP_TO_CUSTOMER_KEY_ID;
        tois.SOLD_TO_CUSTOMER_KEY_ID        := adr43.SOLD_TO_CUSTOMER_KEY_ID;
        tois.HIERARCHY_CUSTOMER_KEY_ID      := adr43.HIERARCHY_CUSTOMER_KEY_ID;
        tois.ULTIMATE_END_CUSTOMER_KEY_ID   := adr43.ULTIMATE_END_CUSTOMER_KEY_ID;
        tois.INTL_COMMERCIAL_TERMS_CDE      := adr43.INTL_COMMERCIAL_TERMS_CDE;
        tois.INTL_CMCL_TERM_ADDITIONAL_DESC := adr43.INTL_CMCL_TERM_ADDITIONAL_DESC;
        tois.SHIPPING_TRSP_CATEGORY_CDE     := adr43.SHIPPING_TRSP_CATEGORY_CDE;
        tois.HEADER_CUST_ORDER_RECEIVED_DT  := adr43.HEADER_CUST_ORDER_RECEIVED_DT;
        tois.SBMT_SB_CNSN_ITRST_PRTNCUST_ID := adr43.SBMT_SB_CNSN_ITRST_PRTNCUST_ID;
        tois.SB_CNSN_ITRST_PRTN_CUST_KEY_ID := adr43.SB_CNSN_ITRST_PRTN_CUST_KEY_ID;
        tois.SHIPPING_CONDITIONS_CDE        := adr43.SHIPPING_CONDITIONS_CDE;
        tois.SBMT_ZI_CNSN_STK_PRTN_CUST_ID  := adr43.SBMT_ZI_CNSN_STK_PRTN_CUST_ID;
        tois.ZI_CNSN_STK_PRTN_CUST_KEY_ID   := adr43.ZI_CNSN_STK_PRTN_CUST_KEY_ID;
        tois.SBMT_SALES_TERRITORY_CDE       := adr43.SBMT_SALES_TERRITORY_CDE;
        tois.SBMT_SALES_OFFICE_CDE          := adr43.SBMT_SALES_OFFICE_CDE;
        tois.SBMT_SALES_GROUP_CDE           := adr43.SBMT_SALES_GROUP_CDE;
        tois.SCHEDULE_LINE_NBR              := adr43.SCHEDULE_LINE_NBR;
        tois.SBMT_SCHEDULE_LINE_NBR         := adr43.SBMT_SCHEDULE_LINE_NBR;
        tois.TRSP_MGE_TRANSIT_TIME_DAYS_QTY := adr43.TRSP_MGE_TRANSIT_TIME_DAYS_QTY;

        -- derive tois.NBR_WINDOW_DAYS_LATE
        IF tois.NBR_WINDOW_DAYS_EARLY IS NULL THEN
          IF adr43.JUST_IN_TIME_CUSTOMER_IND = 'Y' OR
             adr43.SBMT_JUST_IN_TIME_CUSTOMER_IND = '03' THEN
            tois.NBR_WINDOW_DAYS_LATE := 0;
          ELSE
            tois.NBR_WINDOW_DAYS_LATE := vln_nbr_window_days_late;
          END IF;
        ELSE
          tois.NBR_WINDOW_DAYS_LATE := 0;
        END IF;

        tois.ACTUAL_SHIP_LOCATION     := NVL(adr43.LOCATION_CDE, '*');
        tois.ACTUAL_SHIP_BUILDING_NBR := NVL(adr43.PLANT_ID, '*');

        -- derive tois.INVENTORY_LOCATION_CODE
        tois.INVENTORY_LOCATION_CODE := '*';

        -- derive tois.INVENTORY_BUILDING_NBR
        tois.INVENTORY_BUILDING_NBR := '*';

        -- derive tois.CONTROLLER_UNIQUENESS_ID
        IF INSTR(adr43.DATA_SOURCE_DESC, 'SAP') > 0 THEN
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.PLANT_ID, '*');
        ELSE
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.INVENTORY_ORGANIZATION_ID, '*');
        END IF;

        tois.ORDER_BOOKING_DATE        := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_RECEIVED_DATE       := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_TYPE_ID             := adr43.SBMT_SALES_STAT_CATEGORY_CDE;
        tois.REGTRD_DATE               := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.REPORTED_AS_OF_DATE       := adr43.DATA_PROCESSED_DT;
        tois.PURCHASE_ORDER_DATE       := adr43.CUSTOMER_PURCHASE_ORDER_DT;
        tois.PURCHASE_ORDER_NBR        := adr43.CUSTOMER_PURCHASE_ORDER_ID;
        tois.PRODCN_CNTLR_EMPLOYEE_NBR := '*';

        -- derive tois.PART_PRCR_SRC_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.PART_PRCR_SRC_ORG_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.PART_PRCR_SRC_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.TEAM_CODE                   := '*';
        tois.STOCK_MAKE_CODE             := NVL(adr43.STOCK_MAKE_CDE, '*');
        tois.PRODUCT_CODE                := NVL(adr43.PRODUCT_CDE, '*');
        tois.PRODUCT_LINE_CODE           := NVL(adr43.PRODUCT_LINE_CDE, '*');
        tois.WW_ACCOUNT_NBR_BASE         := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 1, 8), '*');
        tois.WW_ACCOUNT_NBR_SUFFIX       := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 9, 2), '*');
        tois.A_TERRITORY_NBR             := NVL(adr43.TERRITORY_CDE, '*');
        tois.CUSTOMER_REFERENCE_PART_NBR := adr43.CUSTOMER_PART_NBR;

        -- derive tois.CUSTOMER_CREDIT_HOLD_IND
        --IF adr43.CREDIT_CHECK_STATUS_CDE IN ('B', 'C') THEN
        --  tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
        --END IF;

        -- derive tois.TEMP_HOLD_IND
        IF adr43.DELIVERY_BLOCK_CDE = 'CH' THEN
        --  tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
          NULL;
        ELSIF adr43.DELIVERY_BLOCK_CDE IS NOT NULL THEN
          tois.TEMP_HOLD_IND := 'T';
        END IF;

        -- derive tois.CUSTOMER_TYPE_CODE
        IF adr43.JUST_IN_TIME_CUSTOMER_IND = 'Y' OR
           adr43.SBMT_JUST_IN_TIME_CUSTOMER_IND = '03' THEN
          tois.CUSTOMER_TYPE_CODE := 'J';
        END IF;

        tois.INDUSTRY_CODE                  := NVL(adr43.INDUSTRY_CDE, '*');
        tois.PRODUCT_BUSNS_LINE_ID          := adr43.COMPETENCY_BSNS_CDE;
        tois.PRODUCT_BUSNS_LINE_FNCTN_ID    := NVL(adr43.COMPETENCY_BSNS_FUNC_CDE, '*');
        tois.ZERO_PART_PROD_CODE            := NVL(adr43.ZERO_PART_PRODUCT_CDE, '*');
        tois.CUSTOMER_ACCT_TYPE_CDE         := adr43.TRADE_INTERCO_CDE;
        tois.MFR_ORG_KEY_ID                 := 0;
        tois.MFG_CAMPUS_ID                  := '*';
        tois.MFG_BUILDING_NBR               := '*';
        tois.REMAINING_QTY_TO_SHIP          := ROUND(adr43.REMAINING_TO_SHIP_QTY, 0);
        tois.INDUSTRY_BUSINESS_CODE         := adr43.INDUSTRY_BUSINESS_CDE;
        tois.SBMT_PART_NBR                  := adr43.SBMT_PART_NBR;
        tois.SBMT_CUSTOMER_ACCT_NBR         := adr43.SBMT_SHIP_TO_CUSTOMER_ID;
        tois.PROFIT_CENTER_ABBR_NM          := NVL(adr43.PROFIT_CENTER_ABBR_NM,
                                                   '*');
        tois.BRAND_ID                       := adr43.AQUISITION_FORMAT_ID;
        tois.SCHD_TYCO_MONTH_OF_YEAR_ID     := adr43.SCHD_TYCO_MONTH_OF_YEAR_ID;
        tois.SCHD_TYCO_QUARTER_ID           := adr43.SCHD_TYCO_QUARTER_ID;
        tois.SCHD_TYCO_YEAR_ID              := adr43.SCHD_TYCO_YEAR_ID;
        tois.SOLD_TO_CUSTOMER_ID            := adr43.SOLD_TO_CUSTOMER_ID;
        tois.INVOICE_NBR                    := adr43.INVOICE_NBR;
        tois.DELIVERY_BLOCK_CDE             := adr43.DELIVERY_BLOCK_CDE;
        tois.CREDIT_CHECK_STATUS_CDE        := adr43.CREDIT_CHECK_STATUS_CDE;
        tois.SALES_ORGANIZATION_ID          := adr43.SALES_ORGANIZATION_ID;
        tois.DISTRIBUTION_CHANNEL_CDE       := adr43.DISTRIBUTION_CHANNEL_CDE;
        tois.ORDER_DIVISION_CDE             := adr43.ORDER_DIVISION_CDE;
        tois.ITEM_DIVISION_CDE              := adr43.ITEM_DIVISION_CDE;
        tois.MATL_ACCOUNT_ASGN_GRP_CDE      := adr43.MATL_ACCOUNT_ASGN_GRP_CDE;
        tois.BATCH_ID                       := adr43.BATCH_ID;
        tois.DATA_SOURCE_DESC               := adr43.DATA_SOURCE_DESC;
        tois.PRIME_WORLDWIDE_CUSTOMER_ID    := adr43.PRIME_WORLDWIDE_CUSTOMER_ID;
        tois.SALES_DOCUMENT_TYPE_CDE        := adr43.SALES_DOC_TYPE_CDE;
        tois.MATERIAL_TYPE_CDE              := adr43.MATERIAL_TYPE_CDE;
        tois.DROP_SHIPMENT_IND              := adr43.DROP_SHIPMENT_IND;
        tois.SALES_OFFICE_CDE               := NVL(adr43.SALES_OFFICE_CDE,
                                                   '*');
        tois.SALES_GROUP_CDE                := NVL(adr43.SALES_GROUP_CDE,
                                                   '*');
        tois.SBMT_PART_PRCR_SRC_ORG_ID      := adr43.PART_PRCR_SRC_ORG_ID;
        tois.HIERARCHY_CUSTOMER_IND         := vgn_hierarchy_customer_ind;
        tois.HIERARCHY_CUSTOMER_ORG_ID      := adr43.HIERARCHY_CUSTOMER_ORG_ID;
        tois.HIERARCHY_CUSTOMER_BASE_ID     := adr43.HIERARCHY_CUSTOMER_BASE_ID;
        tois.HIERARCHY_CUSTOMER_SUFX_ID     := adr43.HIERARCHY_CUSTOMER_SUFX_ID;
        tois.PART_UM                        := adr43.UNIT_OF_MEASURE_CDE;
        tois.SBMT_ORIGINAL_SCHEDULE_DT      := adr43.ORIGINAL_SCHEDULE_DT;
        tois.SBMT_CURRENT_SCHEDULE_DT       := adr43.CURRENT_SCHEDULE_DT;
        tois.SBMT_SOLD_TO_CUSTOMER_ID       := adr43.SBMT_SOLD_TO_CUSTOMER_ID;
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE   := adr43.SCHEDULE_ON_CREDIT_HOLD_DT;
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE  := adr43.SCHEDULE_OFF_CREDIT_HOLD_DT;
        tois.TEMP_HOLD_ON_DATE              := adr43.TEMP_HOLD_ON_DT;
        tois.TEMP_HOLD_OFF_DATE             := adr43.TEMP_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_ON_DT  := adr43.TYCO_CTRL_DELIVERY_HOLD_ON_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_OFF_DT := adr43.TYCO_CTRL_DELIVERY_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_BLOCK_CDE   := adr43.TYCO_CTRL_DELIVERY_BLOCK_CDE;
        tois.PICK_PACK_WORK_DAYS_QTY        := adr43.PICK_PACK_WORK_DAYS_QTY;
        tois.LOADING_NBR_OF_WORK_DAYS_QTY   := adr43.LOADING_NBR_OF_WORK_DAYS_QTY;
        tois.TRSP_LEAD_TIME_DAYS_QTY        := adr43.TRSP_LEAD_TIME_DAYS_QTY;
        tois.TRANSIT_TIME_DAYS_QTY          := adr43.TRANSIT_TIME_DAYS_QTY;
        tois.DELIVERY_ITEM_CATEGORY_CDE     := adr43.DELIVERY_ITEM_CATEGORY_CDE;
        tois.FIXED_DATE_QUANTITY_IND        := adr43.FIXED_DATE_QUANTITY_IND;
        tois.SAP_BILL_TO_CUSTOMER_ID        := adr43.SAP_BILL_TO_CUSTOMER_ID;
        tois.DELIVERY_DOCUMENT_NBR_ID       := adr43.DELIVERY_DOCUMENT_NBR_ID;
        tois.DELIVERY_DOCUMENT_ITEM_NBR_ID  := adr43.DELIVERY_DOCUMENT_ITEM_NBR_ID;
        tois.MISC_LOCAL_FLAG_CDE_1          := adr43.MISC_LOCAL_FLAG_CDE_1;
        tois.MISC_LOCAL_CDE_1               := adr43.MISC_LOCAL_CDE_1;
        tois.MISC_LOCAL_CDE_2               := adr43.MISC_LOCAL_CDE_2;
        tois.MISC_LOCAL_CDE_3               := adr43.MISC_LOCAL_CDE_3;
        tois.CUSTOMER_DATE_BASIS_CDE        := adr43.CUSTOMER_DATE_BASIS_CDE;
        tois.ACTUAL_DATE_BASIS_CDE          := adr43.ACTUAL_DATE_BASIS_CDE;
        tois.SHIP_DATE_DETERMINATION_CDE    := adr43.SHIP_DATE_DETERMINATION_CDE;
        tois.CUST_ORD_REQ_RESET_REASON_CDE  := adr43.CUST_ORD_REQ_RESET_REASON_CDE;
        tois.CUST_ORD_REQ_RESET_REASON_DT   := adr43.CUST_ORD_REQ_RESET_REASON_DT;
        tois.CUSTOMER_ORDER_EDI_TYPE_CDE    := adr43.CUSTOMER_ORDER_EDI_TYPE_CDE;
        tois.ULTIMATE_END_CUSTOMER_ID       := adr43.ULTIMATE_END_CUSTOMER_ID;
        tois.ULTIMATE_END_CUST_ACCT_GRP_CDE := adr43.ULTIMATE_END_CUST_ACCT_GRP_CDE;
        tois.MRP_GROUP_CDE                  := NVL(adr43.MRP_GROUP_CDE, '*');
        tois.COMPLETE_DELIVERY_IND          := adr43.COMPLETE_DELIVERY_IND;
        tois.PART_KEY_ID                    := adr43.PART_KEY_ID;
        tois.SOURCE_ID                      := adr43.SOURCE_ID;
        tois.DATA_SRC_ID                    := adr43.DATA_SRC_ID;
        tois.DISTR_SHIP_WHEN_AVAIL_IND      := adr43.DISTR_SHIP_WHEN_AVAIL_IND;
        tois.SAP_PROFIT_CENTER_CDE          := adr43.SAP_PROFIT_CENTER_CDE;
        tois.STORAGE_LOCATION_ID            := adr43.STORAGE_LOCATION_ID;
        tois.SALES_TERRITORY_CDE            := adr43.SALES_TERRITORY_CDE;
        tois.ACTUAL_SHIP_FROM_BUILDING_ID   := adr43.PLANT_ID;

        tois.FCST_PRM_PRTN_CUSTOMER_KEY_ID  := adr43.FCST_PRM_PRTN_CUSTOMER_KEY_ID;
        tois.FCST_PRM_PRTN_CUST_ACCT_NBR    := adr43.FCST_PRM_PRTN_CUST_ACCT_NBR;
        tois.FCST_PRM_PRTN_ACCT_GROUP_CDE   := adr43.FCST_PRM_PRTN_ACCT_GROUP_CDE;

        -- TELAG 1535 Columns
        tois.ORDER_RECEIVED_DT              := adr43.ORDER_RECEIVED_DT;
        tois.ORDER_CREATED_BY_NTWK_USER_ID  := adr43.ORDER_CREATED_BY_NTWK_USER_ID;
        tois.DELIVERY_DOC_CREATION_DT       := adr43.DELIVERY_DOC_CREATION_DT;
        tois.DELIVERY_DOC_CREATION_TM       := adr43.DELIVERY_DOC_CREATION_TM;
        tois.DLVR_DOC_CRET_BY_NTWK_USER_ID  := adr43.DLVR_DOC_CRET_BY_NTWK_USER_ID;
        -- End TELAG 1535

        tois.PRICING_CONDITION_TYPE_CDE     := adr43.PRICING_CONDITION_TYPE_CDE;
        tois.SCHEDULE_LINE_CATEGORY_CDE     := adr43.SCHEDULE_LINE_CATEGORY_CDE;
        tois.INITIAL_REQUEST_DT             := adr43.INITIAL_REQUEST_DT;
        tois.INITIAL_REQUEST_QTY            := adr43.INITIAL_REQUEST_QTY;

        -- Kumar 11/05/2012 Added Columns for 2012 Q1 Enhancements
        tois.CUST_PUR_ORD_LINE_ITEM_NBR_ID := adr43.CUST_PUR_ORD_LINE_ITEM_NBR_ID;
    tois.BILLING_TYPE_CDE           := adr43.BILLING_TYPE_CDE;
    tois.SAP_DELIVERY_TYPE_CDE       := adr43.SAP_DELIVERY_TYPE_CDE;
    tois.SHIPMENT_NUMBER_ID           := adr43.SHIPMENT_NUMBER_ID;

        -- get values for common columns
        adr43Comm.REPORTING_ORGANIZATION_ID := adr43.REPORTING_ORGANIZATION_ID;
        adr43Comm.ORDER_NBR                 := adr43.ORDER_NBR;
        adr43Comm.ORDER_ITEM_NBR            := adr43.ORDER_ITEM_NBR;
        adr43Comm.SCHEDULE_LINE_NBR         := adr43.SCHEDULE_LINE_NBR;
        adr43Comm.DELIVERY_BLOCK_CDE        := adr43.DELIVERY_BLOCK_CDE;
        adr43Comm.CREDIT_CHECK_STATUS_CDE   := adr43.CREDIT_CHECK_STATUS_CDE;
        adr43Comm.DATA_PROCESSED_DT         := adr43.DATA_PROCESSED_DT;
        adr43Comm.DATA_SOURCE_DESC          := adr43.DATA_SOURCE_DESC;

        -- check if need to get hold_order infor
        IF vgc_oi_sl_ind IS NOT NULL THEN
          p_get_scd_hold_orders_rec(vion_result);
          IF vion_result <> 0 THEN
            EXIT;
          END IF;
        END IF;

        -- insert record to temp_order_item_shipment table
        p_insert_tois_rec(vion_result);
        IF vion_result = -6502 THEN
          RAISE VALUE_ERROR;
        ELSIF vion_result <> 0 THEN
          RAISE New_Exception;
        END IF;

        vln_commit_cnt := vln_commit_cnt + 1;
        IF vln_commit_cnt >= vin_commit_cnt THEN
          COMMIT;
          vln_commit_cnt := 0;
        END IF;

      EXCEPTION
        WHEN VALUE_ERROR THEN
          INSERT INTO SCORECARD_PROCESS_LOG
            (SCD_PROCESS_LOG_SEQ,
             SCD_PROCESS_NAME,
             DML_ORACLE_ID,
             DML_TMSTMP,
             SCD_PROCESS_LINE,
             SCD_PROCESS_TEXT)
          VALUES
            (SCD_PROCESS_LOG_SEQ.NEXTVAL,
             'ADR43 - P_EXTRACT_BILLINGS',
             vgc_job_id,
             SYSDATE,
             1,
             ('Numeric or Value Error; BATCH ID=' || vin_batch_id ||
             ' RECORD_BATCH ID=' || adr43.BATCH_RECORD_ID));
        WHEN New_Exception THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS1 - ' || vgc_job_id ||
                               ' BATCH ID=' || vin_batch_id ||
                               ' RECORD_BATCH ID=' ||
                               adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
        WHEN OTHERS THEN
          vion_result := SQLCODE;
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS2 - ' || vgc_job_id ||
                               ' BATCH ID=' || vin_batch_id ||
                               ' RECORD_BATCH ID=' ||
                               adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
      END;

    END LOOP;
    COMMIT;
    CLOSE cur_billings;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS3 - ' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_billings;

  /************************************************************************
  * Procedure  : p_extract_deliveries
  * Description: Extract delivery records and populate into temp_order_item_shipment table.
  ************************************************************************/

  PROCEDURE p_extract_deliveries(vin_batch_id   IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                                 vin_commit_cnt NUMBER,
                                 vion_result    IN OUT NUMBER) IS

   CURSOR cur_deliveries IS
    SELECT *
    FROM   adr43_deliveries
    WHERE  batch_id                                    = vin_batch_id
    AND    NVL(re_billed_cde, 'x')                    != 'Y'
    AND    NVL(material_type_cde, 'x')                != 'ZSPC'
    AND    sales_transaction_type_cde                 IN ('S1', 'S0')
    AND    NVL(sbmt_sales_stat_category_cde, 'x') NOT IN ( 'MV', 'ZVEN') -- 03/22/2012 Kumar exclude ZVEN records
    AND    ((NVL(sales_doc_type_cde,'x') = 'V' AND delivery_item_category_cde = 'NLC') OR (NVL(sales_doc_type_cde, 'x') != 'V' ))
    AND    NOT (sales_transaction_type_cde = 'S0' AND NVL(billing_type_cde, 'x') = 'IV')
    ORDER BY reporting_organization_id, part_key_id;

    vln_commit_cnt           NUMBER := 0;
    vln_nbr_window_days_late TEMP_ORDER_ITEM_SHIPMENT.NBR_WINDOW_DAYS_LATE%TYPE;
    adr43                    ADR43_DELIVERIES%ROWTYPE;

  BEGIN

    vion_result := 0;

    BEGIN
      SELECT TO_NUMBER(PARAMETER_FIELD, '99')
        INTO vln_NBR_WINDOW_DAYS_LATE
        FROM DELIVERY_PARAMETER
       WHERE PARAMETER_ID = 'DED359';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vln_nbr_window_days_late := 0;
      WHEN OTHERS THEN
        vion_result := SQLCODE;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BILLINGS - ' || vgc_job_id ||' BATCH ID=' || vin_batch_id);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
        RETURN;
    END;

    -- process all delivery records
    OPEN cur_deliveries;
    LOOP
      BEGIN
        FETCH cur_deliveries
          INTO adr43;
        EXIT WHEN(cur_deliveries%NOTFOUND);

        tois := NULL;

        -- derive tois.ORGANIZATION_KEY_ID

        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.ORGANIZATION_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.ORGANIZATION_KEY_ID) THEN
          NULL;
        END IF;

        tois.AMP_ORDER_NBR            := adr43.ORDER_NBR;
        tois.ORDER_ITEM_NBR           := adr43.ORDER_ITEM_NBR;
        tois.SHIPMENT_ID              := adr43.SCHEDULE_LINE_NBR;
        tois.PURCHASE_BY_ACCOUNT_BASE := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID, 1, 8);
        tois.SHIP_TO_ACCOUNT_SUFFIX   := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID, 9, 2);

        -- derive tois.ACCOUNTING_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.SHIP_TO_ACCT_ORGANIZATION_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.ACCOUNTING_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.PRODCN_CNTRLR_CODE             := NVL(adr43.PLANNER_CDE, '*');
        tois.ITEM_QUANTITY                  := ROUND(adr43.CUSTOMER_ORDER_ITEM_QTY, 0);
        tois.RESRVN_LEVEL_1                 := 0;
        tois.RESRVN_LEVEL_5                 := 0;
        tois.RESRVN_LEVEL_9                 := 0;
        tois.QUANTITY_RELEASED              := 0;
        tois.QUANTITY_SHIPPED               := ROUND(adr43.SHIPPED_QTY, 0);
        tois.ISO_CURRENCY_CODE_1            := adr43.ORG_TYPE_CO_ISO_CURRENCY_CDE;
        tois.LOCAL_CURRENCY_BILLED_AMOUNT   := adr43.LINE_ITEM_LOCAL_CURRENCY_AMT;
        tois.EXTENDED_BOOK_BILL_AMOUNT      := adr43.LINE_ITEM_US_DOLLAR_AMT;
        tois.UNIT_PRICE                     := 0;
        tois.CUSTOMER_REQUEST_DATE          := adr43.CUSTOMER_REQUEST_DT;
        tois.AMP_SCHEDULE_DATE              := adr43.ORIGINAL_SCHEDULE_DT;
        tois.RELEASE_DATE                   := adr43.SCHEDULE_RELEASED_SHIP_DT;
        tois.AMP_SHIPPED_DATE               := adr43.SHIPMENT_DT;
        tois.NBR_WINDOW_DAYS_EARLY          := adr43.DAYS_ERL_DLVR_WINDOW_QTY;
        tois.REQUESTED_ON_DOCK_DT           := adr43.REQUESTED_ON_DOCK_DT;
        tois.SCHEDULED_ON_DOCK_DT           := adr43.SCHEDULED_ON_DOCK_DT;
        tois.SHIP_TO_CUSTOMER_KEY_ID        := adr43.SHIP_TO_CUSTOMER_KEY_ID;
        tois.SOLD_TO_CUSTOMER_KEY_ID        := adr43.SOLD_TO_CUSTOMER_KEY_ID;
        tois.HIERARCHY_CUSTOMER_KEY_ID      := adr43.HIERARCHY_CUSTOMER_KEY_ID;
        tois.ULTIMATE_END_CUSTOMER_KEY_ID   := adr43.ULTIMATE_END_CUSTOMER_KEY_ID;
        tois.BILL_OF_LADING_ID              := adr43.BILL_OF_LADING_ID;
        tois.SBMT_FWD_AGENT_VENDOR_ID       := adr43.SBMT_FWD_AGENT_VENDOR_ID;
        tois.FWD_AGENT_VENDOR_KEY_ID        := adr43.FWD_AGENT_VENDOR_KEY_ID;
        tois.INTL_COMMERCIAL_TERMS_CDE      := adr43.INTL_COMMERCIAL_TERMS_CDE;
        tois.INTL_CMCL_TERM_ADDITIONAL_DESC := adr43.INTL_CMCL_TERM_ADDITIONAL_DESC;
        tois.SHIPPING_TRSP_CATEGORY_CDE     := adr43.SHIPPING_TRSP_CATEGORY_CDE;
        tois.HEADER_CUST_ORDER_RECEIVED_DT  := adr43.HEADER_CUST_ORDER_RECEIVED_DT;
        tois.SBMT_SCHD_AGR_CANCEL_IND_CDE   := adr43.SBMT_SCHD_AGR_CANCEL_IND_CDE;
        tois.SCHD_AGR_CANCEL_INDICATOR_CDE  := adr43.SCHD_AGR_CANCEL_INDICATOR_CDE;
        tois.CONSUMED_SA_ORDER_ITEM_NBR_ID  := adr43.CONSUMED_SA_ORDER_ITEM_NBR_ID;
        tois.CONSUMED_SA_ORDER_NUMBER_ID    := adr43.CONSUMED_SA_ORDER_NUMBER_ID;
        tois.SBMT_SB_CNSN_ITRST_PRTNCUST_ID := adr43.SBMT_SB_CNSN_ITRST_PRTNCUST_ID;
        tois.SB_CNSN_ITRST_PRTN_CUST_KEY_ID := adr43.SB_CNSN_ITRST_PRTN_CUST_KEY_ID;
        tois.SHIPPING_CONDITIONS_CDE        := adr43.SHIPPING_CONDITIONS_CDE;
        tois.SBMT_ZI_CNSN_STK_PRTN_CUST_ID  := adr43.SBMT_ZI_CNSN_STK_PRTN_CUST_ID;
        tois.ZI_CNSN_STK_PRTN_CUST_KEY_ID   := adr43.ZI_CNSN_STK_PRTN_CUST_KEY_ID;
        tois.SBMT_SALES_TERRITORY_CDE       := adr43.SBMT_SALES_TERRITORY_CDE;
        tois.SBMT_SALES_OFFICE_CDE          := adr43.SBMT_SALES_OFFICE_CDE;
        tois.SBMT_SALES_GROUP_CDE           := adr43.SBMT_SALES_GROUP_CDE;
        tois.SCHEDULE_LINE_NBR              := adr43.SCHEDULE_LINE_NBR;
        tois.SBMT_SCHEDULE_LINE_NBR         := adr43.SBMT_SCHEDULE_LINE_NBR;

        -- derive tois.NBR_WINDOW_DAYS_LATE
        IF tois.NBR_WINDOW_DAYS_EARLY IS NULL THEN
          IF (adr43.JUST_IN_TIME_CUSTOMER_IND = 'Y' OR adr43.SBMT_JUST_IN_TIME_CUSTOMER_IND = '03') THEN
            tois.NBR_WINDOW_DAYS_LATE := 0;
          ELSE
            tois.NBR_WINDOW_DAYS_LATE := vln_nbr_window_days_late;
          END IF;
        ELSE
          tois.NBR_WINDOW_DAYS_LATE := 0;
        END IF;

        tois.ACTUAL_SHIP_LOCATION     := NVL(adr43.LOCATION_CDE, '*');
        tois.ACTUAL_SHIP_BUILDING_NBR := NVL(adr43.PLANT_ID, '*');

        -- derive tois.INVENTORY_LOCATION_CODE
        tois.INVENTORY_LOCATION_CODE := '*';

        -- derive tois.INVENTORY_BUILDING_NBR
        tois.INVENTORY_BUILDING_NBR := '*';

        -- derive tois.CONTROLLER_UNIQUENESS_ID
        IF INSTR(adr43.DATA_SOURCE_DESC, 'SAP') > 0 THEN
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.PLANT_ID, '*');
        ELSE
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.INVENTORY_ORGANIZATION_ID, '*');
        END IF;

        tois.ORDER_BOOKING_DATE        := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_RECEIVED_DATE       := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_TYPE_ID             := adr43.SBMT_SALES_STAT_CATEGORY_CDE;
        tois.REGTRD_DATE               := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.REPORTED_AS_OF_DATE       := adr43.DATA_PROCESSED_DT;
        tois.PURCHASE_ORDER_DATE       := adr43.CUSTOMER_PURCHASE_ORDER_DT;
        tois.PURCHASE_ORDER_NBR        := adr43.CUSTOMER_PURCHASE_ORDER_ID;
        tois.PRODCN_CNTLR_EMPLOYEE_NBR := '*';

        -- derive tois.PART_PRCR_SRC_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.PART_PRCR_SRC_ORG_ID,
                                        adr43.SHIPMENT_DT,
                                        tois.PART_PRCR_SRC_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.TEAM_CODE                   := '*';
        tois.STOCK_MAKE_CODE             := NVL(adr43.STOCK_MAKE_CDE, '*');
        tois.PRODUCT_CODE                := NVL(adr43.PRODUCT_CDE, '*');
        tois.PRODUCT_LINE_CODE           := NVL(adr43.PRODUCT_LINE_CDE, '*');
        tois.WW_ACCOUNT_NBR_BASE         := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 1, 8), '*');
        tois.WW_ACCOUNT_NBR_SUFFIX       := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 9, 2), '*');
        tois.A_TERRITORY_NBR             := NVL(adr43.TERRITORY_CDE, '*');
        tois.CUSTOMER_REFERENCE_PART_NBR := adr43.CUSTOMER_PART_NBR;

        -- derive tois.CUSTOMER_CREDIT_HOLD_IND
        -- IF adr43.CREDIT_CHECK_STATUS_CDE IN ('B', 'C') THEN
        --   tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
        -- END IF;

        -- derive tois.TEMP_HOLD_IND
        IF adr43.DELIVERY_BLOCK_CDE = 'CH' THEN
        --  tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
          NULL;
        ELSIF adr43.DELIVERY_BLOCK_CDE IS NOT NULL THEN
          tois.TEMP_HOLD_IND := 'T';
        END IF;

        -- set tois.CUSTOMER_CREDIT_HOLD_IND from adr43
        tois.CUSTOMER_CREDIT_HOLD_IND      := adr43.PAYER_CR_BLOCK_STATUS_IND_CDE;
        tois.CUSTOMER_ON_CREDIT_HOLD_DATE  := adr43.PAYER_CREDIT_BLOCK_ON_DT;
        tois.CUSTOMER_OFF_CREDIT_HOLD_DATE := adr43.PAYER_CREDIT_BLOCK_OFF_DT;

        -- derive tois.CUSTOMER_TYPE_CODE
        IF (adr43.JUST_IN_TIME_CUSTOMER_IND = 'Y' OR adr43.SBMT_JUST_IN_TIME_CUSTOMER_IND = '03') THEN
          tois.CUSTOMER_TYPE_CODE := 'J';
        END IF;

        tois.INDUSTRY_CODE                  := NVL(adr43.INDUSTRY_CDE, '*');
        tois.PRODUCT_BUSNS_LINE_ID          := adr43.COMPETENCY_BSNS_CDE;
        tois.PRODUCT_BUSNS_LINE_FNCTN_ID    := NVL(adr43.COMPETENCY_BSNS_FUNC_CDE, '*');
        tois.ZERO_PART_PROD_CODE            := NVL(adr43.ZERO_PART_PRODUCT_CDE, '*');
        tois.CUSTOMER_ACCT_TYPE_CDE         := adr43.TRADE_INTERCO_CDE;
        tois.MFR_ORG_KEY_ID                 := 0;
        tois.MFG_CAMPUS_ID                  := '*';
        tois.MFG_BUILDING_NBR               := '*';
        tois.REMAINING_QTY_TO_SHIP          := ROUND(adr43.REMAINING_TO_SHIP_QTY, 0);
        tois.INDUSTRY_BUSINESS_CODE         := adr43.INDUSTRY_BUSINESS_CDE;
        tois.SBMT_PART_NBR                  := adr43.SBMT_PART_NBR;
        tois.SBMT_CUSTOMER_ACCT_NBR         := adr43.SBMT_SHIP_TO_CUSTOMER_ID;
        tois.PROFIT_CENTER_ABBR_NM          := NVL(adr43.PROFIT_CENTER_ABBR_NM, '*');
        tois.BRAND_ID                       := adr43.AQUISITION_FORMAT_ID;
        tois.SCHD_TYCO_MONTH_OF_YEAR_ID     := adr43.SCHD_TYCO_MONTH_OF_YEAR_ID;
        tois.SCHD_TYCO_QUARTER_ID           := adr43.SCHD_TYCO_QUARTER_ID;
        tois.SCHD_TYCO_YEAR_ID              := adr43.SCHD_TYCO_YEAR_ID;
        tois.SOLD_TO_CUSTOMER_ID            := adr43.SOLD_TO_CUSTOMER_ID;
        tois.INVOICE_NBR                    := adr43.INVOICE_NBR;
        tois.DELIVERY_BLOCK_CDE             := adr43.DELIVERY_BLOCK_CDE;
        tois.CREDIT_CHECK_STATUS_CDE        := adr43.CREDIT_CHECK_STATUS_CDE;
        tois.SALES_ORGANIZATION_ID          := adr43.SALES_ORGANIZATION_ID;
        tois.DISTRIBUTION_CHANNEL_CDE       := adr43.DISTRIBUTION_CHANNEL_CDE;
        tois.ORDER_DIVISION_CDE             := adr43.ORDER_DIVISION_CDE;
        tois.ITEM_DIVISION_CDE              := adr43.ITEM_DIVISION_CDE;
        tois.MATL_ACCOUNT_ASGN_GRP_CDE      := adr43.MATL_ACCOUNT_ASGN_GRP_CDE;
        tois.BATCH_ID                       := adr43.BATCH_ID;
        tois.DATA_SOURCE_DESC               := adr43.DATA_SOURCE_DESC;
        tois.PRIME_WORLDWIDE_CUSTOMER_ID    := adr43.PRIME_WORLDWIDE_CUSTOMER_ID;
        tois.SALES_DOCUMENT_TYPE_CDE        := adr43.SALES_DOC_TYPE_CDE;
        tois.MATERIAL_TYPE_CDE              := adr43.MATERIAL_TYPE_CDE;
        tois.DROP_SHIPMENT_IND              := adr43.DROP_SHIPMENT_IND;
        tois.SALES_OFFICE_CDE               := NVL(adr43.SALES_OFFICE_CDE, '*');
        tois.SALES_GROUP_CDE                := NVL(adr43.SALES_GROUP_CDE, '*');
        tois.SBMT_PART_PRCR_SRC_ORG_ID      := adr43.PART_PRCR_SRC_ORG_ID;
        tois.HIERARCHY_CUSTOMER_IND         := vgn_hierarchy_customer_ind;
        tois.HIERARCHY_CUSTOMER_ORG_ID      := adr43.HIERARCHY_CUSTOMER_ORG_ID;
        tois.HIERARCHY_CUSTOMER_BASE_ID     := adr43.HIERARCHY_CUSTOMER_BASE_ID;
        tois.HIERARCHY_CUSTOMER_SUFX_ID     := adr43.HIERARCHY_CUSTOMER_SUFX_ID;
        tois.PART_UM                        := adr43.UNIT_OF_MEASURE_CDE;
        tois.SBMT_ORIGINAL_SCHEDULE_DT      := adr43.ORIGINAL_SCHEDULE_DT;
        tois.SBMT_CURRENT_SCHEDULE_DT       := adr43.CURRENT_SCHEDULE_DT;
        tois.SBMT_SOLD_TO_CUSTOMER_ID       := adr43.SBMT_SOLD_TO_CUSTOMER_ID;
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE   := adr43.SCHEDULE_ON_CREDIT_HOLD_DT;
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE  := adr43.SCHEDULE_OFF_CREDIT_HOLD_DT;
        tois.TEMP_HOLD_ON_DATE              := adr43.TEMP_HOLD_ON_DT;
        tois.TEMP_HOLD_OFF_DATE             := adr43.TEMP_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_ON_DT  := adr43.TYCO_CTRL_DELIVERY_HOLD_ON_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_OFF_DT := adr43.TYCO_CTRL_DELIVERY_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_BLOCK_CDE   := adr43.TYCO_CTRL_DELIVERY_BLOCK_CDE;
        tois.PICK_PACK_WORK_DAYS_QTY        := adr43.PICK_PACK_WORK_DAYS_QTY;
        tois.LOADING_NBR_OF_WORK_DAYS_QTY   := adr43.LOADING_NBR_OF_WORK_DAYS_QTY;
        tois.TRSP_LEAD_TIME_DAYS_QTY        := adr43.TRSP_LEAD_TIME_DAYS_QTY;
        tois.TRANSIT_TIME_DAYS_QTY          := adr43.TRANSIT_TIME_DAYS_QTY;
        tois.DELIVERY_ITEM_CATEGORY_CDE     := adr43.DELIVERY_ITEM_CATEGORY_CDE;
        tois.ORDER_HEADER_BILLING_BLOCK_CDE := adr43.ORDER_HEADER_BILLING_BLOCK_CDE;
        tois.ITEM_BILLING_BLOCK_CDE         := adr43.ITEM_BILLING_BLOCK_CDE;
        tois.FIXED_DATE_QUANTITY_IND        := adr43.FIXED_DATE_QUANTITY_IND;
        tois.SAP_BILL_TO_CUSTOMER_ID        := adr43.SAP_BILL_TO_CUSTOMER_ID;
        tois.DELIVERY_DOCUMENT_NBR_ID       := adr43.DELIVERY_DOCUMENT_NBR_ID;
        tois.DELIVERY_DOCUMENT_ITEM_NBR_ID  := adr43.DELIVERY_DOCUMENT_ITEM_NBR_ID;
        tois.MISC_LOCAL_FLAG_CDE_1          := adr43.MISC_LOCAL_FLAG_CDE_1;
        tois.MISC_LOCAL_CDE_1               := adr43.MISC_LOCAL_CDE_1;
        tois.MISC_LOCAL_CDE_2               := adr43.MISC_LOCAL_CDE_2;
        tois.MISC_LOCAL_CDE_3               := adr43.MISC_LOCAL_CDE_3;
        tois.CUSTOMER_DATE_BASIS_CDE        := adr43.CUSTOMER_DATE_BASIS_CDE;
        tois.ACTUAL_DATE_BASIS_CDE          := adr43.ACTUAL_DATE_BASIS_CDE;
        tois.SHIP_DATE_DETERMINATION_CDE    := adr43.SHIP_DATE_DETERMINATION_CDE;
        tois.CUST_ORD_REQ_RESET_REASON_CDE  := adr43.CUST_ORD_REQ_RESET_REASON_CDE;
        tois.CUST_ORD_REQ_RESET_REASON_DT   := adr43.CUST_ORD_REQ_RESET_REASON_DT;
        tois.CUSTOMER_ORDER_EDI_TYPE_CDE    := adr43.CUSTOMER_ORDER_EDI_TYPE_CDE;
        tois.ULTIMATE_END_CUSTOMER_ID       := adr43.ULTIMATE_END_CUSTOMER_ID;
        tois.ULTIMATE_END_CUST_ACCT_GRP_CDE := adr43.ULTIMATE_END_CUST_ACCT_GRP_CDE;
        tois.MRP_GROUP_CDE                  := NVL(adr43.MRP_GROUP_CDE, '*');
        tois.COMPLETE_DELIVERY_IND          := adr43.COMPLETE_DELIVERY_IND;
        tois.PART_KEY_ID                    := adr43.PART_KEY_ID;
        tois.SOURCE_ID                      := adr43.SOURCE_ID;
        tois.DATA_SRC_ID                    := adr43.DATA_SRC_ID;
        tois.DISTR_SHIP_WHEN_AVAIL_IND      := adr43.DISTR_SHIP_WHEN_AVAIL_IND;
        tois.SAP_PROFIT_CENTER_CDE          := adr43.SAP_PROFIT_CENTER_CDE;
        tois.STORAGE_LOCATION_ID            := adr43.STORAGE_LOCATION_ID;
        tois.SALES_TERRITORY_CDE            := adr43.SALES_TERRITORY_CDE;
        tois.TRSP_MGE_TRANSIT_TIME_DAYS_QTY := adr43.TRSP_MGE_TRANSIT_TIME_DAYS_QTY;

        -- get physical bldg
        tois.ACTUAL_SHIP_FROM_BUILDING_ID   := Scdcommonbatch.get_physical_building(adr43.PLANT_ID, adr43.STORAGE_LOCATION_ID);
        tois.SBMT_FCST_PP_CUST_ACCT_NBR     := adr43.SBMT_FCST_PP_CUST_ACCT_NBR;
        tois.FCST_PRM_PRTN_CUSTOMER_KEY_ID  := adr43.FCST_PRM_PRTN_CUSTOMER_KEY_ID;
        tois.FCST_PRM_PRTN_CUST_ACCT_NBR    := adr43.FCST_PRM_PRTN_CUST_ACCT_NBR;
        tois.FCST_PRM_PRTN_ACCT_GROUP_CDE   := adr43.FCST_PRM_PRTN_ACCT_GROUP_CDE;

        -- TELAG 1535 Columns
        tois.ORDER_RECEIVED_DT              := adr43.ORDER_RECEIVED_DT;
        tois.ORDER_CREATED_BY_NTWK_USER_ID  := adr43.ORDER_CREATED_BY_NTWK_USER_ID;
        tois.DELIVERY_DOC_CREATION_DT       := adr43.DELIVERY_DOC_CREATION_DT;
        tois.DELIVERY_DOC_CREATION_TM       := adr43.DELIVERY_DOC_CREATION_TM;
        tois.DLVR_DOC_CRET_BY_NTWK_USER_ID  := adr43.DLVR_DOC_CRET_BY_NTWK_USER_ID;
        tois.PLANNED_GOODS_ISSUE_DT         := adr43.PLANNED_GOODS_ISSUE_DT;
        -- End TELAGE Columns

        tois.PRICING_CONDITION_TYPE_CDE     := adr43.PRICING_CONDITION_TYPE_CDE;
        tois.SCHEDULE_LINE_CATEGORY_CDE     := adr43.SCHEDULE_LINE_CATEGORY_CDE;
        tois.INITIAL_REQUEST_DT             := adr43.INITIAL_REQUEST_DT;
        tois.INITIAL_REQUEST_QTY            := adr43.INITIAL_REQUEST_QTY;
        tois.MATERIAL_AVAILABILITY_DT       := adr43.MATERIAL_AVAILABILITY_DT;  -- Kumar 07/06/2012

        -- Kumar 11/05/2012 Added Columns for 2012 Q1 Enhancements
        tois.CUST_PUR_ORD_LINE_ITEM_NBR_ID := adr43.CUST_PUR_ORD_LINE_ITEM_NBR_ID;
        tois.BILLING_TYPE_CDE           := adr43.BILLING_TYPE_CDE;
    tois.SAP_DELIVERY_TYPE_CDE       := adr43.SAP_DELIVERY_TYPE_CDE;
    tois.SHIPMENT_NUMBER_ID           := adr43.SHIPMENT_NUMBER_ID;

        -- get values for common columns
        adr43Comm.REPORTING_ORGANIZATION_ID := adr43.REPORTING_ORGANIZATION_ID;
        adr43Comm.ORDER_NBR                 := adr43.ORDER_NBR;
        adr43Comm.ORDER_ITEM_NBR            := adr43.ORDER_ITEM_NBR;
        adr43Comm.SCHEDULE_LINE_NBR         := adr43.SCHEDULE_LINE_NBR;
        adr43Comm.DELIVERY_BLOCK_CDE        := adr43.DELIVERY_BLOCK_CDE;
        adr43Comm.CREDIT_CHECK_STATUS_CDE   := adr43.CREDIT_CHECK_STATUS_CDE;
        adr43Comm.DATA_PROCESSED_DT         := adr43.DATA_PROCESSED_DT;
        adr43Comm.DATA_SOURCE_DESC          := adr43.DATA_SOURCE_DESC;

        -- check if need to get hold_order infor
        IF vgc_oi_sl_ind IS NOT NULL THEN
          p_get_scd_hold_orders_rec(vion_result);
          IF vion_result <> 0 THEN
            EXIT;
          END IF;
        END IF;

        -- insert record to temp_order_item_shipment table
        p_insert_tois_rec(vion_result);
        IF vion_result = -6502 THEN
          RAISE VALUE_ERROR;
        ELSIF vion_result <> 0 THEN
          RAISE New_Exception;
        END IF;

        vln_commit_cnt := vln_commit_cnt + 1;

        IF vln_commit_cnt >= vin_commit_cnt THEN
          COMMIT;
          vln_commit_cnt := 0;
        END IF;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          INSERT INTO SCORECARD_PROCESS_LOG
            (SCD_PROCESS_LOG_SEQ,
             SCD_PROCESS_NAME,
             DML_ORACLE_ID,
             DML_TMSTMP,
             SCD_PROCESS_LINE,
             SCD_PROCESS_TEXT)
          VALUES
            (SCD_PROCESS_LOG_SEQ.NEXTVAL,
             'ADR43 - P_EXTRACT_DELIVERIES',
             vgc_job_id,
             SYSDATE,
             1,
             ('Numeric or Value Error; BATCH ID=' || vin_batch_id || ' RECORD_BATCH ID=' || adr43.BATCH_RECORD_ID));
        WHEN New_Exception THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_DELIVERIES1 - ' || vgc_job_id || ' BATCH ID=' || vin_batch_id || ' RECORD_BATCH ID=' || adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
        WHEN OTHERS THEN
          vion_result := SQLCODE;
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_DELIVERIES2 - ' || vgc_job_id || ' BATCH ID=' || vin_batch_id || ' RECORD_BATCH ID=' || adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
      END;
    END LOOP;
    COMMIT;
    CLOSE cur_deliveries;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_DELIVERIES3 - ' || vgc_job_id || ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_deliveries;

  /************************************************************************
  * Procedure  : p_extract_backlog
  * Description: Extract backlog records and populate into temp_order_item
  *     _shipment table.
  ************************************************************************/

  PROCEDURE p_extract_backlog(vin_batch_id   IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                              vin_commit_cnt NUMBER,
                              vion_result    IN OUT NUMBER) IS

    CURSOR cur_backlog IS
      SELECT *
        FROM ADR43_BACKLOGS
       WHERE BATCH_ID = vin_batch_id
         AND SALES_TRANSACTION_TYPE_CDE = 'B0'
         AND ((NVL(SALES_DOC_TYPE_CDE,'x') = 'V'
               AND NVL(SBMT_SALES_STAT_CATEGORY_CDE,'x') IN ('NB','ZUB','LP','LU'))
              OR (NVL(SALES_DOC_TYPE_CDE,'x') != 'V'))
         AND NOT (NVL(MATERIAL_TYPE_CDE, 'x') = 'ZSPC' AND
                  NVL(DELIVERY_ITEM_CATEGORY_CDE, 'x') NOT IN ('ZT1D', 'ZSRO', 'ZS3P'))
         AND NVL(SBMT_SALES_STAT_CATEGORY_CDE, 'x') NOT IN ('MV', 'ZPRJ', 'ZREW')
       ORDER BY REPORTING_ORGANIZATION_ID, PART_KEY_ID;

    vln_commit_cnt NUMBER := 0;
    adr43          ADR43_BACKLOGS%ROWTYPE;

  BEGIN

    vion_result := 0;
    -- process all backlog records
    OPEN cur_backlog;
    LOOP
      BEGIN
        FETCH cur_backlog
          INTO adr43;
        EXIT WHEN(cur_backlog%NOTFOUND);

        tois := NULL;

        -- derive tois.ORGANIZATION_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.ORGANIZATION_ID,
                                        adr43.DATA_PROCESSED_DT,
                                        tois.ORGANIZATION_KEY_ID) THEN
          NULL;
        END IF;

        tois.AMP_ORDER_NBR            := adr43.ORDER_NBR;
        tois.ORDER_ITEM_NBR           := adr43.ORDER_ITEM_NBR;
        tois.SHIPMENT_ID              := adr43.SCHEDULE_LINE_NBR;
        tois.PURCHASE_BY_ACCOUNT_BASE := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID, 1, 8);
        tois.SHIP_TO_ACCOUNT_SUFFIX   := SUBSTR(adr43.SHIP_TO_CUSTOMER_ID, 9, 2);

        -- derive tois.ACCOUNTING_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.SHIP_TO_ACCT_ORGANIZATION_ID,
                                        adr43.DATA_PROCESSED_DT,
                                        tois.ACCOUNTING_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.PRODCN_CNTRLR_CODE             := NVL(adr43.PLANNER_CDE, '*');
        tois.ITEM_QUANTITY                  := ROUND(adr43.CUSTOMER_ORDER_ITEM_QTY, 0);
        tois.RESRVN_LEVEL_1                 := 0;
        tois.RESRVN_LEVEL_5                 := ROUND(adr43.REMAINING_TO_SHIP_QTY, 0);
        tois.RESRVN_LEVEL_9                 := 0;
        tois.QUANTITY_RELEASED              := 0;
        tois.QUANTITY_SHIPPED               := ROUND(adr43.SHIPPED_QTY, 0);
        tois.ISO_CURRENCY_CODE_1            := adr43.ORG_TYPE_CO_ISO_CURRENCY_CDE;
        tois.LOCAL_CURRENCY_BILLED_AMOUNT   := adr43.LINE_ITEM_LOCAL_CURRENCY_AMT;
        tois.EXTENDED_BOOK_BILL_AMOUNT      := adr43.LINE_ITEM_US_DOLLAR_AMT;
        tois.UNIT_PRICE                     := 0;
        tois.CUSTOMER_REQUEST_DATE          := adr43.CUSTOMER_REQUEST_DT;
        tois.RELEASE_DATE                   := adr43.SCHEDULE_RELEASED_SHIP_DT;
        tois.AMP_SHIPPED_DATE               := adr43.SHIPMENT_DT;
        tois.NBR_WINDOW_DAYS_EARLY          := adr43.DAYS_ERL_DLVR_WINDOW_QTY;
        tois.AMP_SCHEDULE_DATE              := adr43.CURRENT_SCHEDULE_DT;
        tois.REQUESTED_ON_DOCK_DT           := adr43.REQUESTED_ON_DOCK_DT;
        tois.SCHEDULED_ON_DOCK_DT           := adr43.SCHEDULED_ON_DOCK_DT;
        tois.SHIP_TO_CUSTOMER_KEY_ID        := adr43.SHIP_TO_CUSTOMER_KEY_ID;
        tois.SOLD_TO_CUSTOMER_KEY_ID        := adr43.SOLD_TO_CUSTOMER_KEY_ID;
        tois.HIERARCHY_CUSTOMER_KEY_ID      := adr43.HIERARCHY_CUSTOMER_KEY_ID;
        tois.ULTIMATE_END_CUSTOMER_KEY_ID   := adr43.ULTIMATE_END_CUSTOMER_KEY_ID;
        tois.SBMT_FWD_AGENT_VENDOR_ID       := adr43.SBMT_FWD_AGENT_VENDOR_ID;
        tois.FWD_AGENT_VENDOR_KEY_ID        := adr43.FWD_AGENT_VENDOR_KEY_ID;
        tois.INTL_COMMERCIAL_TERMS_CDE      := adr43.INTL_COMMERCIAL_TERMS_CDE;
        tois.INTL_CMCL_TERM_ADDITIONAL_DESC := adr43.INTL_CMCL_TERM_ADDITIONAL_DESC;
        tois.SHIPPING_TRSP_CATEGORY_CDE     := adr43.SHIPPING_TRSP_CATEGORY_CDE;
        tois.HEADER_CUST_ORDER_RECEIVED_DT  := adr43.HEADER_CUST_ORDER_RECEIVED_DT;
        tois.SBMT_SCHD_AGR_CANCEL_IND_CDE   := adr43.SBMT_SCHD_AGR_CANCEL_IND_CDE;
        tois.SCHD_AGR_CANCEL_INDICATOR_CDE  := adr43.SCHD_AGR_CANCEL_INDICATOR_CDE;
        tois.CONSUMED_SA_ORDER_ITEM_NBR_ID  := adr43.CONSUMED_SA_ORDER_ITEM_NBR_ID;
        tois.CONSUMED_SA_ORDER_NUMBER_ID    := adr43.CONSUMED_SA_ORDER_NUMBER_ID;
        tois.SBMT_SB_CNSN_ITRST_PRTNCUST_ID := adr43.SBMT_SB_CNSN_ITRST_PRTNCUST_ID;
        tois.SB_CNSN_ITRST_PRTN_CUST_KEY_ID := adr43.SB_CNSN_ITRST_PRTN_CUST_KEY_ID;
        tois.SHIPPING_CONDITIONS_CDE        := adr43.SHIPPING_CONDITIONS_CDE;
        tois.SBMT_ZI_CNSN_STK_PRTN_CUST_ID  := adr43.SBMT_ZI_CNSN_STK_PRTN_CUST_ID;
        tois.ZI_CNSN_STK_PRTN_CUST_KEY_ID   := adr43.ZI_CNSN_STK_PRTN_CUST_KEY_ID;
        tois.SBMT_SALES_TERRITORY_CDE       := adr43.SBMT_SALES_TERRITORY_CDE;
        tois.SBMT_SALES_OFFICE_CDE          := adr43.SBMT_SALES_OFFICE_CDE;
        tois.SBMT_SALES_GROUP_CDE           := adr43.SBMT_SALES_GROUP_CDE;
        tois.SCHEDULE_LINE_NBR              := adr43.SCHEDULE_LINE_NBR;
        tois.SBMT_SCHEDULE_LINE_NBR         := adr43.SBMT_SCHEDULE_LINE_NBR;
        tois.DISCONTINUED_OPERATIONS_CDE    := Pkg_Edit_Temp_Order_Daf.get_disc_ops_cde_backlog(adr43);

        -- derive tois.NBR_WINDOW_DAYS_LATE
        tois.NBR_WINDOW_DAYS_LATE     := 0;
        tois.ACTUAL_SHIP_LOCATION     := '*';
        tois.ACTUAL_SHIP_BUILDING_NBR := '*';

        -- derive tois.INVENTORY_LOCATION_CODE
        tois.INVENTORY_LOCATION_CODE := NVL(adr43.LOCATION_CDE, '*');

        -- derive tois.INVENTORY_BUILDING_NBR
        tois.INVENTORY_BUILDING_NBR := NVL(adr43.PLANT_ID, '*');

        -- derive tois.CONTROLLER_UNIQUENESS_ID
        IF INSTR(adr43.DATA_SOURCE_DESC, 'SAP') > 0 THEN
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.PLANT_ID, '*');
        ELSE
          tois.CONTROLLER_UNIQUENESS_ID := NVL(adr43.INVENTORY_ORGANIZATION_ID, '*');
        END IF;

        tois.ORDER_BOOKING_DATE        := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_RECEIVED_DATE       := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.ORDER_TYPE_ID             := adr43.SBMT_SALES_STAT_CATEGORY_CDE;
        tois.REGTRD_DATE               := adr43.CUSTOMER_ORDER_RECV_DT;
        tois.REPORTED_AS_OF_DATE       := adr43.DATA_PROCESSED_DT;
        tois.PURCHASE_ORDER_DATE       := adr43.CUSTOMER_PURCHASE_ORDER_DT;
        tois.PURCHASE_ORDER_NBR        := adr43.CUSTOMER_PURCHASE_ORDER_ID;
        tois.PRODCN_CNTLR_EMPLOYEE_NBR := '*';

        -- derive tois.PART_PRCR_SRC_ORG_KEY_ID
        IF Scdcommonbatch.GetOrgKeyIDV4(adr43.PART_PRCR_SRC_ORG_ID,
                                        adr43.DATA_PROCESSED_DT,
                                        tois.PART_PRCR_SRC_ORG_KEY_ID) THEN
          NULL;
        END IF;

        tois.TEAM_CODE                   := '*';
        tois.STOCK_MAKE_CODE             := NVL(adr43.STOCK_MAKE_CDE, '*');
        tois.PRODUCT_CODE                := NVL(adr43.PRODUCT_CDE, '*');
        tois.PRODUCT_LINE_CODE           := NVL(adr43.PRODUCT_LINE_CDE, '*');
        tois.WW_ACCOUNT_NBR_BASE         := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 1, 8),
                                                '*');
        tois.WW_ACCOUNT_NBR_SUFFIX       := NVL(SUBSTR(adr43.WW_CUSTOMER_ACCOUNT_NBR, 9, 2), '*');
        tois.A_TERRITORY_NBR             := NVL(adr43.TERRITORY_CDE, '*');
        tois.CUSTOMER_REFERENCE_PART_NBR := adr43.CUSTOMER_PART_NBR;

        -- derive tois.CUSTOMER_CREDIT_HOLD_IND
        --IF adr43.CREDIT_CHECK_STATUS_CDE IN ('B', 'C') THEN
        --  tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
        --END IF;

        -- derive tois.TEMP_HOLD_IND
        IF adr43.DELIVERY_BLOCK_CDE = 'CH' THEN
        --  tois.CUSTOMER_CREDIT_HOLD_IND := 'H';
          NULL;
        ELSIF adr43.DELIVERY_BLOCK_CDE IS NOT NULL THEN
          tois.TEMP_HOLD_IND := 'T';
        END IF;

        -- set tois.CUSTOMER_CREDIT_HOLD_IND from adr43
        tois.CUSTOMER_CREDIT_HOLD_IND := adr43.PAYER_CR_BLOCK_STATUS_IND_CDE;
        tois.CUSTOMER_ON_CREDIT_HOLD_DATE := adr43.PAYER_CREDIT_BLOCK_ON_DT;
        tois.CUSTOMER_OFF_CREDIT_HOLD_DATE := adr43.PAYER_CREDIT_BLOCK_OFF_DT;

        -- derive tois.CUSTOMER_TYPE_CODE
        IF adr43.JUST_IN_TIME_CUSTOMER_IND = 'Y' OR
           adr43.SBMT_JUST_IN_TIME_CUSTOMER_IND = '03' THEN
          tois.CUSTOMER_TYPE_CODE := 'J';
        END IF;

        tois.INDUSTRY_CODE                  := NVL(adr43.INDUSTRY_CDE, '*');
        tois.PRODUCT_BUSNS_LINE_ID          := adr43.COMPETENCY_BSNS_CDE;
        tois.PRODUCT_BUSNS_LINE_FNCTN_ID    := NVL(adr43.COMPETENCY_BSNS_FUNC_CDE, '*');
        tois.ZERO_PART_PROD_CODE            := NVL(adr43.ZERO_PART_PRODUCT_CDE,
                                                   '*');
        tois.CUSTOMER_ACCT_TYPE_CDE         := adr43.TRADE_INTERCO_CDE;
        tois.MFR_ORG_KEY_ID                 := 0;
        tois.MFG_CAMPUS_ID                  := '*';
        tois.MFG_BUILDING_NBR               := '*';
        tois.REMAINING_QTY_TO_SHIP          := ROUND(adr43.REMAINING_TO_SHIP_QTY, 0);
        tois.INDUSTRY_BUSINESS_CODE         := adr43.INDUSTRY_BUSINESS_CDE;
        tois.SBMT_PART_NBR                  := adr43.SBMT_PART_NBR;
        tois.SBMT_CUSTOMER_ACCT_NBR         := adr43.SBMT_SHIP_TO_CUSTOMER_ID;
        tois.PROFIT_CENTER_ABBR_NM          := NVL(adr43.PROFIT_CENTER_ABBR_NM,
                                                   '*');
        tois.BRAND_ID                       := adr43.AQUISITION_FORMAT_ID;
        tois.SCHD_TYCO_MONTH_OF_YEAR_ID     := adr43.SCHD_TYCO_MONTH_OF_YEAR_ID;
        tois.SCHD_TYCO_QUARTER_ID           := adr43.SCHD_TYCO_QUARTER_ID;
        tois.SCHD_TYCO_YEAR_ID              := adr43.SCHD_TYCO_YEAR_ID;
        tois.SOLD_TO_CUSTOMER_ID            := adr43.SOLD_TO_CUSTOMER_ID;
        tois.INVOICE_NBR                    := adr43.INVOICE_NBR;
        tois.DELIVERY_BLOCK_CDE             := adr43.DELIVERY_BLOCK_CDE;
        tois.CREDIT_CHECK_STATUS_CDE        := adr43.CREDIT_CHECK_STATUS_CDE;
        tois.SALES_ORGANIZATION_ID          := adr43.SALES_ORGANIZATION_ID;
        tois.DISTRIBUTION_CHANNEL_CDE       := adr43.DISTRIBUTION_CHANNEL_CDE;
        tois.ORDER_DIVISION_CDE             := adr43.ORDER_DIVISION_CDE;
        tois.ITEM_DIVISION_CDE              := adr43.ITEM_DIVISION_CDE;
        tois.MATL_ACCOUNT_ASGN_GRP_CDE      := adr43.MATL_ACCOUNT_ASGN_GRP_CDE;
        tois.BATCH_ID                       := adr43.BATCH_ID;
        tois.DATA_SOURCE_DESC               := adr43.DATA_SOURCE_DESC;
        tois.PRIME_WORLDWIDE_CUSTOMER_ID    := adr43.PRIME_WORLDWIDE_CUSTOMER_ID;
        tois.SALES_DOCUMENT_TYPE_CDE        := adr43.SALES_DOC_TYPE_CDE;
        tois.MATERIAL_TYPE_CDE              := adr43.MATERIAL_TYPE_CDE;
        tois.DROP_SHIPMENT_IND              := adr43.DROP_SHIPMENT_IND;
        tois.SALES_OFFICE_CDE               := NVL(adr43.SALES_OFFICE_CDE, '*');
        tois.SALES_GROUP_CDE                := NVL(adr43.SALES_GROUP_CDE, '*');
        tois.SBMT_PART_PRCR_SRC_ORG_ID      := adr43.PART_PRCR_SRC_ORG_ID;
        tois.HIERARCHY_CUSTOMER_IND         := vgn_hierarchy_customer_ind;
        tois.HIERARCHY_CUSTOMER_ORG_ID      := adr43.HIERARCHY_CUSTOMER_ORG_ID;
        tois.HIERARCHY_CUSTOMER_BASE_ID     := adr43.HIERARCHY_CUSTOMER_BASE_ID;
        tois.HIERARCHY_CUSTOMER_SUFX_ID     := adr43.HIERARCHY_CUSTOMER_SUFX_ID;
        tois.PART_UM                        := adr43.UNIT_OF_MEASURE_CDE;
        tois.SBMT_ORIGINAL_SCHEDULE_DT      := adr43.ORIGINAL_SCHEDULE_DT;
        tois.SBMT_CURRENT_SCHEDULE_DT       := adr43.CURRENT_SCHEDULE_DT;
        tois.SBMT_SOLD_TO_CUSTOMER_ID       := adr43.SBMT_SOLD_TO_CUSTOMER_ID;
        tois.SCHEDULE_ON_CREDIT_HOLD_DATE   := adr43.SCHEDULE_ON_CREDIT_HOLD_DT;
        tois.SCHEDULE_OFF_CREDIT_HOLD_DATE  := adr43.SCHEDULE_OFF_CREDIT_HOLD_DT;
        tois.TEMP_HOLD_ON_DATE              := adr43.TEMP_HOLD_ON_DT;
        tois.TEMP_HOLD_OFF_DATE             := adr43.TEMP_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_ON_DT  := adr43.TYCO_CTRL_DELIVERY_HOLD_ON_DT;
        tois.TYCO_CTRL_DELIVERY_HOLD_OFF_DT := adr43.TYCO_CTRL_DELIVERY_HOLD_OFF_DT;
        tois.TYCO_CTRL_DELIVERY_BLOCK_CDE   := adr43.TYCO_CTRL_DELIVERY_BLOCK_CDE;
        tois.PICK_PACK_WORK_DAYS_QTY        := adr43.PICK_PACK_WORK_DAYS_QTY;
        tois.LOADING_NBR_OF_WORK_DAYS_QTY   := adr43.LOADING_NBR_OF_WORK_DAYS_QTY;
        tois.TRSP_LEAD_TIME_DAYS_QTY        := adr43.TRSP_LEAD_TIME_DAYS_QTY;
        tois.TRANSIT_TIME_DAYS_QTY          := adr43.TRANSIT_TIME_DAYS_QTY;
        tois.DELIVERY_ITEM_CATEGORY_CDE     := adr43.DELIVERY_ITEM_CATEGORY_CDE;
        tois.DELIVERY_IN_PROCESS_QTY        := adr43.DELIVERY_IN_PROCESS_QTY;
        tois.ORDER_HEADER_BILLING_BLOCK_CDE := adr43.ORDER_HEADER_BILLING_BLOCK_CDE;
        tois.ITEM_BILLING_BLOCK_CDE         := adr43.ITEM_BILLING_BLOCK_CDE;
        tois.FIXED_DATE_QUANTITY_IND        := adr43.FIXED_DATE_QUANTITY_IND;
        tois.SAP_BILL_TO_CUSTOMER_ID        := adr43.SAP_BILL_TO_CUSTOMER_ID;
        tois.MISC_LOCAL_FLAG_CDE_1          := adr43.MISC_LOCAL_FLAG_CDE_1;
        tois.MISC_LOCAL_CDE_1               := adr43.MISC_LOCAL_CDE_1;
        tois.MISC_LOCAL_CDE_2               := adr43.MISC_LOCAL_CDE_2;
        tois.MISC_LOCAL_CDE_3               := adr43.MISC_LOCAL_CDE_3;
        tois.CUST_ORD_REQ_RESET_REASON_CDE  := adr43.CUST_ORD_REQ_RESET_REASON_CDE;
        tois.CUST_ORD_REQ_RESET_REASON_DT   := adr43.CUST_ORD_REQ_RESET_REASON_DT;
        tois.CUSTOMER_ORDER_EDI_TYPE_CDE    := adr43.CUSTOMER_ORDER_EDI_TYPE_CDE;
        tois.ULTIMATE_END_CUSTOMER_ID       := adr43.ULTIMATE_END_CUSTOMER_ID;
        tois.ULTIMATE_END_CUST_ACCT_GRP_CDE := adr43.ULTIMATE_END_CUST_ACCT_GRP_CDE;
        tois.MRP_GROUP_CDE                  := NVL(adr43.MRP_GROUP_CDE, '*');
        tois.COMPLETE_DELIVERY_IND          := adr43.COMPLETE_DELIVERY_IND;
        tois.PART_KEY_ID                    := adr43.PART_KEY_ID;
        tois.PLANNED_INSTALLATION_CMPL_DT   := adr43.PLANNED_INSTALLATION_CMPL_DT;
        tois.SOURCE_ID                      := adr43.SOURCE_ID;
        tois.DATA_SRC_ID                    := adr43.DATA_SRC_ID;
        tois.DISTR_SHIP_WHEN_AVAIL_IND      := adr43.DISTR_SHIP_WHEN_AVAIL_IND;
        tois.SAP_PROFIT_CENTER_CDE          := adr43.SAP_PROFIT_CENTER_CDE;
        tois.STORAGE_LOCATION_ID            := adr43.STORAGE_LOCATION_ID;
        tois.SALES_TERRITORY_CDE            := adr43.SALES_TERRITORY_CDE;

        -- get values for common columns
        adr43Comm.REPORTING_ORGANIZATION_ID := adr43.REPORTING_ORGANIZATION_ID;
        adr43Comm.ORDER_NBR                 := adr43.ORDER_NBR;
        adr43Comm.ORDER_ITEM_NBR            := adr43.ORDER_ITEM_NBR;
        adr43Comm.SCHEDULE_LINE_NBR         := adr43.SCHEDULE_LINE_NBR;
        adr43Comm.DELIVERY_BLOCK_CDE        := adr43.DELIVERY_BLOCK_CDE;
        adr43Comm.CREDIT_CHECK_STATUS_CDE   := adr43.CREDIT_CHECK_STATUS_CDE;
        adr43Comm.DATA_PROCESSED_DT         := adr43.DATA_PROCESSED_DT;
        adr43Comm.DATA_SOURCE_DESC          := adr43.DATA_SOURCE_DESC;

        -- TELAG 1535 Columns
        tois.ORDER_RECEIVED_DT              := adr43.ORDER_RECEIVED_DT;
        tois.ORDER_CREATED_BY_NTWK_USER_ID  := adr43.ORDER_CREATED_BY_NTWK_USER_ID;
        tois.DELIVERY_DOC_CREATION_DT       := NULL;
        tois.DELIVERY_DOC_CREATION_TM       := NULL;
        tois.DLVR_DOC_CRET_BY_NTWK_USER_ID  := NULL;
        tois.PLANNED_GOODS_ISSUE_DT         := adr43.PLANNED_GOODS_ISSUE_DT;
        -- End TELAG Columns

        tois.PRICING_CONDITION_TYPE_CDE     := adr43.PRICING_CONDITION_TYPE_CDE;
        tois.SCHEDULE_LINE_CATEGORY_CDE     := adr43.SCHEDULE_LINE_CATEGORY_CDE;
        tois.INITIAL_REQUEST_DT             := adr43.INITIAL_REQUEST_DT;
        tois.INITIAL_REQUEST_QTY            := adr43.INITIAL_REQUEST_QTY;
        tois.DOC_ISO_CURRENCY_CDE           := adr43.SALES_DOC_ISO_CURRENCY_CDE;
        tois.DOC_CURRENCY_AMT               := adr43.LINE_ITEM_DOC_CURRENCY_AMT;
        tois.MATERIAL_AVAILABILITY_DT       := adr43.MATERIAL_AVAILABILITY_DT;

        -- Kumar 11/05/2012 Added Columns for 2012 Q1 Enhancements
        tois.CUST_PUR_ORD_LINE_ITEM_NBR_ID := adr43.CUST_PUR_ORD_LINE_ITEM_NBR_ID;
          tois.BILLING_TYPE_CDE                   := adr43.BILLING_TYPE_CDE;
          tois.EXPEDITE_INDICATOR_CDE           := adr43.EXPEDITE_INDICATOR_CDE;
          tois.EXPEDITE_STATUS_DESC             := adr43.EXPEDITE_STATUS_DESC;
        tois.MODIFIED_CUSTOMER_REQUEST_DT   := adr43.MODIFIED_CUSTOMER_REQUEST_DT; -- RB
        tois.CUSTOMER_REQUESTED_EXPEDITE_DT := adr43.CUSTOMER_REQUESTED_EXPEDITE_DT; -- RB


        -- check if need to update hold_order table
        IF vgc_oi_sl_ind IS NOT NULL THEN
          p_ins_scd_hold_orders_rec(vion_result);
          IF vion_result <> 0 THEN
            EXIT;
          END IF;
        END IF;

        -- get exclusion code
        SSA_SOURCE.SSAC1911_RECORD_EXCLUSION(0 -- GC
                                            ,
                                             tois.product_code,
                                             adr43.reporting_organization_id,
                                             adr43.ship_to_customer_key_id,
                                             adr43.line_item_local_currency_amt,
                                             tois.part_key_id,
                                             tois.remaining_qty_to_ship,
                                             adr43.matl_account_asgn_grp_cde,
                                             adr43.cust_account_asgn_group_cde,
                                             adr43.sbmt_sales_stat_category_cde,
                                             adr43.delivery_item_category_cde,
                                             tois.costed_sales_exclusion_cde);

        -- insert record to temp_order_item_shipment table
        p_insert_tois_rec(vion_result);
        IF vion_result = -6502 THEN
          RAISE VALUE_ERROR;
        ELSIF vion_result <> 0 THEN
          RAISE New_Exception;
        END IF;

        vln_commit_cnt := vln_commit_cnt + 1;
        IF vln_commit_cnt >= vin_commit_cnt THEN
          COMMIT;
          vln_commit_cnt := 0;
        END IF;
      EXCEPTION
        WHEN VALUE_ERROR THEN
          INSERT INTO SCORECARD_PROCESS_LOG
            (SCD_PROCESS_LOG_SEQ,
             SCD_PROCESS_NAME,
             DML_ORACLE_ID,
             DML_TMSTMP,
             SCD_PROCESS_LINE,
             SCD_PROCESS_TEXT)
          VALUES
            (SCD_PROCESS_LOG_SEQ.NEXTVAL,
             'ADR43 - P_EXTRACT_BACKLOG',
             vgc_job_id,
             SYSDATE,
             1,
             ('Numeric or Value Error; BATCH ID=' || vin_batch_id ||
             ' RECORD_BATCH ID=' || adr43.BATCH_RECORD_ID));
        WHEN New_Exception THEN
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BACKLOG1 - ' || vgc_job_id ||
                               ' BATCH ID=' || vin_batch_id ||
                               ' RECORD_BATCH ID=' ||
                               adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
        WHEN OTHERS THEN
          vion_result := SQLCODE;
          ROLLBACK;
          DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BACKLOG2 - ' || vgc_job_id ||
                               ' BATCH ID=' || vin_batch_id ||
                               ' RECORD_BATCH ID=' ||
                               adr43.BATCH_RECORD_ID);
          DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
          EXIT;
      END;
    END LOOP;
    COMMIT;
    CLOSE cur_backlog;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_EXTRACT_BACKLOG3 -' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_backlog;

  /************************************************************************
  * Procedure  : p_extract_scd_data
  * Description: Extract billings AND backlog records from target table and
  *     create the control record in deliver_parameter_local table.
  ************************************************************************/

  PROCEDURE p_extract_scd_data(vin_batch_id   IN TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                               vic_org_id     IN TEMP_ORDER_ITEM_SHIPMENT.SALES_ORGANIZATION_ID%TYPE,
                               vin_commit_cnt IN NUMBER,
                               vioc_org_code  IN OUT VARCHAR2,
                               vion_result    IN OUT NUMBER) IS

    vln_s1_ind     COSTED_ADR43_SUBMISSIONS.S1_IND%TYPE;
    vlc_xorgid_lst DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;

  BEGIN

    vion_result := 0;

    -- get data_src_id, hierarchy_customer_ind, S1_ind
    p_get_data_src_id(vin_batch_id,
                      vioc_org_code,
                      vgn_hierarchy_customer_ind,
                      vln_s1_ind,
                      vion_result);
    IF vion_result <> 0 THEN
      GOTO end_process;
    END IF;

    vgc_job_id   := 'SCDU' || vioc_org_code || '00';
    vgn_batch_id := vin_batch_id;

    -- get hold orders order_item/sched_line param indicator
    BEGIN
      SELECT UPPER(PARAMETER_FIELD)
        INTO vgc_oi_sl_ind
        FROM DELIVERY_PARAMETER_LOCAL
       WHERE PARAMETER_ID = 'SCD' || vioc_org_code || 'HO';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        vgc_oi_sl_ind := NULL;
      WHEN OTHERS THEN
        vion_result := SQLCODE;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('get order_item/sched_line ind -' ||
                             vgc_job_id || ' BATCH ID=' || vin_batch_id);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vion_result));
        GOTO end_process;
    END;

    -- create control records
    p_create_param_local_rec(vin_batch_id, vioc_org_code, vion_result);
    IF vion_result <> 0 THEN
      GOTO end_process;
    END IF;

    -- extract backlog/opens records
    p_extract_backlog(vin_batch_id, vin_commit_cnt, vion_result);
    IF vion_result <> 0 THEN
      GOTO end_process;
    END IF;

    -- get exclusion parameters
    vlc_xorgid_lst := Scdcommonbatch.GetParamValueLocal('SCDEXORGIDSHIPLST');
    IF INSTR(vlc_xorgid_lst, vic_org_id) > 0 THEN
      GOTO end_process; -- exclude shipments/deliveries
    END IF;

    IF vln_s1_ind = 1 THEN
      -- extract deliveries records
      p_extract_deliveries(vin_batch_id, vin_commit_cnt, vion_result);
    ELSE
      -- extract billings records
      p_extract_billings(vin_batch_id, vin_commit_cnt, vion_result);
    END IF;

    <<end_process>>
    NULL;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('p_extract_scd_data -' || vgc_job_id ||
                           ' BATCH ID=' || vin_batch_id);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));

  END p_extract_scd_data;

END PKG_EXTRACT_ADR43;
/
