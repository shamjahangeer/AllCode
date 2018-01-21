CREATE OR REPLACE PROCEDURE p_pop_gam_sec is

CURSOR gam_cur IS
   SELECT 
          a.ROWID
         ,b.PB_GBL_ACCT_CDE NEW_GBL_ACCT_CDE
         ,c.GBL_BUSINESS_UNIT_CDE NEW_GBL_BUSINESS_UNIT_CDE
         ,d.GBL_BSNS_UNIT_PRFT_CTR_NM NEW_GBL_BSNS_UNIT_PRFT_CTR_NM                 
         ,a.CUR_HIERARCHY_CUST_ORG_ID
         ,a.CUR_HIERARCHY_CUST_BASE_ID
         ,a.CUR_IBC_DATA_SECR_GRP_ID
         ,a.CUR_SLS_TERR_DATA_SECR_GRP_ID  
         ,a.CUR_CBC_DATA_SECR_GRP_ID
         ,a.CUR_REPT_PRFT_DATA_SECR_GRP_ID
         ,a.CUR_MGE_PRFT_DATA_SECR_GRP_ID
         ,a.CUR_DATA_SECURITY_TAG_ID        
         ,a.SUPER_DATA_SECURITY_TAG_ID
         ,a.AMP_ORDER_NBR 
         ,a.ORDER_ITEM_NBR 
         ,a.SHIPMENT_ID 
         ,a.ORGANIZATION_KEY_ID
   FROM   ORDER_ITEM_SHIP_DATA_SECURITY a
         ,GBL_ALL_CUST_PURCH_BY b   
         ,GLOBAL_ACCOUNTS c         
         ,GLOBAL_BUSINESS_UNITS d              
   WHERE  a.CUR_HIERARCHY_CUST_ORG_ID  = b.PB_ACCT_ORG_ID
   AND    a.CUR_HIERARCHY_CUST_BASE_ID = b.PB_ACCT_NBR_BASE
   AND    NVL(a.CUR_GBL_ACCT_CDE,'~') <> NVL(b.PB_GBL_ACCT_CDE,'~')  
   AND    b.PB_GBL_ACCT_CDE = c.GBL_ACCT_CDE
   AND    c.GBL_BUSINESS_UNIT_CDE = d.GBL_BUSINESS_UNIT_CDE          
--AND a.ROWID='AAN5SmAFhAAAUUeAAu'
   ;
   
vln_cnt	  			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=100000;
g_error_section     VARCHAR2(50):= NULL;
New_Exception       EXCEPTION;
derived_rec         ORDER_ITEM_SHIP_DATA_SECURITY%ROWTYPE;
BEGIN
   g_error_section := 'Upd OIS tbl';
   FOR gam_rec IN gam_cur LOOP 

     -- get GAM dsg                                                                                  
     IF gam_rec.NEW_GBL_ACCT_CDE IS NOT NULL THEN                                                                         
       derived_rec.CUR_GAM_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(gam_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM);       

       derived_rec.CUR_DATA_SECURITY_TAG_ID := get_data_security_tag1(gam_rec.CUR_IBC_DATA_SECR_GRP_ID
                                                                     ,gam_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID  
                                                                     ,gam_rec.CUR_CBC_DATA_SECR_GRP_ID
                                                                     ,gam_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
                                                                     ,gam_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID
                                                                     ,derived_rec.CUR_GAM_DATA_SECR_GRP_ID
                                                                     );
                                                  
       derived_rec.SUPER_DATA_SECURITY_TAG_ID := PKG_SECURITY.f_get_super_tag(gam_rec.CUR_DATA_SECURITY_TAG_ID
                                                                             ,derived_rec.CUR_DATA_SECURITY_TAG_ID
                                                                             );     

       UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
       SET     DML_USER_ID = USER
              ,DML_TS      = SYSDATE  
              ,CUR_GBL_ACCT_CDE              = gam_rec.NEW_GBL_ACCT_CDE
              ,CUR_GBL_BUSINESS_UNIT_CDE     = gam_rec.NEW_GBL_BUSINESS_UNIT_CDE    
              ,CUR_GBL_BSNS_UNIT_PRFT_CTR_NM = gam_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
              ,CUR_GAM_DATA_SECR_GRP_ID      = derived_rec.CUR_GAM_DATA_SECR_GRP_ID
              ,CUR_DATA_SECURITY_TAG_ID      = derived_rec.CUR_DATA_SECURITY_TAG_ID
              ,SUPER_DATA_SECURITY_TAG_ID    = derived_rec.SUPER_DATA_SECURITY_TAG_ID
       WHERE  ROWID = gam_rec.ROWID;

       IF derived_rec.SUPER_DATA_SECURITY_TAG_ID != gam_rec.SUPER_DATA_SECURITY_TAG_ID THEN
         PKG_SECURITY.p_upd_ois_super_tag(gam_rec.AMP_ORDER_NBR 
                                         ,gam_rec.ORDER_ITEM_NBR 
                                         ,gam_rec.SHIPMENT_ID 
                                         ,gam_rec.ORGANIZATION_KEY_ID
                                         ,derived_rec.SUPER_DATA_SECURITY_TAG_ID
                                         );
       END IF;

       vln_cnt := vln_cnt + 1;
       IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
       END IF;
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
