-- DROP PACKAGE SCD_SOURCE.PKG_HISTORY;

CREATE OR REPLACE PACKAGE SCD_SOURCE.PKG_HISTORY
AS

/*
**********************************************************************************************************
* PACKAGE:     pkg_delvscd_data_load
* DESCRIPTION: Collection of utility functions, procedures, and other PL/SQL objects for SCD Shipments History table.
* Created :    08/10/2010  Alex Orbeta
* PROCEDURES:  
*              
*              
*              
*              
*              
*              
*  ----------------------------------------------------------------------------------------------------------
* MODIFICATION LOG
*
* Date       Programmer  Description
* --------   ----------  ------------------------------------------------
* 12/29/2010 Alex Orbeta Add physical building.
* 01/12/2011 Alex Orbeta Add Forecast Prime Partner fields for Sched Agrmt phase 2.
* 04/06/2011 Alex Orbeta Add Mfg Bldg, default mfg plant, and verdon id.
* 07/06/2011 Kumar Emany Add TELAG 1535 fields and and pricing_condition_type_cde
* 08/29/2011 A. Orbeta   Add planned_goods_issue_dt as part of 1535 changes.
* 01/04/2011 M. Feenstra Add SCHEDULE_LINE_CATEGORY_CDE and INITIAL_REQUEST_DT.
* 06/12/2012 M. Feenstra Added INITIAL_REQUEST_QTY and MATERIAL_AVAILABILITY_DT.
* 11/05/2012 Kumar Emany Add BILLING_TYPE_CDE, CUST_PUR_ORD_LINE_ITEM_NBR_ID, 
*                        SAP_DELIVERY_TYPE_CDE, SHIPMENT_NUMBER_ID Columns for 2012 Q1 Enhancements
***********************************************************************************************************
*/

-- ----------------------------------------------------------------------------------------------------------

-- declare public global variables, constants, etc.

-- declare public subprograms

-- ----------------------------------------------------------------------------------------------------------

-- copy OIS recs > 16 months (retention in SCD02MNTHS param) into OIS history table

PROCEDURE copy_OIS_to_hist;

-- delete OIS history records > 36 months (purge date in CPYHISTSTAT param)
PROCEDURE purge_OISH_recs;

END PKG_HISTORY;
/

-- DROP PACKAGE BODY SCD_SOURCE.PKG_HISTORY;

CREATE OR REPLACE PACKAGE BODY SCD_SOURCE.PKG_HISTORY
AS

  -- declare global variables, constants, etc.
  k_commit_cnt CONSTANT NUMBER(5) := 10000;

  g_OIS_rec  order_item_shipment%ROWTYPE;
  g_purge_dt DATE;

-- ----------------------------------------------------------------------------------------------------------

  FUNCTION ins_OIS_to_hist RETURN BOOLEAN IS

    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'ins rec into OISH';
    INSERT INTO ORDER_ITEM_SHIPMENT_HISTORY
      (PURGED_TO_HIST_BY_MONTH_END_DT,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DML_ORACLE_ID,
       DML_TMSTMP,
       PURCHASE_BY_ACCOUNT_BASE,
       SHIP_TO_ACCOUNT_SUFFIX,
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
       TEAM_CODE,
       STOCK_MAKE_CODE,
       PRODUCT_CODE,
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
       MFG_CAMPUS_ID,
       MFG_BUILDING_NBR,
       REMAINING_QTY_TO_SHIP,
       INDUSTRY_BUSINESS_CODE,
       FISCAL_MONTH,
       FISCAL_QUARTER,
       FISCAL_YEAR,
       SBMT_PART_NBR,
       SBMT_CUSTOMER_ACCT_NBR,
       BRAND_ID,
       PRODUCT_BUSNS_LINE_ID,
       PRODUCT_BUSNS_LINE_FNCTN_ID,
       PROFIT_CENTER_ABBR_NM,
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
       ORGANIZATION_KEY_ID,
       CONTROLLER_UNIQUENESS_ID,
       MFR_ORG_KEY_ID,
       ACCOUNTING_ORG_KEY_ID,
       PRODUCT_LINE_CODE,
       CUSTOMER_ACCT_TYPE_CDE,
       PART_PRCR_SRC_ORG_KEY_ID,
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
       FIXED_DATE_QUANTITY_IND,
       ORDER_HEADER_BILLING_BLOCK_CDE,
       ITEM_BILLING_BLOCK_CDE,
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
       CUST_PUR_ORD_LINE_ITEM_NBR_ID,
       BILLING_TYPE_CDE,
       SAP_DELIVERY_TYPE_CDE,
       SHIPMENT_NUMBER_ID
       ) 
    VALUES
      (g_purge_dt,
       G_OIS_REC.amp_order_nbr,
       G_OIS_REC.order_item_nbr,
       G_OIS_REC.shipment_id,
       USER,
       SYSDATE,
       G_OIS_REC.purchase_by_account_base,
       G_OIS_REC.ship_to_account_suffix,
       G_OIS_REC.prodcn_cntrlr_code,
       G_OIS_REC.item_quantity,
       G_OIS_REC.resrvn_level_1,
       G_OIS_REC.resrvn_level_5,
       G_OIS_REC.resrvn_level_9,
       G_OIS_REC.quantity_released,
       G_OIS_REC.quantity_shipped,
       G_OIS_REC.iso_currency_code_1,
       G_OIS_REC.local_currency_billed_amount,
       G_OIS_REC.extended_book_bill_amount,
       G_OIS_REC.unit_price,
       G_OIS_REC.customer_request_date,
       G_OIS_REC.amp_schedule_date,
       G_OIS_REC.release_date,
       G_OIS_REC.amp_shipped_date,
       G_OIS_REC.nbr_window_days_early,
       G_OIS_REC.nbr_window_days_late,
       G_OIS_REC.inventory_location_code,
       G_OIS_REC.inventory_building_nbr,
       G_OIS_REC.actual_ship_location,
       G_OIS_REC.actual_ship_building_nbr,
       G_OIS_REC.schedule_ship_cmprsn_code,
       G_OIS_REC.schedule_to_ship_variance,
       G_OIS_REC.varbl_schedule_ship_variance,
       G_OIS_REC.request_ship_cmprsn_code,
       G_OIS_REC.request_to_ship_variance,
       G_OIS_REC.varbl_request_ship_variance,
       G_OIS_REC.request_schedule_cmprsn_code,
       G_OIS_REC.request_to_schedule_variance,
       G_OIS_REC.current_to_request_variance,
       G_OIS_REC.current_to_schedule_variance,
       G_OIS_REC.received_to_request_variance,
       G_OIS_REC.received_to_schedule_variance,
       G_OIS_REC.received_to_ship_variance,
       G_OIS_REC.varbl_received_ship_variance,
       G_OIS_REC.release_to_schedule_variance,
       G_OIS_REC.release_schedule_cmprsn_code,
       G_OIS_REC.ship_facility_cmprsn_code,
       G_OIS_REC.release_to_ship_variance,
       G_OIS_REC.order_booking_date,
       G_OIS_REC.order_received_date,
       G_OIS_REC.order_type_id,
       G_OIS_REC.regtrd_date,
       G_OIS_REC.reported_as_of_date,
       G_OIS_REC.database_load_date,
       G_OIS_REC.purchase_order_date,
       G_OIS_REC.purchase_order_nbr,
       G_OIS_REC.prodcn_cntlr_employee_nbr,
       G_OIS_REC.team_code,
       G_OIS_REC.stock_make_code,
       G_OIS_REC.product_code,
       G_OIS_REC.ww_account_nbr_base,
       G_OIS_REC.ww_account_nbr_suffix,
       G_OIS_REC.customer_forecast_code,
       G_OIS_REC.a_territory_nbr,
       G_OIS_REC.customer_reference_part_nbr,
       G_OIS_REC.customer_expedite_date,
       G_OIS_REC.nbr_of_expedites,
       G_OIS_REC.original_expedite_date,
       G_OIS_REC.current_expedite_date,
       G_OIS_REC.earliest_expedite_date,
       G_OIS_REC.schedule_on_credit_hold_date,
       G_OIS_REC.schedule_off_credit_hold_date,
       G_OIS_REC.customer_credit_hold_ind,
       G_OIS_REC.customer_on_credit_hold_date,
       G_OIS_REC.customer_off_credit_hold_date,
       G_OIS_REC.temp_hold_ind,
       G_OIS_REC.temp_hold_on_date,
       G_OIS_REC.temp_hold_off_date,
       G_OIS_REC.customer_type_code,
       G_OIS_REC.industry_code,
       G_OIS_REC.mfg_campus_id,
       G_OIS_REC.mfg_building_nbr,
       G_OIS_REC.remaining_qty_to_ship,
       G_OIS_REC.industry_business_code,
       G_OIS_REC.fiscal_month,
       G_OIS_REC.fiscal_quarter,
       G_OIS_REC.fiscal_year,
       G_OIS_REC.sbmt_part_nbr,
       G_OIS_REC.sbmt_customer_acct_nbr,
       G_OIS_REC.brand_id,
       G_OIS_REC.product_busns_line_id,
       G_OIS_REC.product_busns_line_fnctn_id,
       G_OIS_REC.profit_center_abbr_nm,
       G_OIS_REC.schd_tyco_month_of_year_id,
       G_OIS_REC.schd_tyco_quarter_id,
       G_OIS_REC.schd_tyco_year_id,
       G_OIS_REC.sold_to_customer_id,
       G_OIS_REC.invoice_nbr,
       G_OIS_REC.delivery_block_cde,
       G_OIS_REC.credit_check_status_cde,
       G_OIS_REC.sales_organization_id,
       G_OIS_REC.distribution_channel_cde,
       G_OIS_REC.order_division_cde,
       G_OIS_REC.item_division_cde,
       G_OIS_REC.matl_account_asgn_grp_cde,
       G_OIS_REC.data_source_desc,
       G_OIS_REC.batch_id,
       G_OIS_REC.organization_key_id,
       G_OIS_REC.controller_uniqueness_id,
       G_OIS_REC.mfr_org_key_id,
       G_OIS_REC.accounting_org_key_id,
       G_OIS_REC.product_line_code,
       G_OIS_REC.customer_acct_type_cde,
       G_OIS_REC.part_prcr_src_org_key_id,
       G_OIS_REC.prime_worldwide_customer_id,
       G_OIS_REC.sales_document_type_cde,
       G_OIS_REC.material_type_cde,
       G_OIS_REC.drop_shipment_ind,
       G_OIS_REC.sales_office_cde,
       G_OIS_REC.sales_group_cde,
       G_OIS_REC.sbmt_part_prcr_src_org_id,
       G_OIS_REC.budget_rate_book_bill_amt,
       G_OIS_REC.hierarchy_customer_ind,
       G_OIS_REC.hierarchy_customer_org_id,
       G_OIS_REC.hierarchy_customer_base_id,
       G_OIS_REC.hierarchy_customer_sufx_id,
       G_OIS_REC.gfc_extended_true_amp_cost,
       G_OIS_REC.product_manager_global_id,
       G_OIS_REC.sbmt_original_schedule_dt,
       G_OIS_REC.sbmt_current_schedule_dt,
       G_OIS_REC.part_um,
       G_OIS_REC.sbmt_sold_to_customer_id,
       G_OIS_REC.tyco_ctrl_delivery_hold_on_dt,
       G_OIS_REC.tyco_ctrl_delivery_hold_off_dt,
       G_OIS_REC.tyco_ctrl_delivery_block_cde,
       G_OIS_REC.pick_pack_work_days_qty,
       G_OIS_REC.loading_nbr_of_work_days_qty,
       G_OIS_REC.trsp_lead_time_days_qty,
       G_OIS_REC.transit_time_days_qty,
       G_OIS_REC.delivery_item_category_cde,
       G_OIS_REC.fixed_date_quantity_ind,
       G_OIS_REC.order_header_billing_block_cde,
       G_OIS_REC.item_billing_block_cde,
       G_OIS_REC.sap_bill_to_customer_id,
       G_OIS_REC.delivery_document_nbr_id,
       G_OIS_REC.delivery_document_item_nbr_id,
       G_OIS_REC.misc_local_flag_cde_1,
       G_OIS_REC.misc_local_cde_1,
       G_OIS_REC.misc_local_cde_2,
       G_OIS_REC.misc_local_cde_3,
       G_OIS_REC.customer_date_basis_cde,
       G_OIS_REC.actual_date_basis_cde,
       G_OIS_REC.ship_date_determination_cde,
       G_OIS_REC.cust_ord_req_reset_reason_cde,
       G_OIS_REC.cust_ord_req_reset_reason_dt,
       G_OIS_REC.customer_order_edi_type_cde,
       G_OIS_REC.ultimate_end_customer_id,
       G_OIS_REC.ultimate_end_cust_acct_grp_cde,
       G_OIS_REC.mrp_group_cde,
       G_OIS_REC.complete_delivery_ind,
       G_OIS_REC.part_key_id,
       G_OIS_REC.source_id,
       G_OIS_REC.data_src_id,
       G_OIS_REC.distr_ship_when_avail_ind,
       G_OIS_REC.super_data_security_tag_id,
       G_OIS_REC.consolidation_indicator_cde,
       G_OIS_REC.consolidation_dt,
       G_OIS_REC.sap_profit_center_cde,
       G_OIS_REC.storage_location_id,
       G_OIS_REC.sales_territory_cde,
       G_OIS_REC.requested_on_dock_dt,
       G_OIS_REC.scheduled_on_dock_dt,
       G_OIS_REC.ship_to_customer_key_id,
       G_OIS_REC.sold_to_customer_key_id,
       G_OIS_REC.hierarchy_customer_key_id,
       G_OIS_REC.ultimate_end_customer_key_id,
       G_OIS_REC.bill_of_lading_id,
       G_OIS_REC.sbmt_fwd_agent_vendor_id,
       G_OIS_REC.fwd_agent_vendor_key_id,
       G_OIS_REC.intl_commercial_terms_cde,
       G_OIS_REC.intl_cmcl_term_additional_desc,
       G_OIS_REC.shipping_trsp_category_cde,
       G_OIS_REC.header_cust_order_received_dt,
       G_OIS_REC.sbmt_schd_agr_cancel_ind_cde,
       G_OIS_REC.schd_agr_cancel_indicator_cde,
       G_OIS_REC.consumed_sa_order_item_nbr_id,
       G_OIS_REC.consumed_sa_order_number_id,
       G_OIS_REC.sbmt_sb_cnsn_itrst_prtncust_id,
       G_OIS_REC.sb_cnsn_itrst_prtn_cust_key_id,
       G_OIS_REC.shipping_conditions_cde,
       G_OIS_REC.sbmt_zi_cnsn_stk_prtn_cust_id,
       G_OIS_REC.zi_cnsn_stk_prtn_cust_key_id,
       G_OIS_REC.trsp_mge_transit_time_days_qty,
       G_OIS_REC.actual_ship_from_building_id,
       G_OIS_REC.sbmt_fcst_pp_cust_acct_nbr,
       G_OIS_REC.fcst_prm_prtn_customer_key_id,
       G_OIS_REC.fcst_prm_prtn_cust_acct_nbr,
       G_OIS_REC.fcst_prm_prtn_acct_group_cde,
       G_OIS_REC.default_manufacturing_plant_id,
       G_OIS_REC.vendor_key_id,
       G_OIS_REC.vendor_id,
       G_OIS_REC.order_received_dt,
       G_OIS_REC.order_created_by_ntwk_user_id,
       G_OIS_REC.delivery_doc_creation_dt,
       G_OIS_REC.delivery_doc_creation_tm,
       G_OIS_REC.dlvr_doc_cret_by_ntwk_user_id,
       G_OIS_REC.pricing_condition_type_cde,
       G_OIS_REC.planned_goods_issue_dt,
       G_OIS_REC.schedule_line_category_cde,
       G_OIS_REC.initial_request_dt,
       G_OIS_REC.initial_request_qty,
       G_OIS_REC.material_availability_dt,
       G_OIS_REC.cust_pur_ord_line_item_nbr_id,
       G_OIS_REC.billing_type_cde,
       G_OIS_REC.sap_delivery_type_cde,
       G_OIS_REC.shipment_number_id
       ); 

    RETURN FALSE;

  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RETURN TRUE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END ins_OIS_to_hist;

  -- ----------------------------------------------------------------------------------------------------------

  PROCEDURE del_OIS_from_hist(i_purge_dt DATE) IS
    CURSOR cur_OISH(i_hist_row_k_dt DATE) IS
      SELECT ROWID
        FROM order_item_shipment_history
       WHERE purged_to_hist_by_month_end_dt = i_hist_row_k_dt;

    v_error_section VARCHAR2(100);
    v_cnt           NUMBER(8) := 0;
  BEGIN
    v_error_section := 'del OIS rec from hist';
    FOR cur_OISH_rec in cur_OISH(i_purge_dt) LOOP
      DELETE order_item_shipment_history WHERE ROWID = cur_OISH_rec.ROWID;
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, k_commit_cnt) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Total Records Deleted = ' || v_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END del_OIS_from_hist;

  -- ----------------------------------------------------------------------------------------------------------

  PROCEDURE copy_OIS_to_hist IS
    CURSOR cur_OIS(i_purge_dt DATE) IS
      SELECT /*+ INDEX(order_item_shipment oish_pf2) */
       *
        FROM order_item_shipment
       WHERE amp_shipped_date <= i_purge_dt;

    new_exception EXCEPTION;
    v_error_section  VARCHAR2(100);
    v_cnt            NUMBER(7) := 0;
    v_rtn_months     VARCHAR2(5);
    v_OIS_rec_exist  BOOLEAN;
    v_err_msg        VARCHAR2(200);
    v_copy_hist_stat VARCHAR2(20);
  BEGIN
    v_error_section := 'get purge rtn months';
    v_rtn_months    := scdCommonBatch.GetParamValue('SCD02MTHS');

    v_error_section := 'calc curr purge date';
    g_purge_dt      := LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE),
                                           v_rtn_months * -1));

    v_error_section  := 'get copy hist stat';
    v_copy_hist_stat := scdCommonBatch.GetParamValueLocal('CPYHISTSTAT');

    IF SUBSTR(v_copy_hist_stat, 1, 1) = 'I' THEN
      -- incomplete from previous job run - verify to make sure dates are consistent
      IF g_purge_dt != TO_DATE(SUBSTR(v_copy_hist_stat, 3)) THEN
        -- current purge date  AND  copy hist stat date are not the same - need to investigate
        v_err_msg := 'User DefErr [Recopy process cannot proceed since current Copy Hist Dt=' ||
                     TO_CHAR(g_purge_dt, 'DD-MON-YYYY') ||
                     ' != save Copy Hist Dt=' ||
                     SUBSTR(v_copy_hist_stat, 3) ||
                     ' when it aborted - pls verify data]';
        RAISE new_exception;
      END IF;

      -- remove records from history
      del_OIS_from_hist(g_purge_dt);
    ELSIF SUBSTR(v_copy_hist_stat, 1, 1) = 'C' AND
          g_purge_dt = TO_DATE(SUBSTR(v_copy_hist_stat, 3)) THEN
      -- current purge date  AND  copy hist stat date are the same - need to investigate
      v_err_msg := 'User DefErr [Copy to history process for Copy Hist Dt=' ||
                   TO_CHAR(g_purge_dt, 'DD-MON-YYYY') ||
                   ' was done already - pls verify data]';
      RAISE new_exception;
    END IF;

    -- save copy hist stat  AND  date
    v_error_section := 'save copy hist stat  AND  date - inprogress';
    UPDATE delivery_parameter_local
       SET parameter_field = 'I' || '|' ||
                             TO_CHAR(g_purge_dt, 'DD-MON-YYYY')
     WHERE parameter_id = 'CPYHISTSTAT';
    COMMIT;

    v_error_section := 'open cur_OIS';
    OPEN cur_OIS(g_purge_dt);
    LOOP
      v_error_section := 'fetch cur_OIS rec';
      FETCH cur_OIS
        INTO g_OIS_rec;
      EXIT WHEN cur_OIS%NOTFOUND;

      v_error_section := 'ins_OIS_to_hist 1st time';
      v_OIS_rec_exist := ins_OIS_to_hist;
      IF v_ois_rec_exist THEN
        -- remove an old duplicate record
        DELETE order_item_shipment_history
         WHERE organization_key_id = g_OIS_rec.organization_key_id
           AND amp_order_nbr = g_OIS_rec.amp_order_nbr
           AND order_item_nbr = g_OIS_rec.order_item_nbr
           AND shipment_id = g_OIS_rec.shipment_id;

        -- reinsert the same PK record after delete
        v_error_section := 'ins_OIS_to_hist 2nd time';
        v_OIS_rec_exist := ins_OIS_to_hist;
        IF v_ois_rec_exist THEN
          -- this should not happend since you just removed the same unique K
          v_err_msg := 'User DefErr [duplicate record found in OIS hist on 2nd insert] ' ||
                       SQLERRM;
          RAISE new_exception;
        END IF;
      END IF;

      v_error_section := 'commit recs';
      v_cnt           := v_cnt + 1;
      IF MOD(v_cnt, k_commit_cnt) = 0 THEN
        COMMIT;
      END IF;

    END LOOP;

    v_error_section := 'save copy hist stat  AND  date - complete';
    UPDATE delivery_parameter_local
       SET parameter_field = 'C' || '|' ||
                             TO_CHAR(g_purge_dt, 'DD-MON-YYYY')
     WHERE parameter_id = 'CPYHISTSTAT';
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Total Records Copied = ' || v_cnt);
  EXCEPTION
    WHEN new_exception THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101,
                              v_err_msg || ' in ' || v_error_section);
    WHEN OTHERS THEN
      v_err_msg := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101,
                              v_err_msg || ' in ' || v_error_section);
  END copy_OIS_to_hist;

  -- ----------------------------------------------------------------------------------------------------------

  PROCEDURE purge_OISH_recs IS
    CURSOR cur_OISH(i_purge_dt DATE) IS
      SELECT ROWID,
             organization_key_id,
             amp_order_nbr,
             order_item_nbr,
             shipment_id
        FROM order_item_shipment_history
       WHERE amp_shipped_date <= i_purge_dt;

    v_error_section VARCHAR2(100);
    v_cnt           NUMBER(8) := 0;
    v_rtn_months    VARCHAR2(5);
    v_hist_purge_dt DATE;
    v_err_msg       VARCHAR2(200);
  BEGIN
    v_error_section := 'get history retention months';
    v_rtn_months    := scdCommonBatch.GetParamValueLocal('HISTRTNMTHS');

    v_error_section := 'calc history purge date';
    -- N full calendar months plus current month
    v_hist_purge_dt := LAST_DAY(ADD_MONTHS(TRUNC(SYSDATE),
                                           (v_rtn_months + 1) * -1));

    v_error_section := 'del OIS rec from hist';
    FOR cur_OISH_rec in cur_OISH(v_hist_purge_dt) LOOP
      v_error_section := 'del OIS history rec';
      DELETE order_item_shipment_history WHERE ROWID = cur_OISH_rec.ROWID;

      v_error_section := 'del OIS security rec';
      DELETE order_item_ship_data_security
       WHERE organization_key_id = cur_OISH_rec.organization_key_id
         AND amp_order_nbr = cur_OISH_rec.amp_order_nbr
         AND order_item_nbr = cur_OISH_rec.order_item_nbr
         AND shipment_id = cur_OISH_rec.shipment_id;

      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, k_commit_cnt) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Total Records Deleted = ' || v_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      v_err_msg := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101,
                              v_err_msg || ' in ' || v_error_section);
  END purge_OISH_recs;

-- ----------------------------------------------------------------------------------------------------------

END PKG_HISTORY;
/
