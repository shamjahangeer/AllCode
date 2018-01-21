CREATE OR REPLACE PROCEDURE p_pop_sap_pc is

CURSOR ois_cur IS
  SELECT gmpcr.SAP_PROFIT_CENTER_CDE, ois.ROWID
  FROM   ORDER_ITEM_SHIPMENT ois,
         GBL_MGE_PROFIT_CENTERS gmpc,
         GBL_MGE_PROFIT_CENTER_RELS gmpcr
  WHERE  gmpc.MGE_PROFIT_CENTER_ID  = gmpcr.MGE_PROFIT_CENTER_ID
  AND    gmpcr.ORGANIZATION_ID = (SELECT COMPANY_ORGANIZATION_ID
                                  FROM organizations_dmn
                                  WHERE organization_key_id = ois.ORGANIZATION_KEY_ID
                                  AND record_status_cde = 'C')
  AND    INDUSTRY_BUSINESS_CDE   = ois.INDUSTRY_BUSINESS_CODE
  AND    COMPETENCY_BUSINESS_CDE = ois.product_busns_line_fnctn_id
  AND	   ois.SAP_PROFIT_CENTER_CDE IS NULL
  ;
   
vln_cnt	  			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=100000;
g_error_section     VARCHAR2(50):= NULL;
New_Exception       EXCEPTION;
BEGIN
   g_error_section := 'Upd OIS tbl';
   FOR ois_rec IN ois_cur LOOP

      UPDATE ORDER_ITEM_SHIPMENT
      SET    SAP_PROFIT_CENTER_CDE = ois_rec.SAP_PROFIT_CENTER_CDE
      WHERE  ROWID = ois_rec.ROWID;     

      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;

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
