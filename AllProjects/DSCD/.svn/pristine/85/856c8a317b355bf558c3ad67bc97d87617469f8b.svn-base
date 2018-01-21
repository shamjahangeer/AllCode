CREATE OR REPLACE PACKAGE SCD_SOURCE.PKG_DELVSCD_DATA_LOAD
AS

/*
**********************************************************************************************************
* PACKAGE:     pkg_delvscd_data_load
* DESCRIPTION: Contains procedures to process the TEMP_ORDER_ITEM_SHIPMENT
*              table prior to loading the detail and summary tables.
*
* PROCEDURES:  p_process_temp_order_items
*              p_update_temp_ois
*              p_delete_temp_ois
*              p_intersect_open_temp
*              p_check_for_change
*              p_complete_edits
*              p_delete_order_item_open
*  ----------------------------------------------------------------------------------------------------------
* MODIFICATION LOG
*
* Date      Programmer  Description
* --------  ----------  ------------------------------------------------
* 11/18/96  SDJ (CAI)   New Package
* 12/18/96  SDJ (CAI)   Do not execute p_complete_edits if NO temp rows  are edited (required for restart logic).
* 12/19/96  SDJ (CAI)   Do not execute p_delete_order_item_open when only processing shipments (job id 'SCDUAA00').
* 01/31/97  JAF (CAI)   Fix - move assignment of earliest expedite date for EMEA after invoking P_EDIT_TEMP_ORDER_ITEM
* 04/07/97  JAF (CAI)   ssr 3681 release 2.0 update trade_or_interco_code
* 07/22/97  JAF (CAI)   change time comparison when calculating database_load_date
* 03/12/98  TA          Added fields for Manufacturing view.
*                       Mfg_div_org_code, mfg_group_org_code, mfg_campus_id and mfg_building_nbr
* 05/05/98  LPZ         Added fields for subcontractor view pri_ww_account_nbr_base, pri_ww_account_nbr_suffix
* 06/30/98  BLR         Made Year 2000 compliant - changed to YYYY.
*                       Changed length of substr for parameter_field from 9 to 11 for vld_dbload_date.
* 09/14/98  DSM         Do not execute p_delete_order_item_open when only processing shipments.
* 11/30/99  ALEX        Release 5.0: Added fields for industry view and Fiscal Dates
*                       (REMAINING_QTY_TO_SHIP,FISCAL_MONTH,FISCAL_YEAR,FISCAL_QUARTER,INDUSTRY_BUSINESS_CODE)
* 12/09/99  ALEX        Release 5.0: Removed PRODUCT_LINE_CODE AND PRODUCT_FAMILY_CODE fields.
* 02/22/00  ALEX        Release 5.1: Use PKG_EDIT_TEMP_ORDER_DAF if data go thru DAF process.
* 02/22/00  ALEX (RCG)  Release 5.1: Added new fields (SBMT_PART_NBR, SBMT_CUSTOMER_ACCT_NBR, PROFIT_CENTER_ID, BRAND_ID)
* 05/05/00  ALEX (RCG)  Release 5.1:Added logic to handle (select) the control total records in delivery_parameter_local
*                       table due to timing issue.
* 06/09/00  ALEX (RCG)  Release 5.2: Added new fields for Elec. GearBox
* 01/11/00  ALEX/Faisal Release 5.3: Changed product_busns_line_code to product_busns_line_id and product_busns_line_fnctn_code
*                       to product_busns_line_fnctn_id
* 02/12/01  Faisal      Release 5.4: Added new field (PROFIT_CENTER_ABBR_NM)
* 02/16/01  Faisal/Alex Release 5.5: Added new fields for fiscal dates using amp_schedule_date
* 03/14/01  Alex        Release 5.6: Added new fields for ADR43
* 04/25/01  Alex        Release 6.0: DSCD rewrite
* 10/19/01  Alex        Release 6.1: Added new field budget_rate_bk/bl_amt.
* 11/30/01  Alex        Adjusted time comparison when calculating database load date to 1400 hrs
* 03/25/02  Alex        Add new hierarchy_ columns for profit center reporting.
* 04/05/02  Alex        Add Cost fields.
* 04/21/02  Alex        Added new column PRODUCT_MANAGER_GLOBAL_ID
* 08/26/02  Alex        Add _schedule_date columns.
* 11/14/02  Alex        Add PART_UM and SBMT_SOLD_TO_CUSTOMER_ID columns.  Also remove SUNDAY special logic on DB_LOAD_DATE.
* 01/16/03  Alex        Add columns for Germany's SAP implementation.
* 06/24/03  Alex        Add new columns for Japan (S1) enchancments.
* 08/19/03  Alex        Add enhancement to improve process performance
* 05/07/04  SAP         Add new columns for Replenishment Lead Time enhancement
* 10/11/04              Add Item Booked Dt field.
* 11/16/04  Alex        Add 2 new fields for TEPS Ultimate end customer
* 12/07/04  Alex        Add MRP Group Code and COMPLETE_DELIVERY_IND fields.
* 01/10/05  Alex        Alpha Part project.
* 09/22/05  Alex        Add new column PLANNED_INSTALLATION_CMPL_DT
* 12/30/05  Alex        Add source_id and data_src_id columns.
* 01/17/06  Alex        Remove PART_NBR column.
* 02/28/06  Alex        Changed DB Load Dt logic to 1300 instead of 1400 such that schedule can start at 1300 hrs.
* 09/07/06  Alex        Add DISTR_SHIP_WHEN_AVAIL_IND field.
* 10/10/07  Alex        Add logic for data security.
* 11/10/08  Alex        Add fields for Consolidated Cust Ships changes.
* 10/13/09  Alex        Add COSB exclusion code logic for backlog.
* 11/03/09  Alex        Add SAP profit center.
* 01/26/10  Alex        Add Storage Location ID AND Sales Territory code.
* 08/24/10  Alex        Add TMS Days Qty field.
* 07/06/11  Kumar Emany Add TELAG 1535 fields and pricing_condition_type_cde to p_intersect_open_temp,
*                       p_set_tois_update_code, p_process_temp_order_items
* 08/29/11  A. Orbeta   Add planned_goods_issue_dt as part of 1535 changes.
* 10/12/11              Add cost calculator fields for margins changes.
* 04/02/12  M. Feenstra Added MATERIAL_AVAILABILITY_DT to ORDER_ITEM_OPEN.
* 06/12/12  M. Feenstra Added INITIAL_REQUEST_QTY and MATERIAL_AVAILABILITY_DT.
* 11/05/12  Kumar Emany Add BILLING_TYPE_CDE, CUST_PUR_ORD_LINE_ITEM_NBR_ID, EXPEDITE_INDICATOR_CDE, EXPEDITE_STATUS_DESC,
*                       SAP_DELIVERY_TYPE_CDE, SHIPMENT_NUMBER_ID Columns for 2012 Q1 Enhancements to
*                       p_intersect_open_temp, p_set_tois_update_code, p_process_temp_order_items
* 05/17/13  Reddi       Added column 'MODIFIED_CUSTOMER_REQUEST_DT' to Delivery ScoreCard
* 09/03/13  Reddi       Added column 'CUSTOMER_REQUESTED_EXPEDITE_DT' to Delivery ScoreCard
***********************************************************************************************************
*/

PROCEDURE P_PROCESS_TEMP_ORDER_ITEMS(vic_job_id       IN CHAR,
                                     vin_commit_count IN NUMBER,
                                     vion_result      IN OUT NUMBER);

END PKG_DELVSCD_DATA_LOAD;
/



CREATE OR REPLACE PACKAGE BODY SCD_SOURCE.PKG_DELVSCD_DATA_LOAD
AS

  temp_ois                  TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
  ois                       TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
  oio                       ORDER_ITEM_OPEN%ROWTYPE;
  vgn_temp_ship_seq         TEMP_ORDER_ITEM_SHIPMENT.TEMP_SHIP_SEQ%TYPE;
  vgc_job_id                LOAD_MSG.DML_ORACLE_ID%TYPE;
  vgc_parm_id               DELIVERY_PARAMETER_LOCAL.PARAMETER_ID%TYPE;
  vgc_log_name              SCORECARD_PROCESS_LOG.SCD_PROCESS_NAME%TYPE;
  vgn_log_line              SCORECARD_PROCESS_LOG.SCD_PROCESS_LINE%TYPE;
  vgc_sql_error             CHAR(70);
  vgn_sql_result            NUMBER;
  vgn_nbr_processed         NUMBER(10) := 0;
  vgn_commit_count          NUMBER(10) := 0;
  vgn_open_count            NUMBER(10) := 0;
  vgn_ship_count            NUMBER(10) := 0;
  vgn_ship_jan_count        NUMBER(10) := 0;
  vgn_ship_feb_count        NUMBER(10) := 0;
  vgn_ship_mar_count        NUMBER(10) := 0;
  vgn_ship_apr_count        NUMBER(10) := 0;
  vgn_ship_may_count        NUMBER(10) := 0;
  vgn_ship_jun_count        NUMBER(10) := 0;
  vgn_ship_jul_count        NUMBER(10) := 0;
  vgn_ship_aug_count        NUMBER(10) := 0;
  vgn_ship_sep_count        NUMBER(10) := 0;
  vgn_ship_oct_count        NUMBER(10) := 0;
  vgn_ship_nov_count        NUMBER(10) := 0;
  vgn_ship_dec_count        NUMBER(10) := 0;
  vgn_temp_count            NUMBER(10) := 0;
  vgn_bypass_open           NUMBER(10) := 0;
  vgn_bypass_ship           NUMBER(10) := 0;
  vgn_no_change_count       NUMBER(10) := 0;
  vgn_open_add_count        NUMBER(10) := 0;
  vgn_open_change_count     NUMBER(10) := 0;
  vgn_open_delete_count     NUMBER(10) := 0;
  vgn_open_to_ship_count    NUMBER(10) := 0;
  vgn_ship_add_count        NUMBER(10) := 0;
  vgn_make_stock_null_count NUMBER(10) := 0;
  vgn_pl_null_count         NUMBER(10) := 0;
  vgn_inv_class_null_count  NUMBER(10) := 0;
  vgn_ppsoc_null_count      NUMBER(10) := 0;
  vgn_prod_code_null_count  NUMBER(10) := 0;
  vgn_cntlr_emp_null_count  NUMBER(10) := 0;
  vgn_method_null_count     NUMBER(10) := 0;
  vgn_team_null_count       NUMBER(10) := 0;
  vgr_temp_rowid            ROWID;
  ue_critical_db_error EXCEPTION;
  vgc_org_id ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;

  /****************************************************************************/
  /* PROCEDURE:  p_update_temp_ois                                            */
  /* DESCRIPTION: Update the TEMP_ORDER_ITEM_SHIPMENT row with the            */
  /*              calculated and derived column values.                       */
  /****************************************************************************/

  PROCEDURE P_UPDATE_TEMP_OIS AS

  BEGIN
    vgn_sql_result := 0;
    UPDATE TEMP_ORDER_ITEM_SHIPMENT
       SET UPDATE_CODE                    = ois.update_code,
           DML_TMSTMP                     = SYSDATE,
           PURCHASE_BY_ACCOUNT_BASE       = ois.purchase_by_account_base,
           SHIP_TO_ACCOUNT_SUFFIX         = ois.ship_to_account_suffix,
           ACCOUNTING_ORG_KEY_ID          = ois.accounting_org_key_id,
           PRODCN_CNTRLR_CODE             = ois.prodcn_cntrlr_code,
           ITEM_QUANTITY                  = ois.item_quantity,
           RESRVN_LEVEL_1                 = ois.resrvn_level_1,
           RESRVN_LEVEL_5                 = ois.resrvn_level_5,
           RESRVN_LEVEL_9                 = ois.resrvn_level_9,
           QUANTITY_RELEASED              = ois.quantity_released,
           QUANTITY_SHIPPED               = ois.quantity_shipped,
           ISO_CURRENCY_CODE_1            = ois.iso_currency_code_1,
           LOCAL_CURRENCY_BILLED_AMOUNT   = ois.local_currency_billed_amount,
           EXTENDED_BOOK_BILL_AMOUNT      = ois.extended_book_bill_amount,
           UNIT_PRICE                     = ois.unit_price,
           CUSTOMER_REQUEST_DATE          = ois.customer_request_date,
           AMP_SCHEDULE_DATE              = ois.amp_schedule_date,
           RELEASE_DATE                   = ois.release_date,
           NBR_WINDOW_DAYS_EARLY          = ois.nbr_window_days_early,
           NBR_WINDOW_DAYS_LATE           = ois.nbr_window_days_late,
           INVENTORY_LOCATION_CODE        = ois.inventory_location_code,
           INVENTORY_BUILDING_NBR         = ois.inventory_building_nbr,
           CONTROLLER_UNIQUENESS_ID       = ois.controller_uniqueness_id,
           ACTUAL_SHIP_LOCATION           = ois.actual_ship_location,
           ACTUAL_SHIP_BUILDING_NBR       = ois.actual_ship_building_nbr,
           SCHEDULE_SHIP_CMPRSN_CODE      = ois.schedule_ship_cmprsn_code,
           SCHEDULE_TO_SHIP_VARIANCE      = ois.schedule_to_ship_variance,
           VARBL_SCHEDULE_SHIP_VARIANCE   = ois.varbl_schedule_ship_variance,
           REQUEST_SHIP_CMPRSN_CODE       = ois.request_ship_cmprsn_code,
           REQUEST_TO_SHIP_VARIANCE       = ois.request_to_ship_variance,
           VARBL_REQUEST_SHIP_VARIANCE    = ois.varbl_request_ship_variance,
           REQUEST_SCHEDULE_CMPRSN_CODE   = ois.request_schedule_cmprsn_code,
           REQUEST_TO_SCHEDULE_VARIANCE   = ois.request_to_schedule_variance,
           CURRENT_TO_REQUEST_VARIANCE    = ois.current_to_request_variance,
           CURRENT_TO_SCHEDULE_VARIANCE   = ois.current_to_schedule_variance,
           RECEIVED_TO_REQUEST_VARIANCE   = ois.received_to_request_variance,
           RECEIVED_TO_SCHEDULE_VARIANCE  = ois.received_to_schedule_variance,
           RECEIVED_TO_SHIP_VARIANCE      = ois.received_to_ship_variance,
           VARBL_RECEIVED_SHIP_VARIANCE   = ois.varbl_received_ship_variance,
           RELEASE_TO_SCHEDULE_VARIANCE   = ois.release_to_schedule_variance,
           RELEASE_SCHEDULE_CMPRSN_CODE   = ois.release_schedule_cmprsn_code,
           SHIP_FACILITY_CMPRSN_CODE      = ois.ship_facility_cmprsn_code,
           RELEASE_TO_SHIP_VARIANCE       = ois.release_to_ship_variance,
           ORDER_BOOKING_DATE             = ois.order_booking_date,
           ORDER_RECEIVED_DATE            = ois.order_received_date,
           ORDER_TYPE_ID                  = ois.order_type_id,
           REGTRD_DATE                    = ois.regtrd_date,
           REPORTED_AS_OF_DATE            = ois.reported_as_of_date,
           DATABASE_LOAD_DATE             = ois.database_load_date,
           PURCHASE_ORDER_DATE            = ois.purchase_order_date,
           PURCHASE_ORDER_NBR             = ois.purchase_order_nbr,
           PRODCN_CNTLR_EMPLOYEE_NBR      = ois.prodcn_cntlr_employee_nbr,
           PART_PRCR_SRC_ORG_KEY_ID       = ois.part_prcr_src_org_key_id,
           TEAM_CODE                      = ois.team_code,
           STOCK_MAKE_CODE                = ois.stock_make_code,
           PRODUCT_CODE                   = ois.product_code,
           PRODUCT_LINE_CODE              = ois.product_line_code,
           WW_ACCOUNT_NBR_BASE            = ois.ww_account_nbr_base,
           WW_ACCOUNT_NBR_SUFFIX          = ois.ww_account_nbr_suffix,
           CUSTOMER_FORECAST_CODE         = ois.customer_forecast_code,
           A_TERRITORY_NBR                = ois.a_territory_nbr,
           CUSTOMER_REFERENCE_PART_NBR    = ois.customer_reference_part_nbr,
           CUSTOMER_EXPEDITE_DATE         = ois.customer_expedite_date,
           NBR_OF_EXPEDITES               = ois.nbr_of_expedites,
           ORIGINAL_EXPEDITE_DATE         = ois.original_expedite_date,
           CURRENT_EXPEDITE_DATE          = ois.current_expedite_date,
           EARLIEST_EXPEDITE_DATE         = ois.earliest_expedite_date,
           SCHEDULE_ON_CREDIT_HOLD_DATE   = ois.schedule_on_credit_hold_date,
           SCHEDULE_OFF_CREDIT_HOLD_DATE  = ois.schedule_off_credit_hold_date,
           CUSTOMER_CREDIT_HOLD_IND       = ois.customer_credit_hold_ind,
           CUSTOMER_ON_CREDIT_HOLD_DATE   = ois.customer_on_credit_hold_date,
           CUSTOMER_OFF_CREDIT_HOLD_DATE  = ois.customer_off_credit_hold_date,
           TEMP_HOLD_IND                  = ois.temp_hold_ind,
           TEMP_HOLD_ON_DATE              = ois.temp_hold_on_date,
           TEMP_HOLD_OFF_DATE             = ois.temp_hold_off_date,
           CUSTOMER_TYPE_CODE             = ois.customer_type_code,
           INDUSTRY_CODE                  = ois.industry_code,
           PRODUCT_BUSNS_LINE_ID          = ois.product_busns_line_id,
           PRODUCT_BUSNS_LINE_FNCTN_ID    = ois.product_busns_line_fnctn_id,
           CUSTOMER_ACCT_TYPE_CDE         = ois.customer_acct_type_cde,
           MFR_ORG_KEY_ID                 = ois.mfr_org_key_id,
           MFG_CAMPUS_ID                  = ois.mfg_campus_id,
           MFG_BUILDING_NBR               = ois.mfg_building_nbr,
           REMAINING_QTY_TO_SHIP          = ois.remaining_qty_to_ship,
           FISCAL_MONTH                   = ois.fiscal_month,
           FISCAL_QUARTER                 = ois.fiscal_quarter,
           FISCAL_YEAR                    = ois.fiscal_year,
           INDUSTRY_BUSINESS_CODE         = ois.industry_business_code,
           PROFIT_CENTER_ABBR_NM          = ois.profit_center_abbr_nm,
           SOLD_TO_CUSTOMER_ID            = ois.SOLD_TO_CUSTOMER_ID,
           BUDGET_RATE_BOOK_BILL_AMT      = ois.BUDGET_RATE_BOOK_BILL_AMT,
           GFC_EXTENDED_TRUE_AMP_COST     = ois.GFC_EXTENDED_TRUE_AMP_COST,
           PRODUCT_MANAGER_GLOBAL_ID      = ois.PRODUCT_MANAGER_GLOBAL_ID,
           ORIG_IBC_PROFIT_CENTER_ID      = ois.ORIG_IBC_PROFIT_CENTER_ID,
           ORIG_IBC_DATA_SECR_GRP_ID      = ois.ORIG_IBC_DATA_SECR_GRP_ID,
           ORIG_CBC_PROFIT_CENTER_ID      = ois.ORIG_CBC_PROFIT_CENTER_ID,
           ORIG_CBC_DATA_SECR_GRP_ID      = ois.ORIG_CBC_DATA_SECR_GRP_ID,
           ORIG_REPT_ORG_PROFIT_CENTER_ID = ois.ORIG_REPT_ORG_PROFIT_CENTER_ID,
           ORIGREPT_PRFT_DATA_SECR_GRP_ID = ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID,
           ORIG_SALES_TERRITORY_NBR       = ois.ORIG_SALES_TERRITORY_NBR,
           ORIG_SALES_TERR_PROFIT_CTR_ID  = ois.ORIG_SALES_TERR_PROFIT_CTR_ID,
           ORIG_SLS_TERR_DATA_SECR_GRP_ID = ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID,
           ORIG_MGE_PRFT_DATA_SECR_GRP_ID = ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID,
           ORIG_DATA_SECURITY_TAG_ID      = ois.ORIG_DATA_SECURITY_TAG_ID,
           CUR_DATA_SECURITY_TAG_ID       = ois.CUR_DATA_SECURITY_TAG_ID,
           SUPER_DATA_SECURITY_TAG_ID     = ois.SUPER_DATA_SECURITY_TAG_ID,
           -- ORDER_RECEIVED_DT              = ois.ORDER_RECEIVED_DT,
           -- ORDER_CREATED_BY_NTWK_USER_ID  = ois.ORDER_CREATED_BY_NTWK_USER_ID,
           -- DELIVERY_DOC_CREATION_DT       = ois.DELIVERY_DOC_CREATION_DT,
           -- DELIVERY_DOC_CREATION_TM       = ois.DELIVERY_DOC_CREATION_TM,
           -- DLVR_DOC_CRET_BY_NTWK_USER_ID  = ois.DLVR_DOC_CRET_BY_NTWK_USER_ID,
           -- PRICING_CONDITION_TYPE_CDE     = ois.PRICING_CONDITION_TYPE_CDE,
           USD_LABOR_COST_AMT             = ois.USD_LABOR_COST_AMT,
           USD_TOT_OVHD_COST_AMT          = ois.USD_TOT_OVHD_COST_AMT,
           USD_MFR_ENGR_COST_AMT          = ois.USD_MFR_ENGR_COST_AMT,
           USD_TRUE_MATL_COST_AMT         = ois.USD_TRUE_MATL_COST_AMT,
           USD_MATL_BRDN_COST_AMT         = ois.USD_MATL_BRDN_COST_AMT,
           USD_INCO_CNTT_COST_AMT         = ois.USD_INCO_CNTT_COST_AMT,
           CNST_TRUE_COST_AMT             = ois.CNST_TRUE_COST_AMT,
           CNST_LABOR_COST_AMT            = ois.CNST_LABOR_COST_AMT,
           CNST_TOT_OVHD_COST_AMT         = ois.CNST_TOT_OVHD_COST_AMT,
           CNST_MFR_ENGR_COST_AMT         = ois.CNST_MFR_ENGR_COST_AMT,
           CNST_TRUE_MATL_COST_AMT        = ois.CNST_TRUE_MATL_COST_AMT,
           CNST_MATL_BRDN_COST_AMT        = ois.CNST_MATL_BRDN_COST_AMT,
           CNST_INCO_CNTT_COST_AMT        = ois.CNST_INCO_CNTT_COST_AMT,
           LOCAL_CRNC_TRUE_COST_AMT       = ois.LOCAL_CRNC_TRUE_COST_AMT,
           LOCAL_CRNC_LABOR_COST_AMT      = ois.LOCAL_CRNC_LABOR_COST_AMT,
           LOCAL_CRNC_TOT_OVHD_COST_AMT   = ois.LOCAL_CRNC_TOT_OVHD_COST_AMT,
           LOCAL_CRNC_MFR_ENGR_COST_AMT   = ois.LOCAL_CRNC_MFR_ENGR_COST_AMT,
           LOCAL_CRNC_TRUE_MATL_COST_AMT  = ois.LOCAL_CRNC_TRUE_MATL_COST_AMT,
           LOCAL_CRNC_MATL_BRDN_COST_AMT  = ois.LOCAL_CRNC_MATL_BRDN_COST_AMT,
           LOCAL_CRNC_INCO_CNTT_COST_AMT  = ois.LOCAL_CRNC_INCO_CNTT_COST_AMT
     WHERE ROWID = vgr_temp_rowid;

    vgn_sql_result := SQLCODE;

  EXCEPTION
    WHEN OTHERS THEN
      vgc_log_name   := 'P_UPDATE_TEMP_OIS';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_UPDATE_TEMP_OIS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_UPDATE_TEMP_OIS;

  /****************************************************************************/
  /* PROCEDURE:  p_delete_temp_ois                                            */
  /* DESCRIPTION: Delete a row in the TEMP_ORDER_ITEM_SHIPMENT table          */
  /*              when bypassed because of edit errors.                       */
  /****************************************************************************/

  PROCEDURE P_DELETE_TEMP_OIS AS

  BEGIN

    vgn_sql_result := 0;
    DELETE FROM TEMP_ORDER_ITEM_SHIPMENT WHERE ROWID = vgr_temp_rowid;
    vgn_sql_result := SQLCODE;

  EXCEPTION
    WHEN OTHERS THEN
      vgc_log_name   := 'P_DELETE_TEMP_OIS';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_DELETE_TEMP_OIS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_DELETE_TEMP_OIS;

  /****************************************************************************/
  /* PROCEDURE:  p_intersect_open_temp                                        */
  /* DESCRIPTION:  Compare the TEMP_ORDER_ITEM_SHIPMENT row with the          */
  /*               ORDER_ITEM_OPEN row to determine if any column data        */
  /*               has changed.                                               */
  /****************************************************************************/

  PROCEDURE P_INTERSECT_OPEN_TEMP AS

    CURSOR cur_temp_open_row IS
      SELECT ORGANIZATION_KEY_ID,
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
             ORDER_RECEIVED_DT,
             ORDER_CREATED_BY_NTWK_USER_ID,
             PRICING_CONDITION_TYPE_CDE,
             DOC_ISO_CURRENCY_CDE,
             DOC_CURRENCY_AMT,
             MATERIAL_AVAILABILITY_DT,
             CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
         -- BILLING_TYPE_CDE,
         EXPEDITE_INDICATOR_CDE,
         EXPEDITE_STATUS_DESC,
       MODIFIED_CUSTOMER_REQUEST_DT,
       CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
        FROM TEMP_ORDER_ITEM_SHIPMENT
       WHERE ROWID = vgr_temp_rowid
      INTERSECT
      SELECT ORGANIZATION_KEY_ID,
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
             ORDER_RECEIVED_DT,
             ORDER_CREATED_BY_NTWK_USER_ID,
             PRICING_CONDITION_TYPE_CDE,
             DOC_ISO_CURRENCY_CDE,
             DOC_CURRENCY_AMT,
             MATERIAL_AVAILABILITY_DT,
             CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
         -- BILLING_TYPE_CDE,
         EXPEDITE_INDICATOR_CDE,
         EXPEDITE_STATUS_DESC,
       MODIFIED_CUSTOMER_REQUEST_DT,
       CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
        FROM ORDER_ITEM_OPEN
       WHERE ORGANIZATION_KEY_ID = ois.organization_key_id
         AND AMP_ORDER_NBR = ois.amp_order_nbr
         AND ORDER_ITEM_NBR = ois.order_item_nbr
         AND SHIPMENT_ID = ois.shipment_id;

  BEGIN

    OPEN cur_temp_open_row;
    LOOP
      FETCH cur_temp_open_row
        INTO oio.organization_key_id
      , oio.amp_order_nbr
      , oio.order_item_nbr
      , oio.shipment_id
      , oio.purchase_by_account_base
      , oio.ship_to_account_suffix
      , oio.accounting_org_key_id
      , oio.prodcn_cntrlr_code
      , oio.item_quantity
      , oio.resrvn_level_1
      , oio.resrvn_level_5
      , oio.resrvn_level_9
      , oio.quantity_released
      , oio.quantity_shipped
      , oio.iso_currency_code_1
      , oio.local_currency_billed_amount
      , oio.extended_book_bill_amount
      , oio.unit_price
      , oio.customer_request_date
      , oio.amp_schedule_date
      , oio.release_date
      , oio.inventory_location_code
      , oio.inventory_building_nbr
      , oio.controller_uniqueness_id
      , oio.actual_ship_location
      , oio.actual_ship_building_nbr
      , oio.request_schedule_cmprsn_code
      , oio.request_to_schedule_variance
      , oio.current_to_request_variance
      , oio.current_to_schedule_variance
      , oio.received_to_request_variance
      , oio.received_to_schedule_variance
      , oio.release_to_schedule_variance
      , oio.release_schedule_cmprsn_code
      , oio.order_booking_date
      , oio.order_received_date
      , oio.order_type_id
      , oio.regtrd_date
      , oio.reported_as_of_date
      , oio.purchase_order_date
      , oio.purchase_order_nbr
      , oio.prodcn_cntlr_employee_nbr
      , oio.part_prcr_src_org_key_id
      , oio.team_code
      , oio.stock_make_code
      , oio.product_code
      , oio.product_line_code
      , oio.ww_account_nbr_base
      , oio.ww_account_nbr_suffix
      , oio.a_territory_nbr
      , oio.customer_reference_part_nbr
      , oio.schedule_on_credit_hold_date
      , oio.schedule_off_credit_hold_date
      , oio.customer_credit_hold_ind
      , oio.customer_on_credit_hold_date
      , oio.customer_off_credit_hold_date
      , oio.temp_hold_on_date
      , oio.temp_hold_off_date
      , oio.customer_type_code
      , oio.industry_code
      , oio.product_busns_line_id
      , oio.product_busns_line_fnctn_id
      , oio.customer_acct_type_cde
      , oio.mfr_org_key_id
      , oio.mfg_campus_id
      , oio.mfg_building_nbr
      , oio.remaining_qty_to_ship
      , oio.fiscal_month
      , oio.fiscal_quarter
      , oio.fiscal_year
      , oio.industry_business_code
      , oio.sbmt_part_nbr
      , oio.sbmt_customer_acct_nbr
      , oio.profit_center_abbr_nm
      , oio.brand_id
      , oio.schd_tyco_month_of_year_id
      , oio.schd_tyco_quarter_id
      , oio.schd_tyco_year_id
      , oio.sold_to_customer_id
      , oio.invoice_nbr
      , oio.delivery_block_cde
      , oio.credit_check_status_cde
      , oio.sales_organization_id
      , oio.distribution_channel_cde
      , oio.order_division_cde
      , oio.item_division_cde
      , oio.matl_account_asgn_grp_cde
      , oio.data_source_desc
      , oio.prime_worldwide_customer_id
      , oio.sales_document_type_cde
      , oio.material_type_cde
      , oio.drop_shipment_ind
      , oio.sales_office_cde
      , oio.sales_group_cde
      , oio.sbmt_part_prcr_src_org_id
      , oio.budget_rate_book_bill_amt
      , oio.hierarchy_customer_ind
      , oio.hierarchy_customer_org_id
      , oio.hierarchy_customer_base_id
      , oio.hierarchy_customer_sufx_id
      , oio.gfc_extended_true_amp_cost
      , oio.product_manager_global_id
      , oio.sbmt_original_schedule_dt
      , oio.sbmt_current_schedule_dt
      , oio.part_um
      , oio.sbmt_sold_to_customer_id
      , oio.tyco_ctrl_delivery_hold_on_dt
      , oio.tyco_ctrl_delivery_hold_off_dt
      , oio.tyco_ctrl_delivery_block_cde
      , oio.pick_pack_work_days_qty
      , oio.loading_nbr_of_work_days_qty
      , oio.trsp_lead_time_days_qty
      , oio.transit_time_days_qty
      , oio.delivery_item_category_cde
      , oio.delivery_in_process_qty
      , oio.order_header_billing_block_cde
      , oio.item_billing_block_cde
      , oio.fixed_date_quantity_ind
      , oio.sap_bill_to_customer_id
      , oio.misc_local_flag_cde_1
      , oio.misc_local_cde_1
      , oio.misc_local_cde_2
      , oio.misc_local_cde_3
      , oio.requested_on_dock_dt
      , oio.scheduled_on_dock_dt
      , oio.ship_to_customer_key_id
      , oio.sold_to_customer_key_id
      , oio.hierarchy_customer_key_id
      , oio.ultimate_end_customer_key_id
      , oio.intl_commercial_terms_cde
      , oio.intl_cmcl_term_additional_desc
      , oio.shipping_trsp_category_cde
      , oio.header_cust_order_received_dt
      , oio.sbmt_schd_agr_cancel_ind_cde
      , oio.schd_agr_cancel_indicator_cde
      , oio.consumed_sa_order_item_nbr_id
      , oio.consumed_sa_order_number_id
      , oio.sbmt_sb_cnsn_itrst_prtncust_id
      , oio.sb_cnsn_itrst_prtn_cust_key_id
      , oio.shipping_conditions_cde
      , oio.sbmt_zi_cnsn_stk_prtn_cust_id
      , oio.zi_cnsn_stk_prtn_cust_key_id
      , oio.sbmt_sales_territory_cde
      , oio.sbmt_sales_office_cde
      , oio.sbmt_sales_group_cde
      , oio.schedule_line_nbr
      , oio.sbmt_schedule_line_nbr
      , oio.discontinued_operations_cde
      , oio.order_received_dt
      , oio.order_created_by_ntwk_user_id
      , oio.pricing_condition_type_cde
      , oio.doc_iso_currency_cde
      , oio.doc_currency_amt
      , oio.material_availability_dt
      , oio.cust_pur_ord_line_item_nbr_id  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
      -- , oio.billing_type_cde
      , oio.expedite_indicator_cde
      , oio.expedite_status_desc
      , oio.MODIFIED_CUSTOMER_REQUEST_DT
      , oio.CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
      ;

      EXIT WHEN(cur_temp_open_row%NOTFOUND);
    END LOOP;

    IF cur_temp_open_row%ROWCOUNT = 0 THEN
      vgn_open_change_count := vgn_open_change_count + 1;
      ois.update_code       := 'C';
    ELSE
      vgn_no_change_count := vgn_no_change_count + 1;
      ois.update_code     := 'N';
    END IF;

    CLOSE cur_temp_open_row;

  EXCEPTION
    WHEN OTHERS THEN
      vgc_log_name   := 'P_INTERSECT_OPEN_TEMP';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_INTERSECT_OPEN_TEMP');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_INTERSECT_OPEN_TEMP;

  /****************************************************************************/
  /* PROCEDURE:  p_check_for_change                                           */
  /* DESCRIPTION:  Select the schedule from the ORDER_ITEM_OPEN table.        */
  /*               If the row DOES NOT exist, set the update code to 'A'.     */
  /*               If the row DOES exist and it's an open, execute the        */
  /*               procedure to determine if any column data has changed.     */
  /*               If the row DOES exist and it a shipment, set the           */
  /*               update code 'A'.                                           */
  /****************************************************************************/

  PROCEDURE P_CHECK_FOR_CHANGE AS

    vln_open_count NUMBER(10) := 0;

  BEGIN

    vgn_sql_result := 0;

    SELECT COUNT(*)
      INTO vln_open_count
      FROM ORDER_ITEM_OPEN
     WHERE ORGANIZATION_KEY_ID = ois.organization_key_id
       AND AMP_ORDER_NBR = ois.amp_order_nbr
       AND ORDER_ITEM_NBR = ois.order_item_nbr
       AND SHIPMENT_ID = ois.shipment_id;

    IF vln_open_count = 0 THEN
      IF ois.amp_shipped_date IS NULL THEN
        vgn_open_add_count := vgn_open_add_count + 1;
      ELSE
        vgn_ship_add_count := vgn_ship_add_count + 1;
      END IF;

      ois.update_code := 'A';

    ELSIF ois.amp_shipped_date IS NULL THEN
      ois.update_code := '?';
      /*
      P_INTERSECT_OPEN_TEMP;
      IF vgn_sql_result != 0 THEN
         RAISE ue_critical_db_error;
      END IF;
      */
    ELSE
      vgn_open_to_ship_count := vgn_open_to_ship_count + 1;
      ois.update_code        := 'A';
    END IF;

    /*
    UPDATE
    TEMP_ORDER_ITEM_SHIPMENT
    SET UPDATE_CODE = ois.update_code
    WHERE ROWID = vgr_temp_rowid;
    */

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vgn_sql_result := vgn_sql_result;
    WHEN OTHERS THEN
      vgc_log_name   := 'P_CHECK_FOR_CHANGE';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_CHECK_FOR_CHANGE');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_CHECK_FOR_CHANGE;

  /****************************************************************************/
  /* PROCEDURE:  p_complete_edits                                             */
  /* DESCRIPTION:  Update the SCORECARD_PROCESS_LOG with control totals.      */
  /*               Abend if the totals do not match the control totals        */
  /*               on the DEVLIVERY_PARAMETER_LOCAL table.                    */
  /****************************************************************************/

  PROCEDURE P_COMPLETE_EDITS AS

    vln_open_count     NUMBER(10) := 0;
    vln_ship_count     NUMBER(10) := 0;
    vln_ship_jan_count NUMBER(10) := 0;
    vln_ship_feb_count NUMBER(10) := 0;
    vln_ship_mar_count NUMBER(10) := 0;
    vln_ship_apr_count NUMBER(10) := 0;
    vln_ship_may_count NUMBER(10) := 0;
    vln_ship_jun_count NUMBER(10) := 0;
    vln_ship_jul_count NUMBER(10) := 0;
    vln_ship_aug_count NUMBER(10) := 0;
    vln_ship_sep_count NUMBER(10) := 0;
    vln_ship_oct_count NUMBER(10) := 0;
    vln_ship_nov_count NUMBER(10) := 0;
    vln_ship_dec_count NUMBER(10) := 0;
    vln_count          NUMBER;

  BEGIN

    vgc_parm_id := (SUBSTR(vgc_job_id, 1, 3) ||
                   SUBSTR(vgc_job_id, 5, LENGTH(RTRIM(vgc_job_id)) - 6) ||
                   'OPENS');

    -- check if opens param local header exist
    vln_count := 0;

    SELECT COUNT(*)
      INTO vln_count
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = vgc_parm_id;

    IF vln_count = 0 THEN
      vln_open_count := 0;
    ELSE
      SELECT PARAMETER_FIELD
        INTO vln_open_count
        FROM DELIVERY_PARAMETER_LOCAL
       WHERE PARAMETER_ID = vgc_parm_id;
    END IF;

    vgc_parm_id := (SUBSTR(vgc_job_id, 1, 3) ||
                   SUBSTR(vgc_job_id, 5, LENGTH(RTRIM(vgc_job_id)) - 6) ||
                   'SHIPS');

    -- check if ships param local header exist
    vln_count := 0;
    SELECT COUNT(*)
      INTO vln_count
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = vgc_parm_id;

    IF vln_count = 0 THEN
      vln_ship_jan_count := 0;
      vln_ship_feb_count := 0;
      vln_ship_mar_count := 0;
      vln_ship_apr_count := 0;
      vln_ship_may_count := 0;
      vln_ship_jun_count := 0;
      vln_ship_jul_count := 0;
      vln_ship_aug_count := 0;
      vln_ship_sep_count := 0;
      vln_ship_oct_count := 0;
      vln_ship_nov_count := 0;
      vln_ship_dec_count := 0;
    ELSE
      SELECT DECODE(SUBSTR(PARAMETER_FIELD, 1, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 1, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 11, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 11, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 21, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 21, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 31, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 31, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 41, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 41, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 51, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 51, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 61, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 61, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 71, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 71, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 81, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 81, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 91, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 91, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 101, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 101, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 111, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 111, 10)),
             DECODE(SUBSTR(PARAMETER_FIELD, 121, 10),
                    '          ',
                    0,
                    SUBSTR(PARAMETER_FIELD, 121, 10))
        INTO vln_ship_jan_count,
             vln_ship_feb_count,
             vln_ship_mar_count,
             vln_ship_apr_count,
             vln_ship_may_count,
             vln_ship_jun_count,
             vln_ship_jul_count,
             vln_ship_aug_count,
             vln_ship_sep_count,
             vln_ship_oct_count,
             vln_ship_nov_count,
             vln_ship_dec_count,
             vln_ship_count
        FROM DELIVERY_PARAMETER_LOCAL
       WHERE PARAMETER_ID = vgc_parm_id;
    END IF;

    vgn_log_line := 1;

    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('O' || 'OPEN' || TO_CHAR(vgn_bypass_open, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('S' || 'SHIP' || TO_CHAR(vgn_bypass_ship, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || 'M988' || TO_CHAR(vgn_make_stock_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || '1670' || TO_CHAR(vgn_pl_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || '0200' || TO_CHAR(vgn_inv_class_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || 'J084' || TO_CHAR(vgn_ppsoc_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || '1261' || TO_CHAR(vgn_prod_code_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || 'G801' || TO_CHAR(vgn_cntlr_emp_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || 'A689' || TO_CHAR(vgn_method_null_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_1',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('E' || 'I543' || TO_CHAR(vgn_team_null_count, '0000000009')));

    vgn_log_line := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('01' || TO_CHAR(vln_ship_jan_count, '0000000009') ||
       TO_CHAR(vgn_ship_jan_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('02' || TO_CHAR(vln_ship_feb_count, '0000000009') ||
       TO_CHAR(vgn_ship_feb_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('03' || TO_CHAR(vln_ship_mar_count, '0000000009') ||
       TO_CHAR(vgn_ship_mar_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('04' || TO_CHAR(vln_ship_apr_count, '0000000009') ||
       TO_CHAR(vgn_ship_apr_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('05' || TO_CHAR(vln_ship_may_count, '0000000009') ||
       TO_CHAR(vgn_ship_may_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('06' || TO_CHAR(vln_ship_jun_count, '0000000009') ||
       TO_CHAR(vgn_ship_jun_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('07' || TO_CHAR(vln_ship_jul_count, '0000000009') ||
       TO_CHAR(vgn_ship_jul_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('08' || TO_CHAR(vln_ship_aug_count, '0000000009') ||
       TO_CHAR(vgn_ship_aug_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('09' || TO_CHAR(vln_ship_sep_count, '0000000009') ||
       TO_CHAR(vgn_ship_sep_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('10' || TO_CHAR(vln_ship_oct_count, '0000000009') ||
       TO_CHAR(vgn_ship_oct_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('11' || TO_CHAR(vln_ship_nov_count, '0000000009') ||
       TO_CHAR(vgn_ship_nov_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('12' || TO_CHAR(vln_ship_dec_count, '0000000009') ||
       TO_CHAR(vgn_ship_dec_count, '0000000009')));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_COMPLETE_EDITS_2',
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('13' || TO_CHAR(vln_open_count, '0000000009') ||
       TO_CHAR(vgn_open_count, '0000000009')));

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
      vgc_log_name   := 'P_COMPLETE_EDITS';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_COMPLETE_EDITS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_COMPLETE_EDITS;

  /****************************************************************************/
  /* PROCEDURE:  p_delete_order_item_open                                     */
  /* DESCRIPTION:  Compare the open schedule on the TEMP_ORDER_ITEM_SHIPMENT  */
  /*               table with the ORDER_ITEM_OPEN table. Delete         MENT  */
  /*               ORDER_ITEM_OPEN rows that do not have a correspondingMENT  */
  /*               row on the TEMP_ORDER_ITEM_SHIPMENT table.           MENT  */
  /****************************************************************************/

  PROCEDURE P_DELETE_ORDER_ITEM_OPEN AS

  BEGIN
    DELETE FROM ORDER_ITEM_OPEN
     WHERE ROWID IN (SELECT a.ROWID
                       FROM ORDER_ITEM_OPEN a, ORDER_ITEM_OPEN b
                      WHERE a.DML_ORACLE_ID = vgc_job_id
                        AND a.ROWID = b.ROWID
                        AND (b.ORGANIZATION_KEY_ID, b.AMP_ORDER_NBR,
                             b.ORDER_ITEM_NBR, b.SHIPMENT_ID) IN
                            (SELECT A.ORGANIZATION_KEY_ID,
                                    A.AMP_ORDER_NBR,
                                    A.ORDER_ITEM_NBR,
                                    A.SHIPMENT_ID
                               FROM ORDER_ITEM_OPEN A, ORDER_ITEM_OPEN B
                              WHERE B.DML_ORACLE_ID = vgc_job_id
                                AND A.ROWID = B.ROWID
                             MINUS
                             SELECT /*+ index(TEMP_ORDER_ITEM_SHIPMENT, TOIS_pf2)  */
                              ORGANIZATION_KEY_ID,
                              AMP_ORDER_NBR,
                              ORDER_ITEM_NBR,
                              SHIPMENT_ID
                               FROM TEMP_ORDER_ITEM_SHIPMENT
                              WHERE DML_ORACLE_ID = vgc_job_id
                                AND AMP_SHIPPED_DATE IS NULL));

    vgn_open_delete_count := vgn_open_delete_count + SQL%rowcount;
    vgn_nbr_processed     := vgn_nbr_processed + SQL%rowcount;
    COMMIT;

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vgn_sql_result := vgn_sql_result;
    WHEN OTHERS THEN
      vgc_log_name   := 'P_DELETE_ORDER_ITEM_OPEN';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_DELETE_ORDER_ITEM_OPEN');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_DELETE_ORDER_ITEM_OPEN;

  /***************************************************************************/
  /* PROCEDURE:  P_SET_TOIS_UPDATE_CODE                                      */
  /* DESCRIPTION:  Compare the open schedule on the TEMP_ORDER_ITEM_SHIPMENT */
  /*               table with the ORDER_ITEM_OPEN table. Set the update_code */
  /*               to 'C' if change occurred, otherwise set to 'N'.          */
  /***************************************************************************/

  PROCEDURE P_SET_TOIS_UPDATE_CODE AS

  BEGIN
    -- set update_code to 'C' if there is a change
    UPDATE /*+ use_hash(c) */ TEMP_ORDER_ITEM_SHIPMENT c
       SET UPDATE_CODE = 'C'
     WHERE ROWID IN (SELECT /*+ use_hash(a, b) */
                      a.ROWID
                       FROM TEMP_ORDER_ITEM_SHIPMENT a,
                            (SELECT ORGANIZATION_KEY_ID,
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
                                    ORDER_RECEIVED_DT,
                                    ORDER_CREATED_BY_NTWK_USER_ID,
                                    PRICING_CONDITION_TYPE_CDE,
                                    PLANNED_GOODS_ISSUE_DT,
                                    SCHEDULE_LINE_CATEGORY_CDE,
                                    INITIAL_REQUEST_DT,
                                    INITIAL_REQUEST_QTY,
                                    LOCAL_CRNC_TRUE_COST_AMT,
                                    DOC_ISO_CURRENCY_CDE,
                                    DOC_CURRENCY_AMT,
                                    MATERIAL_AVAILABILITY_DT,
                                    CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
                                    -- BILLING_TYPE_CDE,
                                    EXPEDITE_INDICATOR_CDE,
                                    EXPEDITE_STATUS_DESC,
                                    MODIFIED_CUSTOMER_REQUEST_DT,
                                    CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
                               FROM TEMP_ORDER_ITEM_SHIPMENT
                              WHERE DML_ORACLE_ID = vgc_job_id
                                AND UPDATE_CODE = '?'
                                AND AMP_SHIPPED_DATE IS NULL
                             MINUS
                             SELECT ORGANIZATION_KEY_ID,
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
                                    ORDER_RECEIVED_DT,
                                    ORDER_CREATED_BY_NTWK_USER_ID,
                                    PRICING_CONDITION_TYPE_CDE,
                                    PLANNED_GOODS_ISSUE_DT,
                                    SCHEDULE_LINE_CATEGORY_CDE,
                                    INITIAL_REQUEST_DT,
                                    INITIAL_REQUEST_QTY,
                                    LOCAL_CRNC_TRUE_COST_AMT,
                                    DOC_ISO_CURRENCY_CDE,
                                    DOC_CURRENCY_AMT,
                                    MATERIAL_AVAILABILITY_DT,
                                    CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 3 Columns for 2012 Q1 Enhancements
                                    -- BILLING_TYPE_CDE,
                                    EXPEDITE_INDICATOR_CDE,
                                    EXPEDITE_STATUS_DESC,
                                    MODIFIED_CUSTOMER_REQUEST_DT,
                                    CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
                               FROM ORDER_ITEM_OPEN
                              WHERE dml_oracle_id = vgc_job_id) b
                      WHERE a.DML_ORACLE_ID = vgc_job_id
                        AND a.AMP_SHIPPED_DATE IS NULL
                        AND a.UPDATE_CODE = '?' -- not sure this needs to be here
                        AND a.ORGANIZATION_KEY_ID = b.ORGANIZATION_KEY_ID
                        AND a.AMP_ORDER_NBR = b.AMP_ORDER_NBR
                        AND a.ORDER_ITEM_NBR = b.ORDER_ITEM_NBR
                        AND a.SHIPMENT_ID = b.SHIPMENT_ID);

    vgn_open_change_count := vgn_open_change_count + SQL%rowcount;

    -- set update_code to 'N' for remaining no change
    UPDATE TEMP_ORDER_ITEM_SHIPMENT
       SET UPDATE_CODE = 'N'
     WHERE DML_ORACLE_ID = vgc_job_id
       AND UPDATE_CODE = '?'
       AND AMP_SHIPPED_DATE IS NULL;

    vgn_no_change_count := vgn_no_change_count + SQL%rowcount;
    COMMIT;

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vgn_sql_result := vgn_sql_result;
    WHEN OTHERS THEN
      vgc_log_name   := 'P_SET_TOIS_UPDATE_CODE';
      vgn_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_SET_TOIS_UPDATE_CODE');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vgn_sql_result));

  END P_SET_TOIS_UPDATE_CODE;

  /****************************************************************************/
  /* PROCEDURE:   p_process_temp_order_items                                  */
  /* DESCRIPTION: Select the DELIVERY_PARAMETER_LOCAL row to determine        */
  /*              what database_load_date to use.                             */
  /*                Normal Daily Load:                                        */
  /*                   Parameter_id:  SCD**DATE (SCDAADATE, SCDRSDATE, etc)   */
  /*                   Parameter_field:  NULL                                 */
  /*                Reload:                                                   */
  /*                   Parameter_id:  SCD**DATE (SCDAADATE, SCDRSDATE, etc)   */
  /*                   Parameter_field:  19-OCT-96 (load date)                */
  /*              Cursor all TEMP_ORDER_ITEM_SHIPMENT rows.                   */
  /*              For each row fetched:                                       */
  /*                  Execute PKG_EDIT_TEMP_ORDER to edit the row.            */
  /*                  Execute PKG_VARIANCE_CALC to calculate the variances.   */
  /*                  Execute various procedures to perform the add,    es.   */
  /*                  change, and delete logic.                         es.   */
  /****************************************************************************/

  PROCEDURE P_PROCESS_TEMP_ORDER_ITEMS(vic_job_id       IN CHAR,
                                       vin_commit_count IN NUMBER,
                                       vion_result      IN OUT NUMBER) AS

    vld_dbload_date     DATE;
    vln_nbr_edited      NUMBER;
    vln_runtime         NUMBER(4);
    vlc_runday          CHAR(9);
    vln_tois_open_count NUMBER;

    /*  DSM 9/30/98  */
    CURSOR cur_temp_row IS
      SELECT /*+ INDEX_ASC(TEMP_ORDER_ITEM_SHIPMENT TOIS_PK) */
       TEMP_SHIP_SEQ,
       UPDATE_CODE,
       ORGANIZATION_KEY_ID,
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
       PART_UM,
       PRODUCT_MANAGER_GLOBAL_ID,
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
       CUST_PUR_ORD_LINE_ITEM_NBR_ID,  -- Kumar 11/05/2012 Added below 6 Columns for 2012 Q1 Enhancements
       BILLING_TYPE_CDE,
       SAP_DELIVERY_TYPE_CDE,
       SHIPMENT_NUMBER_ID,
       EXPEDITE_INDICATOR_CDE,
       EXPEDITE_STATUS_DESC,
       MODIFIED_CUSTOMER_REQUEST_DT,
       CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
        FROM TEMP_ORDER_ITEM_SHIPMENT
       WHERE DML_ORACLE_ID = vgc_job_id
         AND TEMP_SHIP_SEQ > vgn_temp_ship_seq
         AND ROWNUM < (vgn_commit_count + 1)
       ORDER BY TEMP_SHIP_SEQ;

  BEGIN

    vgc_job_id          := vic_job_id;
    vgc_log_name        := 'P_PROCESS_TEMP_ORDER_ITEMS';
    vgn_log_line        := 0;
    vgn_sql_result      := 0;
    vgn_temp_ship_seq   := 0;
    vln_nbr_edited      := 0;
    vln_tois_open_count := 0;

    /*  DSM 9/30/98  */
    vgn_commit_count := vin_commit_count;
    vln_runtime      := TO_CHAR(SYSDATE, 'HH24MI');
    vlc_runday       := TO_CHAR(SYSDATE, 'DAY');
    vgc_parm_id      := (SUBSTR(vgc_job_id, 1, 3) ||
                        SUBSTR(vgc_job_id,
                                5,
                                LENGTH(RTRIM(vgc_job_id)) - 6) || 'DATE');

    SELECT /* changed date length from 9 to 11 BLR 6/30/98 */
     TO_DATE(SUBSTR(PARAMETER_FIELD, 1, 11), 'DD-MON-YYYY')
      INTO vld_dbload_date
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = vgc_parm_id;

    IF vld_dbload_date IS NULL THEN
      -- IF vlc_runday = 'SUNDAY   ' THEN
      --    vld_dbload_date := TRUNC(SYSDATE - 2);
      -- ELSE
      IF (vln_runtime >= 0) AND (vln_runtime <= 1259) THEN
        vld_dbload_date := TRUNC(SYSDATE - 1);
      ELSIF (vln_runtime >= 1300) AND (vln_runtime <= 2459) THEN
        vld_dbload_date := TRUNC(SYSDATE);
      ELSE
        RAISE_APPLICATION_ERROR(-20200,
                                'DATABASE LOAD DATE REQUIRED AS PARAMETER');
      END IF;
      -- END IF;
    ELSE
      UPDATE DELIVERY_PARAMETER_LOCAL
         SET PARAMETER_FIELD = NULL
       WHERE PARAMETER_ID = vgc_parm_id;
    END IF;

    DBMS_OUTPUT.PUT_LINE('PARM DB LOAD DATE:  ' || vld_dbload_date);

    OPEN cur_temp_row;
    LOOP
      FETCH cur_temp_row
        INTO vgn_temp_ship_seq
      , ois.update_code
      , ois.organization_key_id
      , ois.amp_order_nbr
      , ois.order_item_nbr
      , ois.shipment_id
      , ois.dml_oracle_id
      , ois.dml_tmstmp
      , ois.purchase_by_account_base
      , ois.ship_to_account_suffix
      , ois.accounting_org_key_id
      , ois.prodcn_cntrlr_code
      , ois.item_quantity
      , ois.resrvn_level_1
      , ois.resrvn_level_5
      , ois.resrvn_level_9
      , ois.quantity_released
      , ois.quantity_shipped
      , ois.iso_currency_code_1
      , ois.local_currency_billed_amount
      , ois.extended_book_bill_amount
      , ois.unit_price
      , ois.customer_request_date
      , ois.amp_schedule_date
      , ois.release_date
      , ois.amp_shipped_date
      , ois.nbr_window_days_early
      , ois.nbr_window_days_late
      , ois.inventory_location_code
      , ois.inventory_building_nbr
      , ois.controller_uniqueness_id
      , ois.actual_ship_location
      , ois.actual_ship_building_nbr
      , ois.schedule_ship_cmprsn_code
      , ois.schedule_to_ship_variance
      , ois.varbl_schedule_ship_variance
      , ois.request_ship_cmprsn_code
      , ois.request_to_ship_variance
      , ois.varbl_request_ship_variance
      , ois.request_schedule_cmprsn_code
      , ois.request_to_schedule_variance
      , ois.current_to_request_variance
      , ois.current_to_schedule_variance
      , ois.received_to_request_variance
      , ois.received_to_schedule_variance
      , ois.received_to_ship_variance
      , ois.varbl_received_ship_variance
      , ois.release_to_schedule_variance
      , ois.release_schedule_cmprsn_code
      , ois.ship_facility_cmprsn_code
      , ois.release_to_ship_variance
      , ois.order_booking_date
      , ois.order_received_date
      , ois.order_type_id
      , ois.regtrd_date
      , ois.reported_as_of_date
      , ois.database_load_date
      , ois.purchase_order_date
      , ois.purchase_order_nbr
      , ois.prodcn_cntlr_employee_nbr
      , ois.part_prcr_src_org_key_id
      , ois.team_code
      , ois.stock_make_code
      , ois.product_code
      , ois.product_line_code
      , ois.ww_account_nbr_base
      , ois.ww_account_nbr_suffix
      , ois.customer_forecast_code
      , ois.a_territory_nbr
      , ois.customer_reference_part_nbr
      , ois.customer_expedite_date
      , ois.nbr_of_expedites
      , ois.original_expedite_date
      , ois.current_expedite_date
      , ois.earliest_expedite_date
      , ois.schedule_on_credit_hold_date
      , ois.schedule_off_credit_hold_date
      , ois.customer_credit_hold_ind
      , ois.customer_on_credit_hold_date
      , ois.customer_off_credit_hold_date
      , ois.temp_hold_ind
      , ois.temp_hold_on_date
      , ois.temp_hold_off_date
      , ois.customer_type_code
      , ois.industry_code
      , ois.product_busns_line_id
      , ois.product_busns_line_fnctn_id
      , ois.customer_acct_type_cde
      , ois.mfr_org_key_id
      , ois.mfg_campus_id
      , ois.mfg_building_nbr
      , ois.remaining_qty_to_ship
      , ois.fiscal_month
      , ois.fiscal_quarter
      , ois.fiscal_year
      , ois.industry_business_code
      , ois.sbmt_part_nbr
      , ois.sbmt_customer_acct_nbr
      , ois.profit_center_abbr_nm
      , ois.brand_id
      , ois.schd_tyco_month_of_year_id
      , ois.schd_tyco_quarter_id
      , ois.schd_tyco_year_id
      , ois.sold_to_customer_id
      , ois.invoice_nbr
      , ois.delivery_block_cde
      , ois.credit_check_status_cde
      , ois.sales_organization_id
      , ois.distribution_channel_cde
      , ois.order_division_cde
      , ois.item_division_cde
      , ois.matl_account_asgn_grp_cde
      , ois.data_source_desc
      , ois.batch_id
      , ois.prime_worldwide_customer_id
      , ois.sales_document_type_cde
      , ois.material_type_cde
      , ois.drop_shipment_ind
      , ois.sales_office_cde
      , ois.sales_group_cde
      , ois.sbmt_part_prcr_src_org_id
      , ois.budget_rate_book_bill_amt
      , ois.hierarchy_customer_ind
      , ois.hierarchy_customer_org_id
      , ois.hierarchy_customer_base_id
      , ois.hierarchy_customer_sufx_id
      , ois.gfc_extended_true_amp_cost
      , ois.part_um
      , ois.product_manager_global_id
      , ois.sbmt_original_schedule_dt
      , ois.sbmt_current_schedule_dt
      , ois.sbmt_sold_to_customer_id
      , ois.tyco_ctrl_delivery_hold_on_dt
      , ois.tyco_ctrl_delivery_hold_off_dt
      , ois.tyco_ctrl_delivery_block_cde
      , ois.pick_pack_work_days_qty
      , ois.loading_nbr_of_work_days_qty
      , ois.trsp_lead_time_days_qty
      , ois.transit_time_days_qty
      , ois.delivery_item_category_cde
      , ois.delivery_in_process_qty
      , ois.order_header_billing_block_cde
      , ois.item_billing_block_cde
      , ois.fixed_date_quantity_ind
      , ois.sap_bill_to_customer_id
      , ois.delivery_document_nbr_id
      , ois.delivery_document_item_nbr_id
      , ois.misc_local_flag_cde_1
      , ois.misc_local_cde_1
      , ois.misc_local_cde_2
      , ois.misc_local_cde_3
      , ois.cust_ord_req_reset_reason_cde
      , ois.cust_ord_req_reset_reason_dt
      , ois.customer_order_edi_type_cde
      , ois.ultimate_end_customer_id
      , ois.ultimate_end_cust_acct_grp_cde
      , ois.mrp_group_cde
      , ois.complete_delivery_ind
      , ois.part_key_id
      , ois.planned_installation_cmpl_dt
      , ois.source_id
      , ois.data_src_id
      , ois.distr_ship_when_avail_ind
      , ois.consolidation_indicator_cde
      , ois.consolidation_dt
      , ois.costed_sales_exclusion_cde
      , ois.sap_profit_center_cde
      , ois.storage_location_id
      , ois.sales_territory_cde
      , vgr_temp_rowid
      , ois.requested_on_dock_dt
      , ois.scheduled_on_dock_dt
      , ois.ship_to_customer_key_id
      , ois.sold_to_customer_key_id
      , ois.hierarchy_customer_key_id
      , ois.ultimate_end_customer_key_id
      , ois.bill_of_lading_id
      , ois.sbmt_fwd_agent_vendor_id
      , ois.fwd_agent_vendor_key_id
      , ois.intl_commercial_terms_cde
      , ois.intl_cmcl_term_additional_desc
      , ois.shipping_trsp_category_cde
      , ois.header_cust_order_received_dt
      , ois.sbmt_schd_agr_cancel_ind_cde
      , ois.schd_agr_cancel_indicator_cde
      , ois.consumed_sa_order_item_nbr_id
      , ois.consumed_sa_order_number_id
      , ois.sbmt_sb_cnsn_itrst_prtncust_id
      , ois.sb_cnsn_itrst_prtn_cust_key_id
      , ois.shipping_conditions_cde
      , ois.sbmt_zi_cnsn_stk_prtn_cust_id
      , ois.zi_cnsn_stk_prtn_cust_key_id
      , ois.sbmt_sales_territory_cde
      , ois.sbmt_sales_office_cde
      , ois.sbmt_sales_group_cde
      , ois.schedule_line_nbr
      , ois.sbmt_schedule_line_nbr
      , ois.trsp_mge_transit_time_days_qty
      , ois.discontinued_operations_cde
      , ois.order_received_dt
      , ois.order_created_by_ntwk_user_id
      , ois.delivery_doc_creation_dt
      , ois.delivery_doc_creation_tm
      , ois.dlvr_doc_cret_by_ntwk_user_id
      , ois.pricing_condition_type_cde
      , ois.planned_goods_issue_dt
      , ois.schedule_line_category_cde
      , ois.initial_request_dt
      , ois.initial_request_qty
      , ois.material_availability_dt
      , ois.cust_pur_ord_line_item_nbr_id  -- Kumar 11/05/2012 Added below 6 Columns for 2012 Q1 Enhancements
      , ois.billing_type_cde
      , ois.sap_delivery_type_cde
      , ois.shipment_number_id
      , ois.expedite_indicator_cde
      , ois.expedite_status_desc
      , ois.modified_customer_request_dt
      , ois.CUSTOMER_REQUESTED_EXPEDITE_DT  -- RB
      ;

      EXIT WHEN(cur_temp_row%NOTFOUND);

      IF (cur_temp_row%ROWCOUNT = 1) AND
         (ois.database_load_date IS NOT NULL) THEN
        vld_dbload_date := ois.database_load_date;
        DBMS_OUTPUT.PUT_LINE('OVERRIDE DB LOAD DATE:  ' || vld_dbload_date);
      END IF;

      vgn_temp_count := vgn_temp_count + 1;
      IF ois.amp_shipped_date IS NULL THEN
        vgn_open_count := vgn_open_count + 1;
      ELSE
        vgn_ship_count := vgn_ship_count + 1;
        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'JAN' THEN
          vgn_ship_jan_count := vgn_ship_jan_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'FEB' THEN
          vgn_ship_feb_count := vgn_ship_feb_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'MAR' THEN
          vgn_ship_mar_count := vgn_ship_mar_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'APR' THEN
          vgn_ship_apr_count := vgn_ship_apr_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'MAY' THEN
          vgn_ship_may_count := vgn_ship_may_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'JUN' THEN
          vgn_ship_jun_count := vgn_ship_jun_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'JUL' THEN
          vgn_ship_jul_count := vgn_ship_jul_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'AUG' THEN
          vgn_ship_aug_count := vgn_ship_aug_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'SEP' THEN
          vgn_ship_sep_count := vgn_ship_sep_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'OCT' THEN
          vgn_ship_oct_count := vgn_ship_oct_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'NOV' THEN
          vgn_ship_nov_count := vgn_ship_nov_count + 1;
        END IF;

        IF TO_CHAR(ois.amp_shipped_date, 'MON') = 'DEC' THEN
          vgn_ship_dec_count := vgn_ship_dec_count + 1;
        END IF;
      END IF;

      IF ois.stock_make_code = '*' THEN
        vgn_make_stock_null_count := vgn_make_stock_null_count + 1;
      END IF;

      IF ois.product_line_code = '*' THEN
        vgn_pl_null_count := vgn_pl_null_count + 1;
      END IF;

      IF ois.part_prcr_src_org_key_id = 0 THEN
        vgn_ppsoc_null_count := vgn_ppsoc_null_count + 1;
      END IF;

      IF ois.product_code = '*' THEN
        vgn_prod_code_null_count := vgn_prod_code_null_count + 1;
      END IF;

      IF ois.prodcn_cntlr_employee_nbr = '*' THEN
        vgn_cntlr_emp_null_count := vgn_cntlr_emp_null_count + 1;
      END IF;

      IF ois.team_code = '*' THEN
        vgn_team_null_count := vgn_team_null_count + 1;
      END IF;

      IF ois.update_code IS NOT NULL THEN
        GOTO commit_work;
      ELSE
        vln_nbr_edited := vln_nbr_edited + 1;
      END IF;

      temp_ois                    := ois;
      temp_ois.database_load_date := vld_dbload_date;

      Pkg_Edit_Temp_Order_Daf.P_EDIT_TEMP_ORDER_ITEM(temp_ois,
                                                     vgn_sql_result);

      IF vgn_sql_result != 0 THEN
        RAISE ue_critical_db_error;
      END IF;

      IF temp_ois.amp_shipped_date IS NULL THEN
        IF Scdcommonbatch.GetCompanyOrgID(temp_ois.organization_key_id,
                                          temp_ois.reported_as_of_date,
                                          vgc_org_id) THEN
          NULL;
        END IF;
      ELSE
        IF Scdcommonbatch.GetCompanyOrgID(temp_ois.organization_key_id,
                                          temp_ois.amp_shipped_date,
                                          vgc_org_id) THEN
          NULL;
        END IF;
      END IF;

      IF vgc_org_id != Scdcommonbatch.gUSCoOrgID THEN
        IF temp_ois.current_expedite_date IS NOT NULL THEN
          IF temp_ois.original_expedite_date IS NULL THEN
            temp_ois.original_expedite_date := temp_ois.current_expedite_date;
          END IF;

          IF temp_ois.earliest_expedite_date IS NULL THEN
            temp_ois.earliest_expedite_date := temp_ois.current_expedite_date;
          END IF;
        END IF;
      END IF;

      IF temp_ois.update_code = 'B' THEN
        /* Bypass */
        P_DELETE_TEMP_OIS;

        IF vgn_sql_result != 0 THEN
          RAISE ue_critical_db_error;
        END IF;

        IF temp_ois.amp_shipped_date IS NULL THEN
          vgn_bypass_open := vgn_bypass_open + 1;
        ELSE
          vgn_bypass_ship := vgn_bypass_ship + 1;
        END IF;

        GOTO commit_work;
      END IF;

      Pkg_Variance_Calc.P_VARIANCE_CALC(temp_ois, vgn_sql_result);
      IF vgn_sql_result != 0 THEN
        RAISE ue_critical_db_error;
      END IF;

      ois := temp_ois;

      IF (ois.current_to_request_variance = 0) AND
         (ois.current_to_schedule_variance = 0) THEN
        ois.reported_as_of_date := NULL;
      END IF;

      IF vgc_org_id != Scdcommonbatch.gUSCoOrgID THEN
        IF (ois.temp_hold_off_date > ois.database_load_date) THEN
          ois.temp_hold_ind := 'T';
        ELSE
          ois.temp_hold_ind := NULL;
        END IF;
      END IF;

      IF ois.amp_shipped_date IS NULL THEN
        -- ois.database_load_date := NULL ;
        ois.nbr_window_days_early := NULL;
        ois.nbr_window_days_late  := NULL;
      ELSE
        ois.current_to_request_variance  := NULL;
        ois.current_to_schedule_variance := NULL;
      END IF;

      P_CHECK_FOR_CHANGE;
      IF vgn_sql_result != 0 THEN
        RAISE ue_critical_db_error;
      END IF;

      P_UPDATE_TEMP_OIS;
      IF vgn_sql_result != 0 THEN
        RAISE ue_critical_db_error;
      END IF;

      <<commit_work>>
      vgn_nbr_processed := vgn_nbr_processed + 1;
      IF vgn_nbr_processed = vgn_commit_count THEN
        COMMIT;
        vgn_nbr_processed := 0;
        CLOSE cur_temp_row;

        OPEN cur_temp_row;
      END IF;

    END LOOP;
    CLOSE cur_temp_row;

    IF vln_nbr_edited > 0 THEN
      P_COMPLETE_EDITS;

      IF vgn_sql_result != 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    /* DSM 9/30/98  - Begin */
    IF vgc_job_id != 'SCDU0S00' THEN
      SELECT COUNT(*)
        INTO vln_tois_open_count
        FROM TEMP_ORDER_ITEM_SHIPMENT
       WHERE DML_ORACLE_ID = vgc_job_id
         AND UPDATE_CODE IS NOT NULL
         AND AMP_SHIPPED_DATE IS NULL
         AND ROWNUM < 2;

      /* If no opens exist on temp_order_item_shipment table */
      /* only shipments are being processed,                 */
      /* so don't delete opens on order_item_open table  DSM */

      IF vln_tois_open_count != 0 THEN
        P_DELETE_ORDER_ITEM_OPEN;
        IF vgn_sql_result != 0 THEN
          RAISE ue_critical_db_error;
        END IF;

        P_SET_TOIS_UPDATE_CODE;
        IF vgn_sql_result != 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    END IF;

    /* DSM 9/30/98  - End */
    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'TEMPS READ:         ' || vgn_temp_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'OPENS ADDED:        ' || vgn_open_add_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'OPENS CHANGED:      ' || vgn_open_change_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'OPENS DELETED:      ' || vgn_open_delete_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'OPENS TO SHIPS:     ' || vgn_open_to_ship_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'OPENS NOT CHANGED:  ' || vgn_no_change_count));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       vgc_log_name,
       vgc_job_id,
       SYSDATE,
       vgn_log_line,
       ('**** ' || 'SHIPS ADDED:        ' || vgn_ship_add_count));

    COMMIT;

    /* Error processing */

  EXCEPTION
    WHEN ue_critical_db_error THEN
      vion_result := vgn_sql_result;
      ROLLBACK;
      vgn_log_line  := vgn_log_line + 1;
      vgc_sql_error := SQLERRM(vion_result);
      INSERT INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         vgc_log_name,
         vgc_job_id,
         SYSDATE,
         vgn_log_line,
         ('DBER ' || SUBSTR(vgc_sql_error, 1, 70)));
      COMMIT;
      /* Commit the error msg */
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_PROCESS_ORDER_ITEMS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(vion_result));
      vgn_log_line  := vgn_log_line + 1;
      vgc_sql_error := SQLERRM(vion_result);
      INSERT INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         vgc_log_name,
         vgc_job_id,
         SYSDATE,
         vgn_log_line,
         ('DBER ' || SUBSTR(vgc_sql_error, 1, 70)));
      COMMIT;

    /* Commit the error msg */

  END P_PROCESS_TEMP_ORDER_ITEMS;

END PKG_DELVSCD_DATA_LOAD;
/
