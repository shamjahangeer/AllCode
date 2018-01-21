CREATE OR REPLACE VIEW SCD.GBL_BUSLN_FNCTN_SCD_DIM_V AS
SELECT
       gblddl_bsns_ln_func_id busln_fnctn_id,
       b.busln_fnctn_short_name busln_fnctn_short_name,
       gblddl_dd1_bsns_ln_func_id dd1_busln_fnctn_id,
       b1.busln_fnctn_short_name dd1_busln_fnctn_short_name,
       gblddl_dd2_bsns_ln_func_id dd2_busln_fnctn_id,
       b2.busln_fnctn_short_name dd2_busln_fnctn_short_name,
       gblddl_dd3_bsns_ln_func_id dd3_busln_fnctn_id,
       b3.busln_fnctn_short_name dd3_busln_fnctn_short_name,
       gblddl_dd4_bsns_ln_func_id dd4_busln_fnctn_id,
       b4.busln_fnctn_short_name dd4_busln_fnctn_short_name,
       gblddl_dd5_bsns_ln_func_id dd5_busln_fnctn_id,
       b5.busln_fnctn_short_name dd5_busln_fnctn_short_name
FROM gbl_current.gbl_bsns_ln_drill_down_layers a,
     gbl_current.gbl_business_line_function b,
     gbl_current.gbl_business_line_function b1,
     gbl_current.gbl_business_line_function b2,
     gbl_current.gbl_business_line_function b3,
     gbl_current.gbl_business_line_function b4,
     gbl_current.gbl_business_line_function b5
WHERE a.gblddl_bsns_ln_func_id=b.busln_fnctn_id
AND a.gblddl_dd1_bsns_ln_func_id=b1.busln_fnctn_id
AND a.gblddl_dd2_bsns_ln_func_id=b2.busln_fnctn_id
AND a.gblddl_dd3_bsns_ln_func_id=b3.busln_fnctn_id
AND a.gblddl_dd4_bsns_ln_func_id=b4.busln_fnctn_id
AND a.gblddl_dd5_bsns_ln_func_id=b5.busln_fnctn_id
;
