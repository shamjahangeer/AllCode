create or replace procedure p_pop_data_security
 (vpn_orgkeyid1 NUMBER, vpn_orgkeyid2 NUMBER, vpd_sdate DATE) IS
  	vgc_job_id           LOAD_MSG.DML_ORACLE_ID%TYPE;
  	vgd_ship_date        DATE;
  	ue_row_not_found     EXCEPTION;
  	ue_duplicate_row     EXCEPTION;
    action CHAR;
    commit_count NUMBER := 0;
    num_rows_processed NUMBER := 0;
  	ois                TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE;
  	vin_commit_count	number := 20000;
	
  	von_result_code  NUMBER;
	  ue_critical_db_error EXCEPTION;	

  	vgn_orgkeyid1		 NUMBER(10);
	  vgn_orgkeyid2		 NUMBER(10);
    vgn_orgkeyid		 NUMBER;
    vgd_sdate	 		 DATE;
    vgd_edate			 DATE;
    vgc_rptorg_id  VARCHAR2(4);
	
    CURSOR ois_cur (vin_orgkeyid NUMBER, vid_sdate DATE, vid_edate DATE) IS
    SELECT AMP_ORDER_NBR
          ,ORDER_ITEM_NBR
          ,SHIPMENT_ID
          ,ORGANIZATION_KEY_ID
          ,INDUSTRY_BUSINESS_CODE
          ,PRODUCT_BUSNS_LINE_FNCTN_ID
          ,HIERARCHY_CUSTOMER_IND
          ,HIERARCHY_CUSTOMER_ORG_ID
          ,HIERARCHY_CUSTOMER_BASE_ID
       	  ,HIERARCHY_CUSTOMER_SUFX_ID
          ,PROFIT_CENTER_ABBR_NM          
          ,AMP_SHIPPED_DATE
          ,PART_KEY_ID
          ,PRODUCT_CODE
          ,INDUSTRY_CODE
 		      ,ROWID
    FROM   ORDER_ITEM_SHIPMENT a   
    WHERE  ORGANIZATION_KEY_ID = vin_orgkeyid
    AND	   AMP_SHIPPED_DATE >= vid_sdate
    AND	   AMP_SHIPPED_DATE <= vid_edate
    AND NOT EXISTS (SELECT 1
                    FROM   ORDER_ITEM_SHIP_DATA_SECURITY b
 	                  WHERE  b.ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
                    AND    b.AMP_ORDER_NBR       = a.AMP_ORDER_NBR
                    AND    b.ORDER_ITEM_NBR      = a.ORDER_ITEM_NBR
                    AND    b.SHIPMENT_ID         = a.SHIPMENT_ID
                   )
--and rowid='AAARSIAC/AAALs9AAJ'
--    and rownum <= 1
    --order by ORGANIZATION_KEY_ID, AMP_SHIPPED_DATE
    ;
    
    CURSOR orgkeyid_cur (vin_orgkeyid1 NUMBER, vin_orgkeyid2 NUMBER, vid_sdate DATE) IS
    SELECT  distinct ORGANIZATION_KEY_ID, to_date('01-'||to_char(AMP_SHIPPED_DATE,'mon-yyyy'))
    FROM   ORDER_ITEM_SHIPMENT
    WHERE  ORGANIZATION_KEY_ID >= vin_orgkeyid1
    AND	   ORGANIZATION_KEY_ID <= vin_orgkeyid2
    AND	   AMP_SHIPPED_DATE >= vid_sdate
--    and rownum <= 1    
    order by ORGANIZATION_KEY_ID, to_date('01-'||to_char(AMP_SHIPPED_DATE,'mon-yyyy'))
    ;	

vlc_STOCK_MAKE_CODE	 ORDER_ITEM_SHIPMENT.STOCK_MAKE_CODE%TYPE;
vlc_section			 VARCHAR2(50);

BEGIN /* main proc */
   vgc_job_id := 'SCD_POPDST';

   IF vpn_orgkeyid1 IS NULL THEN
      SELECT min(ORGANIZATION_KEY_ID) INTO vgn_orgkeyid1 FROM ORDER_ITEM_SHIPMENT;
   ELSE
   	  vgn_orgkeyid1 := vpn_orgkeyid1;
   END IF;

   IF vpn_orgkeyid2 IS NULL THEN
      SELECT max(ORGANIZATION_KEY_ID) INTO vgn_orgkeyid2 FROM ORDER_ITEM_SHIPMENT;
   ELSE
   	  vgn_orgkeyid2 := vpn_orgkeyid2;
   END IF;

   IF vpd_sdate IS NULL THEN
      SELECT min(AMP_SHIPPED_DATE) INTO vgd_sdate FROM ORDER_ITEM_SHIPMENT;
   ELSE
      vgd_sdate := vpd_sdate;
   END IF;
   
   OPEN orgkeyid_cur (vgn_orgkeyid1, vgn_orgkeyid2, vgd_sdate);
   LOOP
 
   FETCH orgkeyid_cur INTO vgn_orgkeyid, vgd_sdate;
 
   EXIT WHEN (orgkeyid_cur%NOTFOUND);
 
   vgd_edate := LAST_DAY(vgd_sdate);
 
   FOR ois_rcur IN ois_cur (vgn_orgkeyid, vgd_sdate, vgd_edate) LOOP

  -- derive values for data security columns
  ois.ORIG_IBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_ibc_pc_id(ois_rcur.INDUSTRY_BUSINESS_CODE);
  ois.ORIG_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_IBC_PROFIT_CENTER_ID);

  ois.ORIG_CBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_cbc_pc_id(ois_rcur.PRODUCT_BUSNS_LINE_FNCTN_ID);
  ois.ORIG_CBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_CBC_PROFIT_CENTER_ID);
  
  if not scdCommonBatch.GetCompanyOrgID(ois_rcur.organization_key_id,
           	 						     	   ois_rcur.amp_shipped_date,
     							      	         vgc_rptorg_id) then
     vgc_rptorg_id := NULL;
  end if;

  ois.ORIG_REPT_ORG_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_org_pc_id(vgc_rptorg_id);
  ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_REPT_ORG_PROFIT_CENTER_ID); 
  
  ois.ORIG_SALES_TERRITORY_NBR := scdCommonBatch.get_hiercust_slsterrnbr(ois_rcur.HIERARCHY_CUSTOMER_ORG_ID
                                                                        ,ois_rcur.HIERARCHY_CUSTOMER_BASE_ID
	                                                		                  ,ois_rcur.HIERARCHY_CUSTOMER_SUFX_ID
                                                                        );
  
  ois.ORIG_SALES_TERR_PROFIT_CTR_ID  := COR_DATA_SECURITY_TAG_CUR.get_slsterrnbr_pc_id(ois.ORIG_SALES_TERRITORY_NBR);
  ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_SALES_TERR_PROFIT_CTR_ID);   
  
  ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois_rcur.PROFIT_CENTER_ABBR_NM); 
  
  ois.ORIG_DATA_SECURITY_TAG_ID := get_data_security_tag(ois.ORIG_IBC_DATA_SECR_GRP_ID
                                                        ,ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID  
                                                        ,ois.ORIG_CBC_DATA_SECR_GRP_ID
                                                        ,ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID
                                                        ,ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID
                                                        );
                                                        
  ois.CUR_DATA_SECURITY_TAG_ID := ois.ORIG_DATA_SECURITY_TAG_ID;
  ois.SUPER_DATA_SECURITY_TAG_ID := ois.ORIG_DATA_SECURITY_TAG_ID;

    -- Insert the new record
    INSERT
    INTO ORDER_ITEM_SHIP_DATA_SECURITY (
       ORGANIZATION_KEY_ID
      ,AMP_ORDER_NBR
      ,ORDER_ITEM_NBR
      ,SHIPMENT_ID
      ,DML_USER_ID
      ,DML_TS
      --,ORDER_ITEM_SHIPMENTS_ROW_ID
      ,ORIG_HIERARCHY_CUST_ORG_ID
      ,ORIG_HIERARCHY_CUST_BASE_ID
      ,ORIG_HIERARCHY_CUST_SUFX_ID
      ,ORIG_INDUSTRY_CDE
      ,ORIG_INDUSTRY_BUSINESS_CDE
      ,ORIG_IBC_PROFIT_CENTER_ID
      ,ORIG_IBC_DATA_SECR_GRP_ID
      ,CUR_HIERARCHY_CUST_ORG_ID
      ,CUR_HIERARCHY_CUST_BASE_ID
      ,CUR_HIERARCHY_CUST_SUFX_ID
      ,CUR_INDUSTRY_CDE
      ,CUR_INDUSTRY_BUSINESS_CDE
      ,CUR_IBC_PROFIT_CENTER_ID
      ,CUR_IBC_DATA_SECR_GRP_ID
      ,PART_KEY_ID
      ,ORIG_PRODUCT_CDE
      ,ORIG_COMPETENCY_BUSINESS_CDE
      ,ORIG_CBC_PROFIT_CENTER_ID
      ,ORIG_CBC_DATA_SECR_GRP_ID
      ,CUR_PRODUCT_CDE
      ,CUR_COMPETENCY_BUSINESS_CDE
      ,CUR_CBC_PROFIT_CENTER_ID
      ,CUR_CBC_DATA_SECR_GRP_ID
      ,ORIG_REPT_ORG_PROFIT_CENTER_ID
      ,ORIGREPT_PRFT_DATA_SECR_GRP_ID
      ,CUR_REPT_ORG_PROFIT_CTR_ID
      ,CUR_REPT_PRFT_DATA_SECR_GRP_ID
      ,ORIG_SALES_TERRITORY_NBR
      ,ORIG_SALES_TERR_PROFIT_CTR_ID
      ,ORIG_SLS_TERR_DATA_SECR_GRP_ID
      ,CUR_SALES_TERRITORY_NBR
      ,CUR_SLS_TERR_PROFIT_CTR_ID
      ,CUR_SLS_TERR_DATA_SECR_GRP_ID
      ,ORIG_MANAGEMENT_PROFIT_CTR_ID
      ,ORIG_MGE_PRFT_DATA_SECR_GRP_ID
      ,CUR_MGE_PROFIT_CTR_ID
      ,CUR_MGE_PRFT_DATA_SECR_GRP_ID
      ,ORIG_DATA_SECURITY_TAG_ID
      ,CUR_DATA_SECURITY_TAG_ID
      ,SUPER_DATA_SECURITY_TAG_ID
	  ,HIERARCHY_CUSTOMER_IND       
      ) VALUES (
       ois_rcur.ORGANIZATION_KEY_ID
      ,ois_rcur.AMP_ORDER_NBR
      ,ois_rcur.ORDER_ITEM_NBR
      ,ois_rcur.SHIPMENT_ID      
      ,vgc_job_id
      ,SYSDATE
      --,ois_rcur.rowid
      ,ois_rcur.HIERARCHY_CUSTOMER_ORG_ID
      ,ois_rcur.HIERARCHY_CUSTOMER_BASE_ID
      ,ois_rcur.HIERARCHY_CUSTOMER_SUFX_ID      
      ,ois_rcur.INDUSTRY_CODE
      ,ois_rcur.INDUSTRY_BUSINESS_CODE
      ,ois.ORIG_IBC_PROFIT_CENTER_ID
      ,ois.ORIG_IBC_DATA_SECR_GRP_ID      
      ,ois_rcur.HIERARCHY_CUSTOMER_ORG_ID -- start copy from orig
      ,ois_rcur.HIERARCHY_CUSTOMER_BASE_ID
      ,ois_rcur.HIERARCHY_CUSTOMER_SUFX_ID      
      ,ois_rcur.INDUSTRY_CODE
      ,ois_rcur.INDUSTRY_BUSINESS_CODE
      ,ois.ORIG_IBC_PROFIT_CENTER_ID
      ,ois.ORIG_IBC_DATA_SECR_GRP_ID
      ,ois_rcur.PART_KEY_ID
      ,ois_rcur.PRODUCT_CODE
      ,ois_rcur.PRODUCT_BUSNS_LINE_FNCTN_ID
      ,ois.ORIG_CBC_PROFIT_CENTER_ID
      ,ois.ORIG_CBC_DATA_SECR_GRP_ID      
      ,ois_rcur.PRODUCT_CODE -- start copy from orig
      ,ois_rcur.PRODUCT_BUSNS_LINE_FNCTN_ID
      ,ois.ORIG_CBC_PROFIT_CENTER_ID
      ,ois.ORIG_CBC_DATA_SECR_GRP_ID            
      ,ois.ORIG_REPT_ORG_PROFIT_CENTER_ID
      ,ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID      
      ,ois.ORIG_REPT_ORG_PROFIT_CENTER_ID -- start copy from orig
      ,ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID      
      ,ois.ORIG_SALES_TERRITORY_NBR
      ,ois.ORIG_SALES_TERR_PROFIT_CTR_ID
      ,ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID      
      ,ois.ORIG_SALES_TERRITORY_NBR -- start copy from orig
      ,ois.ORIG_SALES_TERR_PROFIT_CTR_ID
      ,ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID            
      ,ois_rcur.PROFIT_CENTER_ABBR_NM      
      ,ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID      
      ,ois_rcur.PROFIT_CENTER_ABBR_NM  -- start copy from orig     
      ,ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID      
      ,ois.ORIG_DATA_SECURITY_TAG_ID
      ,ois.CUR_DATA_SECURITY_TAG_ID
      ,ois.SUPER_DATA_SECURITY_TAG_ID
	  ,ois_rcur.HIERARCHY_CUSTOMER_IND
      );

	 BEGIN
	 	vlc_section := 'Update OIS';
	 	UPDATE ORDER_ITEM_SHIPMENT
	 	SET    SUPER_DATA_SECURITY_TAG_ID = ois.ORIG_DATA_SECURITY_TAG_ID 
	 	WHERE  ROWID = ois_rcur.ROWID;
	 EXCEPTION
	 	WHEN NO_DATA_FOUND THEN
		   vlc_section := 'Update OIS no record found';
		   RAISE ue_critical_db_error;
		WHEN OTHERS THEN
		   RAISE ue_critical_db_error;
	 END;	 
    
     	/* Commit if this is the Nth row */
     	commit_count := commit_count + 1;
		num_rows_processed := num_rows_processed + 1;
        if (commit_count >= vin_commit_count) then
          COMMIT;
          commit_count := 0;
        end if;

    END LOOP;
    COMMIT;		
		
    END LOOP;
    CLOSE orgkeyid_cur;

    dbms_output.put_line('recs updated: '||num_rows_processed );

    /* log any error */
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        von_result_code := 0;
    	  dbms_output.put_line('dup_index: '||von_result_code);
      WHEN ue_duplicate_row THEN
        von_result_code := 0;
    	  dbms_output.put_line('duplicate_row: '||von_result_code);
      WHEN ue_critical_db_error THEN
        von_result_code := SQLCODE;
    	dbms_output.put_line('critical_db_err: '||vlc_section||' : '||von_result_code);
      WHEN OTHERS THEN
        von_result_code := SQLCODE;
        DBMS_OUTPUT.PUT_LINE(vlc_section);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR:  '|| SQLERRM(SQLCODE));

END;
/
