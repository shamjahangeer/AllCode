create or replace procedure p_upd_data_security_by_pc
  (i_pc_cde     VARCHAR2
  ,i_old_dsg_id order_item_ship_data_security.cur_mge_prft_data_secr_grp_id%TYPE
  ,i_new_dsg_id order_item_ship_data_security.cur_mge_prft_data_secr_grp_id%TYPE
  ) IS

  g_cnt                NUMBER := 0;
  new_srec             order_item_ship_data_security%ROWTYPE;
  k_commit_cnt    	  number := 20000;
  von_result_code      NUMBER;
  ue_critical_db_error EXCEPTION;	

  CURSOR ois_cur IS
    SELECT
       ORIG_DATA_SECURITY_TAG_ID
      ,CUR_IBC_PROFIT_CENTER_ID
      ,CUR_IBC_DATA_SECR_GRP_ID
      ,CUR_SLS_TERR_PROFIT_CTR_ID
      ,CUR_SLS_TERR_DATA_SECR_GRP_ID  
      ,CUR_CBC_PROFIT_CENTER_ID
      ,CUR_CBC_DATA_SECR_GRP_ID
      ,CUR_REPT_ORG_PROFIT_CTR_ID
      ,CUR_REPT_PRFT_DATA_SECR_GRP_ID
      ,CUR_MGE_PROFIT_CTR_ID
      ,CUR_MGE_PRFT_DATA_SECR_GRP_ID
      ,a.SUPER_DATA_SECURITY_TAG_ID
      ,b.ROWID OIS_ROWID
      ,a.ROWID SEC_ROWID
    FROM  order_item_ship_data_security a
         ,order_item_shipment b   
    WHERE (   (CUR_IBC_DATA_SECR_GRP_ID = i_old_dsg_id 
                 AND CUR_IBC_PROFIT_CENTER_ID = i_pc_cde) 
           OR (CUR_SLS_TERR_DATA_SECR_GRP_ID = i_old_dsg_id
                 AND CUR_SLS_TERR_PROFIT_CTR_ID = i_pc_cde)
           OR (CUR_CBC_DATA_SECR_GRP_ID = i_old_dsg_id       
                 AND CUR_CBC_PROFIT_CENTER_ID = i_pc_cde)
           OR (CUR_REPT_PRFT_DATA_SECR_GRP_ID = i_old_dsg_id 
                 AND CUR_REPT_ORG_PROFIT_CTR_ID = i_pc_cde)
           OR (CUR_MGE_PRFT_DATA_SECR_GRP_ID = i_old_dsg_id
                 AND CUR_MGE_PROFIT_CTR_ID = i_pc_cde)
          )
    AND    b.ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
    AND    b.AMP_ORDER_NBR       = a.AMP_ORDER_NBR
    AND    b.ORDER_ITEM_NBR      = a.ORDER_ITEM_NBR
    AND    b.SHIPMENT_ID         = a.SHIPMENT_ID
--    and rownum <= 1
--and A.rowid='AAJRRgAFhAAAA2cAAL'
    ;
    
  vlc_section			 VARCHAR2(50);

-- funtion to generate super tag based on two input tags.
FUNCTION f_get_super_tag(i_tag1 VARCHAR2, i_tag2 VARCHAR2) RETURN VARCHAR2 IS
  v_pos              NUMBER(2);
  v_super_tag        ORDER_ITEM_SHIP_DATA_SECURITY.SUPER_DATA_SECURITY_TAG_ID%TYPE;
  v_error_section    VARCHAR2(100);  
BEGIN
  v_error_section := 'derive super_tag';
  IF i_tag1 <> i_tag2 THEN
    FOR v_pos IN 1..LENGTH(i_tag1) LOOP
      IF SUBSTR(i_tag1,v_pos,1) = '1' OR SUBSTR(i_tag2,v_pos,1) = '1' THEN
        v_super_tag := v_super_tag || '1';
      ELSE
        v_super_tag := v_super_tag || '0';
      END IF;      
    END LOOP;
  ELSE
    v_super_tag := i_tag1;
  END IF;
  RETURN v_super_tag;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR (-20101, SQLERRM || ' in ' || v_error_section);   
END f_get_super_tag;

-- get OIS super tag
PROCEDURE p_upd_ois_super_tag(i_rowid         ROWID
                             ,i_new_super_tag VARCHAR2) IS
  v_error_section    VARCHAR2(100);  
BEGIN
  v_error_section := 'upd ois super_tag';
  UPDATE ORDER_ITEM_SHIPMENT
  SET    DML_TMSTMP = SYSDATE                                  
        ,SUPER_DATA_SECURITY_TAG_ID = i_new_super_tag
  WHERE  ROWID = i_rowid 
  ;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR (-20101, SQLERRM || ' in ' || v_error_section);   
END p_upd_ois_super_tag;

BEGIN /* main proc */
   FOR ois_rcur IN ois_cur LOOP
     new_srec := NULL;
   
     vlc_section := 'set IBC sec id';
     IF ois_rcur.CUR_IBC_PROFIT_CENTER_ID IS NOT NULL THEN
       IF ois_rcur.CUR_IBC_PROFIT_CENTER_ID = i_pc_cde THEN
         new_srec.CUR_IBC_DATA_SECR_GRP_ID := i_new_dsg_id;
       ELSE
         new_srec.CUR_IBC_DATA_SECR_GRP_ID := ois_rcur.CUR_IBC_DATA_SECR_GRP_ID;
       END IF;
     END IF;
     
     vlc_section := 'set Sales Terr sec id';
     IF ois_rcur.CUR_SLS_TERR_PROFIT_CTR_ID IS NOT NULL THEN
       IF ois_rcur.CUR_SLS_TERR_PROFIT_CTR_ID = i_pc_cde THEN
         new_srec.CUR_SLS_TERR_DATA_SECR_GRP_ID := i_new_dsg_id;
       ELSE
         new_srec.CUR_SLS_TERR_DATA_SECR_GRP_ID := ois_rcur.CUR_SLS_TERR_DATA_SECR_GRP_ID;
       END IF;
     END IF;     
  
     vlc_section := 'set CBC sec id';
     IF ois_rcur.CUR_CBC_PROFIT_CENTER_ID IS NOT NULL THEN
       IF ois_rcur.CUR_CBC_PROFIT_CENTER_ID = i_pc_cde THEN
         new_srec.CUR_CBC_DATA_SECR_GRP_ID := i_new_dsg_id;
       ELSE
         new_srec.CUR_CBC_DATA_SECR_GRP_ID := ois_rcur.CUR_CBC_DATA_SECR_GRP_ID;
       END IF;         
     END IF;
     
     vlc_section := 'set RPT ORG sec id';
     IF ois_rcur.CUR_REPT_ORG_PROFIT_CTR_ID IS NOT NULL THEN
       IF ois_rcur.CUR_REPT_ORG_PROFIT_CTR_ID = i_pc_cde THEN
         new_srec.CUR_REPT_PRFT_DATA_SECR_GRP_ID := i_new_dsg_id;
       ELSE
         new_srec.CUR_REPT_PRFT_DATA_SECR_GRP_ID := ois_rcur.CUR_REPT_PRFT_DATA_SECR_GRP_ID;
       END IF;         
     END IF;     

     vlc_section := 'set RPT ORG sec id';
     IF ois_rcur.CUR_MGE_PROFIT_CTR_ID IS NOT NULL THEN
       IF ois_rcur.CUR_MGE_PROFIT_CTR_ID = i_pc_cde THEN
         new_srec.CUR_MGE_PRFT_DATA_SECR_GRP_ID := i_new_dsg_id;
       ELSE
         new_srec.CUR_MGE_PRFT_DATA_SECR_GRP_ID := ois_rcur.CUR_MGE_PRFT_DATA_SECR_GRP_ID;
       END IF;         
     END IF;

     new_srec.CUR_DATA_SECURITY_TAG_ID := get_data_security_tag(new_srec.CUR_IBC_DATA_SECR_GRP_ID
                                                               ,new_srec.CUR_SLS_TERR_DATA_SECR_GRP_ID  
                                                               ,new_srec.CUR_CBC_DATA_SECR_GRP_ID
                                                               ,new_srec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
                                                               ,new_srec.CUR_MGE_PRFT_DATA_SECR_GRP_ID
                                                               );
                                                  
     new_srec.SUPER_DATA_SECURITY_TAG_ID := f_get_super_tag(ois_rcur.ORIG_DATA_SECURITY_TAG_ID
                                                           ,new_srec.CUR_DATA_SECURITY_TAG_ID
                                                           );

     -- update OIS data security table
     vlc_section := 'upd UPDATE ORDER_ITEM_SHIP_DATA_SECURITY table';
     UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
     SET     DML_USER_ID = USER
            ,DML_TS      = SYSDATE  
            ,CUR_IBC_DATA_SECR_GRP_ID       = new_srec.CUR_IBC_DATA_SECR_GRP_ID            
            ,CUR_CBC_DATA_SECR_GRP_ID       = new_srec.CUR_CBC_DATA_SECR_GRP_ID
            ,CUR_REPT_PRFT_DATA_SECR_GRP_ID = new_srec.CUR_REPT_PRFT_DATA_SECR_GRP_ID
            ,CUR_SLS_TERR_DATA_SECR_GRP_ID  = new_srec.CUR_SLS_TERR_DATA_SECR_GRP_ID
            ,CUR_MGE_PRFT_DATA_SECR_GRP_ID  = new_srec.CUR_MGE_PRFT_DATA_SECR_GRP_ID
            ,CUR_DATA_SECURITY_TAG_ID       = new_srec.CUR_DATA_SECURITY_TAG_ID
            ,SUPER_DATA_SECURITY_TAG_ID     = new_srec.SUPER_DATA_SECURITY_TAG_ID
     WHERE   ROWID = ois_rcur.SEC_ROWID
     ;

     -- update OIS table super tag
     IF ois_rcur.SUPER_DATA_SECURITY_TAG_ID <> new_srec.SUPER_DATA_SECURITY_TAG_ID THEN
       p_upd_ois_super_tag(ois_rcur.OIS_ROWID
                          ,new_srec.SUPER_DATA_SECURITY_TAG_ID);
     END IF;
     
 	  g_cnt := g_cnt + 1;
     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
       COMMIT;
     END IF;

    END LOOP;
    COMMIT;		
		
    dbms_output.put_line('recs updated: '||g_cnt);

    /* log any error */
    EXCEPTION
      WHEN ue_critical_db_error THEN
        ROLLBACK;      
     	  dbms_output.put_line('critical_db_err: '||vlc_section||' : '||von_result_code);
      WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(vlc_section);
        DBMS_OUTPUT.PUT_LINE('SQL ERROR:  '|| SQLERRM(SQLCODE));

END;
/
