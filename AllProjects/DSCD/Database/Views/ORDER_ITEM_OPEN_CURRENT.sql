CREATE OR REPLACE FORCE VIEW scd.order_item_open_current (amp_order_nbr,
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
                                                          product_busns_line_id,
                                                          product_busns_line_fnctn_id,
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
                                                          mfr_org_key_id,
                                                          accounting_org_key_id,
                                                          product_line_code,
                                                          customer_acct_type_cde,
                                                          part_prcr_src_org_key_id,
                                                          controller_uniqueness_id,
                                                          prime_worldwide_customer_id,
                                                          sales_document_type_cde,
                                                          material_type_cde,
                                                          drop_shipment_ind,
                                                          sales_office_cde,
                                                          sales_group_cde,
                                                          sbmt_part_prcr_src_org_id,
                                                          scorecard_organization_id,
                                                          group_organization_id,
                                                          company_organization_id,
                                                          accounting_organization_id,
                                                          part_prcr_source_org_id,
                                                          manufacturing_org_id,
                                                          budget_rate_book_bill_amt,
                                                          part_key_id,
                                                          storage_location_id,
                                                          requested_on_dock_dt,
                                                          scheduled_on_dock_dt,
                                                          customer_requested_expedite_dt
                                                         )
AS
   SELECT oio.amp_order_nbr, oio.order_item_nbr, oio.shipment_id,
          oio.dml_oracle_id, oio.dml_tmstmp, oio.purchase_by_account_base,
          oio.ship_to_account_suffix, oio.prodcn_cntrlr_code,
          oio.item_quantity, oio.resrvn_level_1, oio.resrvn_level_5,
          oio.resrvn_level_9, oio.quantity_released, oio.quantity_shipped,
          oio.iso_currency_code_1, oio.local_currency_billed_amount,
          oio.extended_book_bill_amount, oio.unit_price,
          oio.customer_request_date, oio.amp_schedule_date, oio.release_date,
          oio.inventory_location_code, oio.inventory_building_nbr,
          oio.actual_ship_location, oio.actual_ship_building_nbr,
          oio.request_schedule_cmprsn_code, oio.request_to_schedule_variance,
          oio.current_to_request_variance, oio.current_to_schedule_variance,
          oio.received_to_request_variance, oio.received_to_schedule_variance,
          oio.release_to_schedule_variance, oio.release_schedule_cmprsn_code,
          oio.order_booking_date, oio.order_received_date, oio.order_type_id,
          oio.regtrd_date, oio.reported_as_of_date, oio.database_load_date,
          oio.purchase_order_date, oio.purchase_order_nbr,
          oio.prodcn_cntlr_employee_nbr, oio.team_code, oio.stock_make_code,
          oio.product_code, oio.ww_account_nbr_base,
          oio.ww_account_nbr_suffix, oio.a_territory_nbr,
          oio.customer_reference_part_nbr, oio.schedule_on_credit_hold_date,
          oio.schedule_off_credit_hold_date, oio.customer_credit_hold_ind,
          oio.customer_on_credit_hold_date, oio.temp_hold_on_date,
          oio.temp_hold_off_date, oio.customer_type_code, oio.industry_code,
          oio.product_busns_line_id, oio.product_busns_line_fnctn_id,
          oio.mfg_campus_id, oio.mfg_building_nbr, oio.remaining_qty_to_ship,
          oio.industry_business_code, oio.fiscal_month, oio.fiscal_quarter,
          oio.fiscal_year, oio.sbmt_part_nbr, oio.sbmt_customer_acct_nbr,
          oio.brand_id, oio.profit_center_abbr_nm,
          oio.schd_tyco_month_of_year_id, oio.schd_tyco_quarter_id,
          oio.schd_tyco_year_id, oio.sold_to_customer_id, oio.invoice_nbr,
          oio.delivery_block_cde, oio.credit_check_status_cde,
          oio.sales_organization_id, oio.distribution_channel_cde,
          oio.order_division_cde, oio.item_division_cde,
          oio.matl_account_asgn_grp_cde, oio.data_source_desc, oio.batch_id,
          oio.organization_key_id, oio.mfr_org_key_id,
          oio.accounting_org_key_id, oio.product_line_code,
          oio.customer_acct_type_cde, oio.part_prcr_src_org_key_id,
          oio.controller_uniqueness_id, oio.prime_worldwide_customer_id,
          oio.sales_document_type_cde, oio.material_type_cde,
          oio.drop_shipment_ind, oio.sales_office_cde, oio.sales_group_cde,
          oio.sbmt_part_prcr_src_org_id, odim.organization_id,
          
          -- scorecard org
          DECODE (odim.parent_organization_id,
                  odim.company_organization_id, odim.organization_id,
                  odim.parent_organization_id
                 ),                                               -- group org
          odim.company_organization_id,                         -- company org
                                       accodim.organization_id,
          
          -- accounting org
          ppsodim.organization_id,                        -- part prcr src org
                                  mfrodim.organization_id,          -- mfr org
          oio.budget_rate_book_bill_amt, oio.part_key_id,
          oio.storage_location_id, oio.requested_on_dock_dt,
          oio.scheduled_on_dock_dt, customer_requested_expedite_dt
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
   FROM   order_item_open oio,
          organizations_dmn odim,
          organizations_dmn accodim,
          organizations_dmn ppsodim,
          organizations_dmn mfrodim
    WHERE oio.organization_key_id = odim.organization_key_id
      AND odim.record_status_cde = 'C'
      AND odim.company_organization_id = '0048'
      AND oio.accounting_org_key_id = accodim.organization_key_id
      AND accodim.record_status_cde = 'C'
      AND oio.part_prcr_src_org_key_id = ppsodim.organization_key_id(+)
      AND ppsodim.record_status_cde(+) = 'C'
      AND oio.mfr_org_key_id = mfrodim.organization_key_id
      AND mfrodim.effective_to_dt =
             (SELECT MAX (orgdim.effective_to_dt)
                FROM organizations_dmn orgdim
               WHERE mfrodim.organization_key_id = orgdim.organization_key_id);


DROP PUBLIC SYNONYM ORDER_ITEM_OPEN_CURRENT;

CREATE PUBLIC SYNONYM ORDER_ITEM_OPEN_CURRENT FOR SCD.ORDER_ITEM_OPEN_CURRENT;


GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO GATD;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO GBIS_DECISION_SUPPORT_ROLE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO SCD_ADMIN WITH GRANT OPTION;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO SCD_PRODUCTION_ROLE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO SCD_SOURCE;

GRANT SELECT ON SCD.ORDER_ITEM_OPEN_CURRENT TO TE_DATAMARTS_WITH_COST;