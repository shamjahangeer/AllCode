create or replace procedure p_fix_data_sec_grp_id IS

 k_commit_cnt NUMBER := 10000;

procedure fix_data_sec_grp_id (i_pc_id VARCHAR2, i_data_sec_grp_id NUMBER) IS
  	
  CURSOR oiss_cur IS
    SELECT oisds.*,oisds.rowid
    FROM   ORDER_ITEM_SHIP_DATA_SECURITY oisds
    WHERE ((cur_ibc_profit_center_id = i_pc_id 
           AND (cur_ibc_data_secr_grp_id != i_data_sec_grp_id OR cur_ibc_data_secr_grp_id IS NULL))
       OR (cur_cbc_profit_center_id = i_pc_id 
           AND (cur_cbc_data_secr_grp_id != i_data_sec_grp_id OR cur_cbc_data_secr_grp_id IS NULL))
       OR (cur_rept_org_profit_ctr_id = i_pc_id 
           AND (cur_rept_prft_data_secr_grp_id != i_data_sec_grp_id OR cur_rept_prft_data_secr_grp_id IS NULL))
       OR (cur_sls_terr_profit_ctr_id = i_pc_id 
           AND (cur_sls_terr_data_secr_grp_id != i_data_sec_grp_id OR cur_sls_terr_data_secr_grp_id IS NULL))
       OR (cur_mge_profit_ctr_id = i_pc_id 
           AND (cur_mge_prft_data_secr_grp_id != i_data_sec_grp_id OR cur_mge_prft_data_secr_grp_id IS NULL))
          )
--and amp_order_nbr='606161' 
--and order_item_nbr='001'           
    ;
    
   v_error_section			         VARCHAR2(500);
   v_cnt                            NUMBER:=0;
   v_upd_flag                       BOOLEAN;
   v_ibc_data_secr_grp_id           NUMBER;
   v_cbc_data_secr_grp_id           NUMBER;
   v_rept_prft_data_secr_grp_id     NUMBER;
   v_sls_terr_data_secr_grp_id      NUMBER;
   v_mge_prft_data_secr_grp_id      NUMBER;
   v_data_security_tag_id           ORDER_ITEM_SHIP_DATA_SECURITY.SUPER_DATA_SECURITY_TAG_ID%TYPE;
   v_super_data_security_tag_id     ORDER_ITEM_SHIP_DATA_SECURITY.SUPER_DATA_SECURITY_TAG_ID%TYPE;

BEGIN /* main proc */
   v_error_section := 'prcs cursor';
   FOR oiss_rec IN oiss_cur LOOP
     v_upd_flag := false;

     -- IBC
     v_ibc_data_secr_grp_id := oiss_rec.cur_ibc_data_secr_grp_id;
     IF oiss_rec.cur_ibc_profit_center_id = i_pc_id THEN
       v_ibc_data_secr_grp_id := i_data_sec_grp_id;
       v_upd_flag := true;
     END IF;       
           
     -- CBC
     v_cbc_data_secr_grp_id := oiss_rec.cur_cbc_data_secr_grp_id;
     IF oiss_rec.cur_cbc_profit_center_id = i_pc_id THEN
       v_cbc_data_secr_grp_id := i_data_sec_grp_id;
       v_upd_flag := true;
     END IF;     

     -- RPT ORG
     v_rept_prft_data_secr_grp_id := oiss_rec.cur_rept_prft_data_secr_grp_id;
     IF oiss_rec.cur_rept_org_profit_ctr_id = i_pc_id THEN
       v_rept_prft_data_secr_grp_id := i_data_sec_grp_id;
       v_upd_flag := true;
     END IF; 
     
     -- SLS TERR
     v_sls_terr_data_secr_grp_id := oiss_rec.cur_sls_terr_data_secr_grp_id;
     IF oiss_rec.cur_sls_terr_profit_ctr_id = i_pc_id THEN
       v_sls_terr_data_secr_grp_id := i_data_sec_grp_id;
       v_upd_flag := true;
     END IF;     
     
     -- MGE PC
     v_mge_prft_data_secr_grp_id := oiss_rec.cur_mge_prft_data_secr_grp_id;
     IF oiss_rec.cur_mge_profit_ctr_id = i_pc_id THEN
       v_mge_prft_data_secr_grp_id := i_data_sec_grp_id;
       v_upd_flag := true;
     END IF;      
     
     IF v_upd_flag THEN            
       v_data_security_tag_id := get_data_security_tag(v_ibc_data_secr_grp_id
                                                      ,v_sls_terr_data_secr_grp_id  
                                                      ,v_cbc_data_secr_grp_id
                                                      ,v_rept_prft_data_secr_grp_id
                                                      ,v_mge_prft_data_secr_grp_id
                                                      );
                                                          
--       IF v_data_security_tag_id != oiss_rec.CUR_DATA_SECURITY_TAG_ID THEN                                                       
                                                        
         v_super_data_security_tag_id := PKG_SECURITY.f_get_super_tag(oiss_rec.ORIG_DATA_SECURITY_TAG_ID
                                                                     ,v_data_security_tag_id
                                                                     );
       
         -- OIS security
         v_error_section := 'upd ois sec';
         UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
         SET    CUR_DATA_SECURITY_TAG_ID   = v_data_security_tag_id
               ,SUPER_DATA_SECURITY_TAG_ID = v_super_data_security_tag_id
               ,CUR_IBC_DATA_SECR_GRP_ID   = V_IBC_DATA_SECR_GRP_ID
               ,CUR_CBC_DATA_SECR_GRP_ID   = V_CBC_DATA_SECR_GRP_ID
               ,CUR_REPT_PRFT_DATA_SECR_GRP_ID = V_REPT_PRFT_DATA_SECR_GRP_ID
               ,CUR_SLS_TERR_DATA_SECR_GRP_ID  = V_SLS_TERR_DATA_SECR_GRP_ID
               ,CUR_MGE_PRFT_DATA_SECR_GRP_ID  = V_MGE_PRFT_DATA_SECR_GRP_ID
         WHERE  ROWID = oiss_rec.rowid;         
        
         BEGIN
           v_error_section := 'upd ois';
           UPDATE ORDER_ITEM_SHIPMENT                              
           SET    SUPER_DATA_SECURITY_TAG_ID = v_super_data_security_tag_id
           WHERE  AMP_ORDER_NBR       = oiss_rec.AMP_ORDER_NBR
           AND    ORDER_ITEM_NBR      = oiss_rec.ORDER_ITEM_NBR
           AND    SHIPMENT_ID         = oiss_rec.SHIPMENT_ID
           AND    ORGANIZATION_KEY_ID = oiss_rec.ORGANIZATION_KEY_ID;          
         EXCEPTION
           WHEN NO_DATA_FOUND THEN   
             v_error_section := 'upd ois hist';           
             UPDATE ORDER_ITEM_SHIPMENT_HISTORY                                
             SET    SUPER_DATA_SECURITY_TAG_ID = v_super_data_security_tag_id
             WHERE  AMP_ORDER_NBR       = oiss_rec.AMP_ORDER_NBR
             AND    ORDER_ITEM_NBR      = oiss_rec.ORDER_ITEM_NBR
             AND    SHIPMENT_ID         = oiss_rec.SHIPMENT_ID
             AND    ORGANIZATION_KEY_ID = oiss_rec.ORGANIZATION_KEY_ID;               
           WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20101, SQLERRM || ' in ' || v_error_section);             
         END;
--       END IF;

  	    v_cnt := v_cnt + 1;
       IF MOD(v_cnt, k_commit_cnt) = 0 THEN
         COMMIT;
       END IF;                
     END IF;

   END LOOP;
   COMMIT;		

   dbms_output.put_line('recs updated-'||i_pc_id||': '||v_cnt);

END;

BEGIN
  -- fix/set the PC data security group id 
  -- current AER data security group is 3 it need to be change to 1 base on new policy announcement
  fix_data_sec_grp_id('AER', 1);
  
  fix_data_sec_grp_id('MED', 2);  
  
  fix_data_sec_grp_id('PLY', 2);    
  
END;
/
