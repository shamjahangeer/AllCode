CREATE OR REPLACE PACKAGE pkg_Maint_Code_Appl_Xref AS
  /************************************************************************
  * Package:     Pkg_Maint_Code_Appl_Xref
  * Description: This package/stored pocedure is used to update the
  *              SCD_CODE_APPL_XREF table.
  *
  *-----------------------------------------------------------------------
  * Revisions Log:
  * 06/08/2006  A. Orbeta   Original Version
  * 06/30/2006          Add MRP Group and Sales Office - phase III    
  ************************************************************************/

  PROCEDURE p_add_Controllers(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_del_Controllers(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_add_MrpGroup(io_status  OUT VARCHAR2,
                           io_sqlcode OUT NUMBER,
                           io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_del_MrpGroup(io_status  OUT VARCHAR2,
                           io_sqlcode OUT NUMBER,
                           io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_add_SalesOffice(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_del_SalesOffice(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_add_SalesGroup(io_status  OUT VARCHAR2,
                             io_sqlcode OUT NUMBER,
                             io_sqlerrm OUT VARCHAR2);

  PROCEDURE p_del_SalesGroup(io_status  OUT VARCHAR2,
                             io_sqlcode OUT NUMBER,
                             io_sqlerrm OUT VARCHAR2);
END pkg_Maint_Code_Appl_Xref;
/
CREATE OR REPLACE PACKAGE BODY pkg_Maint_Code_Appl_Xref IS

  v_error_section VARCHAR2(500);
  v_status        VARCHAR2(100);
  v_sqlcode       NUMBER := 0;
  v_sqlerrm       VARCHAR2(500);
  v_days          NUMBER(5) := 0;
  v_cnt           NUMBER(5);
  New_Exception EXCEPTION;
  cax_rec SCD_CODE_APPL_XREF%ROWTYPE;

  PROCEDURE p_insert_cax_rec(io_result IN OUT NUMBER) IS
  BEGIN
    io_result       := 0;
    v_error_section := 'INS rec into SCD_CODE_APPL_XREF';
    INSERT INTO SCD_CODE_APPL_XREF
      (ORGANIZATION_KEY_ID,
       CODE_TYPE_SHORT_NM,
       GENERIC_CDE_1,
       GENERIC_CDE_2,
       SOURCE_SYSTEM_ID,
       DML_USER_ID,
       DML_TS)
    VALUES
      (cax_rec.ORGANIZATION_KEY_ID,
       cax_rec.CODE_TYPE_SHORT_NM,
       cax_rec.GENERIC_CDE_1,
       cax_rec.GENERIC_CDE_2,
       cax_rec.SOURCE_SYSTEM_ID,
       USER,
       SYSDATE);
  EXCEPTION
    WHEN OTHERS THEN
      io_result := SQLCODE;
      v_sqlerrm := SQLERRM;
  END p_insert_cax_rec;
  -------------------------------------------------------------------

  PROCEDURE p_get_days_param(io_result IN OUT NUMBER) IS
  BEGIN
    io_result := 0;
  
    IF v_days > 0 THEN
      -- this procedure has been called already once 
      -- so no need to get the param again.  
      RETURN;
    END IF;
  
    v_error_section := 'Get Days to go back param';
    SELECT TO_NUMBER(PARAMETER_FIELD)
      INTO v_days
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCDUPDAPPXREFDAYS';
  
  EXCEPTION
    WHEN OTHERS THEN
      io_result := SQLCODE;
      v_sqlerrm := SQLERRM;
  END p_get_days_param;
  -------------------------------------------------------------------  

  PROCEDURE p_add_Controllers(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_add(i_days NUMBER) IS
    -- get controller records in OIO and not in XREF table
      SELECT DISTINCT ORGANIZATION_KEY_ID,
                      CONTROLLER_UNIQUENESS_ID,
                      PRODCN_CNTRLR_CODE,
                      Scdcommonbatch.GETSOURCESYSTEMID(DATA_SOURCE_DESC) SOURCE_SYSTEM_ID
        FROM ORDER_ITEM_OPEN oio
       WHERE CONTROLLER_UNIQUENESS_ID != '*'
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = oio.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = oio.CONTROLLER_UNIQUENESS_ID
                 AND cax.GENERIC_CDE_2 = oio.PRODCN_CNTRLR_CODE
                 AND cax.SOURCE_SYSTEM_ID =
                     Scdcommonbatch.GETSOURCESYSTEMID(oio.DATA_SOURCE_DESC))
      UNION
      -- get controller records in OIS (based on date loaded) and not in XREF table  
      SELECT DISTINCT ORGANIZATION_KEY_ID,
                      CONTROLLER_UNIQUENESS_ID,
                      PRODCN_CNTRLR_CODE,
                      Scdcommonbatch.GETSOURCESYSTEMID(DATA_SOURCE_DESC) SOURCE_SYSTEM_ID
        FROM ORDER_ITEM_SHIPMENT ois
       WHERE CONTROLLER_UNIQUENESS_ID != '*'
         AND ois.DATABASE_LOAD_DATE > SYSDATE - i_days
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = ois.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = ois.CONTROLLER_UNIQUENESS_ID
                 AND cax.GENERIC_CDE_2 = ois.PRODCN_CNTRLR_CODE
                 AND cax.SOURCE_SYSTEM_ID =
                     Scdcommonbatch.GETSOURCESYSTEMID(ois.DATA_SOURCE_DESC));
    add_rec cur_add%ROWTYPE;
  
  BEGIN
    p_get_days_param(v_sqlcode);
    IF v_sqlcode != 0 THEN
      RAISE New_Exception;
    END IF;
  
    v_error_section            := 'LOOP THRU cur_add';
    cax_rec                    := NULL;
    cax_rec.CODE_TYPE_SHORT_NM := 'CONTROLLER';
    v_cnt                      := 0;
    FOR add_rec IN cur_add(v_days) LOOP
      v_error_section             := 'FETCH cur_add rec';
      cax_rec.ORGANIZATION_KEY_ID := add_rec.ORGANIZATION_KEY_ID;
      cax_rec.GENERIC_CDE_1       := add_rec.CONTROLLER_UNIQUENESS_ID;
      cax_rec.GENERIC_CDE_2       := add_rec.PRODCN_CNTRLR_CODE;
      cax_rec.SOURCE_SYSTEM_ID    := add_rec.SOURCE_SYSTEM_ID;
    
      p_insert_cax_rec(v_sqlcode);
      IF v_sqlcode != 0 THEN
        RAISE New_Exception;
      END IF;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('CONTROLLER rows added: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_Controllers [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_Controllers [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_add_Controllers;
  -------------------------------------------------------------------

  PROCEDURE p_del_Controllers(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_del IS
    -- get controller records in XREF but not in OIO and/or OIS  
      SELECT ROWID row_id
        FROM SCD_CODE_APPL_XREF
       WHERE (ORGANIZATION_KEY_ID, GENERIC_CDE_1, GENERIC_CDE_2) IN
             (SELECT ORGANIZATION_KEY_ID, GENERIC_CDE_1, GENERIC_CDE_2
                FROM SCD_CODE_APPL_XREF
               WHERE CODE_TYPE_SHORT_NM = 'CONTROLLER'
              MINUS
              SELECT *
                FROM (SELECT DISTINCT ORGANIZATION_KEY_ID,
                                      CONTROLLER_UNIQUENESS_ID,
                                      PRODCN_CNTRLR_CODE
                        FROM TEAM_ORG_SMRY sos
                       WHERE DELIVERY_SMRY_TYPE = '1'
                         AND CONTROLLER_UNIQUENESS_ID != '*'
                      UNION
                      SELECT DISTINCT ORGANIZATION_KEY_ID,
                                      CONTROLLER_UNIQUENESS_ID,
                                      PRODCN_CNTRLR_CODE
                        FROM ORDER_ITEM_OPEN oio
                       WHERE CONTROLLER_UNIQUENESS_ID != '*'));
  
  BEGIN
    v_error_section := 'LOOP THRU cur_del';
    v_cnt           := 0;
    FOR del_rec IN cur_del LOOP
      v_error_section := 'FETCH cur_del rec';
    
      DELETE FROM SCD_CODE_APPL_XREF WHERE ROWID = del_rec.row_id;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('CONTROLLER rows deleted: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_Controllers [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_Controllers [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_del_Controllers;
  -------------------------------------------------------------------

  PROCEDURE p_add_MrpGroup(io_status  OUT VARCHAR2,
                           io_sqlcode OUT NUMBER,
                           io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_add(i_days NUMBER) IS
    -- get Mrp Group records in OIO and not in XREF table
      SELECT DISTINCT ORGANIZATION_KEY_ID, MRP_GROUP_CDE
        FROM ORDER_ITEM_OPEN oio
       WHERE MRP_GROUP_CDE != '*'
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = oio.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = oio.MRP_GROUP_CDE)
      UNION
      -- get Mrp Group records in OIS (based on date loaded) and not in XREF table  
      SELECT DISTINCT ORGANIZATION_KEY_ID, MRP_GROUP_CDE
        FROM ORDER_ITEM_SHIPMENT ois
       WHERE MRP_GROUP_CDE != '*'
         AND ois.DATABASE_LOAD_DATE > SYSDATE - i_days
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = ois.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = ois.MRP_GROUP_CDE);
    add_rec cur_add%ROWTYPE;
  
  BEGIN
    p_get_days_param(v_sqlcode);
    IF v_sqlcode != 0 THEN
      RAISE New_Exception;
    END IF;
  
    v_error_section            := 'LOOP THRU cur_add';
    cax_rec                    := NULL;
    cax_rec.CODE_TYPE_SHORT_NM := 'MRPGROUP';
    v_cnt                      := 0;
    FOR add_rec IN cur_add(v_days) LOOP
      v_error_section             := 'FETCH cur_add rec';
      cax_rec.ORGANIZATION_KEY_ID := add_rec.ORGANIZATION_KEY_ID;
      cax_rec.GENERIC_CDE_1       := add_rec.MRP_GROUP_CDE;
    
      p_insert_cax_rec(v_sqlcode);
      IF v_sqlcode != 0 THEN
        RAISE New_Exception;
      END IF;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('MRPGROUP rows added: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_MrpGroup [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_MrpGroup [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_add_MrpGroup;
  -------------------------------------------------------------------

  PROCEDURE p_del_MrpGroup(io_status  OUT VARCHAR2,
                           io_sqlcode OUT NUMBER,
                           io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_del IS
    -- get Mrp Group records in XREF but not in OIO and/or OIS  
      SELECT ROWID row_id
        FROM SCD_CODE_APPL_XREF
       WHERE (ORGANIZATION_KEY_ID, GENERIC_CDE_1) IN
             (SELECT ORGANIZATION_KEY_ID, GENERIC_CDE_1
                FROM SCD_CODE_APPL_XREF
               WHERE CODE_TYPE_SHORT_NM = 'MRPGROUP'
              MINUS
              SELECT *
                FROM (SELECT DISTINCT ORGANIZATION_KEY_ID, MRP_GROUP_CDE
                        FROM INDUSTRY_CODE_SMRY ics
                       WHERE DELIVERY_SMRY_TYPE = '1'
                         AND MRP_GROUP_CDE != '*'
                      UNION
                      SELECT DISTINCT ORGANIZATION_KEY_ID, MRP_GROUP_CDE
                        FROM ORDER_ITEM_OPEN oio
                       WHERE MRP_GROUP_CDE != '*'));
  
  BEGIN
    v_error_section := 'LOOP THRU cur_del';
    v_cnt           := 0;
    FOR del_rec IN cur_del LOOP
      v_error_section := 'FETCH cur_del rec';
    
      DELETE FROM SCD_CODE_APPL_XREF WHERE ROWID = del_rec.row_id;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('MRPGROUP rows deleted: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_MrpGroup [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_MrpGroup [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_del_MrpGroup;
  -------------------------------------------------------------------  

  PROCEDURE p_add_SalesOffice(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_add(i_days NUMBER) IS
    -- get Sales Office records in OIO and not in XREF table
      SELECT DISTINCT ORGANIZATION_KEY_ID, SALES_OFFICE_CDE
        FROM ORDER_ITEM_OPEN oio
       WHERE SALES_OFFICE_CDE != '*'
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = oio.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = oio.SALES_OFFICE_CDE)
      UNION
      -- get Sales Office records in OIS (based on date loaded) and not in XREF table  
      SELECT DISTINCT ORGANIZATION_KEY_ID, SALES_OFFICE_CDE
        FROM ORDER_ITEM_SHIPMENT ois
       WHERE SALES_OFFICE_CDE != '*'
         AND ois.DATABASE_LOAD_DATE > SYSDATE - i_days
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = ois.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = ois.SALES_OFFICE_CDE);
    add_rec cur_add%ROWTYPE;
  
  BEGIN
    p_get_days_param(v_sqlcode);
    IF v_sqlcode != 0 THEN
      RAISE New_Exception;
    END IF;
  
    v_error_section            := 'LOOP THRU cur_add';
    cax_rec                    := NULL;
    cax_rec.CODE_TYPE_SHORT_NM := 'SALESOFFICE';
    v_cnt                      := 0;
    FOR add_rec IN cur_add(v_days) LOOP
      v_error_section             := 'FETCH cur_add rec';
      cax_rec.ORGANIZATION_KEY_ID := add_rec.ORGANIZATION_KEY_ID;
      cax_rec.GENERIC_CDE_1       := add_rec.SALES_OFFICE_CDE;
    
      p_insert_cax_rec(v_sqlcode);
      IF v_sqlcode != 0 THEN
        RAISE New_Exception;
      END IF;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('SALESOFFICE rows added: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_SalesOffice [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_SalesOffice [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_add_SalesOffice;
  -------------------------------------------------------------------

  PROCEDURE p_del_SalesOffice(io_status  OUT VARCHAR2,
                              io_sqlcode OUT NUMBER,
                              io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_del IS
    -- get Sales Office records in XREF but not in OIO and/or OIS  
      SELECT ROWID row_id
        FROM SCD_CODE_APPL_XREF
       WHERE (ORGANIZATION_KEY_ID, GENERIC_CDE_1) IN
             (SELECT ORGANIZATION_KEY_ID, GENERIC_CDE_1
                FROM SCD_CODE_APPL_XREF
               WHERE CODE_TYPE_SHORT_NM = 'SALESOFFICE'
              MINUS
              SELECT *
                FROM (SELECT DISTINCT ORGANIZATION_KEY_ID, SALES_OFFICE_CDE
                        FROM BUILDING_LOCATION_SMRY bls
                       WHERE DELIVERY_SMRY_TYPE = '1'
                         AND SALES_OFFICE_CDE != '*'
                      UNION
                      SELECT DISTINCT ORGANIZATION_KEY_ID, SALES_OFFICE_CDE
                        FROM ORDER_ITEM_OPEN oio
                       WHERE SALES_OFFICE_CDE != '*'));
  
  BEGIN
    v_error_section := 'LOOP THRU cur_del';
    v_cnt           := 0;
    FOR del_rec IN cur_del LOOP
      v_error_section := 'FETCH cur_del rec';
    
      DELETE FROM SCD_CODE_APPL_XREF WHERE ROWID = del_rec.row_id;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SALESOFFICE rows deleted: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_SalesOffice [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_SalesOffice [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_del_SalesOffice;
  -------------------------------------------------------------------  

  PROCEDURE p_add_SalesGroup(io_status  OUT VARCHAR2,
                             io_sqlcode OUT NUMBER,
                             io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_add(i_days NUMBER) IS
    -- get Sales Office and Sales Group records in OIO and not in XREF table
      SELECT DISTINCT ORGANIZATION_KEY_ID,
                      SALES_OFFICE_CDE,
                      SALES_GROUP_CDE
        FROM ORDER_ITEM_OPEN oio
       WHERE NOT (SALES_OFFICE_CDE = '*' AND SALES_GROUP_CDE = '*')
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = oio.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = oio.SALES_OFFICE_CDE
                 AND cax.GENERIC_CDE_2 = oio.SALES_GROUP_CDE)
      UNION
      -- get Sales Office and Sales Group records in OIS (based on date loaded) and not in XREF table  
      SELECT DISTINCT ORGANIZATION_KEY_ID,
                      SALES_OFFICE_CDE,
                      SALES_GROUP_CDE
        FROM ORDER_ITEM_SHIPMENT ois
       WHERE NOT (SALES_OFFICE_CDE = '*' AND SALES_GROUP_CDE = '*')
         AND ois.DATABASE_LOAD_DATE > SYSDATE - i_days
         AND NOT EXISTS
       (SELECT 'x'
                FROM SCD_CODE_APPL_XREF cax
               WHERE cax.ORGANIZATION_KEY_ID = ois.ORGANIZATION_KEY_ID
                 AND cax.GENERIC_CDE_1 = ois.SALES_OFFICE_CDE
                 AND cax.GENERIC_CDE_2 = ois.SALES_GROUP_CDE);
    add_rec cur_add%ROWTYPE;
  
  BEGIN
    p_get_days_param(v_sqlcode);
    IF v_sqlcode != 0 THEN
      RAISE New_Exception;
    END IF;
  
    v_error_section            := 'LOOP THRU cur_add';
    cax_rec                    := NULL;
    cax_rec.CODE_TYPE_SHORT_NM := 'SALESGROUP';
    v_cnt                      := 0;
    FOR add_rec IN cur_add(v_days) LOOP
      v_error_section             := 'FETCH cur_add rec';
      cax_rec.ORGANIZATION_KEY_ID := add_rec.ORGANIZATION_KEY_ID;
      cax_rec.GENERIC_CDE_1       := add_rec.SALES_OFFICE_CDE;
      cax_rec.GENERIC_CDE_2       := add_rec.SALES_GROUP_CDE;
    
      p_insert_cax_rec(v_sqlcode);
      IF v_sqlcode != 0 THEN
        RAISE New_Exception;
      END IF;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('SALESGROUP rows added: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_SalesGroup [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_add_SalesGroup [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_add_SalesGroup;
  -------------------------------------------------------------------

  PROCEDURE p_del_SalesGroup(io_status  OUT VARCHAR2,
                             io_sqlcode OUT NUMBER,
                             io_sqlerrm OUT VARCHAR2) IS
  
    CURSOR cur_del IS
    -- get Sales Office and Sales Group records in XREF but not in OIO and/or OIS  
      SELECT ROWID row_id
        FROM SCD_CODE_APPL_XREF
       WHERE (ORGANIZATION_KEY_ID, GENERIC_CDE_1, GENERIC_CDE_2) IN
             (SELECT ORGANIZATION_KEY_ID, GENERIC_CDE_1, GENERIC_CDE_2
                FROM SCD_CODE_APPL_XREF
               WHERE CODE_TYPE_SHORT_NM = 'SALESGROUP'
              MINUS
              SELECT *
                FROM (SELECT DISTINCT ORGANIZATION_KEY_ID,
                                      SALES_OFFICE_CDE,
                                      SALES_GROUP_CDE
                        FROM BUILDING_LOCATION_SMRY bls
                       WHERE DELIVERY_SMRY_TYPE = '1'
                         AND NOT (SALES_OFFICE_CDE = '*' AND
                              SALES_GROUP_CDE = '*')
                      UNION
                      SELECT DISTINCT ORGANIZATION_KEY_ID,
                                      SALES_OFFICE_CDE,
                                      SALES_GROUP_CDE
                        FROM ORDER_ITEM_OPEN oio
                       WHERE NOT (SALES_OFFICE_CDE = '*' AND
                              SALES_GROUP_CDE = '*')));
  
  BEGIN
    v_error_section := 'LOOP THRU cur_del';
    v_cnt           := 0;
    FOR del_rec IN cur_del LOOP
      v_error_section := 'FETCH cur_del rec';
    
      DELETE FROM SCD_CODE_APPL_XREF WHERE ROWID = del_rec.row_id;
    
      v_cnt := v_cnt + 1;
      IF MOD(v_cnt, 10000) = 0 THEN
        COMMIT;
      END IF;
    
    END LOOP;
  
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('SALESGROUP rows deleted: ' || v_cnt);
    io_status := 'OK';
  EXCEPTION
    WHEN New_Exception THEN
      io_status  := 'ABORT';
      io_sqlcode := v_sqlcode;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_SalesGroup [' ||
                    v_error_section || '] - ' || v_sqlerrm;
      ROLLBACK;
    WHEN OTHERS THEN
      io_status  := 'ABORT';
      io_sqlcode := SQLCODE;
      io_sqlerrm := 'pkg_Maint_Code_Appl_Xref.p_del_SalesGroup [' ||
                    v_error_section || '] - ' || SQLERRM;
      ROLLBACK;
  END p_del_SalesGroup;

END pkg_Maint_Code_Appl_Xref;
/
