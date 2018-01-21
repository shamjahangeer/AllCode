CREATE OR REPLACE FORCE VIEW scd.order_item_shipment_v 
(amp_order_nbr,
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
 range_code,
 unit_price,
 customer_request_date,
 amp_schedule_date,
 release_date,
 actual_on_dock_date,
 amp_shipped_date,
 nbr_window_days_early,
 nbr_window_days_late,
 inventory_location_code,
 inventory_building_nbr,
 actual_ship_location,
 actual_ship_building_nbr,
 schedule_ship_cmprsn_code,
 schedule_to_ship_variance,
 varbl_schedule_ship_variance,
 request_ship_cmprsn_code,
 request_to_ship_variance,
 varbl_request_ship_variance,
 request_schedule_cmprsn_code,
 request_to_schedule_variance,
 current_to_request_variance,
 current_to_schedule_variance,
 received_to_request_variance,
 received_to_schedule_variance,
 received_to_ship_variance,
 varbl_received_ship_variance,
 release_to_schedule_variance,
 release_schedule_cmprsn_code,
 ship_facility_cmprsn_code,
 release_to_ship_variance,
 order_booking_date,
 order_received_date,
 order_type_id,
 regtrd_date,
 reported_as_of_date,
 database_load_date,
 inventory_classfcn_code,
 purchase_order_date,
 purchase_order_nbr,
 prodcn_cntlr_employee_nbr,
 schlg_method_code,
 team_code,
 stock_make_code,
 product_code,
 ww_account_nbr_base,
 ww_account_nbr_suffix,
 customer_forecast_code,
 a_territory_nbr,
 customer_reference_part_nbr,
 customer_expedite_date,
 nbr_of_expedites,
 original_expedite_date,
 current_expedite_date,
 earliest_expedite_date,
 schedule_on_credit_hold_date,
 schedule_off_credit_hold_date,
 customer_credit_hold_ind,
 customer_on_credit_hold_date,
 temp_hold_ind,
 temp_hold_on_date,
 temp_hold_off_date,
 forced_bill_ind,
 customer_type_code,
 rush_ind,
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
 hierarchy_customer_ind,
 hierarchy_customer_org_id,
 hierarchy_customer_base_id,
 hierarchy_customer_sufx_id,
 gfc_extended_true_amp_cost,
 true_cost,
 part_key_id,
 trsp_mge_transit_time_days_qty,
 default_manufacturing_plant_id,
 vendor_key_id,
 vendor_id,
 order_received_dt,
 order_created_by_ntwk_user_id,
 delivery_doc_creation_dt,
 delivery_doc_creation_tm,
 dlvr_doc_cret_by_ntwk_user_id,
 pricing_condition_type_cde,
 planned_goods_issue_dt,
 distr_ship_when_avail_ind,
 ship_to_customer_key_id,
 sold_to_customer_key_id,
 header_cust_order_received_dt,
 customer_off_credit_hold_date,
 initial_request_dt,
 schedule_line_category_cde,
 initial_request_qty,
 material_availability_dt,
 cust_pur_ord_line_item_nbr_id,
 billing_type_cde,
 sap_delivery_type_cde,
 shipment_number_id
,product_manager_global_id
,sbmt_original_schedule_dt
,sbmt_current_schedule_dt
,part_um
,sbmt_sold_to_customer_id
,tyco_ctrl_delivery_hold_on_dt
,tyco_ctrl_delivery_hold_off_dt
,tyco_ctrl_delivery_block_cde
,pick_pack_work_days_qty
,loading_nbr_of_work_days_qty
,trsp_lead_time_days_qty
,transit_time_days_qty
,delivery_item_category_cde
,fixed_date_quantity_ind
,order_header_billing_block_cde
,item_billing_block_cde
,sap_bill_to_customer_id
,delivery_document_nbr_id
,delivery_document_item_nbr_id
,misc_local_flag_cde_1
,misc_local_cde_1
,misc_local_cde_2
,misc_local_cde_3
,customer_date_basis_cde
,actual_date_basis_cde
,ship_date_determination_cde
,cust_ord_req_reset_reason_cde
,cust_ord_req_reset_reason_dt
,customer_order_edi_type_cde
,item_booked_dt
,ultimate_end_customer_id
,ultimate_end_cust_acct_grp_cde
,mrp_group_cde
,complete_delivery_ind
,source_id
,data_src_id
,super_data_security_tag_id
,consolidation_indicator_cde
,consolidation_dt
,sap_profit_center_cde
,storage_location_id
,sales_territory_cde
,requested_on_dock_dt
,scheduled_on_dock_dt
,hierarchy_customer_key_id
,ultimate_end_customer_key_id
,bill_of_lading_id
,sbmt_fwd_agent_vendor_id
,fwd_agent_vendor_key_id
,intl_commercial_terms_cde
,intl_cmcl_term_additional_desc
,shipping_trsp_category_cde
,sbmt_schd_agr_cancel_ind_cde
,schd_agr_cancel_indicator_cde
,consumed_sa_order_item_nbr_id
,consumed_sa_order_number_id
,sbmt_sb_cnsn_itrst_prtncust_id
,sb_cnsn_itrst_prtn_cust_key_id
,shipping_conditions_cde
,sbmt_zi_cnsn_stk_prtn_cust_id
,zi_cnsn_stk_prtn_cust_key_id
,actual_ship_from_building_id
,sbmt_fcst_pp_cust_acct_nbr
,fcst_prm_prtn_customer_key_id
,fcst_prm_prtn_cust_acct_nbr
,fcst_prm_prtn_acct_group_cde
)
AS
SELECT amp_order_nbr, order_item_nbr, shipment_id, dml_oracle_id,
       dml_tmstmp, purchase_by_account_base, ship_to_account_suffix,
       prodcn_cntrlr_code, item_quantity, resrvn_level_1, resrvn_level_5,
       resrvn_level_9, quantity_released, quantity_shipped,
       iso_currency_code_1, local_currency_billed_amount,
       extended_book_bill_amount, range_code, unit_price,
       customer_request_date, amp_schedule_date, release_date,
       actual_on_dock_date, amp_shipped_date, nbr_window_days_early,
       nbr_window_days_late, inventory_location_code,
       inventory_building_nbr, actual_ship_location,
       actual_ship_building_nbr, schedule_ship_cmprsn_code,
       schedule_to_ship_variance, varbl_schedule_ship_variance,
       request_ship_cmprsn_code, request_to_ship_variance,
       varbl_request_ship_variance, request_schedule_cmprsn_code,
       request_to_schedule_variance, current_to_request_variance,
       current_to_schedule_variance, received_to_request_variance,
       received_to_schedule_variance, received_to_ship_variance,
       varbl_received_ship_variance, release_to_schedule_variance,
       release_schedule_cmprsn_code, ship_facility_cmprsn_code,
       release_to_ship_variance, order_booking_date, order_received_date,
       order_type_id, regtrd_date, reported_as_of_date, database_load_date,
       inventory_classfcn_code, purchase_order_date, purchase_order_nbr,
       prodcn_cntlr_employee_nbr, schlg_method_code, team_code,
       stock_make_code, product_code, ww_account_nbr_base,
       ww_account_nbr_suffix, customer_forecast_code, a_territory_nbr,
       customer_reference_part_nbr, customer_expedite_date,
       nbr_of_expedites, original_expedite_date, current_expedite_date,
       earliest_expedite_date, schedule_on_credit_hold_date,
       schedule_off_credit_hold_date, customer_credit_hold_ind,
       customer_on_credit_hold_date, temp_hold_ind, temp_hold_on_date,
       temp_hold_off_date, forced_bill_ind, customer_type_code, rush_ind,
       industry_code, mfg_campus_id, mfg_building_nbr,
       remaining_qty_to_ship, industry_business_code, fiscal_month,
       fiscal_quarter, fiscal_year, sbmt_part_nbr, sbmt_customer_acct_nbr,
       brand_id, product_busns_line_id, product_busns_line_fnctn_id,
       profit_center_abbr_nm, schd_tyco_month_of_year_id,
       schd_tyco_quarter_id, schd_tyco_year_id, sold_to_customer_id,
       invoice_nbr, delivery_block_cde, credit_check_status_cde,
       sales_organization_id, distribution_channel_cde, order_division_cde,
       item_division_cde, matl_account_asgn_grp_cde, data_source_desc,
       batch_id, organization_key_id, controller_uniqueness_id,
       mfr_org_key_id, accounting_org_key_id, product_line_code,
       customer_acct_type_cde, part_prcr_src_org_key_id,
       prime_worldwide_customer_id, sales_document_type_cde,
       material_type_cde, drop_shipment_ind, sales_office_cde,
       sales_group_cde, sbmt_part_prcr_src_org_id,
       budget_rate_book_bill_amt, hierarchy_customer_ind,
       hierarchy_customer_org_id, hierarchy_customer_base_id,
       hierarchy_customer_sufx_id, gfc_extended_true_amp_cost,
       ROUND (  gfc_extended_true_amp_cost
              / DECODE (quantity_shipped, 0, NULL, quantity_shipped),
              5
             ),
       part_key_id, trsp_mge_transit_time_days_qty,
       default_manufacturing_plant_id, vendor_key_id, vendor_id,
       order_received_dt, order_created_by_ntwk_user_id,
       delivery_doc_creation_dt, delivery_doc_creation_tm,
       dlvr_doc_cret_by_ntwk_user_id, pricing_condition_type_cde,
       planned_goods_issue_dt, distr_ship_when_avail_ind,
       ship_to_customer_key_id, sold_to_customer_key_id,
       header_cust_order_received_dt, customer_off_credit_hold_date,
       initial_request_dt, schedule_line_category_cde, initial_request_qty,
       material_availability_dt,
       cust_pur_ord_line_item_nbr_id, billing_type_cde,
       sap_delivery_type_cde, shipment_number_id
      ,product_manager_global_id
      ,sbmt_original_schedule_dt
      ,sbmt_current_schedule_dt
      ,part_um
      ,sbmt_sold_to_customer_id
      ,tyco_ctrl_delivery_hold_on_dt
      ,tyco_ctrl_delivery_hold_off_dt
      ,tyco_ctrl_delivery_block_cde
      ,pick_pack_work_days_qty
      ,loading_nbr_of_work_days_qty
      ,trsp_lead_time_days_qty
      ,transit_time_days_qty
      ,delivery_item_category_cde
      ,fixed_date_quantity_ind
      ,order_header_billing_block_cde
      ,item_billing_block_cde
      ,sap_bill_to_customer_id
      ,delivery_document_nbr_id
      ,delivery_document_item_nbr_id
      ,misc_local_flag_cde_1
      ,misc_local_cde_1
      ,misc_local_cde_2
      ,misc_local_cde_3
      ,customer_date_basis_cde
      ,actual_date_basis_cde
      ,ship_date_determination_cde
      ,cust_ord_req_reset_reason_cde
      ,cust_ord_req_reset_reason_dt
      ,customer_order_edi_type_cde
      ,item_booked_dt
      ,ultimate_end_customer_id
      ,ultimate_end_cust_acct_grp_cde
      ,mrp_group_cde
      ,complete_delivery_ind
      ,source_id
      ,data_src_id
      ,super_data_security_tag_id
      ,consolidation_indicator_cde
      ,consolidation_dt
      ,sap_profit_center_cde
      ,storage_location_id
      ,sales_territory_cde
      ,requested_on_dock_dt
      ,scheduled_on_dock_dt
      ,hierarchy_customer_key_id
      ,ultimate_end_customer_key_id
      ,bill_of_lading_id
      ,sbmt_fwd_agent_vendor_id
      ,fwd_agent_vendor_key_id
      ,intl_commercial_terms_cde
      ,intl_cmcl_term_additional_desc
      ,shipping_trsp_category_cde
      ,sbmt_schd_agr_cancel_ind_cde
      ,schd_agr_cancel_indicator_cde
      ,consumed_sa_order_item_nbr_id
      ,consumed_sa_order_number_id
      ,sbmt_sb_cnsn_itrst_prtncust_id
      ,sb_cnsn_itrst_prtn_cust_key_id
      ,shipping_conditions_cde
      ,sbmt_zi_cnsn_stk_prtn_cust_id
      ,zi_cnsn_stk_prtn_cust_key_id
      ,actual_ship_from_building_id
      ,sbmt_fcst_pp_cust_acct_nbr
      ,fcst_prm_prtn_customer_key_id
      ,fcst_prm_prtn_cust_acct_nbr
      ,fcst_prm_prtn_acct_group_cde
FROM   order_item_shipment
WHERE  super_data_security_tag_id NOT LIKE cor_user_security.get_user_security_encoded_str;

GRANT SELECT ON SCD.ORDER_ITEM_SHIPMENT_V TO SAO_READ, SUP_USER;