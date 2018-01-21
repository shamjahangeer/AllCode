CREATE OR REPLACE PROCEDURE P_DSCD_FIX_BAKOUT_REC
( vic_recalculate IN CHAR
, vic_update      IN CHAR
, vic_backout     IN CHAR
, vic_adjust      IN CHAR
, vid_after_date  IN DATE
, vid_before_date IN DATE
, vin_com_cnt     IN NUMBER
, von_sql_rc     OUT NUMBER)
IS

 ue_fatal_db_err  EXCEPTION;

 vgc_proc_name             CHAR(40);
 vgc_job_id                CHAR(8) := 'DSCDFIX ';
 vgc_ois_rec               TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
 vgn_adj_amt               NUMBER;
 vgn_nbr_smrys_ins         NUMBER;
 vgn_nbr_smrys_upd         NUMBER;
 vgn_nbr_smrys_del         NUMBER;
 vgn_sql_rc                NUMBER := 0;
 vgn_row_read_cnt          NUMBER := 0;
 vgn_row_proc_backout_cnt  NUMBER := 0;
 vgn_row_proc_variance_cnt NUMBER := 0;
 vgn_row_proc_update_cnt   NUMBER := 0;
 vgn_row_proc_adjust_cnt   NUMBER := 0;

  CURSOR ois_cur IS
   SELECT * FROM order_item_shipment
   WHERE  order_type_id = 'ZVEN';

   /*
   -- 03/21/2012 and Before

   WHERE  amp_order_nbr='523755'
   AND    purchase_by_account_base='00043047'

   WHERE (((ORDER_ITEM_SHIPMENT.DML_TMSTMP)>='09-dec-2004') AND ((ORDER_ITEM_SHIPMENT.AMP_SHIPPED_DATE)='07-dec-2004')
   AND ((ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_BUILDING_NBR)='453') AND ((ORDER_ITEM_SHIPMENT.RELEASE_TO_SHIP_VARIANCE)>0))
   and order_item_nbr='001'

   where purchase_by_account_base = '71707101'
   and ship_to_account_suffix = '01'
   and amp_shipped_date > '28-FEB-2002'
   and customer_request_date between '01-MAR-2002'and '06-MAR-2002'
   and (purchase_order_nbr like '5665PC205%' or purchase_order_nbr like '5665PC206%')
   and organization_key_id = 536
   and (release_to_ship_variance <> 0 or request_to_ship_variance <> 0);

   where organization_key_id=731
   and amp_shipped_date between '26-sep-2001' and '10-oct-2001'
   and NBR_WINDOW_DAYS_EARLY = 0;

   where Amp_order_nbr = '112401275'
   and order_item_nbr = '001'
   and shipment_id = '200112801';

   where div_org_code = '0K5'
   and ww_account_nbr_base = '00000258'
   and ww_account_nbr_suffix = '06'
   and amp_shipped_date = '03-SEP-99'
   and request_to_ship_variance = 1;

   where co_org_code = '0'
   and amp_shipped_date = '24-MAY-99'
   and release_date = '23-MAR-99'
   and (schedule_to_ship_variance = 1 or request_to_ship_variance = 1)
   and actual_ship_location = 'RG'
   and actual_ship_building_nbr = '271';

   where co_org_code = 'EB'
   and amp_shipped_date = '12-MAR-99'
   and schedule_to_ship_variance = 1
   and (amp_order_nbr <> '000019846' and
        amp_order_nbr <> '000021643' and
        amp_order_nbr <> '000026487' and
        amp_order_nbr <> '000026821' and
        amp_order_nbr <> '000027358' and
        amp_order_nbr <> '000028825' and
        amp_order_nbr <> '000028937' and
        amp_order_nbr <> '000029492' and
        amp_order_nbr <> '000030604' and
        amp_order_nbr <> '000031127' and
        amp_order_nbr <> '000031852' and
        amp_order_nbr <> '000032819' and
        amp_order_nbr <> '000032977' and
        amp_order_nbr <> '000033198' and
        amp_order_nbr <> '000033780' and
        amp_order_nbr <> '000034480' and
        amp_order_nbr <> '000034752' and
        amp_order_nbr <> '000035003' and
        amp_order_nbr <> '000035585' and
        amp_order_nbr <> '000035587' and
        amp_order_nbr <> '000035813' and
        amp_order_nbr <> '000035825' and
        amp_order_nbr <> '000036617' and
        amp_order_nbr <> '000037211' and
        amp_order_nbr <> '000037359' and
        amp_order_nbr <> '000037702' and
        amp_order_nbr <> '000037882' and
        amp_order_nbr <> '000038996' and
        amp_order_nbr <> '000039058' and
        amp_order_nbr <> '000039178' and
        amp_order_nbr <> '000039270' and
        amp_order_nbr <> '000091464' and
        amp_order_nbr <> '000094900' and
        amp_order_nbr <> '000097706' and
        amp_order_nbr <> '000097712' and
        amp_order_nbr <> '000098134' and
        amp_order_nbr <> '000098671' and
        amp_order_nbr <> '000099025');

   where CO_ORG_CODE = 'EB'
   AND schedule_to_ship_variance = 1
   and amp_shipped_date = '22-DEC-98';

   */

/* *************************************************************** */
/* SUB PROCEDURE:  p_1000_recalculate_variances                    */
/*                                                                 */
/* Author:  Jordan G. Karr (CAI)                                   */
/*   Date:  January, 1998                                          */
/*                                                                 */
/* Purpose:  Recalculates variances for retrieved OIS record       */
/*                                                                 */
/* *************************************************************** */

PROCEDURE P_1000_RECALCULATE_VARIANCES
IS

BEGIN

   vgc_proc_name := 'p_1000_recalculate_variances';
   vgn_sql_rc    := 0;

   -- Particular input Variance Calculation field changes

   -- VGC_OIS_REC.release_date           := '22-SEP-2003';
   -- VGC_OIS_REC.amp_shipped_date       := '21-APR-2010';
   -- VGC_OIS_REC.actual_on_dock_date    := VGC_OIS_REC.amp_shipped_date;
   -- VGC_OIS_REC.regtrd_date            := '25-feb-2003';
   -- VGC_OIS_REC.amp_schedule_date      := '24-SEP-2002';
   -- VGC_OIS_REC.CUSTOMER_expedite_DATE := VGC_OIS_REC.amp_shipped_date;
   -- VGC_OIS_REC.customer_request_date  := '24-SEP-2002';
   -- VGC_OIS_REC.customer_expedite_date := '08-MAY-01';
   -- VGC_OIS_REC.nbr_window_days_early  := 3;
   -- VGC_OIS_REC.nbr_window_days_late   := 0;

   PKG_VARIANCE_CALC.p_variance_calc (vgc_ois_rec, vgn_sql_rc);

END P_1000_RECALCULATE_VARIANCES;

/* *************************************************************** */
/* SUB PROCEDURE:  p_2000_update_ois                               */
/*                                                                 */
/* Author:  Jordan G. Karr (CAI)                                   */
/*   Date:  January, 1998                                          */
/*                                                                 */
/* Purpose:  Updates OIS record with recalculated                  */
/*           VARBL_REQUEST_SHIP_VARIANCE bucket                    */
/*                                                                 */
/* *************************************************************** */

PROCEDURE P_2000_UPDATE_OIS
IS

BEGIN

   vgc_proc_name := 'p_2000_update_ois';
   vgn_sql_rc    := 0;

   UPDATE order_item_shipment  -- Particular OIS field updates
   SET    dml_tmstmp                    = SYSDATE
        -- , region_org_code        = 'L'
        -- , amp_shipped_date       = VGC_OIS_REC.amp_shipped_date
        -- , actual_on_dock_date    = VGC_OIS_REC.amp_shipped_date
        -- , regtrd_date            = '25-feb-2003'
        -- , release_date           = '22-SEP-2003'
        -- , amp_schedule_date      = '24-SEP-2002'
        -- , customer_request_date  = '24-SEP-2002'
        -- , release_date           = VGC_OIS_REC.amp_shipped_date
        -- , customer_expedite_date = VGC_OIS_REC.CUSTOMER_expedite_DATE
        -- , current_expedite_date  = VGC_OIS_REC.current_expedite_date
        -- , earliest_expedite_date = VGC_OIS_REC.earliest_expedite_date
        -- , nbr_window_days_early  = 3
        -- , nbr_window_days_late   = 0
        , schedule_ship_cmprsn_code     = VGC_OIS_REC.schedule_ship_cmprsn_code
        , schedule_to_ship_variance     = VGC_OIS_REC.schedule_to_ship_variance
        , varbl_schedule_ship_variance  = VGC_OIS_REC.varbl_schedule_ship_variance
        , request_ship_cmprsn_code      = VGC_OIS_REC.request_ship_cmprsn_code
        , request_to_ship_variance      = VGC_OIS_REC.request_to_ship_variance
        , varbl_request_ship_variance   = VGC_OIS_REC.varbl_request_ship_variance
        , request_schedule_cmprsn_code  = VGC_OIS_REC.request_schedule_cmprsn_code
        , request_to_schedule_variance  = VGC_OIS_REC.request_to_schedule_variance
        , current_to_request_variance   = VGC_OIS_REC.current_to_request_variance
        , current_to_schedule_variance  = VGC_OIS_REC.current_to_schedule_variance
        , received_to_request_variance  = VGC_OIS_REC.received_to_request_variance
        , received_to_schedule_variance = VGC_OIS_REC.received_to_schedule_variance
        , received_to_ship_variance     = VGC_OIS_REC.received_to_ship_variance
        , varbl_received_ship_variance  = VGC_OIS_REC.varbl_received_ship_variance
        , release_schedule_cmprsn_code  = VGC_OIS_REC.release_schedule_cmprsn_code
        , release_to_schedule_variance  = VGC_OIS_REC.release_to_schedule_variance
        , ship_facility_cmprsn_code     = VGC_OIS_REC.ship_facility_cmprsn_code
        , release_to_ship_variance      = VGC_OIS_REC.release_to_ship_variance
   WHERE  amp_order_nbr      = VGC_OIS_REC.amp_order_nbr
   AND   shipment_id         = VGC_OIS_REC.shipment_id
   AND   order_item_nbr      = VGC_OIS_REC.order_item_nbr
   AND   organization_key_id = VGC_OIS_REC.organization_key_id
   -- AND   scorecard_org_code = VGC_OIS_REC.scorecard_org_code
   ;

EXCEPTION
   WHEN OTHERS THEN
      vgn_sql_rc    := SQLCODE;

END P_2000_UPDATE_OIS;

/* ************************************************************** */
/* SUB PROCEDURE:  p_3000_backout_summaries                       */
/*                                                                */
/* Author:  Jordan G. Karr (CAI)                                  */
/*   Date:  January, 1998                                         */
/*                                                                */
/* Purpose:  Backs out summary tables for retrieved OIS record    */
/*           variances                                            */
/*                                                                */
/* ************************************************************** */

PROCEDURE P_3000_BACKOUT_SUMMARIES
IS

BEGIN

   vgc_proc_name     := 'p_3000_backout_summaries';
   vgn_adj_amt       := -1;
   vgn_nbr_smrys_ins :=  0;
   vgn_nbr_smrys_upd :=  0;
   vgn_nbr_smrys_del :=  0;
   vgn_sql_rc        :=  0;

   PKG_ADJUST_SUMMARIES.p_adjust_summaries
   ( vgc_job_id
   , VGC_OIS_REC.amp_shipped_date
   , VGC_OIS_REC.organization_key_id
   -- , VGC_OIS_REC.div_org_code
   -- , VGC_OIS_REC.group_org_code
   -- , VGC_OIS_REC.co_org_code
   -- , VGC_OIS_REC.area_org_code
   -- , VGC_OIS_REC.region_org_code
   -- , VGC_OIS_REC.scorecard_org_code
   -- , VGC_OIS_REC.part_prcmt_source_org_code
   , VGC_OIS_REC.team_code
   , VGC_OIS_REC.prodcn_cntrlr_code
   , VGC_OIS_REC.controller_uniqueness_id
   -- , VGC_OIS_REC.inventory_org_code
   , VGC_OIS_REC.stock_make_code
   , VGC_OIS_REC.product_line_code
   -- , VGC_OIS_REC.intrntnl_product_line_code
   , VGC_OIS_REC.product_code
   , VGC_OIS_REC.prodcn_cntlr_employee_nbr
   , VGC_OIS_REC.a_territory_nbr
   -- , VGC_OIS_REC.marketing_org_code
   -- , VGC_OIS_REC.product_family_code
   , VGC_OIS_REC.actual_ship_building_nbr
   , VGC_OIS_REC.actual_ship_location
   , VGC_OIS_REC.purchase_by_account_base
   , VGC_OIS_REC.ship_to_account_suffix
   , VGC_OIS_REC.ww_account_nbr_base
   , VGC_OIS_REC.ww_account_nbr_suffix
   , VGC_OIS_REC.customer_type_code
   , VGC_OIS_REC.ship_facility_cmprsn_code
   , VGC_OIS_REC.release_to_ship_variance
   , VGC_OIS_REC.schedule_to_ship_variance
   , VGC_OIS_REC.varbl_schedule_ship_variance
   , VGC_OIS_REC.request_to_ship_variance
   , VGC_OIS_REC.varbl_request_ship_variance
   , VGC_OIS_REC.request_to_schedule_variance
   -- , VGC_OIS_REC.trade_or_interco_code
   , VGC_OIS_REC.customer_acct_type_cde
   , VGC_OIS_REC.industry_code
   , VGC_OIS_REC.mfr_org_key_id
   -- , VGC_OIS_REC.mfg_div_org_code
   -- , VGC_OIS_REC.mfg_group_org_code
   , VGC_OIS_REC.mfg_campus_id
   , VGC_OIS_REC.mfg_building_nbr
   -- , VGC_OIS_REC.pri_ww_account_nbr_base
   -- , VGC_OIS_REC.pri_ww_account_nbr_suffix
   , VGC_OIS_REC.industry_business_code
      , VGC_OIS_REC.accounting_org_key_id
   , VGC_OIS_REC.product_busns_line_fnctn_id
   , VGC_OIS_REC.profit_center_abbr_nm
   , VGC_OIS_REC.sold_to_customer_id
   , VGC_OIS_REC.product_busns_line_id
   , VGC_OIS_REC.product_manager_global_id
   , VGC_OIS_REC.sales_office_cde
   , VGC_OIS_REC.sales_group_cde
   , SCDCOMMONBATCH.getsourcesystemid(VGC_OIS_REC.data_source_desc)
   , VGC_OIS_REC.mrp_group_cde
   , vgn_adj_amt
   , vgn_nbr_smrys_ins
   , vgn_nbr_smrys_upd
   , vgn_nbr_smrys_del
   , vgn_sql_rc );

   -- Delete the detail record
  DELETE FROM ORDER_ITEM_SHIPMENT
  WHERE  organization_key_id = VGC_OIS_REC.organization_key_id
  AND    amp_order_nbr       = VGC_OIS_REC.amp_order_nbr
  AND    order_item_nbr      = VGC_OIS_REC.order_item_nbr
  AND    shipment_id         = VGC_OIS_REC.shipment_id;

  -- Delete the corresponding security detail record
  DELETE FROM ORDER_ITEM_SHIP_DATA_SECURITY
  WHERE  organization_key_id = VGC_OIS_REC.organization_key_id
  AND    amp_order_nbr       = VGC_OIS_REC.amp_order_nbr
  AND    order_item_nbr      = VGC_OIS_REC.order_item_nbr
  AND    shipment_id         = VGC_OIS_REC.shipment_id;

EXCEPTION
   WHEN OTHERS THEN
      vgn_sql_rc    := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('   SQL ERROR MSG:  ' || SQLERRM);

END P_3000_BACKOUT_SUMMARIES;

/* ************************************************************** */
/* SUB PROCEDURE:  p_4000_adjust_summaries                        */
/*                                                                */
/* Author:  Jordan G. Karr (CAI)                                  */
/*   Date:  January, 1998                                         */
/*                                                                */
/* Purpose:  Adjusts summary tables with recalculated variances   */
/*           for retrieved OIS record                             */
/*                                                                */
/* ************************************************************** */

PROCEDURE P_4000_ADJUST_SUMMARIES
IS

BEGIN

 vgc_proc_name     := 'p_4000_adjust_summaries';
 vgn_adj_amt       := 1;
 vgn_nbr_smrys_ins := 0;
 vgn_nbr_smrys_upd := 0;
 vgn_nbr_smrys_del := 0;
 vgn_sql_rc        := 0;

      PKG_ADJUST_SUMMARIES.p_adjust_summaries
      ( vgc_job_id
      , VGC_OIS_REC.amp_shipped_date
      , VGC_OIS_REC.ORGANIZATION_KEY_ID
      -- ,VGC_OIS_REC.div_org_code
      -- ,VGC_OIS_REC.group_org_code
      -- ,VGC_OIS_REC.co_org_code
      -- ,VGC_OIS_REC.area_org_code
      -- ,VGC_OIS_REC.region_org_code
      -- ,VGC_OIS_REC.scorecard_org_code
      -- ,VGC_OIS_REC.part_prcmt_source_org_code
      , VGC_OIS_REC.team_code
      , VGC_OIS_REC.prodcn_cntrlr_code
      , VGC_OIS_REC.CONTROLLER_UNIQUENESS_ID
      -- ,VGC_OIS_REC.inventory_org_code
      , VGC_OIS_REC.stock_make_code
      , VGC_OIS_REC.product_line_code
      -- ,VGC_OIS_REC.intrntnl_product_line_code
      , VGC_OIS_REC.product_code
      , VGC_OIS_REC.prodcn_cntlr_employee_nbr
      , VGC_OIS_REC.a_territory_nbr
      -- ,VGC_OIS_REC.marketing_org_code
      -- ,VGC_OIS_REC.product_family_code
      , VGC_OIS_REC.actual_ship_building_nbr
      , VGC_OIS_REC.actual_ship_location
      , VGC_OIS_REC.purchase_by_account_base
      , VGC_OIS_REC.ship_to_account_suffix
      , VGC_OIS_REC.ww_account_nbr_base
      , VGC_OIS_REC.ww_account_nbr_suffix
      , VGC_OIS_REC.customer_type_code
      , VGC_OIS_REC.ship_facility_cmprsn_code
      , VGC_OIS_REC.release_to_ship_variance
      , VGC_OIS_REC.schedule_to_ship_variance
      , VGC_OIS_REC.varbl_schedule_ship_variance
      , VGC_OIS_REC.request_to_ship_variance
      , VGC_OIS_REC.varbl_request_ship_variance
      , VGC_OIS_REC.request_to_schedule_variance
      -- ,VGC_OIS_REC.trade_or_interco_code
      , VGC_OIS_REC.CUSTOMER_ACCT_TYPE_CDE
      , VGC_OIS_REC.industry_code
      , VGC_OIS_REC.MFR_ORG_KEY_ID
      -- ,VGC_OIS_REC.mfg_div_org_code
      -- ,VGC_OIS_REC.mfg_group_org_code
      , VGC_OIS_REC.mfg_campus_id
      , VGC_OIS_REC.mfg_building_nbr
      -- ,VGC_OIS_REC.pri_ww_account_nbr_base
      -- ,VGC_OIS_REC.pri_ww_account_nbr_suffix
      , VGC_OIS_REC.industry_business_code
      , VGC_OIS_REC.ACCOUNTING_ORG_KEY_ID
      , VGC_OIS_REC.PRODUCT_BUSNS_LINE_FNCTN_ID
      , VGC_OIS_REC.PROFIT_CENTER_ABBR_NM
      , VGC_OIS_REC.SOLD_TO_CUSTOMER_ID
      , VGC_OIS_REC.PRODUCT_BUSNS_LINE_ID
      , VGC_OIS_REC.PRODUCT_MANAGER_GLOBAL_ID
      , VGC_OIS_REC.SALES_OFFICE_CDE
      , VGC_OIS_REC.SALES_GROUP_CDE
      , SCDCOMMONBATCH.GETSOURCESYSTEMID(VGC_OIS_REC.data_source_desc)
      , VGC_OIS_REC.MRP_GROUP_CDE
      , vgn_adj_amt
      , vgn_nbr_smrys_ins
      , vgn_nbr_smrys_upd
      , vgn_nbr_smrys_del
      , vgn_sql_rc);

EXCEPTION
   WHEN OTHERS THEN
      vgn_sql_rc    := SQLCODE;

END P_4000_ADJUST_SUMMARIES;

/* ************************************************************** */
/* MAIN PROCEDURE:  p_0000_dscd_fix                               */
/*                                                                */
/* Author:  Jordan G. Karr (CAI)                                  */
/*   Date:  January, 1998                                         */
/*                                                                */
/* Purpose:  Execute user specified sub procedures for each       */
/*           OIS cursor retrieved row                             */
/*                                                                */
/* ************************************************************** */

BEGIN

   DBMS_OUTPUT.PUT_LINE('*');
   DBMS_OUTPUT.PUT_LINE('*       PROCEDURE NAME:  ' || 'p_0000_dscd_fix');
   DBMS_OUTPUT.PUT_LINE('Value of vic_recalculate='||vic_recalculate);
   DBMS_OUTPUT.PUT_LINE('Value of vic_BACKOUT='||vic_backout);
   DBMS_OUTPUT.PUT_LINE('Value of vic_UPDATE='||vic_update);
   DBMS_OUTPUT.PUT_LINE('Value of vic_ADJUST='||vic_adjust);

   DBMS_OUTPUT.PUT_LINE('*  START DATE AND TIME:  ' || TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'));

   FOR ois_rec IN ois_cur
   LOOP

      vgn_row_read_cnt := vgn_row_read_cnt + 1;

      VGC_OIS_REC.temp_ship_seq                  := NULL;
      VGC_OIS_REC.dml_oracle_id                  := NULL;
      VGC_OIS_REC.dml_tmstmp                     := NULL;
      VGC_OIS_REC.update_code                    := NULL;
      VGC_OIS_REC.ORGANIZATION_KEY_ID            := OIS_REC.organization_key_id;
      -- VGC_OIS_REC.scorecard_org_code          := OIS_REC.scorecard_org_code;
      VGC_OIS_REC.amp_order_nbr                  := OIS_REC.amp_order_nbr;
      VGC_OIS_REC.order_item_nbr                 := OIS_REC.order_item_nbr;
      VGC_OIS_REC.shipment_id                    := OIS_REC.shipment_id;
      -- VGC_OIS_REC.part_nbr                    := OIS_REC.part_nbr;
      -- VGC_OIS_REC.amp_corp_name_abbrn         := OIS_REC.amp_corp_name_abbrn;
      VGC_OIS_REC.purchase_by_account_base       := OIS_REC.purchase_by_account_base;
      VGC_OIS_REC.ship_to_account_suffix         := OIS_REC.ship_to_account_suffix;
      -- VGC_OIS_REC.div_org_code                := OIS_REC.div_org_code;
      -- VGC_OIS_REC.group_org_code              := OIS_REC.group_org_code;
      -- VGC_OIS_REC.co_org_code                 := OIS_REC.co_org_code;
      -- VGC_OIS_REC.area_org_code               := OIS_REC.area_org_code;
      -- VGC_OIS_REC.region_org_code             := OIS_REC.region_org_code;
      VGC_OIS_REC.prodcn_cntrlr_code             := OIS_REC.prodcn_cntrlr_code;
      VGC_OIS_REC.item_quantity                  := OIS_REC.item_quantity;
      VGC_OIS_REC.resrvn_level_1                 := OIS_REC.resrvn_level_1;
      VGC_OIS_REC.resrvn_level_5                 := OIS_REC.resrvn_level_5;
      VGC_OIS_REC.resrvn_level_9                 := OIS_REC.resrvn_level_9;
      VGC_OIS_REC.quantity_released              := OIS_REC.quantity_released;
      VGC_OIS_REC.quantity_shipped               := OIS_REC.quantity_shipped;
      VGC_OIS_REC.iso_currency_code_1            := OIS_REC.iso_currency_code_1;
      VGC_OIS_REC.local_currency_billed_amount   := OIS_REC.local_currency_billed_amount;
      VGC_OIS_REC.extended_book_bill_amount      := OIS_REC.extended_book_bill_amount;
      VGC_OIS_REC.range_code                     := OIS_REC.range_code;
      VGC_OIS_REC.unit_price                     := OIS_REC.unit_price;
      VGC_OIS_REC.customer_request_date          := OIS_REC.customer_request_date;
      VGC_OIS_REC.amp_schedule_date              := OIS_REC.amp_schedule_date;
      VGC_OIS_REC.release_date                   := OIS_REC.release_date;
      VGC_OIS_REC.actual_on_dock_date            := OIS_REC.actual_on_dock_date;
      VGC_OIS_REC.amp_shipped_date               := OIS_REC.amp_shipped_date;
      VGC_OIS_REC.nbr_window_days_early          := OIS_REC.nbr_window_days_early;
      VGC_OIS_REC.nbr_window_days_late           := OIS_REC.nbr_window_days_late;
      VGC_OIS_REC.inventory_location_code        := OIS_REC.inventory_location_code;
      VGC_OIS_REC.inventory_building_nbr         := OIS_REC.inventory_building_nbr;
      -- VGC_OIS_REC.inventory_org_code          := OIS_REC.inventory_org_code;
      VGC_OIS_REC.Controller_uniqueness_id       := OIS_REC.controller_uniqueness_id;
      VGC_OIS_REC.actual_ship_location           := OIS_REC.actual_ship_location;
      VGC_OIS_REC.actual_ship_building_nbr       := OIS_REC.actual_ship_building_nbr;
      VGC_OIS_REC.schedule_ship_cmprsn_code      := OIS_REC.schedule_ship_cmprsn_code;
      VGC_OIS_REC.schedule_to_ship_variance      := OIS_REC.schedule_to_ship_variance;
      VGC_OIS_REC.varbl_schedule_ship_variance   := OIS_REC.varbl_schedule_ship_variance;
      VGC_OIS_REC.request_ship_cmprsn_code       := OIS_REC.request_ship_cmprsn_code;
      VGC_OIS_REC.request_to_ship_variance       := OIS_REC.request_to_ship_variance;
      VGC_OIS_REC.varbl_request_ship_variance    := OIS_REC.varbl_request_ship_variance;
      VGC_OIS_REC.request_schedule_cmprsn_code   := OIS_REC.request_schedule_cmprsn_code;
      VGC_OIS_REC.request_to_schedule_variance   := OIS_REC.request_to_schedule_variance;
      VGC_OIS_REC.current_to_request_variance    := OIS_REC.current_to_request_variance;
      VGC_OIS_REC.current_to_schedule_variance   := OIS_REC.current_to_schedule_variance;
      VGC_OIS_REC.received_to_request_variance   := OIS_REC.received_to_request_variance;
      VGC_OIS_REC.received_to_schedule_variance  := OIS_REC.received_to_schedule_variance;
      VGC_OIS_REC.received_to_ship_variance      := OIS_REC.received_to_ship_variance;
      VGC_OIS_REC.varbl_received_ship_variance   := OIS_REC.varbl_received_ship_variance;
      VGC_OIS_REC.release_to_schedule_variance   := OIS_REC.release_to_schedule_variance;
      VGC_OIS_REC.release_schedule_cmprsn_code   := OIS_REC.release_schedule_cmprsn_code;
      VGC_OIS_REC.ship_facility_cmprsn_code      := OIS_REC.ship_facility_cmprsn_code;
      VGC_OIS_REC.release_to_ship_variance       := OIS_REC.release_to_ship_variance;
      VGC_OIS_REC.order_booking_date             := OIS_REC.order_booking_date;
      VGC_OIS_REC.order_received_date            := OIS_REC.order_received_date;
      VGC_OIS_REC.order_type_id                  := OIS_REC.order_type_id;
      VGC_OIS_REC.regtrd_date                    := OIS_REC.regtrd_date;
      VGC_OIS_REC.reported_as_of_date            := OIS_REC.reported_as_of_date;
      VGC_OIS_REC.database_load_date             := OIS_REC.database_load_date;
      VGC_OIS_REC.inventory_classfcn_code        := OIS_REC.inventory_classfcn_code;
      VGC_OIS_REC.purchase_order_date            := OIS_REC.purchase_order_date;
      VGC_OIS_REC.purchase_order_nbr             := OIS_REC.purchase_order_nbr;
      VGC_OIS_REC.prodcn_cntlr_employee_nbr      := OIS_REC.prodcn_cntlr_employee_nbr;
      -- VGC_OIS_REC.part_prcmt_source_org_code  := OIS_REC.part_prcmt_source_org_code;
      VGC_OIS_REC.schlg_method_code              := OIS_REC.schlg_method_code;
      -- VGC_OIS_REC.marketing_org_code          := OIS_REC.marketing_org_code;
      VGC_OIS_REC.team_code                      := OIS_REC.team_code;
      VGC_OIS_REC.stock_make_code                := OIS_REC.stock_make_code;
      VGC_OIS_REC.product_code                   := OIS_REC.product_code;
      VGC_OIS_REC.product_line_code              := OIS_REC.product_line_code;
      -- VGC_OIS_REC.intrntnl_product_line_code  := OIS_REC.intrntnl_product_line_code;
      -- VGC_OIS_REC.product_family_code         := OIS_REC.product_family_code;
      VGC_OIS_REC.ww_account_nbr_base            := OIS_REC.ww_account_nbr_base;
      VGC_OIS_REC.ww_account_nbr_suffix          := OIS_REC.ww_account_nbr_suffix;
      VGC_OIS_REC.customer_forecast_code         := OIS_REC.customer_forecast_code;
      VGC_OIS_REC.a_territory_nbr                := OIS_REC.a_territory_nbr;
      VGC_OIS_REC.customer_reference_part_nbr    := OIS_REC.customer_reference_part_nbr;
      VGC_OIS_REC.customer_expedite_date         := OIS_REC.customer_expedite_date;
      VGC_OIS_REC.nbr_of_expedites               := OIS_REC.nbr_of_expedites;
      VGC_OIS_REC.original_expedite_date         := OIS_REC.original_expedite_date;
      VGC_OIS_REC.current_expedite_date          := OIS_REC.current_expedite_date;
      VGC_OIS_REC.earliest_expedite_date         := OIS_REC.earliest_expedite_date;
      VGC_OIS_REC.schedule_on_credit_hold_date   := OIS_REC.schedule_on_credit_hold_date;
      VGC_OIS_REC.schedule_off_credit_hold_date  := OIS_REC.schedule_off_credit_hold_date;
      VGC_OIS_REC.customer_credit_hold_ind       := OIS_REC.customer_credit_hold_ind;
      VGC_OIS_REC.customer_on_credit_hold_date   := OIS_REC.customer_on_credit_hold_date;
      VGC_OIS_REC.temp_hold_ind                  := OIS_REC.temp_hold_ind;
      VGC_OIS_REC.temp_hold_on_date              := OIS_REC.temp_hold_on_date;
      VGC_OIS_REC.temp_hold_off_date             := OIS_REC.temp_hold_off_date;
      VGC_OIS_REC.forced_bill_ind                := OIS_REC.forced_bill_ind;
      VGC_OIS_REC.customer_type_code             := OIS_REC.customer_type_code;
      VGC_OIS_REC.rush_ind                       := OIS_REC.rush_ind;
      -- VGC_OIS_REC.customer_busns_line_code       := OIS_REC.customer_busns_line_code;
      -- VGC_OIS_REC.customer_busns_line_fnctn_code := OIS_REC.customer_busns_line_fnctn_code;
      -- VGC_OIS_REC.industry_busns_line_code       := OIS_REC.industry_busns_line_code;
      -- VGC_OIS_REC.industry_busns_line_fnctn_code := OIS_REC.industry_busns_line_fnctn_code;
      VGC_OIS_REC.industry_code                  := OIS_REC.industry_code;
      VGC_OIS_REC.product_busns_line_id          := OIS_REC.product_busns_line_id;
      VGC_OIS_REC.product_busns_line_fnctn_id    := OIS_REC.product_busns_line_fnctn_id;
      VGC_OIS_REC.zero_part_prod_code            := NULL;
      VGC_OIS_REC.customer_acct_type_cde         := OIS_REC.customer_acct_type_cde;
      -- VGC_OIS_REC.trade_or_interco_code       := OIS_REC.trade_or_interco_code;
      -- VGC_OIS_REC.cust_rating_code            := NULL;
      -- VGC_OIS_REC.mfg_div_org_code            := OIS_REC.mfg_div_org_code;
      -- VGC_OIS_REC.mfg_group_org_code          := OIS_REC.mfg_group_org_code;
      VGC_OIS_REC.mfg_campus_id                  := OIS_REC.mfg_campus_id;
      VGC_OIS_REC.mfg_building_nbr               := OIS_REC.mfg_building_nbr;
      VGC_OIS_REC.mfr_org_key_id                 := OIS_REC.mfr_org_key_id;
      -- VGC_OIS_REC.pri_ww_account_nbr_base        := OIS_REC.pri_ww_account_nbr_base;
      -- VGC_OIS_REC.pri_ww_account_nbr_suffix      := OIS_REC.pri_ww_account_nbr_suffix;
      VGC_OIS_REC.industry_business_code         := OIS_REC.industry_business_code;
      VGC_OIS_REC.accounting_org_key_id          := OIS_REC.accounting_org_key_id;
      VGC_OIS_REC.profit_center_abbr_nm          := OIS_REC.profit_center_abbr_nm;
      VGC_OIS_REC.sold_to_customer_id            := OIS_REC.sold_to_customer_id;
      VGC_OIS_REC.product_manager_global_id      := OIS_REC.product_manager_global_id;
      VGC_OIS_REC.sales_office_cde               := OIS_REC.sales_office_cde;
      VGC_OIS_REC.sales_group_cde                := OIS_REC.sales_group_cde;
      VGC_OIS_REC.data_source_desc               := OIS_REC.data_source_desc;
      VGC_OIS_REC.pick_pack_work_days_qty        := OIS_REC.pick_pack_work_days_qty;
      VGC_OIS_REC.mrp_group_cde                  := OIS_REC.mrp_group_cde;

      /*
      -- Deleted on 05/11/2012
      VGC_OIS_REC.schedule_on_customer_dock_date := OIS_REC.schedule_on_customer_dock_date;
      VGC_OIS_REC.actual_on_customer_dock_date   := OIS_REC.actual_on_customer_dock_date;
      VGC_OIS_REC.customer_revised_schedule_date := OIS_REC.customer_revised_schedule_date;
      VGC_OIS_REC.special_packaging_code         := OIS_REC.special_packaging_code;
      */

      IF vic_backout = 'Y' THEN
         P_3000_BACKOUT_SUMMARIES;
         IF vgn_sql_rc <> 0 THEN
            DBMS_OUTPUT.PUT_LINE('>>>>>>>>>vgn_sql_rc>:  ' || vgn_sql_rc);
            RAISE ue_fatal_db_err;
         END IF;
         vgn_row_proc_backout_cnt := vgn_row_proc_backout_cnt + 1;
      END IF;

      /*
      IF vic_recalculate = 'Y' THEN
         p_1000_recalculate_variances;
         IF vgn_sql_rc <> 0 THEN
            RAISE ue_fatal_db_err;
         END IF;
         vgn_row_proc_variance_cnt := vgn_row_proc_variance_cnt + 1;
      END IF;

      IF vic_update = 'Y' THEN
         p_2000_update_ois;
         IF vgn_sql_rc <> 0 THEN
            RAISE ue_fatal_db_err;
         END IF;
         vgn_row_proc_update_cnt := vgn_row_proc_update_cnt + 1;
      END IF;

      IF vic_adjust = 'Y' THEN
         p_4000_adjust_summaries;
         IF vgn_sql_rc <> 0 THEN
            DBMS_OUTPUT.PUT_LINE('>>>>>>>>>vgn_sql_rc>:  ' || vgn_sql_rc);
            RAISE ue_fatal_db_err;
         END IF;
         vgn_row_proc_adjust_cnt := vgn_row_proc_adjust_cnt + 1;
      END IF;
      */

      IF MOD (vgn_row_read_cnt, vin_com_cnt) = 0 THEN
         DBMS_OUTPUT.PUT_LINE('*');
         DBMS_OUTPUT.PUT_LINE('*  PROCEDURE NAME:  ' || vgc_proc_name);
         DBMS_OUTPUT.PUT_LINE('*       ROWS READ:  ' || vgn_row_read_cnt);
         DBMS_OUTPUT.PUT_LINE('* ROWS BACKED OUT:  ' || vgn_row_proc_backout_cnt);
         DBMS_OUTPUT.PUT_LINE('* ROWS RECALC VAR:  ' || vgn_row_proc_variance_cnt);
         DBMS_OUTPUT.PUT_LINE('*    ROWS UPDATED:  ' || vgn_row_proc_update_cnt);
         DBMS_OUTPUT.PUT_LINE('*   ROWS ADJUSTED:  ' || vgn_row_proc_adjust_cnt);
         DBMS_OUTPUT.PUT_LINE('*');
         COMMIT;
      END IF;

   END LOOP;
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('*');
   DBMS_OUTPUT.PUT_LINE('*  PROCEDURE NAME:  ' || vgc_proc_name);
   DBMS_OUTPUT.PUT_LINE('*       ROWS READ:  ' || vgn_row_read_cnt);
   DBMS_OUTPUT.PUT_LINE('* ROWS BACKED OUT:  ' || vgn_row_proc_backout_cnt);
   DBMS_OUTPUT.PUT_LINE('* ROWS RECALC VAR:  ' || vgn_row_proc_variance_cnt);
   DBMS_OUTPUT.PUT_LINE('*    ROWS UPDATED:  ' || vgn_row_proc_update_cnt);
   DBMS_OUTPUT.PUT_LINE('*   ROWS ADJUSTED:  ' || vgn_row_proc_adjust_cnt);
   DBMS_OUTPUT.PUT_LINE('*');
   DBMS_OUTPUT.PUT_LINE('*     PROCEDURE NAME:  ' || 'p_0000_dscd_fix');
   DBMS_OUTPUT.PUT_LINE('*  END DATE AND TIME:  ' || TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'));

   von_sql_rc := vgn_sql_rc;

EXCEPTION
   WHEN ue_fatal_db_err THEN
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*  PROCEDURE NAME:  ' || vgc_proc_name);
      DBMS_OUTPUT.PUT_LINE('*       SQL ERROR:  ' || SQLERRM(vgn_sql_rc));
      DBMS_OUTPUT.PUT_LINE('*       ROWS READ:  ' || vgn_row_read_cnt);
      DBMS_OUTPUT.PUT_LINE('* ROWS BACKED OUT:  ' || vgn_row_proc_backout_cnt);
      DBMS_OUTPUT.PUT_LINE('* ROWS RECALC VAR:  ' || vgn_row_proc_variance_cnt);
      DBMS_OUTPUT.PUT_LINE('*    ROWS UPDATED:  ' || vgn_row_proc_update_cnt);
      DBMS_OUTPUT.PUT_LINE('*   ROWS ADJUSTED:  ' || vgn_row_proc_adjust_cnt);
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*     PROCEDURE NAME:  ' || 'p_0000_dscd_fix');
      DBMS_OUTPUT.PUT_LINE('*  END DATE AND TIME:  ' || TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'));
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*       AMP_ORDER_NBR:  ' || VGC_OIS_REC.amp_order_nbr);
      DBMS_OUTPUT.PUT_LINE('*      ORDER_ITEM_NBR:  ' || VGC_OIS_REC.order_item_nbr);
      DBMS_OUTPUT.PUT_LINE('*         SHIPMENT_ID:  ' || VGC_OIS_REC.shipment_id);
      DBMS_OUTPUT.PUT_LINE('* ORGANIZATION_KEY_ID:  ' || VGC_OIS_REC.organization_key_id);
      von_sql_rc := vgn_sql_rc;
      ROLLBACK;

   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*  PROCEDURE NAME:  ' || vgc_proc_name);
      DBMS_OUTPUT.PUT_LINE('*       SQL ERROR:  ' || SQLERRM(vgn_sql_rc));
      DBMS_OUTPUT.PUT_LINE('*       ROWS READ:  ' || vgn_row_read_cnt);
      DBMS_OUTPUT.PUT_LINE('* ROWS BACKED OUT:  ' || vgn_row_proc_backout_cnt);
      DBMS_OUTPUT.PUT_LINE('* ROWS RECALC VAR:  ' || vgn_row_proc_variance_cnt);
      DBMS_OUTPUT.PUT_LINE('*    ROWS UPDATED:  ' || vgn_row_proc_update_cnt);
      DBMS_OUTPUT.PUT_LINE('*   ROWS ADJUSTED:  ' || vgn_row_proc_adjust_cnt);
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*     PROCEDURE NAME:  ' || 'p_0000_dscd_fix');
      DBMS_OUTPUT.PUT_LINE('*  END DATE AND TIME:  ' || TO_CHAR (SYSDATE, 'DD-MON-YY HH:MI AM'));
      DBMS_OUTPUT.PUT_LINE('*');
      DBMS_OUTPUT.PUT_LINE('*       AMP_ORDER_NBR:  ' || VGC_OIS_REC.amp_order_nbr);
      DBMS_OUTPUT.PUT_LINE('*      ORDER_ITEM_NBR:  ' || VGC_OIS_REC.order_item_nbr);
      DBMS_OUTPUT.PUT_LINE('*         SHIPMENT_ID:  ' || VGC_OIS_REC.shipment_id);
      DBMS_OUTPUT.PUT_LINE('* ORGANIZATION_KEY_ID:  ' || VGC_OIS_REC.organization_key_id);
      von_sql_rc := vgn_sql_rc;

      ROLLBACK;

END P_DSCD_FIX_BAKOUT_REC;
/
