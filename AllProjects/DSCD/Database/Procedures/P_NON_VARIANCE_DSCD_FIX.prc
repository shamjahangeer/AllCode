CREATE OR REPLACE PROCEDURE "P_NON_VARIANCE_DSCD_FIX" (vic_recalculate IN CHAR,
                                             vic_update      IN CHAR,
                                             vic_backout     IN CHAR,
                                             vic_adjust      IN CHAR,
                                             vid_after_date  IN DATE,
                                             vid_before_date IN DATE,
                                             vin_com_cnt     IN NUMBER,
                                             von_sql_rc     OUT NUMBER) IS

  ue_fatal_db_err  EXCEPTION;

  vgc_proc_name     CHAR(40);
  vgc_job_id        CHAR(8) := 'DSCDFIX ';
  vgc_ois_rec       temp_order_item_shipment%ROWTYPE;
  vgn_adj_amt       NUMBER;
  vgn_nbr_smrys_ins NUMBER;
  vgn_nbr_smrys_upd NUMBER;
  vgn_nbr_smrys_del NUMBER;
  vgn_sql_rc        NUMBER := 0;
  vgn_row_read_cnt  NUMBER := 0;
  vgn_row_proc_backout_cnt  NUMBER := 0;
  vgn_row_proc_variance_cnt  NUMBER := 0;
  vgn_row_proc_update_cnt  NUMBER := 0;
  vgn_row_proc_adjust_cnt  NUMBER := 0;
  vgc_profit_center_abbr_nm ORDER_ITEM_SHIPMENT.PROFIT_CENTER_ABBR_NM%TYPE;
  vlc_section			 VARCHAR2(50);
  vgn_result			 NUMBER := 0;

  CURSOR ois_cur IS
    SELECT a.*,b.st_industry_code,c.industry_business_code gi_industry_business_code
          ,d.pb_WW_CSTMR_ACCT_NBR
FROM order_item_shipment a, GBL_CURRENT.GBL_CUSTOMER_SHIP_TO b
    ,GBL_INDUSTRY c
    , GBL_CURRENT.GBL_CUSTOMER_PURCHASED_BY d
WHERE 1=1
--WHERE a.industry_code='RA21'
--AND database_load_date  BETWEEN '01-dec-2007' AND '30-dec-2007'
AND a.industry_code='ZZZZ'
AND database_load_date >= '01-aug-2009'
--AND database_load_date  BETWEEN '09-aug-2009' AND '14-aug-2009'
AND a.hierarchy_customer_org_id=b.ST_ACCT_ORG_ID
AND a.hierarchy_customer_base_id=b.ST_ACCT_NBR_BASE
AND a.hierarchy_customer_sufx_id=b.ST_ACCT_NBR_SUFX
AND b.st_industry_code != 'ZZZZ' --IS NOT NULL
AND b.st_industry_code = c.industry_code
AND c.industry_business_code IS NOT NULL
AND d.PB_ACCT_ORG_ID    = a.hierarchy_customer_org_id
AND d.PB_ACCT_NBR_BASE  = a.hierarchy_customer_base_id
--AND ((amp_order_nbr='3013496853' and order_item_nbr='000001')
--or (amp_order_nbr='711302723' and order_item_nbr='001')
--or (amp_order_nbr='6949396' and order_item_nbr='23')
--)
--AND a.hierarchy_customer_org_id ='0791'
;

  g_rec  ois_cur%ROWTYPE;

PROCEDURE p_get_profit_center_abbr_nm IS
BEGIN
  vlc_section := 'Get Profit Ctr';

  SELECT MGE_PROFIT_CENTER_ABBR_NM
  INTO   vgc_profit_center_abbr_nm
  FROM   GBL_MGE_PROFIT_CENTERS gmpc,
         GBL_MGE_PROFIT_CENTER_RELS gmpcr
  WHERE  gmpc.MGE_PROFIT_CENTER_ID  = gmpcr.MGE_PROFIT_CENTER_ID
    AND  gmpcr.ORGANIZATION_ID = (SELECT COMPANY_ORGANIZATION_ID
	                              FROM organizations_dmn
								  WHERE organization_key_id = vgc_ois_rec.ORGANIZATION_KEY_ID
								  AND record_status_cde = 'C')
  AND    INDUSTRY_BUSINESS_CDE 	 = vgc_ois_rec.INDUSTRY_BUSINESS_CODE
  AND    COMPETENCY_BUSINESS_CDE = vgc_ois_rec.product_busns_line_fnctn_id; -- vgc_busln_fnctn_id;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    vgc_profit_center_abbr_nm := NULL;
  WHEN OTHERS THEN
  	vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(SQLCODE)) ;
END;

PROCEDURE p_update_ww_acct_xref IS
  v_amp_ship_date	DATE;
  v_rowid			ROWID;
BEGIN
  vlc_section := 'Get Shipped_date in ww_acct_xref';
  BEGIN
    SELECT AMP_SHIPPED_DATE,ROWID
	INTO   v_amp_ship_date,v_rowid
	FROM   SCORECARD_CUSTOMER_WW_XREF
	WHERE  PURCHASE_BY_ACCOUNT_BASE = vgc_ois_rec.PURCHASE_BY_ACCOUNT_BASE
	AND    SHIP_TO_ACCOUNT_SUFFIX 	= vgc_ois_rec.SHIP_TO_ACCOUNT_SUFFIX
	AND	   ACCOUNTING_ORG_KEY_ID 	= vgc_ois_rec.ACCOUNTING_ORG_KEY_ID
    AND    WW_ACCOUNT_NBR_BASE 		= vgc_ois_rec.WW_ACCOUNT_NBR_BASE
	AND    WW_ACCOUNT_NBR_SUFFIX 	= vgc_ois_rec.WW_ACCOUNT_NBR_SUFFIX
	AND    NBR_WINDOW_DAYS_EARLY 	= NVL(vgc_ois_rec.NBR_WINDOW_DAYS_EARLY,0)
	AND    NBR_WINDOW_DAYS_LATE 	= NVL(vgc_ois_rec.NBR_WINDOW_DAYS_LATE,0)
	;

	IF vgc_ois_rec.AMP_SHIPPED_DATE > v_amp_ship_date THEN
	  vlc_section := 'Update ww_acct_xref';
	  UPDATE SCORECARD_CUSTOMER_WW_XREF
	  SET	 AMP_SHIPPED_DATE =	vgc_ois_rec.AMP_SHIPPED_DATE
	  		,DML_TMSTMP		  = SYSDATE
	  WHERE	 ROWID 			  = v_rowid
	  ;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
  	  vlc_section := 'Insert ww_acct_xref';
      INSERT INTO SCORECARD_CUSTOMER_WW_XREF
           (WW_ACCOUNT_NBR_BASE
           ,WW_ACCOUNT_NBR_SUFFIX
           ,PURCHASE_BY_ACCOUNT_BASE
           ,SHIP_TO_ACCOUNT_SUFFIX
           ,NBR_WINDOW_DAYS_EARLY
           ,NBR_WINDOW_DAYS_LATE
           ,DML_ORACLE_ID
           ,DML_TMSTMP
           ,AMP_SHIPPED_DATE
		   ,ACCOUNTING_ORG_KEY_ID
		   )
      VALUES
           (vgc_ois_rec.WW_ACCOUNT_NBR_BASE
           ,vgc_ois_rec.WW_ACCOUNT_NBR_SUFFIX
           ,vgc_ois_rec.PURCHASE_BY_ACCOUNT_BASE
           ,vgc_ois_rec.SHIP_TO_ACCOUNT_SUFFIX
           ,NVL(vgc_ois_rec.NBR_WINDOW_DAYS_EARLY,0)
           ,NVL(vgc_ois_rec.NBR_WINDOW_DAYS_LATE,0)
           ,vgc_ois_rec.DML_ORACLE_ID
           ,SYSDATE
           ,vgc_ois_rec.AMP_SHIPPED_DATE
		   ,vgc_ois_rec.ACCOUNTING_ORG_KEY_ID
		   );
    WHEN OTHERS THEN
  	  vgn_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
      DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(SQLCODE)) ;
  END;
EXCEPTION
  WHEN OTHERS THEN
  	vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(SQLCODE)) ;
END;


/*********************************************************************/
/**  SUB PROCEDURE:  p_1000_recalculate_variances                   **/
/**                                                                 **/
/**  Author:  Jordan G. Karr (CAI)                                  **/
/**    Date:  January, 1998                                         **/
/**                                                                 **/
/**  Purpose:  Recalculates variances for retrieved OIS record      **/
/**                                                                 **/
/*********************************************************************/

  PROCEDURE p_1000_recalculate_variances IS

    BEGIN

      vgc_proc_name := 'p_1000_recalculate_variances';

      vgn_sql_rc    := 0;

/**                                                       **/
/**  Particular input Variance Calculation field changes  **/
/**                                                       **/
--      vgc_ois_rec.release_date := '24-SEP-2007';
--      vgc_ois_rec.amp_shipped_date := '21-may-2008';
--	  vgc_ois_rec.actual_on_dock_date := vgc_ois_rec.amp_shipped_date;
	  --vgc_ois_rec.regtrd_date := '25-feb-2003';
--      vgc_ois_rec.amp_schedule_date := '09-JAN-2008';
--      vgc_ois_rec.CUSTOMER_expedite_DATE := vgc_ois_rec.amp_shipped_date;
--        vgc_ois_rec.customer_request_date := '09-JAN-2008';
--        vgc_ois_rec.customer_expedite_date := '08-MAY-01';
--        vgc_ois_rec.nbr_window_days_early := 3;
--       vgc_ois_rec.nbr_window_days_late := 0;

      Pkg_Variance_Calc.p_variance_calc (vgc_ois_rec, vgn_sql_rc);

    END p_1000_recalculate_variances;

/*********************************************************************/
/**  SUB PROCEDURE:  p_2000_update_ois                              **/
/**                                                                 **/
/**  Author:  Jordan G. Karr (CAI)                                  **/
/**    Date:  January, 1998                                         **/
/**                                                                 **/
/**  Purpose:  Updates OIS record with recalculated                 **/
/**            VARBL_REQUEST_SHIP_VARIANCE bucket                   **/
/**                                                                 **/
/*********************************************************************/

  PROCEDURE p_2000_update_ois IS

    BEGIN

      vgc_proc_name := 'p_2000_update_ois';

      vgn_sql_rc    := 0;

    vgc_ois_rec.INDUSTRY_CODE := g_rec.st_industry_code;
    vgc_ois_rec.INDUSTRY_BUSINESS_CODE := g_rec.gi_INDUSTRY_BUSINESS_CODE;

	   	  -- get new profit center one more time
	   	  p_get_profit_center_abbr_nm;
       	  IF vgn_result <> 0 THEN
    	  	    RAISE_APPLICATION_ERROR (-20101, 'ABORTED in p_get_profit_center_abbr_nm with sql error-' || SQLERRM);
       	  END IF;
    vgc_ois_rec.profit_center_abbr_nm := NVL(vgc_profit_center_abbr_nm,'*');

	 -- get trade/interco value
	 IF g_rec.st_industry_code IN ('VA11','VA12') THEN
     	vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE := 'I';
	 ELSE
     	vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE := 'T';
  	 END IF;

    IF g_rec.pb_WW_CSTMR_ACCT_NBR IS NOT NULL THEN
	   vgc_ois_rec.WW_ACCOUNT_NBR_BASE   := NVL(SUBSTR(g_rec.pb_WW_CSTMR_ACCT_NBR,1,8),'*');
	   vgc_ois_rec.WW_ACCOUNT_NBR_SUFFIX := NVL(SUBSTR(g_rec.pb_WW_CSTMR_ACCT_NBR,9,2),'*');

   	   -- update ww_accnt_xref table
       p_update_ww_acct_xref;
   	   IF vgn_result <> 0 THEN
   	   	RAISE_APPLICATION_ERROR (-20101, 'ABORTED in p_update_ww_acct_xref with sql error-' || SQLERRM);
   	   END IF;
    END IF;


    -- derive security values
    vgc_ois_rec.ORIG_IBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_ibc_pc_id(vgc_ois_rec.INDUSTRY_BUSINESS_CODE);
    vgc_ois_rec.ORIG_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(vgc_ois_rec.ORIG_IBC_PROFIT_CENTER_ID);

    vgc_ois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(vgc_ois_rec.PROFIT_CENTER_ABBR_NM);

    -- get CBC & RPTORG DSG ID
    BEGIN
      SELECT ORIG_CBC_DATA_SECR_GRP_ID
            ,ORIGREPT_PRFT_DATA_SECR_GRP_ID
            ,ORIG_SLS_TERR_DATA_SECR_GRP_ID
      INTO   vgc_ois_rec.ORIG_CBC_DATA_SECR_GRP_ID
           , vgc_ois_rec.ORIGREPT_PRFT_DATA_SECR_GRP_ID
           , vgc_ois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID
      FROM   ORDER_ITEM_SHIP_DATA_SECURITY
      WHERE  AMP_ORDER_NBR       = vgc_ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = vgc_ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	       = vgc_ois_rec.SHIPMENT_ID
      AND	 ORGANIZATION_KEY_ID = vgc_ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20101, 'ABORTED in get other DSG ID with sql error-' || SQLERRM);
    END;

    vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID := get_data_security_tag(vgc_ois_rec.ORIG_IBC_DATA_SECR_GRP_ID
                                                               ,vgc_ois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID
                                                               ,vgc_ois_rec.ORIG_CBC_DATA_SECR_GRP_ID
                                                               ,vgc_ois_rec.ORIGREPT_PRFT_DATA_SECR_GRP_ID
                                                               ,vgc_ois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
                                                               );

    vgc_ois_rec.CUR_DATA_SECURITY_TAG_ID := vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID;
    vgc_ois_rec.SUPER_DATA_SECURITY_TAG_ID := vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID;

    -- update security table
    BEGIN
    	vlc_section := 'Update CUSTOMER_ACCT in OIS SECURITY';
      UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
      SET    DML_TS = SYSDATE
            ,ORIG_INDUSTRY_CDE              = vgc_ois_rec.INDUSTRY_CODE
            ,ORIG_INDUSTRY_BUSINESS_CDE     = vgc_ois_rec.INDUSTRY_BUSINESS_CODE
            ,ORIG_IBC_PROFIT_CENTER_ID      = vgc_ois_rec.ORIG_IBC_PROFIT_CENTER_ID
            ,ORIG_IBC_DATA_SECR_GRP_ID      = vgc_ois_rec.ORIG_IBC_DATA_SECR_GRP_ID
            ,CUR_INDUSTRY_CDE               = vgc_ois_rec.INDUSTRY_CODE
            ,CUR_INDUSTRY_BUSINESS_CDE      = vgc_ois_rec.INDUSTRY_BUSINESS_CODE
            ,CUR_IBC_PROFIT_CENTER_ID       = vgc_ois_rec.ORIG_IBC_PROFIT_CENTER_ID
            ,CUR_IBC_DATA_SECR_GRP_ID       = vgc_ois_rec.ORIG_IBC_DATA_SECR_GRP_ID
            ,ORIG_MANAGEMENT_PROFIT_CTR_ID  = vgc_ois_rec.PROFIT_CENTER_ABBR_NM
            ,ORIG_MGE_PRFT_DATA_SECR_GRP_ID = vgc_ois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,CUR_MGE_PROFIT_CTR_ID          = vgc_ois_rec.PROFIT_CENTER_ABBR_NM
            ,CUR_MGE_PRFT_DATA_SECR_GRP_ID  = vgc_ois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,ORIG_DATA_SECURITY_TAG_ID      = vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,CUR_DATA_SECURITY_TAG_ID       = vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,SUPER_DATA_SECURITY_TAG_ID     = vgc_ois_rec.ORIG_DATA_SECURITY_TAG_ID
      WHERE  AMP_ORDER_NBR       = vgc_ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = vgc_ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	       = vgc_ois_rec.SHIPMENT_ID
      AND	   ORGANIZATION_KEY_ID = vgc_ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
--       WHEN NO_DATA_FOUND THEN
--         NULL;
       WHEN OTHERS THEN
         RAISE_APPLICATION_ERROR (-20101, 'ABORTED in UPDATE ORDER_ITEM_SHIP_DATA_SECURITY with sql error-' || SQLERRM);
    END;

    UPDATE order_item_shipment
/**                                **/
/**  Particular OIS field updates  **/
/**                                **/
    SET
 	  		    dml_tmstmp = SYSDATE
			   ,INDUSTRY_CODE 					= vgc_ois_rec.INDUSTRY_CODE
			   ,INDUSTRY_BUSINESS_CODE	  		= vgc_ois_rec.INDUSTRY_BUSINESS_CODE
			   ,CUSTOMER_ACCT_TYPE_CDE 		= vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE
			   ,PROFIT_CENTER_ABBR_NM        = vgc_ois_rec.PROFIT_CENTER_ABBR_NM
			   ,WW_ACCOUNT_NBR_BASE				= vgc_ois_rec.WW_ACCOUNT_NBR_BASE
			   ,WW_ACCOUNT_NBR_SUFFIX			= vgc_ois_rec.WW_ACCOUNT_NBR_SUFFIX
            ,SUPER_DATA_SECURITY_TAG_ID   = vgc_ois_rec.SUPER_DATA_SECURITY_TAG_ID

     WHERE amp_order_nbr      = vgc_ois_rec.amp_order_nbr       AND
            shipment_id        = vgc_ois_rec.shipment_id         AND
            order_item_nbr     = vgc_ois_rec.order_item_nbr      AND
--            scorecard_org_code = vgc_ois_rec.scorecard_org_code;
			organization_key_id = vgc_ois_rec.organization_key_id;

    EXCEPTION
      WHEN OTHERS THEN
        vgn_sql_rc    := SQLCODE;

    END p_2000_update_ois;

/*********************************************************************/
/**  SUB PROCEDURE:  p_3000_backout_summaries                       **/
/**                                                                 **/
/**  Author:  Jordan G. Karr (CAI)                                  **/
/**    Date:  January, 1998                                         **/
/**                                                                 **/
/**  Purpose:  Backs out summary tables for retrieved OIS record    **/
/**            variances                                            **/
/**                                                                 **/
/*********************************************************************/

  PROCEDURE p_3000_backout_summaries IS

    BEGIN

      vgc_proc_name := 'p_3000_backout_summaries';

      vgn_adj_amt       := -1;
      vgn_nbr_smrys_ins :=  0;
      vgn_nbr_smrys_upd :=  0;
      vgn_nbr_smrys_del :=  0;
      vgn_sql_rc        :=  0;

      Pkg_Adjust_Summaries.p_adjust_summaries (vgc_job_id,
        vgc_ois_rec.amp_shipped_date,
		vgc_ois_rec.ORGANIZATION_KEY_ID,
--        vgc_ois_rec.div_org_code,
--        vgc_ois_rec.group_org_code,
--        vgc_ois_rec.co_org_code,
--        vgc_ois_rec.area_org_code,
--        vgc_ois_rec.region_org_code,
--        vgc_ois_rec.scorecard_org_code,
--        vgc_ois_rec.part_prcmt_source_org_code,
        vgc_ois_rec.team_code,
        vgc_ois_rec.prodcn_cntrlr_code,
		vgc_ois_rec.CONTROLLER_UNIQUENESS_ID,
--        vgc_ois_rec.inventory_org_code,
        vgc_ois_rec.stock_make_code,
        vgc_ois_rec.product_line_code,
--        vgc_ois_rec.intrntnl_product_line_code,
        vgc_ois_rec.product_code,
        vgc_ois_rec.prodcn_cntlr_employee_nbr,
        vgc_ois_rec.a_territory_nbr,
--        vgc_ois_rec.marketing_org_code,
--        vgc_ois_rec.product_family_code,
        vgc_ois_rec.actual_ship_building_nbr,
        vgc_ois_rec.actual_ship_location,
        vgc_ois_rec.purchase_by_account_base,
        vgc_ois_rec.ship_to_account_suffix,
        vgc_ois_rec.ww_account_nbr_base,
        vgc_ois_rec.ww_account_nbr_suffix,
        vgc_ois_rec.customer_type_code,
        vgc_ois_rec.ship_facility_cmprsn_code,
        vgc_ois_rec.release_to_ship_variance,
        vgc_ois_rec.schedule_to_ship_variance,
        vgc_ois_rec.varbl_schedule_ship_variance,
        vgc_ois_rec.request_to_ship_variance,
        vgc_ois_rec.varbl_request_ship_variance,
        vgc_ois_rec.request_to_schedule_variance,
--        vgc_ois_rec.trade_or_interco_code,
		vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE,
        vgc_ois_rec.industry_code,
		vgc_ois_rec.MFR_ORG_KEY_ID,
--        vgc_ois_rec.mfg_div_org_code,
--        vgc_ois_rec.mfg_group_org_code,
        vgc_ois_rec.mfg_campus_id,
        vgc_ois_rec.mfg_building_nbr,
--        vgc_ois_rec.pri_ww_account_nbr_base,
--        vgc_ois_rec.pri_ww_account_nbr_suffix,
		vgc_ois_rec.industry_business_code,
	   	vgc_ois_rec.ACCOUNTING_ORG_KEY_ID,
		vgc_ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID,
		vgc_ois_rec.PROFIT_CENTER_ABBR_NM,
		vgc_ois_rec.SOLD_TO_CUSTOMER_ID,
		vgc_ois_rec.PRODUCT_BUSNS_LINE_ID,
		vgc_ois_rec.PRODUCT_MANAGER_GLOBAL_ID,
	   	vgc_ois_rec.SALES_OFFICE_CDE,
		vgc_ois_rec.SALES_GROUP_CDE,
		Scdcommonbatch.GETSOURCESYSTEMID(vgc_ois_rec.DATA_SOURCE_DESC),
		vgc_ois_rec.MRP_GROUP_CDE,
        vgn_adj_amt,
        vgn_nbr_smrys_ins,
        vgn_nbr_smrys_upd,
        vgn_nbr_smrys_del,
        vgn_sql_rc);

    EXCEPTION
      WHEN OTHERS THEN
        vgn_sql_rc    := SQLCODE;
		DBMS_OUTPUT.PUT_LINE('   SQL ERROR MSG:  ' || SQLERRM);

    END p_3000_backout_summaries;

/*********************************************************************/
/**  SUB PROCEDURE:  p_4000_adjust_summaries                        **/
/**                                                                 **/
/**  Author:  Jordan G. Karr (CAI)                                  **/
/**    Date:  January, 1998                                         **/
/**                                                                 **/
/**  Purpose:  Adjusts summary tables with recalculated variances   **/
/**            for retrieved OIS record                             **/
/**                                                                 **/
/*********************************************************************/

  PROCEDURE p_4000_adjust_summaries IS

    BEGIN

      vgc_proc_name := 'p_4000_adjust_summaries';

      vgn_adj_amt       := 1;
      vgn_nbr_smrys_ins := 0;
      vgn_nbr_smrys_upd := 0;
      vgn_nbr_smrys_del := 0;
      vgn_sql_rc        := 0;

      Pkg_Adjust_Summaries.p_adjust_summaries (vgc_job_id,
        vgc_ois_rec.amp_shipped_date,
		vgc_ois_rec.ORGANIZATION_KEY_ID,
--        vgc_ois_rec.div_org_code,
--        vgc_ois_rec.group_org_code,
--        vgc_ois_rec.co_org_code,
--        vgc_ois_rec.area_org_code,
--        vgc_ois_rec.region_org_code,
--        vgc_ois_rec.scorecard_org_code,
--        vgc_ois_rec.part_prcmt_source_org_code,
        vgc_ois_rec.team_code,
        vgc_ois_rec.prodcn_cntrlr_code,
		vgc_ois_rec.CONTROLLER_UNIQUENESS_ID,
--        vgc_ois_rec.inventory_org_code,
        vgc_ois_rec.stock_make_code,
        vgc_ois_rec.product_line_code,
--        vgc_ois_rec.intrntnl_product_line_code,
        vgc_ois_rec.product_code,
        vgc_ois_rec.prodcn_cntlr_employee_nbr,
        vgc_ois_rec.a_territory_nbr,
--        vgc_ois_rec.marketing_org_code,
--        vgc_ois_rec.product_family_code,
        vgc_ois_rec.actual_ship_building_nbr,
        vgc_ois_rec.actual_ship_location,
        vgc_ois_rec.purchase_by_account_base,
        vgc_ois_rec.ship_to_account_suffix,
        vgc_ois_rec.ww_account_nbr_base,
        vgc_ois_rec.ww_account_nbr_suffix,
        vgc_ois_rec.customer_type_code,
        vgc_ois_rec.ship_facility_cmprsn_code,
        vgc_ois_rec.release_to_ship_variance,
        vgc_ois_rec.schedule_to_ship_variance,
        vgc_ois_rec.varbl_schedule_ship_variance,
        vgc_ois_rec.request_to_ship_variance,
        vgc_ois_rec.varbl_request_ship_variance,
        vgc_ois_rec.request_to_schedule_variance,
--        vgc_ois_rec.trade_or_interco_code,
		vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE,
        vgc_ois_rec.industry_code,
		vgc_ois_rec.MFR_ORG_KEY_ID,
--        vgc_ois_rec.mfg_div_org_code,
--        vgc_ois_rec.mfg_group_org_code,
        vgc_ois_rec.mfg_campus_id,
        vgc_ois_rec.mfg_building_nbr,
--        vgc_ois_rec.pri_ww_account_nbr_base,
--        vgc_ois_rec.pri_ww_account_nbr_suffix,
		vgc_ois_rec.industry_business_code,
	   	vgc_ois_rec.ACCOUNTING_ORG_KEY_ID,
		vgc_ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID,
		vgc_ois_rec.PROFIT_CENTER_ABBR_NM,
		vgc_ois_rec.SOLD_TO_CUSTOMER_ID,
		vgc_ois_rec.PRODUCT_BUSNS_LINE_ID,
		vgc_ois_rec.PRODUCT_MANAGER_GLOBAL_ID,
	   	vgc_ois_rec.SALES_OFFICE_CDE,
		vgc_ois_rec.SALES_GROUP_CDE,
		Scdcommonbatch.GETSOURCESYSTEMID(vgc_ois_rec.DATA_SOURCE_DESC),
		vgc_ois_rec.MRP_GROUP_CDE,
        vgn_adj_amt,
        vgn_nbr_smrys_ins,
        vgn_nbr_smrys_upd,
        vgn_nbr_smrys_del,
        vgn_sql_rc);

    EXCEPTION
      WHEN OTHERS THEN
        vgn_sql_rc    := SQLCODE;

    END p_4000_adjust_summaries;

/*********************************************************************/
/**  MAIN PROCEDURE:  p_0000_dscd_fix                               **/
/**                                                                 **/
/**  Author:  Jordan G. Karr (CAI)                                  **/
/**    Date:  January, 1998                                         **/
/**                                                                 **/
/**  Purpose:  Execute user specified sub procedures for each       **/
/**            OIS cursor retrieved row                             **/
/**                                                                 **/
/*********************************************************************/

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
        g_rec := ois_rec;
        vgn_row_read_cnt := vgn_row_read_cnt + 1;

        vgc_ois_rec.temp_ship_seq                  := NULL;
        vgc_ois_rec.dml_oracle_id                  := ois_rec.dml_oracle_id;
        vgc_ois_rec.dml_tmstmp                     := NULL;
        vgc_ois_rec.update_code                    := NULL;
        vgc_ois_rec.ORGANIZATION_KEY_ID			   := ois_rec.ORGANIZATION_KEY_ID;
        -- vgc_ois_rec.scorecard_org_code             := ois_rec.scorecard_org_code;
        vgc_ois_rec.amp_order_nbr                  := ois_rec.amp_order_nbr;
        vgc_ois_rec.order_item_nbr                 := ois_rec.order_item_nbr;
        vgc_ois_rec.shipment_id                    := ois_rec.shipment_id;
        -- vgc_ois_rec.part_nbr                       := ois_rec.part_nbr;
        -- vgc_ois_rec.amp_corp_name_abbrn            := ois_rec.amp_corp_name_abbrn;
        vgc_ois_rec.purchase_by_account_base       := ois_rec.purchase_by_account_base;
        vgc_ois_rec.ship_to_account_suffix         := ois_rec.ship_to_account_suffix;
        -- vgc_ois_rec.div_org_code                   := ois_rec.div_org_code;
        -- vgc_ois_rec.group_org_code                 := ois_rec.group_org_code;
        -- vgc_ois_rec.co_org_code                    := ois_rec.co_org_code;
        -- vgc_ois_rec.area_org_code                  := ois_rec.area_org_code;
        -- vgc_ois_rec.region_org_code                := ois_rec.region_org_code;
        vgc_ois_rec.prodcn_cntrlr_code             := ois_rec.prodcn_cntrlr_code;
        vgc_ois_rec.item_quantity                  := ois_rec.item_quantity;
        vgc_ois_rec.resrvn_level_1                 := ois_rec.resrvn_level_1;
        vgc_ois_rec.resrvn_level_5                 := ois_rec.resrvn_level_5;
        vgc_ois_rec.resrvn_level_9                 := ois_rec.resrvn_level_9;
        vgc_ois_rec.quantity_released              := ois_rec.quantity_released;
        vgc_ois_rec.quantity_shipped               := ois_rec.quantity_shipped;
        vgc_ois_rec.iso_currency_code_1            := ois_rec.iso_currency_code_1;
        vgc_ois_rec.local_currency_billed_amount   := ois_rec.local_currency_billed_amount;
        vgc_ois_rec.extended_book_bill_amount      := ois_rec.extended_book_bill_amount;
        vgc_ois_rec.range_code                     := ois_rec.range_code;
        vgc_ois_rec.unit_price                     := ois_rec.unit_price;
        vgc_ois_rec.customer_request_date          := ois_rec.customer_request_date;
        vgc_ois_rec.amp_schedule_date              := ois_rec.amp_schedule_date;
        vgc_ois_rec.release_date                   := ois_rec.release_date;
        vgc_ois_rec.actual_on_dock_date            := ois_rec.actual_on_dock_date;
        vgc_ois_rec.amp_shipped_date               := ois_rec.amp_shipped_date;
        vgc_ois_rec.nbr_window_days_early          := ois_rec.nbr_window_days_early;
        vgc_ois_rec.nbr_window_days_late           := ois_rec.nbr_window_days_late;
        vgc_ois_rec.inventory_location_code        := ois_rec.inventory_location_code;
        vgc_ois_rec.inventory_building_nbr         := ois_rec.inventory_building_nbr;
        -- vgc_ois_rec.inventory_org_code             := ois_rec.inventory_org_code;
        vgc_ois_rec.CONTROLLER_UNIQUENESS_ID	   := ois_rec.CONTROLLER_UNIQUENESS_ID;
        vgc_ois_rec.actual_ship_location           := ois_rec.actual_ship_location;
        vgc_ois_rec.actual_ship_building_nbr       := ois_rec.actual_ship_building_nbr;
        vgc_ois_rec.schedule_ship_cmprsn_code      := ois_rec.schedule_ship_cmprsn_code;
        vgc_ois_rec.schedule_to_ship_variance      := ois_rec.schedule_to_ship_variance;
        vgc_ois_rec.varbl_schedule_ship_variance   := ois_rec.varbl_schedule_ship_variance;
        vgc_ois_rec.request_ship_cmprsn_code       := ois_rec.request_ship_cmprsn_code;
        vgc_ois_rec.request_to_ship_variance       := ois_rec.request_to_ship_variance;
        vgc_ois_rec.varbl_request_ship_variance    := ois_rec.varbl_request_ship_variance;
        vgc_ois_rec.request_schedule_cmprsn_code   := ois_rec.request_schedule_cmprsn_code;
        vgc_ois_rec.request_to_schedule_variance   := ois_rec.request_to_schedule_variance;
        vgc_ois_rec.current_to_request_variance    := ois_rec.current_to_request_variance;
        vgc_ois_rec.current_to_schedule_variance   := ois_rec.current_to_schedule_variance;
        vgc_ois_rec.received_to_request_variance   := ois_rec.received_to_request_variance;
        vgc_ois_rec.received_to_schedule_variance  := ois_rec.received_to_schedule_variance;
        vgc_ois_rec.received_to_ship_variance      := ois_rec.received_to_ship_variance;
        vgc_ois_rec.varbl_received_ship_variance   := ois_rec.varbl_received_ship_variance;
        vgc_ois_rec.release_to_schedule_variance   := ois_rec.release_to_schedule_variance;
        vgc_ois_rec.release_schedule_cmprsn_code   := ois_rec.release_schedule_cmprsn_code;
        vgc_ois_rec.ship_facility_cmprsn_code      := ois_rec.ship_facility_cmprsn_code;
        vgc_ois_rec.release_to_ship_variance       := ois_rec.release_to_ship_variance;
        vgc_ois_rec.order_booking_date             := ois_rec.order_booking_date;
        vgc_ois_rec.order_received_date            := ois_rec.order_received_date;
        vgc_ois_rec.order_type_id                  := ois_rec.order_type_id;
        vgc_ois_rec.regtrd_date                    := ois_rec.regtrd_date;
        vgc_ois_rec.reported_as_of_date            := ois_rec.reported_as_of_date;
        vgc_ois_rec.database_load_date             := ois_rec.database_load_date;
        vgc_ois_rec.inventory_classfcn_code        := ois_rec.inventory_classfcn_code;
        vgc_ois_rec.purchase_order_date            := ois_rec.purchase_order_date;
        vgc_ois_rec.purchase_order_nbr             := ois_rec.purchase_order_nbr;
        vgc_ois_rec.prodcn_cntlr_employee_nbr      := ois_rec.prodcn_cntlr_employee_nbr;
        -- vgc_ois_rec.part_prcmt_source_org_code     := ois_rec.part_prcmt_source_org_code;
        vgc_ois_rec.schlg_method_code              := ois_rec.schlg_method_code;
        -- vgc_ois_rec.marketing_org_code             := ois_rec.marketing_org_code;
        vgc_ois_rec.team_code                      := ois_rec.team_code;
        vgc_ois_rec.stock_make_code                := ois_rec.stock_make_code;
        vgc_ois_rec.product_code                   := ois_rec.product_code;
        vgc_ois_rec.product_line_code              := ois_rec.product_line_code;
        -- vgc_ois_rec.intrntnl_product_line_code     := ois_rec.intrntnl_product_line_code;
        -- vgc_ois_rec.product_family_code            := ois_rec.product_family_code;
        vgc_ois_rec.ww_account_nbr_base            := ois_rec.ww_account_nbr_base;
        vgc_ois_rec.ww_account_nbr_suffix          := ois_rec.ww_account_nbr_suffix;
        vgc_ois_rec.customer_forecast_code         := ois_rec.customer_forecast_code;
        vgc_ois_rec.a_territory_nbr                := ois_rec.a_territory_nbr;
        vgc_ois_rec.customer_reference_part_nbr    := ois_rec.customer_reference_part_nbr;
        vgc_ois_rec.customer_expedite_date         := ois_rec.customer_expedite_date;
        vgc_ois_rec.nbr_of_expedites               := ois_rec.nbr_of_expedites;
        vgc_ois_rec.original_expedite_date         := ois_rec.original_expedite_date;
        vgc_ois_rec.current_expedite_date          := ois_rec.current_expedite_date;
        vgc_ois_rec.earliest_expedite_date         := ois_rec.earliest_expedite_date;
        vgc_ois_rec.schedule_on_credit_hold_date   := ois_rec.schedule_on_credit_hold_date;
        vgc_ois_rec.schedule_off_credit_hold_date  := ois_rec.schedule_off_credit_hold_date;
        vgc_ois_rec.customer_credit_hold_ind       := ois_rec.customer_credit_hold_ind;
        vgc_ois_rec.customer_on_credit_hold_date   := ois_rec.customer_on_credit_hold_date;
        vgc_ois_rec.temp_hold_ind                  := ois_rec.temp_hold_ind;
        vgc_ois_rec.temp_hold_on_date              := ois_rec.temp_hold_on_date;
        vgc_ois_rec.temp_hold_off_date             := ois_rec.temp_hold_off_date;
        vgc_ois_rec.forced_bill_ind                := ois_rec.forced_bill_ind;
        vgc_ois_rec.customer_type_code             := ois_rec.customer_type_code;
        vgc_ois_rec.rush_ind                       := ois_rec.rush_ind;
        -- vgc_ois_rec.customer_busns_line_code       := ois_rec.customer_busns_line_code;
        -- vgc_ois_rec.customer_busns_line_fnctn_code := ois_rec.customer_busns_line_fnctn_code;
        -- vgc_ois_rec.industry_busns_line_code       := ois_rec.industry_busns_line_code;
        -- vgc_ois_rec.industry_busns_line_fnctn_code := ois_rec.industry_busns_line_fnctn_code;
        vgc_ois_rec.industry_code                  := ois_rec.industry_code;
        vgc_ois_rec.product_busns_line_id        := ois_rec.product_busns_line_id;
        vgc_ois_rec.product_busns_line_fnctn_id  := ois_rec.product_busns_line_fnctn_id;
        vgc_ois_rec.zero_part_prod_code            := NULL;
        vgc_ois_rec.CUSTOMER_ACCT_TYPE_CDE		     := ois_rec.CUSTOMER_ACCT_TYPE_CDE;
        -- vgc_ois_rec.trade_or_interco_code          := ois_rec.trade_or_interco_code;
        -- vgc_ois_rec.cust_rating_code               := NULL;
        -- vgc_ois_rec.mfg_div_org_code               := ois_rec.mfg_div_org_code;
        -- vgc_ois_rec.mfg_group_org_code             := ois_rec.mfg_group_org_code;
        vgc_ois_rec.mfg_campus_id                  := ois_rec.mfg_campus_id;
        vgc_ois_rec.mfg_building_nbr               := ois_rec.mfg_building_nbr;
        vgc_ois_rec.MFR_ORG_KEY_ID				   := ois_rec.MFR_ORG_KEY_ID;
        -- vgc_ois_rec.pri_ww_account_nbr_base        := ois_rec.pri_ww_account_nbr_base;
        -- vgc_ois_rec.pri_ww_account_nbr_suffix      := ois_rec.pri_ww_account_nbr_suffix;
	vgc_ois_rec.industry_business_code         := ois_rec.industry_business_code;
	vgc_ois_rec.ACCOUNTING_ORG_KEY_ID		   := ois_rec.ACCOUNTING_ORG_KEY_ID;
	vgc_ois_rec.PROFIT_CENTER_ABBR_NM		   := ois_rec.PROFIT_CENTER_ABBR_NM;
	vgc_ois_rec.SOLD_TO_CUSTOMER_ID		   	   := ois_rec.SOLD_TO_CUSTOMER_ID;
	vgc_ois_rec.PRODUCT_MANAGER_GLOBAL_ID	   := ois_rec.PRODUCT_MANAGER_GLOBAL_ID;
	vgc_ois_rec.SALES_OFFICE_CDE			   := ois_rec.SALES_OFFICE_CDE;
	vgc_ois_rec.SALES_GROUP_CDE				   := ois_rec.SALES_GROUP_CDE;
	vgc_ois_rec.DATA_SOURCE_DESC			   := ois_rec.DATA_SOURCE_DESC;
	vgc_ois_rec.PICK_PACK_WORK_DAYS_QTY        := ois_rec.PICK_PACK_WORK_DAYS_QTY;
	vgc_ois_rec.MRP_GROUP_CDE			  	   := ois_rec.MRP_GROUP_CDE;

        /*
        -- Deleted on 05/10/2012
        vgc_ois_rec.schedule_on_customer_dock_date := ois_rec.schedule_on_customer_dock_date;
        vgc_ois_rec.actual_on_customer_dock_date   := ois_rec.actual_on_customer_dock_date;
        vgc_ois_rec.customer_revised_schedule_date := ois_rec.customer_revised_schedule_date;
        vgc_ois_rec.special_packaging_code         := ois_rec.special_packaging_code;
        */

        IF vic_backout = 'Y' THEN
            p_3000_backout_summaries;
            IF vgn_sql_rc <> 0 THEN
              DBMS_OUTPUT.PUT_LINE('>>>>>>>>>vgn_sql_rc>:  ' || vgn_sql_rc);
              RAISE ue_fatal_db_err;
            END IF;
            vgn_row_proc_backout_cnt := vgn_row_proc_backout_cnt + 1;
        END IF;

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
          ROLLBACK;
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
		  DBMS_OUTPUT.PUT_LINE('*       AMP_ORDER_NBR:  ' || vgc_ois_rec.AMP_ORDER_NBR);
		  DBMS_OUTPUT.PUT_LINE('*      ORDER_ITEM_NBR:  ' || vgc_ois_rec.ORDER_ITEM_NBR);
		  DBMS_OUTPUT.PUT_LINE('*         SHIPMENT_ID:  ' || vgc_ois_rec.SHIPMENT_ID);
		  DBMS_OUTPUT.PUT_LINE('* ORGANIZATION_KEY_ID:  ' || vgc_ois_rec.ORGANIZATION_KEY_ID);
          von_sql_rc := vgn_sql_rc;
        WHEN OTHERS THEN
          ROLLBACK;
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
		  DBMS_OUTPUT.PUT_LINE('*       AMP_ORDER_NBR:  ' || vgc_ois_rec.AMP_ORDER_NBR);
		  DBMS_OUTPUT.PUT_LINE('*      ORDER_ITEM_NBR:  ' || vgc_ois_rec.ORDER_ITEM_NBR);
		  DBMS_OUTPUT.PUT_LINE('*         SHIPMENT_ID:  ' || vgc_ois_rec.SHIPMENT_ID);
		  DBMS_OUTPUT.PUT_LINE('* ORGANIZATION_KEY_ID:  ' || vgc_ois_rec.ORGANIZATION_KEY_ID);
          von_sql_rc := vgn_sql_rc;

    END P_non_variance_Dscd_Fix;
/
