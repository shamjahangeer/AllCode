create or replace package PKG_SECURITY is
  ----------------------------------------------------------------------------------
  -- PACKAGE:     pkg_security
  -- DESCRIPTION: Contains procedures to update the security related fields.
  --
  -- MODIFICATION LOG:
  -- Date      Programmer    Description                                      
  -- 11-01-07  A.Orbeta      Initial version.
  -- 18-08-10                Update super_security_tag of OIS history.
  -- 18-11-10                Add GAM in data security.
  -- --------  ------------  -------------------------------------------------------
  PROCEDURE p_VT_Cust;
  PROCEDURE p_Reorg_OIS_Data;
  FUNCTION f_get_super_tag(i_tag1 VARCHAR2, i_tag2 VARCHAR2) RETURN VARCHAR2;
  FUNCTION get_gam_pc_id(i_org_id VARCHAR2,
                         i_soldto VARCHAR2,
                         o_gam_id OUT NOCOPY VARCHAR2,
                         o_gbu_id OUT NOCOPY VARCHAR2) RETURN VARCHAR2;
  PROCEDURE p_upd_ois_super_tag(i_order_nbr     VARCHAR2,
                                i_item_nbr      VARCHAR2,
                                i_ship_id       VARCHAR2,
                                i_org_kid       VARCHAR2,
                                i_new_super_tag VARCHAR2);
end PKG_SECURITY;
/
create or replace package body PKG_SECURITY is

  -- Public declarations
  k_commit_cnt NUMBER(7) := 10000;
  g_row_id     ROWID;
  g_cnt        NUMBER(10);
  g_errmsg     VARCHAR2(1000);

  -- define SQL table populated once at pkg initial load - small table
  -- define GAM lookup table
  TYPE gam_lookup_table IS TABLE OF GLOBAL_ACCOUNTS.GBL_BUSINESS_UNIT_CDE%TYPE INDEX BY GLOBAL_ACCOUNTS.GBL_ACCT_CDE%TYPE;
  gam_gbu_id_table gam_lookup_table;

  -- define global BU lookup table
  TYPE gbu_lookup_table IS TABLE OF GLOBAL_BUSINESS_UNITS.GBL_BSNS_UNIT_PRFT_CTR_NM%TYPE INDEX BY GLOBAL_BUSINESS_UNITS.GBL_BUSINESS_UNIT_CDE%TYPE;
  gbu_pc_id_table gbu_lookup_table;

  -- define SQL table populated on demand - large table 
  -- define product lookup table
  TYPE soldto_lookup_table IS TABLE OF GBL_ALL_CUST_PURCH_BY.PB_GBL_ACCT_CDE%TYPE INDEX BY VARCHAR2(12);
  soldto_gam_id_table soldto_lookup_table;

  -- funtion to generate super tag based on two input tags.
  FUNCTION f_get_super_tag(i_tag1 VARCHAR2, i_tag2 VARCHAR2) RETURN VARCHAR2 IS
    v_pos           NUMBER(2);
    v_super_tag     ORDER_ITEM_SHIP_DATA_SECURITY.SUPER_DATA_SECURITY_TAG_ID%TYPE;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'derive super_tag';
    IF i_tag1 <> i_tag2 THEN
      FOR v_pos IN 1 .. LENGTH(i_tag1) LOOP
        IF SUBSTR(i_tag1, v_pos, 1) = '1' OR SUBSTR(i_tag2, v_pos, 1) = '1' THEN
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
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END f_get_super_tag;

  -- get global BU PC
  FUNCTION get_gbu_pc_id(i_gbu_id VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF i_gbu_id IS NULL THEN
      RETURN NULL;
    ELSE
      RETURN gbu_pc_id_table(i_gbu_id);
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function PKG_SECURITY.get_gbu_pc_id');
  END get_gbu_pc_id;

  -- get global BU
  FUNCTION get_gbu_id(i_gam_id VARCHAR2) RETURN VARCHAR2 IS
  BEGIN
    IF i_gam_id IS NULL THEN
      RETURN NULL;
    ELSE
      RETURN gam_gbu_id_table(i_gam_id);
    END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function PKG_SECURITY.get_gbu_id');
  END get_gbu_id;

  -- get GAM ID
  FUNCTION get_gam_pc_id(i_org_id VARCHAR2,
                         i_soldto VARCHAR2,
                         o_gam_id OUT NOCOPY VARCHAR2,
                         o_gbu_id OUT NOCOPY VARCHAR2) RETURN VARCHAR2 IS
    v_gbu_pc_id GLOBAL_BUSINESS_UNITS.GBL_BUSINESS_UNIT_CDE%TYPE := NULL;
  BEGIN
    o_gam_id := NULL;
    o_gbu_id := NULL;
    IF i_org_id IS NULL OR i_soldto IS NULL THEN
      RETURN NULL;
    END IF;
    o_gam_id    := soldto_gam_id_table(i_org_id || i_soldto);
    o_gbu_id    := get_gbu_id(o_gam_id);
    v_gbu_pc_id := get_gbu_pc_id(o_gbu_id);
    RETURN v_gbu_pc_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT a.PB_GBL_ACCT_CDE
          INTO o_gam_id
          FROM GBL_ALL_CUST_PURCH_BY a
         WHERE a.PB_ACCT_ORG_ID = i_org_id
           AND a.PB_ACCT_NBR_BASE = i_soldto
           AND ROWNUM <= 1;
      
        soldto_gam_id_table(i_org_id || i_soldto) := o_gam_id;
        o_gbu_id := get_gbu_id(o_gam_id);
        v_gbu_pc_id := get_gbu_pc_id(o_gbu_id);
        RETURN v_gbu_pc_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN v_gbu_pc_id;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function PKG_SECURITY.get_gam_pc_id-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function PKG_SECURITY.get_gam_pc_id-1');
  END get_gam_pc_id;

  -- populate GAM lookup table
  PROCEDURE pop_gam_lookup_table IS
    CURSOR gam_cur IS
      SELECT GBL_ACCT_CDE, GBL_BUSINESS_UNIT_CDE
        FROM GLOBAL_ACCOUNTS
       WHERE GBL_BUSINESS_UNIT_CDE IS NOT NULL;
  BEGIN
    FOR gam_rec in gam_cur LOOP
      gam_gbu_id_table(gam_rec.GBL_ACCT_CDE) := gam_rec.GBL_BUSINESS_UNIT_CDE;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in procedure PKG_SECURITY.pop_gam_lookup_table');
  END pop_gam_lookup_table;

  -- populate global BU lookup table
  PROCEDURE pop_gbu_pc_lookup_table IS
    CURSOR gbu_pc_cur IS
      SELECT GBL_BUSINESS_UNIT_CDE, GBL_BSNS_UNIT_PRFT_CTR_NM
        FROM GLOBAL_BUSINESS_UNITS
       WHERE GBL_BSNS_UNIT_PRFT_CTR_NM IS NOT NULL;
  BEGIN
    FOR gbu_pc_rec in gbu_pc_cur LOOP
      gbu_pc_id_table(gbu_pc_rec.GBL_BUSINESS_UNIT_CDE) := gbu_pc_rec.GBL_BSNS_UNIT_PRFT_CTR_NM;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in procedure PKG_SECURITY.pop_gbu_pc_lookup_table');
  END pop_gbu_pc_lookup_table;

  -- get OIS super tag
  PROCEDURE p_upd_ois_super_tag(i_order_nbr     VARCHAR2,
                                i_item_nbr      VARCHAR2,
                                i_ship_id       VARCHAR2,
                                i_org_kid       VARCHAR2,
                                i_new_super_tag VARCHAR2) IS
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'upd ois super_tag';
    UPDATE ORDER_ITEM_SHIPMENT
       SET DML_TMSTMP                 = SYSDATE,
           SUPER_DATA_SECURITY_TAG_ID = i_new_super_tag
     WHERE AMP_ORDER_NBR = i_order_nbr
       AND ORDER_ITEM_NBR = i_item_nbr
       AND SHIPMENT_ID = i_ship_id
       AND ORGANIZATION_KEY_ID = i_org_kid;
  
    IF SQL%ROWCOUNT <= 0 THEN
      BEGIN
        -- update hist if not in OIS table
        v_error_section := 'upd ois history super_tag';
        UPDATE ORDER_ITEM_SHIPMENT_HISTORY
           SET DML_TMSTMP                 = SYSDATE,
               SUPER_DATA_SECURITY_TAG_ID = i_new_super_tag
         WHERE AMP_ORDER_NBR = i_order_nbr
           AND ORDER_ITEM_NBR = i_item_nbr
           AND SHIPMENT_ID = i_ship_id
           AND ORGANIZATION_KEY_ID = i_org_kid;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- same record not in history table
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_upd_ois_super_tag;

  -- procedure to void and transfer hier customer and update the security related columns
  PROCEDURE p_VT_Cust IS
    CURSOR cust_cur IS
      SELECT c.row_id,
             c.CUR_HIERARCHY_CUST_ORG_ID,
             c.CUR_HIERARCHY_CUST_BASE_ID,
             c.CUR_HIERARCHY_CUST_SUFX_ID,
             AMP_ORDER_NBR,
             ORDER_ITEM_NBR,
             SHIPMENT_ID,
             ORGANIZATION_KEY_ID,
             CUR_INDUSTRY_CDE,
             CUR_INDUSTRY_BUSINESS_CDE,
             CUR_IBC_PROFIT_CENTER_ID,
             CUR_IBC_DATA_SECR_GRP_ID,
             CUR_COMPETENCY_BUSINESS_CDE,
             CUR_CBC_DATA_SECR_GRP_ID,
             CUR_REPT_PRFT_DATA_SECR_GRP_ID,
             CUR_SALES_TERRITORY_NBR,
             CUR_SLS_TERR_PROFIT_CTR_ID,
             CUR_SLS_TERR_DATA_SECR_GRP_ID,
             CUR_MGE_PROFIT_CTR_ID,
             CUR_MGE_PRFT_DATA_SECR_GRP_ID,
             CUR_GBL_ACCT_CDE,
             CUR_GBL_BUSINESS_UNIT_CDE,
             CUR_GBL_BSNS_UNIT_PRFT_CTR_NM,
             CUR_GAM_DATA_SECR_GRP_ID,
             ORIG_DATA_SECURITY_TAG_ID,
             CUR_DATA_SECURITY_TAG_ID,
             SUPER_DATA_SECURITY_TAG_ID
        FROM (SELECT b.ROWID                    row_id,
                      GCM_VALID_ST_ACCT_ORG_ID   CUR_HIERARCHY_CUST_ORG_ID,
                      GCM_VALID_ST_ACCT_NBR_BASE CUR_HIERARCHY_CUST_BASE_ID,
                      GCM_VALID_ST_ACCT_NBR_SUFX CUR_HIERARCHY_CUST_SUFX_ID
                 FROM GBL_PRIOR_MONTH_END.GBL_CUSTOMER_MAPPING a,
                      ORDER_ITEM_SHIP_DATA_SECURITY            b
                WHERE GCM_ST_COMPOSITE_KEY <> GCM_VALID_ST_COMPOSITE_KEY
                  AND GCM_ST_ACCT_ORG_ID = CUR_HIERARCHY_CUST_ORG_ID
                  AND GCM_ST_ACCT_NBR_BASE = CUR_HIERARCHY_CUST_BASE_ID
                  AND GCM_ST_ACCT_NBR_SUFX = CUR_HIERARCHY_CUST_SUFX_ID
                  AND HIERARCHY_CUSTOMER_IND = 0 -- shipto only   
               UNION
               SELECT b.ROWID                    row_id,
                      GCM_VALID_ST_ACCT_ORG_ID   CUR_HIERARCHY_CUST_ORG_ID,
                      GCM_VALID_ST_ACCT_NBR_BASE CUR_HIERARCHY_CUST_BASE_ID,
                      GCM_VALID_ST_ACCT_NBR_SUFX CUR_HIERARCHY_CUST_SUFX_ID
                 FROM GBL_PRIOR_MONTH_END.GBL_CUSTOMER_MAPPING a
                      -- get the lowest suffix since '00' is not always true
                     ,
                      (SELECT GCM_ST_ACCT_ORG_ID GCM_ORG,
                               GCM_ST_ACCT_NBR_BASE GCM_BASE,
                               MIN(GCM_ST_ACCT_NBR_SUFX) GCM_SUFX
                          FROM GBL_PRIOR_MONTH_END.GBL_CUSTOMER_MAPPING
                         WHERE GCM_ST_COMPOSITE_KEY <>
                               GCM_VALID_ST_COMPOSITE_KEY
                              -- filter out US for performance since it's always a shipto
                         AND GCM_ST_ACCT_ORG_ID <> '0048'
                       GROUP BY GCM_ST_ACCT_ORG_ID, GCM_ST_ACCT_NBR_BASE) a1,
                     ORDER_ITEM_SHIP_DATA_SECURITY b
               WHERE NOT EXISTS
               (SELECT 1 -- make sure it does not exist in sold to table
                        FROM GBL_PRIOR_MONTH_END.GBL_CUSTOMER_PURCHASED_BY
                       WHERE PB_ACCT_ORG_ID = a.GCM_ST_ACCT_ORG_ID
                         AND PB_ACCT_NBR_BASE = a.GCM_ST_ACCT_NBR_BASE)
                 AND a1.GCM_ORG = a.GCM_ST_ACCT_ORG_ID
                 AND a1.GCM_BASE = a.GCM_ST_ACCT_NBR_BASE
                 AND a1.GCM_SUFX = a.GCM_ST_ACCT_NBR_SUFX
                 AND GCM_ST_COMPOSITE_KEY <> GCM_VALID_ST_COMPOSITE_KEY
                 AND GCM_ST_ACCT_ORG_ID = CUR_HIERARCHY_CUST_ORG_ID
                 AND GCM_ST_ACCT_NBR_BASE = CUR_HIERARCHY_CUST_BASE_ID
                 AND HIERARCHY_CUSTOMER_IND = 1 -- soldto only   
              ) c,
             ORDER_ITEM_SHIP_DATA_SECURITY d
       WHERE c.row_id = d.ROWID;
  
    derived_rec     cust_cur%ROWTYPE;
    v_error_section VARCHAR2(100);
    v_co_org_id     GBL_ORGS.GO_ORG_ID%TYPE;
    v_upd_super_tag BOOLEAN;
  BEGIN
    v_error_section := 'p_VT_Cust';
    g_cnt           := 0;
    FOR cust_rec IN cust_cur LOOP
      -- copy original value to derived columns
      v_error_section := 'set derived_rec';
      derived_rec     := cust_rec;
      v_upd_super_tag := FALSE;
    
      -- get industry code
      derived_rec.CUR_INDUSTRY_CDE := scdcommonbatch.get_shipto_industry_code(derived_rec.CUR_HIERARCHY_CUST_ORG_ID,
                                                                              derived_rec.CUR_HIERARCHY_CUST_BASE_ID,
                                                                              derived_rec.CUR_HIERARCHY_CUST_SUFX_ID);
      IF derived_rec.CUR_INDUSTRY_CDE IS NULL THEN
        derived_rec.CUR_INDUSTRY_CDE := '*';
      END IF;
    
      -- check if industry code is different       
      IF cust_rec.CUR_INDUSTRY_CDE != derived_rec.CUR_INDUSTRY_CDE THEN
      
        -- get industry business code
        derived_rec.CUR_INDUSTRY_BUSINESS_CDE := scdcommonbatch.get_ibc_code(derived_rec.CUR_INDUSTRY_CDE);
      
        IF derived_rec.CUR_INDUSTRY_BUSINESS_CDE IS NULL THEN
          derived_rec.CUR_INDUSTRY_BUSINESS_CDE := '*';
        END IF;
      
        -- check if industry business code is different       
        IF cust_rec.CUR_INDUSTRY_BUSINESS_CDE !=
           derived_rec.CUR_INDUSTRY_BUSINESS_CDE THEN
          -- get IBC profit center & dsg 
          derived_rec.CUR_IBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_ibc_pc_id(derived_rec.CUR_INDUSTRY_BUSINESS_CDE);
          derived_rec.CUR_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.CUR_IBC_PROFIT_CENTER_ID);
          v_upd_super_tag                      := TRUE;
        
          -- get MGE profit center & dsg
          IF scdcommonbatch.GetCompanyOrgID(derived_rec.ORGANIZATION_KEY_ID,
                                            TRUNC(SYSDATE),
                                            v_co_org_id) THEN
            derived_rec.CUR_MGE_PROFIT_CTR_ID         := COR_DATA_SECURITY_TAG_CUR.get_mgerels_pc_id(v_co_org_id,
                                                                                                     derived_rec.CUR_INDUSTRY_BUSINESS_CDE,
                                                                                                     derived_rec.CUR_COMPETENCY_BUSINESS_CDE);
            derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.CUR_MGE_PROFIT_CTR_ID);
          END IF;
        END IF;
      
      END IF;
    
      -- get sales terr nbr
      derived_rec.CUR_SALES_TERRITORY_NBR := scdCommonBatch.get_hiercust_slsterrnbr(derived_rec.CUR_HIERARCHY_CUST_ORG_ID,
                                                                                    derived_rec.CUR_HIERARCHY_CUST_BASE_ID,
                                                                                    derived_rec.CUR_HIERARCHY_CUST_SUFX_ID);
      -- get sales terr profit center & dsg                                                                                  
      IF derived_rec.CUR_SALES_TERRITORY_NBR IS NOT NULL THEN
        IF cust_rec.CUR_SALES_TERRITORY_NBR IS NULL OR
           cust_rec.CUR_SALES_TERRITORY_NBR !=
           derived_rec.CUR_SALES_TERRITORY_NBR THEN
          derived_rec.CUR_SLS_TERR_PROFIT_CTR_ID    := COR_DATA_SECURITY_TAG_CUR.get_slsterrnbr_pc_id(derived_rec.CUR_SALES_TERRITORY_NBR);
          derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.CUR_SLS_TERR_PROFIT_CTR_ID);
          v_upd_super_tag                           := TRUE;
        END IF;
      ELSE
        -- derived value is null
        IF cust_rec.CUR_SALES_TERRITORY_NBR IS NOT NULL THEN
          -- existing value is not null
          derived_rec.CUR_SLS_TERR_PROFIT_CTR_ID    := NULL;
          derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID := NULL;
          v_upd_super_tag                           := TRUE;
        END IF;
      END IF;
    
      -- get GAM, GBU, & GBU PC
      derived_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM := get_gam_pc_id(derived_rec.CUR_HIERARCHY_CUST_ORG_ID,
                                                                 derived_rec.CUR_HIERARCHY_CUST_BASE_ID,
                                                                 derived_rec.CUR_GBL_ACCT_CDE,
                                                                 derived_rec.CUR_GBL_BUSINESS_UNIT_CDE);
      -- get GAM dsg                                                                                  
      IF derived_rec.CUR_GBL_ACCT_CDE IS NOT NULL THEN
        IF cust_rec.CUR_GBL_ACCT_CDE IS NULL OR
           cust_rec.CUR_GBL_ACCT_CDE != derived_rec.CUR_GBL_ACCT_CDE THEN
          derived_rec.CUR_GAM_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM);
          v_upd_super_tag                      := TRUE;
        END IF;
      ELSE
        -- derived value is null
        IF cust_rec.CUR_GBL_ACCT_CDE IS NOT NULL THEN
          -- existing value is not null
          derived_rec.CUR_GAM_DATA_SECR_GRP_ID  := NULL;
          derived_rec.CUR_GBL_ACCT_CDE          := NULL;
          derived_rec.CUR_GBL_BUSINESS_UNIT_CDE := NULL;
          v_upd_super_tag                       := TRUE;
        END IF;
      END IF;
    
      IF v_upd_super_tag THEN
        derived_rec.CUR_DATA_SECURITY_TAG_ID := get_data_security_tag1(derived_rec.CUR_IBC_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_CBC_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_GAM_DATA_SECR_GRP_ID);
      
        derived_rec.SUPER_DATA_SECURITY_TAG_ID := f_get_super_tag(cust_rec.ORIG_DATA_SECURITY_TAG_ID,
                                                                  derived_rec.CUR_DATA_SECURITY_TAG_ID);
      END IF;
    
      -- update OIS data security table
      v_error_section := 'upd UPDATE ORDER_ITEM_SHIP_DATA_SECURITY table';
      UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
         SET DML_USER_ID                   = USER,
             DML_TS                        = SYSDATE,
             CUR_HIERARCHY_CUST_ORG_ID     = derived_rec.CUR_HIERARCHY_CUST_ORG_ID,
             CUR_HIERARCHY_CUST_BASE_ID    = derived_rec.CUR_HIERARCHY_CUST_BASE_ID,
             CUR_HIERARCHY_CUST_SUFX_ID    = derived_rec.CUR_HIERARCHY_CUST_SUFX_ID,
             CUR_INDUSTRY_CDE              = derived_rec.CUR_INDUSTRY_CDE,
             CUR_INDUSTRY_BUSINESS_CDE     = derived_rec.CUR_INDUSTRY_BUSINESS_CDE,
             CUR_IBC_PROFIT_CENTER_ID      = derived_rec.CUR_IBC_PROFIT_CENTER_ID,
             CUR_IBC_DATA_SECR_GRP_ID      = derived_rec.CUR_IBC_DATA_SECR_GRP_ID,
             CUR_SALES_TERRITORY_NBR       = derived_rec.CUR_SALES_TERRITORY_NBR,
             CUR_SLS_TERR_PROFIT_CTR_ID    = derived_rec.CUR_SLS_TERR_PROFIT_CTR_ID,
             CUR_SLS_TERR_DATA_SECR_GRP_ID = derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID,
             CUR_MGE_PROFIT_CTR_ID         = derived_rec.CUR_MGE_PROFIT_CTR_ID,
             CUR_MGE_PRFT_DATA_SECR_GRP_ID = derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID,
             CUR_GBL_ACCT_CDE              = derived_rec.CUR_GBL_ACCT_CDE,
             CUR_GBL_BUSINESS_UNIT_CDE     = derived_rec.CUR_GBL_BUSINESS_UNIT_CDE,
             CUR_GBL_BSNS_UNIT_PRFT_CTR_NM = derived_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM,
             CUR_GAM_DATA_SECR_GRP_ID      = derived_rec.CUR_GAM_DATA_SECR_GRP_ID,
             CUR_DATA_SECURITY_TAG_ID      = derived_rec.CUR_DATA_SECURITY_TAG_ID,
             SUPER_DATA_SECURITY_TAG_ID    = derived_rec.SUPER_DATA_SECURITY_TAG_ID
       WHERE ROWID = cust_rec.row_id;
    
      IF cust_rec.SUPER_DATA_SECURITY_TAG_ID <>
         derived_rec.SUPER_DATA_SECURITY_TAG_ID THEN
        p_upd_ois_super_tag(derived_rec.AMP_ORDER_NBR,
                            derived_rec.ORDER_ITEM_NBR,
                            derived_rec.SHIPMENT_ID,
                            derived_rec.ORGANIZATION_KEY_ID,
                            derived_rec.SUPER_DATA_SECURITY_TAG_ID);
      END IF;
    
      g_cnt := g_cnt + 1;
      IF MOD(g_cnt, k_commit_cnt) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('VT cust Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      g_errmsg := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101,
                              g_errmsg || ' in ' || v_error_section);
  END p_VT_Cust;

  -- reorg industry related fields
  PROCEDURE p_Get_Industry IS
    CURSOR indu_cur IS
      SELECT a.ROWID,
             NVL(b.ST_INDUSTRY_CODE, '*') NEW_INDUSTRY_CDE,
             NVL(c.INDUSTRY_BUSINESS_CODE, '*') NEW_INDUSTRY_BUSINESS_CDE,
             d.GIB_HYPERION_CODE NEW_IBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_CUSTOMER_SHIP_TO          b,
             GBL_INDUSTRY                  c,
             GBL_INDUSTRY_BUSINESS         d
       WHERE a.CUR_HIERARCHY_CUST_ORG_ID = b.ST_ACCT_ORG_ID
         AND a.CUR_HIERARCHY_CUST_BASE_ID = b.ST_ACCT_NBR_BASE
         AND a.CUR_HIERARCHY_CUST_SUFX_ID = b.ST_ACCT_NBR_SUFX
         AND b.ST_INDUSTRY_CODE = c.INDUSTRY_CODE
         AND a.CUR_INDUSTRY_CDE <> b.ST_INDUSTRY_CODE
         AND c.INDUSTRY_BUSINESS_CODE = d.GIB_INDUSTRY_BUSINESS_CODE;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg industry';
    g_cnt           := 0;
    FOR indu_rec IN indu_cur LOOP
      g_row_id := indu_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - industry';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_INDUSTRY_CDE          = indu_rec.NEW_INDUSTRY_CDE,
               NEW_INDUSTRY_BUSINESS_CDE = indu_rec.NEW_INDUSTRY_BUSINESS_CDE,
               IBC_PROFIT_CENTER_IND     = 1,
               NEW_IBC_PROFIT_CENTER_ID  = indu_rec.NEW_IBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = indu_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - industry';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_INDUSTRY_CDE,
             NEW_INDUSTRY_BUSINESS_CDE,
             IBC_PROFIT_CENTER_IND,
             NEW_IBC_PROFIT_CENTER_ID)
          VALUES
            (indu_rec.ROWID,
             indu_rec.NEW_INDUSTRY_CDE,
             indu_rec.NEW_INDUSTRY_BUSINESS_CDE,
             1,
             indu_rec.NEW_IBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Industry Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_Industry;

  -- reorg IBC related fields
  PROCEDURE p_Get_IBC IS
    CURSOR ibc_cur IS
      SELECT a.ROWID,
             NVL(b.INDUSTRY_BUSINESS_CODE, '*') NEW_INDUSTRY_BUSINESS_CDE,
             c.GIB_HYPERION_CODE NEW_IBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_INDUSTRY                  b,
             GBL_INDUSTRY_BUSINESS         c
       WHERE a.CUR_INDUSTRY_CDE = b.INDUSTRY_CODE
         AND a.CUR_INDUSTRY_BUSINESS_CDE <> b.INDUSTRY_BUSINESS_CODE
         AND NOT EXISTS
       (SELECT 1 -- if product identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND b.NEW_INDUSTRY_CDE IS NOT NULL)
         AND b.INDUSTRY_BUSINESS_CODE = c.GIB_INDUSTRY_BUSINESS_CODE;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg ibc';
    g_cnt           := 0;
    FOR ibc_rec IN ibc_cur LOOP
      g_row_id := ibc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - ibc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_INDUSTRY_BUSINESS_CDE = ibc_rec.NEW_INDUSTRY_BUSINESS_CDE,
               IBC_PROFIT_CENTER_IND     = 1,
               NEW_IBC_PROFIT_CENTER_ID  = ibc_rec.NEW_IBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = ibc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - ibc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_INDUSTRY_BUSINESS_CDE,
             IBC_PROFIT_CENTER_IND,
             NEW_IBC_PROFIT_CENTER_ID)
          VALUES
            (ibc_rec.ROWID,
             ibc_rec.NEW_INDUSTRY_BUSINESS_CDE,
             1,
             ibc_rec.NEW_IBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('IBC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_IBC;

  -- reorg IBC PC 
  PROCEDURE p_Get_IBC_PC IS
    CURSOR ibcpc_cur IS
      SELECT a.ROWID, b.GIB_HYPERION_CODE NEW_IBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a, GBL_INDUSTRY_BUSINESS b
       WHERE a.CUR_INDUSTRY_BUSINESS_CDE = b.GIB_INDUSTRY_BUSINESS_CODE
         AND NVL(a.CUR_IBC_PROFIT_CENTER_ID, '~') <>
             NVL(b.GIB_HYPERION_CODE, '~')
         AND NOT EXISTS
       (SELECT 1 -- if product identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND (b.NEW_INDUSTRY_BUSINESS_CDE IS NOT NULL OR
                     b.NEW_INDUSTRY_CDE IS NOT NULL));
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg CBC PC';
    g_cnt           := 0;
    FOR ibcpc_rec IN ibcpc_cur LOOP
      g_row_id := ibcpc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - ibc pc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET IBC_PROFIT_CENTER_IND    = 1,
               NEW_IBC_PROFIT_CENTER_ID = ibcpc_rec.NEW_IBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = ibcpc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - ibc pc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             IBC_PROFIT_CENTER_IND,
             NEW_IBC_PROFIT_CENTER_ID)
          VALUES
            (ibcpc_rec.ROWID, 1, ibcpc_rec.NEW_IBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('IBC PC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_IBC_PC;

  -- reorg product related fields
  PROCEDURE p_Get_Product IS
    CURSOR prod_cur IS
      SELECT a.ROWID,
             NVL(b.PRODUCT_CDE, '*') NEW_PRODUCT_CDE,
             NVL(c.PROD_BUSLN_FNCTN_ID, '*') NEW_COMPETENCY_BUSINESS_CDE,
             d.BUSLN_FNCTN_HYPERION_CODE NEW_CBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             CORPORATE_PARTS               b,
             GBL_PRODUCT                   c,
             GBL_BUSINESS_LINE_FUNCTION    d
       WHERE a.PART_KEY_ID = b.PART_KEY_ID
         AND b.PART_KEY_ID <> 0 -- default
         AND a.CUR_PRODUCT_CDE <> b.PRODUCT_CDE
         AND b.PRODUCT_CDE = c.PROD_CODE
         AND c.PROD_BUSLN_FNCTN_ID = d.BUSLN_FNCTN_ID;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg product';
    g_cnt           := 0;
    FOR prod_rec IN prod_cur LOOP
      g_row_id := prod_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - product';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_PRODUCT_CDE             = prod_rec.NEW_PRODUCT_CDE,
               NEW_COMPETENCY_BUSINESS_CDE = prod_rec.NEW_COMPETENCY_BUSINESS_CDE,
               CBC_PROFIT_CENTER_IND       = 1,
               NEW_CBC_PROFIT_CENTER_ID    = prod_rec.NEW_CBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = prod_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - product';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_PRODUCT_CDE,
             NEW_COMPETENCY_BUSINESS_CDE,
             CBC_PROFIT_CENTER_IND,
             NEW_CBC_PROFIT_CENTER_ID)
          VALUES
            (prod_rec.ROWID,
             prod_rec.NEW_PRODUCT_CDE,
             prod_rec.NEW_COMPETENCY_BUSINESS_CDE,
             1,
             prod_rec.NEW_CBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Product Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_Product;

  -- reorg CBC related fields
  PROCEDURE p_Get_CBC IS
    CURSOR cbc_cur IS
      SELECT a.ROWID,
             NVL(b.PROD_BUSLN_FNCTN_ID, '*') NEW_COMPETENCY_BUSINESS_CDE,
             c.BUSLN_FNCTN_HYPERION_CODE NEW_CBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_PRODUCT                   b,
             GBL_BUSINESS_LINE_FUNCTION    c
       WHERE a.CUR_PRODUCT_CDE = b.PROD_CODE
         AND a.CUR_PRODUCT_CDE <> '9964' -- default
         AND a.CUR_COMPETENCY_BUSINESS_CDE <> b.PROD_BUSLN_FNCTN_ID
         AND NOT EXISTS
       (SELECT 1 -- if product identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND b.NEW_PRODUCT_CDE IS NOT NULL)
         AND b.PROD_BUSLN_FNCTN_ID = c.BUSLN_FNCTN_ID;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg CBC';
    g_cnt           := 0;
    FOR cbc_rec IN cbc_cur LOOP
      g_row_id := cbc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - cbc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_COMPETENCY_BUSINESS_CDE = cbc_rec.NEW_COMPETENCY_BUSINESS_CDE,
               CBC_PROFIT_CENTER_IND       = 1,
               NEW_CBC_PROFIT_CENTER_ID    = cbc_rec.NEW_CBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = cbc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - cbc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_COMPETENCY_BUSINESS_CDE,
             CBC_PROFIT_CENTER_IND,
             NEW_CBC_PROFIT_CENTER_ID)
          VALUES
            (cbc_rec.ROWID,
             cbc_rec.NEW_COMPETENCY_BUSINESS_CDE,
             1,
             cbc_rec.NEW_CBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('CBC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_CBC;

  -- reorg CBC PC 
  PROCEDURE p_Get_CBC_PC IS
    CURSOR cbcpc_cur IS
      SELECT a.ROWID, b.BUSLN_FNCTN_HYPERION_CODE NEW_CBC_PROFIT_CENTER_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a, GBL_BUSINESS_LINE_FUNCTION b
       WHERE a.CUR_COMPETENCY_BUSINESS_CDE = b.BUSLN_FNCTN_ID
         AND NVL(a.CUR_CBC_PROFIT_CENTER_ID, '~') <>
             NVL(b.BUSLN_FNCTN_HYPERION_CODE, '~')
         AND NOT EXISTS
       (SELECT 1 -- if product identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND (b.NEW_COMPETENCY_BUSINESS_CDE IS NOT NULL OR
                     b.NEW_PRODUCT_CDE IS NOT NULL));
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg CBC PC';
    g_cnt           := 0;
    FOR cbcpc_rec IN cbcpc_cur LOOP
      g_row_id := cbcpc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - cbc pc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET CBC_PROFIT_CENTER_IND    = 1,
               NEW_CBC_PROFIT_CENTER_ID = cbcpc_rec.NEW_CBC_PROFIT_CENTER_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = cbcpc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - cbc pc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             CBC_PROFIT_CENTER_IND,
             NEW_CBC_PROFIT_CENTER_ID)
          VALUES
            (cbcpc_rec.ROWID, 1, cbcpc_rec.NEW_CBC_PROFIT_CENTER_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('CBC PC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_CBC_PC;

  -- reorg ORG PC 
  PROCEDURE p_Get_ORG_PC IS
    CURSOR orgpc_cur IS
      SELECT a.ROWID,
             b.ORG_MANAGING_PROFIT_CENTER_ID NEW_REPT_ORG_PROFIT_CTR_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_ORGS                      b,
             ORGANIZATIONS_DMN             c
       WHERE a.ORGANIZATION_KEY_ID = c.ORGANIZATION_KEY_ID
         AND c.RECORD_STATUS_CDE = 'C'
         AND c.COMPANY_ORGANIZATION_ID = b.GO_ORG_ID
         AND NVL(a.CUR_REPT_ORG_PROFIT_CTR_ID, '~') <>
             NVL(b.ORG_MANAGING_PROFIT_CENTER_ID, '~');
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg ORG PC';
    g_cnt           := 0;
    FOR orgpc_rec IN orgpc_cur LOOP
      g_row_id := orgpc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - org pc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET REPT_ORG_IND               = 1,
               NEW_REPT_ORG_PROFIT_CTR_ID = orgpc_rec.NEW_REPT_ORG_PROFIT_CTR_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = orgpc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - cbc pc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             REPT_ORG_IND,
             NEW_REPT_ORG_PROFIT_CTR_ID)
          VALUES
            (orgpc_rec.ROWID, 1, orgpc_rec.NEW_REPT_ORG_PROFIT_CTR_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('ORG PC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_ORG_PC;

  -- reorg Sales Terr Nbr 
  PROCEDURE p_Get_Sales_Terr_Nbr IS
    CURSOR stn_cur IS
      SELECT a.ROWID,
             b.SALES_TERRITORY_NBR NEW_SALES_TERRITORY_NBR,
             c.SALES_HIER_OWNING_PRFT_CTR NEW_SLS_TERR_PROFIT_CTR_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_TERRITORY_ASSIGNMENTS     b,
             GBL_SALES_TERRITORIES         c
       WHERE CUR_HIERARCHY_CUST_ORG_ID = ST_ACCT_ORG_ID
         AND CUR_HIERARCHY_CUST_BASE_ID = ST_ACCT_NBR_BASE
         AND CUR_HIERARCHY_CUST_SUFX_ID = ST_ACCT_NBR_SUFX
         AND TERRITORY_ASSIGNMENT_TYPE_CDE = 'A'
         AND b.SALES_TERRITORY_NBR = c.SALES_TERRITORY_NBR
         AND NVL(a.CUR_SALES_TERRITORY_NBR, -9999) <>
             NVL(b.SALES_TERRITORY_NBR, -9999);
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg sales terr nbr';
    g_cnt           := 0;
    FOR stn_rec IN stn_cur LOOP
      g_row_id := stn_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - sales terr nbr';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET SALES_TERRITORY_NBR_IND    = 1,
               NEW_SALES_TERRITORY_NBR    = stn_rec.NEW_SALES_TERRITORY_NBR,
               NEW_SLS_TERR_PROFIT_CTR_ID = stn_rec.NEW_SLS_TERR_PROFIT_CTR_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = stn_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - sales terr nbr';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             SALES_TERRITORY_NBR_IND,
             NEW_SALES_TERRITORY_NBR,
             NEW_SLS_TERR_PROFIT_CTR_ID)
          VALUES
            (stn_rec.ROWID,
             1,
             stn_rec.NEW_SALES_TERRITORY_NBR,
             stn_rec.NEW_SLS_TERR_PROFIT_CTR_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('SALES TERR NBR Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_Sales_Terr_Nbr;

  -- reorg Sales Terr PC 
  PROCEDURE p_Get_Sales_Terr_PC IS
    CURSOR stpc_cur IS
      SELECT a.ROWID,
             b.SALES_HIER_OWNING_PRFT_CTR NEW_SLS_TERR_PROFIT_CTR_ID
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a, GBL_SALES_TERRITORIES b
       WHERE a.CUR_SALES_TERRITORY_NBR = b.SALES_TERRITORY_NBR
         AND NVL(a.CUR_SLS_TERR_PROFIT_CTR_ID, '~') <>
             NVL(b.SALES_HIER_OWNING_PRFT_CTR, '~')
         AND NOT EXISTS
       (SELECT 1 -- if sale terr nbr identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND b.SALES_TERRITORY_NBR_IND = 1);
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg sales terr pc';
    g_cnt           := 0;
    FOR stpc_rec IN stpc_cur LOOP
      g_row_id := stpc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - sales terr pc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET SALES_TERR_PROFIT_CTR_IND  = 1,
               NEW_SLS_TERR_PROFIT_CTR_ID = stpc_rec.NEW_SLS_TERR_PROFIT_CTR_ID
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = stpc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - sales terr pc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             SALES_TERR_PROFIT_CTR_IND,
             NEW_SLS_TERR_PROFIT_CTR_ID)
          VALUES
            (stpc_rec.ROWID, 1, stpc_rec.NEW_SLS_TERR_PROFIT_CTR_ID);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
      --     IF MOD(g_cnt, k_commit_cnt) = 0 THEN
    --       COMMIT;
    --     END IF;     
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('SALES TERR PC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_Sales_Terr_PC;

  -- reorg GAM related fields
  PROCEDURE p_Get_GAM IS
    CURSOR gam_cur IS
      SELECT a.ROWID,
             b.PB_GBL_ACCT_CDE NEW_GBL_ACCT_CDE,
             c.GBL_BUSINESS_UNIT_CDE NEW_GBL_BUSINESS_UNIT_CDE,
             d.GBL_BSNS_UNIT_PRFT_CTR_NM NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GBL_ALL_CUST_PURCH_BY         b,
             GLOBAL_ACCOUNTS               c,
             GLOBAL_BUSINESS_UNITS         d
       WHERE a.CUR_HIERARCHY_CUST_ORG_ID = b.PB_ACCT_ORG_ID
         AND a.CUR_HIERARCHY_CUST_BASE_ID = b.PB_ACCT_NBR_BASE
         AND NVL(a.CUR_GBL_ACCT_CDE, '~') <> NVL(b.PB_GBL_ACCT_CDE, '~')
         AND b.PB_GBL_ACCT_CDE = c.GBL_ACCT_CDE
         AND c.GBL_BUSINESS_UNIT_CDE = d.GBL_BUSINESS_UNIT_CDE;
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg GAM';
    g_cnt           := 0;
    FOR gam_rec IN gam_cur LOOP
      g_row_id := gam_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - gam';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_GBL_ACCT_CDE              = gam_rec.NEW_GBL_ACCT_CDE,
               NEW_GBL_BUSINESS_UNIT_CDE     = gam_rec.NEW_GBL_BUSINESS_UNIT_CDE,
               GAM_PROFIT_CENTER_NAME_IND    = 1,
               NEW_GBL_BSNS_UNIT_PRFT_CTR_NM = gam_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = gam_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - gam';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_GBL_ACCT_CDE,
             NEW_GBL_BUSINESS_UNIT_CDE,
             GAM_PROFIT_CENTER_NAME_IND,
             NEW_GBL_BSNS_UNIT_PRFT_CTR_NM)
          VALUES
            (gam_rec.ROWID,
             gam_rec.NEW_GBL_ACCT_CDE,
             gam_rec.NEW_GBL_BUSINESS_UNIT_CDE,
             1,
             gam_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('GAM Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_GAM;

  -- reorg GBU related fields
  PROCEDURE p_Get_GBU IS
    CURSOR gbu_cur IS
      SELECT a.ROWID,
             b.GBL_BUSINESS_UNIT_CDE NEW_GBL_BUSINESS_UNIT_CDE,
             c.GBL_BSNS_UNIT_PRFT_CTR_NM NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a,
             GLOBAL_ACCOUNTS               b,
             GLOBAL_BUSINESS_UNITS         c
       WHERE a.CUR_GBL_ACCT_CDE = b.GBL_ACCT_CDE
         AND NVL(a.CUR_GBL_BUSINESS_UNIT_CDE, '~') <>
             NVL(c.GBL_BUSINESS_UNIT_CDE, '~')
         AND b.GBL_BUSINESS_UNIT_CDE = c.GBL_BUSINESS_UNIT_CDE
         AND NOT EXISTS
       (SELECT 1 -- if GBU identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND b.NEW_GBL_ACCT_CDE IS NOT NULL);
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg GBU';
    g_cnt           := 0;
    FOR gbu_rec IN gbu_cur LOOP
      g_row_id := gbu_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - gbu';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET NEW_GBL_BUSINESS_UNIT_CDE     = gbu_rec.NEW_GBL_BUSINESS_UNIT_CDE,
               GAM_PROFIT_CENTER_NAME_IND    = 1,
               NEW_GBL_BSNS_UNIT_PRFT_CTR_NM = gbu_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = gbu_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - gbu';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             NEW_GBL_BUSINESS_UNIT_CDE,
             GAM_PROFIT_CENTER_NAME_IND,
             NEW_GBL_BSNS_UNIT_PRFT_CTR_NM)
          VALUES
            (gbu_rec.ROWID,
             gbu_rec.NEW_GBL_BUSINESS_UNIT_CDE,
             1,
             gbu_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('GAM Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_GBU;

  -- reorg GBU PC 
  PROCEDURE p_Get_GBU_PC IS
    CURSOR gbupc_cur IS
      SELECT a.ROWID,
             b.GBL_BSNS_UNIT_PRFT_CTR_NM NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
        FROM ORDER_ITEM_SHIP_DATA_SECURITY a, GLOBAL_BUSINESS_UNITS b
       WHERE a.CUR_GBL_BUSINESS_UNIT_CDE = b.GBL_BUSINESS_UNIT_CDE
         AND NVL(a.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM, '~') <>
             NVL(b.GBL_BSNS_UNIT_PRFT_CTR_NM, '~')
         AND NOT EXISTS
       (SELECT 1 -- if GBU identified then ignore
                FROM TEMP_SHIPMENTS_DATA_SECURITY b
               WHERE b.SHIPMENTS_DATA_SECURITY_ROW_ID = a.ROWID
                 AND (b.NEW_GBL_BUSINESS_UNIT_CDE IS NOT NULL OR
                     b.NEW_GBL_ACCT_CDE IS NOT NULL));
    v_error_section VARCHAR2(100);
  BEGIN
    v_error_section := 'reorg GBU PC';
    g_cnt           := 0;
    FOR gbupc_rec IN gbupc_cur LOOP
      g_row_id := gbupc_rec.ROWID;
      BEGIN
        v_error_section := 'upd temp table - gbu pc';
        UPDATE TEMP_SHIPMENTS_DATA_SECURITY
           SET GAM_PROFIT_CENTER_NAME_IND    = 1,
               NEW_GBL_BSNS_UNIT_PRFT_CTR_NM = gbupc_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM
         WHERE SHIPMENTS_DATA_SECURITY_ROW_ID = gbupc_rec.ROWID;
      
        IF SQL%NOTFOUND THEN
          v_error_section := 'ins temp table - gbu pc';
          INSERT INTO TEMP_SHIPMENTS_DATA_SECURITY
            (SHIPMENTS_DATA_SECURITY_ROW_ID,
             GAM_PROFIT_CENTER_NAME_IND,
             NEW_GBL_BSNS_UNIT_PRFT_CTR_NM)
          VALUES
            (gbupc_rec.ROWID, 1, gbupc_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM);
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM || ' in ' || v_error_section);
      END;
    
      g_cnt := g_cnt + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('GBU PC Found: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      RAISE_APPLICATION_ERROR(-20101, SQLERRM || ' in ' || v_error_section);
  END p_Get_GBU_PC;

  -- procedure to reorg and update other OIS security related columns
  PROCEDURE p_Reorg_OIS_Data IS
    CURSOR ois_cur IS
      SELECT b.ROWID,
             AMP_ORDER_NBR,
             ORDER_ITEM_NBR,
             SHIPMENT_ID,
             ORGANIZATION_KEY_ID,
             a.NEW_INDUSTRY_CDE,
             a.NEW_INDUSTRY_BUSINESS_CDE,
             b.CUR_INDUSTRY_CDE,
             b.CUR_INDUSTRY_BUSINESS_CDE,
             a.IBC_PROFIT_CENTER_IND,
             a.NEW_IBC_PROFIT_CENTER_ID,
             b.CUR_IBC_PROFIT_CENTER_ID,
             CUR_IBC_DATA_SECR_GRP_ID,
             a.NEW_PRODUCT_CDE,
             a.NEW_COMPETENCY_BUSINESS_CDE,
             b.CUR_PRODUCT_CDE,
             b.CUR_COMPETENCY_BUSINESS_CDE,
             a.CBC_PROFIT_CENTER_IND,
             a.NEW_CBC_PROFIT_CENTER_ID,
             b.CUR_CBC_PROFIT_CENTER_ID,
             CUR_CBC_DATA_SECR_GRP_ID,
             a.REPT_ORG_IND,
             a.NEW_REPT_ORG_PROFIT_CTR_ID,
             b.CUR_REPT_ORG_PROFIT_CTR_ID,
             CUR_REPT_PRFT_DATA_SECR_GRP_ID,
             a.SALES_TERRITORY_NBR_IND,
             a.NEW_SALES_TERRITORY_NBR,
             b.CUR_SALES_TERRITORY_NBR,
             a.SALES_TERR_PROFIT_CTR_IND,
             a.NEW_SLS_TERR_PROFIT_CTR_ID,
             b.CUR_SLS_TERR_PROFIT_CTR_ID,
             CUR_SLS_TERR_DATA_SECR_GRP_ID,
             CUR_MGE_PROFIT_CTR_ID,
             CUR_MGE_PRFT_DATA_SECR_GRP_ID,
             a.NEW_GBL_ACCT_CDE,
             a.NEW_GBL_BUSINESS_UNIT_CDE,
             b.CUR_GBL_ACCT_CDE,
             b.CUR_GBL_BUSINESS_UNIT_CDE,
             a.GAM_PROFIT_CENTER_NAME_IND,
             a.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM,
             b.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM,
             CUR_GAM_DATA_SECR_GRP_ID,
             ORIG_DATA_SECURITY_TAG_ID,
             CUR_DATA_SECURITY_TAG_ID,
             SUPER_DATA_SECURITY_TAG_ID
        FROM TEMP_SHIPMENTS_DATA_SECURITY  a,
             ORDER_ITEM_SHIP_DATA_SECURITY b
       WHERE b.ROWID = a.SHIPMENTS_DATA_SECURITY_ROW_ID;
  
    derived_rec     ois_cur%ROWTYPE;
    v_error_section VARCHAR2(100);
    v_co_org_id     GBL_ORGS.GO_ORG_ID%TYPE;
    v_upd_super_tag BOOLEAN;
  BEGIN
    -- put identified re-org records into temp table
    v_error_section := 'delete temp recs';
    DELETE TEMP_SHIPMENTS_DATA_SECURITY;
    COMMIT;
  
    p_Get_Industry;
    p_Get_IBC;
    p_Get_IBC_PC;
    p_Get_Product;
    p_Get_CBC;
    p_Get_CBC_PC;
    p_Get_Org_PC;
    p_Get_Sales_Terr_Nbr;
    p_Get_Sales_Terr_PC;
    p_Get_GAM;
    p_Get_GBU;
    p_Get_GBU_PC;
  
    g_cnt := 0;
    FOR ois_rec IN ois_cur LOOP
      -- copy original value to derived columns
      v_error_section := 'set derived_rec';
      derived_rec     := ois_rec;
      v_upd_super_tag := FALSE;
    
      -- customer/IBC
      IF ois_rec.IBC_PROFIT_CENTER_IND = 1 THEN
        IF ois_rec.NEW_INDUSTRY_CDE IS NULL THEN
          derived_rec.NEW_INDUSTRY_CDE := ois_rec.CUR_INDUSTRY_CDE;
        END IF;
      
        IF ois_rec.NEW_INDUSTRY_BUSINESS_CDE IS NULL THEN
          derived_rec.NEW_INDUSTRY_BUSINESS_CDE := ois_rec.CUR_INDUSTRY_BUSINESS_CDE;
        END IF;
      
        derived_rec.CUR_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_IBC_PROFIT_CENTER_ID);
        v_upd_super_tag                      := TRUE;
      ELSE
        derived_rec.NEW_INDUSTRY_CDE          := ois_rec.CUR_INDUSTRY_CDE;
        derived_rec.NEW_INDUSTRY_BUSINESS_CDE := ois_rec.CUR_INDUSTRY_BUSINESS_CDE;
        derived_rec.NEW_IBC_PROFIT_CENTER_ID  := ois_rec.CUR_IBC_PROFIT_CENTER_ID;
      END IF;
    
      -- product/CBC
      IF ois_rec.CBC_PROFIT_CENTER_IND = 1 THEN
        IF ois_rec.NEW_PRODUCT_CDE IS NULL THEN
          derived_rec.NEW_PRODUCT_CDE := ois_rec.CUR_PRODUCT_CDE;
        END IF;
      
        IF ois_rec.NEW_COMPETENCY_BUSINESS_CDE IS NULL THEN
          derived_rec.NEW_COMPETENCY_BUSINESS_CDE := ois_rec.CUR_COMPETENCY_BUSINESS_CDE;
        END IF;
      
        derived_rec.CUR_CBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_CBC_PROFIT_CENTER_ID);
        v_upd_super_tag                      := TRUE;
      ELSE
        derived_rec.NEW_PRODUCT_CDE             := ois_rec.CUR_PRODUCT_CDE;
        derived_rec.NEW_COMPETENCY_BUSINESS_CDE := ois_rec.CUR_COMPETENCY_BUSINESS_CDE;
        derived_rec.NEW_CBC_PROFIT_CENTER_ID    := ois_rec.CUR_CBC_PROFIT_CENTER_ID;
      END IF;
    
      -- reporting org
      IF ois_rec.REPT_ORG_IND = 1 THEN
        derived_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_REPT_ORG_PROFIT_CTR_ID);
        v_upd_super_tag                            := TRUE;
      ELSE
        derived_rec.NEW_REPT_ORG_PROFIT_CTR_ID := ois_rec.CUR_REPT_ORG_PROFIT_CTR_ID;
      END IF;
    
      -- get MGE profit center & dsg     
      IF derived_rec.NEW_INDUSTRY_BUSINESS_CDE !=
         ois_rec.CUR_INDUSTRY_BUSINESS_CDE OR
         derived_rec.NEW_COMPETENCY_BUSINESS_CDE !=
         ois_rec.CUR_COMPETENCY_BUSINESS_CDE THEN
      
        IF scdcommonbatch.GetCompanyOrgID(derived_rec.ORGANIZATION_KEY_ID,
                                          TRUNC(SYSDATE),
                                          v_co_org_id) THEN
          NULL;
        END IF;
        derived_rec.CUR_MGE_PROFIT_CTR_ID         := COR_DATA_SECURITY_TAG_CUR.get_mgerels_pc_id(v_co_org_id,
                                                                                                 derived_rec.NEW_INDUSTRY_BUSINESS_CDE,
                                                                                                 derived_rec.NEW_COMPETENCY_BUSINESS_CDE);
        derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.CUR_MGE_PROFIT_CTR_ID);
        v_upd_super_tag                           := TRUE;
      END IF;
    
      -- sales terr nbr
      IF ois_rec.SALES_TERR_PROFIT_CTR_IND = 1 THEN
        derived_rec.NEW_SALES_TERRITORY_NBR       := ois_rec.CUR_SALES_TERRITORY_NBR;
        derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_SLS_TERR_PROFIT_CTR_ID);
        v_upd_super_tag                           := TRUE;
      ELSE
        IF ois_rec.SALES_TERRITORY_NBR_IND = 1 THEN
          IF NVL(derived_rec.NEW_SLS_TERR_PROFIT_CTR_ID, '~') <>
             NVL(ois_rec.CUR_SLS_TERR_PROFIT_CTR_ID, '~') THEN
            derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_SLS_TERR_PROFIT_CTR_ID);
            v_upd_super_tag                           := TRUE;
          END IF;
        ELSE
          derived_rec.NEW_SALES_TERRITORY_NBR    := ois_rec.CUR_SALES_TERRITORY_NBR;
          derived_rec.NEW_SLS_TERR_PROFIT_CTR_ID := ois_rec.CUR_SLS_TERR_PROFIT_CTR_ID;
        END IF;
      END IF;
    
      -- customer/GAM
      IF ois_rec.GAM_PROFIT_CENTER_NAME_IND = 1 THEN
        IF ois_rec.NEW_GBL_ACCT_CDE IS NULL THEN
          derived_rec.NEW_GBL_ACCT_CDE := ois_rec.CUR_GBL_ACCT_CDE;
        END IF;
      
        IF ois_rec.NEW_GBL_BUSINESS_UNIT_CDE IS NULL THEN
          derived_rec.NEW_GBL_BUSINESS_UNIT_CDE := ois_rec.CUR_GBL_BUSINESS_UNIT_CDE;
        END IF;
      
        derived_rec.CUR_GAM_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(derived_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM);
        v_upd_super_tag                      := TRUE;
      ELSE
        derived_rec.NEW_GBL_ACCT_CDE              := ois_rec.CUR_GBL_ACCT_CDE;
        derived_rec.NEW_GBL_BUSINESS_UNIT_CDE     := ois_rec.CUR_GBL_BUSINESS_UNIT_CDE;
        derived_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM := ois_rec.CUR_GBL_BSNS_UNIT_PRFT_CTR_NM;
      END IF;
    
      IF v_upd_super_tag THEN
        derived_rec.CUR_DATA_SECURITY_TAG_ID := get_data_security_tag1(derived_rec.CUR_IBC_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_CBC_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID,
                                                                       derived_rec.CUR_GAM_DATA_SECR_GRP_ID);
      
        derived_rec.SUPER_DATA_SECURITY_TAG_ID := f_get_super_tag(ois_rec.ORIG_DATA_SECURITY_TAG_ID,
                                                                  derived_rec.CUR_DATA_SECURITY_TAG_ID);
      END IF;
    
      -- update OIS data security table
      v_error_section := 'upd UPDATE ORDER_ITEM_SHIP_DATA_SECURITY table';
      UPDATE ORDER_ITEM_SHIP_DATA_SECURITY
         SET DML_USER_ID                    = USER,
             DML_TS                         = SYSDATE,
             CUR_INDUSTRY_CDE               = derived_rec.NEW_INDUSTRY_CDE,
             CUR_INDUSTRY_BUSINESS_CDE      = derived_rec.NEW_INDUSTRY_BUSINESS_CDE,
             CUR_IBC_PROFIT_CENTER_ID       = derived_rec.NEW_IBC_PROFIT_CENTER_ID,
             CUR_IBC_DATA_SECR_GRP_ID       = derived_rec.CUR_IBC_DATA_SECR_GRP_ID,
             CUR_PRODUCT_CDE                = derived_rec.NEW_PRODUCT_CDE,
             CUR_COMPETENCY_BUSINESS_CDE    = derived_rec.NEW_COMPETENCY_BUSINESS_CDE,
             CUR_CBC_PROFIT_CENTER_ID       = derived_rec.NEW_CBC_PROFIT_CENTER_ID,
             CUR_CBC_DATA_SECR_GRP_ID       = derived_rec.CUR_CBC_DATA_SECR_GRP_ID,
             CUR_REPT_ORG_PROFIT_CTR_ID     = derived_rec.NEW_REPT_ORG_PROFIT_CTR_ID,
             CUR_REPT_PRFT_DATA_SECR_GRP_ID = derived_rec.CUR_REPT_PRFT_DATA_SECR_GRP_ID,
             CUR_SALES_TERRITORY_NBR        = derived_rec.NEW_SALES_TERRITORY_NBR,
             CUR_SLS_TERR_PROFIT_CTR_ID     = derived_rec.NEW_SLS_TERR_PROFIT_CTR_ID,
             CUR_SLS_TERR_DATA_SECR_GRP_ID  = derived_rec.CUR_SLS_TERR_DATA_SECR_GRP_ID,
             CUR_MGE_PROFIT_CTR_ID          = derived_rec.CUR_MGE_PROFIT_CTR_ID,
             CUR_MGE_PRFT_DATA_SECR_GRP_ID  = derived_rec.CUR_MGE_PRFT_DATA_SECR_GRP_ID,
             CUR_GBL_ACCT_CDE               = derived_rec.NEW_GBL_ACCT_CDE,
             CUR_GBL_BUSINESS_UNIT_CDE      = derived_rec.NEW_GBL_BUSINESS_UNIT_CDE,
             CUR_GBL_BSNS_UNIT_PRFT_CTR_NM  = derived_rec.NEW_GBL_BSNS_UNIT_PRFT_CTR_NM,
             CUR_GAM_DATA_SECR_GRP_ID       = derived_rec.CUR_GAM_DATA_SECR_GRP_ID,
             CUR_DATA_SECURITY_TAG_ID       = derived_rec.CUR_DATA_SECURITY_TAG_ID,
             SUPER_DATA_SECURITY_TAG_ID     = derived_rec.SUPER_DATA_SECURITY_TAG_ID
       WHERE ROWID = ois_rec.ROWID;
    
      -- update OIS table super tag
      IF ois_rec.SUPER_DATA_SECURITY_TAG_ID <>
         derived_rec.SUPER_DATA_SECURITY_TAG_ID THEN
        p_upd_ois_super_tag(derived_rec.AMP_ORDER_NBR,
                            derived_rec.ORDER_ITEM_NBR,
                            derived_rec.SHIPMENT_ID,
                            derived_rec.ORGANIZATION_KEY_ID,
                            derived_rec.SUPER_DATA_SECURITY_TAG_ID);
      END IF;
    
      g_cnt := g_cnt + 1;
      IF MOD(g_cnt, k_commit_cnt) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('OIS Sec Rec Updated: ' || g_cnt);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('ROWID: ' || g_row_id);
      g_errmsg := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101,
                              g_errmsg || ' in ' || v_error_section);
  END p_Reorg_OIS_Data;

BEGIN
  pop_gam_lookup_table;
  pop_gbu_pc_lookup_table;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20403,
                            SQLERRM ||
                            ' error occurred in package PKG_SECURITY.init prcs');
end PKG_SECURITY;
/
