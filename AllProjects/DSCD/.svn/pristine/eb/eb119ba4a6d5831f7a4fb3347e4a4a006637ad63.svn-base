CREATE OR REPLACE PACKAGE SCD_SOURCE.PKG_ORDER_ITEM_PROCESS
AS

/*
**********************************************************************************************************

* PACKAGE:     pkg_order_item_process
* DESCRIPTION: Contains procedures for processing the ORDER_ITEM_SHIPMENT
*              and ORDER_ITEM_OPEN tables.
*
* PROCEDURES:  p_process_temp_order_items
*              p_insert_order_item_open
*              p_update_order_item_open
*              p_delete_order_item_open
*              p_insert_order_item_shpmt
*              p_delete_order_item_shpmt
*              p_duplicate_order_item
*              p_get_order_item
*              p_get_cust_xref
*              p_monthly_purge
*              p_requested_backout
*              p_requested_region_backout
*              p_requested_group_backout
*              p_requested_div_backout
*              p_requested_area_backout
*              p_requested_co_backout
*              p_requested_all_backout
*              p_update_cust_ww_xref
*  ----------------------------------------------------------------------------------------------------------

* MODIFICATION LOG
*
* Date     Programmer  Description
* -------- ----------  ------------------------------------------------
* 07/01/96 RJD (CAI)   New Package
* 11/18/96 SDJ (CAI)   Add put_lines to all abends, retrieve parms
*                      from delivery_parameter_local for backout, and add parm edits for backout.
* 01/06/97 SDJ (CAI)   Add edit to p_requested_backout.  Backout to-date is a required parameter.
* 04/07/97 JAF (CAI)   ssr 3681 release 2.0  update TRADE_OR_INTERCO_CODE and pass to PKG_ADJUST_SUMMARIES.
*                      Pass INDUSTRY_CODE to PKG_ADJUST_SUMMARIES.
* 12/01/97 JGK (CAI)   ssr 3681 release 2.1  remove PART_NBR from being passed to PKG_ADJUST_SUMMARIES.
* 04/01/98 JGK (CAI)   ssr A513 add new data elements to support new MFG view.
* 05/05/98 LPZ (CAI)   ssr ???? add new data elements to support new Subcontractor view.
* 11/30/99 ALEX (RCG)  Release 5.0: Added fields for industry view AND Fiscal Dates
*                      (REMAINING_QTY_TO_SHIP,FISCAL_MONTH,FISCAL_YEAR,FISCAL_QUARTER,INDUSTRY_BUSINESS_CODE)
* 02/22/00 ALEX (RCG)  Release 5.1: Added new fields (SBMT_PART_NBR, SBMT_CUSTOMER_ACCT_NBR,PROFIT_CENTER_ID, BRAND_ID)
* 06/13/00 ALEX (RCG)  Release 5.2: Added new fields for Elec. GearBox
* 01/11/00 ALEX/Faisal Release 5.3:Changed product_busns_line_code to product_busns_line_id and
*                      product_busns_line_fnctn_code to product_busns_line_fnctn_id
* 02/12/01 Faisal      Release 5.4: Added new field PROFIT_CENTER_ABBR_NM
* 02/16/01 Faisal/Alex Release 5.5: Added new fields for fiscal dates using amp_schedule_date
* 03/14/01 Alex        Release 5.6: Added new fields for ADR43
* 04/25/01 Alex        Release 6.0: DSCD rewrite
* 10/19/01 Alex        Release 6.1: Added new field budget_rate_bk/bl_amt.
* 03/25/02 Alex        Add new hierarchy_ columns for profit center reporting.
* 04/17/02 Alex        Added PRODUCT_BUSNS_LINE_ID column into adjust_smry.
* 04/30/02 Alex        Add Cost fields.
* 04/21/02 Alex        Added new column PRODUCT_MANAGER_GLOBAL_ID
* 08/26/02 Alex        Add _schedule_date columns.
* 11/20/02 Alex        Add SALES_OFFICE_CDE, SALES_GROUP_CDE AND SOURCE_SYSTEM_ID
* 12/04/02 Alex        Add PART_UM AND SBMT_SOLD_TO_CUSTOMER_ID columns.
* 01/16/03 Alex        Add columns for Germany's SAP implementation.
* 06/23/03 Alex        Add new columns for Japan (S1) enchancments.
* 10/14/03 Alex        Add Third Party Drop-Ships Ind columns.
* 05/10/04 SAP         Add new columns for Replenishment Lead Time enhancement
* 10/11/04             Add Item Booked Dt field.
* 11/16/04 Alex        Add 2 new fields for TEPS Ultimate end customer
* 12/07/04 Alex        Add MRP Group Code and COMPLETE_DELIVERY_IND fields.
* 01/10/05 Alex        Alpha Part project.
* 09/22/05 Alex        Add new column PLANNED_INSTALLATION_CMPL_DT
* 12/30/05 Alex        Add source_id and data_src_id columns.
* 01/17/06 Alex        Remove PART_NBR column.
* 06/16/06 Alex        Add MRP_Group_Cde param. Filter enhancement - phase III.
* 09/07/06 Alex        Add DISTR_SHIP_WHEN_AVAIL_IND field.
* 10/10/07 Alex        Add logic for data security.
* 11/10/08 Alex        Add fields for Consolidated Cust Ships changes.
* 10/13/09 Alex        Add COSB exclusion code logic for backlog.
* 11/03/09 Alex        Add SAP profit center.
* 01/26/10 Alex        Add Storage Location ID AND Sales Territory code.
* 06/23/10 Alex        Add fields for Backlog enhancement (Request #520003)
* 08/18/10 Alex        Add logic to update the OIS security rec in case it already exist.
                       delete the old then re-inser the new)
* 08/24/10 Alex        Add TMS Days Qty field.
* 08/31/10 Alex        Add logic to store latest batch_id in delivery_parameter table.
* 12/02/10 Alex        Add GAM in data security.
* 12/20/10 Alex        Add Physical Bldg.
* 01/13/11 Alex        Add Forecast Prime Partner fields for Sched Agrmt phase 2.
* 04/06/11 Alex        Add logic to derive Mfg Bldg, Mfg plant, Vendor ID.
* 07/06/11 Kumar Emany Add TELAG 1535 fields and pricing_condition_type_cde to p_insert_order_item_shpmt,
*                      p_insert_order_item_open, p_update_order_item_open, p_process_temp_order_items
* 08/29/11 A. Orbeta   Add planned_goods_issue_dt as part of 1535 changes.
* 10/12/11             Add cost calculator fields for margins changes.
* 11/15/11             Change logic to derive Mfg building.
* 01/04/11 M. Feenstra Add SCHEDULE_LINE_CATEGORY_CDE and INITIAL_REQUEST_DT.
* 03/19/12 Kumar Emany Added APPEND hint to the INSERT statement of p_insert_order_item_shpmt Procedure
*                      (The table has been changed to tablespace COMPRESS)
* 04/02/12 M. Feenstra Added MATERIAL_AVAILABILITY_DT to ORDER_ITEM_OPEN.
* 06/12/12 M. Feenstra Added INITIAL_REQUEST_QTY and MATERIAL_AVAILABILITY_DT.
* 11/05/12 Kumar Emany Add BILLING_TYPE_CDE, CUST_PUR_ORD_LINE_ITEM_NBR_ID, EXPEDITE_INDICATOR_CDE, EXPEDITE_STATUS_DESC,
*                      SAP_DELIVERY_TYPE_CDE, SHIPMENT_NUMBER_ID Columns for 2012 Q1 Enhancements to
*                      p_insert_order_item_shpmt, p_insert_order_item_open, p_update_order_item_open, p_process_temp_order_items
* 05/17/13 Reddi       Added column 'MODIFIED_CUSTOMER_REQUEST_DT' to Delivery ScoreCard
* 09/03/13 Reddi       Added column 'CUSTOMER_REQUESTED_EXPEDITE_DT' to Delivery ScoreCard
***********************************************************************************************************
*/

PROCEDURE p_process_temp_order_items(vic_job_id       IN CHAR,
                                     vin_commit_count IN NUMBER,
                                     vib_purge_temp   IN BOOLEAN,
                                     vion_result      IN OUT NUMBER);

PROCEDURE p_monthly_purge(vic_job_id       IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                          vin_commit_count IN NUMBER,
                          vion_result      IN OUT NUMBER);

PROCEDURE p_requested_backout(vic_job_id       IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                              vin_commit_count IN NUMBER,
                              vion_result      IN OUT NUMBER);

END PKG_ORDER_ITEM_PROCESS;
/




CREATE OR REPLACE PACKAGE BODY SCD_SOURCE.PKG_ORDER_ITEM_PROCESS
AS

 temp_ois              TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
 order_item_ship       ORDER_ITEM_SHIPMENT%ROWTYPE;
 ois_security_rec      ORDER_ITEM_SHIP_DATA_SECURITY%ROWTYPE;
 vgn_rem_qty_to_ship   TEMP_ORDER_ITEM_SHIPMENT.REMAINING_QTY_TO_SHIP%TYPE;
 vgn_dlvry_prcs_qty    TEMP_ORDER_ITEM_SHIPMENT.DELIVERY_IN_PROCESS_QTY%TYPE;
 vgd_plan_inst_cmpl_dt TEMP_ORDER_ITEM_SHIPMENT.PLANNED_INSTALLATION_CMPL_DT%TYPE;
 temp_ship_seq         TEMP_ORDER_ITEM_SHIPMENT.TEMP_SHIP_SEQ%TYPE;
 vgc_update_code       TEMP_ORDER_ITEM_SHIPMENT.UPDATE_CODE%TYPE;
 v_sbmt_sls_ter_cde    TEMP_ORDER_ITEM_SHIPMENT.SBMT_SALES_TERRITORY_CDE%TYPE;
 v_sbmt_sls_off_cde    TEMP_ORDER_ITEM_SHIPMENT.SBMT_SALES_OFFICE_CDE%TYPE;
 v_sbmt_sls_grp_cde    TEMP_ORDER_ITEM_SHIPMENT.SBMT_SALES_GROUP_CDE%TYPE;
 v_schd_line_nbr       TEMP_ORDER_ITEM_SHIPMENT.SCHEDULE_LINE_NBR%TYPE;
 v_sbmt_schd_line_nbr  TEMP_ORDER_ITEM_SHIPMENT.SBMT_SCHEDULE_LINE_NBR%TYPE;
 v_disc_op_cde         TEMP_ORDER_ITEM_SHIPMENT.DISCONTINUED_OPERATIONS_CDE%TYPE;
 vgc_job_id            LOAD_MSG.DML_ORACLE_ID%TYPE;

 vgn_smrys_inserted NUMBER := 0;
 vgn_smrys_updated  NUMBER := 0;
 vgn_smrys_deleted  NUMBER := 0;
 vgn_sql_result     NUMBER;
 vgd_ship_date      DATE;

 ue_critical_db_error EXCEPTION;
 ue_row_not_found EXCEPTION;
 ue_duplicate_row EXCEPTION;

/*
**********************************************************************************************************
* PROCEDURE:   p_get_order_item
* DESCRIPTION: Retrieves and returns the actual_on_customer_doc_date from the order_item_shipment table
*              when the OPEN ind is FALSE; retrieves the row from the order_item_open table
*              when the OPEN ind is TRUE.
**********************************************************************************************************
*/

PROCEDURE p_get_order_item(vib_open_ind       IN BOOLEAN,
                           vin_org_key_id     IN NUMBER,
                           vic_amp_order_nbr  IN CHAR,
                           vic_order_item_nbr IN CHAR,
                           vic_shipment_id    IN CHAR,
                           vod_cust_doc_date  OUT DATE,
                           vor_rowid          OUT ROWID,
                           von_sqlcode        OUT NUMBER) IS

BEGIN
  IF vib_open_ind = TRUE THEN
    SELECT ROWID
      INTO vor_rowid
      FROM ORDER_ITEM_OPEN
     WHERE ORGANIZATION_KEY_ID = vin_org_key_id
       AND AMP_ORDER_NBR = vic_amp_order_nbr
       AND ORDER_ITEM_NBR = vic_order_item_nbr
       AND SHIPMENT_ID = vic_shipment_id;
  ELSE
    SELECT NULL, ROWID
      INTO vod_cust_doc_date, vor_rowid
      FROM ORDER_ITEM_SHIPMENT
     WHERE ORGANIZATION_KEY_ID = vin_org_key_id
       AND AMP_ORDER_NBR = vic_amp_order_nbr
       AND ORDER_ITEM_NBR = vic_order_item_nbr
       AND SHIPMENT_ID = vic_shipment_id;
  END IF;

  von_sqlcode := 0;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    von_sqlcode       := SQLCODE;
    vod_cust_doc_date := NULL;
  WHEN OTHERS THEN
    von_sqlcode       := SQLCODE;
    vod_cust_doc_date := NULL;
    DBMS_OUTPUT.PUT_LINE('P_GET_ORDER_ITEM');
    DBMS_OUTPUT.PUT_LINE('P_GET_ORDER_ITEM');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

END p_get_order_item;

/*
**********************************************************************************************************
* PROCEDURE:   p_get_cust_xref
* DESCRIPTION: Retrieves the SCORECARD_CUSTOMER_WW_XREF
**********************************************************************************************************
*/

PROCEDURE p_get_cust_xref(von_sqlcode OUT NUMBER, vor_rowid OUT ROWID) IS

  /* local variables  */
  days_early NUMBER;
  days_late  NUMBER;

BEGIN

  IF ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY IS NULL THEN
    DAYS_EARLY := 0;
  ELSE
    DAYS_EARLY := ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY;
  END IF;

  IF ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE IS NULL THEN
    DAYS_LATE := 0;
  ELSE
    DAYS_LATE := ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE;
  END IF;

  SELECT AMP_SHIPPED_DATE, ROWID
    INTO VGD_SHIP_DATE, VOR_ROWID
    FROM SCORECARD_CUSTOMER_WW_XREF
   WHERE ACCOUNTING_ORG_KEY_ID = ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID
     AND PURCHASE_BY_ACCOUNT_BASE =
         ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE
     AND SHIP_TO_ACCOUNT_SUFFIX = ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX
     AND WW_ACCOUNT_NBR_BASE = ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE
     AND WW_ACCOUNT_NBR_SUFFIX = ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX
     AND NBR_WINDOW_DAYS_EARLY = DAYS_EARLY
     AND NBR_WINDOW_DAYS_LATE = DAYS_LATE;

  von_sqlcode := 0;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    von_sqlcode := SQLCODE;
  WHEN OTHERS THEN
    von_sqlcode := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('P_GET_CUST_XREF');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

END p_get_cust_xref;

/*
**********************************************************************************************************
* PROCEDURE:   p_update_cust_ww_xref
* DESCRIPTION: update the SCORECARD_CUSTOMER_WW_XREF table for shipments.
**********************************************************************************************************
*/

PROCEDURE p_update_cust_ww_xref(vion_nbr_inserted_smrys IN OUT NUMBER,
                                vion_nbr_updated_smrys  IN OUT NUMBER,
                                von_result_code         OUT NUMBER) AS

  /* Local Variables */
  XREF_ROWID         ROWID;
  nbr_smrys_inserted NUMBER;
  nbr_smrys_updated  NUMBER;

BEGIN

  /* Initialize some variables */
  vion_nbr_inserted_smrys := 0;
  vion_nbr_updated_smrys  := 0;
  nbr_smrys_inserted      := 0;
  nbr_smrys_updated       := 0;
  von_result_code         := 0;

  /* See if customer xref exists   */
  p_get_cust_xref(VGN_SQL_RESULT, XREF_ROWID);
  IF VGN_SQL_RESULT = 100 THEN
    INSERT INTO SCORECARD_CUSTOMER_WW_XREF
    VALUES
      (ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE,
       ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX,
       ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE,
       ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX,
       NVL(ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY, 0),
       NVL(ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE, 0),
       vgc_job_id,
       SYSDATE,
       ORDER_ITEM_SHIP.AMP_SHIPPED_DATE,
       ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID);
    NBR_SMRYS_INSERTED := NBR_SMRYS_INSERTED + 1;
  ELSIF VGN_SQL_RESULT = 0 THEN
    IF ORDER_ITEM_SHIP.AMP_SHIPPED_DATE > VGD_SHIP_DATE OR
       VGD_SHIP_DATE IS NULL THEN
      UPDATE SCORECARD_CUSTOMER_WW_XREF
         SET AMP_SHIPPED_DATE = ORDER_ITEM_SHIP.AMP_SHIPPED_DATE
       WHERE ROWID = xref_rowid;
      NBR_SMRYS_UPDATED := NBR_SMRYS_UPDATED + 1;
    END IF;
  ELSE
    RAISE UE_CRITICAL_DB_ERROR;
  END IF;

  vion_nbr_inserted_smrys := nbr_smrys_inserted;
  vion_nbr_updated_smrys  := nbr_smrys_updated;

  /* log any error */

EXCEPTION
  WHEN ue_critical_db_error THEN
    von_result_code := vgn_sql_result;
  WHEN OTHERS THEN
    von_result_code := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('P_UPDATE_CUST_WW_XREF');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

END p_update_cust_ww_xref;

/*
**********************************************************************************************************
* PROCEDURE:   p_insert_ois_data_security
* DESCRIPTION: Insert a row in the ORDER_ITEM_SHIP_DATA_SECURITY table.
**********************************************************************************************************
*/

PROCEDURE p_insert_ois_data_security(von_sqlcode OUT NUMBER) IS

BEGIN

  -- Insert the new record
  INSERT INTO ORDER_ITEM_SHIP_DATA_SECURITY
    (ORGANIZATION_KEY_ID,
     AMP_ORDER_NBR,
     ORDER_ITEM_NBR,
     SHIPMENT_ID,
     DML_USER_ID,
     DML_TS,
     ORIG_HIERARCHY_CUST_ORG_ID,
     ORIG_HIERARCHY_CUST_BASE_ID,
     ORIG_HIERARCHY_CUST_SUFX_ID,
     ORIG_INDUSTRY_CDE,
     ORIG_INDUSTRY_BUSINESS_CDE,
     ORIG_IBC_PROFIT_CENTER_ID,
     ORIG_IBC_DATA_SECR_GRP_ID,
     CUR_HIERARCHY_CUST_ORG_ID,
     CUR_HIERARCHY_CUST_BASE_ID,
     CUR_HIERARCHY_CUST_SUFX_ID,
     CUR_INDUSTRY_CDE,
     CUR_INDUSTRY_BUSINESS_CDE,
     CUR_IBC_PROFIT_CENTER_ID,
     CUR_IBC_DATA_SECR_GRP_ID,
     PART_KEY_ID,
     ORIG_PRODUCT_CDE,
     ORIG_COMPETENCY_BUSINESS_CDE,
     ORIG_CBC_PROFIT_CENTER_ID,
     ORIG_CBC_DATA_SECR_GRP_ID,
     CUR_PRODUCT_CDE,
     CUR_COMPETENCY_BUSINESS_CDE,
     CUR_CBC_PROFIT_CENTER_ID,
     CUR_CBC_DATA_SECR_GRP_ID,
     ORIG_REPT_ORG_PROFIT_CENTER_ID,
     ORIGREPT_PRFT_DATA_SECR_GRP_ID,
     CUR_REPT_ORG_PROFIT_CTR_ID,
     CUR_REPT_PRFT_DATA_SECR_GRP_ID,
     ORIG_SALES_TERRITORY_NBR,
     ORIG_SALES_TERR_PROFIT_CTR_ID,
     ORIG_SLS_TERR_DATA_SECR_GRP_ID,
     CUR_SALES_TERRITORY_NBR,
     CUR_SLS_TERR_PROFIT_CTR_ID,
     CUR_SLS_TERR_DATA_SECR_GRP_ID,
     ORIG_MANAGEMENT_PROFIT_CTR_ID,
     ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
     CUR_MGE_PROFIT_CTR_ID,
     CUR_MGE_PRFT_DATA_SECR_GRP_ID,
     ORIG_DATA_SECURITY_TAG_ID,
     CUR_DATA_SECURITY_TAG_ID,
     SUPER_DATA_SECURITY_TAG_ID,
     HIERARCHY_CUSTOMER_IND,
     CUR_GBL_ACCT_CDE,
     CUR_GBL_BUSINESS_UNIT_CDE,
     CUR_GBL_BSNS_UNIT_PRFT_CTR_NM,
     CUR_GAM_DATA_SECR_GRP_ID)
  VALUES
    (order_item_ship.ORGANIZATION_KEY_ID,
     order_item_ship.AMP_ORDER_NBR,
     order_item_ship.ORDER_ITEM_NBR,
     order_item_ship.SHIPMENT_ID,
     vgc_job_id,
     SYSDATE,
     order_item_ship.HIERARCHY_CUSTOMER_ORG_ID,
     order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
     order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID,
     order_item_ship.INDUSTRY_CODE,
     order_item_ship.INDUSTRY_BUSINESS_CODE,
     temp_ois.ORIG_IBC_PROFIT_CENTER_ID,
     temp_ois.ORIG_IBC_DATA_SECR_GRP_ID,
     order_item_ship.HIERARCHY_CUSTOMER_ORG_ID, -- start copy from orig
     order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
     order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID,
     order_item_ship.INDUSTRY_CODE,
     order_item_ship.INDUSTRY_BUSINESS_CODE,
     temp_ois.ORIG_IBC_PROFIT_CENTER_ID,
     temp_ois.ORIG_IBC_DATA_SECR_GRP_ID,
     order_item_ship.PART_KEY_ID,
     order_item_ship.PRODUCT_CODE,
     order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
     temp_ois.ORIG_CBC_PROFIT_CENTER_ID,
     temp_ois.ORIG_CBC_DATA_SECR_GRP_ID,
     order_item_ship.PRODUCT_CODE, -- start copy from orig
     order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
     temp_ois.ORIG_CBC_PROFIT_CENTER_ID,
     temp_ois.ORIG_CBC_DATA_SECR_GRP_ID,
     temp_ois.ORIG_REPT_ORG_PROFIT_CENTER_ID,
     temp_ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID,
     temp_ois.ORIG_REPT_ORG_PROFIT_CENTER_ID, -- start copy from orig
     temp_ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID,
     temp_ois.ORIG_SALES_TERRITORY_NBR,
     temp_ois.ORIG_SALES_TERR_PROFIT_CTR_ID,
     temp_ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID,
     temp_ois.ORIG_SALES_TERRITORY_NBR, -- start copy from orig
     temp_ois.ORIG_SALES_TERR_PROFIT_CTR_ID,
     temp_ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID,
     order_item_ship.PROFIT_CENTER_ABBR_NM,
     temp_ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
     order_item_ship.PROFIT_CENTER_ABBR_NM, -- start copy from orig
     temp_ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
     temp_ois.ORIG_DATA_SECURITY_TAG_ID,
     temp_ois.CUR_DATA_SECURITY_TAG_ID,
     order_item_ship.SUPER_DATA_SECURITY_TAG_ID,
     order_item_ship.HIERARCHY_CUSTOMER_IND,
     ois_security_rec.CUR_GBL_ACCT_CDE,
     ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE,
     ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM,
     ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID);

  von_sqlcode := 0;

EXCEPTION
  WHEN OTHERS THEN
    von_sqlcode := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_insert_ois_data_security');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

END p_insert_ois_data_security;

/*
**********************************************************************************************************
* PROCEDURE:   p_insert_order_item_shpmt
* DESCRIPTION: Insert a row in the ORDER_ITEM_SHIPMENT table.  Adjust the summary tables.
**********************************************************************************************************
*/

PROCEDURE p_insert_order_item_shpmt(voc_action_taken        OUT CHAR,
                                    vion_nbr_inserted_smrys IN OUT NUMBER,
                                    vion_nbr_updated_smrys  IN OUT NUMBER,
                                    von_result_code         OUT NUMBER) AS

  /* Local Variables */
  curr_cust_dock_date   DATE;
  order_item_ship_rowid ROWID;
  nbr_smrys_inserted    NUMBER;
  nbr_smrys_updated     NUMBER;
  nbr_smrys_deleted     NUMBER;

BEGIN

  /* Initialize some variables */
  vion_nbr_inserted_smrys := 0;
  vion_nbr_updated_smrys  := 0;
  von_result_code         := 0;

  /* Check to see if an OPEN exists */
  p_get_order_item(FALSE,
                   order_item_ship.organization_key_id,
                   order_item_ship.amp_order_nbr,
                   order_item_ship.order_item_nbr,
                   order_item_ship.shipment_id,
                   curr_cust_dock_date,
                   order_item_ship_rowid,
                   vgn_sql_result);

  IF (vgn_sql_result = 0) THEN
    P_Write_Error(order_item_ship.organization_key_id,
                  order_item_ship.amp_order_nbr,
                  order_item_ship.order_item_nbr,
                  order_item_ship.shipment_id,
                  order_item_ship.database_load_date,
                  order_item_ship.amp_shipped_date,
                  order_item_ship.amp_schedule_date,
                  order_item_ship.part_key_id,
                  'DUPL',
                  vgc_update_code,
                  vgc_job_id,
                  0,
                  NULL);
    RAISE ue_duplicate_row;
  END IF;

  -- derive GAM security fields
  -- get GAM, GBU, AND GBU PC
  ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM := PKG_SECURITY.get_gam_pc_id(order_item_ship.HIERARCHY_CUSTOMER_ORG_ID,
                                                                               order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
                                                                               ois_security_rec.CUR_GBL_ACCT_CDE,
                                                                               ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE);

  -- get GAM dsg
  IF ois_security_rec.CUR_GBL_ACCT_CDE IS NOT NULL THEN
    ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM);
    -- get new security with GAM
    IF ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID IS NOT NULL THEN
      temp_ois.ORIG_DATA_SECURITY_TAG_ID         := get_data_security_tag1(temp_ois.ORIG_IBC_DATA_SECR_GRP_ID,
                                                                           temp_ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID,
                                                                           temp_ois.ORIG_CBC_DATA_SECR_GRP_ID,
                                                                           temp_ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID,
                                                                           temp_ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
                                                                           ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID);
      temp_ois.CUR_DATA_SECURITY_TAG_ID          := temp_ois.ORIG_DATA_SECURITY_TAG_ID;
      order_item_ship.SUPER_DATA_SECURITY_TAG_ID := temp_ois.ORIG_DATA_SECURITY_TAG_ID;
    END IF;
  ELSE
    -- set derived value to null
    ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE     := NULL;
    ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM := NULL;
    ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID      := NULL;
  END IF;

  /* Insert the new record */
  INSERT /*+ APPEND */ INTO ORDER_ITEM_SHIPMENT  -- Added APPEND Hint Kumar 03/19/2012
    (ORGANIZATION_KEY_ID,
     AMP_ORDER_NBR,
     ORDER_ITEM_NBR,
     SHIPMENT_ID,
     DML_ORACLE_ID,
     DML_TMSTMP,
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
     SCHEDULE_SHIP_CMPRSN_CODE,
     SCHEDULE_TO_SHIP_VARIANCE,
     VARBL_SCHEDULE_SHIP_VARIANCE,
     REQUEST_SHIP_CMPRSN_CODE,
     REQUEST_TO_SHIP_VARIANCE,
     VARBL_REQUEST_SHIP_VARIANCE,
     REQUEST_SCHEDULE_CMPRSN_CODE,
     REQUEST_TO_SCHEDULE_VARIANCE,
     CURRENT_TO_REQUEST_VARIANCE,
     CURRENT_TO_SCHEDULE_VARIANCE,
     RECEIVED_TO_REQUEST_VARIANCE,
     RECEIVED_TO_SCHEDULE_VARIANCE,
     RECEIVED_TO_SHIP_VARIANCE,
     VARBL_RECEIVED_SHIP_VARIANCE,
     RELEASE_TO_SCHEDULE_VARIANCE,
     RELEASE_SCHEDULE_CMPRSN_CODE,
     SHIP_FACILITY_CMPRSN_CODE,
     RELEASE_TO_SHIP_VARIANCE,
     ORDER_BOOKING_DATE,
     ORDER_RECEIVED_DATE,
     ORDER_TYPE_ID,
     REGTRD_DATE,
     REPORTED_AS_OF_DATE,
     DATABASE_LOAD_DATE,
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
     CUSTOMER_OFF_CREDIT_HOLD_DATE,
     TEMP_HOLD_IND,
     TEMP_HOLD_ON_DATE,
     TEMP_HOLD_OFF_DATE,
     CUSTOMER_TYPE_CODE,
     INDUSTRY_CODE,
     PRODUCT_BUSNS_LINE_ID,
     PRODUCT_BUSNS_LINE_FNCTN_ID,
     CUSTOMER_ACCT_TYPE_CDE,
     MFR_ORG_KEY_ID,
     MFG_CAMPUS_ID,
     MFG_BUILDING_NBR,
     FISCAL_MONTH,
     FISCAL_QUARTER,
     FISCAL_YEAR,
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
     BUDGET_RATE_BOOK_BILL_AMT,
     HIERARCHY_CUSTOMER_IND,
     HIERARCHY_CUSTOMER_ORG_ID,
     HIERARCHY_CUSTOMER_BASE_ID,
     HIERARCHY_CUSTOMER_SUFX_ID,
     GFC_EXTENDED_TRUE_AMP_COST,
     PRODUCT_MANAGER_GLOBAL_ID,
     SBMT_ORIGINAL_SCHEDULE_DT,
     SBMT_CURRENT_SCHEDULE_DT,
     PART_UM,
     SBMT_SOLD_TO_CUSTOMER_ID,
     TYCO_CTRL_DELIVERY_HOLD_ON_DT,
     TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
     TYCO_CTRL_DELIVERY_BLOCK_CDE,
     PICK_PACK_WORK_DAYS_QTY,
     LOADING_NBR_OF_WORK_DAYS_QTY,
     TRSP_LEAD_TIME_DAYS_QTY,
     TRANSIT_TIME_DAYS_QTY,
     DELIVERY_ITEM_CATEGORY_CDE,
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
     SOURCE_ID,
     DATA_SRC_ID,
     DISTR_SHIP_WHEN_AVAIL_IND,
     SUPER_DATA_SECURITY_TAG_ID,
     CONSOLIDATION_INDICATOR_CDE,
     CONSOLIDATION_DT,
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
     TRSP_MGE_TRANSIT_TIME_DAYS_QTY,
     ACTUAL_SHIP_FROM_BUILDING_ID,
     SBMT_FCST_PP_CUST_ACCT_NBR,
     FCST_PRM_PRTN_CUSTOMER_KEY_ID,
     FCST_PRM_PRTN_CUST_ACCT_NBR,
     FCST_PRM_PRTN_ACCT_GROUP_CDE,
     DEFAULT_MANUFACTURING_PLANT_ID,
     VENDOR_KEY_ID,
     VENDOR_ID,
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
     MATERIAL_AVAILABILITY_DT,
     CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 4 Columns for 2012 Q1 Enhancements
     BILLING_TYPE_CDE,
     SAP_DELIVERY_TYPE_CDE,
     SHIPMENT_NUMBER_ID)
  VALUES
    (order_item_ship.ORGANIZATION_KEY_ID,
     order_item_ship.AMP_ORDER_NBR,
     order_item_ship.ORDER_ITEM_NBR,
     order_item_ship.SHIPMENT_ID,
     vgc_job_id,
     SYSDATE,
     order_item_ship.PURCHASE_BY_ACCOUNT_BASE,
     order_item_ship.SHIP_TO_ACCOUNT_SUFFIX,
     order_item_ship.ACCOUNTING_ORG_KEY_ID,
     order_item_ship.PRODCN_CNTRLR_CODE,
     order_item_ship.ITEM_QUANTITY,
     order_item_ship.RESRVN_LEVEL_1,
     order_item_ship.RESRVN_LEVEL_5,
     order_item_ship.RESRVN_LEVEL_9,
     order_item_ship.QUANTITY_RELEASED,
     order_item_ship.QUANTITY_SHIPPED,
     order_item_ship.ISO_CURRENCY_CODE_1,
     order_item_ship.LOCAL_CURRENCY_BILLED_AMOUNT,
     order_item_ship.EXTENDED_BOOK_BILL_AMOUNT,
     order_item_ship.UNIT_PRICE,
     order_item_ship.CUSTOMER_REQUEST_DATE,
     order_item_ship.AMP_SCHEDULE_DATE,
     order_item_ship.RELEASE_DATE,
     order_item_ship.AMP_SHIPPED_DATE,
     order_item_ship.NBR_WINDOW_DAYS_EARLY,
     order_item_ship.NBR_WINDOW_DAYS_LATE,
     order_item_ship.INVENTORY_LOCATION_CODE,
     order_item_ship.INVENTORY_BUILDING_NBR,
     order_item_ship.CONTROLLER_UNIQUENESS_ID,
     order_item_ship.ACTUAL_SHIP_LOCATION,
     order_item_ship.ACTUAL_SHIP_BUILDING_NBR,
     order_item_ship.SCHEDULE_SHIP_CMPRSN_CODE,
     order_item_ship.SCHEDULE_TO_SHIP_VARIANCE,
     order_item_ship.VARBL_SCHEDULE_SHIP_VARIANCE,
     order_item_ship.REQUEST_SHIP_CMPRSN_CODE,
     order_item_ship.REQUEST_TO_SHIP_VARIANCE,
     order_item_ship.VARBL_REQUEST_SHIP_VARIANCE,
     order_item_ship.REQUEST_SCHEDULE_CMPRSN_CODE,
     order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE,
     order_item_ship.CURRENT_TO_REQUEST_VARIANCE,
     order_item_ship.CURRENT_TO_SCHEDULE_VARIANCE,
     order_item_ship.RECEIVED_TO_REQUEST_VARIANCE,
     order_item_ship.RECEIVED_TO_SCHEDULE_VARIANCE,
     order_item_ship.RECEIVED_TO_SHIP_VARIANCE,
     order_item_ship.VARBL_RECEIVED_SHIP_VARIANCE,
     order_item_ship.RELEASE_TO_SCHEDULE_VARIANCE,
     order_item_ship.RELEASE_SCHEDULE_CMPRSN_CODE,
     order_item_ship.SHIP_FACILITY_CMPRSN_CODE,
     order_item_ship.RELEASE_TO_SHIP_VARIANCE,
     order_item_ship.ORDER_BOOKING_DATE,
     order_item_ship.ORDER_RECEIVED_DATE,
     order_item_ship.ORDER_TYPE_ID,
     order_item_ship.REGTRD_DATE,
     order_item_ship.REPORTED_AS_OF_DATE,
     order_item_ship.DATABASE_LOAD_DATE,
     order_item_ship.PURCHASE_ORDER_DATE,
     order_item_ship.PURCHASE_ORDER_NBR,
     order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR,
     order_item_ship.PART_PRCR_SRC_ORG_KEY_ID,
     order_item_ship.TEAM_CODE,
     order_item_ship.STOCK_MAKE_CODE,
     order_item_ship.PRODUCT_CODE,
     order_item_ship.PRODUCT_LINE_CODE,
     order_item_ship.WW_ACCOUNT_NBR_BASE,
     order_item_ship.WW_ACCOUNT_NBR_SUFFIX,
     order_item_ship.CUSTOMER_FORECAST_CODE,
     order_item_ship.A_TERRITORY_NBR,
     order_item_ship.CUSTOMER_REFERENCE_PART_NBR,
     order_item_ship.CUSTOMER_EXPEDITE_DATE,
     order_item_ship.NBR_OF_EXPEDITES,
     order_item_ship.ORIGINAL_EXPEDITE_DATE,
     order_item_ship.CURRENT_EXPEDITE_DATE,
     order_item_ship.EARLIEST_EXPEDITE_DATE,
     order_item_ship.SCHEDULE_ON_CREDIT_HOLD_DATE,
     order_item_ship.SCHEDULE_OFF_CREDIT_HOLD_DATE,
     order_item_ship.CUSTOMER_CREDIT_HOLD_IND,
     order_item_ship.CUSTOMER_ON_CREDIT_HOLD_DATE,
     order_item_ship.CUSTOMER_OFF_CREDIT_HOLD_DATE,
     order_item_ship.TEMP_HOLD_IND,
     order_item_ship.TEMP_HOLD_ON_DATE,
     order_item_ship.TEMP_HOLD_OFF_DATE,
     order_item_ship.CUSTOMER_TYPE_CODE,
     order_item_ship.INDUSTRY_CODE,
     order_item_ship.PRODUCT_BUSNS_LINE_ID,
     order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
     order_item_ship.CUSTOMER_ACCT_TYPE_CDE,
     order_item_ship.MFR_ORG_KEY_ID,
     order_item_ship.MFG_CAMPUS_ID,
     order_item_ship.MFG_BUILDING_NBR,
     order_item_ship.FISCAL_MONTH,
     order_item_ship.FISCAL_QUARTER,
     order_item_ship.FISCAL_YEAR,
     order_item_ship.INDUSTRY_BUSINESS_CODE,
     order_item_ship.SBMT_PART_NBR,
     order_item_ship.SBMT_CUSTOMER_ACCT_NBR,
     order_item_ship.PROFIT_CENTER_ABBR_NM,
     order_item_ship.BRAND_ID,
     order_item_ship.SCHD_TYCO_MONTH_OF_YEAR_ID,
     order_item_ship.SCHD_TYCO_QUARTER_ID,
     order_item_ship.SCHD_TYCO_YEAR_ID,
     order_item_ship.SOLD_TO_CUSTOMER_ID,
     order_item_ship.INVOICE_NBR,
     order_item_ship.DELIVERY_BLOCK_CDE,
     order_item_ship.CREDIT_CHECK_STATUS_CDE,
     order_item_ship.SALES_ORGANIZATION_ID,
     order_item_ship.DISTRIBUTION_CHANNEL_CDE,
     order_item_ship.ORDER_DIVISION_CDE,
     order_item_ship.ITEM_DIVISION_CDE,
     order_item_ship.MATL_ACCOUNT_ASGN_GRP_CDE,
     order_item_ship.DATA_SOURCE_DESC,
     order_item_ship.BATCH_ID,
     order_item_ship.PRIME_WORLDWIDE_CUSTOMER_ID,
     order_item_ship.SALES_DOCUMENT_TYPE_CDE,
     order_item_ship.MATERIAL_TYPE_CDE,
     order_item_ship.DROP_SHIPMENT_IND,
     order_item_ship.SALES_OFFICE_CDE,
     order_item_ship.SALES_GROUP_CDE,
     order_item_ship.SBMT_PART_PRCR_SRC_ORG_ID,
     order_item_ship.BUDGET_RATE_BOOK_BILL_AMT,
     order_item_ship.HIERARCHY_CUSTOMER_IND,
     order_item_ship.HIERARCHY_CUSTOMER_ORG_ID,
     order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
     order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID,
     order_item_ship.GFC_EXTENDED_TRUE_AMP_COST,
     order_item_ship.PRODUCT_MANAGER_GLOBAL_ID,
     order_item_ship.SBMT_ORIGINAL_SCHEDULE_DT,
     order_item_ship.SBMT_CURRENT_SCHEDULE_DT,
     order_item_ship.PART_UM,
     order_item_ship.SBMT_SOLD_TO_CUSTOMER_ID,
     order_item_ship.TYCO_CTRL_DELIVERY_HOLD_ON_DT,
     order_item_ship.TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
     order_item_ship.TYCO_CTRL_DELIVERY_BLOCK_CDE,
     order_item_ship.PICK_PACK_WORK_DAYS_QTY,
     order_item_ship.LOADING_NBR_OF_WORK_DAYS_QTY,
     order_item_ship.TRSP_LEAD_TIME_DAYS_QTY,
     order_item_ship.TRANSIT_TIME_DAYS_QTY,
     order_item_ship.DELIVERY_ITEM_CATEGORY_CDE,
     order_item_ship.ORDER_HEADER_BILLING_BLOCK_CDE,
     order_item_ship.ITEM_BILLING_BLOCK_CDE,
     order_item_ship.FIXED_DATE_QUANTITY_IND,
     order_item_ship.SAP_BILL_TO_CUSTOMER_ID,
     order_item_ship.DELIVERY_DOCUMENT_NBR_ID,
     order_item_ship.DELIVERY_DOCUMENT_ITEM_NBR_ID,
     order_item_ship.MISC_LOCAL_FLAG_CDE_1,
     order_item_ship.MISC_LOCAL_CDE_1,
     order_item_ship.MISC_LOCAL_CDE_2,
     order_item_ship.MISC_LOCAL_CDE_3,
     order_item_ship.CUSTOMER_DATE_BASIS_CDE,
     order_item_ship.ACTUAL_DATE_BASIS_CDE,
     order_item_ship.SHIP_DATE_DETERMINATION_CDE,
     order_item_ship.CUST_ORD_REQ_RESET_REASON_CDE,
     order_item_ship.CUST_ORD_REQ_RESET_REASON_DT,
     order_item_ship.CUSTOMER_ORDER_EDI_TYPE_CDE,
     order_item_ship.ULTIMATE_END_CUSTOMER_ID,
     order_item_ship.ULTIMATE_END_CUST_ACCT_GRP_CDE,
     order_item_ship.MRP_GROUP_CDE,
     order_item_ship.COMPLETE_DELIVERY_IND,
     order_item_ship.PART_KEY_ID,
     order_item_ship.SOURCE_ID,
     order_item_ship.DATA_SRC_ID,
     order_item_ship.DISTR_SHIP_WHEN_AVAIL_IND,
     order_item_ship.SUPER_DATA_SECURITY_TAG_ID,
     order_item_ship.CONSOLIDATION_INDICATOR_CDE,
     order_item_ship.CONSOLIDATION_DT,
     order_item_ship.SAP_PROFIT_CENTER_CDE,
     order_item_ship.STORAGE_LOCATION_ID,
     order_item_ship.SALES_TERRITORY_CDE,
     order_item_ship.REQUESTED_ON_DOCK_DT,
     order_item_ship.SCHEDULED_ON_DOCK_DT,
     order_item_ship.SHIP_TO_CUSTOMER_KEY_ID,
     order_item_ship.SOLD_TO_CUSTOMER_KEY_ID,
     order_item_ship.HIERARCHY_CUSTOMER_KEY_ID,
     order_item_ship.ULTIMATE_END_CUSTOMER_KEY_ID,
     order_item_ship.BILL_OF_LADING_ID,
     order_item_ship.SBMT_FWD_AGENT_VENDOR_ID,
     order_item_ship.FWD_AGENT_VENDOR_KEY_ID,
     order_item_ship.INTL_COMMERCIAL_TERMS_CDE,
     order_item_ship.INTL_CMCL_TERM_ADDITIONAL_DESC,
     order_item_ship.SHIPPING_TRSP_CATEGORY_CDE,
     order_item_ship.HEADER_CUST_ORDER_RECEIVED_DT,
     order_item_ship.SBMT_SCHD_AGR_CANCEL_IND_CDE,
     order_item_ship.SCHD_AGR_CANCEL_INDICATOR_CDE,
     order_item_ship.CONSUMED_SA_ORDER_ITEM_NBR_ID,
     order_item_ship.CONSUMED_SA_ORDER_NUMBER_ID,
     order_item_ship.SBMT_SB_CNSN_ITRST_PRTNCUST_ID,
     order_item_ship.SB_CNSN_ITRST_PRTN_CUST_KEY_ID,
     order_item_ship.SHIPPING_CONDITIONS_CDE,
     order_item_ship.SBMT_ZI_CNSN_STK_PRTN_CUST_ID,
     order_item_ship.ZI_CNSN_STK_PRTN_CUST_KEY_ID,
     order_item_ship.TRSP_MGE_TRANSIT_TIME_DAYS_QTY,
     order_item_ship.ACTUAL_SHIP_FROM_BUILDING_ID,
     order_item_ship.SBMT_FCST_PP_CUST_ACCT_NBR,
     order_item_ship.FCST_PRM_PRTN_CUSTOMER_KEY_ID,
     order_item_ship.FCST_PRM_PRTN_CUST_ACCT_NBR,
     order_item_ship.FCST_PRM_PRTN_ACCT_GROUP_CDE,
     order_item_ship.DEFAULT_MANUFACTURING_PLANT_ID,
     order_item_ship.VENDOR_KEY_ID,
     order_item_ship.VENDOR_ID,
     order_item_ship.ORDER_RECEIVED_DT,
     order_item_ship.ORDER_CREATED_BY_NTWK_USER_ID,
     order_item_ship.DELIVERY_DOC_CREATION_DT,
     order_item_ship.DELIVERY_DOC_CREATION_TM,
     order_item_ship.DLVR_DOC_CRET_BY_NTWK_USER_ID,
     order_item_ship.PRICING_CONDITION_TYPE_CDE,
     order_item_ship.PLANNED_GOODS_ISSUE_DT,
     order_item_ship.SCHEDULE_LINE_CATEGORY_CDE,
     order_item_ship.INITIAL_REQUEST_DT,
     order_item_ship.INITIAL_REQUEST_QTY,
     temp_ois.MATERIAL_AVAILABILITY_DT,
     order_item_ship.CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 4 Columns for 2012 Q1 Enhancements
     order_item_ship.BILLING_TYPE_CDE,
     order_item_ship.SAP_DELIVERY_TYPE_CDE,
     order_item_ship.SHIPMENT_NUMBER_ID);

  von_result_code  := SQLCODE;
  voc_action_taken := 'I';

  Pkg_Adjust_Summaries.p_adjust_summaries(vgc_job_id,
                                          order_item_ship.AMP_SHIPPED_DATE,
                                          order_item_ship.ORGANIZATION_KEY_ID,
                                          order_item_ship.TEAM_CODE,
                                          order_item_ship.PRODCN_CNTRLR_CODE,
                                          order_item_ship.CONTROLLER_UNIQUENESS_ID,
                                          order_item_ship.STOCK_MAKE_CODE,
                                          order_item_ship.PRODUCT_LINE_CODE,
                                          order_item_ship.PRODUCT_CODE,
                                          order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR,
                                          order_item_ship.A_TERRITORY_NBR,
                                          order_item_ship.ACTUAL_SHIP_BUILDING_NBR,
                                          order_item_ship.ACTUAL_SHIP_LOCATION,
                                          order_item_ship.PURCHASE_BY_ACCOUNT_BASE,
                                          order_item_ship.SHIP_TO_ACCOUNT_SUFFIX,
                                          order_item_ship.WW_ACCOUNT_NBR_BASE,
                                          order_item_ship.WW_ACCOUNT_NBR_SUFFIX,
                                          order_item_ship.CUSTOMER_TYPE_CODE,
                                          order_item_ship.SHIP_FACILITY_CMPRSN_CODE,
                                          order_item_ship.RELEASE_TO_SHIP_VARIANCE,
                                          order_item_ship.SCHEDULE_TO_SHIP_VARIANCE,
                                          order_item_ship.VARBL_SCHEDULE_SHIP_VARIANCE,
                                          order_item_ship.REQUEST_TO_SHIP_VARIANCE,
                                          order_item_ship.VARBL_REQUEST_SHIP_VARIANCE,
                                          order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE,
                                          order_item_ship.CUSTOMER_ACCT_TYPE_CDE,
                                          order_item_ship.INDUSTRY_CODE,
                                          order_item_ship.MFR_ORG_KEY_ID,
                                          order_item_ship.MFG_CAMPUS_ID,
                                          order_item_ship.MFG_BUILDING_NBR,
                                          order_item_ship.INDUSTRY_BUSINESS_CODE, -- alex - added 11/99
                                          order_item_ship.ACCOUNTING_ORG_KEY_ID,
                                          order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
                                          order_item_ship.PROFIT_CENTER_ABBR_NM,
                                          order_item_ship.SOLD_TO_CUSTOMER_ID,
                                          order_item_ship.PRODUCT_BUSNS_LINE_ID,
                                          order_item_ship.PRODUCT_MANAGER_GLOBAL_ID,
                                          order_item_ship.SALES_OFFICE_CDE,
                                          order_item_ship.SALES_GROUP_CDE,
                                          Scdcommonbatch.GetSourceSystemID(order_item_ship.DATA_SOURCE_DESC),
                                          order_item_ship.MRP_GROUP_CDE,
                                          1,
                                          nbr_smrys_inserted,
                                          nbr_smrys_updated,
                                          nbr_smrys_deleted,
                                          vgn_sql_result);

  IF (vgn_sql_result <> 0) THEN
    RAISE ue_critical_db_error;
  END IF;

  vion_nbr_inserted_smrys := nbr_smrys_inserted;
  vion_nbr_updated_smrys  := nbr_smrys_updated;

  p_update_cust_ww_xref(nbr_smrys_inserted,
                        nbr_smrys_updated,
                        vgn_sql_result);
  IF (vgn_sql_result <> 0) THEN
    RAISE ue_critical_db_error;
  END IF;

  vion_nbr_inserted_smrys := vion_nbr_inserted_smrys + nbr_smrys_inserted;
  vion_nbr_updated_smrys  := vion_nbr_updated_smrys + nbr_smrys_updated;

  -- insert security rec
  p_insert_ois_data_security(vgn_sql_result);

  IF vgn_sql_result = -1 THEN
    -- duplicate in security means the same PK exist (old rec > 16 months) -- so remove it
    DELETE ORDER_ITEM_SHIP_DATA_SECURITY
     WHERE ORGANIZATION_KEY_ID = order_item_ship.ORGANIZATION_KEY_ID
       AND AMP_ORDER_NBR = order_item_ship.AMP_ORDER_NBR
       AND ORDER_ITEM_NBR = order_item_ship.ORDER_ITEM_NBR
       AND SHIPMENT_ID = order_item_ship.SHIPMENT_ID;

    -- then re-insert the new security rec
    p_insert_ois_data_security(vgn_sql_result);
  END IF;

  IF (vgn_sql_result <> 0) THEN
    RAISE ue_critical_db_error;
  END IF;

  /* log any error */

EXCEPTION
  WHEN DUP_VAL_ON_INDEX THEN
    voc_action_taken := 'P';
    von_result_code  := 0;
  WHEN ue_duplicate_row THEN
    voc_action_taken := 'E';
    von_result_code  := 0;
  WHEN ue_critical_db_error THEN
    voc_action_taken := 'E';
    von_result_code  := vgn_sql_result;
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(vion_nbr_inserted_smrys);
    DBMS_OUTPUT.PUT_LINE(vion_nbr_updated_smrys);
    voc_action_taken := 'E';
    von_result_code  := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('P_INSERT_ORDER_ITEM_SHPMT');
    DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

END p_insert_order_item_shpmt;

/*
**********************************************************************************************************
* PROCEDURE:   p_insert_order_item_open
* DESCRIPTION: Insert a row in the ORDER_ITEM_OPEN table
**********************************************************************************************************
*/

  PROCEDURE p_insert_order_item_open(voc_action_taken        OUT CHAR,
                                     vion_nbr_inserted_smrys IN OUT NUMBER,
                                     von_result_code         OUT NUMBER) AS

    /* Local Variables */
    curr_cust_dock_date   DATE;
    nbr_smrys_inserted    NUMBER;
    nbr_smrys_updated     NUMBER;
    order_item_ship_rowid ROWID;

  BEGIN

    von_result_code := 0;

    /* Check to see if an OPEN exists */
    p_get_order_item(TRUE,
                     order_item_ship.organization_key_id,
                     order_item_ship.amp_order_nbr,
                     order_item_ship.order_item_nbr,
                     order_item_ship.shipment_id,
                     curr_cust_dock_date,
                     order_item_ship_rowid,
                     vgn_sql_result);

    IF (vgn_sql_result = 0) THEN
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DUPL',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      RAISE ue_duplicate_row;
    END IF;

    /* Insert the new record */
    INSERT INTO ORDER_ITEM_OPEN
      (ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DML_ORACLE_ID,
       DML_TMSTMP,
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
       INVENTORY_LOCATION_CODE,
       INVENTORY_BUILDING_NBR,
       CONTROLLER_UNIQUENESS_ID,
       ACTUAL_SHIP_LOCATION,
       ACTUAL_SHIP_BUILDING_NBR,
       REQUEST_SCHEDULE_CMPRSN_CODE,
       REQUEST_TO_SCHEDULE_VARIANCE,
       CURRENT_TO_REQUEST_VARIANCE,
       CURRENT_TO_SCHEDULE_VARIANCE,
       RECEIVED_TO_REQUEST_VARIANCE,
       RECEIVED_TO_SCHEDULE_VARIANCE,
       RELEASE_TO_SCHEDULE_VARIANCE,
       RELEASE_SCHEDULE_CMPRSN_CODE,
       ORDER_BOOKING_DATE,
       ORDER_RECEIVED_DATE,
       ORDER_TYPE_ID,
       REGTRD_DATE,
       REPORTED_AS_OF_DATE,
       DATABASE_LOAD_DATE,
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
       TEMP_HOLD_ON_DATE,
       TEMP_HOLD_OFF_DATE,
       CUSTOMER_TYPE_CODE,
       INDUSTRY_CODE,
       PRODUCT_BUSNS_LINE_ID,
       PRODUCT_BUSNS_LINE_FNCTN_ID,
       CUSTOMER_ACCT_TYPE_CDE,
       MFR_ORG_KEY_ID,
       MFG_CAMPUS_ID,
       MFG_BUILDING_NBR,
       REMAINING_QTY_TO_SHIP,
       FISCAL_MONTH,
       FISCAL_QUARTER,
       FISCAL_YEAR,
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
       BUDGET_RATE_BOOK_BILL_AMT,
       HIERARCHY_CUSTOMER_IND,
       HIERARCHY_CUSTOMER_ORG_ID,
       HIERARCHY_CUSTOMER_BASE_ID,
       HIERARCHY_CUSTOMER_SUFX_ID,
       GFC_EXTENDED_TRUE_AMP_COST,
       PRODUCT_MANAGER_GLOBAL_ID,
       SBMT_ORIGINAL_SCHEDULE_DT,
       SBMT_CURRENT_SCHEDULE_DT,
       PART_UM,
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
       MISC_LOCAL_FLAG_CDE_1,
       MISC_LOCAL_CDE_1,
       MISC_LOCAL_CDE_2,
       MISC_LOCAL_CDE_3,
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
       DISCONTINUED_OPERATIONS_CDE,
       DEFAULT_MANUFACTURING_PLANT_ID,
       VENDOR_KEY_ID,
       VENDOR_ID,
       ORDER_RECEIVED_DT,
       ORDER_CREATED_BY_NTWK_USER_ID,
       PRICING_CONDITION_TYPE_CDE,
       PLANNED_GOODS_ISSUE_DT,
       SCHEDULE_LINE_CATEGORY_CDE,
       INITIAL_REQUEST_DT,
       INITIAL_REQUEST_QTY,
       USD_LABOR_COST_AMT,
       USD_TOT_OVHD_COST_AMT,
       USD_MFR_ENGR_COST_AMT,
       USD_TRUE_MATL_COST_AMT,
       USD_MATL_BRDN_COST_AMT,
       USD_INCO_CNTT_COST_AMT,
       CNST_TRUE_COST_AMT,
       CNST_LABOR_COST_AMT,
       CNST_TOT_OVHD_COST_AMT,
       CNST_MFR_ENGR_COST_AMT,
       CNST_TRUE_MATL_COST_AMT,
       CNST_MATL_BRDN_COST_AMT,
       CNST_INCO_CNTT_COST_AMT,
       LOCAL_CRNC_TRUE_COST_AMT,
       LOCAL_CRNC_LABOR_COST_AMT,
       LOCAL_CRNC_TOT_OVHD_COST_AMT,
       LOCAL_CRNC_MFR_ENGR_COST_AMT,
       LOCAL_CRNC_TRUE_MATL_COST_AMT,
       LOCAL_CRNC_MATL_BRDN_COST_AMT,
       LOCAL_CRNC_INCO_CNTT_COST_AMT,
       DOC_ISO_CURRENCY_CDE,
       DOC_CURRENCY_AMT,
       MATERIAL_AVAILABILITY_DT,
       CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
       -- BILLING_TYPE_CDE,
       EXPEDITE_INDICATOR_CDE,
       EXPEDITE_STATUS_DESC,
       MODIFIED_CUSTOMER_REQUEST_DT,
       CUSTOMER_REQUESTED_EXPEDITE_DT)  -- RB
    VALUES
      (order_item_ship.ORGANIZATION_KEY_ID,
       order_item_ship.AMP_ORDER_NBR,
       order_item_ship.ORDER_ITEM_NBR,
       order_item_ship.SHIPMENT_ID,
       vgc_job_id,
       SYSDATE,
       order_item_ship.PURCHASE_BY_ACCOUNT_BASE,
       order_item_ship.SHIP_TO_ACCOUNT_SUFFIX,
       order_item_ship.ACCOUNTING_ORG_KEY_ID,
       order_item_ship.PRODCN_CNTRLR_CODE,
       order_item_ship.ITEM_QUANTITY,
       order_item_ship.RESRVN_LEVEL_1,
       order_item_ship.RESRVN_LEVEL_5,
       order_item_ship.RESRVN_LEVEL_9,
       order_item_ship.QUANTITY_RELEASED,
       order_item_ship.QUANTITY_SHIPPED,
       order_item_ship.ISO_CURRENCY_CODE_1,
       order_item_ship.LOCAL_CURRENCY_BILLED_AMOUNT,
       order_item_ship.EXTENDED_BOOK_BILL_AMOUNT,
       order_item_ship.UNIT_PRICE,
       order_item_ship.CUSTOMER_REQUEST_DATE,
       order_item_ship.AMP_SCHEDULE_DATE,
       order_item_ship.RELEASE_DATE,
       order_item_ship.INVENTORY_LOCATION_CODE,
       order_item_ship.INVENTORY_BUILDING_NBR,
       order_item_ship.CONTROLLER_UNIQUENESS_ID,
       order_item_ship.ACTUAL_SHIP_LOCATION,
       order_item_ship.ACTUAL_SHIP_BUILDING_NBR,
       order_item_ship.REQUEST_SCHEDULE_CMPRSN_CODE,
       order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE,
       order_item_ship.CURRENT_TO_REQUEST_VARIANCE,
       order_item_ship.CURRENT_TO_SCHEDULE_VARIANCE,
       order_item_ship.RECEIVED_TO_REQUEST_VARIANCE,
       order_item_ship.RECEIVED_TO_SCHEDULE_VARIANCE,
       order_item_ship.RELEASE_TO_SCHEDULE_VARIANCE,
       order_item_ship.RELEASE_SCHEDULE_CMPRSN_CODE,
       order_item_ship.ORDER_BOOKING_DATE,
       order_item_ship.ORDER_RECEIVED_DATE,
       order_item_ship.ORDER_TYPE_ID,
       order_item_ship.REGTRD_DATE,
       order_item_ship.REPORTED_AS_OF_DATE,
       order_item_ship.DATABASE_LOAD_DATE,
       order_item_ship.PURCHASE_ORDER_DATE,
       order_item_ship.PURCHASE_ORDER_NBR,
       order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR,
       order_item_ship.PART_PRCR_SRC_ORG_KEY_ID,
       order_item_ship.TEAM_CODE,
       order_item_ship.STOCK_MAKE_CODE,
       order_item_ship.PRODUCT_CODE,
       order_item_ship.PRODUCT_LINE_CODE,
       order_item_ship.WW_ACCOUNT_NBR_BASE,
       order_item_ship.WW_ACCOUNT_NBR_SUFFIX,
       order_item_ship.A_TERRITORY_NBR,
       order_item_ship.CUSTOMER_REFERENCE_PART_NBR,
       order_item_ship.SCHEDULE_ON_CREDIT_HOLD_DATE,
       order_item_ship.SCHEDULE_OFF_CREDIT_HOLD_DATE,
       order_item_ship.CUSTOMER_CREDIT_HOLD_IND,
       order_item_ship.CUSTOMER_ON_CREDIT_HOLD_DATE,
       order_item_ship.CUSTOMER_OFF_CREDIT_HOLD_DATE,
       order_item_ship.TEMP_HOLD_ON_DATE,
       order_item_ship.TEMP_HOLD_OFF_DATE,
       order_item_ship.CUSTOMER_TYPE_CODE,
       order_item_ship.INDUSTRY_CODE,
       order_item_ship.PRODUCT_BUSNS_LINE_ID,
       order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
       order_item_ship.CUSTOMER_ACCT_TYPE_CDE,
       order_item_ship.MFR_ORG_KEY_ID,
       order_item_ship.MFG_CAMPUS_ID,
       order_item_ship.MFG_BUILDING_NBR,
       vgn_rem_qty_to_ship,
       order_item_ship.FISCAL_MONTH,
       order_item_ship.FISCAL_QUARTER,
       order_item_ship.FISCAL_YEAR,
       order_item_ship.INDUSTRY_BUSINESS_CODE,
       order_item_ship.SBMT_PART_NBR,
       order_item_ship.SBMT_CUSTOMER_ACCT_NBR,
       order_item_ship.PROFIT_CENTER_ABBR_NM,
       order_item_ship.BRAND_ID,
       order_item_ship.SCHD_TYCO_MONTH_OF_YEAR_ID,
       order_item_ship.SCHD_TYCO_QUARTER_ID,
       order_item_ship.SCHD_TYCO_YEAR_ID,
       order_item_ship.SOLD_TO_CUSTOMER_ID,
       order_item_ship.INVOICE_NBR,
       order_item_ship.DELIVERY_BLOCK_CDE,
       order_item_ship.CREDIT_CHECK_STATUS_CDE,
       order_item_ship.SALES_ORGANIZATION_ID,
       order_item_ship.DISTRIBUTION_CHANNEL_CDE,
       order_item_ship.ORDER_DIVISION_CDE,
       order_item_ship.ITEM_DIVISION_CDE,
       order_item_ship.MATL_ACCOUNT_ASGN_GRP_CDE,
       order_item_ship.DATA_SOURCE_DESC,
       order_item_ship.BATCH_ID,
       order_item_ship.PRIME_WORLDWIDE_CUSTOMER_ID,
       order_item_ship.SALES_DOCUMENT_TYPE_CDE,
       order_item_ship.MATERIAL_TYPE_CDE,
       order_item_ship.DROP_SHIPMENT_IND,
       order_item_ship.SALES_OFFICE_CDE,
       order_item_ship.SALES_GROUP_CDE,
       order_item_ship.SBMT_PART_PRCR_SRC_ORG_ID,
       order_item_ship.BUDGET_RATE_BOOK_BILL_AMT,
       order_item_ship.HIERARCHY_CUSTOMER_IND,
       order_item_ship.HIERARCHY_CUSTOMER_ORG_ID,
       order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
       order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID,
       order_item_ship.GFC_EXTENDED_TRUE_AMP_COST,
       order_item_ship.PRODUCT_MANAGER_GLOBAL_ID,
       order_item_ship.SBMT_ORIGINAL_SCHEDULE_DT,
       order_item_ship.SBMT_CURRENT_SCHEDULE_DT,
       order_item_ship.PART_UM,
       order_item_ship.SBMT_SOLD_TO_CUSTOMER_ID,
       order_item_ship.TYCO_CTRL_DELIVERY_HOLD_ON_DT,
       order_item_ship.TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
       order_item_ship.TYCO_CTRL_DELIVERY_BLOCK_CDE,
       order_item_ship.PICK_PACK_WORK_DAYS_QTY,
       order_item_ship.LOADING_NBR_OF_WORK_DAYS_QTY,
       order_item_ship.TRSP_LEAD_TIME_DAYS_QTY,
       order_item_ship.TRANSIT_TIME_DAYS_QTY,
       order_item_ship.DELIVERY_ITEM_CATEGORY_CDE,
       vgn_dlvry_prcs_qty,
       order_item_ship.ORDER_HEADER_BILLING_BLOCK_CDE,
       order_item_ship.ITEM_BILLING_BLOCK_CDE,
       order_item_ship.FIXED_DATE_QUANTITY_IND,
       order_item_ship.SAP_BILL_TO_CUSTOMER_ID,
       order_item_ship.MISC_LOCAL_FLAG_CDE_1,
       order_item_ship.MISC_LOCAL_CDE_1,
       order_item_ship.MISC_LOCAL_CDE_2,
       order_item_ship.MISC_LOCAL_CDE_3,
       order_item_ship.CUSTOMER_ORDER_EDI_TYPE_CDE,
       order_item_ship.ULTIMATE_END_CUSTOMER_ID,
       order_item_ship.ULTIMATE_END_CUST_ACCT_GRP_CDE,
       order_item_ship.MRP_GROUP_CDE,
       order_item_ship.COMPLETE_DELIVERY_IND,
       order_item_ship.PART_KEY_ID,
       vgd_plan_inst_cmpl_dt,
       order_item_ship.SOURCE_ID,
       order_item_ship.DATA_SRC_ID,
       order_item_ship.DISTR_SHIP_WHEN_AVAIL_IND,
       temp_ois.COSTED_SALES_EXCLUSION_CDE,
       order_item_ship.SAP_PROFIT_CENTER_CDE,
       order_item_ship.STORAGE_LOCATION_ID,
       order_item_ship.SALES_TERRITORY_CDE,
       order_item_ship.REQUESTED_ON_DOCK_DT,
       order_item_ship.SCHEDULED_ON_DOCK_DT,
       order_item_ship.SHIP_TO_CUSTOMER_KEY_ID,
       order_item_ship.SOLD_TO_CUSTOMER_KEY_ID,
       order_item_ship.HIERARCHY_CUSTOMER_KEY_ID,
       order_item_ship.ULTIMATE_END_CUSTOMER_KEY_ID,
       order_item_ship.INTL_COMMERCIAL_TERMS_CDE,
       order_item_ship.INTL_CMCL_TERM_ADDITIONAL_DESC,
       order_item_ship.SHIPPING_TRSP_CATEGORY_CDE,
       order_item_ship.HEADER_CUST_ORDER_RECEIVED_DT,
       order_item_ship.SBMT_SCHD_AGR_CANCEL_IND_CDE,
       order_item_ship.SCHD_AGR_CANCEL_INDICATOR_CDE,
       order_item_ship.CONSUMED_SA_ORDER_ITEM_NBR_ID,
       order_item_ship.CONSUMED_SA_ORDER_NUMBER_ID,
       order_item_ship.SBMT_SB_CNSN_ITRST_PRTNCUST_ID,
       order_item_ship.SB_CNSN_ITRST_PRTN_CUST_KEY_ID,
       order_item_ship.SHIPPING_CONDITIONS_CDE,
       order_item_ship.SBMT_ZI_CNSN_STK_PRTN_CUST_ID,
       order_item_ship.ZI_CNSN_STK_PRTN_CUST_KEY_ID,
       v_sbmt_sls_ter_cde,
       v_sbmt_sls_off_cde,
       v_sbmt_sls_grp_cde,
       v_schd_line_nbr,
       v_sbmt_schd_line_nbr,
       v_disc_op_cde,
       order_item_ship.DEFAULT_MANUFACTURING_PLANT_ID,
       order_item_ship.VENDOR_KEY_ID,
       order_item_ship.VENDOR_ID,
       order_item_ship.ORDER_RECEIVED_DT,
       order_item_ship.ORDER_CREATED_BY_NTWK_USER_ID,
       order_item_ship.PRICING_CONDITION_TYPE_CDE,
       order_item_ship.PLANNED_GOODS_ISSUE_DT,
       order_item_ship.SCHEDULE_LINE_CATEGORY_CDE,
       order_item_ship.INITIAL_REQUEST_DT,
       order_item_ship.INITIAL_REQUEST_QTY,
       temp_ois.USD_LABOR_COST_AMT,
       temp_ois.USD_TOT_OVHD_COST_AMT,
       temp_ois.USD_MFR_ENGR_COST_AMT,
       temp_ois.USD_TRUE_MATL_COST_AMT,
       temp_ois.USD_MATL_BRDN_COST_AMT,
       temp_ois.USD_INCO_CNTT_COST_AMT,
       temp_ois.CNST_TRUE_COST_AMT,
       temp_ois.CNST_LABOR_COST_AMT,
       temp_ois.CNST_TOT_OVHD_COST_AMT,
       temp_ois.CNST_MFR_ENGR_COST_AMT,
       temp_ois.CNST_TRUE_MATL_COST_AMT,
       temp_ois.CNST_MATL_BRDN_COST_AMT,
       temp_ois.CNST_INCO_CNTT_COST_AMT,
       temp_ois.LOCAL_CRNC_TRUE_COST_AMT,
       temp_ois.LOCAL_CRNC_LABOR_COST_AMT,
       temp_ois.LOCAL_CRNC_TOT_OVHD_COST_AMT,
       temp_ois.LOCAL_CRNC_MFR_ENGR_COST_AMT,
       temp_ois.LOCAL_CRNC_TRUE_MATL_COST_AMT,
       temp_ois.LOCAL_CRNC_MATL_BRDN_COST_AMT,
       temp_ois.LOCAL_CRNC_INCO_CNTT_COST_AMT,
       temp_ois.DOC_ISO_CURRENCY_CDE,
       temp_ois.DOC_CURRENCY_AMT,
       temp_ois.MATERIAL_AVAILABILITY_DT,
       order_item_ship.CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 4 Columns for 2012 Q1 Enhancements
       -- order_item_ship.BILLING_TYPE_CDE,
       temp_ois.EXPEDITE_INDICATOR_CDE,
       temp_ois.EXPEDITE_STATUS_DESC,
       temp_ois.MODIFIED_CUSTOMER_REQUEST_DT,
       temp_ois.CUSTOMER_REQUESTED_EXPEDITE_DT);  -- RB

    p_update_cust_ww_xref(nbr_smrys_inserted,
                          nbr_smrys_updated,
                          vgn_sql_result);
    IF (vgn_sql_result <> 0) THEN
      RAISE ue_critical_db_error;
    END IF;

    vion_nbr_inserted_smrys := nbr_smrys_inserted;
    von_result_code         := SQLCODE;
    voc_action_taken        := 'I';

    /* log any error */

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      voc_action_taken := 'P';
      von_result_code  := 0;
    WHEN ue_duplicate_row THEN
      voc_action_taken := 'E';
      von_result_code  := 0;
    WHEN OTHERS THEN
      voc_action_taken := 'E';
      von_result_code  := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_INSERT_ORDER_ITEM_OPEN');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

  END p_insert_order_item_open;

/*
**********************************************************************************************************
* PROCEDURE:  p_update_order_item_open
* DESCRIPTION: Update a row in the ORDER_ITEM_OPEN table
**********************************************************************************************************
*/

  PROCEDURE p_update_order_item_open(voc_action_taken OUT CHAR,
                                     von_result_code  OUT NUMBER) AS

  BEGIN
    von_result_code := 0;

    UPDATE ORDER_ITEM_OPEN
       SET ORGANIZATION_KEY_ID            = order_item_ship.ORGANIZATION_KEY_ID,
           AMP_ORDER_NBR                  = order_item_ship.AMP_ORDER_NBR,
           ORDER_ITEM_NBR                 = order_item_ship.ORDER_ITEM_NBR,
           SHIPMENT_ID                    = order_item_ship.SHIPMENT_ID,
           DML_ORACLE_ID                  = vgc_job_id,
           DML_TMSTMP                     = SYSDATE,
           PURCHASE_BY_ACCOUNT_BASE       = order_item_ship.PURCHASE_BY_ACCOUNT_BASE,
           SHIP_TO_ACCOUNT_SUFFIX         = order_item_ship.SHIP_TO_ACCOUNT_SUFFIX,
           ACCOUNTING_ORG_KEY_ID          = order_item_ship.ACCOUNTING_ORG_KEY_ID,
           PRODCN_CNTRLR_CODE             = order_item_ship.PRODCN_CNTRLR_CODE,
           ITEM_QUANTITY                  = order_item_ship.ITEM_QUANTITY,
           RESRVN_LEVEL_1                 = order_item_ship.RESRVN_LEVEL_1,
           RESRVN_LEVEL_5                 = order_item_ship.RESRVN_LEVEL_5,
           RESRVN_LEVEL_9                 = order_item_ship.RESRVN_LEVEL_9,
           QUANTITY_RELEASED              = order_item_ship.QUANTITY_RELEASED,
           QUANTITY_SHIPPED               = order_item_ship.QUANTITY_SHIPPED,
           ISO_CURRENCY_CODE_1            = order_item_ship.ISO_CURRENCY_CODE_1,
           LOCAL_CURRENCY_BILLED_AMOUNT   = order_item_ship.LOCAL_CURRENCY_BILLED_AMOUNT,
           EXTENDED_BOOK_BILL_AMOUNT      = order_item_ship.EXTENDED_BOOK_BILL_AMOUNT,
           UNIT_PRICE                     = order_item_ship.UNIT_PRICE,
           CUSTOMER_REQUEST_DATE          = order_item_ship.CUSTOMER_REQUEST_DATE,
           AMP_SCHEDULE_DATE              = order_item_ship.AMP_SCHEDULE_DATE,
           RELEASE_DATE                   = order_item_ship.RELEASE_DATE,
           INVENTORY_LOCATION_CODE        = order_item_ship.INVENTORY_LOCATION_CODE,
           INVENTORY_BUILDING_NBR         = order_item_ship.INVENTORY_BUILDING_NBR,
           CONTROLLER_UNIQUENESS_ID       = order_item_ship.CONTROLLER_UNIQUENESS_ID,
           ACTUAL_SHIP_LOCATION           = order_item_ship.ACTUAL_SHIP_LOCATION,
           ACTUAL_SHIP_BUILDING_NBR       = order_item_ship.ACTUAL_SHIP_BUILDING_NBR,
           REQUEST_SCHEDULE_CMPRSN_CODE   = order_item_ship.REQUEST_SCHEDULE_CMPRSN_CODE,
           REQUEST_TO_SCHEDULE_VARIANCE   = order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE,
           CURRENT_TO_REQUEST_VARIANCE    = order_item_ship.CURRENT_TO_REQUEST_VARIANCE,
           CURRENT_TO_SCHEDULE_VARIANCE   = order_item_ship.CURRENT_TO_SCHEDULE_VARIANCE,
           RECEIVED_TO_REQUEST_VARIANCE   = order_item_ship.RECEIVED_TO_REQUEST_VARIANCE,
           RECEIVED_TO_SCHEDULE_VARIANCE  = order_item_ship.RECEIVED_TO_SCHEDULE_VARIANCE,
           RELEASE_TO_SCHEDULE_VARIANCE   = order_item_ship.RELEASE_TO_SCHEDULE_VARIANCE,
           RELEASE_SCHEDULE_CMPRSN_CODE   = order_item_ship.RELEASE_SCHEDULE_CMPRSN_CODE,
           ORDER_BOOKING_DATE             = order_item_ship.ORDER_BOOKING_DATE,
           ORDER_RECEIVED_DATE            = order_item_ship.ORDER_RECEIVED_DATE,
           ORDER_TYPE_ID                  = order_item_ship.ORDER_TYPE_ID,
           REGTRD_DATE                    = order_item_ship.REGTRD_DATE,
           REPORTED_AS_OF_DATE            = order_item_ship.REPORTED_AS_OF_DATE,
           DATABASE_LOAD_DATE             = order_item_ship.DATABASE_LOAD_DATE,
           PURCHASE_ORDER_DATE            = order_item_ship.PURCHASE_ORDER_DATE,
           PURCHASE_ORDER_NBR             = order_item_ship.PURCHASE_ORDER_NBR,
           PRODCN_CNTLR_EMPLOYEE_NBR      = order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR,
           PART_PRCR_SRC_ORG_KEY_ID       = order_item_ship.PART_PRCR_SRC_ORG_KEY_ID,
           TEAM_CODE                      = order_item_ship.TEAM_CODE,
           STOCK_MAKE_CODE                = order_item_ship.STOCK_MAKE_CODE,
           PRODUCT_CODE                   = order_item_ship.PRODUCT_CODE,
           PRODUCT_LINE_CODE              = order_item_ship.PRODUCT_LINE_CODE,
           WW_ACCOUNT_NBR_BASE            = order_item_ship.WW_ACCOUNT_NBR_BASE,
           WW_ACCOUNT_NBR_SUFFIX          = order_item_ship.WW_ACCOUNT_NBR_SUFFIX,
           A_TERRITORY_NBR                = order_item_ship.A_TERRITORY_NBR,
           CUSTOMER_REFERENCE_PART_NBR    = order_item_ship.CUSTOMER_REFERENCE_PART_NBR,
           SCHEDULE_ON_CREDIT_HOLD_DATE   = order_item_ship.SCHEDULE_ON_CREDIT_HOLD_DATE,
           SCHEDULE_OFF_CREDIT_HOLD_DATE  = order_item_ship.SCHEDULE_OFF_CREDIT_HOLD_DATE,
           CUSTOMER_CREDIT_HOLD_IND       = order_item_ship.CUSTOMER_CREDIT_HOLD_IND,
           CUSTOMER_ON_CREDIT_HOLD_DATE   = order_item_ship.CUSTOMER_ON_CREDIT_HOLD_DATE,
           CUSTOMER_OFF_CREDIT_HOLD_DATE  = order_item_ship.CUSTOMER_OFF_CREDIT_HOLD_DATE,
           TEMP_HOLD_ON_DATE              = order_item_ship.TEMP_HOLD_ON_DATE,
           TEMP_HOLD_OFF_DATE             = order_item_ship.TEMP_HOLD_OFF_DATE,
           CUSTOMER_TYPE_CODE             = order_item_ship.CUSTOMER_TYPE_CODE,
           INDUSTRY_CODE                  = order_item_ship.INDUSTRY_CODE,
           PRODUCT_BUSNS_LINE_ID          = order_item_ship.PRODUCT_BUSNS_LINE_ID,
           PRODUCT_BUSNS_LINE_FNCTN_ID    = order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
           CUSTOMER_ACCT_TYPE_CDE         = order_item_ship.CUSTOMER_ACCT_TYPE_CDE,
           MFR_ORG_KEY_ID                 = order_item_ship.MFR_ORG_KEY_ID,
           MFG_CAMPUS_ID                  = order_item_ship.MFG_CAMPUS_ID,
           MFG_BUILDING_NBR               = order_item_ship.MFG_BUILDING_NBR,
           REMAINING_QTY_TO_SHIP          = vgn_rem_qty_to_ship,
           FISCAL_MONTH                   = order_item_ship.FISCAL_MONTH,
           FISCAL_QUARTER                 = order_item_ship.FISCAL_QUARTER,
           FISCAL_YEAR                    = order_item_ship.FISCAL_YEAR,
           INDUSTRY_BUSINESS_CODE         = order_item_ship.INDUSTRY_BUSINESS_CODE,
           SBMT_PART_NBR                  = order_item_ship.SBMT_PART_NBR,
           SBMT_CUSTOMER_ACCT_NBR         = order_item_ship.SBMT_CUSTOMER_ACCT_NBR,
           PROFIT_CENTER_ABBR_NM          = order_item_ship.PROFIT_CENTER_ABBR_NM,
           BRAND_ID                       = order_item_ship.BRAND_ID,
           SCHD_TYCO_MONTH_OF_YEAR_ID     = order_item_ship.SCHD_TYCO_MONTH_OF_YEAR_ID,
           SCHD_TYCO_QUARTER_ID           = order_item_ship.SCHD_TYCO_QUARTER_ID,
           SCHD_TYCO_YEAR_ID              = order_item_ship.SCHD_TYCO_YEAR_ID,
           SOLD_TO_CUSTOMER_ID            = order_item_ship.SOLD_TO_CUSTOMER_ID,
           INVOICE_NBR                    = order_item_ship.INVOICE_NBR,
           DELIVERY_BLOCK_CDE             = order_item_ship.DELIVERY_BLOCK_CDE,
           CREDIT_CHECK_STATUS_CDE        = order_item_ship.CREDIT_CHECK_STATUS_CDE,
           SALES_ORGANIZATION_ID          = order_item_ship.SALES_ORGANIZATION_ID,
           DISTRIBUTION_CHANNEL_CDE       = order_item_ship.DISTRIBUTION_CHANNEL_CDE,
           ORDER_DIVISION_CDE             = order_item_ship.ORDER_DIVISION_CDE,
           ITEM_DIVISION_CDE              = order_item_ship.ITEM_DIVISION_CDE,
           MATL_ACCOUNT_ASGN_GRP_CDE      = order_item_ship.MATL_ACCOUNT_ASGN_GRP_CDE,
           DATA_SOURCE_DESC               = order_item_ship.DATA_SOURCE_DESC,
           BATCH_ID                       = order_item_ship.BATCH_ID,
           PRIME_WORLDWIDE_CUSTOMER_ID    = order_item_ship.PRIME_WORLDWIDE_CUSTOMER_ID,
           SALES_DOCUMENT_TYPE_CDE        = order_item_ship.SALES_DOCUMENT_TYPE_CDE,
           MATERIAL_TYPE_CDE              = order_item_ship.MATERIAL_TYPE_CDE,
           DROP_SHIPMENT_IND              = order_item_ship.DROP_SHIPMENT_IND,
           SALES_OFFICE_CDE               = order_item_ship.SALES_OFFICE_CDE,
           SALES_GROUP_CDE                = order_item_ship.SALES_GROUP_CDE,
           SBMT_PART_PRCR_SRC_ORG_ID      = order_item_ship.SBMT_PART_PRCR_SRC_ORG_ID,
           BUDGET_RATE_BOOK_BILL_AMT      = order_item_ship.BUDGET_RATE_BOOK_BILL_AMT,
           HIERARCHY_CUSTOMER_IND         = order_item_ship.HIERARCHY_CUSTOMER_IND,
           HIERARCHY_CUSTOMER_ORG_ID      = order_item_ship.HIERARCHY_CUSTOMER_ORG_ID,
           HIERARCHY_CUSTOMER_BASE_ID     = order_item_ship.HIERARCHY_CUSTOMER_BASE_ID,
           HIERARCHY_CUSTOMER_SUFX_ID     = order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID,
           GFC_EXTENDED_TRUE_AMP_COST     = order_item_ship.GFC_EXTENDED_TRUE_AMP_COST,
           PRODUCT_MANAGER_GLOBAL_ID      = order_item_ship.PRODUCT_MANAGER_GLOBAL_ID,
           SBMT_ORIGINAL_SCHEDULE_DT      = order_item_ship.SBMT_ORIGINAL_SCHEDULE_DT,
           SBMT_CURRENT_SCHEDULE_DT       = order_item_ship.SBMT_CURRENT_SCHEDULE_DT,
           PART_UM                        = order_item_ship.PART_UM,
           SBMT_SOLD_TO_CUSTOMER_ID       = order_item_ship.SBMT_SOLD_TO_CUSTOMER_ID,
           TYCO_CTRL_DELIVERY_HOLD_ON_DT  = order_item_ship.TYCO_CTRL_DELIVERY_HOLD_ON_DT,
           TYCO_CTRL_DELIVERY_HOLD_OFF_DT = order_item_ship.TYCO_CTRL_DELIVERY_HOLD_OFF_DT,
           TYCO_CTRL_DELIVERY_BLOCK_CDE   = order_item_ship.TYCO_CTRL_DELIVERY_BLOCK_CDE,
           PICK_PACK_WORK_DAYS_QTY        = order_item_ship.PICK_PACK_WORK_DAYS_QTY,
           LOADING_NBR_OF_WORK_DAYS_QTY   = order_item_ship.LOADING_NBR_OF_WORK_DAYS_QTY,
           TRSP_LEAD_TIME_DAYS_QTY        = order_item_ship.TRSP_LEAD_TIME_DAYS_QTY,
           TRANSIT_TIME_DAYS_QTY          = order_item_ship.TRANSIT_TIME_DAYS_QTY,
           DELIVERY_ITEM_CATEGORY_CDE     = order_item_ship.DELIVERY_ITEM_CATEGORY_CDE,
           DELIVERY_IN_PROCESS_QTY        = vgn_dlvry_prcs_qty,
           ORDER_HEADER_BILLING_BLOCK_CDE = order_item_ship.ORDER_HEADER_BILLING_BLOCK_CDE,
           ITEM_BILLING_BLOCK_CDE         = order_item_ship.ITEM_BILLING_BLOCK_CDE,
           FIXED_DATE_QUANTITY_IND        = order_item_ship.FIXED_DATE_QUANTITY_IND,
           SAP_BILL_TO_CUSTOMER_ID        = order_item_ship.SAP_BILL_TO_CUSTOMER_ID,
           MISC_LOCAL_FLAG_CDE_1          = order_item_ship.MISC_LOCAL_FLAG_CDE_1,
           MISC_LOCAL_CDE_1               = order_item_ship.MISC_LOCAL_CDE_1,
           MISC_LOCAL_CDE_2               = order_item_ship.MISC_LOCAL_CDE_2,
           MISC_LOCAL_CDE_3               = order_item_ship.MISC_LOCAL_CDE_3,
           CUSTOMER_ORDER_EDI_TYPE_CDE    = order_item_ship.CUSTOMER_ORDER_EDI_TYPE_CDE,
           ULTIMATE_END_CUSTOMER_ID       = order_item_ship.ULTIMATE_END_CUSTOMER_ID,
           ULTIMATE_END_CUST_ACCT_GRP_CDE = order_item_ship.ULTIMATE_END_CUST_ACCT_GRP_CDE,
           MRP_GROUP_CDE                  = order_item_ship.MRP_GROUP_CDE,
           COMPLETE_DELIVERY_IND          = order_item_ship.COMPLETE_DELIVERY_IND,
           PART_KEY_ID                    = order_item_ship.PART_KEY_ID,
           PLANNED_INSTALLATION_CMPL_DT   = vgd_plan_inst_cmpl_dt,
           SOURCE_ID                      = order_item_ship.SOURCE_ID,
           DATA_SRC_ID                    = order_item_ship.DATA_SRC_ID,
           DISTR_SHIP_WHEN_AVAIL_IND      = order_item_ship.DISTR_SHIP_WHEN_AVAIL_IND,
           COSTED_SALES_EXCLUSION_CDE     = temp_ois.COSTED_SALES_EXCLUSION_CDE,
           SAP_PROFIT_CENTER_CDE          = order_item_ship.SAP_PROFIT_CENTER_CDE,
           STORAGE_LOCATION_ID            = order_item_ship.STORAGE_LOCATION_ID,
           SALES_TERRITORY_CDE            = order_item_ship.SALES_TERRITORY_CDE,
           REQUESTED_ON_DOCK_DT           = order_item_ship.REQUESTED_ON_DOCK_DT,
           SCHEDULED_ON_DOCK_DT           = order_item_ship.SCHEDULED_ON_DOCK_DT,
           SHIP_TO_CUSTOMER_KEY_ID        = order_item_ship.SHIP_TO_CUSTOMER_KEY_ID,
           SOLD_TO_CUSTOMER_KEY_ID        = order_item_ship.SOLD_TO_CUSTOMER_KEY_ID,
           HIERARCHY_CUSTOMER_KEY_ID      = order_item_ship.HIERARCHY_CUSTOMER_KEY_ID,
           ULTIMATE_END_CUSTOMER_KEY_ID   = order_item_ship.ULTIMATE_END_CUSTOMER_KEY_ID,
           INTL_COMMERCIAL_TERMS_CDE      = order_item_ship.INTL_COMMERCIAL_TERMS_CDE,
           INTL_CMCL_TERM_ADDITIONAL_DESC = order_item_ship.INTL_CMCL_TERM_ADDITIONAL_DESC,
           SHIPPING_TRSP_CATEGORY_CDE     = order_item_ship.SHIPPING_TRSP_CATEGORY_CDE,
           HEADER_CUST_ORDER_RECEIVED_DT  = order_item_ship.HEADER_CUST_ORDER_RECEIVED_DT,
           SBMT_SCHD_AGR_CANCEL_IND_CDE   = order_item_ship.SBMT_SCHD_AGR_CANCEL_IND_CDE,
           SCHD_AGR_CANCEL_INDICATOR_CDE  = order_item_ship.SCHD_AGR_CANCEL_INDICATOR_CDE,
           CONSUMED_SA_ORDER_ITEM_NBR_ID  = order_item_ship.CONSUMED_SA_ORDER_ITEM_NBR_ID,
           CONSUMED_SA_ORDER_NUMBER_ID    = order_item_ship.CONSUMED_SA_ORDER_NUMBER_ID,
           SBMT_SB_CNSN_ITRST_PRTNCUST_ID = order_item_ship.SBMT_SB_CNSN_ITRST_PRTNCUST_ID,
           SB_CNSN_ITRST_PRTN_CUST_KEY_ID = order_item_ship.SB_CNSN_ITRST_PRTN_CUST_KEY_ID,
           SHIPPING_CONDITIONS_CDE        = order_item_ship.SHIPPING_CONDITIONS_CDE,
           SBMT_ZI_CNSN_STK_PRTN_CUST_ID  = order_item_ship.SBMT_ZI_CNSN_STK_PRTN_CUST_ID,
           ZI_CNSN_STK_PRTN_CUST_KEY_ID   = order_item_ship.ZI_CNSN_STK_PRTN_CUST_KEY_ID,
           SBMT_SALES_TERRITORY_CDE       = v_sbmt_sls_ter_cde,
           SBMT_SALES_OFFICE_CDE          = v_sbmt_sls_off_cde,
           SBMT_SALES_GROUP_CDE           = v_sbmt_sls_grp_cde,
           SCHEDULE_LINE_NBR              = v_schd_line_nbr,
           SBMT_SCHEDULE_LINE_NBR         = v_sbmt_schd_line_nbr,
           DISCONTINUED_OPERATIONS_CDE    = v_disc_op_cde,
           DEFAULT_MANUFACTURING_PLANT_ID = order_item_ship.DEFAULT_MANUFACTURING_PLANT_ID,
           VENDOR_KEY_ID                  = order_item_ship.VENDOR_KEY_ID,
           VENDOR_ID                      = order_item_ship.VENDOR_ID,
           ORDER_RECEIVED_DT              = order_item_ship.ORDER_RECEIVED_DT,
           ORDER_CREATED_BY_NTWK_USER_ID  = order_item_ship.ORDER_CREATED_BY_NTWK_USER_ID,
           PRICING_CONDITION_TYPE_CDE     = order_item_ship.PRICING_CONDITION_TYPE_CDE,
           PLANNED_GOODS_ISSUE_DT         = order_item_ship.PLANNED_GOODS_ISSUE_DT,
           SCHEDULE_LINE_CATEGORY_CDE     = order_item_ship.SCHEDULE_LINE_CATEGORY_CDE,
           INITIAL_REQUEST_DT             = order_item_ship.INITIAL_REQUEST_DT,
           INITIAL_REQUEST_QTY            = order_item_ship.INITIAL_REQUEST_QTY,
           USD_LABOR_COST_AMT             = temp_ois.USD_LABOR_COST_AMT,
           USD_TOT_OVHD_COST_AMT          = temp_ois.USD_TOT_OVHD_COST_AMT,
           USD_MFR_ENGR_COST_AMT          = temp_ois.USD_MFR_ENGR_COST_AMT,
           USD_TRUE_MATL_COST_AMT         = temp_ois.USD_TRUE_MATL_COST_AMT,
           USD_MATL_BRDN_COST_AMT         = temp_ois.USD_MATL_BRDN_COST_AMT,
           USD_INCO_CNTT_COST_AMT         = temp_ois.USD_INCO_CNTT_COST_AMT,
           CNST_TRUE_COST_AMT             = temp_ois.CNST_TRUE_COST_AMT,
           CNST_LABOR_COST_AMT            = temp_ois.CNST_LABOR_COST_AMT,
           CNST_TOT_OVHD_COST_AMT         = temp_ois.CNST_TOT_OVHD_COST_AMT,
           CNST_MFR_ENGR_COST_AMT         = temp_ois.CNST_MFR_ENGR_COST_AMT,
           CNST_TRUE_MATL_COST_AMT        = temp_ois.CNST_TRUE_MATL_COST_AMT,
           CNST_MATL_BRDN_COST_AMT        = temp_ois.CNST_MATL_BRDN_COST_AMT,
           CNST_INCO_CNTT_COST_AMT        = temp_ois.CNST_INCO_CNTT_COST_AMT,
           LOCAL_CRNC_TRUE_COST_AMT       = temp_ois.LOCAL_CRNC_TRUE_COST_AMT,
           LOCAL_CRNC_LABOR_COST_AMT      = temp_ois.LOCAL_CRNC_LABOR_COST_AMT,
           LOCAL_CRNC_TOT_OVHD_COST_AMT   = temp_ois.LOCAL_CRNC_TOT_OVHD_COST_AMT,
           LOCAL_CRNC_MFR_ENGR_COST_AMT   = temp_ois.LOCAL_CRNC_MFR_ENGR_COST_AMT,
           LOCAL_CRNC_TRUE_MATL_COST_AMT  = temp_ois.LOCAL_CRNC_TRUE_MATL_COST_AMT,
           LOCAL_CRNC_MATL_BRDN_COST_AMT  = temp_ois.LOCAL_CRNC_MATL_BRDN_COST_AMT,
           LOCAL_CRNC_INCO_CNTT_COST_AMT  = temp_ois.LOCAL_CRNC_INCO_CNTT_COST_AMT,
           DOC_ISO_CURRENCY_CDE           = temp_ois.DOC_ISO_CURRENCY_CDE,
           DOC_CURRENCY_AMT               = temp_ois.DOC_CURRENCY_AMT,
           MATERIAL_AVAILABILITY_DT       = temp_ois.MATERIAL_AVAILABILITY_DT,
           CUST_PUR_ORD_LINE_ITEM_NBR_ID  = order_item_ship.CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 4 Columns for 2012 Q1 Enhancements
       -- BILLING_TYPE_CDE              = order_item_ship.BILLING_TYPE_CDE,
       EXPEDITE_INDICATOR_CDE          = temp_ois.EXPEDITE_INDICATOR_CDE,
       EXPEDITE_STATUS_DESC              = temp_ois.EXPEDITE_STATUS_DESC,
     MODIFIED_CUSTOMER_REQUEST_DT   = temp_ois.MODIFIED_CUSTOMER_REQUEST_DT,
     CUSTOMER_REQUESTED_EXPEDITE_DT = temp_ois.CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
     WHERE ORGANIZATION_KEY_ID = order_item_ship.ORGANIZATION_KEY_ID
       AND AMP_ORDER_NBR = order_item_ship.AMP_ORDER_NBR
       AND ORDER_ITEM_NBR = order_item_ship.ORDER_ITEM_NBR
       AND SHIPMENT_ID = order_item_ship.SHIPMENT_ID;

    IF SQL%NOTFOUND THEN
      /* Can't find record to update */
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'NOTF',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      RAISE ue_row_not_found;
    END IF;

    von_result_code  := SQLCODE;
    voc_action_taken := 'U';

    /* log any error */

  EXCEPTION
    WHEN ue_row_not_found THEN
      voc_action_taken := 'E';
      von_result_code  := 0;
    WHEN OTHERS THEN
      voc_action_taken := 'E';
      von_result_code  := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_UPDATE_ORDER_ITEM_OPEN');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

  END p_update_order_item_open;

/*
**********************************************************************************************************
* PROCEDURE:  p_delete_order_item_shpmt
* DESCRIPTION: Delete a row in the ORDER_ITEM_SHIPMENT table.  Adjust the summary tables.
**********************************************************************************************************
*/

  PROCEDURE p_delete_order_item_shpmt(voc_action_taken       OUT CHAR,
                                      vion_nbr_updated_smrys IN OUT NUMBER,
                                      vion_nbr_deleted_smrys IN OUT NUMBER,
                                      von_result_code        OUT NUMBER) AS

    /* Local Variables */
    nbr_smrys_inserted NUMBER;
    nbr_smrys_updated  NUMBER;
    nbr_smrys_deleted  NUMBER;

  BEGIN

    /* Initialize some variables */
    vion_nbr_updated_smrys := 0;
    vion_nbr_deleted_smrys := 0;
    von_result_code        := 0;

    /* Delete the detail record */
    DELETE FROM ORDER_ITEM_SHIPMENT
     WHERE ORGANIZATION_KEY_ID = order_item_ship.ORGANIZATION_KEY_ID
       AND AMP_ORDER_NBR = order_item_ship.AMP_ORDER_NBR
       AND ORDER_ITEM_NBR = order_item_ship.ORDER_ITEM_NBR
       AND SHIPMENT_ID = order_item_ship.SHIPMENT_ID;

    IF SQL%NOTFOUND THEN
      /* Can't find record to update */
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'NOTF',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      RAISE ue_row_not_found;
    END IF;

    von_result_code  := SQLCODE;
    voc_action_taken := 'D';

    /* Adjust Summaries */
    Pkg_Adjust_Summaries.p_adjust_summaries(vgc_job_id,
                                            order_item_ship.AMP_SHIPPED_DATE,
                                            order_item_ship.ORGANIZATION_KEY_ID,
                                            order_item_ship.TEAM_CODE,
                                            order_item_ship.PRODCN_CNTRLR_CODE,
                                            order_item_ship.CONTROLLER_UNIQUENESS_ID,
                                            order_item_ship.STOCK_MAKE_CODE,
                                            order_item_ship.PRODUCT_LINE_CODE,
                                            order_item_ship.PRODUCT_CODE,
                                            order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR,
                                            order_item_ship.A_TERRITORY_NBR,
                                            order_item_ship.ACTUAL_SHIP_BUILDING_NBR,
                                            order_item_ship.ACTUAL_SHIP_LOCATION,
                                            order_item_ship.PURCHASE_BY_ACCOUNT_BASE,
                                            order_item_ship.SHIP_TO_ACCOUNT_SUFFIX,
                                            order_item_ship.WW_ACCOUNT_NBR_BASE,
                                            order_item_ship.WW_ACCOUNT_NBR_SUFFIX,
                                            order_item_ship.CUSTOMER_TYPE_CODE,
                                            order_item_ship.SHIP_FACILITY_CMPRSN_CODE,
                                            order_item_ship.RELEASE_TO_SHIP_VARIANCE,
                                            order_item_ship.SCHEDULE_TO_SHIP_VARIANCE,
                                            order_item_ship.VARBL_SCHEDULE_SHIP_VARIANCE,
                                            order_item_ship.REQUEST_TO_SHIP_VARIANCE,
                                            order_item_ship.VARBL_REQUEST_SHIP_VARIANCE,
                                            order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE,
                                            order_item_ship.CUSTOMER_ACCT_TYPE_CDE,
                                            order_item_ship.INDUSTRY_CODE,
                                            order_item_ship.MFR_ORG_KEY_ID,
                                            order_item_ship.MFG_CAMPUS_ID,
                                            order_item_ship.MFG_BUILDING_NBR,
                                            order_item_ship.INDUSTRY_BUSINESS_CODE, -- alex - added 11/99
                                            order_item_ship.ACCOUNTING_ORG_KEY_ID,
                                            order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID,
                                            order_item_ship.PROFIT_CENTER_ABBR_NM,
                                            order_item_ship.SOLD_TO_CUSTOMER_ID,
                                            order_item_ship.PRODUCT_BUSNS_LINE_ID,
                                            order_item_ship.PRODUCT_MANAGER_GLOBAL_ID,
                                            order_item_ship.SALES_OFFICE_CDE,
                                            order_item_ship.SALES_GROUP_CDE,
                                            Scdcommonbatch.GetSourceSystemID(order_item_ship.DATA_SOURCE_DESC),
                                            order_item_ship.MRP_GROUP_CDE,
                                            -1, -- pass -1 to mean a detail record is being removed
                                            nbr_smrys_inserted,
                                            nbr_smrys_updated,
                                            nbr_smrys_deleted,
                                            vgn_sql_result);
    IF (vgn_sql_result <> 0) THEN
      RAISE ue_critical_db_error;
    END IF;

    vion_nbr_updated_smrys := nbr_smrys_updated;
    vion_nbr_deleted_smrys := nbr_smrys_deleted;

    -- Delete the corresponding security detail record
    DELETE FROM ORDER_ITEM_SHIP_DATA_SECURITY
     WHERE ORGANIZATION_KEY_ID = order_item_ship.ORGANIZATION_KEY_ID
       AND AMP_ORDER_NBR = order_item_ship.AMP_ORDER_NBR
       AND ORDER_ITEM_NBR = order_item_ship.ORDER_ITEM_NBR
       AND SHIPMENT_ID = order_item_ship.SHIPMENT_ID;

    IF SQL%NOTFOUND THEN
      /* Can't find record to update */
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'NOTS',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      -- nothing to delete since record not in table
      von_result_code := 0;
    ELSE
      von_result_code := SQLCODE;
    END IF;

    /* log any error */

  EXCEPTION
    WHEN ue_row_not_found THEN
      voc_action_taken := 'E';
      von_result_code  := 0;
    WHEN ue_critical_db_error THEN
      voc_action_taken := 'E';
      von_result_code  := vgn_sql_result;
    WHEN OTHERS THEN
      voc_action_taken := 'E';
      von_result_code  := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_DELETE_ORDER_ITEM_SHPMT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

  END p_delete_order_item_shpmt;

/*
**********************************************************************************************************
* PROCEDURE:  p_delete_order_item_open
* DESCRIPTION: Delete a row in the ORDER_ITEM_OPEN table
**********************************************************************************************************
*/

  PROCEDURE p_delete_order_item_open(voc_action_taken OUT CHAR,
                                     von_result_code  OUT NUMBER) AS

  BEGIN

    von_result_code := 0;

    /* Delete the detail row */
    DELETE FROM ORDER_ITEM_OPEN
     WHERE ORGANIZATION_KEY_ID = order_item_ship.ORGANIZATION_KEY_ID
       AND AMP_ORDER_NBR = order_item_ship.AMP_ORDER_NBR
       AND ORDER_ITEM_NBR = order_item_ship.ORDER_ITEM_NBR
       AND SHIPMENT_ID = order_item_ship.SHIPMENT_ID;

    IF SQL%NOTFOUND THEN
      /* Can't find record to update */
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'NOTF',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      RAISE ue_row_not_found;
    END IF;

    von_result_code  := SQLCODE;
    voc_action_taken := 'D';

    /* log any error */

  EXCEPTION
    WHEN ue_row_not_found THEN
      voc_action_taken := 'E';
      von_result_code  := 0;
    WHEN OTHERS THEN
      voc_action_taken := 'E';
      von_result_code  := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_DELETE_ORDER_ITEM_OPEN');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));

  END p_delete_order_item_open;

/*
**********************************************************************************************************
* PROCEDURE:   p_duplicate_order_item
* DESCRIPTION: If the duplicate row is an OPEN, insert a row in load_msg.  If the duplicate row is a
*              SHIPMENT and customer on dock date changed, update the row; otherwise, insert a row in load_msg.
**********************************************************************************************************
*/

  PROCEDURE p_duplicate_order_item(voc_action_taken OUT CHAR,
                                   von_result_code  OUT NUMBER) IS

    /* Local Variables */
    curr_cust_dock_date   DATE;
    order_item_ship_rowid ROWID;

  BEGIN

    von_result_code := 0;
    IF order_item_ship.AMP_SHIPPED_DATE IS NULL THEN
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DUPL',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
      RAISE ue_duplicate_row;
    END IF;

    /* Get the on dock date. */
    p_get_order_item(FALSE,
                     order_item_ship.organization_key_id,
                     order_item_ship.amp_order_nbr,
                     order_item_ship.order_item_nbr,
                     order_item_ship.shipment_id,
                     curr_cust_dock_date,
                     order_item_ship_rowid,
                     vgn_sql_result);
    IF (vgn_sql_result <> 0) THEN
      RAISE ue_critical_db_error;
    END IF;

    /* Record already exists. */
    P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DUPL',
                    vgc_update_code,
                    vgc_job_id,
                    0,
                    NULL);
    RAISE ue_duplicate_row;

    von_result_code := 0;

  EXCEPTION
    WHEN ue_duplicate_row THEN
      voc_action_taken := 'E';
      von_result_code  := 0;
    WHEN ue_critical_db_error THEN
      voc_action_taken := 'E';
      von_result_code  := vgn_sql_result;
    WHEN OTHERS THEN
      voc_action_taken := 'E';
      von_result_code  := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_DUPLICATE_ORDER_ITEM');

      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_duplicate_order_item;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_region_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters: Region code and
*              database load date between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_region_backout(vid_from_date    DATE,
                                       vid_to_date      DATE,
                                       vic_region_code  ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                       vin_commit_count IN NUMBER,
                                       vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_region_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT a.*
        FROM ORDER_ITEM_SHIPMENT a
       WHERE EXISTS
       (SELECT '1'
                FROM ORGANIZATIONS_DMN
               WHERE ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                 AND (LAYER1_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER2_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER3_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER4_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER5_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER6_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER7_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER8_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER9_ORGANIZATION_ID = cvc_region_org_code OR
                     LAYER10_ORGANIZATION_ID = cvc_region_org_code)
                 AND ((EFFECTIVE_FROM_DT <= cvd_from_date AND
                     EFFECTIVE_TO_DT >= cvd_from_date) OR
                     (EFFECTIVE_FROM_DT <= cvd_to_date AND
                     EFFECTIVE_TO_DT >= cvd_to_date)))
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_region_code,
                                 vid_from_date,
                                 vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      /* Delete this record */
      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;

      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_region_code,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER' -- Status
                   ,
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_REGION_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
  END p_requested_region_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_group_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters: Group code and
*              database load date between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_group_backout(vid_from_date    DATE,
                                      vid_to_date      DATE,
                                      vic_group_code   ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                      vin_commit_count IN NUMBER,
                                      vion_result      IN OUT NUMBER) IS
    CURSOR cur_order_item_ship_row(cvc_group_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT a.*
        FROM ORDER_ITEM_SHIPMENT a
       WHERE EXISTS
       (SELECT '1'
                FROM ORGANIZATIONS_DMN
               WHERE ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                 AND (LAYER1_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER2_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER3_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER4_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER5_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER6_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER7_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER8_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER9_ORGANIZATION_ID = cvc_group_org_code OR
                     LAYER10_ORGANIZATION_ID = cvc_group_org_code)
                 AND ((EFFECTIVE_FROM_DT <= cvd_from_date AND
                     EFFECTIVE_TO_DT >= cvd_from_date) OR
                     (EFFECTIVE_FROM_DT <= cvd_to_date AND
                     EFFECTIVE_TO_DT >= cvd_to_date)))
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_group_code,
                                 vid_from_date,
                                 vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_group_code,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_GROUP_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_group_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_div_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters: Div code and
*              database load date between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_div_backout(vid_from_date    DATE,
                                    vid_to_date      DATE,
                                    vic_div_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                    vin_commit_count IN NUMBER,
                                    vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_div_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT a.*
        FROM ORDER_ITEM_SHIPMENT a
       WHERE EXISTS
       (SELECT '1'
                FROM ORGANIZATIONS_DMN
               WHERE ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                 AND (LAYER1_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER2_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER3_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER4_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER5_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER6_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER7_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER8_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER9_ORGANIZATION_ID = cvc_div_org_code OR
                     LAYER10_ORGANIZATION_ID = cvc_div_org_code)
                 AND ((EFFECTIVE_FROM_DT <= cvd_from_date AND
                     EFFECTIVE_TO_DT >= cvd_from_date) OR
                     (EFFECTIVE_FROM_DT <= cvd_to_date AND
                     EFFECTIVE_TO_DT >= cvd_to_date)))
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_div_org_code,
                                 vid_from_date,
                                 vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_div_org_code,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_DIV_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_div_backout;

  PROCEDURE p_requested_job_backout(vid_from_date    DATE,
                                    vid_to_date      DATE,
                                    vic_job_name     ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                                    vin_commit_count IN NUMBER,
                                    vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_job_name ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT *
        FROM ORDER_ITEM_SHIPMENT
       WHERE DML_ORACLE_ID = cvc_job_name
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_job_name, vid_from_date, vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_job_name,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_JOB_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_job_backout;

  PROCEDURE p_requested_batch_backout(vid_from_date    DATE,
                                      vid_to_date      DATE,
                                      vic_batch_id     ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE,
                                      vin_commit_count IN NUMBER,
                                      vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_batch_id ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT *
        FROM ORDER_ITEM_SHIPMENT
       WHERE BATCH_ID = cvc_batch_id
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_batch_id, vid_from_date, vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_batch_id,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_BATCH_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_batch_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_area_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters: Area code and
*              database load date between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_area_backout(vid_from_date     DATE,
                                     vid_to_date       DATE,
                                     vic_area_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                     vin_commit_count  IN NUMBER,
                                     vion_result       IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_area_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT a.*
        FROM ORDER_ITEM_SHIPMENT a
       WHERE EXISTS
       (SELECT '1'
                FROM ORGANIZATIONS_DMN
               WHERE ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                 AND (LAYER1_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER2_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER3_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER4_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER5_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER6_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER7_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER8_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER9_ORGANIZATION_ID = cvc_area_org_code OR
                     LAYER10_ORGANIZATION_ID = cvc_area_org_code)
                 AND ((EFFECTIVE_FROM_DT <= cvd_from_date AND
                     EFFECTIVE_TO_DT >= cvd_from_date) OR
                     (EFFECTIVE_FROM_DT <= cvd_to_date AND
                     EFFECTIVE_TO_DT >= cvd_to_date)))
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_area_org_code,
                                 vid_from_date,
                                 vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_area_org_code,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_AREA_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_area_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_co_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters: Div code and
*              database load date  between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_co_backout(vid_from_date    DATE,
                                   vid_to_date      DATE,
                                   vic_co_org_code  ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                   vin_commit_count IN NUMBER,
                                   vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvc_co_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE, cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT a.*
        FROM ORDER_ITEM_SHIPMENT a
       WHERE EXISTS
       (SELECT '1'
                FROM ORGANIZATIONS_DMN
               WHERE ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                 AND (LAYER1_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER2_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER3_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER4_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER5_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER6_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER7_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER8_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER9_ORGANIZATION_ID = cvc_co_org_code OR
                     LAYER10_ORGANIZATION_ID = cvc_co_org_code)
                 AND ((EFFECTIVE_FROM_DT <= cvd_from_date AND
                     EFFECTIVE_TO_DT >= cvd_from_date) OR
                     (EFFECTIVE_FROM_DT <= cvd_to_date AND
                     EFFECTIVE_TO_DT >= cvd_to_date)))
         AND (DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date)
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vic_co_org_code,
                                 vid_from_date,
                                 vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vic_co_org_code,
                                     vid_from_date,
                                     vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_CO_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_co_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_requested_all_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows that meet the specified parameters:
*              database load date between the from_date and the to_date.
**********************************************************************************************************
*/

  PROCEDURE p_requested_all_backout(vid_from_date    DATE,
                                    vid_to_date      DATE,
                                    vin_commit_count IN NUMBER,
                                    vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(cvd_from_date DATE, cvd_to_date DATE) IS
      SELECT *
        FROM ORDER_ITEM_SHIPMENT
       WHERE DATABASE_LOAD_DATE BETWEEN cvd_from_date AND cvd_to_date
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;

  BEGIN

    OPEN cur_order_item_ship_row(vid_from_date, vid_to_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(vid_from_date, vid_to_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    DBMS_OUTPUT.PUT_LINE('OIS Deleted: ' || num_rows_processed);
    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED,
       UPDATE_TYPE,
       SQL_ERROR_CODE,
       SQL_ERROR_MSG)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted,
       NULL,
       NULL,
       NULL);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_ALL_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_requested_all_backout;

/*
**********************************************************************************************************
* PROCEDURE:   p_process_temp_order_items
* DESCRIPTION: Processes the TEMP_ORDER_ITEM_SHIPMENT table.
*              Depending on the update code, an Insert, Update or Delete procedure will be called.
*              After each record is processed, it is deleted from the temp table (if the vib_purge_temp parameter is TRUE).
**********************************************************************************************************
*/

  PROCEDURE p_process_temp_order_items(vic_job_id       IN CHAR,
                                       vin_commit_count IN NUMBER,
                                       vib_purge_temp   IN BOOLEAN,
                                       vion_result      IN OUT NUMBER) AS

    action                   CHAR;
    commit_count             NUMBER := 0;
    num_rows_processed       NUMBER := 0;
    num_order_items_inserted NUMBER := 0;
    num_order_items_updated  NUMBER := 0;
    num_order_items_deleted  NUMBER := 0;
    num_summaries_inserted   NUMBER := 0;
    num_summaries_updated    NUMBER := 0;
    num_summaries_deleted    NUMBER := 0;
    temp_rowid               ROWID;

    v_curr_batch_id  TEMP_ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE := 0;
    v_param_batch_id DELIVERY_PARAMETER.PARAMETER_FIELD%TYPE;
    v_rptorg_id      temp_order_item_shipment.hierarchy_customer_org_id%TYPE;
    v_proc_type_cde  gcs_frozen_cost_v.gfc_procurement_type_cde%TYPE;
    v_rpt_dt         DATE;
    v_plant_id       temp_order_item_shipment.actual_ship_building_nbr%TYPE;

    /* Cursor on all records in the TEMP_ORDER_ITEM_SHIPMENT table */
    CURSOR cur_temp_row IS
      SELECT -- /*+ INDEX_ASC(TEMP_ORDER_ITEM_SHIPMENT TOIS_PK) */
       TEMP_SHIP_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       UPDATE_CODE,
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
       SCHEDULE_SHIP_CMPRSN_CODE,
       SCHEDULE_TO_SHIP_VARIANCE,
       VARBL_SCHEDULE_SHIP_VARIANCE,
       REQUEST_SHIP_CMPRSN_CODE,
       REQUEST_TO_SHIP_VARIANCE,
       VARBL_REQUEST_SHIP_VARIANCE,
       REQUEST_SCHEDULE_CMPRSN_CODE,
       REQUEST_TO_SCHEDULE_VARIANCE,
       CURRENT_TO_REQUEST_VARIANCE,
       CURRENT_TO_SCHEDULE_VARIANCE,
       RECEIVED_TO_REQUEST_VARIANCE,
       RECEIVED_TO_SCHEDULE_VARIANCE,
       RECEIVED_TO_SHIP_VARIANCE,
       VARBL_RECEIVED_SHIP_VARIANCE,
       RELEASE_TO_SCHEDULE_VARIANCE,
       RELEASE_SCHEDULE_CMPRSN_CODE,
       SHIP_FACILITY_CMPRSN_CODE,
       RELEASE_TO_SHIP_VARIANCE,
       ORDER_BOOKING_DATE,
       ORDER_RECEIVED_DATE,
       ORDER_TYPE_ID,
       REGTRD_DATE,
       REPORTED_AS_OF_DATE,
       DATABASE_LOAD_DATE,
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
       CUSTOMER_OFF_CREDIT_HOLD_DATE,
       TEMP_HOLD_IND,
       TEMP_HOLD_ON_DATE,
       TEMP_HOLD_OFF_DATE,
       CUSTOMER_TYPE_CODE,
       INDUSTRY_CODE,
       PRODUCT_BUSNS_LINE_ID,
       PRODUCT_BUSNS_LINE_FNCTN_ID,
       CUSTOMER_ACCT_TYPE_CDE,
       MFR_ORG_KEY_ID,
       MFG_CAMPUS_ID,
       MFG_BUILDING_NBR,
       REMAINING_QTY_TO_SHIP,
       FISCAL_MONTH,
       FISCAL_QUARTER,
       FISCAL_YEAR,
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
       BUDGET_RATE_BOOK_BILL_AMT,
       HIERARCHY_CUSTOMER_IND,
       HIERARCHY_CUSTOMER_ORG_ID,
       HIERARCHY_CUSTOMER_BASE_ID,
       HIERARCHY_CUSTOMER_SUFX_ID,
       GFC_EXTENDED_TRUE_AMP_COST,
       PRODUCT_MANAGER_GLOBAL_ID,
       SBMT_ORIGINAL_SCHEDULE_DT,
       SBMT_CURRENT_SCHEDULE_DT,
       PART_UM,
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
       ORIG_IBC_PROFIT_CENTER_ID,
       ORIG_IBC_DATA_SECR_GRP_ID,
       ORIG_CBC_PROFIT_CENTER_ID,
       ORIG_CBC_DATA_SECR_GRP_ID,
       ORIG_REPT_ORG_PROFIT_CENTER_ID,
       ORIGREPT_PRFT_DATA_SECR_GRP_ID,
       ORIG_SALES_TERRITORY_NBR,
       ORIG_SALES_TERR_PROFIT_CTR_ID,
       ORIG_SLS_TERR_DATA_SECR_GRP_ID,
       ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
       ORIG_DATA_SECURITY_TAG_ID,
       CUR_DATA_SECURITY_TAG_ID,
       SUPER_DATA_SECURITY_TAG_ID,
       CONSOLIDATION_INDICATOR_CDE,
       CONSOLIDATION_DT,
       COSTED_SALES_EXCLUSION_CDE,
       SAP_PROFIT_CENTER_CDE,
       STORAGE_LOCATION_ID,
       SALES_TERRITORY_CDE,
       ROWID,
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
       USD_LABOR_COST_AMT,
       USD_TOT_OVHD_COST_AMT,
       USD_MFR_ENGR_COST_AMT,
       USD_TRUE_MATL_COST_AMT,
       USD_MATL_BRDN_COST_AMT,
       USD_INCO_CNTT_COST_AMT,
       CNST_TRUE_COST_AMT,
       CNST_LABOR_COST_AMT,
       CNST_TOT_OVHD_COST_AMT,
       CNST_MFR_ENGR_COST_AMT,
       CNST_TRUE_MATL_COST_AMT,
       CNST_MATL_BRDN_COST_AMT,
       CNST_INCO_CNTT_COST_AMT,
       LOCAL_CRNC_TRUE_COST_AMT,
       LOCAL_CRNC_LABOR_COST_AMT,
       LOCAL_CRNC_TOT_OVHD_COST_AMT,
       LOCAL_CRNC_MFR_ENGR_COST_AMT,
       LOCAL_CRNC_TRUE_MATL_COST_AMT,
       LOCAL_CRNC_MATL_BRDN_COST_AMT,
       LOCAL_CRNC_INCO_CNTT_COST_AMT,
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
       CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
        FROM TEMP_ORDER_ITEM_SHIPMENT
       WHERE DML_ORACLE_ID = vgc_job_id
         AND UPDATE_CODE IS NOT NULL
         AND ROWNUM < (vin_commit_count + 1);

  BEGIN

    vgc_job_id := vic_job_id;
    /* Open Cursor to process all temp rows */
    OPEN cur_temp_row;
    LOOP
      FETCH cur_temp_row
        INTO temp_ship_seq
      , order_item_ship.DML_ORACLE_ID
      , order_item_ship.DML_TMSTMP
      , vgc_update_code
      , order_item_ship.ORGANIZATION_KEY_ID
      , order_item_ship.AMP_ORDER_NBR
      , order_item_ship.ORDER_ITEM_NBR
      , order_item_ship.SHIPMENT_ID
      , order_item_ship.PURCHASE_BY_ACCOUNT_BASE
      , order_item_ship.SHIP_TO_ACCOUNT_SUFFIX
      , order_item_ship.ACCOUNTING_ORG_KEY_ID
      , order_item_ship.PRODCN_CNTRLR_CODE
      , order_item_ship.ITEM_QUANTITY
      , order_item_ship.RESRVN_LEVEL_1
      , order_item_ship.RESRVN_LEVEL_5
      , order_item_ship.RESRVN_LEVEL_9
      , order_item_ship.QUANTITY_RELEASED
      , order_item_ship.QUANTITY_SHIPPED
      , order_item_ship.ISO_CURRENCY_CODE_1
      , order_item_ship.LOCAL_CURRENCY_BILLED_AMOUNT
      , order_item_ship.EXTENDED_BOOK_BILL_AMOUNT
      , order_item_ship.UNIT_PRICE
      , order_item_ship.CUSTOMER_REQUEST_DATE
      , order_item_ship.AMP_SCHEDULE_DATE
      , order_item_ship.RELEASE_DATE
      , order_item_ship.AMP_SHIPPED_DATE
      , order_item_ship.NBR_WINDOW_DAYS_EARLY
      , order_item_ship.NBR_WINDOW_DAYS_LATE
      , order_item_ship.INVENTORY_LOCATION_CODE
      , order_item_ship.INVENTORY_BUILDING_NBR
      , order_item_ship.CONTROLLER_UNIQUENESS_ID
      , order_item_ship.ACTUAL_SHIP_LOCATION
      , order_item_ship.ACTUAL_SHIP_BUILDING_NBR
      , order_item_ship.SCHEDULE_SHIP_CMPRSN_CODE
      , order_item_ship.SCHEDULE_TO_SHIP_VARIANCE
      , order_item_ship.VARBL_SCHEDULE_SHIP_VARIANCE
      , order_item_ship.REQUEST_SHIP_CMPRSN_CODE
      , order_item_ship.REQUEST_TO_SHIP_VARIANCE
      , order_item_ship.VARBL_REQUEST_SHIP_VARIANCE
      , order_item_ship.REQUEST_SCHEDULE_CMPRSN_CODE
      , order_item_ship.REQUEST_TO_SCHEDULE_VARIANCE
      , order_item_ship.CURRENT_TO_REQUEST_VARIANCE
      , order_item_ship.CURRENT_TO_SCHEDULE_VARIANCE
      , order_item_ship.RECEIVED_TO_REQUEST_VARIANCE
      , order_item_ship.RECEIVED_TO_SCHEDULE_VARIANCE
      , order_item_ship.RECEIVED_TO_SHIP_VARIANCE
      , order_item_ship.VARBL_RECEIVED_SHIP_VARIANCE
      , order_item_ship.RELEASE_TO_SCHEDULE_VARIANCE
      , order_item_ship.RELEASE_SCHEDULE_CMPRSN_CODE
      , order_item_ship.SHIP_FACILITY_CMPRSN_CODE
      , order_item_ship.RELEASE_TO_SHIP_VARIANCE
      , order_item_ship.ORDER_BOOKING_DATE
      , order_item_ship.ORDER_RECEIVED_DATE
      , order_item_ship.ORDER_TYPE_ID
      , order_item_ship.REGTRD_DATE
      , order_item_ship.REPORTED_AS_OF_DATE
      , order_item_ship.DATABASE_LOAD_DATE
      , order_item_ship.PURCHASE_ORDER_DATE
      , order_item_ship.PURCHASE_ORDER_NBR
      , order_item_ship.PRODCN_CNTLR_EMPLOYEE_NBR
      , order_item_ship.PART_PRCR_SRC_ORG_KEY_ID
      , order_item_ship.TEAM_CODE
      , order_item_ship.STOCK_MAKE_CODE
      , order_item_ship.PRODUCT_CODE
      , order_item_ship.PRODUCT_LINE_CODE
      , order_item_ship.WW_ACCOUNT_NBR_BASE
      , order_item_ship.WW_ACCOUNT_NBR_SUFFIX
      , order_item_ship.CUSTOMER_FORECAST_CODE
      , order_item_ship.A_TERRITORY_NBR
      , order_item_ship.CUSTOMER_REFERENCE_PART_NBR
      , order_item_ship.CUSTOMER_EXPEDITE_DATE
      , order_item_ship.NBR_OF_EXPEDITES
      , order_item_ship.ORIGINAL_EXPEDITE_DATE
      , order_item_ship.CURRENT_EXPEDITE_DATE
      , order_item_ship.EARLIEST_EXPEDITE_DATE
      , order_item_ship.SCHEDULE_ON_CREDIT_HOLD_DATE
      , order_item_ship.SCHEDULE_OFF_CREDIT_HOLD_DATE
      , order_item_ship.CUSTOMER_CREDIT_HOLD_IND
      , order_item_ship.CUSTOMER_ON_CREDIT_HOLD_DATE
      , order_item_ship.CUSTOMER_OFF_CREDIT_HOLD_DATE
      , order_item_ship.TEMP_HOLD_IND
      , order_item_ship.TEMP_HOLD_ON_DATE
      , order_item_ship.TEMP_HOLD_OFF_DATE
      , order_item_ship.CUSTOMER_TYPE_CODE
      , order_item_ship.INDUSTRY_CODE
      , order_item_ship.PRODUCT_BUSNS_LINE_ID
      , order_item_ship.PRODUCT_BUSNS_LINE_FNCTN_ID
      , order_item_ship.CUSTOMER_ACCT_TYPE_CDE
      , order_item_ship.MFR_ORG_KEY_ID
      , order_item_ship.MFG_CAMPUS_ID
      , order_item_ship.MFG_BUILDING_NBR
      , vgn_rem_qty_to_ship
      , order_item_ship.FISCAL_MONTH
      , order_item_ship.FISCAL_QUARTER
      , order_item_ship.FISCAL_YEAR
      , order_item_ship.INDUSTRY_BUSINESS_CODE
      , order_item_ship.SBMT_PART_NBR
      , order_item_ship.SBMT_CUSTOMER_ACCT_NBR
      , order_item_ship.PROFIT_CENTER_ABBR_NM
      , order_item_ship.BRAND_ID
      , order_item_ship.SCHD_TYCO_MONTH_OF_YEAR_ID
      , order_item_ship.SCHD_TYCO_QUARTER_ID
      , order_item_ship.SCHD_TYCO_YEAR_ID
      , order_item_ship.SOLD_TO_CUSTOMER_ID
      , order_item_ship.INVOICE_NBR
      , order_item_ship.DELIVERY_BLOCK_CDE
      , order_item_ship.CREDIT_CHECK_STATUS_CDE
      , order_item_ship.SALES_ORGANIZATION_ID
      , order_item_ship.DISTRIBUTION_CHANNEL_CDE
      , order_item_ship.ORDER_DIVISION_CDE
      , order_item_ship.ITEM_DIVISION_CDE
      , order_item_ship.MATL_ACCOUNT_ASGN_GRP_CDE
      , order_item_ship.DATA_SOURCE_DESC
      , order_item_ship.BATCH_ID
      , order_item_ship.PRIME_WORLDWIDE_CUSTOMER_ID
      , order_item_ship.SALES_DOCUMENT_TYPE_CDE
      , order_item_ship.MATERIAL_TYPE_CDE
      , order_item_ship.DROP_SHIPMENT_IND
      , order_item_ship.SALES_OFFICE_CDE
      , order_item_ship.SALES_GROUP_CDE
      , order_item_ship.SBMT_PART_PRCR_SRC_ORG_ID
      , order_item_ship.BUDGET_RATE_BOOK_BILL_AMT
      , order_item_ship.HIERARCHY_CUSTOMER_IND
      , order_item_ship.HIERARCHY_CUSTOMER_ORG_ID
      , order_item_ship.HIERARCHY_CUSTOMER_BASE_ID
      , order_item_ship.HIERARCHY_CUSTOMER_SUFX_ID
      , order_item_ship.GFC_EXTENDED_TRUE_AMP_COST
      , order_item_ship.PRODUCT_MANAGER_GLOBAL_ID
      , order_item_ship.SBMT_ORIGINAL_SCHEDULE_DT
      , order_item_ship.SBMT_CURRENT_SCHEDULE_DT
      , order_item_ship.PART_UM
      , order_item_ship.SBMT_SOLD_TO_CUSTOMER_ID
      , order_item_ship.TYCO_CTRL_DELIVERY_HOLD_ON_DT
      , order_item_ship.TYCO_CTRL_DELIVERY_HOLD_OFF_DT
      , order_item_ship.TYCO_CTRL_DELIVERY_BLOCK_CDE
      , order_item_ship.PICK_PACK_WORK_DAYS_QTY
      , order_item_ship.LOADING_NBR_OF_WORK_DAYS_QTY
      , order_item_ship.TRSP_LEAD_TIME_DAYS_QTY
      , order_item_ship.TRANSIT_TIME_DAYS_QTY
      , order_item_ship.DELIVERY_ITEM_CATEGORY_CDE
      , vgn_dlvry_prcs_qty
      , order_item_ship.ORDER_HEADER_BILLING_BLOCK_CDE
      , order_item_ship.ITEM_BILLING_BLOCK_CDE
      , order_item_ship.FIXED_DATE_QUANTITY_IND
      , order_item_ship.SAP_BILL_TO_CUSTOMER_ID
      , order_item_ship.DELIVERY_DOCUMENT_NBR_ID
      , order_item_ship.DELIVERY_DOCUMENT_ITEM_NBR_ID
      , order_item_ship.MISC_LOCAL_FLAG_CDE_1
      , order_item_ship.MISC_LOCAL_CDE_1
      , order_item_ship.MISC_LOCAL_CDE_2
      , order_item_ship.MISC_LOCAL_CDE_3
      , order_item_ship.CUSTOMER_DATE_BASIS_CDE
      , order_item_ship.ACTUAL_DATE_BASIS_CDE
      , order_item_ship.SHIP_DATE_DETERMINATION_CDE
      , order_item_ship.CUST_ORD_REQ_RESET_REASON_CDE
      , order_item_ship.CUST_ORD_REQ_RESET_REASON_DT
      , order_item_ship.CUSTOMER_ORDER_EDI_TYPE_CDE
      , order_item_ship.ULTIMATE_END_CUSTOMER_ID
      , order_item_ship.ULTIMATE_END_CUST_ACCT_GRP_CDE
      , order_item_ship.MRP_GROUP_CDE
      , order_item_ship.COMPLETE_DELIVERY_IND
      , order_item_ship.PART_KEY_ID
      , vgd_plan_inst_cmpl_dt
      , order_item_ship.SOURCE_ID
      , order_item_ship.DATA_SRC_ID
      , order_item_ship.DISTR_SHIP_WHEN_AVAIL_IND
      , temp_ois.ORIG_IBC_PROFIT_CENTER_ID
      , temp_ois.ORIG_IBC_DATA_SECR_GRP_ID
      , temp_ois.ORIG_CBC_PROFIT_CENTER_ID
      , temp_ois.ORIG_CBC_DATA_SECR_GRP_ID
      , temp_ois.ORIG_REPT_ORG_PROFIT_CENTER_ID
      , temp_ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID
      , temp_ois.ORIG_SALES_TERRITORY_NBR
      , temp_ois.ORIG_SALES_TERR_PROFIT_CTR_ID
      , temp_ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID
      , temp_ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
      , temp_ois.ORIG_DATA_SECURITY_TAG_ID
      , temp_ois.CUR_DATA_SECURITY_TAG_ID
      , order_item_ship.SUPER_DATA_SECURITY_TAG_ID
      , order_item_ship.CONSOLIDATION_INDICATOR_CDE
      , order_item_ship.CONSOLIDATION_DT
      , temp_ois.COSTED_SALES_EXCLUSION_CDE
      , order_item_ship.SAP_PROFIT_CENTER_CDE
      , order_item_ship.STORAGE_LOCATION_ID
      , order_item_ship.SALES_TERRITORY_CDE
      , temp_rowid
      , order_item_ship.REQUESTED_ON_DOCK_DT
      , order_item_ship.SCHEDULED_ON_DOCK_DT
      , order_item_ship.SHIP_TO_CUSTOMER_KEY_ID
      , order_item_ship.SOLD_TO_CUSTOMER_KEY_ID
      , order_item_ship.HIERARCHY_CUSTOMER_KEY_ID
      , order_item_ship.ULTIMATE_END_CUSTOMER_KEY_ID
      , order_item_ship.BILL_OF_LADING_ID
      , order_item_ship.SBMT_FWD_AGENT_VENDOR_ID
      , order_item_ship.FWD_AGENT_VENDOR_KEY_ID
      , order_item_ship.INTL_COMMERCIAL_TERMS_CDE
      , order_item_ship.INTL_CMCL_TERM_ADDITIONAL_DESC
      , order_item_ship.SHIPPING_TRSP_CATEGORY_CDE
      , order_item_ship.HEADER_CUST_ORDER_RECEIVED_DT
      , order_item_ship.SBMT_SCHD_AGR_CANCEL_IND_CDE
      , order_item_ship.SCHD_AGR_CANCEL_INDICATOR_CDE
      , order_item_ship.CONSUMED_SA_ORDER_ITEM_NBR_ID
      , order_item_ship.CONSUMED_SA_ORDER_NUMBER_ID
      , order_item_ship.SBMT_SB_CNSN_ITRST_PRTNCUST_ID
      , order_item_ship.SB_CNSN_ITRST_PRTN_CUST_KEY_ID
      , order_item_ship.SHIPPING_CONDITIONS_CDE
      , order_item_ship.SBMT_ZI_CNSN_STK_PRTN_CUST_ID
      , order_item_ship.ZI_CNSN_STK_PRTN_CUST_KEY_ID
      , v_sbmt_sls_ter_cde
      , v_sbmt_sls_off_cde
      , v_sbmt_sls_grp_cde
      , v_schd_line_nbr
      , v_sbmt_schd_line_nbr
      , order_item_ship.TRSP_MGE_TRANSIT_TIME_DAYS_QTY
      , v_disc_op_cde
      , order_item_ship.actual_ship_from_building_id
      , order_item_ship.SBMT_FCST_PP_CUST_ACCT_NBR
      , order_item_ship.FCST_PRM_PRTN_CUSTOMER_KEY_ID
      , order_item_ship.FCST_PRM_PRTN_CUST_ACCT_NBR
      , order_item_ship.FCST_PRM_PRTN_ACCT_GROUP_CDE
      , order_item_ship.ORDER_RECEIVED_DT
      , order_item_ship.ORDER_CREATED_BY_NTWK_USER_ID
      , order_item_ship.DELIVERY_DOC_CREATION_DT
      , order_item_ship.DELIVERY_DOC_CREATION_TM
      , order_item_ship.DLVR_DOC_CRET_BY_NTWK_USER_ID
      , order_item_ship.PRICING_CONDITION_TYPE_CDE
      , order_item_ship.PLANNED_GOODS_ISSUE_DT
      , order_item_ship.SCHEDULE_LINE_CATEGORY_CDE
      , order_item_ship.INITIAL_REQUEST_DT
      , order_item_ship.INITIAL_REQUEST_QTY
      , temp_ois.USD_LABOR_COST_AMT
      , temp_ois.USD_TOT_OVHD_COST_AMT
      , temp_ois.USD_MFR_ENGR_COST_AMT
      , temp_ois.USD_TRUE_MATL_COST_AMT
      , temp_ois.USD_MATL_BRDN_COST_AMT
      , temp_ois.USD_INCO_CNTT_COST_AMT
      , temp_ois.CNST_TRUE_COST_AMT
      , temp_ois.CNST_LABOR_COST_AMT
      , temp_ois.CNST_TOT_OVHD_COST_AMT
      , temp_ois.CNST_MFR_ENGR_COST_AMT
      , temp_ois.CNST_TRUE_MATL_COST_AMT
      , temp_ois.CNST_MATL_BRDN_COST_AMT
      , temp_ois.CNST_INCO_CNTT_COST_AMT
      , temp_ois.LOCAL_CRNC_TRUE_COST_AMT
      , temp_ois.LOCAL_CRNC_LABOR_COST_AMT
      , temp_ois.LOCAL_CRNC_TOT_OVHD_COST_AMT
      , temp_ois.LOCAL_CRNC_MFR_ENGR_COST_AMT
      , temp_ois.LOCAL_CRNC_TRUE_MATL_COST_AMT
      , temp_ois.LOCAL_CRNC_MATL_BRDN_COST_AMT
      , temp_ois.LOCAL_CRNC_INCO_CNTT_COST_AMT
      , temp_ois.DOC_ISO_CURRENCY_CDE
      , temp_ois.DOC_CURRENCY_AMT
      , temp_ois.MATERIAL_AVAILABILITY_DT
      , order_item_ship.CUST_PUR_ORD_LINE_ITEM_NBR_ID -- Kumar 11/06/2012 Added below 6 Columns for 2012 Q1 Enhancements
      , order_item_ship.BILLING_TYPE_CDE
      , order_item_ship.SAP_DELIVERY_TYPE_CDE
      , order_item_ship.SHIPMENT_NUMBER_ID
      , temp_ois.EXPEDITE_INDICATOR_CDE
      , temp_ois.EXPEDITE_STATUS_DESC
      , temp_ois.MODIFIED_CUSTOMER_REQUEST_DT
      , temp_ois.CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
      ;

      /* Exit loop when there are no more records to process. */
      EXIT WHEN(cur_temp_row%NOTFOUND);

      vgn_smrys_inserted := 0;
      vgn_smrys_updated  := 0;
      vgn_smrys_deleted  := 0;
      vgn_sql_result     := 0;

      IF (order_item_ship.CURRENT_TO_REQUEST_VARIANCE = 0) AND
         (order_item_ship.CURRENT_TO_SCHEDULE_VARIANCE = 0) THEN
        order_item_ship.REPORTED_AS_OF_DATE := NULL;
      END IF;

      -- mfg bldg logic is for SAP only
      --IF order_item_ship.data_source_desc = 'TYCOSAPABC' THEN
      -- now it should include all
      -- init derived fields
      order_item_ship.default_manufacturing_plant_id := null;
      order_item_ship.vendor_id                      := null;
      order_item_ship.vendor_key_id                  := null;

      -- derive mfg bldg/plant first
      IF Scdcommonbatch.get_mfg_bldg_plant(order_item_ship.mfr_org_key_id,
                                           order_item_ship.part_key_id,
                                           order_item_ship.mfg_building_nbr,
                                           order_item_ship.default_manufacturing_plant_id) THEN
        NULL;
      END IF;
      IF order_item_ship.mfg_building_nbr IS NOT NULL THEN
        -- if found then no need to check if product is purchase or not
        GOTO end_mfgbldg;
      ELSE
        order_item_ship.mfg_building_nbr := '*';
      END IF;

      -- get rpt org id
      IF order_item_ship.amp_shipped_date IS NULL THEN
        -- backlog
        v_rpt_dt   := NVL(order_item_ship.reported_as_of_date,
                          TRUNC(SYSDATE));
        v_plant_id := order_item_ship.inventory_building_nbr;
      ELSE
        v_rpt_dt   := order_item_ship.amp_shipped_date;
        v_plant_id := order_item_ship.actual_ship_building_nbr;
      END IF;

      IF NOT scdCommonBatch.GetOrgIDV4(order_item_ship.mfr_org_key_id,
                                       v_rpt_dt,
                                       v_rptorg_id) THEN
        GOTO end_mfgbldg;
      END IF;

      -- determine if product is purchased
      v_proc_type_cde := Scdcommonbatch.get_proc_type_cde(v_rptorg_id,
                                                          order_item_ship.part_key_id);
      IF v_proc_type_cde = '2' THEN
        -- manufactured
        -- derive mfg bldg/plant
        --IF Scdcommonbatch.get_mfg_bldg_plant(order_item_ship.mfr_org_key_id ,order_item_ship.part_key_id ,order_item_ship.mfg_building_nbr ,order_item_ship.default_manufacturing_plant_id ) THEN
        --   NULL;
        --END IF;

        IF order_item_ship.mfg_building_nbr IS NULL THEN
          order_item_ship.mfg_building_nbr := '*';
        END IF;
      ELSIF v_proc_type_cde IS NOT NULL THEN
        -- purchased
        order_item_ship.mfg_building_nbr := 'PUR'; -- set default value
        -- derive vendor id
        IF Scdcommonbatch.get_sap_vendor_id(order_item_ship.part_key_id,
                                            v_plant_id,
                                            order_item_ship.vendor_id,
                                            order_item_ship.vendor_key_id) THEN
          NULL;
        END IF;
      END IF;
      --END IF;

      <<end_mfgbldg>>
      IF (vgc_update_code = 'A') THEN
        /* Add/Insert the row */
        IF order_item_ship.AMP_SHIPPED_DATE IS NULL THEN
          p_insert_order_item_open(action,
                                   vgn_smrys_inserted,
                                   vgn_sql_result);
        ELSE
          p_insert_order_item_shpmt(action,
                                    vgn_smrys_inserted,
                                    vgn_smrys_updated,
                                    vgn_sql_result);
        END IF;

        IF (vgn_sql_result <> 0) THEN
          RAISE ue_critical_db_error;
        END IF;

        num_rows_processed := num_rows_processed + 1;

        IF (action = 'P') THEN
          /* A duplicate insert is attempted */
          p_duplicate_order_item(action, vgn_sql_result);
          IF (vgn_sql_result <> 0) THEN
            RAISE ue_critical_db_error;
          END IF;
        END IF;

        IF (action = 'I') THEN
          /* A row has been Inserted */
          num_order_items_inserted := num_order_items_inserted + 1;
          num_summaries_inserted   := num_summaries_inserted +
                                      vgn_smrys_inserted;
          num_summaries_updated    := num_summaries_updated +
                                      vgn_smrys_updated;
        END IF;

        IF (action = 'U') THEN
          /* A row has been Updated */
          num_order_items_updated := num_order_items_updated + 1;
        END IF;
      END IF;

      IF (vgc_update_code = 'C') THEN
        /* Change/Update the row */
        p_update_order_item_open(action, vgn_sql_result);
        IF (vgn_sql_result <> 0) THEN
          RAISE ue_critical_db_error;
        END IF;

        num_rows_processed := num_rows_processed + 1;
        IF (action = 'U') THEN
          /* A row has been updated */
          num_order_items_updated := num_order_items_updated + 1;
        END IF;
      END IF;

      IF (vgc_update_code = 'D') THEN
        /* Delete the row */
        IF order_item_ship.AMP_SHIPPED_DATE IS NULL THEN
          p_delete_order_item_open(action, vgn_sql_result);
        ELSE
          p_delete_order_item_shpmt(action,
                                    vgn_smrys_updated,
                                    vgn_smrys_deleted,
                                    vgn_sql_result);
        END IF;

        IF (vgn_sql_result <> 0) THEN
          RAISE ue_critical_db_error;
        END IF;

        num_rows_processed := num_rows_processed + 1;

        IF (action = 'D') THEN
          /* A row has been deleted */
          num_order_items_deleted := num_order_items_deleted + 1;
          num_summaries_updated   := num_summaries_updated +
                                     vgn_smrys_updated;
          num_summaries_deleted   := num_summaries_deleted +
                                     vgn_smrys_deleted;
        END IF;
      END IF;

      /* Delete temp record */
      IF (vib_purge_temp = TRUE) THEN
        DELETE FROM TEMP_ORDER_ITEM_SHIPMENT WHERE ROWID = temp_rowid;
      END IF;

      -- make sure the curr batch_id is the latest batch_id
      IF order_item_ship.BATCH_ID > v_curr_batch_id THEN
        v_curr_batch_id := order_item_ship.BATCH_ID;
      END IF;

      /* Commit if this is the Nth row */
      commit_count := commit_count + 1;
      IF (commit_count = vin_commit_count) THEN
        COMMIT;
        commit_count := 0;
        CLOSE cur_temp_row;
        OPEN cur_temp_row;
      END IF;
    END LOOP;
    CLOSE cur_temp_row;

    /* Insert results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       num_order_items_inserted,
       num_order_items_updated,
       num_order_items_deleted,
       num_summaries_inserted,
       num_summaries_updated,
       num_summaries_deleted);

    -- get saved batch_id in param table
    v_param_batch_id := Scdcommonbatch.GetParamValue('DM5250');

    -- update save batch_id but make sure current batch_id > saved batch_id
    IF v_curr_batch_id > TO_NUMBER(v_param_batch_id) THEN
      UPDATE DELIVERY_PARAMETER A
         SET A.PARAMETER_FIELD = v_curr_batch_id, A.DML_TMSTMP = SYSDATE
       WHERE A.PARAMETER_ID = 'DM5250';
    END IF;

    /* Do one last commit */
    COMMIT;

    /* Error processing */

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Temp Ship Seq #:  ' || temp_ship_seq);
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    vgc_update_code,
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_PROCESS_TEMP_ORDER_ITEMS');
      DBMS_OUTPUT.PUT_LINE('Temp Ship Seq #:  ' || temp_ship_seq);
      DBMS_OUTPUT.PUT_LINE('SQL code:  ' || SQLCODE);
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    vgc_update_code,
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_process_temp_order_items;

/*
**********************************************************************************************************
* PROCEDURE:   p_monthly_purge
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows older than the data retention limit.  The retention
*              date is calculated usingthe SCD02MTHS parameter in the DELIVERY_PARAMETER table.
**********************************************************************************************************
*/

  PROCEDURE p_monthly_purge(vic_job_id       IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                            vin_commit_count IN NUMBER,
                            vion_result      IN OUT NUMBER) IS

    CURSOR cur_order_item_ship_row(nines_date DATE, purge_date DATE) IS
      SELECT /*+ INDEX(order_item_shipment oish_pf2) */
       *
        FROM ORDER_ITEM_SHIPMENT
       WHERE ((amp_shipped_date > nines_date) AND
             (amp_shipped_date <= purge_date))
         AND (ROWNUM <= vin_commit_count);

    action                  CHAR;
    num_rows_processed      NUMBER := 0;
    num_order_items_updated NUMBER := 0;
    num_order_items_deleted NUMBER := 0;
    num_summaries_updated   NUMBER := 0;
    num_summaries_deleted   NUMBER := 0;
    retain_months           NUMBER := 0;
    m_purge_date            DATE;
    m_nines_date            DATE;

  BEGIN

    vgc_job_id   := vic_job_id;
    m_nines_date := TO_DATE('0001001', 'YYYYDDD');
    SELECT PARAMETER_FIELD
      INTO retain_months
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'SCD02MTHS';

    /* Calculate Purge Date */
    m_purge_date := LAST_DAY(ADD_MONTHS(SYSDATE, retain_months * -1));
    OPEN cur_order_item_ship_row(m_nines_date, m_purge_date);
    LOOP
      FETCH cur_order_item_ship_row
        INTO order_item_ship;
      EXIT WHEN(cur_order_item_ship_row%NOTFOUND);

      vgn_smrys_updated := 0;
      vgn_smrys_deleted := 0;
      p_delete_order_item_shpmt(action,
                                vgn_smrys_updated,
                                vgn_smrys_deleted,
                                vgn_sql_result);
      IF (vgn_sql_result <> 0) THEN
        RAISE ue_critical_db_error;
      END IF;

      IF (action = 'D') THEN
        num_order_items_deleted := num_order_items_deleted + 1;
        num_summaries_updated   := num_summaries_updated +
                                   vgn_smrys_updated;
        num_summaries_deleted   := num_summaries_deleted +
                                   vgn_smrys_deleted;
        num_rows_processed      := num_rows_processed + 1;
      END IF;

      IF (MOD(num_rows_processed, vin_commit_count) = 0) THEN
        COMMIT;
        CLOSE cur_order_item_ship_row;
        OPEN cur_order_item_ship_row(m_nines_date, m_purge_date);
      END IF;
    END LOOP;
    CLOSE cur_order_item_ship_row;

    /* Do one last commit */
    COMMIT;

    /* Enter results into load_msg file */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       vgc_job_id,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       m_purge_date,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       num_order_items_updated,
       num_order_items_deleted,
       NULL,
       num_summaries_updated,
       num_summaries_deleted);

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_MONTHLY_PURGE');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      P_Write_Error(order_item_ship.organization_key_id,
                    order_item_ship.amp_order_nbr,
                    order_item_ship.order_item_nbr,
                    order_item_ship.shipment_id,
                    order_item_ship.database_load_date,
                    order_item_ship.amp_shipped_date,
                    order_item_ship.amp_schedule_date,
                    order_item_ship.part_key_id,
                    'DBER',
                    'D',
                    vgc_job_id,
                    vion_result,
                    SQLERRM(vion_result));
      COMMIT;
      /* Commit the error msg */

  END p_monthly_purge;


/*
**********************************************************************************************************
* PROCEDURE:   p_requested_backout
* DESCRIPTION: Deletes all ORDER_ITEM_SHIPMENT rows based on the several fields in the
*              DELIVERY_PARAMETER_LOCAL table: to_date,   from_date,and/or one, or none, of region, area,
*              company, group, or division.
**********************************************************************************************************
*/

  PROCEDURE p_requested_backout(vic_job_id       IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                                vin_commit_count IN NUMBER,
                                vion_result      IN OUT NUMBER) IS

    sql_msg       LOAD_MSG.SQL_ERROR_MSG%TYPE;
    region_code   ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    group_code    ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    div_org_code  ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    co_org_code   ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    area_org_code ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    job_name      ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE;
    batch_id      ORDER_ITEM_SHIPMENT.BATCH_ID%TYPE;
    from_date     DATE;
    TO_DATE       DATE;
    max_date      DATE;
    ue_invalid_parameters EXCEPTION;

  BEGIN

    vgc_job_id := vic_job_id;
    SELECT PARAMETER_FIELD
      INTO from_date
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04FMDTE';

    SELECT PARAMETER_FIELD
      INTO TO_DATE
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04TODTE';

    SELECT PARAMETER_FIELD
      INTO region_code
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04RGN';

    SELECT PARAMETER_FIELD
      INTO area_org_code
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04AREA';

    SELECT PARAMETER_FIELD
      INTO co_org_code
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04CO';

    SELECT PARAMETER_FIELD
      INTO group_code
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04GRP';

    SELECT PARAMETER_FIELD
      INTO div_org_code
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04DIV';

    SELECT PARAMETER_FIELD
      INTO job_name
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04JOB';

    SELECT PARAMETER_FIELD
      INTO batch_id
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD04BATCH';

    IF (from_date IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20000, 'BACKOUT FROM-DATE IS REQUIRED');
    END IF;

    IF (TO_DATE IS NULL) THEN
      RAISE_APPLICATION_ERROR(-20400, 'BACKOUT TO-DATE IS REQUIRED');
    END IF;

    IF (from_date > TO_DATE) THEN
      RAISE_APPLICATION_ERROR(-20200, 'FROM-DATE MUST BE <= TO-DATE');
    END IF;

    max_date := (from_date + 7);

    IF (TO_DATE > max_date) THEN
      RAISE_APPLICATION_ERROR(-20300,
                              'ONLY 7 DAYS OF DATA MAY BE BACKED OUT AT A TIME');
    END IF;

    IF (region_code IS NOT NULL) AND
       ((area_org_code IS NOT NULL) OR (co_org_code IS NOT NULL) OR
       (group_code IS NOT NULL) OR (div_org_code IS NOT NULL) OR
       (job_name IS NOT NULL) OR (batch_id IS NOT NULL)) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    ELSIF (area_org_code IS NOT NULL) AND
          ((co_org_code IS NOT NULL) OR (group_code IS NOT NULL) OR
          (div_org_code IS NOT NULL) OR (job_name IS NOT NULL) OR
          (batch_id IS NOT NULL)) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    ELSIF (co_org_code IS NOT NULL) AND
          ((group_code IS NOT NULL) OR (div_org_code IS NOT NULL) OR
          (job_name IS NOT NULL) OR (batch_id IS NOT NULL)) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    ELSIF (group_code IS NOT NULL) AND
          ((div_org_code IS NOT NULL) OR (job_name IS NOT NULL) OR
          (batch_id IS NOT NULL)) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    ELSIF (div_org_code IS NOT NULL) AND
          ((job_name IS NOT NULL) OR (batch_id IS NOT NULL)) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    ELSIF (job_name IS NOT NULL) AND (batch_id IS NOT NULL) THEN
      RAISE_APPLICATION_ERROR(-20100,
                              'ONLY ONE(1) BACKOUT OPTION IS ALLOWED');
    END IF;

    DBMS_OUTPUT.PUT_LINE('From Date: ' || from_date);
    DBMS_OUTPUT.PUT_LINE('To Date: ' || TO_DATE);
    DBMS_OUTPUT.PUT_LINE('Region Code: ' || region_code);
    DBMS_OUTPUT.PUT_LINE('Area Code: ' || area_org_code);
    DBMS_OUTPUT.PUT_LINE('Co Code: ' || co_org_code);
    DBMS_OUTPUT.PUT_LINE('Group Code: ' || group_code);
    DBMS_OUTPUT.PUT_LINE('Div Code: ' || div_org_code);
    DBMS_OUTPUT.PUT_LINE('Job Name: ' || job_name);
    DBMS_OUTPUT.PUT_LINE('Batch Id: ' || batch_id);

    IF (div_org_code IS NOT NULL) THEN
      p_requested_div_backout(from_date,
                              TO_DATE,
                              div_org_code,
                              vin_commit_count,
                              vion_result);
    ELSIF (group_code IS NOT NULL) THEN
      p_requested_group_backout(from_date,
                                TO_DATE,
                                group_code,
                                vin_commit_count,
                                vion_result);
    ELSIF (co_org_code IS NOT NULL) THEN
      p_requested_co_backout(from_date,
                             TO_DATE,
                             co_org_code,
                             vin_commit_count,
                             vion_result);
    ELSIF (area_org_code IS NOT NULL) THEN
      p_requested_area_backout(from_date,
                               TO_DATE,
                               area_org_code,
                               vin_commit_count,
                               vion_result);
    ELSIF (region_code IS NOT NULL) THEN
      p_requested_region_backout(from_date,
                                 TO_DATE,
                                 region_code,
                                 vin_commit_count,
                                 vion_result);
    ELSIF (job_name IS NOT NULL) THEN
      p_requested_job_backout(from_date,
                              TO_DATE,
                              job_name,
                              vin_commit_count,
                              vion_result);
    ELSIF (batch_id IS NOT NULL) THEN
      p_requested_batch_backout(from_date,
                                TO_DATE,
                                batch_id,
                                vin_commit_count,
                                vion_result);
    ELSE
      p_requested_all_backout(from_date,
                              TO_DATE,
                              vin_commit_count,
                              vion_result);
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_REQUESTED_BACKOUT');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(vion_result));
      sql_msg := SQLERRM(vion_result);
      INSERT INTO LOAD_MSG
        (LOAD_MSG_SEQ,
         DML_ORACLE_ID,
         DML_TMSTMP,
         ORGANIZATION_KEY_ID,
         AMP_ORDER_NBR,
         ORDER_ITEM_NBR,
         SHIPMENT_ID,
         DATABASE_LOAD_DATE,
         AMP_SHIPPED_DATE,
         AMP_SCHEDULE_DATE,
         PART_KEY_ID,
         STATUS,
         NBR_DETAILS_INSERTED,
         NBR_DETAILS_MODIFIED,
         NBR_DETAILS_DELETED,
         NBR_SMRYS_INSERTED,
         NBR_SMRYS_MODIFIED,
         NBR_SMRYS_DELETED,
         UPDATE_TYPE,
         SQL_ERROR_CODE,
         SQL_ERROR_MSG)
      VALUES
        (LOAD_MSG_SEQ.NEXTVAL,
         vgc_job_id,
         SYSDATE,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         NULL,
         'DBER',
         0,
         0,
         0,
         0,
         0,
         0,
         NULL,
         vion_result,
         sql_msg);
      COMMIT;
      /* Commit the error msg */

  END p_requested_backout;

END PKG_ORDER_ITEM_PROCESS;
/
