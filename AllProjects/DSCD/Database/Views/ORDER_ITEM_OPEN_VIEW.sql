CREATE OR REPLACE FORCE VIEW scd.order_item_open_view (month_id,
                                                       manufacturing_org_code,
                                                       amp_order_nbr,
                                                       order_item_nbr,
                                                       shipment_id,
                                                       dml_oracle_id,
                                                       dml_tmstmp,
                                                       purchase_by_account_base,
                                                       ship_to_account_suffix,
                                                       prodcn_cntrlr_code,
                                                       item_quantity,
                                                       resrvn_level_1,
                                                       resrvn_level_5,
                                                       resrvn_level_9,
                                                       quantity_released,
                                                       quantity_shipped,
                                                       iso_currency_code_1,
                                                       local_currency_billed_amount,
                                                       extended_book_bill_amount,
                                                       unit_price,
                                                       customer_request_date,
                                                       amp_schedule_date,
                                                       release_date,
                                                       inventory_location_code,
                                                       inventory_building_nbr,
                                                       actual_ship_location,
                                                       actual_ship_building_nbr,
                                                       request_schedule_cmprsn_code,
                                                       request_to_schedule_variance,
                                                       current_to_request_variance,
                                                       current_to_schedule_variance,
                                                       received_to_request_variance,
                                                       received_to_schedule_variance,
                                                       release_to_schedule_variance,
                                                       release_schedule_cmprsn_code,
                                                       order_booking_date,
                                                       order_received_date,
                                                       order_type_id,
                                                       regtrd_date,
                                                       reported_as_of_date,
                                                       database_load_date,
                                                       purchase_order_date,
                                                       purchase_order_nbr,
                                                       prodcn_cntlr_employee_nbr,
                                                       team_code,
                                                       stock_make_code,
                                                       product_code,
                                                       ww_account_nbr_base,
                                                       ww_account_nbr_suffix,
                                                       a_territory_nbr,
                                                       customer_reference_part_nbr,
                                                       schedule_on_credit_hold_date,
                                                       schedule_off_credit_hold_date,
                                                       customer_credit_hold_ind,
                                                       customer_on_credit_hold_date,
                                                       temp_hold_on_date,
                                                       temp_hold_off_date,
                                                       customer_type_code,
                                                       industry_code,
                                                       mfg_campus_id,
                                                       mfg_building_nbr,
                                                       remaining_qty_to_ship,
                                                       industry_business_code,
                                                       fiscal_month,
                                                       fiscal_quarter,
                                                       fiscal_year,
                                                       sbmt_part_nbr,
                                                       sbmt_customer_acct_nbr,
                                                       brand_id,
                                                       product_busns_line_id,
                                                       product_busns_line_fnctn_id,
                                                       profit_center_abbr_nm,
                                                       schd_tyco_month_of_year_id,
                                                       schd_tyco_quarter_id,
                                                       schd_tyco_year_id,
                                                       sold_to_customer_id,
                                                       invoice_nbr,
                                                       delivery_block_cde,
                                                       credit_check_status_cde,
                                                       sales_organization_id,
                                                       distribution_channel_cde,
                                                       order_division_cde,
                                                       item_division_cde,
                                                       matl_account_asgn_grp_cde,
                                                       data_source_desc,
                                                       batch_id,
                                                       organization_key_id,
                                                       controller_uniqueness_id,
                                                       mfr_org_key_id,
                                                       accounting_org_key_id,
                                                       product_line_code,
                                                       customer_acct_type_cde,
                                                       part_prcr_src_org_key_id,
                                                       prime_worldwide_customer_id,
                                                       sales_document_type_cde,
                                                       material_type_cde,
                                                       drop_shipment_ind,
                                                       sales_office_cde,
                                                       sales_group_cde,
                                                       sbmt_part_prcr_src_org_id,
                                                       budget_rate_book_bill_amt,
                                                       part_key_id,
                                                       customer_requested_expedite_dt
                                                      )
AS
   SELECT /*+ first_rows index(oio oiop_pf9) use_nl(mox org oio) no_merge(org) */
          'CURRENT' month_id,
          mox.manufacturing_org_code manufacturing_org_code, amp_order_nbr,
          order_item_nbr, shipment_id, oio.dml_oracle_id, oio.dml_tmstmp,
          purchase_by_account_base, ship_to_account_suffix,
          prodcn_cntrlr_code, item_quantity, resrvn_level_1, resrvn_level_5,
          resrvn_level_9, quantity_released, quantity_shipped,
          iso_currency_code_1, local_currency_billed_amount,
          extended_book_bill_amount, unit_price, customer_request_date,
          amp_schedule_date, release_date, inventory_location_code,
          inventory_building_nbr, actual_ship_location,
          actual_ship_building_nbr, request_schedule_cmprsn_code,
          request_to_schedule_variance, current_to_request_variance,
          current_to_schedule_variance, received_to_request_variance,
          received_to_schedule_variance, release_to_schedule_variance,
          release_schedule_cmprsn_code, order_booking_date,
          order_received_date, order_type_id, regtrd_date,
          reported_as_of_date, database_load_date, purchase_order_date,
          purchase_order_nbr, prodcn_cntlr_employee_nbr, team_code,
          stock_make_code, oio.product_code, ww_account_nbr_base,
          ww_account_nbr_suffix, a_territory_nbr, customer_reference_part_nbr,
          schedule_on_credit_hold_date, schedule_off_credit_hold_date,
          customer_credit_hold_ind, customer_on_credit_hold_date,
          temp_hold_on_date, temp_hold_off_date, customer_type_code,
          industry_code, mfg_campus_id, mfg_building_nbr,
          remaining_qty_to_ship, industry_business_code, fiscal_month,
          fiscal_quarter, fiscal_year, sbmt_part_nbr, sbmt_customer_acct_nbr,
          brand_id, product_busns_line_id, product_busns_line_fnctn_id,
          profit_center_abbr_nm, schd_tyco_month_of_year_id,
          schd_tyco_quarter_id, schd_tyco_year_id, sold_to_customer_id,
          invoice_nbr, delivery_block_cde, credit_check_status_cde,
          sales_organization_id, distribution_channel_cde, order_division_cde,
          item_division_cde, matl_account_asgn_grp_cde, data_source_desc,
          batch_id, oio.organization_key_id, controller_uniqueness_id,
          mfr_org_key_id, accounting_org_key_id, product_line_code,
          customer_acct_type_cde, part_prcr_src_org_key_id,
          prime_worldwide_customer_id, sales_document_type_cde,
          material_type_cde, drop_shipment_ind, sales_office_cde,
          sales_group_cde, sbmt_part_prcr_src_org_id,
          budget_rate_book_bill_amt, oio.part_key_id,
          customer_requested_expedite_dt
     -- Deleted on 05/10/2012
     -- , range_code
     -- , actual_on_dock_date
     -- , schedule_on_customer_dock_date
     -- , actual_on_customer_dock_date
     -- , amp_shipped_date
     -- , nbr_window_days_early
     -- , nbr_window_days_late
     -- , schedule_ship_cmprsn_code
     -- , schedule_to_ship_variance
     -- , varbl_schedule_ship_variance
     -- , request_ship_cmprsn_code
     -- , request_to_ship_variance
     -- , varbl_request_ship_variance
     -- , received_to_ship_variance
     -- , varbl_received_ship_variance
     -- , ship_facility_cmprsn_code
     -- , release_to_ship_variance
     -- , inventory_classfcn_code
     -- , schlg_method_code
     -- , customer_forecast_code
     -- , customer_revised_schedule_date
     -- , customer_expedite_date
     -- , nbr_of_expedites
     -- , original_expedite_date
     -- , current_expedite_date
     -- , earliest_expedite_date
     -- , temp_hold_ind
     -- , special_packaging_code
     -- , forced_bill_ind
     -- , rush_ind
     -- , purchased_from_org_id
     -- , inco_purchase_order_id
     -- , inco_purchase_order_item_id
     -- , purchasing_org_cde
     -- , pb_acct_org_id
     -- , end_cust_account_id
     -- , end_cust_purchase_order_id
     -- , end_cust_ww_account_id
   FROM   scd.order_item_open oio,
          manufacturing_orgs_xref mox,
          (SELECT organization_key_id
             FROM scd.scddm_mfr_organization_dmn
            WHERE layer5_organization_id = '0048') org
    WHERE mox.product_code = oio.product_code
      AND org.organization_key_id = oio.organization_key_id;


GRANT SELECT ON SCD.ORDER_ITEM_OPEN_VIEW TO GBIS_DECISION_SUPPORT_ROLE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_VIEW TO IC_AMS_USER_ROLE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_VIEW TO SCD_ADMIN WITH GRANT OPTION;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_VIEW TO SCD_PRODUCTION_ROLE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_VIEW TO SCD_SOURCE;