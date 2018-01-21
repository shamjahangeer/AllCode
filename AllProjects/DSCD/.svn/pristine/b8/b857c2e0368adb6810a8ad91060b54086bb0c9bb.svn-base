CREATE OR REPLACE VIEW SCD.ORDER_ITEM_SHIPMENT_LOAD_TIME
(amp_order_nbr, order_item_nbr, shipment_id, dml_oracle_id, dml_tmstmp, purchase_by_account_base, ship_to_account_suffix, prodcn_cntrlr_code, item_quantity, resrvn_level_1, resrvn_level_5, resrvn_level_9, quantity_released, quantity_shipped, iso_currency_code_1, local_currency_billed_amount, extended_book_bill_amount, range_code, unit_price, customer_request_date, amp_schedule_date, release_date, actual_on_dock_date, amp_shipped_date, nbr_window_days_early, nbr_window_days_late, inventory_location_code, inventory_building_nbr, actual_ship_location, actual_ship_building_nbr, schedule_ship_cmprsn_code, schedule_to_ship_variance, varbl_schedule_ship_variance, request_ship_cmprsn_code, request_to_ship_variance, varbl_request_ship_variance, request_schedule_cmprsn_code, request_to_schedule_variance, current_to_request_variance, current_to_schedule_variance, received_to_request_variance, received_to_schedule_variance, received_to_ship_variance, varbl_received_ship_variance, release_to_schedule_variance, release_schedule_cmprsn_code, ship_facility_cmprsn_code, release_to_ship_variance, order_booking_date, order_received_date, order_type_id, regtrd_date, reported_as_of_date, database_load_date, inventory_classfcn_code, purchase_order_date, purchase_order_nbr, prodcn_cntlr_employee_nbr, schlg_method_code, team_code, stock_make_code, product_code, ww_account_nbr_base, ww_account_nbr_suffix, customer_forecast_code, a_territory_nbr, customer_reference_part_nbr, customer_expedite_date, nbr_of_expedites, original_expedite_date, current_expedite_date, earliest_expedite_date, schedule_on_credit_hold_date, schedule_off_credit_hold_date, customer_credit_hold_ind, customer_on_credit_hold_date, temp_hold_ind, temp_hold_on_date, temp_hold_off_date, forced_bill_ind, customer_type_code, rush_ind, industry_code, product_busns_line_id, product_busns_line_fnctn_id, mfg_campus_id, mfg_building_nbr, industry_business_code, fiscal_month, fiscal_quarter, fiscal_year, sbmt_part_nbr, sbmt_customer_acct_nbr, brand_id, profit_center_abbr_nm, schd_tyco_month_of_year_id, schd_tyco_quarter_id, schd_tyco_year_id, sold_to_customer_id, invoice_nbr, delivery_block_cde, credit_check_status_cde, sales_organization_id, distribution_channel_cde, order_division_cde, item_division_cde, matl_account_asgn_grp_cde, data_source_desc, batch_id, organization_key_id, mfr_org_key_id, accounting_org_key_id, customer_acct_type_cde, product_line_code, part_prcr_src_org_key_id, controller_uniqueness_id, prime_worldwide_customer_id, sales_document_type_cde, material_type_cde, drop_shipment_ind, sales_office_cde, sales_group_cde, part_key_id, scorecard_organization_id, group_organization_id, company_organization_id, accounting_organization_id, part_prcr_source_org_id, manufacturing_org_id)
AS
SELECT OIS.AMP_ORDER_NBR,
          OIS.ORDER_ITEM_NBR,
          OIS.SHIPMENT_ID,
          OIS.DML_ORACLE_ID,
          OIS.DML_TMSTMP,
          OIS.PURCHASE_BY_ACCOUNT_BASE,
          OIS.SHIP_TO_ACCOUNT_SUFFIX,
          OIS.PRODCN_CNTRLR_CODE,
          OIS.ITEM_QUANTITY,
          OIS.RESRVN_LEVEL_1,
          OIS.RESRVN_LEVEL_5,
          OIS.RESRVN_LEVEL_9,
          OIS.QUANTITY_RELEASED,
          OIS.QUANTITY_SHIPPED,
          OIS.ISO_CURRENCY_CODE_1,
          OIS.LOCAL_CURRENCY_BILLED_AMOUNT,
          OIS.EXTENDED_BOOK_BILL_AMOUNT,
          OIS.RANGE_CODE,
          OIS.UNIT_PRICE,
          OIS.CUSTOMER_REQUEST_DATE,
          OIS.AMP_SCHEDULE_DATE,
          OIS.RELEASE_DATE,
          OIS.ACTUAL_ON_DOCK_DATE,
          OIS.AMP_SHIPPED_DATE,
          OIS.NBR_WINDOW_DAYS_EARLY,
          OIS.NBR_WINDOW_DAYS_LATE,
          OIS.INVENTORY_LOCATION_CODE,
          OIS.INVENTORY_BUILDING_NBR,
          OIS.ACTUAL_SHIP_LOCATION,
          OIS.ACTUAL_SHIP_BUILDING_NBR,
          OIS.SCHEDULE_SHIP_CMPRSN_CODE,
          OIS.SCHEDULE_TO_SHIP_VARIANCE,
          OIS.VARBL_SCHEDULE_SHIP_VARIANCE,
          OIS.REQUEST_SHIP_CMPRSN_CODE,
          OIS.REQUEST_TO_SHIP_VARIANCE,
          OIS.VARBL_REQUEST_SHIP_VARIANCE,
          OIS.REQUEST_SCHEDULE_CMPRSN_CODE,
          OIS.REQUEST_TO_SCHEDULE_VARIANCE,
          OIS.CURRENT_TO_REQUEST_VARIANCE,
          OIS.CURRENT_TO_SCHEDULE_VARIANCE,
          OIS.RECEIVED_TO_REQUEST_VARIANCE,
          OIS.RECEIVED_TO_SCHEDULE_VARIANCE,
          OIS.RECEIVED_TO_SHIP_VARIANCE,
          OIS.VARBL_RECEIVED_SHIP_VARIANCE,
          OIS.RELEASE_TO_SCHEDULE_VARIANCE,
          OIS.RELEASE_SCHEDULE_CMPRSN_CODE,
          OIS.SHIP_FACILITY_CMPRSN_CODE,
          OIS.RELEASE_TO_SHIP_VARIANCE,
          OIS.ORDER_BOOKING_DATE,
          OIS.ORDER_RECEIVED_DATE,
          OIS.ORDER_TYPE_ID,
          OIS.REGTRD_DATE,
          OIS.REPORTED_AS_OF_DATE,
          OIS.DATABASE_LOAD_DATE,
          OIS.INVENTORY_CLASSFCN_CODE,
          OIS.PURCHASE_ORDER_DATE,
          OIS.PURCHASE_ORDER_NBR,
          OIS.PRODCN_CNTLR_EMPLOYEE_NBR,
          OIS.SCHLG_METHOD_CODE,
          OIS.TEAM_CODE,
          OIS.STOCK_MAKE_CODE,
          OIS.PRODUCT_CODE,
          OIS.WW_ACCOUNT_NBR_BASE,
          OIS.WW_ACCOUNT_NBR_SUFFIX,
          OIS.CUSTOMER_FORECAST_CODE,
          OIS.A_TERRITORY_NBR,
          OIS.CUSTOMER_REFERENCE_PART_NBR,
          OIS.CUSTOMER_EXPEDITE_DATE,
          OIS.NBR_OF_EXPEDITES,
          OIS.ORIGINAL_EXPEDITE_DATE,
          OIS.CURRENT_EXPEDITE_DATE,
          OIS.EARLIEST_EXPEDITE_DATE,
          OIS.SCHEDULE_ON_CREDIT_HOLD_DATE,
          OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE,
          OIS.CUSTOMER_CREDIT_HOLD_IND,
          OIS.CUSTOMER_ON_CREDIT_HOLD_DATE,
          OIS.TEMP_HOLD_IND,
          OIS.TEMP_HOLD_ON_DATE,
          OIS.TEMP_HOLD_OFF_DATE,
          OIS.FORCED_BILL_IND,
          OIS.CUSTOMER_TYPE_CODE,
          OIS.RUSH_IND,
          OIS.INDUSTRY_CODE,
          OIS.PRODUCT_BUSNS_LINE_ID,
          OIS.PRODUCT_BUSNS_LINE_FNCTN_ID,
          OIS.MFG_CAMPUS_ID,
          OIS.MFG_BUILDING_NBR,
          OIS.INDUSTRY_BUSINESS_CODE,
          OIS.FISCAL_MONTH,
          OIS.FISCAL_QUARTER,
          OIS.FISCAL_YEAR,
          OIS.SBMT_PART_NBR,
          OIS.SBMT_CUSTOMER_ACCT_NBR,
          OIS.BRAND_ID,
          OIS.PROFIT_CENTER_ABBR_NM,
          OIS.SCHD_TYCO_MONTH_OF_YEAR_ID,
          OIS.SCHD_TYCO_QUARTER_ID,
          OIS.SCHD_TYCO_YEAR_ID,
          OIS.SOLD_TO_CUSTOMER_ID,
          OIS.INVOICE_NBR,
          OIS.DELIVERY_BLOCK_CDE,
          OIS.CREDIT_CHECK_STATUS_CDE,
          OIS.SALES_ORGANIZATION_ID,
          OIS.DISTRIBUTION_CHANNEL_CDE,
          OIS.ORDER_DIVISION_CDE,
          OIS.ITEM_DIVISION_CDE,
          OIS.MATL_ACCOUNT_ASGN_GRP_CDE,
          OIS.DATA_SOURCE_DESC,
          OIS.BATCH_ID,
          OIS.ORGANIZATION_KEY_ID,
          OIS.MFR_ORG_KEY_ID,
          OIS.ACCOUNTING_ORG_KEY_ID,
          OIS.CUSTOMER_ACCT_TYPE_CDE,
          OIS.PRODUCT_LINE_CODE,
          OIS.PART_PRCR_SRC_ORG_KEY_ID,
          OIS.CONTROLLER_UNIQUENESS_ID,
          OIS.PRIME_WORLDWIDE_CUSTOMER_ID,
          OIS.SALES_DOCUMENT_TYPE_CDE,
          OIS.MATERIAL_TYPE_CDE,
          OIS.DROP_SHIPMENT_IND,
          OIS.SALES_OFFICE_CDE,
          OIS.SALES_GROUP_CDE,
          OIS.PART_KEY_ID,
          ODIM.ORGANIZATION_ID,
          DECODE (ODIM.PARENT_ORGANIZATION_ID,
                  ODIM.COMPANY_ORGANIZATION_ID, ODIM.ORGANIZATION_ID,
                  ODIM.PARENT_ORGANIZATION_ID),
          ODIM.COMPANY_ORGANIZATION_ID,
          ACCODIM.ORGANIZATION_ID,
          PPSODIM.ORGANIZATION_ID,
          MFRODIM.ORGANIZATION_ID
          -- Deleted on 05/10/2012
	  -- , OIS.ACTUAL_ON_CUSTOMER_DOCK_DATE
	  -- , OIS.CUSTOMER_REVISED_SCHEDULE_DATE
	  -- , OIS.END_CUST_ACCOUNT_ID
	  -- , OIS.END_CUST_PURCHASE_ORDER_ID
	  -- , OIS.END_CUST_WW_ACCOUNT_ID
	  -- , OIS.INCO_PURCHASE_ORDER_ID
	  -- , OIS.INCO_PURCHASE_ORDER_ITEM_ID
	  -- , OIS.PB_ACCT_ORG_ID
	  -- , OIS.PURCHASED_FROM_ORG_ID
	  -- , OIS.PURCHASING_ORG_CDE
	  -- , OIS.SCHEDULE_ON_CUSTOMER_DOCK_DATE
	  -- , OIS.SPECIAL_PACKAGING_CODE
     FROM ORDER_ITEM_SHIPMENT OIS,
          ORGANIZATIONS_DMN ODIM,
          ORGANIZATIONS_DMN ACCODIM,
          ORGANIZATIONS_DMN PPSODIM,
          ORGANIZATIONS_DMN MFRODIM
    WHERE OIS.ORGANIZATION_KEY_ID = ODIM.ORGANIZATION_KEY_ID
          AND OIS.AMP_SHIPPED_DATE BETWEEN ODIM.EFFECTIVE_FROM_DT
                                       AND ODIM.EFFECTIVE_TO_DT
          AND ODIM.COMPANY_ORGANIZATION_ID = '0048'
          AND OIS.ACCOUNTING_ORG_KEY_ID = ACCODIM.ORGANIZATION_KEY_ID
          AND OIS.AMP_SCHEDULE_DATE BETWEEN ACCODIM.EFFECTIVE_FROM_DT
                                        AND ACCODIM.EFFECTIVE_TO_DT
          AND OIS.PART_PRCR_SRC_ORG_KEY_ID = PPSODIM.ORGANIZATION_KEY_ID(+)
          AND OIS.AMP_SCHEDULE_DATE BETWEEN PPSODIM.EFFECTIVE_FROM_DT(+)
                                        AND PPSODIM.EFFECTIVE_TO_DT(+)
          AND OIS.MFR_ORG_KEY_ID = MFRODIM.ORGANIZATION_KEY_ID
          AND MFRODIM.EFFECTIVE_TO_DT =
                 (SELECT MAX (ORGDIM.EFFECTIVE_TO_DT)
                    FROM ORGANIZATIONS_DMN ORGDIM
                   WHERE MFRODIM.ORGANIZATION_KEY_ID =
                            ORGDIM.ORGANIZATION_KEY_ID);
