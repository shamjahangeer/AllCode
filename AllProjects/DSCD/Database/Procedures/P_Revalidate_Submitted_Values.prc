CREATE OR REPLACE PROCEDURE P_Revalidate_Submitted_Values IS
/*************************************************************************
* Procedure:   p_revalidate_submitted_values
* Description: This stored pocedure is used to revalidate submitted values
*              which were replaced with default value when it was not found
*			   in lookup table during first process. If at this time it is
*			   found then default value is replaced with submitted value
*			   and readjustment on summary tables is effected.
*-------------------------------------------------------------------------
* Revisions Log:
* 1.0   10/13/2000  A. Orbeta   Original Version
* 1.1   01/11/2001 Alex/Faisal  Changed product_busns_line_code to
*                               product_busns_line_id & product_busns_line_fnctn_code
*								to product_busns_line_fnctn_id & the logic
*								to derive the busns_ids instead of code.
* 1.2    02/11/2001 Faisal      Added a new field PROFIT_CENTER_ABBR_NM & logic
*                               in order to derive profit center abbreviation name.
* 1.3    04/2001    M. Gonzales Modified to accomodate table changes from OrgCodes
                                to Org Key Id
* 1.4	 10/2001	A. Orbeta	Remove the use for update logic in cursor.
* 1.5	 04/17/2002 A. Orbeta	Changed logic in getting lowest CBC & addjust_smry.
* 1.6	 06/18/2002 A. Orbeta	Added new column PRODUCT_MANAGER_GLOBAL_ID.
* 1.7	 10/03/2002 A. Orbeta	Modified logic to include branded_amp_parts xref.
* 1.8	 11/19/2002 A. Orbeta	Add SALES_ & SYSTEM_SOURCE_ID columns.
* 1.9	 05/20/2003 A. Orbeta	Add revalidation of Customer & restatement of
  		 			   			WWAN.   					
* 1.10	 11/18/2003 A. Orbeta	Removed reference to GBL_US_TERRITORY_ASSIGNMENT
  		 			   			specific for 0048 territory code derivation. Also,
								remove reference to obseleted Raychem _XREF table. 								
* 05/10/2004  A. Orbeta			Use hierarchy_cust to derive WWAN instead of sold-to.	
* 12/14/2004  	 				Alpha Part project.
* 01/11/2006					Remove PART_NBR column.			
* 06/16/2006				    Add MRP_Group_Cde param - Filter enhancement - phase III.				
* 10/18/2007                    Add logic for data security.
--11/02/2009               Add SAP profit center.
--12/03/2010               Add GAM in data security.
***********************************************************************************/

vln_cnt				 NUMBER(10) := 0;
vln_max_cnt			 NUMBER := 1000;
ois_rec				 ORDER_ITEM_SHIPMENT%ROWTYPE;
tois_rec           TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
ois_security_rec   ORDER_ITEM_SHIP_DATA_SECURITY%ROWTYPE;
vlc_section			 VARCHAR2(100);
vgn_result			 NUMBER := 0;
vgc_busln_fnctn_id	 GBL_PRODUCT.PROD_BUSLN_FNCTN_ID%TYPE;
vgc_profit_center_abbr_nm ORDER_ITEM_SHIPMENT.PROFIT_CENTER_ABBR_NM%TYPE;
vgc_SAP_profit_center_cde ORDER_ITEM_SHIPMENT.SAP_PROFIT_CENTER_CDE%TYPE;
ue_critical_db_error EXCEPTION;


PROCEDURE p_adjust_summaries (vlc_expr IN NUMBER) IS
  vln_smrys_inserted NUMBER;
  vln_smrys_updated	 NUMBER;
  vln_smrys_deleted	 NUMBER;
BEGIN
  vlc_section := 'p_adjust_summaries';
  Pkg_Adjust_Summaries.p_adjust_summaries(
                       ois_rec.DML_ORACLE_ID,
                       ois_rec.AMP_SHIPPED_DATE,
					   ois_rec.ORGANIZATION_KEY_ID,
                       ois_rec.TEAM_CODE,
                       ois_rec.PRODCN_CNTRLR_CODE,
					   ois_rec.CONTROLLER_UNIQUENESS_ID,
                       ois_rec.STOCK_MAKE_CODE,
					   ois_rec.PRODUCT_LINE_CODE,
                       ois_rec.PRODUCT_CODE,
                       ois_rec.PRODCN_CNTLR_EMPLOYEE_NBR,
                       ois_rec.A_TERRITORY_NBR,
                       ois_rec.ACTUAL_SHIP_BUILDING_NBR,
                       ois_rec.ACTUAL_SHIP_LOCATION,
                       ois_rec.PURCHASE_BY_ACCOUNT_BASE,
                       ois_rec.SHIP_TO_ACCOUNT_SUFFIX,
                       ois_rec.WW_ACCOUNT_NBR_BASE,
                       ois_rec.WW_ACCOUNT_NBR_SUFFIX,
                       ois_rec.CUSTOMER_TYPE_CODE,
                       ois_rec.SHIP_FACILITY_CMPRSN_CODE,
                       ois_rec.RELEASE_TO_SHIP_VARIANCE,
                       ois_rec.SCHEDULE_TO_SHIP_VARIANCE,
                       ois_rec.VARBL_SCHEDULE_SHIP_VARIANCE,
                       ois_rec.REQUEST_TO_SHIP_VARIANCE,
                       ois_rec.VARBL_REQUEST_SHIP_VARIANCE,
                       ois_rec.REQUEST_TO_SCHEDULE_VARIANCE,
					   ois_rec.CUSTOMER_ACCT_TYPE_CDE,
                       ois_rec.INDUSTRY_CODE,
					   ois_rec.MFR_ORG_KEY_ID,
                       ois_rec.MFG_CAMPUS_ID,
                       ois_rec.MFG_BUILDING_NBR,
  			   		   ois_rec.INDUSTRY_BUSINESS_CODE,
					   ois_rec.ACCOUNTING_ORG_KEY_ID,
					   ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID,
					   ois_rec.PROFIT_CENTER_ABBR_NM,
					   ois_rec.SOLD_TO_CUSTOMER_ID,
					   ois_rec.PRODUCT_BUSNS_LINE_ID,
					   ois_rec.PRODUCT_MANAGER_GLOBAL_ID,
					   ois_rec.SALES_OFFICE_CDE,
					   ois_rec.SALES_GROUP_CDE,
					   Scdcommonbatch.GETSOURCESYSTEMID(ois_rec.DATA_SOURCE_DESC),
					   ois_rec.MRP_GROUP_CDE,
                       vlc_expr,
                       vln_smrys_inserted,
                       vln_smrys_updated,
                       vln_smrys_deleted,
                       vgn_result);
END;

PROCEDURE p_get_profit_center_abbr_nm IS
BEGIN
  vlc_section := 'Get Profit Ctr';

  SELECT MGE_PROFIT_CENTER_ABBR_NM
        ,SAP_PROFIT_CENTER_CDE
  INTO   vgc_profit_center_abbr_nm
        ,vgc_SAP_profit_center_cde
  FROM   GBL_MGE_PROFIT_CENTERS gmpc,
         GBL_MGE_PROFIT_CENTER_RELS gmpcr
  WHERE  gmpc.MGE_PROFIT_CENTER_ID  = gmpcr.MGE_PROFIT_CENTER_ID
    AND  gmpcr.ORGANIZATION_ID = (SELECT COMPANY_ORGANIZATION_ID
	                              FROM organizations_dmn
								  WHERE organization_key_id = ois_rec.ORGANIZATION_KEY_ID
								  AND record_status_cde = 'C')
  AND    INDUSTRY_BUSINESS_CDE 	 = ois_rec.INDUSTRY_BUSINESS_CODE
  AND    COMPETENCY_BUSINESS_CDE = vgc_busln_fnctn_id;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    vgc_profit_center_abbr_nm := NULL;
    vgc_SAP_profit_center_cde := NULL;
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
	WHERE  PURCHASE_BY_ACCOUNT_BASE = ois_rec.PURCHASE_BY_ACCOUNT_BASE 
	AND    SHIP_TO_ACCOUNT_SUFFIX 	= ois_rec.SHIP_TO_ACCOUNT_SUFFIX 
	AND	   ACCOUNTING_ORG_KEY_ID 	= ois_rec.ACCOUNTING_ORG_KEY_ID				
    AND    WW_ACCOUNT_NBR_BASE 		= ois_rec.WW_ACCOUNT_NBR_BASE
	AND    WW_ACCOUNT_NBR_SUFFIX 	= ois_rec.WW_ACCOUNT_NBR_SUFFIX 
	AND    NBR_WINDOW_DAYS_EARLY 	= NVL(ois_rec.NBR_WINDOW_DAYS_EARLY,0) 
	AND    NBR_WINDOW_DAYS_LATE 	= NVL(ois_rec.NBR_WINDOW_DAYS_LATE,0)
	;
	
	IF ois_rec.AMP_SHIPPED_DATE > v_amp_ship_date THEN
	  vlc_section := 'Update ww_acct_xref';
	  UPDATE SCORECARD_CUSTOMER_WW_XREF
	  SET	 AMP_SHIPPED_DATE =	ois_rec.AMP_SHIPPED_DATE
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
           (ois_rec.WW_ACCOUNT_NBR_BASE
           ,ois_rec.WW_ACCOUNT_NBR_SUFFIX
           ,ois_rec.PURCHASE_BY_ACCOUNT_BASE
           ,ois_rec.SHIP_TO_ACCOUNT_SUFFIX
           ,NVL(ois_rec.NBR_WINDOW_DAYS_EARLY,0)
           ,NVL(ois_rec.NBR_WINDOW_DAYS_LATE,0)
           ,ois_rec.DML_ORACLE_ID
           ,SYSDATE
           ,ois_rec.AMP_SHIPPED_DATE
		   ,ois_rec.ACCOUNTING_ORG_KEY_ID
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


PROCEDURE p_revalidate_parts IS

vlc_product_code	 		 ORDER_ITEM_SHIPMENT.PRODUCT_CODE%TYPE;
vlc_product_line	 		 ORDER_ITEM_SHIPMENT.PRODUCT_LINE_CODE%TYPE;
vlc_busln_id		 		 GBL_PRODUCT.PROD_BUSLN_ID%TYPE;
vlc_prod_busns_line_fnctn_id ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_FNCTN_ID%TYPE;
vlc_io_status 	 			 VARCHAR2(20);
vln_io_sqlcode	 			 NUMBER;
vlc_io_sqlerrm	 			 VARCHAR2(260);
vlc_171_part				 ORDER_ITEM_SHIPMENT.SBMT_PART_NBR%TYPE;

CURSOR part_cur IS
SELECT *
FROM   ORDER_ITEM_SHIPMENT a
WHERE  a.PART_KEY_ID = scdCommonBatch.gZeroPartKeyID 
AND    a.PRODUCT_CODE = '9964' AND a.SBMT_PART_NBR != scdCommonBatch.gZero711PartNbr
AND   (EXISTS (SELECT 1 FROM  CORPORATE_PARTS b
	  		  		    -- SAP parts
	   				  	WHERE (a.BRAND_ID = 975
							   AND b.TYCO_ELECTRONICS_CORP_PART_NBR = a.SBMT_PART_NBR)
						-- AMP parts and numeric only 
					  	OR    (a.BRAND_ID = 1 AND RTRIM(a.SBMT_PART_NBR,'0123456789') IS NULL AND
							   b.PART_KEY_ID = (SELECT c.PART_KEY_ID
        			  				   	  	    FROM   CORPORATE_PART_ALIASES c
       									  	    WHERE  ACQUIRED_FORMAT_ID = a.BRAND_ID
												AND	   BUSINESS_ID_TYPE_CDE = '0'
         								  	    AND    c.PART_NBR = convert_to_std_171(a.SBMT_PART_NBR)												
											   )
							  ) 
						-- not SAP and not AMP
					  	OR    (a.BRAND_ID != 1 AND a.BRAND_ID != 975
							   AND b.PART_KEY_ID = (SELECT c.PART_KEY_ID
        			  				   	  	        FROM   CORPORATE_PART_ALIASES c
												    WHERE  BUSINESS_ID_TYPE_CDE = '0'
       									  	        AND   ((ACQUIRED_FORMAT_ID = a.BRAND_ID
         								  	     	       AND c.PART_NBR = a.SBMT_PART_NBR
														  ) -- submmitted part is asummed as not 711
														  OR
       									  	     		   (ACQUIRED_FORMAT_ID = 1
												 		    AND RTRIM(a.SBMT_PART_NBR,'0123456789') IS NULL
         								  	     		    AND c.PART_NBR = convert_to_std_171(a.SBMT_PART_NBR)
											    		   ) -- submmitted part is asummed as 711 and numeric only
							   						      )
													AND ROWNUM <= 1
												   )												
							  )						   
		  	  )
	  ) 	  
;

BEGIN
  vlc_section := 'Process SBMT_PART_NBR';
  vln_cnt	  := 0;

  FOR part_rec IN part_cur LOOP
     ois_rec := part_rec;
	 
	 -- derive product code
	 BEGIN
    	vlc_section := 'Derive PROD CODE';
		SELECT PART_KEY_ID,NVL(PRODUCT_CDE,'9964')
    	INTO   ois_rec.PART_KEY_ID,vlc_product_code 
		FROM   CORPORATE_PARTS b
			   -- SAP parts
		WHERE (ois_rec.BRAND_ID = 975
			   AND b.TYCO_ELECTRONICS_CORP_PART_NBR = ois_rec.SBMT_PART_NBR)			   
           	  -- AMP parts and numeric only  
           OR (ois_rec.BRAND_ID = 1 AND RTRIM(ois_rec.SBMT_PART_NBR,'0123456789') IS NULL AND
           	   b.PART_KEY_ID = (SELECT c.PART_KEY_ID
             		   	  	    FROM   CORPORATE_PART_ALIASES c
            			  	    WHERE  ACQUIRED_FORMAT_ID = ois_rec.BRAND_ID
								AND	   BUSINESS_ID_TYPE_CDE = '0'
              			  	    AND    c.PART_NBR = convert_to_std_171(ois_rec.SBMT_PART_NBR)
           					   )
           	  ) 
           	  -- not SAP and not AMP
           OR (ois_rec.BRAND_ID != 1 AND ois_rec.BRAND_ID != 975
			   AND b.PART_KEY_ID = (SELECT c.PART_KEY_ID
    			  				   	FROM   CORPORATE_PART_ALIASES c
								    WHERE  BUSINESS_ID_TYPE_CDE = '0'
   									AND   ((ACQUIRED_FORMAT_ID = ois_rec.BRAND_ID
     								        AND c.PART_NBR = ois_rec.SBMT_PART_NBR
										   ) -- submmitted part is asummed as not 711
										  OR
   									  	   (ACQUIRED_FORMAT_ID = 1
								 		    AND RTRIM(ois_rec.SBMT_PART_NBR,'0123456789') IS NULL
     								  	    AND c.PART_NBR = convert_to_std_171(ois_rec.SBMT_PART_NBR)
							    		   ) -- submmitted part is asummed as 711 and numeric only
			   						      )
									AND ROWNUM <= 1
								   )												
			  )
		;
	 EXCEPTION
	 	WHEN NO_DATA_FOUND THEN
--		   ois_rec.PART_KEY_ID := scdCommonBatch.gZeroPartKeyID;
--		   vlc_product_code := '9964';		   
		   GOTO next_rec;
		WHEN OTHERS THEN
		   RAISE ue_critical_db_error;
	 END;
	 
	 BEGIN
	 	vlc_section := 'Derive PROD LINE';
	 	SELECT NVL(PROD_GLOBAL_PRLN_CODE,'350'),PROD_BUSLN_FNCTN_ID,
			   PROD_BUSLN_ID
	 	INTO   vlc_product_line,vgc_busln_fnctn_id,
			   vlc_busln_id
	 	FROM   GBL_PRODUCT
	 	WHERE  PROD_CODE = vlc_product_code;
	 EXCEPTION
	 	WHEN NO_DATA_FOUND THEN
		   vlc_product_line := '350';
		   vgc_busln_fnctn_id := NULL;
		   vlc_busln_id := NULL;
		WHEN OTHERS THEN
		   RAISE ue_critical_db_error;
	 END;

	 p_get_profit_center_abbr_nm;
     IF vgn_result <> 0 THEN
    	RAISE ue_critical_db_error;
     END IF;
    ois_rec.SAP_PROFIT_CENTER_CDE := vgc_SAP_profit_center_cde;

	 vlc_busln_id := NVL(vlc_busln_id,'*');
	 vlc_prod_busns_line_fnctn_id := NVL(vgc_busln_fnctn_id,'*');
	 vgc_profit_center_abbr_nm	  := NVL(vgc_profit_center_abbr_nm,'*');

	 IF ois_rec.PRODUCT_LINE_CODE <> vlc_product_line OR
	 	ois_rec.PRODUCT_CODE <> vlc_product_code OR
		ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID <> vlc_prod_busns_line_fnctn_id OR
		ois_rec.PRODUCT_BUSNS_LINE_ID <> vlc_busln_id OR
		ois_rec.PROFIT_CENTER_ABBR_NM <> vgc_profit_center_abbr_nm THEN

    	-- subtract 1 in summary tables
      	p_adjust_summaries(-1);
    	IF vgn_result <> 0 THEN
    	   RAISE ue_critical_db_error;
    	END IF;

		ois_rec.PRODUCT_LINE_CODE := vlc_product_line;
	 	ois_rec.PRODUCT_CODE := vlc_product_code;
		ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID	:= vlc_prod_busns_line_fnctn_id;
		ois_rec.PROFIT_CENTER_ABBR_NM       := vgc_profit_center_abbr_nm;
		ois_rec.PRODUCT_BUSNS_LINE_ID := vlc_busln_id;

    	-- add 1 in summary tables
      	p_adjust_summaries(1);
    	IF vgn_result <> 0 THEN
    	   RAISE ue_critical_db_error;
    	END IF;
	 END IF;
   
    -- derive security values
    tois_rec.ORIG_CBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_cbc_pc_id(ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID);
    tois_rec.ORIG_CBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(tois_rec.ORIG_CBC_PROFIT_CENTER_ID);
  
    tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(tois_rec.PROFIT_CENTER_ABBR_NM); 

    -- get IBC, RPTORG, SLS TERR DSG IDs, GAM
    BEGIN
      vlc_section := 'Get DSG ID FROM OIS SECURITY';
      SELECT CUR_IBC_DATA_SECR_GRP_ID
            ,CUR_REPT_PRFT_DATA_SECR_GRP_ID
            ,CUR_SLS_TERR_DATA_SECR_GRP_ID
            ,CUR_GAM_DATA_SECR_GRP_ID
      INTO   ois_security_rec.CUR_IBC_DATA_SECR_GRP_ID
            ,ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
            ,ois_security_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID
            ,ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID
      FROM   ORDER_ITEM_SHIP_DATA_SECURITY
      WHERE  AMP_ORDER_NBR       = ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	       = ois_rec.SHIPMENT_ID
      AND	 ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         ois_security_rec.CUR_IBC_DATA_SECR_GRP_ID := NULL;
         ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID := NULL;
         ois_security_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID := NULL;     
         ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID := NULL; 
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));
         RAISE ue_critical_db_error;
    END;

    tois_rec.ORIG_DATA_SECURITY_TAG_ID := get_data_security_tag1(ois_security_rec.CUR_IBC_DATA_SECR_GRP_ID
                                                                ,ois_security_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID  
                                                                ,tois_rec.ORIG_CBC_DATA_SECR_GRP_ID
                                                                ,ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
                                                                ,tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
                                                                ,ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID
                                                                );
                                                        
    tois_rec.CUR_DATA_SECURITY_TAG_ID := tois_rec.ORIG_DATA_SECURITY_TAG_ID;
    tois_rec.SUPER_DATA_SECURITY_TAG_ID := tois_rec.ORIG_DATA_SECURITY_TAG_ID;  

    -- update security table
    BEGIN
    	vlc_section := 'Update PART related fields in OIS SECURITY';    
      UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
      SET    DML_TS = SYSDATE
            ,PART_KEY_ID                    = ois_rec.PART_KEY_ID
            ,ORIG_PRODUCT_CDE               = ois_rec.PRODUCT_CODE
            ,ORIG_COMPETENCY_BUSINESS_CDE   = ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID
            ,ORIG_CBC_PROFIT_CENTER_ID      = tois_rec.ORIG_CBC_PROFIT_CENTER_ID
            ,ORIG_CBC_DATA_SECR_GRP_ID      = tois_rec.ORIG_CBC_DATA_SECR_GRP_ID 
            ,CUR_PRODUCT_CDE                = ois_rec.PRODUCT_CODE
            ,CUR_COMPETENCY_BUSINESS_CDE    = ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID
            ,CUR_CBC_PROFIT_CENTER_ID       = tois_rec.ORIG_CBC_PROFIT_CENTER_ID
            ,CUR_CBC_DATA_SECR_GRP_ID       = tois_rec.ORIG_CBC_DATA_SECR_GRP_ID 
            ,ORIG_MANAGEMENT_PROFIT_CTR_ID  = ois_rec.PROFIT_CENTER_ABBR_NM
            ,ORIG_MGE_PRFT_DATA_SECR_GRP_ID = tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,CUR_MGE_PROFIT_CTR_ID          = ois_rec.PROFIT_CENTER_ABBR_NM
            ,CUR_MGE_PRFT_DATA_SECR_GRP_ID  = tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,ORIG_DATA_SECURITY_TAG_ID      = tois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,CUR_DATA_SECURITY_TAG_ID       = tois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,SUPER_DATA_SECURITY_TAG_ID     = tois_rec.ORIG_DATA_SECURITY_TAG_ID
      WHERE  AMP_ORDER_NBR       = ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	       = ois_rec.SHIPMENT_ID
      AND	 ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         NULL;
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));
         RAISE ue_critical_db_error;
    END;   

	 BEGIN
    	vlc_section := 'Update PART_NBR in OIS';
    	UPDATE ORDER_ITEM_SHIPMENT
		SET	   DML_TMSTMP 						= SYSDATE
			   ,PART_KEY_ID 		  		   	= ois_rec.PART_KEY_ID			   
			   ,PRODUCT_LINE_CODE 		        = ois_rec.PRODUCT_LINE_CODE
			   ,PRODUCT_CODE 					= ois_rec.PRODUCT_CODE
			   ,PRODUCT_BUSNS_LINE_ID		  	= ois_rec.PRODUCT_BUSNS_LINE_ID
			   ,PRODUCT_BUSNS_LINE_FNCTN_ID 	= ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID
			   ,PROFIT_CENTER_ABBR_NM           = ois_rec.PROFIT_CENTER_ABBR_NM
         ,SUPER_DATA_SECURITY_TAG_ID     = tois_rec.ORIG_DATA_SECURITY_TAG_ID         
         ,SAP_PROFIT_CENTER_CDE          = ois_rec.SAP_PROFIT_CENTER_CDE
--    	WHERE CURRENT OF part_cur
    	WHERE AMP_ORDER_NBR		  = ois_rec.AMP_ORDER_NBR
		AND   ORDER_ITEM_NBR	  = ois_rec.ORDER_ITEM_NBR
		AND   SHIPMENT_ID		  = ois_rec.SHIPMENT_ID
		AND	ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
		;
	 EXCEPTION
		WHEN OTHERS THEN
		   RAISE ue_critical_db_error;
	 END;

  	 vlc_section := 'Process SBMT_PART_NBR';
 	 vln_cnt := vln_cnt + 1;
 	 IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
       	COMMIT;
  	 END IF;

	 <<next_rec>>
	 NULL;
  END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Submitted PART_NBR revalidated/found: ' || vln_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
	DBMS_OUTPUT.PUT_LINE('ORGANIZATION_KEY_ID:'||ois_rec.ORGANIZATION_KEY_ID) ;
	DBMS_OUTPUT.PUT_LINE('AMP_ORDER_NBR	     :'||ois_rec.AMP_ORDER_NBR) ;
	DBMS_OUTPUT.PUT_LINE('ORDER_ITEM_NBR	 :'||ois_rec.ORDER_ITEM_NBR) ;
	DBMS_OUTPUT.PUT_LINE('SHIPMENT_ID		 :'||ois_rec.SHIPMENT_ID) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
END ;


PROCEDURE p_revalidate_customer IS

vlc_formatted_shipto		  ORDER_ITEM_SHIPMENT.SBMT_CUSTOMER_ACCT_NBR%TYPE;
vlc_shipto_org_id			  ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_ORG_ID%TYPE;
vlc_formatted_soldto		  ORDER_ITEM_SHIPMENT.SBMT_CUSTOMER_ACCT_NBR%TYPE;
vlc_industry_code		  	  ORDER_ITEM_SHIPMENT.INDUSTRY_CODE%TYPE;
vln_count 					  NUMBER(3);
vlb_shipto_exist			  BOOLEAN;
vlb_soldto_exist			  BOOLEAN;
vlb_hier_cust_exist			  BOOLEAN;
vln_data_src_id				  COSTED_ADR43_SUBMISSIONS.DATA_SOURCE_ID%TYPE;
vlc_sap_cust_restatement_ind  COSTED_ADR43_SUBMISSIONS.SAP_CUST_RESTATEMENT_IND%TYPE;	
vlc_rpt_org_id 		  		  ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_ORG_ID%TYPE;
vlc_hier_cust_org_id 		  ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_ORG_ID%TYPE;
vlc_hier_cust_base_id 		  ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_BASE_ID%TYPE;
vlc_hier_cust_sufx_id 		  ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_SUFX_ID%TYPE;  
vlc_ww_accnt_nbr			  GBL_CUSTOMER_PURCHASED_BY.PB_WW_CSTMR_ACCT_NBR%TYPE;
vlc_busln_id		 		  GBL_PRODUCT.PROD_BUSLN_ID%TYPE;
k_territory_assign_type_cde	  CONSTANT VARCHAR2(1) := 'A';

CURSOR cust_accnt_cur IS
  SELECT *
  FROM   ORDER_ITEM_SHIPMENT
  WHERE	((SOLD_TO_CUSTOMER_ID IN ('99999999','66666601') AND SBMT_SOLD_TO_CUSTOMER_ID IS NOT NULL) 
  OR     ( ( (PURCHASE_BY_ACCOUNT_BASE = '66666601' AND SHIP_TO_ACCOUNT_SUFFIX = '01')
	         OR (PURCHASE_BY_ACCOUNT_BASE = '99999999' AND SHIP_TO_ACCOUNT_SUFFIX IN ('00','99'))
		  ) AND SBMT_CUSTOMER_ACCT_NBR IS NOT NULL
	    ))	          
;
			  
BEGIN
  vlc_section := 'Process SBMT_CUSTOMER_ACCT_NBR';
  vln_cnt	  := 0;

  FOR cust_accnt_rec IN cust_accnt_cur LOOP
     ois_rec := cust_accnt_rec;

	 vlc_formatted_shipto := NULL;
 	 vlc_formatted_soldto := NULL;
	 
	 IF ois_rec.DATA_SOURCE_DESC = 'RYCADR313' THEN 
	 	vlc_formatted_shipto := '00' || ois_rec.SBMT_CUSTOMER_ACCT_NBR || '00';
	 	vlc_formatted_soldto := '00' || NVL(ois_rec.SBMT_SOLD_TO_CUSTOMER_ID,ois_rec.SBMT_CUSTOMER_ACCT_NBR);
       	IF NOT Scdcommonbatch.GetOrgIDV4(ois_rec.accounting_org_key_id,
       	 						   	  	 ois_rec.amp_shipped_date,
     							      	 vlc_hier_cust_org_id) THEN
     	  GOTO next_rec;
     	END IF;		
        vlc_hier_cust_base_id := SUBSTR(vlc_formatted_shipto,1,8);
	    vlc_hier_cust_sufx_id := SUBSTR(vlc_formatted_shipto,9,2);
		 
	 ELSIF ois_rec.DATA_SOURCE_DESC = 'TYCOADR13' THEN
	 	vlc_formatted_shipto := ois_rec.SBMT_CUSTOMER_ACCT_NBR;
	 	vlc_formatted_soldto := NVL(ois_rec.SBMT_SOLD_TO_CUSTOMER_ID,SUBSTR(ois_rec.SBMT_CUSTOMER_ACCT_NBR,1,8));		
       	IF NOT Scdcommonbatch.GetOrgIDV4(ois_rec.accounting_org_key_id,
       	 						   	  	 ois_rec.amp_shipped_date,
     							      	 vlc_hier_cust_org_id) THEN
     	  GOTO next_rec;
     	END IF;  
        vlc_hier_cust_base_id := SUBSTR(vlc_formatted_shipto,1,8);
	    vlc_hier_cust_sufx_id := SUBSTR(vlc_formatted_shipto,9,2); 		

	 ELSE -- format submitted ACCNT_NBR
	 	-- get data_source
		BEGIN
		  SELECT TO_NUMBER(SUBSTR(ois_rec.DML_ORACLE_ID,5,LENGTH(RTRIM(ois_rec.DML_ORACLE_ID))-6))
		  INTO	 vln_data_src_id
		  FROM	 DUAL;
		EXCEPTION
		  WHEN INVALID_NUMBER THEN
  		  	GOTO next_rec;		
		  WHEN OTHERS THEN
  	        DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));		  
    	  	RAISE ue_critical_db_error;
		END;	 	

		-- get reporting org id
       	IF NOT Scdcommonbatch.GetOrgIDV4(ois_rec.organization_key_id,
       	 						   	  	 ois_rec.amp_shipped_date,
     							      	 vlc_rpt_org_id) THEN
     	  GOTO next_rec;
     	END IF;		
		
	 	vlc_sap_cust_restatement_ind := 0;
		-- Determine the SAP customer restatement ind
		BEGIN 
		  vlc_section := 'In COSTED_ADR43_SUBMISSIONS table';	
		  SELECT sap_cust_restatement_ind
  		  INTO   vlc_sap_cust_restatement_ind
  		  FROM   COSTED_ADR43_SUBMISSIONS 
  		  WHERE  data_source_id = vln_data_src_id
		  AND	 REPORTING_ORGANIZATION_ID = vlc_rpt_org_id
  		  AND    EXPIRATION_DT IS NULL;
    	EXCEPTION
    	  WHEN NO_DATA_FOUND THEN
    	 	vlc_sap_cust_restatement_ind := 0;
    	  WHEN OTHERS THEN
  	        DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));		  
    	  	RAISE ue_critical_db_error;
    	END;

		IF vlc_sap_cust_restatement_ind = 1 THEN 		
		   vlc_formatted_shipto := LPAD(SUBSTR('00000000'||ois_rec.SBMT_CUSTOMER_ACCT_NBR, -8), 8, '0') || '00';
		   vlc_formatted_soldto := LPAD(SUBSTR('00000000'||ois_rec.SBMT_SOLD_TO_CUSTOMER_ID, -8), 8, '0');		   
		ELSE
		   vlc_formatted_shipto := LPAD(SUBSTR(ois_rec.SBMT_CUSTOMER_ACCT_NBR, 1, 8), 8, '0')
		   						   || RPAD(NVL(SUBSTR(ois_rec.SBMT_CUSTOMER_ACCT_NBR, 9, 2), '0'), 2, '0');
		   vlc_formatted_soldto := LPAD(SUBSTR(ois_rec.SBMT_SOLD_TO_CUSTOMER_ID, 1, 8), 8, '0');								   
	    END IF;

		IF ois_rec.HIERARCHY_CUSTOMER_IND = 1 THEN 
  		  vlc_hier_cust_org_id  := ois_rec.HIERARCHY_CUSTOMER_ORG_ID;
		  vlc_hier_cust_base_id := SUBSTR(vlc_formatted_soldto,1,8);
	      vlc_hier_cust_sufx_id := '00';
		ELSE
          IF NOT Scdcommonbatch.GetOrgIDV4(ois_rec.accounting_org_key_id,
       	 						   	  	 ois_rec.amp_shipped_date,
     							      	 vlc_hier_cust_org_id) THEN
     	    GOTO next_rec;
		  END IF;
          vlc_hier_cust_base_id := SUBSTR(vlc_formatted_shipto,1,8);
	      vlc_hier_cust_sufx_id := SUBSTR(vlc_formatted_shipto,9,2);		  
     	END IF;  
		
	 END IF;		
	 
	 -- validate hierarchy cust
	 vlb_hier_cust_exist := FALSE;
	 vlc_industry_code := NULL;
	 IF ((ois_rec.PURCHASE_BY_ACCOUNT_BASE = '66666601' AND ois_rec.SHIP_TO_ACCOUNT_SUFFIX = '01')
	      OR (ois_rec.PURCHASE_BY_ACCOUNT_BASE = '99999999' AND ois_rec.SHIP_TO_ACCOUNT_SUFFIX IN ('00','99')))
		OR 
		(ois_rec.SOLD_TO_CUSTOMER_ID IN ('99999999','66666601')
		  AND ois_rec.HIERARCHY_CUSTOMER_IND = 1)
 	   THEN	  
  	   BEGIN
  	     vlc_section := 'In GBL_CUSTOMER_SHIP_TO table - 1';
         SELECT NVL(ST_INDUSTRY_CODE,'*')	
  	     INTO	vlc_industry_code	    
         FROM   GBL_CUSTOMER_SHIP_TO b 
         WHERE  b.ST_ACCT_ORG_ID   = vlc_hier_cust_org_id 
         AND    b.ST_ACCT_NBR_BASE = vlc_hier_cust_base_id
  	     AND	b.ST_ACCT_NBR_SUFX = vlc_hier_cust_sufx_id;
  	     vlb_hier_cust_exist := TRUE; 
  	   EXCEPTION
  	     WHEN NO_DATA_FOUND THEN
  	   	   NULL;
  	     WHEN OTHERS THEN
  	       DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));
  	   	   RAISE ue_critical_db_error;
  	   END;
	 END IF; 	 

	 -- validate soldto cust
	 vlb_soldto_exist := FALSE;
	 IF ois_rec.SOLD_TO_CUSTOMER_ID IN ('99999999','66666601') THEN	
       BEGIN
    	 vlc_section := 'In GBL_CUSTOMER_PURCHASED_BY table';
	     vln_count := 0;
         SELECT COUNT(*)	
	     INTO	vln_count	    
         FROM   GBL_CUSTOMER_PURCHASED_BY b 
         WHERE  b.PB_ACCT_ORG_ID   = vlc_hier_cust_org_id 
         AND    b.PB_ACCT_NBR_BASE = vlc_hier_cust_base_id;

		 IF vln_count > 0 THEN
	 	 	vlb_soldto_exist := TRUE;
		 END IF;					 
       EXCEPTION
    	 WHEN NO_DATA_FOUND THEN
	   	   NULL;
    	 WHEN OTHERS THEN
	       DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;		 
    	   RAISE ue_critical_db_error;
       END;
	 END IF;	 	 
	 
	 -- validate shipto cust
	 vlb_shipto_exist := FALSE;
	 IF ois_rec.HIERARCHY_CUSTOMER_IND = 1 THEN
       IF NOT Scdcommonbatch.GetOrgIDV4(ois_rec.accounting_org_key_id,
        						   	  	ois_rec.amp_shipped_date,
     							      	vlc_shipto_org_id) THEN
     	 NULL;
	   END IF;

	   BEGIN
	     vlc_section := 'In GBL_CUSTOMER_SHIP_TO table - 2';
	     vln_count := 0;
         SELECT COUNT(*)	
	     INTO	vln_count	    
         FROM   GBL_CUSTOMER_SHIP_TO b 
         WHERE  b.ST_ACCT_ORG_ID   = vlc_shipto_org_id
         AND    b.ST_ACCT_NBR_BASE = SUBSTR(vlc_formatted_shipto,1,8)
	     AND	b.ST_ACCT_NBR_SUFX = SUBSTR(vlc_formatted_shipto,9,2);

		 IF vln_count > 0 THEN
	       vlb_shipto_exist := TRUE;
		 END IF; 
	   EXCEPTION
	     WHEN NO_DATA_FOUND THEN
	   	   NULL;
	     WHEN OTHERS THEN
	       DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;		 
	   	   RAISE ue_critical_db_error;
	   END;
	 ELSIF vlb_hier_cust_exist THEN
	   vlb_shipto_exist := TRUE;
	 END IF;

	 IF vlb_hier_cust_exist = FALSE
	   AND vlb_soldto_exist = FALSE
	   AND vlb_shipto_exist = FALSE THEN
	   GOTO next_rec;
	 END IF;
	 
   	 -- subtract 1 in summary tables
     p_adjust_summaries(-1);
   	 IF vgn_result <> 0 THEN
   	   	RAISE ue_critical_db_error;
   	 END IF;

	 IF vlb_hier_cust_exist = FALSE THEN
	   GOTO end_derive_codes; 
	 END IF;
	  
	 -- get industry business code
	 BEGIN
	   vlc_section := 'In GBL_INDUSTRY table';	 
	   SELECT NVL(industry_business_code,'*')
  	   INTO   ois_rec.INDUSTRY_BUSINESS_CODE
  	   FROM   GBL_INDUSTRY
  	   WHERE  industry_code = vlc_industry_code;
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	   	 ois_rec.INDUSTRY_BUSINESS_CODE := '*';
	   WHEN OTHERS THEN
   	     DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;
	   	 RAISE ue_critical_db_error;
	 END;	   

	 -- get new profit center
 	 vgc_busln_fnctn_id := ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID;
	 p_get_profit_center_abbr_nm;
     IF vgn_result <> 0 THEN
    	RAISE ue_critical_db_error;
     END IF;
    ois_rec.SAP_PROFIT_CENTER_CDE := vgc_SAP_profit_center_cde;

	 IF vgc_profit_center_abbr_nm IS NULL 
	     AND ois_rec.INDUSTRY_BUSINESS_CODE != '*' THEN
	   -- restate competency business maybe Profit Ctr may now have value 
	   BEGIN
	 	 vlc_section := 'In GBL_PRODUCT table';
	 	 SELECT PROD_BUSLN_FNCTN_ID, PROD_BUSLN_ID
	 	 INTO   vgc_busln_fnctn_id, vlc_busln_id
	 	 FROM   GBL_PRODUCT
	 	 WHERE  PROD_CODE = ois_rec.PRODUCT_CODE;
	   EXCEPTION
	 	 WHEN NO_DATA_FOUND THEN
		   vgc_busln_fnctn_id := NULL;
		   vlc_busln_id := NULL;
		 WHEN OTHERS THEN
		   RAISE ue_critical_db_error;
	   END;	 

	   IF vgc_busln_fnctn_id IS NOT NULL THEN 
	   	  -- get new profit center one more time
	   	  p_get_profit_center_abbr_nm;
       	  IF vgn_result <> 0 THEN
    	  	 RAISE ue_critical_db_error;
       	  END IF;

	 	  IF vgc_profit_center_abbr_nm IS NOT NULL THEN
		  	 ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID := vgc_busln_fnctn_id;
		  	 ois_rec.PRODUCT_BUSNS_LINE_ID 		 := vlc_busln_id;
	   	  END IF;
	   END IF;
	 END IF;	 
	 ois_rec.PROFIT_CENTER_ABBR_NM  := NVL(vgc_profit_center_abbr_nm,'*');
	 
	 -- get territory code
	 BEGIN
         vlc_section := 'GET TERRITORY CODE'; 
         SELECT NVL(b.territory_cde,'*')
         INTO   ois_rec.A_TERRITORY_NBR
         FROM   GBL_TERRITORY_ASSIGNMENTS a, GBL_SALES_TERRITORIES b
         WHERE  a.sales_territory_nbr = b.sales_territory_nbr
         AND    a.st_acct_org_id = vlc_hier_cust_org_id
         AND    a.st_acct_nbr_base = vlc_hier_cust_base_id
         AND    a.st_acct_nbr_sufx = vlc_hier_cust_sufx_id
         AND    a.territory_assignment_type_cde = k_territory_assign_type_cde;
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN
	   	 ois_rec.A_TERRITORY_NBR := '*';
	   WHEN OTHERS THEN
	     DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;
	   	 RAISE ue_critical_db_error;
	 END;  

	 -- derive WWAN
     BEGIN
  	 	vlc_section := 'Derive WWAN - GBL_CUSTOMER_PURCHASED_BY table';
		vlc_ww_accnt_nbr := NULL;
       	SELECT PB_WW_CSTMR_ACCT_NBR	
  	 	INTO	vlc_ww_accnt_nbr	    
       	FROM   GBL_CUSTOMER_PURCHASED_BY b 
       	WHERE  b.PB_ACCT_ORG_ID   = vlc_hier_cust_org_id 
       	AND    b.PB_ACCT_NBR_BASE = vlc_hier_cust_base_id;
     EXCEPTION
  	 	WHEN NO_DATA_FOUND THEN
  	   		 NULL;
  	 	WHEN OTHERS THEN
      		 DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;		 
  	   		 RAISE ue_critical_db_error;
     END;
	 
	 -- get trade/interco value
	 IF vlc_industry_code IN ('VA11','VA12') THEN
     	ois_rec.CUSTOMER_ACCT_TYPE_CDE := 'I';
	 ELSE
     	ois_rec.CUSTOMER_ACCT_TYPE_CDE := 'T';
  	 END IF;

	 -- set industry code
	 ois_rec.INDUSTRY_CODE := NVL(vlc_industry_code,'*');	 
	 
	 <<end_derive_codes>>

	 IF vlb_shipto_exist THEN
	   IF ois_rec.HIERARCHY_CUSTOMER_IND = 1 THEN
	     ois_rec.PURCHASE_BY_ACCOUNT_BASE := SUBSTR(vlc_formatted_shipto,1,8);
	     ois_rec.SHIP_TO_ACCOUNT_SUFFIX	  := SUBSTR(vlc_formatted_shipto,9,2);	   
	   ELSE
	     ois_rec.PURCHASE_BY_ACCOUNT_BASE := vlc_hier_cust_base_id;
	     ois_rec.SHIP_TO_ACCOUNT_SUFFIX	  := vlc_hier_cust_sufx_id;
	   END IF;
	 END IF;

	 IF vlb_hier_cust_exist 
	   AND vlc_hier_cust_org_id = ois_rec.HIERARCHY_CUSTOMER_ORG_ID THEN 	 
	   ois_rec.HIERARCHY_CUSTOMER_BASE_ID := vlc_hier_cust_base_id;
	   ois_rec.HIERARCHY_CUSTOMER_SUFX_ID := vlc_hier_cust_sufx_id;

	   ois_rec.WW_ACCOUNT_NBR_BASE   := NVL(SUBSTR(vlc_ww_accnt_nbr,1,8),'*');
	   ois_rec.WW_ACCOUNT_NBR_SUFFIX := NVL(SUBSTR(vlc_ww_accnt_nbr,9,2),'*');

   	   -- update ww_accnt_xref table
       p_update_ww_acct_xref;
   	   IF vgn_result <> 0 THEN
   	   	 RAISE ue_critical_db_error;
   	   END IF;	   
	 END IF;

	 IF vlb_soldto_exist AND vlc_formatted_soldto IS NOT NULL THEN
	   ois_rec.SOLD_TO_CUSTOMER_ID	 := SUBSTR(vlc_formatted_soldto,1,8);  
	 END IF;
	 
   	 -- add 1 in summary tables
     p_adjust_summaries(1);
   	 IF vgn_result <> 0 THEN
   	   	RAISE ue_critical_db_error;
   	 END IF;

    -- derive security values
    tois_rec.ORIG_IBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_ibc_pc_id(ois_rec.INDUSTRY_BUSINESS_CODE);
    tois_rec.ORIG_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(tois_rec.ORIG_IBC_PROFIT_CENTER_ID);

    tois_rec.ORIG_SALES_TERRITORY_NBR := scdCommonBatch.get_hiercust_slsterrnbr(ois_rec.HIERARCHY_CUSTOMER_ORG_ID
                                                                               ,ois_rec.HIERARCHY_CUSTOMER_BASE_ID
    	                                                	                      ,ois_rec.HIERARCHY_CUSTOMER_SUFX_ID
                                                                               );
  
    tois_rec.ORIG_SALES_TERR_PROFIT_CTR_ID  := COR_DATA_SECURITY_TAG_CUR.get_slsterrnbr_pc_id(tois_rec.ORIG_SALES_TERRITORY_NBR);
    tois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(tois_rec.ORIG_SALES_TERR_PROFIT_CTR_ID);   
  
    tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(tois_rec.PROFIT_CENTER_ABBR_NM); 

    -- derive GAM security fields
    -- get GAM, GBU, & GBU PC
    ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM := PKG_SECURITY.get_gam_pc_id(ois_rec.HIERARCHY_CUSTOMER_ORG_ID
                                                                                ,ois_rec.HIERARCHY_CUSTOMER_BASE_ID
                                                                                ,ois_security_rec.CUR_GBL_ACCT_CDE
                                                                                ,ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE               
                                                                                );
    -- get GAM dsg                                                                                  
    IF ois_security_rec.CUR_GBL_ACCT_CDE IS NOT NULL THEN                                                                         
      ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM);
    ELSE -- set derived value to null
      ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE     := NULL;
      ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM := NULL;
      ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID      := NULL;
    END IF;

    -- get CBC & RPTORG DSG ID
    BEGIN
      SELECT CUR_CBC_DATA_SECR_GRP_ID
            ,CUR_REPT_PRFT_DATA_SECR_GRP_ID
      INTO   ois_security_rec.CUR_CBC_DATA_SECR_GRP_ID
           , ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
      FROM   ORDER_ITEM_SHIP_DATA_SECURITY
      WHERE  AMP_ORDER_NBR       = ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	      = ois_rec.SHIPMENT_ID
      AND	 ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         ois_security_rec.CUR_CBC_DATA_SECR_GRP_ID := NULL;
         ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID := NULL;       
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));
         RAISE ue_critical_db_error;
    END;

    tois_rec.ORIG_DATA_SECURITY_TAG_ID := get_data_security_tag1(tois_rec.ORIG_IBC_DATA_SECR_GRP_ID
                                                                ,tois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID  
                                                                ,ois_security_rec.CUR_CBC_DATA_SECR_GRP_ID
                                                                ,ois_security_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
                                                                ,tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
                                                                ,ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID
                                                                );
                                                        
    tois_rec.CUR_DATA_SECURITY_TAG_ID := tois_rec.ORIG_DATA_SECURITY_TAG_ID;
    tois_rec.SUPER_DATA_SECURITY_TAG_ID := tois_rec.ORIG_DATA_SECURITY_TAG_ID;  

    -- update security table
    BEGIN
    	vlc_section := 'Update CUSTOMER_ACCT in OIS SECURITY';    
      UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
      SET    DML_TS = SYSDATE
            ,ORIG_HIERARCHY_CUST_ORG_ID     = ois_rec.HIERARCHY_CUSTOMER_ORG_ID
            ,ORIG_HIERARCHY_CUST_BASE_ID    = ois_rec.HIERARCHY_CUSTOMER_BASE_ID
            ,ORIG_HIERARCHY_CUST_SUFX_ID    = ois_rec.HIERARCHY_CUSTOMER_SUFX_ID
            ,ORIG_INDUSTRY_CDE              = ois_rec.INDUSTRY_CODE
            ,ORIG_INDUSTRY_BUSINESS_CDE     = ois_rec.INDUSTRY_BUSINESS_CODE
            ,ORIG_IBC_PROFIT_CENTER_ID      = tois_rec.ORIG_IBC_PROFIT_CENTER_ID
            ,ORIG_IBC_DATA_SECR_GRP_ID      = tois_rec.ORIG_IBC_DATA_SECR_GRP_ID
            ,CUR_HIERARCHY_CUST_ORG_ID      = ois_rec.HIERARCHY_CUSTOMER_ORG_ID
            ,CUR_HIERARCHY_CUST_BASE_ID     = ois_rec.HIERARCHY_CUSTOMER_BASE_ID
            ,CUR_HIERARCHY_CUST_SUFX_ID     = ois_rec.HIERARCHY_CUSTOMER_SUFX_ID
            ,CUR_INDUSTRY_CDE               = ois_rec.INDUSTRY_CODE
            ,CUR_INDUSTRY_BUSINESS_CDE      = ois_rec.INDUSTRY_BUSINESS_CODE
            ,CUR_IBC_PROFIT_CENTER_ID       = tois_rec.ORIG_IBC_PROFIT_CENTER_ID
            ,CUR_IBC_DATA_SECR_GRP_ID       = tois_rec.ORIG_IBC_DATA_SECR_GRP_ID
            ,ORIG_SALES_TERRITORY_NBR       = tois_rec.ORIG_SALES_TERRITORY_NBR
            ,ORIG_SALES_TERR_PROFIT_CTR_ID  = tois_rec.ORIG_SALES_TERR_PROFIT_CTR_ID
            ,ORIG_SLS_TERR_DATA_SECR_GRP_ID = tois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID
            ,CUR_SALES_TERRITORY_NBR        = tois_rec.ORIG_SALES_TERRITORY_NBR
            ,CUR_SLS_TERR_PROFIT_CTR_ID     = tois_rec.ORIG_SALES_TERR_PROFIT_CTR_ID
            ,CUR_SLS_TERR_DATA_SECR_GRP_ID  = tois_rec.ORIG_SLS_TERR_DATA_SECR_GRP_ID
            ,ORIG_MANAGEMENT_PROFIT_CTR_ID  = ois_rec.PROFIT_CENTER_ABBR_NM
            ,ORIG_MGE_PRFT_DATA_SECR_GRP_ID = tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,CUR_MGE_PROFIT_CTR_ID          = ois_rec.PROFIT_CENTER_ABBR_NM
            ,CUR_MGE_PRFT_DATA_SECR_GRP_ID  = tois_rec.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
            ,ORIG_DATA_SECURITY_TAG_ID      = tois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,CUR_DATA_SECURITY_TAG_ID       = tois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,SUPER_DATA_SECURITY_TAG_ID     = tois_rec.ORIG_DATA_SECURITY_TAG_ID
            ,CUR_GBL_ACCT_CDE               = ois_security_rec.CUR_GBL_ACCT_CDE
            ,CUR_GBL_BUSINESS_UNIT_CDE      = ois_security_rec.CUR_GBL_BUSINESS_UNIT_CDE
            ,CUR_GBL_BSNS_UNIT_PRFT_CTR_NM  = ois_security_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM
            ,CUR_GAM_DATA_SECR_GRP_ID       = ois_security_rec.CUR_GAM_DATA_SECR_GRP_ID
      WHERE  AMP_ORDER_NBR       = ois_rec.AMP_ORDER_NBR
      AND    ORDER_ITEM_NBR      = ois_rec.ORDER_ITEM_NBR
      AND    SHIPMENT_ID	       = ois_rec.SHIPMENT_ID
      AND	 ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
      ;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         NULL;
       WHEN OTHERS THEN
         DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE));
         RAISE ue_critical_db_error;
    END;

	 BEGIN
    	vlc_section := 'Update CUSTOMER_ACCT in OIS';
    	UPDATE ORDER_ITEM_SHIPMENT
		SET	  DML_TMSTMP 						= SYSDATE
			   ,PURCHASE_BY_ACCOUNT_BASE   		= ois_rec.PURCHASE_BY_ACCOUNT_BASE
			   ,SHIP_TO_ACCOUNT_SUFFIX 		    = ois_rec.SHIP_TO_ACCOUNT_SUFFIX
			   ,SOLD_TO_CUSTOMER_ID				= ois_rec.SOLD_TO_CUSTOMER_ID
			   ,INDUSTRY_CODE 					= ois_rec.INDUSTRY_CODE
			   ,INDUSTRY_BUSINESS_CODE	  		= ois_rec.INDUSTRY_BUSINESS_CODE
			   ,CUSTOMER_ACCT_TYPE_CDE 			= ois_rec.CUSTOMER_ACCT_TYPE_CDE
			   ,PROFIT_CENTER_ABBR_NM           = ois_rec.PROFIT_CENTER_ABBR_NM
			   ,A_TERRITORY_NBR					= ois_rec.A_TERRITORY_NBR
			   ,WW_ACCOUNT_NBR_BASE				= ois_rec.WW_ACCOUNT_NBR_BASE
			   ,WW_ACCOUNT_NBR_SUFFIX			= ois_rec.WW_ACCOUNT_NBR_SUFFIX
			   ,HIERARCHY_CUSTOMER_BASE_ID		= ois_rec.HIERARCHY_CUSTOMER_BASE_ID
			   ,HIERARCHY_CUSTOMER_SUFX_ID		= ois_rec.HIERARCHY_CUSTOMER_SUFX_ID 
			   ,PRODUCT_BUSNS_LINE_ID		  	= ois_rec.PRODUCT_BUSNS_LINE_ID
			   ,PRODUCT_BUSNS_LINE_FNCTN_ID 	= ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID			   
         ,SUPER_DATA_SECURITY_TAG_ID   = tois_rec.SUPER_DATA_SECURITY_TAG_ID
         ,SAP_PROFIT_CENTER_CDE          = ois_rec.SAP_PROFIT_CENTER_CDE
    	WHERE  AMP_ORDER_NBR	   = ois_rec.AMP_ORDER_NBR
		AND    ORDER_ITEM_NBR	   = ois_rec.ORDER_ITEM_NBR
		AND    SHIPMENT_ID		   = ois_rec.SHIPMENT_ID
		AND	   ORGANIZATION_KEY_ID = ois_rec.ORGANIZATION_KEY_ID
		;
	 EXCEPTION
		WHEN OTHERS THEN
	       DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;
		   RAISE ue_critical_db_error;
	 END;			 	  

   vlc_section := 'Process SBMT_CUSTOMER_ACCT_NBR';
 	 vln_cnt := vln_cnt + 1;
 	 IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
       	COMMIT;
  	 END IF;	 
	 
	 <<next_rec>>
	 NULL;
  END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('Submitted CUSTOMER_ACCT_NBR revalidated: ' || vln_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
	DBMS_OUTPUT.PUT_LINE('ORGANIZATION_KEY_ID:'||ois_rec.ORGANIZATION_KEY_ID) ;
	DBMS_OUTPUT.PUT_LINE('AMP_ORDER_NBR	     :'||ois_rec.AMP_ORDER_NBR) ;
	DBMS_OUTPUT.PUT_LINE('ORDER_ITEM_NBR	 :'||ois_rec.ORDER_ITEM_NBR) ;
	DBMS_OUTPUT.PUT_LINE('SHIPMENT_ID		 :'||ois_rec.SHIPMENT_ID) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
END ;


PROCEDURE p_restate_ww_customer IS

vln_count 					  NUMBER(3);
vlc_ww_accnt_nbr			  GBL_CUSTOMER_PURCHASED_BY.PB_WW_CSTMR_ACCT_NBR%TYPE;
k_record_status				  VARCHAR2(1) := 'C';

CURSOR ww_accnt_cur IS
  SELECT A.*,C.PB_WW_CSTMR_ACCT_NBR
  FROM   ORDER_ITEM_SHIPMENT A, GBL_CUSTOMER_PURCHASED_BY C 
  WHERE	 HIERARCHY_CUSTOMER_BASE_ID NOT IN ('99999999','66666601','*')
  AND	 C.PB_ACCT_ORG_ID 	   	 = A.HIERARCHY_CUSTOMER_ORG_ID
  AND	 C.PB_ACCT_NBR_BASE    	 = A.HIERARCHY_CUSTOMER_BASE_ID
  AND	 C.PB_WW_CSTMR_ACCT_NBR != A.WW_ACCOUNT_NBR_BASE||WW_ACCOUNT_NBR_SUFFIX
;
			  
BEGIN
  vlc_section := 'Process WW_ACCT_NBR';
  vln_cnt	  := 0;

  FOR ww_accnt_rec IN ww_accnt_cur LOOP
  	 -- get info needed for resummary 
	 -- this has to be updated if a column is added/remove from p_adjust_summary
     ois_rec.DML_ORACLE_ID	  	   		  := ww_accnt_rec.DML_ORACLE_ID;
     ois_rec.AMP_SHIPPED_DATE 	   		  := ww_accnt_rec.AMP_SHIPPED_DATE;
     ois_rec.ORGANIZATION_KEY_ID   		  := ww_accnt_rec.ORGANIZATION_KEY_ID;
     ois_rec.TEAM_CODE			   		  := ww_accnt_rec.TEAM_CODE;
     ois_rec.PRODCN_CNTRLR_CODE	   		  := ww_accnt_rec.PRODCN_CNTRLR_CODE;
     ois_rec.CONTROLLER_UNIQUENESS_ID	  := ww_accnt_rec.CONTROLLER_UNIQUENESS_ID;
     ois_rec.STOCK_MAKE_CODE			  := ww_accnt_rec.STOCK_MAKE_CODE;
     ois_rec.PRODUCT_LINE_CODE		  	  := ww_accnt_rec.PRODUCT_LINE_CODE;
     ois_rec.PRODUCT_CODE	   		  	  := ww_accnt_rec.PRODUCT_CODE;
     ois_rec.PRODCN_CNTLR_EMPLOYEE_NBR	  := ww_accnt_rec.PRODCN_CNTLR_EMPLOYEE_NBR;
     ois_rec.A_TERRITORY_NBR		   	  := ww_accnt_rec.A_TERRITORY_NBR;
     ois_rec.ACTUAL_SHIP_BUILDING_NBR  	  := ww_accnt_rec.ACTUAL_SHIP_BUILDING_NBR;
     ois_rec.ACTUAL_SHIP_LOCATION	   	  := ww_accnt_rec.ACTUAL_SHIP_LOCATION;
     ois_rec.PURCHASE_BY_ACCOUNT_BASE  	  := ww_accnt_rec.PURCHASE_BY_ACCOUNT_BASE;
     ois_rec.SHIP_TO_ACCOUNT_SUFFIX	   	  := ww_accnt_rec.SHIP_TO_ACCOUNT_SUFFIX;
     ois_rec.WW_ACCOUNT_NBR_BASE	   	  := ww_accnt_rec.WW_ACCOUNT_NBR_BASE;
     ois_rec.WW_ACCOUNT_NBR_SUFFIX	   	  := ww_accnt_rec.WW_ACCOUNT_NBR_SUFFIX;
     ois_rec.CUSTOMER_TYPE_CODE	   	   	  := ww_accnt_rec.CUSTOMER_TYPE_CODE;
     ois_rec.SHIP_FACILITY_CMPRSN_CODE 	  := ww_accnt_rec.SHIP_FACILITY_CMPRSN_CODE;
     ois_rec.RELEASE_TO_SHIP_VARIANCE  	  := ww_accnt_rec.RELEASE_TO_SHIP_VARIANCE;
     ois_rec.SCHEDULE_TO_SHIP_VARIANCE 	  := ww_accnt_rec.SCHEDULE_TO_SHIP_VARIANCE;
     ois_rec.VARBL_SCHEDULE_SHIP_VARIANCE := ww_accnt_rec.VARBL_SCHEDULE_SHIP_VARIANCE;
     ois_rec.REQUEST_TO_SHIP_VARIANCE	  := ww_accnt_rec.REQUEST_TO_SHIP_VARIANCE;
     ois_rec.VARBL_REQUEST_SHIP_VARIANCE  := ww_accnt_rec.VARBL_REQUEST_SHIP_VARIANCE;
     ois_rec.REQUEST_TO_SCHEDULE_VARIANCE := ww_accnt_rec.REQUEST_TO_SCHEDULE_VARIANCE;
     ois_rec.CUSTOMER_ACCT_TYPE_CDE		  := ww_accnt_rec.CUSTOMER_ACCT_TYPE_CDE;
     ois_rec.INDUSTRY_CODE				  := ww_accnt_rec.INDUSTRY_CODE;
     ois_rec.MFR_ORG_KEY_ID				  := ww_accnt_rec.MFR_ORG_KEY_ID;
     ois_rec.MFG_CAMPUS_ID				  := ww_accnt_rec.MFG_CAMPUS_ID;
     ois_rec.MFG_BUILDING_NBR			  := ww_accnt_rec.MFG_BUILDING_NBR;
     ois_rec.INDUSTRY_BUSINESS_CODE		  := ww_accnt_rec.INDUSTRY_BUSINESS_CODE;
     ois_rec.ACCOUNTING_ORG_KEY_ID		  := ww_accnt_rec.ACCOUNTING_ORG_KEY_ID;
     ois_rec.PRODUCT_BUSNS_LINE_FNCTN_ID  := ww_accnt_rec.PRODUCT_BUSNS_LINE_FNCTN_ID;
     ois_rec.PROFIT_CENTER_ABBR_NM		  := ww_accnt_rec.PROFIT_CENTER_ABBR_NM;
     ois_rec.SOLD_TO_CUSTOMER_ID		  := ww_accnt_rec.SOLD_TO_CUSTOMER_ID;
     ois_rec.PRODUCT_BUSNS_LINE_ID		  := ww_accnt_rec.PRODUCT_BUSNS_LINE_ID;
     ois_rec.PRODUCT_MANAGER_GLOBAL_ID	  := ww_accnt_rec.PRODUCT_MANAGER_GLOBAL_ID;
     ois_rec.SALES_OFFICE_CDE			  := ww_accnt_rec.SALES_OFFICE_CDE;
     ois_rec.SALES_GROUP_CDE			  := ww_accnt_rec.SALES_GROUP_CDE;
	 ois_rec.DATA_SOURCE_DESC			  := ww_accnt_rec.DATA_SOURCE_DESC;
	 ois_rec.MRP_GROUP_CDE			  	  := ww_accnt_rec.MRP_GROUP_CDE;
	 
	 -- get primary key infor
     ois_rec.AMP_ORDER_NBR	   	 := ww_accnt_rec.AMP_ORDER_NBR;
	 ois_rec.ORDER_ITEM_NBR	   	 := ww_accnt_rec.ORDER_ITEM_NBR;
	 ois_rec.SHIPMENT_ID		 := ww_accnt_rec.SHIPMENT_ID;
	 ois_rec.ORGANIZATION_KEY_ID := ww_accnt_rec.ORGANIZATION_KEY_ID;	 

   	 -- subtract 1 in summary tables
     p_adjust_summaries(-1);
   	 IF vgn_result <> 0 THEN
   	   	RAISE ue_critical_db_error;
   	 END IF;
	 
     ois_rec.WW_ACCOUNT_NBR_BASE   := NVL(SUBSTR(ww_accnt_rec.PB_WW_CSTMR_ACCT_NBR,1,8),'*');
     ois_rec.WW_ACCOUNT_NBR_SUFFIX := NVL(SUBSTR(ww_accnt_rec.PB_WW_CSTMR_ACCT_NBR,9,2),'*');	 	 	 
			 	  
   	 -- add 1 in summary tables
     p_adjust_summaries(1);
   	 IF vgn_result <> 0 THEN
   	   	RAISE ue_critical_db_error;
   	 END IF;
	 
  	 -- get values needed by update_wwan_xref 
	 ois_rec.NBR_WINDOW_DAYS_EARLY := ww_accnt_rec.NBR_WINDOW_DAYS_EARLY; 
	 ois_rec.NBR_WINDOW_DAYS_LATE  := ww_accnt_rec.NBR_WINDOW_DAYS_LATE;	 
   	 -- update ww_accnt_xref table
     p_update_ww_acct_xref;
   	 IF vgn_result <> 0 THEN
   	   	RAISE ue_critical_db_error;
   	 END IF;	 

	 BEGIN
    	vlc_section := 'Update WW_ACCT_NBR in OIS';
    	UPDATE ORDER_ITEM_SHIPMENT
		SET	   DML_TMSTMP 				= SYSDATE
			   ,WW_ACCOUNT_NBR_BASE		= ois_rec.WW_ACCOUNT_NBR_BASE
			   ,WW_ACCOUNT_NBR_SUFFIX	= ois_rec.WW_ACCOUNT_NBR_SUFFIX
    	WHERE  AMP_ORDER_NBR	   	= ois_rec.AMP_ORDER_NBR
		AND    ORDER_ITEM_NBR	   	= ois_rec.ORDER_ITEM_NBR
		AND    SHIPMENT_ID		   	= ois_rec.SHIPMENT_ID
		AND	   ORGANIZATION_KEY_ID 	= ois_rec.ORGANIZATION_KEY_ID
		;
	 EXCEPTION
		WHEN OTHERS THEN
	       DBMS_OUTPUT.PUT_LINE('SQL Error: ' || SQLERRM(SQLCODE)) ;
		   RAISE ue_critical_db_error;
	 END;
	 
  	 vlc_section := 'Process WW_ACCT_NBR';
 	 vln_cnt := vln_cnt + 1;
 	 IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
       	COMMIT;
  	 END IF;	 
	 
  END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('World-Wide Account Nbr restated: ' || vln_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
	DBMS_OUTPUT.PUT_LINE('ORGANIZATION_KEY_ID:'||ois_rec.ORGANIZATION_KEY_ID) ;
	DBMS_OUTPUT.PUT_LINE('AMP_ORDER_NBR	     :'||ois_rec.AMP_ORDER_NBR) ;
	DBMS_OUTPUT.PUT_LINE('ORDER_ITEM_NBR	 :'||ois_rec.ORDER_ITEM_NBR) ;
	DBMS_OUTPUT.PUT_LINE('SHIPMENT_ID		 :'||ois_rec.SHIPMENT_ID) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_revalidate_submitted_values - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
END ;

	 
BEGIN -- main block

   p_revalidate_parts;

   p_revalidate_customer;   

   p_restate_ww_customer;   
   
END ;
/
