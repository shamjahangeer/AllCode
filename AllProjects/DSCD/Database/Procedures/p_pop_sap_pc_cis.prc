CREATE OR REPLACE PROCEDURE p_pop_sap_pc_cis is

CURSOR ois_cur IS
  SELECT gmpcr.SAP_PROFIT_CENTER_CDE, ois.ROWID, ois.source_id
        ,ois.INDUSTRY_BUSINESS_CODE,ois.part_key_id
        ,ois.Hierarchy_Customer_Org_Id,ois.Hierarchy_Customer_Base_Id,ois.Hierarchy_Customer_Sufx_Id
  FROM   ORDER_ITEM_SHIPMENT ois,
         GBL_MGE_PROFIT_CENTERS gmpc,
         GBL_MGE_PROFIT_CENTER_RELS gmpcr
  WHERE  gmpc.MGE_PROFIT_CENTER_ID(+)  = gmpcr.MGE_PROFIT_CENTER_ID
/*  AND    gmpcr.ORGANIZATION_ID(+) = (SELECT COMPANY_ORGANIZATION_ID
                                  FROM organizations_dmn
                                  WHERE organization_key_id = ois.ORGANIZATION_KEY_ID
                                  AND record_status_cde = 'C') */
  and gmpcr.ORGANIZATION_ID(+)=substr(source_id,1,4)
  AND    INDUSTRY_BUSINESS_CDE(+)   = ois.INDUSTRY_BUSINESS_CODE
  AND    COMPETENCY_BUSINESS_CDE(+) = ois.product_busns_line_fnctn_id
  AND    ois.profit_center_abbr_nm='CIS'
  AND	   (ois.SAP_PROFIT_CENTER_CDE IS NULL 
         OR 
          gmpcr.SAP_PROFIT_CENTER_CDE <> ois.SAP_PROFIT_CENTER_CDE
         ) 
--and ois.rowid = 'AAMivGAEVAAAnrdAAA'    
and ois.fiscal_year=2010
and ois.fiscal_month in (4,5,6)
  ;
   
vln_cnt	  			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=100000;
g_error_section     VARCHAR2(50):= NULL;
New_Exception       EXCEPTION;
BEGIN
   g_error_section := 'Upd OIS tbl';
   FOR ois_rec IN ois_cur LOOP
      IF ois_rec.sap_profit_center_cde IS NULL THEN
       begin
        -- derive current CBC
        SELECT gmpcr.SAP_PROFIT_CENTER_CDE
        INTO   ois_rec.SAP_PROFIT_CENTER_CDE
        FROM   ORDER_ITEM_SHIPMENT ois,
               GBL_MGE_PROFIT_CENTERS gmpc,
               GBL_MGE_PROFIT_CENTER_RELS gmpcr
        WHERE  gmpc.MGE_PROFIT_CENTER_ID  = gmpcr.MGE_PROFIT_CENTER_ID
        and    gmpcr.ORGANIZATION_ID= substr(ois_rec.source_id,1,4)
        AND    INDUSTRY_BUSINESS_CDE   = ois_rec.INDUSTRY_BUSINESS_CODE
        AND    COMPETENCY_BUSINESS_CDE = (SELECT gp.prod_busln_fnctn_id
                                          FROM gbl_product gp
                                              ,corporate_parts cp
                                          WHERE cp.part_key_id = ois_rec.part_key_id
                                          AND cp.product_cde = gp.prod_code)
        AND    ois.profit_center_abbr_nm='CIS'        
        AND    ois.rowid = ois_rec.rowid;
       exception
        when no_data_found then
          begin       
            -- derive current IBC
            SELECT gmpcr.SAP_PROFIT_CENTER_CDE
            INTO   ois_rec.SAP_PROFIT_CENTER_CDE
            FROM   ORDER_ITEM_SHIPMENT ois,
                   GBL_MGE_PROFIT_CENTERS gmpc,
                   GBL_MGE_PROFIT_CENTER_RELS gmpcr
            WHERE  gmpc.MGE_PROFIT_CENTER_ID  = gmpcr.MGE_PROFIT_CENTER_ID
            and    gmpcr.ORGANIZATION_ID= substr(ois_rec.source_id,1,4)
            AND    INDUSTRY_BUSINESS_CDE   = (SELECT industry_business_code
                                              FROM   GBL_INDUSTRY gi
                                                    ,GBL_CUSTOMER_SHIP_TO st 
                                              WHERE  industry_code = st.ST_INDUSTRY_CODE
                                              AND    st.ST_ACCT_ORG_ID   = ois_rec.Hierarchy_Customer_Org_Id
                                              AND    st.ST_ACCT_NBR_BASE = ois_rec.Hierarchy_Customer_Base_Id
                                              AND	  st.ST_ACCT_NBR_SUFX = ois_rec.Hierarchy_Customer_Sufx_Id)
            AND    COMPETENCY_BUSINESS_CDE = (SELECT gp.prod_busln_fnctn_id
                                              FROM gbl_product gp
                                                  ,corporate_parts cp
                                              WHERE cp.part_key_id = ois_rec.part_key_id
                                              AND cp.product_cde = gp.prod_code)
            AND    ois.profit_center_abbr_nm='CIS'        
            AND    ois.rowid = ois_rec.rowid;          
          exception
            when no_data_found then    
              dbms_output.put_line('rowid: '||ois_rec.rowid);
              goto next_rec;
          end;
       end;
      END IF;   
   
      UPDATE ORDER_ITEM_SHIPMENT
      SET    SAP_PROFIT_CENTER_CDE = ois_rec.SAP_PROFIT_CENTER_CDE
      WHERE  ROWID = ois_rec.ROWID;     

      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;
      <<next_rec>>
        null;
   END LOOP;
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('recs updated: '||vln_cnt);   
EXCEPTION
  WHEN New_Exception THEN
  	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM||' - '||g_error_section);
  WHEN OTHERS THEN
  	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM);  	      
END;
/
