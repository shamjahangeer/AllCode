CREATE OR REPLACE PACKAGE scd_alpha_cust_fix_hist IS
    -- -----------------------------------------------------------------------------------
    -- Purpose:  One Time Backfill of SCD Alpha Customer Key Ids
    -- -----------------------------------------------------------------------------------
    -- Created  :  06/04/2010  Bryan Houder
    -- Revisions:  06/18/2010 - Added GET_CUSTOMER_KEY_ID method. This is used when the 'real'
    -- customer id cannot successfully return a customer key id. It invokes daf_customer_utls.get_customer
    -- _key_id and adds a 'skeleton row' if the key id is not successfully found.

    -- -----------------------------------------------------------------------------------
    PROCEDURE update_order_item_shipment;

    PROCEDURE GET_CUSTOMER_KEY_ID(IO_rec_added         IN OUT NUMBER,
                                  IO_reccnt            IN OUT NUMBER,
                                  IO_CUST_KEY_ID       IN OUT NUMBER,
                                  I_CUST_NBR           IN VARCHAR2,
                                  I_SALES_ORGID        IN VARCHAR2,
                                  I_DIST_CHANNEL       IN VARCHAR2,
                                  I_ORGID              IN VARCHAR2,
                                  I_SRC_SYSTEM_ID      IN NUMBER,
                                  I_CUST_NUM_TYPE      IN VARCHAR2,
                                  I_POINT_IN_TIME_FLAG IN VARCHAR2,
                                  I_SAP_TEMPLATE_IND   IN NUMBER);


END scd_alpha_cust_fix_hist;
/
CREATE OR REPLACE PACKAGE BODY scd_alpha_cust_fix_hist AS
    ----------------------------------------------------------------------------------------------------
    PROCEDURE update_order_item_shipment IS
        subroutine_exception EXCEPTION;
        PRAGMA EXCEPTION_INIT(subroutine_exception, -20101);
        v_error_section VARCHAR2(50) := NULL;

        v_status  VARCHAR2(100);
        v_sqlcode NUMBER(10);
        v_sqlerrm VARCHAR2(200);

        v_commit_count     NUMBER := 0;
        v_reccnt           NUMBER := 0;
        v_rec_added        NUMBER := 0;
        v_invalid_cust_cnt NUMBER := 0;
        v_temp_ans         NUMBER;
        v_upd_ind          VARCHAR2(1) := 0;


        k_cust_number_type     VARCHAR2(1) := cor_customer.c_base_sufx_number;
        k_point_in_time_flag   VARCHAR2(3) := 'GC'; -- global current
        k_distribution_channel VARCHAR2(3) := 'MIN';
        k_init_def_cust_key_id order_item_shipment.sold_to_customer_key_id%TYPE := 9999999999;

        v_source_system_id NUMBER;

        v_organization_id              order_item_shipment.sales_organization_id%TYPE;
        v_customer_id                  order_item_shipment.sbmt_sold_to_customer_id%TYPE;
        v_real_cust_id                 order_item_shipment.sbmt_sold_to_customer_id%TYPE;
        v_customer_key_id              order_item_shipment.sold_to_customer_key_id%TYPE;
        v_ship_to_customer_key_id      order_item_shipment.ship_to_customer_key_id%TYPE;
        v_sold_to_customer_key_id      order_item_shipment.sold_to_customer_key_id%TYPE;
        v_hierarchy_customer_key_id    order_item_shipment.hierarchy_customer_key_id%TYPE;
        v_ultimate_end_customer_key_id order_item_shipment.ultimate_end_customer_key_id%TYPE;
        v_distribution_channel_cde     order_item_shipment.distribution_channel_cde%TYPE;
        v_sap_template_ind             costed_adr43_submissions.sap_template_ind%TYPE;

        -- added for performance
        CURSOR get_cust_cur IS -- list of customer accounts
            SELECT sub.sap_template_ind
                  ,dtl.sbmt_sold_to_customer_id customer_id
                  ,sub.sold_to_organization_id organization_id
                  ,sub.sap_cust_restatement_ind
                  ,0 suffix_ind
                  ,dtl.distribution_channel_cde
              FROM scd.order_item_shipment      dtl
                  ,ssa.costed_adr43_submissions sub
             WHERE sub.data_source_id = dtl.data_src_id
               AND sub.source_id = dtl.source_id
               AND sub.expiration_dt IS NULL
               AND dtl.sold_to_customer_key_id = k_init_def_cust_key_id
               AND dtl.sbmt_sold_to_customer_id IS NOT NULL
            UNION
            SELECT sub.sap_template_ind
                  ,dtl.sbmt_customer_acct_nbr -- ship_to
                  ,sub.ship_to_organization_id organization_id
                  ,sub.sap_cust_restatement_ind
                  ,1 suffix_ind
                  ,dtl.distribution_channel_cde
              FROM scd.order_item_shipment      dtl
                  ,ssa.costed_adr43_submissions sub
             WHERE sub.data_source_id = dtl.data_src_id
               AND sub.source_id = dtl.source_id
               AND sub.expiration_dt IS NULL
               AND dtl.ship_to_customer_key_id = k_init_def_cust_key_id
               AND dtl.sbmt_customer_acct_nbr IS NOT NULL
            UNION
            SELECT sub.sap_template_ind
                  ,dtl.ultimate_end_customer_id
                  ,sub.sold_to_organization_id organization_id
                  ,sub.sap_cust_restatement_ind
                  ,0 suffix_ind
                  ,dtl.distribution_channel_cde
              FROM scd.order_item_shipment      dtl
                  ,ssa.costed_adr43_submissions sub
             WHERE sub.data_source_id = dtl.data_src_id
               AND sub.source_id = dtl.source_id
               AND sub.expiration_dt IS NULL
               AND dtl.ultimate_end_customer_key_id = k_init_def_cust_key_id
               AND dtl.ultimate_end_customer_id IS NOT NULL
             ORDER BY 1
                     ,2
                     ,3;

/*        CURSOR shp_cust_cur IS -- shipments
            SELECT dtl.*
                  ,dtl.ROWID
                  ,sub.sold_to_organization_id
                  ,sub.ship_to_organization_id
              FROM scd.order_item_shipment      dtl
                  ,ssa.costed_adr43_submissions sub
             WHERE sub.data_source_id = dtl.data_src_id
               AND sub.source_id = dtl.source_id
               AND sub.expiration_dt IS NULL
               AND (dtl.sold_to_customer_key_id = k_init_def_cust_key_id OR
                   dtl.ship_to_customer_key_id = k_init_def_cust_key_id OR
                   dtl.ultimate_end_customer_key_id = k_init_def_cust_key_id)
             ORDER BY sbmt_sold_to_customer_id
                     ,sbmt_customer_acct_nbr -- ship_to
                     ,ultimate_end_customer_id;*/

    BEGIN
        dbms_output.put_line('START TIME: ' || to_char(SYSDATE, 'YYYY-MM-DD HH24:MI.SS'));
        dbms_output.put_line('.');

        --v_error_section := 'BACKOUT DATA';
        --DELETE FROM scd.temp_hist_alpha_cust_helper;
        --COMMIT;

        v_error_section := 'LOOP THROUGH GET CUST ';
        FOR get_cust_rec IN get_cust_cur
        LOOP

            v_error_section            := 'INITIALIZE VARIABLES';
            v_organization_id          := get_cust_rec.organization_id;
            v_distribution_channel_cde := get_cust_rec.distribution_channel_cde;
            v_sap_template_ind         := get_cust_rec.sap_template_ind;

            v_error_section := 'CALCULATE CUSTOMER ID';
            IF get_cust_rec.sap_cust_restatement_ind = 0
            THEN
                v_customer_id := lpad(substr(get_cust_rec.customer_id, 1, 8), 8, '0'); -- base
                IF get_cust_rec.suffix_ind = 1
                THEN
                    v_customer_id := v_customer_id || rpad(nvl(substr(get_cust_rec.customer_id, 9, 2), '0'), 2, '0'); -- sufx
                END IF;
            ELSE
                v_customer_id := substr(lpad(get_cust_rec.customer_id, 35, '0'), -8); -- base
                IF get_cust_rec.suffix_ind = 1
                THEN
                    v_customer_id := v_customer_id || '00'; -- sufx
                END IF;
            END IF;

            v_error_section := 'GET SOURCE SYSTEM ID';
            IF get_cust_rec.sap_template_ind = 1
            THEN
                v_source_system_id := 1;
            ELSE
                BEGIN
                    SELECT source_system_id
                      INTO v_source_system_id
                      FROM source_systems
                     WHERE customer_org_ind = 1
                       AND organization_id = v_organization_id;
                EXCEPTION
                    WHEN no_data_found THEN
                        raise_application_error(-20001
                                               ,'SCD_ALPHA_CUST_FIX_HIST.UPDATE_ORDER_ITEM_SHIPMENT Org id not in SOURCE_SYSTEMS:' ||
                                                ' => ORG=' || v_organization_id || ' => DIST=' ||
                                                v_distribution_channel_cde);
                END;
            END IF;

            v_error_section := 'CALL CUSTOMER KEY ID PROC';

            GET_CUSTOMER_KEY_ID(v_rec_added
                               ,v_reccnt
                               ,v_customer_key_id
                               ,v_customer_id
                               ,NULL
                               ,NVL(v_distribution_channel_cde, k_distribution_channel)
                               ,v_organization_id
                               ,v_source_system_id
                               ,k_cust_number_type
                               ,k_point_in_time_flag
                               ,v_sap_template_ind);

            IF v_customer_key_id <> 0 -- key id found or added
            THEN
                v_error_section := 'LOAD ALPHA CUST TABLE';
                INSERT INTO scd.temp_hist_alpha_cust_helper
                    (sap_template_ind
                    ,customer_id
                    ,organization_id
                    ,customer_key_id
                    ,distribution_channel_cde
                    ,customer_suffix_nbr_ind)
                VALUES
                    (get_cust_rec.sap_template_ind
                    ,get_cust_rec.customer_id
                    ,get_cust_rec.organization_id
                    ,v_customer_key_id
                    ,v_distribution_channel_cde
                    ,get_cust_rec.suffix_ind);

                v_commit_count := v_commit_count + 1;

                IF v_commit_count > 1000
                THEN
                    COMMIT;
                    v_commit_count := 0;
                END IF;
            END IF;

        END LOOP; -- GET_CUST_CUR

        dbms_output.put_line('# OF CUSTOMERS ADDED: ' || v_rec_added);
        dbms_output.put_line('# OF CUSTOMER FOUND: ' || v_reccnt);

        COMMIT;
        v_commit_count := 0;
        v_reccnt       := 0;

        v_error_section := 'ANALYZE ALPHA CUST TABLE';
        scd.analyze_scd_table('TEMP_HIST_ALPHA_CUST_HELPER', 'ESTIMATE');  

        /***********************************************************************************/
        /*v_error_section := 'OPEN SHP_CUST_CUR';
        FOR SHP_CUST_REC IN SHP_CUST_CUR
        LOOP

            V_ERROR_SECTION            := 'GET SOLD_TO CUST KEY ID';
            V_CUSTOMER_ID              := SHP_CUST_REC.SBMT_SOLD_TO_CUSTOMER_ID;
            V_ORGANIZATION_ID          := SHP_CUST_REC.sold_to_organization_id;
            v_distribution_channel_cde := SHP_CUST_REC.DISTRIBUTION_CHANNEL_CDE;

            -- join to temp table to get cust key
            SELECT COUNT(1)
                  ,MAX(a.CUSTOMER_KEY_ID)
              INTO V_TEMP_ANS
                  ,v_sold_to_customer_key_id
              FROM SCD.TEMP_HIST_ALPHA_CUST_HELPER a
             WHERE a.CUSTOMER_ID = V_CUSTOMER_ID
               AND a.ORGANIZATION_ID = V_ORGANIZATION_ID
               AND NVL(A.DISTRIBUTION_CHANNEL_CDE, k_distribution_channel) =
                   NVL(v_distribution_channel_cde, k_distribution_channel)
               AND A.CUSTOMER_SUFFIX_NBR_IND = 0;

            IF V_TEMP_ANS = 1 -- record found
            THEN
                V_UPD_IND := 1;
            ELSE
                v_sold_to_customer_key_id := K_INIT_DEF_CUST_KEY_ID;
            END IF;

            V_ERROR_SECTION            := 'GET SHIP_TO CUST KEY ID';
            V_CUSTOMER_ID              := SHP_CUST_REC.SBMT_CUSTOMER_ACCT_NBR;
            V_ORGANIZATION_ID          := SHP_CUST_REC.ship_to_organization_id;
            v_distribution_channel_cde := SHP_CUST_REC.DISTRIBUTION_CHANNEL_CDE;

            -- join to temp table to get cust key
            SELECT COUNT(1)
                  ,MAX(a.CUSTOMER_KEY_ID)
              INTO V_TEMP_ANS
                  ,v_ship_to_customer_key_id
              FROM SCD.TEMP_HIST_ALPHA_CUST_HELPER a
             WHERE a.CUSTOMER_ID = V_CUSTOMER_ID
               AND a.ORGANIZATION_ID = V_ORGANIZATION_ID
               AND NVL(A.DISTRIBUTION_CHANNEL_CDE, k_distribution_channel) =
                   NVL(v_distribution_channel_cde, k_distribution_channel)
               AND A.CUSTOMER_SUFFIX_NBR_IND = 1;

            IF V_TEMP_ANS = 1 -- record found
            THEN
                V_UPD_IND := 1;
            ELSE
                v_ship_to_customer_key_id := K_INIT_DEF_CUST_KEY_ID;
            END IF;

            V_ERROR_SECTION            := 'GET ULTIMATE CUST KEY ID';
            V_CUSTOMER_ID              := SHP_CUST_REC.ULTIMATE_END_CUSTOMER_ID;
            V_ORGANIZATION_ID          := SHP_CUST_REC.sold_to_organization_id;
            v_distribution_channel_cde := SHP_CUST_REC.DISTRIBUTION_CHANNEL_CDE;

            -- join to temp table to get cust key
            SELECT COUNT(1)
                  ,MAX(a.CUSTOMER_KEY_ID)
              INTO V_TEMP_ANS
                  ,v_ultimate_end_customer_key_id
              FROM SCD.TEMP_HIST_ALPHA_CUST_HELPER a
             WHERE a.CUSTOMER_ID = V_CUSTOMER_ID
               AND a.ORGANIZATION_ID = V_ORGANIZATION_ID
               AND NVL(A.DISTRIBUTION_CHANNEL_CDE, k_distribution_channel) =
                   NVL(v_distribution_channel_cde, k_distribution_channel)
               AND A.CUSTOMER_SUFFIX_NBR_IND = 0;

            IF V_TEMP_ANS = 1 -- record found
            THEN
                V_UPD_IND := 1;
            ELSE
                v_ultimate_end_customer_key_id := K_INIT_DEF_CUST_KEY_ID;
            END IF;


            V_ERROR_SECTION := 'UPDATE CUST KEY IDS';
            IF V_UPD_IND = 1 -- at least one of the customer key ids found
            THEN
                IF SHP_CUST_REC.HIERARCHY_CUSTOMER_IND = 1
                THEN
                    v_hierarchy_customer_key_id := v_sold_to_customer_key_id;
                ELSE
                    v_hierarchy_customer_key_id := v_ship_to_customer_key_id;
                END IF;

                UPDATE scd.order_item_shipment
                   SET sold_to_customer_key_id      = v_sold_to_customer_key_id
                      ,ship_to_customer_key_id      = v_ship_to_customer_key_id
                      ,hierarchy_customer_key_id    = v_hierarchy_customer_key_id
                      ,ultimate_end_customer_key_id = v_ultimate_end_customer_key_id
                 WHERE ROWID = SHP_CUST_REC.ROWID;

                V_COMMIT_COUNT := V_COMMIT_COUNT + 1;

                IF V_COMMIT_COUNT > 500
                THEN
                    COMMIT;
                    V_COMMIT_COUNT := 0;
                END IF;

                V_RECCNT  := V_RECCNT + 1;
                V_UPD_IND := 0;
            ELSE
                V_INVALID_CUST_CNT := V_INVALID_CUST_CNT + 1;
            END IF;

        END LOOP; -- SHP_CUST_CUR
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('# OF ORDER_ITEM_SHIPMENT RECORDS UPDATED: ' || V_RECCNT);
        DBMS_OUTPUT.PUT_LINE('# OF ORDER_ITEM_SHIPMENT RECORDS INVALID: ' || V_INVALID_CUST_CNT);*/

        /***********************************************************************************/
        -- Cleanup remaining defaults and analyze order_item_shipment
/*        v_error_section := 'SET KEY_IDS TO NULL'; --Clean up Key_Ids

        UPDATE scd.order_item_shipment c
        SET c.ultimate_end_customer_key_id = NULL
        WHERE c.ultimate_end_customer_key_id = k_init_def_cust_key_id;

        COMMIT;

        UPDATE scd.order_item_shipment c
        SET c.hierarchy_customer_key_id = NULL
        WHERE c.hierarchy_customer_key_id = k_init_def_cust_key_id;

        COMMIT;
        
        UPDATE scd.order_item_shipment c
        SET c.sold_to_customer_key_id = NULL
        WHERE c.sold_to_customer_key_id = k_init_def_cust_key_id;
        
        COMMIT;
        
        UPDATE scd.order_item_shipment c
        SET c.ship_to_customer_key_id = NULL
        WHERE c.ship_to_customer_key_id = k_init_def_cust_key_id;
        
        COMMIT;
        
         v_error_section := 'ANALYZE ORDER_ITEM_SHIPMENT TABLE';
         scd.analyze_scd_table('ORDER_ITEM_SHIPMENT', 'ESTIMATE');*/
        
        /***********************************************************************************/

        dbms_output.put_line('.');
        dbms_output.put_line('END TIME: ' || to_char(SYSDATE, 'YYYY-MM-DD HH24:MI.SS'));

    EXCEPTION
        WHEN subroutine_exception THEN
            ROLLBACK;
            raise_application_error(-20101, 'appl abend');
        WHEN OTHERS THEN
            dbms_output.put_line('ABORT END TIME: ' || to_char(SYSDATE, 'YYYY-MM-DD HH24:MI.SS'));
            raise_application_error(-20001
                                   ,'SCD_ALPHA_CUST_FIX_HIST.UPDATE_ORDER_ITEM_SHIPMENT execution error at code section ' ||
                                    v_error_section || ': ' || SQLERRM || ' => ORG=' || v_organization_id || ' CUST=' ||
                                    v_customer_id || ' SRC SYSTEM=' || v_source_system_id);


    END update_order_item_shipment;
    ----------------------------------------------------------------------------------------------------
    PROCEDURE GET_CUSTOMER_KEY_ID(IO_rec_added         IN OUT NUMBER,
                                  IO_reccnt            IN OUT NUMBER,
                                  IO_CUST_KEY_ID       IN OUT NUMBER,
                                  I_CUST_NBR           IN VARCHAR2,
                                  I_SALES_ORGID        IN VARCHAR2,
                                  I_DIST_CHANNEL       IN VARCHAR2,
                                  I_ORGID              IN VARCHAR2,
                                  I_SRC_SYSTEM_ID      IN NUMBER,
                                  I_CUST_NUM_TYPE      IN VARCHAR2,
                                  I_POINT_IN_TIME_FLAG IN VARCHAR2,
                                  I_SAP_TEMPLATE_IND   IN NUMBER) IS
        V_ERROR_SECTION VARCHAR2(50);
    BEGIN

        --   DAF_DISPLAY.PUT_REC('daf_dr00043_validate.get_customer_key_id',
        --                       I_CUST_NBR || '/' || I_ORGID || '/' ||
        --                       I_SALES_ORGID || '/' || I_SRC_SYSTEM_ID || '/' ||
        --                       I_CUST_NUM_TYPE || '/' || I_DIST_CHANNEL || '/' ||
        --                       I_POINT_IN_TIME_FLAG);
        IF (I_SAP_TEMPLATE_IND = 1)
        THEN
            V_ERROR_SECTION := 'ADD SAP CUSTOMER KEY ID';
            IF NOT (SCD_Customer_Edit.GET_CUSTOMER_KEY_ID(IO_CUST_KEY_ID
                                                         ,I_CUST_NBR
                                                         ,I_ORGID
                                                         ,I_SRC_SYSTEM_ID
                                                         ,I_CUST_NUM_TYPE
                                                         ,I_POINT_IN_TIME_FLAG
                                                         ,I_DIST_CHANNEL))
            THEN
                -- add skeleton row
                V_ERROR_SECTION := 'ADD SAP SKELETON ROW';
                IO_rec_added    := IO_rec_added + 1;
                IF (SCD_Customer_Edit.ADD_SKELETON_ROW(IO_CUST_KEY_ID
                                                      ,I_SRC_SYSTEM_ID
                                                      ,I_SALES_ORGID
                                                      ,I_ORGID
                                                      ,I_CUST_NBR
                                                      ,I_DIST_CHANNEL
                                                      ,I_CUST_NUM_TYPE
                                                      ,I_POINT_IN_TIME_FLAG))
                THEN
                    --DAF_EDIT.INSERT_EDIT_VIOLATION(I_EDIT_RULE2, IO_CUST_KEY_ID || '/' || I_ORGID || '/' || I_CUST_NBR);
                    dbms_output.put_line('CUST ADDED => ORG=' || I_ORGID || ' CUST=' || I_CUST_NBR || ' SRC_SYSTEM=' ||
                                         I_SRC_SYSTEM_ID || ' DIST=' || I_DIST_CHANNEL);
                ELSE
                    --DAF_EDIT.INSERT_EDIT_VIOLATION(I_EDIT_RULE1, I_ORGID || '/' || I_CUST_NBR);
                    IO_CUST_KEY_ID := 0;
                    dbms_output.put_line('ERROR ADDING CUST => ORG=' || I_ORGID || ' CUST=' || I_CUST_NBR ||
                                         ' SRC_SYSTEM=' || I_SRC_SYSTEM_ID || ' DIST=' || I_DIST_CHANNEL);
                END IF;
            ELSE
                IO_reccnt := IO_reccnt + 1;
            END IF;
        ELSE
            V_ERROR_SECTION := 'ADD NON-SAP CUSTOMER KEY ID';
            IF NOT (SCD_Customer_Edit.GET_CUSTOMER_KEY_ID(IO_CUST_KEY_ID
                                                         ,I_CUST_NBR
                                                         ,I_ORGID
                                                         ,I_SRC_SYSTEM_ID
                                                         ,I_CUST_NUM_TYPE
                                                         ,I_POINT_IN_TIME_FLAG
                                                         ,'MIN'))
            THEN
                -- add skeleton row
                V_ERROR_SECTION := 'ADD NON-SAP SKELETON ROW';

                IF (SCD_Customer_Edit.ADD_SKELETON_ROW(IO_CUST_KEY_ID
                                                      ,I_SRC_SYSTEM_ID
                                                      ,'0000'
                                                      ,I_ORGID
                                                      ,I_CUST_NBR
                                                      ,NULL
                                                      ,I_CUST_NUM_TYPE
                                                      ,I_POINT_IN_TIME_FLAG))
                THEN
                    --DAF_EDIT.INSERT_EDIT_VIOLATION(I_EDIT_RULE2, IO_CUST_KEY_ID || '/' || I_ORGID || '/' || I_CUST_NBR);
                    dbms_output.put_line('CUST ADDED => ORG=' || I_ORGID || ' CUST=' || I_CUST_NBR || ' SRC_SYSTEM=' ||
                                         I_SRC_SYSTEM_ID || ' DIST=' || I_DIST_CHANNEL);
                ELSE
                    --DAF_EDIT.INSERT_EDIT_VIOLATION(I_EDIT_RULE1, I_ORGID || '/' || I_CUST_NBR);
                    dbms_output.put_line('ERROR ADDING CUST => ORG=' || I_ORGID || ' CUST=' || I_CUST_NBR ||
                                         ' SRC_SYSTEM=' || I_SRC_SYSTEM_ID || ' DIST=' || I_DIST_CHANNEL);
                    IO_CUST_KEY_ID := 0;
                END IF;
            END IF;
        END IF;
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            --LOG_ABORT(SQLCODE, SQLERRM, V_ERROR_SECTION, 'DAF_DR00043_VALIDATE.GET_CUSTOMER_KEY_ID');
            RAISE_APPLICATION_ERROR(-20101, 'Abort: get_customer_key_id  SECTION= ' || V_ERROR_SECTION);
    END GET_CUSTOMER_KEY_ID;
    -----------------------------------------------------------------------------------

END scd_alpha_cust_fix_hist;
/
