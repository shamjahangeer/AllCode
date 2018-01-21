CREATE OR REPLACE PACKAGE Pkg_Edit_Temp_Order_Daf AS
  /*********************************************************************/
  /* PACKAGE:     PKG_EDIT_TEMP_ORDER                                  */
  /* DESCRIPTION:                                                      */
  /*                                                                   */
  /*                                                                   */
  /* PROCEDURES:  P_EDIT_TEMP_ORDER_ITEM                               */
  /*              P_CALC_NBR_EXPEDITES                                 */
  /*              P_WRITE_PROCESS_LOG                                  */
  /* AUTHOR:      LESA HARTMAN                                         */
  /*                                                                   */
  /*********************************************************************/
  /* MODIFICATION LOG:                                                 */
  /*                                                                   */
  /*  11/25/96 -  NEW PROGRAM                              L. HARTMAN  */
  /*                                                         (         */
  /*  04/07/97 -  RELEASE 2.0 - ADD INTERCO_SHIPMENT_IND   J. FASSANO  */
  /*              BY SELECTING GBL_MARKETING_ORG             (CAI)     */
  /*                                                                   */
  /*  12/01/97 -  RELEASE 2.1 - update ww_account_nbr_base   J. Karr   */
  /*              and ww_account_nbr_suffix from             (CAI)     */
  /*              gbl_customer_purchase_by for non-domestic only       */
  /*                                                                   */
  /*  12/01/97 -  RELEASE 2.1 - update number of expedites   J. Karr   */
  /*              if current_expedite_date has changed       (CAI)     */
  /*              (applies to both OPENS and SHIPMENTS)                */
  /*                                                                   */
  /*  02/17/98 -  RELEASE 2.1 - Modification Number (1)      Tanveer   */
  /*              Using the customer account number populate industry  */
  /*              code (applies to both OPENS and SHIPMENTS)           */
  /*                                                                   */
  /*  03/19/98 -  RELEASE 2.2 - Modification Number (1)      LPZ       */
  /*              Added MFG_GROUP_ORG_CODE, MFG_DIV_ORG_CODE, and      */
  /*              MFG_BUILDING_NBR edits                               */
  /*                                                                   */
  /*  05/05/98 -  RELEASE 2.3 -                              LPZ       */
  /*              Added PRI_WW_ACCOUNT_NBR_BASE and                    */
  /*                PRI_WW_ACCOUNT_NBR_SUFFIX edits                    */
  /*                                                                   */
  /*  01/22/99 -  Commented out writing to process log when invalid    */
  /*              mfg. org encountered.                      (Tanveer) */
  /*                                                                   */
  /*  10/07/99 -  RELEASE 4.2 -                 (Robin Jovanelly/Alex) */
  /*              Added sanity check for the booking and billing amts  */
  /*              if > $1M and qty < 1000, flag it                     */
  /*                                                                   */
  /*  11/25/99 -  RELEASE 5.0 -                                  Alex) */
  /*              REMAINING_QTY_TO_SHIP, QUANTITY_SHIPPED, IBC edits   */
  /*                                                                   */
  /*  11/30/99 -  Release 5.0                      ALEX  */
  /*              Added fields for industry view AND Fiscal Dates        */
  /*          (REMAINING_QTY_TO_SHIP,FISCAL_MONTH,FISCAL_YEAR,     */
  /*              FISCAL_QUARTER,INDUSTRY_BUSINESS_CODE)               */
  /*                                                                   */
  /*  12/09/99 -  Release 5.0                      ALEX  */
  /*          Removed PRODUCT_LINE_CODE,PRODUCT_FAMILY_CODE fields.*/
  /*                                                                   */
  /*  04/14/00 -  Release 5.0                      ALEX  */
  /*          Fixed bug that cause the vgc_prev_mfg_group_code AND   */
  /*          vgc_prev_mfg_div_code to be null when mfg_div_code is*/
  /*        not found in scorecard_org table.              */
  /*  09/28/00 -  Release 5.1                      ALEX  */
  /*          Removed logic that bypass record if product_code is  */
  /*        '9964' and part_nbr is '000000000'           */
  /*  04/19/01 -  Release 6.0  DSCD rewrite            Alex  */
  /*  10/19/01 -  Added logic to derive budget_rate_bk/bl_amt.   Alex  */
  /*  04/17/02 -  Added logic for CBC.                 Alex  */
  /*  04/30/02 -  Added logic to derive                                */
  /*              gfc_extended_true_amp_cost.                Jeff/Alex */
  /*  05/21/02 -  Added logic to derive prod_mgr_globad_id      Alex */
  /*  07/08/02 -  Display TOIS_SEQ when critical DB error occur.  Alex */
  /*  01/17/03 -  Add logic get the reporting org in calc cost  Alex */
  /*  03/20/03 -  Add logic to set expedite_date columns to null  Alex */
  /*  03/31/03 -  Ignore Cost_calc warning flags error          Alex */
  /*  04/09/03 -  Get Mfg_source_id from GCS table.       Alex *.
  /*  08/18/03 -  Add previous logic on getting MFG Source ID   Alex */
  /*  08/27/03 -  Optimize program by avoiding unecessary use     Alex */
  /*          nvl,to_char, building of reckey statement.       */
  /*  12/17/04 -  Alpha Part project.               Alex */
  /*  09/22/05 -  Use new APN compliant SSAC0085_Cost_Calculator  Alex */
  --  10/10/07    Add logic for data security.
  --  10/12/11 -  Add cost calculator fields for margins changes.
  /*********************************************************************/

  PROCEDURE P_EDIT_TEMP_ORDER_ITEM(OIS        IN OUT NOCOPY TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE,
                                   VON_RESULT OUT NUMBER);

  FUNCTION get_disc_ops_cde_backlog(i_adr43 IN ADR43_BACKLOGS%ROWTYPE)
    RETURN NUMBER;

END Pkg_Edit_Temp_Order_Daf;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Edit_Temp_Order_Daf AS
  /* ASSUMING THE FOLLOWING GLOBALS DECLARED BY DRIVING PROCEDURE: */
  vgc_bypassed_message    CHAR(50);
  vgc_bypassed_value      CHAR(20);
  vgc_bypassed_rec_key    VARCHAR2(80);
  vgn_organization_key_id ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE;
  vgc_amp_order_nbr       ORDER_ITEM_SHIPMENT.AMP_ORDER_NBR%TYPE;
  vgc_order_item_nbr      ORDER_ITEM_SHIPMENT.ORDER_ITEM_NBR%TYPE;
  vgc_shipment_id         ORDER_ITEM_SHIPMENT.SHIPMENT_ID%TYPE;
  vgn_bypassed_seq_nbr    NUMBER(6) := 0;
  vgn_log_line            NUMBER := 0;

  vgn_days_early            NUMBER(2);
  vgn_days_late             NUMBER(2);
  vgn_nbr_of_expedites      ORDER_ITEM_SHIPMENT.NBR_OF_EXPEDITES%TYPE;
  vgd_current_expedite_date ORDER_ITEM_SHIPMENT.CURRENT_EXPEDITE_DATE%TYPE;
  vgb_first_time            BOOLEAN := TRUE;

  /* generic elements for calling procedures */
  vgc_job_id temp_order_item_shipment.DML_ORACLE_ID%TYPE;
  vgn_result NUMBER;

  /* industry fiscal globals */
  vgn_fiscal_month       NUMBER(2) := NULL;
  vgn_fiscal_year        NUMBER(4) := NULL;
  vgc_fiscal_quarter     VARCHAR(2) := NULL;
  vgd_prev_calendar_date DATE := TO_DATE('01-JAN-1900', 'DD-MON-YYYY');

  -- mfg global vars
  vgn_prev_mfg_org_kid TEMP_ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE;
  vgc_prev_rptorg_id   MANUFACTURING_SOURCE_ORGS.ORG_ID%TYPE := '!!!!';
  vgn_prev_part_key_id TEMP_ORDER_ITEM_SHIPMENT.PART_KEY_ID%TYPE := -1;
  vgd_prev_trans_dt    DATE := to_date('20990101', 'YYYYMMDD');

  vgc_org_id         ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
  vgn_key_id_pad_len NUMBER := 6;

  vgn_rate_from_us_mult_fctr   currency_exchange_rates.rate_from_us_mult_fctr%TYPE := -1.0;
  vgn_rate_to_us_mult_fctr     currency_exchange_rates.rate_to_us_mult_fctr%TYPE := -1.0;
  vgd_prev_reported_as_of_date DATE := to_date('20990101', 'YYYYMMDD');
  vgc_prev_iso_currency_code   TEMP_ORDER_ITEM_SHIPMENT.iso_currency_code_1%TYPE := '!!!';

  /* cor variables */
  vgc_io_status  VARCHAR2(20);
  vgn_io_sqlcode NUMBER;
  vgc_io_sqlerrm VARCHAR2(260);

  vgd_fy_1st_day DATE := NULL;

  k_max_date      CONSTANT DATE := to_date('20991231', 'YYYYMMDD');
  k_begin_of_time CONSTANT DATE := to_date('00010101', 'YYYYMMDD');

  UE_CRITICAL_DB_ERROR EXCEPTION;

  /***************************************************************/
  /* PROCEDURE:    p_get_fiscal_dates                */
  /* DESCRIPTION:  GET THE TYCO FISCAL DATES (YR,MO,QTR) FOR     */
  /*               A CALENDAR DATE.                              */
  /***************************************************************/
  PROCEDURE p_get_fiscal_dates(vid_calendar_date IN temp_order_item_shipment.AMP_SHIPPED_DATE%TYPE) IS
    vlc_io_status    VARCHAR2(20);
    vlc_io_sqlcode   VARCHAR2(20);
    vlc_io_sqlerrm   VARCHAR2(260);
    vln_fiscal_month NUMBER(2);
    vln_tyco_qtr     NUMBER(2);
    vln_tyco_year    NUMBER(4);
  BEGIN
    vgn_result := 0;
    IF vgd_prev_calendar_date <> vid_calendar_date THEN
      vgd_prev_calendar_date := vid_calendar_date;

      cor_date_dmn.get_tyco_month_from_day(vlc_io_status,
                                           vlc_io_sqlcode,
                                           vlc_io_sqlerrm,
                                           vln_fiscal_month,
                                           vln_tyco_qtr,
                                           vln_tyco_year,
                                           vid_calendar_date);

      IF vlc_io_status = 'FOUND' THEN
        vgn_fiscal_month   := vln_fiscal_month;
        vgn_fiscal_year    := vln_tyco_year;
        vgc_fiscal_quarter := 'Q' || TO_CHAR(vln_tyco_qtr);
      ELSIF vlc_io_status = 'ABORT' AND vlc_io_sqlcode = '-20405' THEN
        vgn_result := +100;
      ELSE
        vgn_result := SQLCODE;
      END IF;

    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vgn_result         := SQLCODE;
      vgn_fiscal_month   := NULL;
      vgn_fiscal_year    := NULL;
      vgc_fiscal_quarter := NULL;
    WHEN OTHERS THEN
      vgn_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('p_get_fiscal_dates');
      DBMS_OUTPUT.PUT_LINE('sql error:  ' || SQLERRM(vgn_result));
  END p_get_fiscal_dates;

  /***************************************************************/
  /* PROCEDURE:    p_write_process_log_to_tbl                    */
  /* DESCRIPTION:  INSERT THREE ENTRIES IN THE PROCESS LOG FOR   */
  /*               EACH FIELD THAT HAS FAILED THE EDIT.          */
  /***************************************************************/
  PROCEDURE p_write_process_log_to_tbl IS

  BEGIN

    vgn_result   := 0;
    vgn_log_line := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_EDIT_TEMP_ORDER_ITEM',
       VGC_JOB_ID,
       SYSDATE,
       vgn_log_line,
       (vgc_bypassed_message || vgc_bypassed_value));

    vgn_log_line := vgn_log_line + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.CURRVAL,
       'P_EDIT_TEMP_ORDER_ITEM',
       VGC_JOB_ID,
       SYSDATE,
       vgn_log_line,
       vgc_bypassed_rec_key);

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      vgn_result := SQLCODE;
    WHEN OTHERS THEN
      vgn_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_write_process_log_to_tbl');
      DBMS_OUTPUT.PUT_LINE('sql error:  ' || SQLERRM(vgn_result));

  END p_write_process_log_to_tbl;

  /***************************************************************/
  /* PROCEDURE:    P_EDIT_TEMP_ORDER_ITEM                        */
  /* DESCRIPTION:  CALLED PROCEDURE TO EDIT 1 TEMP OIS RECORD.   */
  /*               IF RECORD DOES NOT PASS EDITS, BYPASS IS      */
  /*               INDICATED AND A RECORD IS WRITTEN TO THE      */
  /*               SCORECARD_PROCESS_LOG                         */
  /***************************************************************/
  PROCEDURE P_EDIT_TEMP_ORDER_ITEM(OIS        IN OUT NOCOPY TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE,
                                   VON_RESULT OUT NUMBER) AS

    /*  LOCAL VARIABLE DECLARATIONS  */
    vln_organization_key_id ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE;
    vlc_open_ship_ind       CHAR(1);
    vlc_cust_acct_base      CHAR(8);
    vlc_cust_acct_sufx      CHAR(2);
    vln_part_key_id         ORDER_ITEM_SHIPMENT.PART_KEY_ID%TYPE;
    vlc_amp_order_nbr       CHAR(10);
    vlc_order_item_nbr      CHAR(8);
    vlc_shipment_id         CHAR(15);
    vlb_build_reckey_1st    BOOLEAN := TRUE;

    vlc_sql_error  CHAR(70);
    vln_work_quantity NUMBER(9);

    /* cost variables */
    vlc_cost_quantity       TEMP_ORDER_ITEM_SHIPMENT.QUANTITY_SHIPPED%TYPE;
    vlc_true_cost           TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_labor_cost          TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_tot_ovhd_cost       TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_mfr_engr_cost       TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_true_matl_cost      TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_matl_brdn_cost      TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_inco_cntt_cost      TEMP_ORDER_ITEM_SHIPMENT.GFC_EXTENDED_TRUE_AMP_COST%TYPE;
    vlc_out_cost_status_cde NUMBER(2) := NULL;
    vlc_out_stat            NUMBER(2) := NULL;
    vlc_data_source_desc    TEMP_ORDER_ITEM_SHIPMENT.DATA_SOURCE_DESC%TYPE;
    vlc_rptorg_id           ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;

    vlc_trans_dt   DATE;
    vlc_mfg_org_id ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;

    /***************************************************************/
    /* PROCEDURE:    p_write_process_log                         */
    /* DESCRIPTION:  build bypass record key string            */
    /***************************************************************/
    PROCEDURE p_write_process_log IS

    BEGIN
      IF vlb_build_reckey_1st THEN
        vgn_bypassed_seq_nbr    := vgn_bypassed_seq_nbr + 1;
        vln_organization_key_id := ois.ORGANIZATION_KEY_ID;
        IF ois.purchase_by_account_base IS NULL THEN
          vlc_cust_acct_base := ' ';
        ELSE
          vlc_cust_acct_base := ois.purchase_by_account_base;
        END IF;
        IF ois.ship_to_account_suffix IS NULL THEN
          vlc_cust_acct_sufx := ' ';
        ELSE
          vlc_cust_acct_sufx := ois.ship_to_account_suffix;
        END IF;

        vln_part_key_id := ois.part_key_id;
        IF ois.amp_order_nbr IS NULL THEN
          vlc_amp_order_nbr := ' ';
        ELSE
          vlc_amp_order_nbr := ois.amp_order_nbr;
        END IF;
        IF ois.order_item_nbr IS NULL THEN
          vlc_order_item_nbr := ' ';
        ELSE
          vlc_order_item_nbr := ois.order_item_nbr;
        END IF;
        IF ois.shipment_id IS NULL THEN
          vlc_shipment_id := ' ';
        ELSE
          vlc_shipment_id := ois.shipment_id;
        END IF;
        vgc_bypassed_rec_key := TO_CHAR(vgn_bypassed_seq_nbr, '000009') || '|' ||
                                lpad(to_char(vln_ORGANIZATION_KEY_ID),
                                     vgn_key_id_pad_len) || '|' ||
                                vlc_open_ship_ind || '|' ||
                                vlc_cust_acct_base || '|' ||
                                vlc_cust_acct_sufx || '|' ||
                                TO_CHAR(vln_part_key_id) || '|' ||
                                vlc_amp_order_nbr || '|' ||
                                vlc_order_item_nbr || '|' ||
                                vlc_shipment_id;
        vlb_build_reckey_1st := FALSE;
      END IF;
      p_write_process_log_to_tbl;
    EXCEPTION
      WHEN OTHERS THEN
        vgn_result := SQLCODE;
        DBMS_OUTPUT.PUT_LINE('p_write_process_log');
        DBMS_OUTPUT.PUT_LINE('sql error:  ' || SQLERRM(vgn_result));
    END;

  BEGIN

    IF vgb_first_time THEN
      vgb_first_time := FALSE;
      VGC_JOB_ID     := OIS.DML_ORACLE_ID;
      SELECT TO_NUMBER(PARAMETER_FIELD, '99')
        INTO vgn_days_early
        FROM DELIVERY_PARAMETER
       WHERE PARAMETER_ID = 'DED358';
      SELECT TO_NUMBER(PARAMETER_FIELD, '99')
        INTO vgn_days_late
        FROM DELIVERY_PARAMETER
       WHERE PARAMETER_ID = 'DED359';
    END IF;
    IF ois.amp_shipped_date IS NULL THEN
      vlc_open_ship_ind := 'O';
    ELSE
      vlc_open_ship_ind := 'S';
    END IF;

    /****** REMAINING_QTY_TO_SHIP and QUANTITY_SHIPPED edit - added by alex 10/99 ******/
    IF vlc_open_ship_ind = 'O' THEN
      IF ois.remaining_qty_to_ship > 0 THEN
        ois.quantity_shipped := 0;
        GOTO end_remaining_qty_edit;
      END IF;
      IF ois.quantity_shipped > 0 THEN
        ois.remaining_qty_to_ship := ois.quantity_shipped;
        ois.quantity_shipped      := 0;
      END IF;
    END IF;
    <<end_remaining_qty_edit>>

    /****** FISCAL DATES (MO,YR,QTR) edit - added by alex 12/99 ******/
    IF vlc_open_ship_ind = 'O' THEN
      IF ois.customer_request_date IS NULL OR
         TO_CHAR(ois.customer_request_date, 'DD-MM-YYYY') = '01-01-0001' THEN
        GOTO end_fiscal_date_edit;
      END IF;
      p_get_fiscal_dates(ois.customer_request_date);
    ELSIF vlc_open_ship_ind = 'S' THEN
      IF ois.amp_shipped_date IS NULL THEN
        GOTO end_fiscal_date_edit;
      END IF;
      p_get_fiscal_dates(ois.amp_shipped_date);
    ELSE
      GOTO end_fiscal_date_edit;
    END IF;
    IF vgn_result = +0 THEN
      ois.fiscal_month   := vgn_fiscal_month;
      ois.fiscal_year    := vgn_fiscal_year;
      ois.fiscal_quarter := vgc_fiscal_quarter;
    ELSIF vgn_result = +100 THEN
      NULL;
    ELSE
      RAISE UE_CRITICAL_DB_ERROR;
    END IF;
    <<end_fiscal_date_edit>>

    if vlc_open_ship_ind = 'S' then
      if scdCommonBatch.GetCompanyOrgID(ois.organization_key_id,
                                        ois.amp_shipped_date,
                                        vgc_org_id) then
        null;
      end if;
    else
      if scdCommonBatch.GetCompanyOrgID(ois.organization_key_id,
                                        ois.reported_as_of_date,
                                        vgc_org_id) then
        null;
      end if;
    end if;

    IF ois.organization_key_id = 0 THEN
      vgc_bypassed_message := 'SCD ORG KEY ID REQUIRED - BYPASSED';
      vgc_bypassed_value   := lpad(to_char(ois.organization_key_id),
                                   vgn_key_id_pad_len);
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.accounting_org_key_id = 0 THEN
      vgc_bypassed_message := 'ACCNT ORG KEY ID REQUIRED - BYPASSED';
      vgc_bypassed_value   := lpad(to_char(ois.accounting_org_key_id),
                                   vgn_key_id_pad_len);
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    if vgc_org_id = scdCommonBatch.gUSCoOrgID then
      if ois.mfr_org_key_id = 0 then
        vgc_bypassed_message := 'MFG DIV ORG KEY ID REQUIRED - LOADED';
        vgc_bypassed_value   := lpad(to_char(ois.mfr_org_key_id),
                                     vgn_key_id_pad_len);
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    END IF;

    IF ois.amp_order_nbr IS NULL THEN
      vgc_bypassed_message := 'AMP ORDER NBR REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.amp_order_nbr;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.order_item_nbr IS NULL THEN
      vgc_bypassed_message := 'ORDER ITEM NBR REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.order_item_nbr;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.shipment_id IS NULL THEN
      vgc_bypassed_message := 'SCHEDULE LINE REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.shipment_id;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.part_key_id IS NULL THEN
      vgc_bypassed_message := 'PART NUMBER REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.sbmt_part_nbr;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.purchase_by_account_base IS NULL OR
       ois.ship_to_account_suffix IS NULL THEN
      vgc_bypassed_message := 'CUST ACCT NBR REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.purchase_by_account_base ||
                              ois.ship_to_account_suffix;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    IF ois.item_quantity < 0 THEN
      vgc_bypassed_message := 'ORDER ITEM QTY MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.item_quantity, 'S000000009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.resrvn_level_1 < 0 THEN
      vgc_bypassed_message := 'ORDER QYT RL1 MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.resrvn_level_1, 'S000000009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.resrvn_level_5 < 0 THEN
      vgc_bypassed_message := 'ORDER QYT RL5 MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.resrvn_level_5, 'S000000009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.resrvn_level_9 < 0 THEN
      vgc_bypassed_message := 'ORDER QYT RL9 MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.resrvn_level_9, 'S000000009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.quantity_released < 0 THEN
      vgc_bypassed_message := 'QTY RELEASED MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.quantity_released, 'S000000009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    /*  CHECK QUANTITY RELATIONSHIP.  If shipment: Quantity_shipped must
    be > 0. If invalid, bypass.   If open: RL1, 5, 9, or Quantity_
    released must be > 0. If invalid, bypass.  Can add the 4 fields
    together and check for > 0.  */

    IF vlc_open_ship_ind = 'S' THEN
      IF ois.Quantity_shipped <= 0 THEN
        vgc_bypassed_message := 'QTY SHIPPED RQD FOR SHIPMENTS - BYPASSED';
        vgc_bypassed_value   := TO_CHAR(ois.quantity_shipped, 'S000000009');
        ois.update_code      := 'B';
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    ELSE
      IF ois.resrvn_level_1 + ois.resrvn_level_5 + ois.resrvn_level_9 +
         ois.quantity_released <= 0 THEN
        vgc_bypassed_message := 'QTY RLSD,RL1,RL5 OR RL9 RQD FOR OPENS - BYP';
        vln_work_quantity    := (ois.resrvn_level_1 + ois.resrvn_level_5 +
                                ois.resrvn_level_9 + ois.quantity_released);
        vgc_bypassed_value   := TO_CHAR(vln_work_quantity, 'S000000009');
        ois.update_code      := 'B';
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    END IF;

    IF ois.local_currency_billed_amount < 0 THEN
      vgc_bypassed_message := 'EXTD BB AMT MUST BE POSITIVE - BYPASSED';
      vgc_bypassed_value   := TO_CHAR(ois.local_currency_billed_amount,
                                      'S00000009.00009');
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

    /*** Extended Booking and Billing amt sanity check - added 10/99 R Jovanelly/alex ***/
    IF vlc_open_ship_ind = 'S' THEN
      IF ois.extended_book_bill_amount > 1000000 AND
         ois.Quantity_shipped < 1000 THEN
        vgc_bypassed_message := 'VALID BILLING AMOUNT QUESTIONABLE';
        vgc_bypassed_value   := TO_CHAR(ois.extended_book_bill_amount,
                                        'S0000000009.09');
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    ELSE
      IF ois.extended_book_bill_amount > 1000000 AND
         (ois.resrvn_level_1 + ois.resrvn_level_5 + ois.resrvn_level_9 +
         ois.quantity_released) < 1000 THEN
        vgc_bypassed_message := 'VALID BILLING AMOUNT QUESTIONABLE';
        vgc_bypassed_value   := TO_CHAR(ois.extended_book_bill_amount,
                                        'S0000000009.09');
        p_write_process_log;
      END IF;
    END IF;

    -- calculate budget_book_bill_amt
    if ois.local_currency_billed_amount >= 0 then

      -- get fiscal year first day
      if vgd_fy_1st_day is null then
        begin
          select to_date(parameter_field, 'DD-MON-YYYY')
            into vgd_fy_1st_day
            from delivery_parameter_local
           where parameter_id = 'SCDFY1STDAY';

        exception
          when others then
            vgn_result := sqlcode;
            RAISE ue_critical_db_error;
        end;
      end if;

      cor_curr_exchg_rates.convert_currency_amt(vgc_io_status,
                                                vgn_io_sqlcode,
                                                vgc_io_sqlerrm,
                                                ois.budget_rate_book_bill_amt,
                                                ois.local_currency_billed_amount,
                                                ois.iso_currency_code_1,
                                                'USD',
                                                vgd_fy_1st_day,
                                                '1'); -- 1 = budget rate
      if vgc_io_status != 'OK' then
        if vgn_io_sqlcode = +100 then
          ois.budget_rate_book_bill_amt := NULL;
        else
          vgn_result := vgn_io_sqlcode;
          RAISE ue_critical_db_error;
        end if;
      end if;

    end if;

    /****** end ISO_CURRENCY_CODE_1 edit ******/

    /****** begin get GFC_EXTENDED_TRUE_AMP_COST ******/
    IF ois.update_code = 'B' THEN
      GOTO end_getcost;
    END IF;

    IF ois.part_key_id != scdCommonBatch.gZeroPartKeyID THEN

      IF vlc_open_ship_ind = 'S' THEN
        vlc_cost_quantity := ois.quantity_shipped;
      ELSE
        vlc_cost_quantity := ois.resrvn_level_1 + ois.resrvn_level_5 +
                             ois.resrvn_level_9 + ois.quantity_released;
      END IF;

      IF ois.data_source_desc IS NULL AND ois.brand_id = 2 THEN
        -- default to RYC
        vlc_data_source_desc := 'RYC';
      ELSE
        vlc_data_source_desc := ois.data_source_desc;
      END IF;

      -- get reporting org id if not company org != US (0048)
      if vgc_org_id != scdCommonBatch.gUSCoOrgID THEN
        if vlc_open_ship_ind = 'S' then
          vlc_trans_dt := ois.amp_shipped_date;
          if not scdCommonBatch.GetOrgIDV4(ois.organization_key_id,
                                           ois.amp_shipped_date,
                                           vlc_rptorg_id) then
            GOTO end_getcost;
          end if;
        else
          vlc_trans_dt := ois.reported_as_of_date;
          if not scdCommonBatch.GetOrgIDV4(ois.organization_key_id,
                                           ois.reported_as_of_date,
                                           vlc_rptorg_id) then
            GOTO end_getcost;
          end if;
        end if;
      else
        vlc_rptorg_id := vgc_org_id;
      end if;

      SSA_SOURCE.SSAC0085_COST_CALCULATOR.COST_CALCULATOR(vlc_rptorg_id,
                                                          ois.part_key_id,
                                                          ois.reported_as_of_date,
                                                          ois.fiscal_year, /* fiscal year */
                                                          vlc_cost_quantity,
                                                          ois.extended_book_bill_amount,
                                                          'USD', -- ois.iso_currency_code_1,
                                                          ois.part_um, /* unit of measure */
                                                          '2', /* frozen cost */
                                                          '3', /* daily */
                                                          vlc_data_source_desc,
                                                          vlc_true_cost,
                                                          vlc_labor_cost,
                                                          vlc_tot_ovhd_cost,
                                                          vlc_mfr_engr_cost,
                                                          vlc_true_matl_cost,
                                                          vlc_matl_brdn_cost,
                                                          vlc_inco_cntt_cost,
                                                          vlc_out_cost_status_cde,
                                                          vlc_out_stat);

      IF vlc_out_stat <> 99 THEN
        -- USD
        ois.GFC_EXTENDED_TRUE_AMP_COST := vlc_true_cost;

        if vlc_open_ship_ind = 'O' then
          -- only for backlog for now
          ois.usd_labor_cost_amt     := vlc_labor_cost;
          ois.usd_tot_ovhd_cost_amt  := vlc_tot_ovhd_cost;
          ois.usd_mfr_engr_cost_amt  := vlc_mfr_engr_cost;
          ois.usd_true_matl_cost_amt := vlc_true_matl_cost;
          ois.usd_matl_brdn_cost_amt := vlc_matl_brdn_cost;
          ois.usd_inco_cntt_cost_amt := vlc_inco_cntt_cost;

          -- local curr
          if vgc_prev_iso_currency_code != ois.iso_currency_code_1 or
             vgd_prev_reported_as_of_date != ois.reported_as_of_date then
            begin
              select rate_from_us_mult_fctr
                into vgn_rate_from_us_mult_fctr
                from currency_exchange_rates
               where currency_exchange_rate_cde = 3
                 and ois.reported_as_of_date between effective_dt and
                     expiration_dt
                 and currency_cde = ois.iso_currency_code_1;
            exception
              when no_data_found then
                vgn_rate_from_us_mult_fctr := -1.0;
              when others then
                vgn_result := SQLCODE;
                DBMS_OUTPUT.PUT_LINE('Error in getting local exchange rate');
                DBMS_OUTPUT.PUT_LINE('sql error: ' || SQLERRM(vgn_result));
                RAISE ue_critical_db_error;
            end;
          end if;
          if vgn_rate_from_us_mult_fctr != -1.0 then
            ois.local_crnc_true_cost_amt      := vlc_true_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_labor_cost_amt     := vlc_labor_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_tot_ovhd_cost_amt  := vlc_tot_ovhd_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_mfr_engr_cost_amt  := vlc_mfr_engr_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_true_matl_cost_amt := vlc_true_matl_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_matl_brdn_cost_amt := vlc_matl_brdn_cost *
                                                 vgn_rate_from_us_mult_fctr;
            ois.local_crnc_inco_cntt_cost_amt := vlc_inco_cntt_cost *
                                                 vgn_rate_from_us_mult_fctr;
          end if;

          -- TBR
          if vgc_prev_iso_currency_code != ois.iso_currency_code_1 then
            begin
              select rate_to_us_mult_fctr
                into vgn_rate_to_us_mult_fctr
                from currency_exchange_rates
               where currency_exchange_rate_cde = 1
                 and vgd_fy_1st_day between effective_dt and expiration_dt
                 and currency_cde = ois.iso_currency_code_1;
            exception
              when no_data_found then
                vgn_rate_to_us_mult_fctr := -1.0;
              when others then
                vgn_result := SQLCODE;
                DBMS_OUTPUT.PUT_LINE('Error in getting TBR exchange rate');
                DBMS_OUTPUT.PUT_LINE('sql error: ' || SQLERRM(vgn_result));
                RAISE ue_critical_db_error;
            end;
          end if;
          if vgn_rate_from_us_mult_fctr != -1.0 then
            ois.cnst_true_cost_amt      := ois.local_crnc_true_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_labor_cost_amt     := ois.local_crnc_labor_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_tot_ovhd_cost_amt  := ois.local_crnc_tot_ovhd_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_mfr_engr_cost_amt  := ois.local_crnc_mfr_engr_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_true_matl_cost_amt := ois.local_crnc_true_matl_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_matl_brdn_cost_amt := ois.local_crnc_matl_brdn_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
            ois.cnst_inco_cntt_cost_amt := ois.local_crnc_inco_cntt_cost_amt *
                                           vgn_rate_to_us_mult_fctr;
          end if;

          vgc_prev_iso_currency_code   := ois.iso_currency_code_1;
          vgd_prev_reported_as_of_date := ois.reported_as_of_date;
        end if;
      ELSE
        --     vgn_result := vlc_out_stat;
        --         RAISE ue_critical_db_error;
        vgc_bypassed_message := 'DB ERR IN COST FUNC FOR SBMT_PART_NBR ';
        vgc_bypassed_value   := ois.sbmt_part_nbr;
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;

      -- derive MFG_SOURCE_ID if not US
      if vgc_org_id != scdCommonBatch.gUSCoOrgID THEN
        --need to change this logic once GCS table is available
        --     if ois.part_nbr = vgc_prev_part_nbr
        if ois.part_key_id = vgn_prev_part_key_id and
           vlc_trans_dt = vgd_prev_trans_dt and
           vlc_rptorg_id = vgc_prev_rptorg_id then

          ois.mfr_org_key_id := vgn_prev_mfg_org_kid;
        else
          BEGIN
            SELECT MANUFACTURING_SOURCE_ORG_ID
              INTO vlc_mfg_org_id
              FROM MANUFACTURING_SOURCE_ORGS
             WHERE PART_KEY_ID = ois.part_key_id
               AND ORG_ID = vlc_rptorg_id
               AND vlc_trans_dt BETWEEN EFFECTIVE_DT AND
                   NVL(EXPIRATION_DT, k_max_date);

            if not scdCommonBatch.GetOrgKeyIDV2(vlc_mfg_org_id,
                                                ois.mfr_org_key_id) then
              NULL;
            end if;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              ois.mfr_org_key_id := 0;
            WHEN OTHERS THEN
              vgn_result := SQLCODE;
              DBMS_OUTPUT.PUT_LINE('Error in gettin MFG_SOURCE_ID');
              DBMS_OUTPUT.PUT_LINE('sql error: ' || SQLERRM(vgn_result));
              RAISE ue_critical_db_error;
          END;

          --     vgc_prev_part_nbr    := ois.part_nbr;
          vgn_prev_part_key_id := ois.part_key_id;
          vgd_prev_trans_dt    := vlc_trans_dt;
          vgc_prev_rptorg_id   := vlc_rptorg_id;
          vgn_prev_mfg_org_kid := ois.mfr_org_key_id;
        end if;
      end if;
    else
      -- part_key_id = 0
      -- get reporting org id if not company org != US (0048)
      if vgc_org_id != scdCommonBatch.gUSCoOrgID THEN
        if vlc_open_ship_ind = 'S' then
          if not scdCommonBatch.GetOrgIDV4(ois.organization_key_id,
                                           ois.amp_shipped_date,
                                           vlc_rptorg_id) then
            GOTO end_getcost;
          end if;
        else
          if not scdCommonBatch.GetOrgIDV4(ois.organization_key_id,
                                           ois.reported_as_of_date,
                                           vlc_rptorg_id) then
            GOTO end_getcost;
          end if;
        end if;
      else
        vlc_rptorg_id := vgc_org_id;
      end if;

    END IF;
    <<end_getcost>>
  /******* end get GFC_EXTENDED_TRUE_AMP_COST *******/

    IF ois.customer_request_date IS NULL THEN
      vgc_bypassed_message := 'CUSTOMER REQUEST REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.customer_request_date;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.amp_schedule_date IS NULL THEN
      vgc_bypassed_message := 'AMP SCHEDULE REQUIRED - BYPASSED';
      vgc_bypassed_value   := ois.amp_schedule_date;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF ois.reported_as_of_date IS NULL OR
       ois.reported_as_of_date = k_begin_of_time THEN
      vgc_bypassed_message := 'INVALID REPORTED AS OF DATE - BYPASSED';
      vgc_bypassed_value   := ois.reported_as_of_date;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;
    IF vlc_open_ship_ind = 'S' THEN
      IF ois.amp_shipped_date > ois.reported_as_of_date + 1 THEN
        vgc_bypassed_message := 'FUTURE SHIP DATE - BYPASSED';
        vgc_bypassed_value   := ois.amp_shipped_date;
        ois.update_code      := 'B';
        p_write_process_log;
        IF vgn_result <> 0 THEN
          RAISE ue_critical_db_error;
        END IF;
      END IF;
    END IF;

    IF nvl(ois.update_code, 'x') <> 'B' THEN
      -- set to null the expedite dates if it satisfies the condition
      IF ois.AMP_SCHEDULE_DATE <> k_begin_of_time THEN
        IF ois.CURRENT_EXPEDITE_DATE = k_begin_of_time THEN
          ois.CURRENT_EXPEDITE_DATE := NULL;
        END IF;

        IF ois.EARLIEST_EXPEDITE_DATE = k_begin_of_time THEN
          ois.EARLIEST_EXPEDITE_DATE := NULL;
        END IF;

        IF ois.ORIGINAL_EXPEDITE_DATE = k_begin_of_time THEN
          ois.ORIGINAL_EXPEDITE_DATE := NULL;
        END IF;
      END IF;

      IF ois.CUSTOMER_REQUEST_DATE <> k_begin_of_time THEN
        IF ois.CUSTOMER_EXPEDITE_DATE = k_begin_of_time THEN
          ois.CUSTOMER_EXPEDITE_DATE := NULL;
        END IF;
      END IF;
    END IF;

    /* logic for calculating number of expedites -- shipments and opens*/
    IF ois.current_expedite_date IS NOT NULL AND
       ois.current_expedite_date <> k_begin_of_time THEN
      vgd_current_expedite_date := ois.current_expedite_date;
      vgn_nbr_of_expedites      := ois.nbr_of_expedites;
      vgn_organization_key_id   := ois.organization_key_id;
      vgc_amp_order_nbr         := ois.amp_order_nbr;
      vgc_order_item_nbr        := ois.order_item_nbr;
      vgc_shipment_id           := ois.shipment_id;

      vgn_result := 0;

      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      ELSE
        IF vgn_nbr_of_expedites > 99 THEN
          p_write_process_log;
          IF vgn_result <> 0 THEN
            RAISE ue_critical_db_error;
          END IF;
        END IF;
        ois.nbr_of_expedites := vgn_nbr_of_expedites;
      END IF;
    END IF;

    IF ois.product_code = '9964' AND
       ois.part_key_id = scdCommonbatch.gZeroPartKeyID THEN
      NULL;
    ELSIF SUBSTR(ois.product_code, 1, 1) = '9' THEN
      vgc_bypassed_message := 'PRODUCT CODE IS 9XXX - BYPASSED';
      vgc_bypassed_value   := ois.product_code;
      ois.update_code      := 'B';
      p_write_process_log;
      IF vgn_result <> 0 THEN
        RAISE ue_critical_db_error;
      END IF;
    END IF;

  <<edit_zero_part_pc>>
    NULL;
    /* for zero parts, zero_part_prod_code is required */
    /* EMEA ONLY                                       */
    IF ois.part_key_id = scdCommonbatch.gZeroPartKeyID AND
       vgc_org_id <> scdCommonBatch.gUSCoOrgID THEN
      IF ois.zero_part_prod_code IS NULL THEN
        NULL;
      ELSE
        ois.product_code := ois.zero_part_prod_code;
      END IF;
    END IF;

    -- derive Prod Mgr Global ID
    IF ois.update_code = 'B' THEN
      GOTO end_prodmgr;
    END IF;
    IF scdCommonBatch.GetGIMNProdMgrGlobalID('AMP',
                                             'PRODCDE',
                                             ois.product_code,
                                             vgc_org_id,
                                             ois.product_manager_global_id) THEN
      NULL;
    ELSIF sqlcode = -20101 THEN
      RAISE ue_critical_db_error;
    END IF;
    <<end_prodmgr>>

    --  ois.sold_to_customer_id := nvl(ois.sold_to_customer_id,ois.purchase_by_account_base);
    if ois.sold_to_customer_id is null then
      ois.sold_to_customer_id := ois.purchase_by_account_base;
    end if;
    --  ois.profit_center_abbr_nm := nvl(ois.profit_center_abbr_nm,'*');
    if ois.profit_center_abbr_nm is null then
      ois.profit_center_abbr_nm := '*';
    end if;
    --  ois.product_busns_line_fnctn_id := nvl(ois.product_busns_line_fnctn_id,'*');
    if ois.product_busns_line_fnctn_id is null then
      ois.product_busns_line_fnctn_id := '*';
    end if;
    --  ois.controller_uniqueness_id := nvl(ois.controller_uniqueness_id,'*');
    if ois.controller_uniqueness_id is null then
      ois.controller_uniqueness_id := '*';
    end if;
    --  ois.product_busns_line_id := nvl(ois.product_busns_line_id,'*');
    if ois.product_busns_line_id is null then
      ois.product_busns_line_id := '*';
    end if;
    --  ois.product_manager_global_id := nvl(ois.product_manager_global_id,0);
    if ois.product_manager_global_id is null then
      ois.product_manager_global_id := 0;
    end if;

    IF ois.update_code = 'B' or vlc_open_ship_ind <> 'S' THEN
      GOTO end_derive_security;
    END IF;
    -- derive values for data security columns
    ois.ORIG_IBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_ibc_pc_id(ois.INDUSTRY_BUSINESS_CODE);
    ois.ORIG_IBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_IBC_PROFIT_CENTER_ID);

    ois.ORIG_CBC_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_cbc_pc_id(ois.PRODUCT_BUSNS_LINE_FNCTN_ID);
    ois.ORIG_CBC_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_CBC_PROFIT_CENTER_ID);

    ois.ORIG_REPT_ORG_PROFIT_CENTER_ID := COR_DATA_SECURITY_TAG_CUR.get_org_pc_id(vgc_org_id);
    ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_REPT_ORG_PROFIT_CENTER_ID);

    ois.ORIG_SALES_TERRITORY_NBR := scdCommonBatch.get_hiercust_slsterrnbr(ois.HIERARCHY_CUSTOMER_ORG_ID,
                                                                           ois.HIERARCHY_CUSTOMER_BASE_ID,
                                                                           ois.HIERARCHY_CUSTOMER_SUFX_ID);

    ois.ORIG_SALES_TERR_PROFIT_CTR_ID  := COR_DATA_SECURITY_TAG_CUR.get_slsterrnbr_pc_id(ois.ORIG_SALES_TERRITORY_NBR);
    ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.ORIG_SALES_TERR_PROFIT_CTR_ID);

    ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID := COR_DATA_SECURITY_TAG_CUR.get_mge_pc_dsg_id(ois.PROFIT_CENTER_ABBR_NM);

    ois.ORIG_DATA_SECURITY_TAG_ID := get_data_security_tag(ois.ORIG_IBC_DATA_SECR_GRP_ID,
                                                           ois.ORIG_SLS_TERR_DATA_SECR_GRP_ID,
                                                           ois.ORIG_CBC_DATA_SECR_GRP_ID,
                                                           ois.ORIGREPT_PRFT_DATA_SECR_GRP_ID,
                                                           ois.ORIG_MGE_PRFT_DATA_SECR_GRP_ID);

    ois.CUR_DATA_SECURITY_TAG_ID   := ois.ORIG_DATA_SECURITY_TAG_ID;
    ois.SUPER_DATA_SECURITY_TAG_ID := ois.ORIG_DATA_SECURITY_TAG_ID;
    <<end_derive_security>>
    NULL;

  EXCEPTION

    WHEN ue_critical_db_error THEN
      DBMS_OUTPUT.PUT_LINE('TOIS_SEQ: ' || ois.TEMP_SHIP_SEQ);
      von_result := vgn_result;
    WHEN OTHERS THEN
      vgn_result := SQLCODE;
      von_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_EDIT_TEMP_ORDER_ITEM - seq#: ' ||
                           ois.TEMP_SHIP_SEQ);
      DBMS_OUTPUT.PUT_LINE('sql error:  ' || SQLERRM(vgn_result));
      vgn_log_line  := vgn_log_line + 1;
      vlc_sql_error := SQLERRM(vgn_result);
      INSERT INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_EDIT_TEMP_ORDER_ITEM',
         VGC_JOB_ID,
         SYSDATE,
         VGN_LOG_LINE,
         ('DBER ' || SUBSTR(VLC_SQL_ERROR, 1, 70)));
      COMMIT;

  END p_edit_temp_order_item;

  FUNCTION get_disc_ops_cde_backlog(i_adr43 IN ADR43_BACKLOGS%ROWTYPE)
    RETURN NUMBER IS
    v_disc_operations_cde NUMBER;
    v_status              NUMBER;
    v_sqlcode             NUMBER;
    v_sqlerrm             VARCHAR2(300);
    v_schema_ind          NUMBER := 0;

  BEGIN

    ssa_source.discontinued_ops_sales.GET_DISCONTINUED_OPS_CDE(v_status,
                                                               v_sqlcode,
                                                               v_sqlerrm,
                                                               v_disc_operations_cde,
                                                               v_schema_ind,
                                                               i_adr43.reporting_organization_id,
                                                               i_adr43.part_key_id,
                                                               i_adr43.product_cde,
                                                               i_adr43.hierarchy_customer_org_id,
                                                               i_adr43.hierarchy_customer_base_id,
                                                               i_adr43.hierarchy_customer_sufx_id);
    RETURN v_disc_operations_cde;

  END get_disc_ops_cde_backlog;

END Pkg_Edit_Temp_Order_Daf;
/
