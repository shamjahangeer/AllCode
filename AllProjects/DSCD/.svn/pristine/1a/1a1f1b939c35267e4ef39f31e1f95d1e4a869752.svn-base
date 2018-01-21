CREATE OR REPLACE PACKAGE Pkg_Adjust_Summaries AS
  /****************************************************************************/
  /* PACKAGE:     pkg_adjust_summaries                                        */
  /* DESCRIPTION: Contains procedures for modifing the summary tables.        */
  /*                                                                          */
  /* PROCEDURES:  p_adjust_summaries                                          */
  /*              p_adjust_subcontractor_smry                                 */
  /*              p_get_subcontractor_smry                                    */
  /*              p_adjust_bldg_loc_smry                                      */
  /*              p_get_bldg_loc_smry                                         */
  /*              p_adjust_mfg_camp_bldg_smry                                 */
  /*              p_get_mfg_camp_bldg_smry                                    */
  /*              p_adjust_cntrlr_prod_line_smry                              */
  /*              p_get_cntrlr_prod_line_smry                                 */
  /*              p_adjust_customer_acct_smrys                                */
  /*              p_adjust_customer_smry_t1                                   */
  /*              p_adjust_customer_smry_t2                                   */
  /*              p_adjust_customer_smry_t3                                   */
  /*              p_get_customer_smry_t1                                      */
  /*              p_adjust_marketing_org_smry                                 */
  /*              p_get_marketing_org_smry                                    */
  /*              p_adjust_part_prcmt_smry                                    */
  /*              p_get_part_prcmt_smry                                       */
  /*              p_adjust_prod_family_smry                                   */
  /*              p_get_prod_family_smry                                      */
  /*              p_adjust_sales_eng_smry                                     */
  /*              p_get_sales_eng_smry                                        */
  /*              p_adjust_scorecard_org_smry                                 */
  /*              p_get_scorecard_org_smry                                    */
  /*              p_adjust_team_org_smry                                      */
  /*              p_get_team_org_smry                                         */
  /*              p_adjust_industry_code_smry                                 */
  /*              p_get_industry_code_smry                                    */
  /*              p_initialize_delta_variables                                */
  /*                                                                          */
  /* MODIFICATION LOG                                                         */
  /*                                                                          */
  /* Date      Description                                      Programmer    */
  /* --------  ------------------------------------------------ ----------    */
  /* 07/01/96  New Package                                      RJD (CAI)     */
  /* 11/18/96  Add put_line to all abends.                      SDJ (CAI)     */
  /* 04/07/97  Release 2.0                                      JAF (CAI)     */
  /*             - ADD LOGIC FOR INDUSTR_CODE_SMRY                            */
  /*             - INCLUDE INTERCOMPANY INDICATOR IN CONTROLLER,              */
  /*               ORG AND TEAM SUMMARIES.                                    */
  /*             - REMOVE PART_NBR FROM CUSTOMER SUMMARY                      */
  /*             - CHANGE CONTROLLER SUMMERY TO ONE PRODUCT LINE              */
  /*             - CHANGE SHIPPING FACILITY LOGIC                             */
  /* 12/01/97  Release 2.1                                      JGK (CAI)     */
  /*             - ADD TEAM_CODE AND STOCK_MAKE_CODE TO SUMMARIZATION         */
  /*               CRITERIA FOR CUSTOMER_ACCOUNT_SMRY TABLES.                 */
  /*             - ADD PRODUCT_LINE_CODE TO SUMMARIZATION CRITERIA FOR        */
  /*               TEAM_ORG_SMRY TABLE.                                       */
  /*             - REMOVE PART_NBR FROM SUMMARIZATION CRITERIA FOR            */
  /*               MARKETING_ORG_SMRY AND PART_PRCMT_SMRY TABLES.             */
  /* 04/01/98  SSR#A513                                         JGK (CAI)     */
  /*             - ADD NEW MFG_CAMPUS_BLDG_SMRY TABLE                         */
  /*               (ONLY USED FOR U.S. SHIPMENTS (CO_ORG_CODE = '0').         */
  /*               (ONLY USED AFTER MARCH 31, 1998)                           */
  /* 05/12/98  SSR#A279                                         LPZ (CAI)     */
  /*             - ADD NEW SUBCONTR_ACCOUNT_SMRY TABLE                        */
  /* 08/05/98  SSR#A279                                         JGK (CAI)     */
  /*             - (ONLY USED AFTER JULY 31, 1998)                            */
  /* 04/04/01  SCD Rewite                           Alex      */
  /* 02/05/02  Add CUSTOMER_ACCT_TYPE_CDE in PROFIT_CENTER_SMRY.  Alex    */
  /* 04/17/02  Add PRODUCT_BUSNS_LINE_ID in PROFIT_CENTER_SMRY.  Alex     */
  /* 04/21/02  Added PRODUCT_MANAGER_GLOBAL_ID in CNTRLR_PROD_LINE_SMRY. Alex */
  /* 10/28/02  Added STOCK_MAKE_CODE and CUSTOMER_ACCT_TYPE_CDE        Alex */
  /*        in BUILDING_LOCATION_SMRY                   */
  /* 11/08/02  Added SALES_OFFICE_CDE, SALES_GROUP_CDE & SOURCE_SYSTEM_ID   */
  /*        in BUILDING_LOCATION_SMRY                Alex */
  /* 01/10/03  Fixed bug on deleting record in customer_smry_t? tables   Alex */
  /* 04/10/03  Removed US only restriction on MFG SMRY             Alex */
  /* 02/24/04  Add logic to populate Weekly SMRY table for Op Ex       Alex */
  /* 04/27/04  Added error handling logic to trap DB error       Alex */
  /* 05/24/04  Add IBC column to SMRY for Op Ex                  Alex */
  /* 12/02/05  Add Profit Center to BUILDING_LOCATION_SMRY           Alex */
  /* 06/16/06  Add MRP_Group_Cde to BUILDING_LOC, TEAM_ORG, INDUSTRY_    Alex */
  /*          CODE SMRY. Filter enhancement - phase III.                    */
  /* 09/19/06  Exclude intraco Cust in OpEx Summary table to avoid       Alex */
  /*            double counting.                                              */
  -- 09/04/08  Add STOCK_MAKE_CODE & MRP_GROUP_CDE in profit_center_smry table.
  /****************************************************************************/

  PROCEDURE p_adjust_summaries(vic_job_id                     IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                               vid_amp_shipped_date           IN ORDER_ITEM_SHIPMENT.AMP_SHIPPED_DATE%TYPE,
                               vin_organization_key_id        IN ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE,
                               vic_team_code                  IN ORDER_ITEM_SHIPMENT.TEAM_CODE%TYPE,
                               vic_prodcn_cntrlr_code         IN ORDER_ITEM_SHIPMENT.PRODCN_CNTRLR_CODE%TYPE,
                               vic_controller_uniqueness_id   IN ORDER_ITEM_SHIPMENT.CONTROLLER_UNIQUENESS_ID%TYPE,
                               vic_stock_make_code            IN ORDER_ITEM_SHIPMENT.STOCK_MAKE_CODE%TYPE,
                               vic_product_line_code          IN ORDER_ITEM_SHIPMENT.PRODUCT_LINE_CODE%TYPE,
                               vic_product_code               IN ORDER_ITEM_SHIPMENT.PRODUCT_CODE%TYPE,
                               vic_prodcn_cntrlr_employee_nbr IN ORDER_ITEM_SHIPMENT.PRODCN_CNTLR_EMPLOYEE_NBR%TYPE,
                               vic_a_territory_nbr            IN ORDER_ITEM_SHIPMENT.A_TERRITORY_NBR%TYPE,
                               vic_actual_ship_building_nbr   IN ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_BUILDING_NBR%TYPE,
                               vic_actual_ship_location       IN ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_LOCATION%TYPE,
                               vic_purchase_by_account_base   IN ORDER_ITEM_SHIPMENT.PURCHASE_BY_ACCOUNT_BASE%TYPE,
                               vic_ship_to_account_suffix     IN ORDER_ITEM_SHIPMENT.SHIP_TO_ACCOUNT_SUFFIX%TYPE,
                               vic_ww_account_nbr_base        IN ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_BASE%TYPE,
                               vic_ww_account_nbr_suffix      IN ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_SUFFIX%TYPE,
                               vic_customer_type_code         IN ORDER_ITEM_SHIPMENT.CUSTOMER_TYPE_CODE%TYPE,
                               vic_ship_facility_cmprsn_code  IN ORDER_ITEM_SHIPMENT.SHIP_FACILITY_CMPRSN_CODE%TYPE,
                               vin_release_to_ship_var        IN ORDER_ITEM_SHIPMENT.RELEASE_TO_SHIP_VARIANCE%TYPE,
                               vin_schedule_to_ship_var       IN ORDER_ITEM_SHIPMENT.SCHEDULE_TO_SHIP_VARIANCE%TYPE,
                               vin_varbl_schedule_ship_var    IN ORDER_ITEM_SHIPMENT.VARBL_SCHEDULE_SHIP_VARIANCE%TYPE,
                               vin_request_to_ship_var        IN ORDER_ITEM_SHIPMENT.REQUEST_TO_SHIP_VARIANCE%TYPE,
                               vin_varbl_request_ship_var     IN ORDER_ITEM_SHIPMENT.VARBL_REQUEST_SHIP_VARIANCE%TYPE,
                               vin_request_to_schedule_var    IN ORDER_ITEM_SHIPMENT.REQUEST_TO_SCHEDULE_VARIANCE%TYPE,
                               vic_customer_acct_type_cde     IN ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE,
                               vic_industry_code              IN ORDER_ITEM_SHIPMENT.INDUSTRY_CODE%TYPE,
                               vin_mfr_org_key_id             IN ORDER_ITEM_SHIPMENT.MFR_ORG_KEY_ID%TYPE,
                               vic_mfg_campus_id              IN ORDER_ITEM_SHIPMENT.MFG_CAMPUS_ID%TYPE,
                               vic_mfg_building_nbr           IN ORDER_ITEM_SHIPMENT.MFG_BUILDING_NBR%TYPE,
                               vic_industry_business_code     IN ORDER_ITEM_SHIPMENT.INDUSTRY_BUSINESS_CODE%TYPE, -- alex - added 11/99
                               vin_accounting_org_key_id      IN ORDER_ITEM_SHIPMENT.ACCOUNTING_ORG_KEY_ID%TYPE,
                               vic_product_busns_line_fnctnid IN ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_FNCTN_ID%TYPE,
                               vic_profit_center_abbr_nm      IN ORDER_ITEM_SHIPMENT.PROFIT_CENTER_ABBR_NM%TYPE,
                               vic_sold_to_customer_id        IN ORDER_ITEM_SHIPMENT.SOLD_TO_CUSTOMER_ID%TYPE,
                               vic_product_busns_line_id      IN ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_ID%TYPE,
                               vin_product_manager_global_id  IN ORDER_ITEM_SHIPMENT.PRODUCT_MANAGER_GLOBAL_ID%TYPE,
                               vic_sales_office_cde           IN ORDER_ITEM_SHIPMENT.SALES_OFFICE_CDE%TYPE,
                               vic_sales_group_cde            IN ORDER_ITEM_SHIPMENT.SALES_GROUP_CDE%TYPE,
                               vin_source_system_id           IN BUILDING_LOCATION_SMRY.SOURCE_SYSTEM_ID%TYPE,
                               vic_mrp_group_cde              IN ORDER_ITEM_SHIPMENT.MRP_GROUP_CDE%TYPE,
                               vin_adjust_amount              IN NUMBER,
                               vion_num_smrys_inserted        IN OUT NUMBER,
                               vion_num_smrys_updated         IN OUT NUMBER,
                               vion_num_smrys_deleted         IN OUT NUMBER,
                               von_result_code                OUT NUMBER);
END Pkg_Adjust_Summaries;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Adjust_Summaries AS
  vg_dps_rec                     SCD_DELIVERY_PERFORMANCE_SMRY%ROWTYPE;
  vgc_job_id                     ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE;
  vgc_smry_type                  TEAM_ORG_SMRY.DELIVERY_SMRY_TYPE%TYPE;
  vgc_customer_type_code         ORDER_ITEM_SHIPMENT.CUSTOMER_TYPE_CODE%TYPE;
  vgn_organization_key_id        ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE;
  vgc_team_code                  ORDER_ITEM_SHIPMENT.TEAM_CODE%TYPE;
  vgc_prodcn_cntrlr_code         ORDER_ITEM_SHIPMENT.PRODCN_CNTRLR_CODE%TYPE;
  vgc_controller_uniqueness_id   ORDER_ITEM_SHIPMENT.CONTROLLER_UNIQUENESS_ID%TYPE;
  vgc_stock_make_code            ORDER_ITEM_SHIPMENT.STOCK_MAKE_CODE%TYPE;
  vgc_product_line_code          ORDER_ITEM_SHIPMENT.PRODUCT_LINE_CODE%TYPE;
  vgc_product_code               ORDER_ITEM_SHIPMENT.PRODUCT_CODE%TYPE;
  vgc_prodcn_cntrlr_employee_nbr ORDER_ITEM_SHIPMENT.PRODCN_CNTLR_EMPLOYEE_NBR%TYPE;
  vgc_a_territory_nbr            ORDER_ITEM_SHIPMENT.A_TERRITORY_NBR%TYPE;
  vgc_actual_ship_building_nbr   ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_BUILDING_NBR%TYPE;
  vgc_actual_ship_location       ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_LOCATION%TYPE;
  vgc_purchase_by_account_base   ORDER_ITEM_SHIPMENT.PURCHASE_BY_ACCOUNT_BASE%TYPE;
  vgc_ship_to_account_suffix     ORDER_ITEM_SHIPMENT.SHIP_TO_ACCOUNT_SUFFIX%TYPE;
  vgc_ww_account_nbr_base        ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_BASE%TYPE;
  vgc_ww_account_nbr_suffix      ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_SUFFIX%TYPE;
  vgc_ship_facility_cmprsn_code  ORDER_ITEM_SHIPMENT.SHIP_FACILITY_CMPRSN_CODE%TYPE;
  vgn_release_to_ship_var        ORDER_ITEM_SHIPMENT.RELEASE_TO_SHIP_VARIANCE%TYPE;
  vgn_schedule_to_ship_var       ORDER_ITEM_SHIPMENT.SCHEDULE_TO_SHIP_VARIANCE%TYPE;
  vgn_varbl_schedule_ship_var    ORDER_ITEM_SHIPMENT.VARBL_SCHEDULE_SHIP_VARIANCE%TYPE;
  vgn_request_to_ship_var        ORDER_ITEM_SHIPMENT.REQUEST_TO_SHIP_VARIANCE%TYPE;
  vgn_varbl_request_ship_var     ORDER_ITEM_SHIPMENT.VARBL_REQUEST_SHIP_VARIANCE%TYPE;
  vgn_request_to_schedule_var    ORDER_ITEM_SHIPMENT.REQUEST_TO_SCHEDULE_VARIANCE%TYPE;
  vgc_customer_acct_type_cde     ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE;
  vgc_industry_code              ORDER_ITEM_SHIPMENT.INDUSTRY_CODE%TYPE;
  vgn_mfr_org_key_id             ORDER_ITEM_SHIPMENT.MFR_ORG_KEY_ID%TYPE;
  vgc_mfg_campus_id              ORDER_ITEM_SHIPMENT.MFG_CAMPUS_ID%TYPE;
  vgc_mfg_building_nbr           ORDER_ITEM_SHIPMENT.MFG_BUILDING_NBR%TYPE;
  vgc_industry_business_code     ORDER_ITEM_SHIPMENT.INDUSTRY_BUSINESS_CODE%TYPE; -- alex - added 11/99
  vgn_accounting_org_key_id      ORDER_ITEM_SHIPMENT.ACCOUNTING_ORG_KEY_ID%TYPE;
  vgc_product_busns_line_fnctnid ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_FNCTN_ID%TYPE;
  vgc_profit_center_abbr_nm      ORDER_ITEM_SHIPMENT.PROFIT_CENTER_ABBR_NM%TYPE;
  vgc_sold_to_customer_id        ORDER_ITEM_SHIPMENT.SOLD_TO_CUSTOMER_ID%TYPE;
  vgc_product_busns_line_id      ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_ID%TYPE;
  vgn_product_manager_global_id  ORDER_ITEM_SHIPMENT.PRODUCT_MANAGER_GLOBAL_ID%TYPE;
  vgc_sales_office_cde           ORDER_ITEM_SHIPMENT.SALES_OFFICE_CDE%TYPE;
  vgc_sales_group_cde            ORDER_ITEM_SHIPMENT.SALES_GROUP_CDE%TYPE;
  vgn_source_system_id           BUILDING_LOCATION_SMRY.SOURCE_SYSTEM_ID%TYPE;
  vgc_mrp_group_cde              ORDER_ITEM_SHIPMENT.MRP_GROUP_CDE%TYPE;
  vgn_adjust_amount              NUMBER;
  vgn_sql_result                 NUMBER;
  vgn_day_variance               NUMBER;
  vgn_varbl_variance             NUMBER;
  vgn_ship_out_early             NUMBER;
  vgn_ship_six_early             NUMBER;
  vgn_ship_five_early            NUMBER;
  vgn_ship_four_early            NUMBER;
  vgn_ship_three_early           NUMBER;
  vgn_ship_two_early             NUMBER;
  vgn_ship_one_early             NUMBER;
  vgn_ship_on_time               NUMBER;
  vgn_ship_one_late              NUMBER;
  vgn_ship_two_late              NUMBER;
  vgn_ship_three_late            NUMBER;
  vgn_ship_four_late             NUMBER;
  vgn_ship_five_late             NUMBER;
  vgn_ship_six_late              NUMBER;
  vgn_ship_out_late              NUMBER;
  vgn_jit_out_early              NUMBER;
  vgn_jit_six_early              NUMBER;
  vgn_jit_five_early             NUMBER;
  vgn_jit_four_early             NUMBER;
  vgn_jit_three_early            NUMBER;
  vgn_jit_two_early              NUMBER;
  vgn_jit_one_early              NUMBER;
  vgn_jit_on_time                NUMBER;
  vgn_jit_one_late               NUMBER;
  vgn_jit_two_late               NUMBER;
  vgn_jit_three_late             NUMBER;
  vgn_jit_four_late              NUMBER;
  vgn_jit_five_late              NUMBER;
  vgn_jit_six_late               NUMBER;
  vgn_jit_out_late               NUMBER;
  vgn_varbl_out_early            NUMBER;
  vgn_varbl_six_early            NUMBER;
  vgn_varbl_five_early           NUMBER;
  vgn_varbl_four_early           NUMBER;
  vgn_varbl_three_early          NUMBER;
  vgn_varbl_two_early            NUMBER;
  vgn_varbl_one_early            NUMBER;
  vgn_varbl_on_time              NUMBER;
  vgn_varbl_one_late             NUMBER;
  vgn_varbl_two_late             NUMBER;
  vgn_varbl_three_late           NUMBER;
  vgn_varbl_four_late            NUMBER;
  vgn_varbl_five_late            NUMBER;
  vgn_varbl_six_late             NUMBER;
  vgn_varbl_out_late             NUMBER;
  vgn_total_jit_ship             NUMBER;
  vgn_total_shipments            NUMBER;
  ue_critical_db_error EXCEPTION;
  ue_smry_update_error EXCEPTION;

  -- This date is the first day of 2nd Qtr of Fiscal 2003 which is the oldest complete 
  -- Qtr we could build OPX Weekly SMRY history based from SCD detail table.
  kd_opx_smry_beg_dt CONSTANT DATE := TO_DATE('2002-12-22', 'YYYY-MM-DD');

  TYPE cust_lookup_table IS TABLE OF VARCHAR2(3) INDEX BY VARCHAR2(12);
  exclude_cust_list cust_lookup_table;
  vgb_first_pass    BOOLEAN := TRUE;

  CURSOR cust_cur IS
    SELECT DISTINCT SUBSTR(PARAMETER_DESCRIPTION, 1, 4) || PARAMETER_FIELD OrgID_Cust
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID LIKE 'RPT1EXCLUDECUST%';

  FUNCTION f_is_cust_in_exclusion_list(iOrgIDCust    VARCHAR2,
                                       io_sql_result OUT NUMBER)
    RETURN BOOLEAN IS
  BEGIN
    io_sql_result := 0;
    IF vgb_first_pass THEN
      vgb_first_pass := FALSE;
      FOR cust_rec IN cust_cur LOOP
        BEGIN
          exclude_cust_list(cust_rec.OrgID_Cust) := 'YES';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;
      END LOOP;
    END IF;
  
    BEGIN
      IF exclude_cust_list(iOrgIDCust) = 'YES' THEN
        RETURN TRUE; -- in cust list       
      END IF;
      RETURN FALSE; -- not in cust list 
    
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RETURN FALSE; -- not in cust list      
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      io_sql_result := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('f_is_cust_in_exclusion_list');
      DBMS_OUTPUT.PUT_LINE('OrgID and Cust ID :' || iOrgIDCust);
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(io_sql_result));
      RETURN FALSE; -- not in cust list            
  END f_is_cust_in_exclusion_list;

  /****************************************************************************/
  /* PROCEDURE:   p_initialize_delta_variables                                */
  /* DESCRIPTION: Initialize the variables used by the adjust summary         */
  /*              procedures.                                                 */
  /****************************************************************************/
  PROCEDURE p_initialize_delta_variables(vin_counter IN NUMBER) IS
  BEGIN
    vgn_ship_out_early    := 0;
    vgn_ship_six_early    := 0;
    vgn_ship_five_early   := 0;
    vgn_ship_four_early   := 0;
    vgn_ship_three_early  := 0;
    vgn_ship_two_early    := 0;
    vgn_ship_one_early    := 0;
    vgn_ship_on_time      := 0;
    vgn_ship_one_late     := 0;
    vgn_ship_two_late     := 0;
    vgn_ship_three_late   := 0;
    vgn_ship_four_late    := 0;
    vgn_ship_five_late    := 0;
    vgn_ship_six_late     := 0;
    vgn_ship_out_late     := 0;
    vgn_jit_out_early     := 0;
    vgn_jit_six_early     := 0;
    vgn_jit_five_early    := 0;
    vgn_jit_four_early    := 0;
    vgn_jit_three_early   := 0;
    vgn_jit_two_early     := 0;
    vgn_jit_one_early     := 0;
    vgn_jit_on_time       := 0;
    vgn_jit_one_late      := 0;
    vgn_jit_two_late      := 0;
    vgn_jit_three_late    := 0;
    vgn_jit_four_late     := 0;
    vgn_jit_five_late     := 0;
    vgn_jit_six_late      := 0;
    vgn_jit_out_late      := 0;
    vgn_total_jit_ship    := 0;
    vgn_varbl_out_early   := 0;
    vgn_varbl_six_early   := 0;
    vgn_varbl_five_early  := 0;
    vgn_varbl_four_early  := 0;
    vgn_varbl_three_early := 0;
    vgn_varbl_two_early   := 0;
    vgn_varbl_one_early   := 0;
    vgn_varbl_on_time     := 0;
    vgn_varbl_one_late    := 0;
    vgn_varbl_two_late    := 0;
    vgn_varbl_three_late  := 0;
    vgn_varbl_four_late   := 0;
    vgn_varbl_five_late   := 0;
    vgn_varbl_six_late    := 0;
    vgn_varbl_out_late    := 0;
    IF (vgn_day_variance < -6) THEN
      vgn_ship_out_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -6) THEN
      vgn_ship_six_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -5) THEN
      vgn_ship_five_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -4) THEN
      vgn_ship_four_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -3) THEN
      vgn_ship_three_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -2) THEN
      vgn_ship_two_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = -1) THEN
      vgn_ship_one_early := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 0) THEN
      vgn_ship_on_time := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 1) THEN
      vgn_ship_one_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 2) THEN
      vgn_ship_two_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 3) THEN
      vgn_ship_three_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 4) THEN
      vgn_ship_four_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 5) THEN
      vgn_ship_five_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance = 6) THEN
      vgn_ship_six_late := vgn_adjust_amount;
    ELSIF (vgn_day_variance > 6) THEN
      vgn_ship_out_late := vgn_adjust_amount;
    END IF;
    /* only types 1 and 2 use the varable variance */
    IF (vin_counter < 3) THEN
      IF (vgn_varbl_variance < -6) THEN
        vgn_varbl_out_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -6) THEN
        vgn_varbl_six_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -5) THEN
        vgn_varbl_five_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -4) THEN
        vgn_varbl_four_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -3) THEN
        vgn_varbl_three_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -2) THEN
        vgn_varbl_two_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = -1) THEN
        vgn_varbl_one_early := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 0) THEN
        vgn_varbl_on_time := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 1) THEN
        vgn_varbl_one_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 2) THEN
        vgn_varbl_two_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 3) THEN
        vgn_varbl_three_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 4) THEN
        vgn_varbl_four_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 5) THEN
        vgn_varbl_five_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance = 6) THEN
        vgn_varbl_six_late := vgn_adjust_amount;
      ELSIF (vgn_varbl_variance > 6) THEN
        vgn_varbl_out_late := vgn_adjust_amount;
      END IF;
    END IF;
    IF vgc_customer_type_code = 'J' THEN
      vgn_jit_out_early   := vgn_ship_out_early;
      vgn_jit_six_early   := vgn_ship_six_early;
      vgn_jit_five_early  := vgn_ship_five_early;
      vgn_jit_four_early  := vgn_ship_four_early;
      vgn_jit_three_early := vgn_ship_three_early;
      vgn_jit_two_early   := vgn_ship_two_early;
      vgn_jit_one_early   := vgn_ship_one_early;
      vgn_jit_on_time     := vgn_ship_on_time;
      vgn_jit_one_late    := vgn_ship_one_late;
      vgn_jit_two_late    := vgn_ship_two_late;
      vgn_jit_three_late  := vgn_ship_three_late;
      vgn_jit_four_late   := vgn_ship_four_late;
      vgn_jit_five_late   := vgn_ship_five_late;
      vgn_jit_six_late    := vgn_ship_six_late;
      vgn_jit_out_late    := vgn_ship_out_late;
      vgn_total_jit_ship  := vgn_adjust_amount;
    END IF;
  END p_initialize_delta_variables;
  /****************************************************************************/
  /* PROCEDURE:   p_get_bldg_loc_smry                                         */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              BUILDING_LOCATION_SMRY table for the supplied key.          */
  /****************************************************************************/
  PROCEDURE p_get_bldg_loc_smry(vic_delivery_smry_type IN BUILDING_LOCATION_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                vid_amp_shipped_month  IN BUILDING_LOCATION_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM BUILDING_LOCATION_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND ACTUAL_SHIP_BUILDING_NBR = vgc_actual_ship_building_nbr
       AND ACTUAL_SHIP_LOCATION = vgc_actual_ship_location
       AND SALES_OFFICE_CDE = vgc_sales_office_cde
       AND SALES_GROUP_CDE = vgc_sales_group_cde
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
       AND MRP_GROUP_CDE = vgc_mrp_group_cde
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND SOURCE_SYSTEM_ID = vgn_source_system_id
       AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_BLDG_LOC_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_bldg_loc_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_mfg_camp_bldg_smry                                    */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              MFG_CAMPUS_BLDG_SMRY for the supplied key.                  */
  /****************************************************************************/
  PROCEDURE p_get_mfg_camp_bldg_smry(vic_delivery_smry_type IN MFG_CAMPUS_BLDG_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                     vid_amp_shipped_month  IN MFG_CAMPUS_BLDG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                     von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM MFG_CAMPUS_BLDG_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type
       AND MFG_CAMPUS_ID = vgc_mfg_campus_id
       AND MFG_BUILDING_NBR = vgc_mfg_building_nbr
       AND PRODUCT_LINE_CODE = vgc_product_line_code
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND MFR_ORG_KEY_ID = vgn_mfr_org_key_id
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id;
  
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_MFG_CAMP_BLDG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_mfg_camp_bldg_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_cntrlr_prod_line_smry                                 */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              CNTRLR_PROD_LINE_SMRY table for the supplied key.           */
  /****************************************************************************/
  PROCEDURE p_get_cntrlr_prod_line_smry(vic_delivery_smry_type IN CNTRLR_PROD_LINE_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                        vid_amp_shipped_month  IN CNTRLR_PROD_LINE_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                        von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM CNTRLR_PROD_LINE_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND TEAM_CODE = vgc_team_code
       AND PRODUCT_LINE_CODE = vgc_product_line_code
       AND PRODUCT_CODE = vgc_product_code
       AND PRODUCT_MANAGER_GLOBAL_ID = vgn_product_manager_global_id
       AND PRODCN_CNTRLR_EMPLOYEE_NBR = vgc_prodcn_cntrlr_employee_nbr
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_CNTRLR_PROD_LINE_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_cntrlr_prod_line_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_customer_smry_t1                                   */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              CUSTOMER_ACCOUNT_SMRY_T1 table for the supplied key.        */
  /****************************************************************************/
  PROCEDURE p_get_customer_smry_t1(vid_amp_shipped_month IN CUSTOMER_ACCOUNT_SMRY_T1.AMP_SHIPPED_MONTH%TYPE,
                                   von_sqlcode           OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM CUSTOMER_ACCOUNT_SMRY_T1
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
       AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
       AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
       AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
       AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND TEAM_CODE = vgc_team_code
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
       AND DELIVERY_SMRY_TYPE = '1';
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_CUSTOMER_SMRY_T1');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_customer_smry_t1;
  /****************************************************************************/
  /* PROCEDURE:   p_get_scorecard_org_smry                                    */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              SCORECARD_ORG_SMRY       table for the supplied key.        */
  /****************************************************************************/
  PROCEDURE p_get_scorecard_org_smry(vic_delivery_smry_type IN SCORECARD_ORG_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                     vid_amp_shipped_month  IN SCORECARD_ORG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                     von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM SCORECARD_ORG_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_SCORECARD_ORG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
      DBMS_OUTPUT.PUT_LINE('AMP_SHIPPED_MONTH = ' || vid_amp_shipped_month);
      DBMS_OUTPUT.PUT_LINE('ORGANIZATION_KEY_ID = ' ||
                           vgn_organization_key_id);
      DBMS_OUTPUT.PUT_LINE('CUSTOMER_ACCT_TYPE_CDE = ' ||
                           vgc_customer_acct_type_cde);
      DBMS_OUTPUT.PUT_LINE('DELIVERY_SMRY_TYPE = ' ||
                           vic_delivery_smry_type);
  END p_get_scorecard_org_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_team_org_smry                                         */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              TEAM_ORG_SMRY            table for the supplied key.        */
  /****************************************************************************/
  PROCEDURE p_get_team_org_smry(vic_delivery_smry_type IN TEAM_ORG_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                vid_amp_shipped_month  IN TEAM_ORG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM TEAM_ORG_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND PRODUCT_CODE = vgc_product_code
       AND PRODUCT_LINE_CODE = vgc_product_line_code
       AND TEAM_CODE = vgc_team_code
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type
       AND MRP_GROUP_CDE = vgc_mrp_group_cde
       AND STOCK_MAKE_CODE = vgc_stock_make_code;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_TEAM_ORG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_team_org_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_industry_code_smry                                         */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              INDUSTRY_CODE_SMRY       table for the supplied key.        */
  /****************************************************************************/
  PROCEDURE p_get_industry_code_smry(vic_delivery_smry_type IN industry_code_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                     vid_amp_shipped_month  IN industry_code_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                     von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM industry_code_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND INDUSTRY_CODE = vgc_industry_code
       AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
       AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
       AND MRP_GROUP_CDE = vgc_mrp_group_cde
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type
       AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code; -- alex - added 11/99
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_industry_code_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_industry_code_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_profit_center_smry                                    */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              PROFIT_CENTER_SMRY table for the supplied key.            */
  /****************************************************************************/
  PROCEDURE p_get_profit_center_smry(vic_delivery_smry_type IN PROFIT_CENTER_SMRY.DELIVERY_SMRY_TYPE%TYPE,
                                     vid_amp_shipped_month  IN PROFIT_CENTER_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                     von_sqlcode            OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_NBR_SHPMTS
      INTO vgn_total_shipments
      FROM PROFIT_CENTER_SMRY
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code
       AND PRODUCT_BUSNS_LINE_FNCTN_ID = vgc_product_busns_line_fnctnid
       AND PRODUCT_BUSNS_LINE_ID = vgc_product_busns_line_id
       AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
       AND MRP_GROUP_CDE = vgc_mrp_group_cde
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND DELIVERY_SMRY_TYPE = vic_delivery_smry_type;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_PROFIT_CENTER_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_profit_center_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_get_opx_weekly_smry                                    */
  /* DESCRIPTION: Retrieves the total number of shipments from the            */
  /*              PROFIT_CENTER_SMRY table for the supplied key.            */
  /****************************************************************************/
  PROCEDURE p_get_opx_weekly_smry(von_sqlcode OUT NUMBER) IS
  BEGIN
    vgn_total_shipments := 0;
    SELECT TOTAL_SHIPMENT_QTY
      INTO vgn_total_shipments
      FROM SCD_DELIVERY_PERFORMANCE_SMRY
     WHERE FISCAL_WEEK_ID = vg_dps_rec.FISCAL_WEEK_ID
       AND FISCAL_YEAR_ID = vg_dps_rec.FISCAL_YEAR_ID
       AND ORGANIZATION_KEY_ID = vg_dps_rec.ORGANIZATION_KEY_ID
       AND REGION_ORG_ID = vg_dps_rec.REGION_ORG_ID
       AND ACTUAL_SHIP_BUILDING_NBR = vgc_ACTUAL_SHIP_BUILDING_NBR
       AND MFG_BUILDING_NBR = vgc_MFG_BUILDING_NBR
       AND PROFIT_CENTER_ABBR_NM = vgc_PROFIT_CENTER_ABBR_NM
       AND PRODUCT_BUSNS_LINE_ID = vgc_PRODUCT_BUSNS_LINE_ID
       AND INDUSTRY_BUSINESS_CODE = vgc_INDUSTRY_BUSINESS_CODE;
    von_sqlcode := SQLCODE;
  EXCEPTION
    WHEN OTHERS THEN
      von_sqlcode := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_GET_OPX_WEEKLY_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_get_opx_weekly_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_customer_smry_t1                                   */
  /* DESCRIPTION:  Adjusts summary rows for CUSTOMER_ACCOUNT_SMRY_T1          */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_customer_smry_t1(vid_amp_shipped_month IN CUSTOMER_ACCOUNT_SMRY_T1.AMP_SHIPPED_MONTH%TYPE,
                                      vioc_action_taken     IN OUT CHAR,
                                      von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    /* Update record */
    UPDATE CUSTOMER_ACCOUNT_SMRY_T1
       SET DML_ORACLE_ID               = vgc_job_id,
           DML_TMSTMP                  = SYSDATE,
           NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                         vgn_ship_out_early,
           NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                         vgn_ship_six_early,
           NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                         vgn_ship_five_early,
           NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                         vgn_ship_four_early,
           NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                         vgn_ship_three_early,
           NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                         vgn_ship_two_early,
           NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                         vgn_ship_one_early,
           NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                         vgn_ship_on_time,
           NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                         vgn_ship_one_late,
           NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                         vgn_ship_two_late,
           NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                         vgn_ship_three_late,
           NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                         vgn_ship_four_late,
           NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                         vgn_ship_five_late,
           NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                         vgn_ship_six_late,
           NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                         vgn_ship_out_late,
           TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                         vgn_adjust_amount,
           NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                         vgn_jit_out_early,
           NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                         vgn_jit_six_early,
           NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                         vgn_jit_five_early,
           NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                         vgn_jit_four_early,
           NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                         vgn_jit_three_early,
           NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                         vgn_jit_two_early,
           NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                         vgn_jit_one_early,
           NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME + vgn_jit_on_time,
           NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                         vgn_jit_one_late,
           NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                         vgn_jit_two_late,
           NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                         vgn_jit_three_late,
           NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                         vgn_jit_four_late,
           NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                         vgn_jit_five_late,
           NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                         vgn_jit_six_late,
           NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                         vgn_jit_out_late,
           TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                         vgn_total_jit_ship,
           NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                         vgn_varbl_out_early,
           NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                         vgn_varbl_six_early,
           NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                         vgn_varbl_five_early,
           NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                         vgn_varbl_four_early,
           NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                         vgn_varbl_three_early,
           NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                         vgn_varbl_two_early,
           NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                         vgn_varbl_one_early,
           NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                         vgn_varbl_on_time,
           NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                         vgn_varbl_one_late,
           NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                         vgn_varbl_two_late,
           NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                         vgn_varbl_three_late,
           NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                         vgn_varbl_four_late,
           NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                         vgn_varbl_five_late,
           NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                         vgn_varbl_six_late,
           NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                         vgn_varbl_out_late
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
       AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
       AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
       AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
       AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND TEAM_CODE = vgc_team_code
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
       AND DELIVERY_SMRY_TYPE = vgc_smry_type;
    IF SQL%NOTFOUND THEN
      /* Insert Recrod */
      INSERT INTO CUSTOMER_ACCOUNT_SMRY_T1
        (CUSTOMER_ACCOUNT_SMRY_SEQ,
         DELIVERY_SMRY_TYPE,
         AMP_SHIPPED_MONTH,
         WW_ACCOUNT_NBR_BASE,
         WW_ACCOUNT_NBR_SUFFIX,
         PURCHASE_BY_ACCOUNT_BASE,
         SHIP_TO_ACCOUNT_SUFFIX,
         SOLD_TO_CUSTOMER_ID,
         PRODCN_CNTRLR_CODE,
         CONTROLLER_UNIQUENESS_ID,
         TEAM_CODE,
         STOCK_MAKE_CODE,
         ORGANIZATION_KEY_ID,
         ACCOUNTING_ORG_KEY_ID,
         DML_ORACLE_ID,
         DML_TMSTMP,
         NBR_SHPMTS_OUT_RANGE_EARLY,
         NBR_SHPMTS_SIX_DAYS_EARLY,
         NBR_SHPMTS_FIVE_DAYS_EARLY,
         NBR_SHPMTS_FOUR_DAYS_EARLY,
         NBR_SHPMTS_THREE_DAYS_EARLY,
         NBR_SHPMTS_TWO_DAYS_EARLY,
         NBR_SHPMTS_ONE_DAY_EARLY,
         NBR_SHPMTS_ON_TIME,
         NBR_SHPMTS_ONE_DAY_LATE,
         NBR_SHPMTS_TWO_DAYS_LATE,
         NBR_SHPMTS_THREE_DAYS_LATE,
         NBR_SHPMTS_FOUR_DAYS_LATE,
         NBR_SHPMTS_FIVE_DAYS_LATE,
         NBR_SHPMTS_SIX_DAYS_LATE,
         NBR_SHPMTS_OUT_RANGE_LATE,
         TOTAL_NBR_SHPMTS,
         NBR_JIT_OUT_RANGE_EARLY,
         NBR_JIT_SIX_DAYS_EARLY,
         NBR_JIT_FIVE_DAYS_EARLY,
         NBR_JIT_FOUR_DAYS_EARLY,
         NBR_JIT_THREE_DAYS_EARLY,
         NBR_JIT_TWO_DAYS_EARLY,
         NBR_JIT_ONE_DAY_EARLY,
         NBR_JIT_ON_TIME,
         NBR_JIT_ONE_DAY_LATE,
         NBR_JIT_TWO_DAYS_LATE,
         NBR_JIT_THREE_DAYS_LATE,
         NBR_JIT_FOUR_DAYS_LATE,
         NBR_JIT_FIVE_DAYS_LATE,
         NBR_JIT_SIX_DAYS_LATE,
         NBR_JIT_OUT_RANGE_LATE,
         TOTAL_NBR_JIT_SHPMTS,
         NBR_VARBL_OUT_RANGE_EARLY,
         NBR_VARBL_SIX_DAYS_EARLY,
         NBR_VARBL_FIVE_DAYS_EARLY,
         NBR_VARBL_FOUR_DAYS_EARLY,
         NBR_VARBL_THREE_DAYS_EARLY,
         NBR_VARBL_TWO_DAYS_EARLY,
         NBR_VARBL_ONE_DAY_EARLY,
         NBR_VARBL_ON_TIME,
         NBR_VARBL_ONE_DAY_LATE,
         NBR_VARBL_TWO_DAYS_LATE,
         NBR_VARBL_THREE_DAYS_LATE,
         NBR_VARBL_FOUR_DAYS_LATE,
         NBR_VARBL_FIVE_DAYS_LATE,
         NBR_VARBL_SIX_DAYS_LATE,
         NBR_VARBL_OUT_RANGE_LATE)
      VALUES
        (CUSTOMER_ACCOUNT_SMRY_SEQ.NEXTVAL,
         vgc_smry_type,
         vid_amp_shipped_month,
         vgc_ww_account_nbr_base,
         vgc_ww_account_nbr_suffix,
         vgc_purchase_by_account_base,
         vgc_ship_to_account_suffix,
         vgc_sold_to_customer_id,
         vgc_prodcn_cntrlr_code,
         vgc_controller_uniqueness_id,
         vgc_team_code,
         vgc_stock_make_code,
         vgn_organization_key_id,
         vgn_accounting_org_key_id,
         vgc_job_id,
         SYSDATE,
         vgn_ship_out_early,
         vgn_ship_six_early,
         vgn_ship_five_early,
         vgn_ship_four_early,
         vgn_ship_three_early,
         vgn_ship_two_early,
         vgn_ship_one_early,
         vgn_ship_on_time,
         vgn_ship_one_late,
         vgn_ship_two_late,
         vgn_ship_three_late,
         vgn_ship_four_late,
         vgn_ship_five_late,
         vgn_ship_six_late,
         vgn_ship_out_late,
         vgn_adjust_amount,
         vgn_jit_out_early,
         vgn_jit_six_early,
         vgn_jit_five_early,
         vgn_jit_four_early,
         vgn_jit_three_early,
         vgn_jit_two_early,
         vgn_jit_one_early,
         vgn_jit_on_time,
         vgn_jit_one_late,
         vgn_jit_two_late,
         vgn_jit_three_late,
         vgn_jit_four_late,
         vgn_jit_five_late,
         vgn_jit_six_late,
         vgn_jit_out_late,
         vgn_total_jit_ship,
         vgn_varbl_out_early,
         vgn_varbl_six_early,
         vgn_varbl_five_early,
         vgn_varbl_four_early,
         vgn_varbl_three_early,
         vgn_varbl_two_early,
         vgn_varbl_one_early,
         vgn_varbl_on_time,
         vgn_varbl_one_late,
         vgn_varbl_two_late,
         vgn_varbl_three_late,
         vgn_varbl_four_late,
         vgn_varbl_five_late,
         vgn_varbl_six_late,
         vgn_varbl_out_late);
      vioc_action_taken := 'I';
    END IF;
    von_result_code := SQLCODE;
  END p_adjust_customer_smry_t1;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_customer_smry_t2                                   */
  /* DESCRIPTION:  Adjusts summary rows for CUSTOMER_ACCOUNT_SMRY_T2          */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_customer_smry_t2(vid_amp_shipped_month IN CUSTOMER_ACCOUNT_SMRY_T2.AMP_SHIPPED_MONTH%TYPE,
                                      vioc_action_taken     IN OUT CHAR,
                                      von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    /* Update record */
    UPDATE CUSTOMER_ACCOUNT_SMRY_T2
       SET DML_ORACLE_ID               = vgc_job_id,
           DML_TMSTMP                  = SYSDATE,
           NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                         vgn_ship_out_early,
           NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                         vgn_ship_six_early,
           NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                         vgn_ship_five_early,
           NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                         vgn_ship_four_early,
           NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                         vgn_ship_three_early,
           NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                         vgn_ship_two_early,
           NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                         vgn_ship_one_early,
           NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                         vgn_ship_on_time,
           NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                         vgn_ship_one_late,
           NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                         vgn_ship_two_late,
           NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                         vgn_ship_three_late,
           NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                         vgn_ship_four_late,
           NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                         vgn_ship_five_late,
           NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                         vgn_ship_six_late,
           NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                         vgn_ship_out_late,
           TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                         vgn_adjust_amount,
           NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                         vgn_jit_out_early,
           NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                         vgn_jit_six_early,
           NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                         vgn_jit_five_early,
           NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                         vgn_jit_four_early,
           NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                         vgn_jit_three_early,
           NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                         vgn_jit_two_early,
           NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                         vgn_jit_one_early,
           NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME + vgn_jit_on_time,
           NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                         vgn_jit_one_late,
           NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                         vgn_jit_two_late,
           NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                         vgn_jit_three_late,
           NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                         vgn_jit_four_late,
           NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                         vgn_jit_five_late,
           NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                         vgn_jit_six_late,
           NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                         vgn_jit_out_late,
           TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                         vgn_total_jit_ship,
           NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                         vgn_varbl_out_early,
           NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                         vgn_varbl_six_early,
           NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                         vgn_varbl_five_early,
           NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                         vgn_varbl_four_early,
           NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                         vgn_varbl_three_early,
           NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                         vgn_varbl_two_early,
           NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                         vgn_varbl_one_early,
           NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                         vgn_varbl_on_time,
           NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                         vgn_varbl_one_late,
           NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                         vgn_varbl_two_late,
           NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                         vgn_varbl_three_late,
           NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                         vgn_varbl_four_late,
           NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                         vgn_varbl_five_late,
           NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                         vgn_varbl_six_late,
           NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                         vgn_varbl_out_late
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
       AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
       AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
       AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
       AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND TEAM_CODE = vgc_team_code
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
       AND DELIVERY_SMRY_TYPE = vgc_smry_type;
    IF SQL%NOTFOUND THEN
      /* Insert Recrod */
      INSERT INTO CUSTOMER_ACCOUNT_SMRY_T2
        (CUSTOMER_ACCOUNT_SMRY_SEQ,
         DELIVERY_SMRY_TYPE,
         AMP_SHIPPED_MONTH,
         WW_ACCOUNT_NBR_BASE,
         WW_ACCOUNT_NBR_SUFFIX,
         PURCHASE_BY_ACCOUNT_BASE,
         SHIP_TO_ACCOUNT_SUFFIX,
         SOLD_TO_CUSTOMER_ID,
         PRODCN_CNTRLR_CODE,
         CONTROLLER_UNIQUENESS_ID,
         TEAM_CODE,
         STOCK_MAKE_CODE,
         ORGANIZATION_KEY_ID,
         ACCOUNTING_ORG_KEY_ID,
         DML_ORACLE_ID,
         DML_TMSTMP,
         NBR_SHPMTS_OUT_RANGE_EARLY,
         NBR_SHPMTS_SIX_DAYS_EARLY,
         NBR_SHPMTS_FIVE_DAYS_EARLY,
         NBR_SHPMTS_FOUR_DAYS_EARLY,
         NBR_SHPMTS_THREE_DAYS_EARLY,
         NBR_SHPMTS_TWO_DAYS_EARLY,
         NBR_SHPMTS_ONE_DAY_EARLY,
         NBR_SHPMTS_ON_TIME,
         NBR_SHPMTS_ONE_DAY_LATE,
         NBR_SHPMTS_TWO_DAYS_LATE,
         NBR_SHPMTS_THREE_DAYS_LATE,
         NBR_SHPMTS_FOUR_DAYS_LATE,
         NBR_SHPMTS_FIVE_DAYS_LATE,
         NBR_SHPMTS_SIX_DAYS_LATE,
         NBR_SHPMTS_OUT_RANGE_LATE,
         TOTAL_NBR_SHPMTS,
         NBR_JIT_OUT_RANGE_EARLY,
         NBR_JIT_SIX_DAYS_EARLY,
         NBR_JIT_FIVE_DAYS_EARLY,
         NBR_JIT_FOUR_DAYS_EARLY,
         NBR_JIT_THREE_DAYS_EARLY,
         NBR_JIT_TWO_DAYS_EARLY,
         NBR_JIT_ONE_DAY_EARLY,
         NBR_JIT_ON_TIME,
         NBR_JIT_ONE_DAY_LATE,
         NBR_JIT_TWO_DAYS_LATE,
         NBR_JIT_THREE_DAYS_LATE,
         NBR_JIT_FOUR_DAYS_LATE,
         NBR_JIT_FIVE_DAYS_LATE,
         NBR_JIT_SIX_DAYS_LATE,
         NBR_JIT_OUT_RANGE_LATE,
         TOTAL_NBR_JIT_SHPMTS,
         NBR_VARBL_OUT_RANGE_EARLY,
         NBR_VARBL_SIX_DAYS_EARLY,
         NBR_VARBL_FIVE_DAYS_EARLY,
         NBR_VARBL_FOUR_DAYS_EARLY,
         NBR_VARBL_THREE_DAYS_EARLY,
         NBR_VARBL_TWO_DAYS_EARLY,
         NBR_VARBL_ONE_DAY_EARLY,
         NBR_VARBL_ON_TIME,
         NBR_VARBL_ONE_DAY_LATE,
         NBR_VARBL_TWO_DAYS_LATE,
         NBR_VARBL_THREE_DAYS_LATE,
         NBR_VARBL_FOUR_DAYS_LATE,
         NBR_VARBL_FIVE_DAYS_LATE,
         NBR_VARBL_SIX_DAYS_LATE,
         NBR_VARBL_OUT_RANGE_LATE)
      VALUES
        (CUSTOMER_ACCOUNT_SMRY_SEQ.NEXTVAL,
         vgc_smry_type,
         vid_amp_shipped_month,
         vgc_ww_account_nbr_base,
         vgc_ww_account_nbr_suffix,
         vgc_purchase_by_account_base,
         vgc_ship_to_account_suffix,
         vgc_sold_to_customer_id,
         vgc_prodcn_cntrlr_code,
         vgc_controller_uniqueness_id,
         vgc_team_code,
         vgc_stock_make_code,
         vgn_organization_key_id,
         vgn_accounting_org_key_id,
         vgc_job_id,
         SYSDATE,
         vgn_ship_out_early,
         vgn_ship_six_early,
         vgn_ship_five_early,
         vgn_ship_four_early,
         vgn_ship_three_early,
         vgn_ship_two_early,
         vgn_ship_one_early,
         vgn_ship_on_time,
         vgn_ship_one_late,
         vgn_ship_two_late,
         vgn_ship_three_late,
         vgn_ship_four_late,
         vgn_ship_five_late,
         vgn_ship_six_late,
         vgn_ship_out_late,
         vgn_adjust_amount,
         vgn_jit_out_early,
         vgn_jit_six_early,
         vgn_jit_five_early,
         vgn_jit_four_early,
         vgn_jit_three_early,
         vgn_jit_two_early,
         vgn_jit_one_early,
         vgn_jit_on_time,
         vgn_jit_one_late,
         vgn_jit_two_late,
         vgn_jit_three_late,
         vgn_jit_four_late,
         vgn_jit_five_late,
         vgn_jit_six_late,
         vgn_jit_out_late,
         vgn_total_jit_ship,
         vgn_varbl_out_early,
         vgn_varbl_six_early,
         vgn_varbl_five_early,
         vgn_varbl_four_early,
         vgn_varbl_three_early,
         vgn_varbl_two_early,
         vgn_varbl_one_early,
         vgn_varbl_on_time,
         vgn_varbl_one_late,
         vgn_varbl_two_late,
         vgn_varbl_three_late,
         vgn_varbl_four_late,
         vgn_varbl_five_late,
         vgn_varbl_six_late,
         vgn_varbl_out_late);
      vioc_action_taken := 'I';
    END IF;
    von_result_code := SQLCODE;
  END p_adjust_customer_smry_t2;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_customer_smry_t3                                   */
  /* DESCRIPTION:  Adjusts summary rows for CUSTOMER_ACCOUNT_SMRY_T3          */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_customer_smry_t3(vid_amp_shipped_month IN CUSTOMER_ACCOUNT_SMRY_T3.AMP_SHIPPED_MONTH%TYPE,
                                      vioc_action_taken     IN OUT CHAR,
                                      von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    /* Update record */
    UPDATE CUSTOMER_ACCOUNT_SMRY_T3
       SET DML_ORACLE_ID               = vgc_job_id,
           DML_TMSTMP                  = SYSDATE,
           NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                         vgn_ship_out_early,
           NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                         vgn_ship_six_early,
           NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                         vgn_ship_five_early,
           NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                         vgn_ship_four_early,
           NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                         vgn_ship_three_early,
           NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                         vgn_ship_two_early,
           NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                         vgn_ship_one_early,
           NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                         vgn_ship_on_time,
           NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                         vgn_ship_one_late,
           NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                         vgn_ship_two_late,
           NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                         vgn_ship_three_late,
           NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                         vgn_ship_four_late,
           NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                         vgn_ship_five_late,
           NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                         vgn_ship_six_late,
           NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                         vgn_ship_out_late,
           TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                         vgn_adjust_amount,
           NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                         vgn_jit_out_early,
           NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                         vgn_jit_six_early,
           NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                         vgn_jit_five_early,
           NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                         vgn_jit_four_early,
           NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                         vgn_jit_three_early,
           NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                         vgn_jit_two_early,
           NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                         vgn_jit_one_early,
           NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME + vgn_jit_on_time,
           NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                         vgn_jit_one_late,
           NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                         vgn_jit_two_late,
           NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                         vgn_jit_three_late,
           NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                         vgn_jit_four_late,
           NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                         vgn_jit_five_late,
           NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                         vgn_jit_six_late,
           NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                         vgn_jit_out_late,
           TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                         vgn_total_jit_ship,
           NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                         vgn_varbl_out_early,
           NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                         vgn_varbl_six_early,
           NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                         vgn_varbl_five_early,
           NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                         vgn_varbl_four_early,
           NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                         vgn_varbl_three_early,
           NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                         vgn_varbl_two_early,
           NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                         vgn_varbl_one_early,
           NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                         vgn_varbl_on_time,
           NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                         vgn_varbl_one_late,
           NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                         vgn_varbl_two_late,
           NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                         vgn_varbl_three_late,
           NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                         vgn_varbl_four_late,
           NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                         vgn_varbl_five_late,
           NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                         vgn_varbl_six_late,
           NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                         vgn_varbl_out_late
     WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
       AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
       AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
       AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
       AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
       AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
       AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
       AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
       AND TEAM_CODE = vgc_team_code
       AND STOCK_MAKE_CODE = vgc_stock_make_code
       AND ORGANIZATION_KEY_ID = vgn_organization_key_id
       AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
       AND DELIVERY_SMRY_TYPE = vgc_smry_type;
    IF SQL%NOTFOUND THEN
      /* Insert Recrod */
      INSERT INTO CUSTOMER_ACCOUNT_SMRY_T3
        (CUSTOMER_ACCOUNT_SMRY_SEQ,
         DELIVERY_SMRY_TYPE,
         AMP_SHIPPED_MONTH,
         WW_ACCOUNT_NBR_BASE,
         WW_ACCOUNT_NBR_SUFFIX,
         PURCHASE_BY_ACCOUNT_BASE,
         SHIP_TO_ACCOUNT_SUFFIX,
         SOLD_TO_CUSTOMER_ID,
         PRODCN_CNTRLR_CODE,
         CONTROLLER_UNIQUENESS_ID,
         TEAM_CODE,
         STOCK_MAKE_CODE,
         ORGANIZATION_KEY_ID,
         ACCOUNTING_ORG_KEY_ID,
         DML_ORACLE_ID,
         DML_TMSTMP,
         NBR_SHPMTS_OUT_RANGE_EARLY,
         NBR_SHPMTS_SIX_DAYS_EARLY,
         NBR_SHPMTS_FIVE_DAYS_EARLY,
         NBR_SHPMTS_FOUR_DAYS_EARLY,
         NBR_SHPMTS_THREE_DAYS_EARLY,
         NBR_SHPMTS_TWO_DAYS_EARLY,
         NBR_SHPMTS_ONE_DAY_EARLY,
         NBR_SHPMTS_ON_TIME,
         NBR_SHPMTS_ONE_DAY_LATE,
         NBR_SHPMTS_TWO_DAYS_LATE,
         NBR_SHPMTS_THREE_DAYS_LATE,
         NBR_SHPMTS_FOUR_DAYS_LATE,
         NBR_SHPMTS_FIVE_DAYS_LATE,
         NBR_SHPMTS_SIX_DAYS_LATE,
         NBR_SHPMTS_OUT_RANGE_LATE,
         TOTAL_NBR_SHPMTS,
         NBR_JIT_OUT_RANGE_EARLY,
         NBR_JIT_SIX_DAYS_EARLY,
         NBR_JIT_FIVE_DAYS_EARLY,
         NBR_JIT_FOUR_DAYS_EARLY,
         NBR_JIT_THREE_DAYS_EARLY,
         NBR_JIT_TWO_DAYS_EARLY,
         NBR_JIT_ONE_DAY_EARLY,
         NBR_JIT_ON_TIME,
         NBR_JIT_ONE_DAY_LATE,
         NBR_JIT_TWO_DAYS_LATE,
         NBR_JIT_THREE_DAYS_LATE,
         NBR_JIT_FOUR_DAYS_LATE,
         NBR_JIT_FIVE_DAYS_LATE,
         NBR_JIT_SIX_DAYS_LATE,
         NBR_JIT_OUT_RANGE_LATE,
         TOTAL_NBR_JIT_SHPMTS,
         NBR_VARBL_OUT_RANGE_EARLY,
         NBR_VARBL_SIX_DAYS_EARLY,
         NBR_VARBL_FIVE_DAYS_EARLY,
         NBR_VARBL_FOUR_DAYS_EARLY,
         NBR_VARBL_THREE_DAYS_EARLY,
         NBR_VARBL_TWO_DAYS_EARLY,
         NBR_VARBL_ONE_DAY_EARLY,
         NBR_VARBL_ON_TIME,
         NBR_VARBL_ONE_DAY_LATE,
         NBR_VARBL_TWO_DAYS_LATE,
         NBR_VARBL_THREE_DAYS_LATE,
         NBR_VARBL_FOUR_DAYS_LATE,
         NBR_VARBL_FIVE_DAYS_LATE,
         NBR_VARBL_SIX_DAYS_LATE,
         NBR_VARBL_OUT_RANGE_LATE)
      VALUES
        (CUSTOMER_ACCOUNT_SMRY_SEQ.NEXTVAL,
         vgc_smry_type,
         vid_amp_shipped_month,
         vgc_ww_account_nbr_base,
         vgc_ww_account_nbr_suffix,
         vgc_purchase_by_account_base,
         vgc_ship_to_account_suffix,
         vgc_sold_to_customer_id,
         vgc_prodcn_cntrlr_code,
         vgc_controller_uniqueness_id,
         vgc_team_code,
         vgc_stock_make_code,
         vgn_organization_key_id,
         vgn_accounting_org_key_id,
         vgc_job_id,
         SYSDATE,
         vgn_ship_out_early,
         vgn_ship_six_early,
         vgn_ship_five_early,
         vgn_ship_four_early,
         vgn_ship_three_early,
         vgn_ship_two_early,
         vgn_ship_one_early,
         vgn_ship_on_time,
         vgn_ship_one_late,
         vgn_ship_two_late,
         vgn_ship_three_late,
         vgn_ship_four_late,
         vgn_ship_five_late,
         vgn_ship_six_late,
         vgn_ship_out_late,
         vgn_adjust_amount,
         vgn_jit_out_early,
         vgn_jit_six_early,
         vgn_jit_five_early,
         vgn_jit_four_early,
         vgn_jit_three_early,
         vgn_jit_two_early,
         vgn_jit_one_early,
         vgn_jit_on_time,
         vgn_jit_one_late,
         vgn_jit_two_late,
         vgn_jit_three_late,
         vgn_jit_four_late,
         vgn_jit_five_late,
         vgn_jit_six_late,
         vgn_jit_out_late,
         vgn_total_jit_ship,
         vgn_varbl_out_early,
         vgn_varbl_six_early,
         vgn_varbl_five_early,
         vgn_varbl_four_early,
         vgn_varbl_three_early,
         vgn_varbl_two_early,
         vgn_varbl_one_early,
         vgn_varbl_on_time,
         vgn_varbl_one_late,
         vgn_varbl_two_late,
         vgn_varbl_three_late,
         vgn_varbl_four_late,
         vgn_varbl_five_late,
         vgn_varbl_six_late,
         vgn_varbl_out_late);
      vioc_action_taken := 'I';
    END IF;
    von_result_code := SQLCODE;
  END p_adjust_customer_smry_t3;
  /****************************************************************************/
  /* PROCEDURE:    p_adjust_bldg_loc_smry                                     */
  /* DESCRIPTION:  Adjusts summary rows for BUILDING_LOCATION_SMRY            */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_bldg_loc_smry(vid_amp_shipped_month IN BUILDING_LOCATION_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                   vioc_action_taken     IN OUT CHAR,
                                   von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_bldg_loc_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all four record types: '1', '2', '3','4'     */
      /* Building Location Smry has two addition summary types     */
      /* for Shipping Facility.                                    */
      <<summary_type_loop>>
      FOR counter IN 1 .. 4 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        ELSIF counter = 4 THEN
          vgc_smry_type      := '4';
          vgn_day_variance   := vgn_release_to_ship_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE BUILDING_LOCATION_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND ACTUAL_SHIP_BUILDING_NBR = vgc_actual_ship_building_nbr
           AND ACTUAL_SHIP_LOCATION = vgc_actual_ship_location
           AND SALES_OFFICE_CDE = vgc_sales_office_cde
           AND SALES_GROUP_CDE = vgc_sales_group_cde
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
           AND MRP_GROUP_CDE = vgc_mrp_group_cde
           AND STOCK_MAKE_CODE = vgc_stock_make_code
           AND SOURCE_SYSTEM_ID = vgn_source_system_id
           AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
           AND DELIVERY_SMRY_TYPE = vgc_smry_type;
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO BUILDING_LOCATION_SMRY
            (BUILDING_LOCATION_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             ORGANIZATION_KEY_ID,
             ACTUAL_SHIP_BUILDING_NBR,
             ACTUAL_SHIP_LOCATION,
             MRP_GROUP_CDE,
             STOCK_MAKE_CODE,
             CUSTOMER_ACCT_TYPE_CDE,
             SALES_OFFICE_CDE,
             SALES_GROUP_CDE,
             SOURCE_SYSTEM_ID,
             PROFIT_CENTER_ABBR_NM,
             DML_ORACLE_ID,
             DML_TMSTMP,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE)
          VALUES
            (BUILDING_LOCATION_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgn_organization_key_id,
             vgc_actual_ship_building_nbr,
             vgc_actual_ship_location,
             vgc_mrp_group_cde,
             vgc_stock_make_code,
             vgc_customer_acct_type_cde,
             vgc_sales_office_cde,
             vgc_sales_group_cde,
             vgn_source_system_id,
             vgc_profit_center_abbr_nm,
             vgc_job_id,
             SYSDATE,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the five rows */
      DELETE BUILDING_LOCATION_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND ACTUAL_SHIP_BUILDING_NBR = vgc_actual_ship_building_nbr
         AND ACTUAL_SHIP_LOCATION = vgc_actual_ship_location
         AND SALES_OFFICE_CDE = vgc_sales_office_cde
         AND SALES_GROUP_CDE = vgc_sales_group_cde
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
         AND MRP_GROUP_CDE = vgc_mrp_group_cde
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND SOURCE_SYSTEM_ID = vgn_source_system_id
         AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3', '4');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_BLDG_LOC_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_bldg_loc_smry;
  /****************************************************************************/
  /* PROCEDURE:    p_adjust_mfg_camp_bldg_smry                                */
  /* DESCRIPTION:  Adjusts summary rows for MFG_CAMPUS_BLDG_SMRY              */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_mfg_camp_bldg_smry(vid_amp_shipped_month IN MFG_CAMPUS_BLDG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                        vioc_action_taken     IN OUT CHAR,
                                        von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_mfg_camp_bldg_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE MFG_CAMPUS_BLDG_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND DELIVERY_SMRY_TYPE = vgc_smry_type
           AND MFG_CAMPUS_ID = vgc_mfg_campus_id
           AND MFG_BUILDING_NBR = vgc_mfg_building_nbr
           AND PRODUCT_LINE_CODE = vgc_product_line_code
           AND STOCK_MAKE_CODE = vgc_stock_make_code
           AND MFR_ORG_KEY_ID = vgn_mfr_org_key_id
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id;
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO MFG_CAMPUS_BLDG_SMRY
            (MFG_CAMPUS_BLDG_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             MFR_ORG_KEY_ID,
             ORGANIZATION_KEY_ID,
             MFG_CAMPUS_ID,
             MFG_BUILDING_NBR,
             PRODUCT_LINE_CODE,
             DML_ORACLE_ID,
             DML_TMSTMP,
             STOCK_MAKE_CODE,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE)
          VALUES
            (MFG_CAMPUS_BLDG_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgn_mfr_org_key_id,
             vgn_organization_key_id,
             vgc_mfg_campus_id,
             vgc_mfg_building_nbr,
             vgc_product_line_code,
             vgc_job_id,
             SYSDATE,
             vgc_stock_make_code,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE MFG_CAMPUS_BLDG_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND MFG_CAMPUS_ID = vgc_mfg_campus_id
         AND MFG_BUILDING_NBR = vgc_mfg_building_nbr
         AND PRODUCT_LINE_CODE = vgc_product_line_code
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND MFR_ORG_KEY_ID = vgn_mfr_org_key_id
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_MFG_CAMP_BLDG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_mfg_camp_bldg_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_cntrlr_prod_line_smry                              */
  /* DESCRIPTION:  Adjusts summary rows for CNTRLR_PROD_LINE_SMRY             */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_cntrlr_prod_line_smry(vid_amp_shipped_month IN CNTRLR_PROD_LINE_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                           vioc_action_taken     IN OUT CHAR,
                                           von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_cntrlr_prod_line_smry('1',
                                  vid_amp_shipped_month,
                                  vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE CNTRLR_PROD_LINE_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
           AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
           AND TEAM_CODE = vgc_team_code
           AND PRODUCT_LINE_CODE = vgc_product_line_code
           AND PRODUCT_CODE = vgc_product_code
           AND PRODUCT_MANAGER_GLOBAL_ID = vgn_product_manager_global_id
           AND PRODCN_CNTRLR_EMPLOYEE_NBR = vgc_prodcn_cntrlr_employee_nbr
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
           AND DELIVERY_SMRY_TYPE = vgc_smry_type;
        IF SQL%NOTFOUND THEN
          /* Insert Recrod */
          INSERT INTO CNTRLR_PROD_LINE_SMRY
            (CNTRLR_PROD_LINE_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             PRODCN_CNTRLR_CODE,
             CONTROLLER_UNIQUENESS_ID,
             TEAM_CODE,
             PRODUCT_LINE_CODE,
             PRODUCT_CODE,
             PRODUCT_MANAGER_GLOBAL_ID,
             PRODCN_CNTRLR_EMPLOYEE_NBR,
             ORGANIZATION_KEY_ID,
             DML_ORACLE_ID,
             DML_TMSTMP,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE,
             CUSTOMER_ACCT_TYPE_CDE)
          VALUES
            (CNTRLR_PROD_LINE_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgc_prodcn_cntrlr_code,
             vgc_CONTROLLER_UNIQUENESS_ID,
             vgc_team_code,
             vgc_product_line_code,
             vgc_product_code,
             vgn_product_manager_global_id,
             vgc_prodcn_cntrlr_employee_nbr,
             vgn_organization_key_id,
             vgc_job_id,
             SYSDATE,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late,
             vgc_customer_acct_type_cde);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE CNTRLR_PROD_LINE_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
         AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
         AND TEAM_CODE = vgc_team_code
         AND PRODUCT_LINE_CODE = vgc_product_line_code
         AND PRODUCT_CODE = vgc_product_code
         AND PRODUCT_MANAGER_GLOBAL_ID = vgn_product_manager_global_id
         AND PRODCN_CNTRLR_EMPLOYEE_NBR = vgc_prodcn_cntrlr_employee_nbr
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_CNTRLR_PROD_LINE_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_cntrlr_prod_line_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_customer_acct_smry                                 */
  /* DESCRIPTION:  Adjusts summary rows for CUSTOMER_ACCOUNT_SMRYs            */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_customer_acct_smry(vid_amp_shipped_month IN CUSTOMER_ACCOUNT_SMRY_T1.AMP_SHIPPED_MONTH%TYPE,
                                        vioc_action_taken     IN OUT CHAR,
                                        von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_customer_smry_t1(vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
          p_initialize_delta_variables(counter);
          p_adjust_customer_smry_t1(vid_amp_shipped_month,
                                    vioc_action_taken,
                                    vgn_sql_result);
          IF (vgn_sql_result <> 0) THEN
            RAISE ue_smry_update_error;
          END IF;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
          p_initialize_delta_variables(counter);
          p_adjust_customer_smry_t2(vid_amp_shipped_month,
                                    vioc_action_taken,
                                    vgn_sql_result);
          IF (vgn_sql_result <> 0) THEN
            RAISE ue_smry_update_error;
          END IF;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
          p_initialize_delta_variables(counter);
          p_adjust_customer_smry_t3(vid_amp_shipped_month,
                                    vioc_action_taken,
                                    vgn_sql_result);
          IF (vgn_sql_result <> 0) THEN
            RAISE ue_smry_update_error;
          END IF;
        END IF;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the summary type 1 */
      DELETE CUSTOMER_ACCOUNT_SMRY_T1
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
         AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
         AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
         AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
         AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
         AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
         AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
         AND TEAM_CODE = vgc_team_code
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
         AND DELIVERY_SMRY_TYPE = '1';
      /* Delete the summary type 2 */
      DELETE CUSTOMER_ACCOUNT_SMRY_T2
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
         AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
         AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
         AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
         AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
         AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
         AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
         AND TEAM_CODE = vgc_team_code
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
         AND DELIVERY_SMRY_TYPE = '2';
      /* Delete the summary type 3 */
      DELETE CUSTOMER_ACCOUNT_SMRY_T3
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
         AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
         AND PURCHASE_BY_ACCOUNT_BASE = vgc_purchase_by_account_base
         AND SHIP_TO_ACCOUNT_SUFFIX = vgc_ship_to_account_suffix
         AND SOLD_TO_CUSTOMER_ID = vgc_sold_to_customer_id
         AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
         AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
         AND TEAM_CODE = vgc_team_code
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND ACCOUNTING_ORG_KEY_ID = vgn_accounting_org_key_id
         AND DELIVERY_SMRY_TYPE = '3';
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_CUSTOMER_ACCT_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_customer_acct_smry;

  /****************************************************************************/
  /* PROCEDURE:   p_adjust_scorecard_org_smry                                 */
  /* DESCRIPTION:  Adjusts summary rows for SCORECARD_ORG_SMRY                */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_scorecard_org_smry(vid_amp_shipped_month IN SCORECARD_ORG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                        vioc_action_taken     IN OUT CHAR,
                                        von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_scorecard_org_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE SCORECARD_ORG_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
           AND DELIVERY_SMRY_TYPE = vgc_smry_type;
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO SCORECARD_ORG_SMRY
            (SCORECARD_ORG_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             ORGANIZATION_KEY_ID,
             DML_ORACLE_ID,
             DML_TMSTMP,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE,
             CUSTOMER_ACCT_TYPE_CDE)
          VALUES
            (SCD_ORG_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgn_organization_key_id,
             vgc_job_id,
             SYSDATE,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late,
             vgc_customer_acct_type_cde);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE SCORECARD_ORG_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_SCORECARD_ORG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_scorecard_org_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_team_org_smry                                      */
  /* DESCRIPTION:  Adjusts summary rows for TEAM_ORG_SMRY                     */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_team_org_smry(vid_amp_shipped_month IN TEAM_ORG_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                   vioc_action_taken     IN OUT CHAR,
                                   von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_team_org_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('TEAM1');
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE TEAM_ORG_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND PRODUCT_CODE = vgc_product_code
           AND PRODUCT_LINE_CODE = vgc_product_line_code
           AND TEAM_CODE = vgc_team_code
           AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
           AND CONTROLLER_UNIQUENESS_ID = vgc_CONTROLLER_UNIQUENESS_ID
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND DELIVERY_SMRY_TYPE = vgc_smry_type
           AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
           AND MRP_GROUP_CDE = vgc_mrp_group_cde
           AND STOCK_MAKE_CODE = vgc_stock_make_code;
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO TEAM_ORG_SMRY
            (TEAM_ORG_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             PRODUCT_CODE,
             PRODUCT_LINE_CODE,
             TEAM_CODE,
             PRODCN_CNTRLR_CODE,
             CONTROLLER_UNIQUENESS_ID,
             ORGANIZATION_KEY_ID,
             MRP_GROUP_CDE,
             STOCK_MAKE_CODE,
             DML_ORACLE_ID,
             DML_TMSTMP,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE,
             CUSTOMER_ACCT_TYPE_CDE)
          VALUES
            (TEAM_ORG_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgc_product_code,
             vgc_product_line_code,
             vgc_team_code,
             vgc_prodcn_cntrlr_code,
             vgc_controller_uniqueness_id,
             vgn_organization_key_id,
             vgc_mrp_group_cde,
             vgc_stock_make_code,
             vgc_job_id,
             SYSDATE,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late,
             vgc_customer_acct_type_cde);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE TEAM_ORG_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND PRODUCT_CODE = vgc_product_code
         AND PRODUCT_LINE_CODE = vgc_product_line_code
         AND TEAM_CODE = vgc_team_code
         AND PRODCN_CNTRLR_CODE = vgc_prodcn_cntrlr_code
         AND CONTROLLER_UNIQUENESS_ID = vgc_controller_uniqueness_id
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND MRP_GROUP_CDE = vgc_mrp_group_cde
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      DBMS_OUTPUT.PUT_LINE('TEAM2');
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('TEAM3');
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_TEAM_ORG_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_team_org_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_industry_code_smry                                 */
  /* DESCRIPTION:  Adjusts summary rows for industry_code_SMRY                */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_industry_code_smry(vid_amp_shipped_month IN industry_code_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                        vioc_action_taken     IN OUT CHAR,
                                        von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_industry_code_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('INDUSTRY1');
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE industry_code_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND INDUSTRY_CODE = vgc_industry_code
           AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
           AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
           AND MRP_GROUP_CDE = vgc_mrp_group_cde
           AND STOCK_MAKE_CODE = vgc_stock_make_code
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND DELIVERY_SMRY_TYPE = vgc_smry_type
           AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code; -- alex - added 11/99
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO industry_code_SMRY
            (industry_code_SMRY_SEQ,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             INDUSTRY_CODE,
             WW_ACCOUNT_NBR_BASE,
             WW_ACCOUNT_NBR_SUFFIX,
             MRP_GROUP_CDE,
             STOCK_MAKE_CODE,
             ORGANIZATION_KEY_ID,
             DML_ORACLE_ID,
             DML_TMSTMP,
             INDUSTRY_BUSINESS_CDE,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE)
          VALUES
            (industry_code_SMRY_SEQ.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgc_industry_code,
             vgc_ww_account_nbr_base,
             vgc_ww_account_nbr_suffix,
             vgc_mrp_group_cde,
             vgc_stock_make_code,
             vgn_organization_key_id,
             vgc_job_id,
             SYSDATE,
             vgc_industry_business_code, -- alex - added 11/99
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE industry_code_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND INDUSTRY_CODE = vgc_industry_code
         AND WW_ACCOUNT_NBR_BASE = vgc_ww_account_nbr_base
         AND WW_ACCOUNT_NBR_SUFFIX = vgc_ww_account_nbr_suffix
         AND MRP_GROUP_CDE = vgc_mrp_group_cde
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3')
         AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code; -- alex - added 11/99
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      DBMS_OUTPUT.PUT_LINE('INDUSTRY2');
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('INDUSTRY3');
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_industry_code_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_industry_code_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_profit_center_smry                                 */
  /* DESCRIPTION:  Adjusts summary rows for PROFIT_CENTER_SMRY                */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_profit_center_smry(vid_amp_shipped_month IN PROFIT_CENTER_SMRY.AMP_SHIPPED_MONTH%TYPE,
                                        vioc_action_taken     IN OUT CHAR,
                                        von_result_code       OUT NUMBER) AS
  BEGIN
    von_result_code := 0;
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      p_get_profit_center_smry('1', vid_amp_shipped_month, vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('PROFIT_CENTER1');
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      /* Loop through all three record types: '1', '2', '3' */
      <<summary_type_loop>>
      FOR counter IN 1 .. 3 LOOP
        IF counter = 1 THEN
          vgc_smry_type      := '1';
          vgn_day_variance   := vgn_schedule_to_ship_var;
          vgn_varbl_variance := vgn_varbl_schedule_ship_var;
        ELSIF counter = 2 THEN
          vgc_smry_type      := '2';
          vgn_day_variance   := vgn_request_to_ship_var;
          vgn_varbl_variance := vgn_varbl_request_ship_var;
        ELSIF counter = 3 THEN
          vgc_smry_type      := '3';
          vgn_day_variance   := vgn_request_to_schedule_var;
          vgn_varbl_variance := 0;
        END IF;
        p_initialize_delta_variables(counter);
        /* Update record */
        UPDATE PROFIT_CENTER_SMRY
           SET DML_ORACLE_ID               = vgc_job_id,
               DML_TMSTMP                  = SYSDATE,
               NBR_SHPMTS_OUT_RANGE_EARLY  = NBR_SHPMTS_OUT_RANGE_EARLY +
                                             vgn_ship_out_early,
               NBR_SHPMTS_SIX_DAYS_EARLY   = NBR_SHPMTS_SIX_DAYS_EARLY +
                                             vgn_ship_six_early,
               NBR_SHPMTS_FIVE_DAYS_EARLY  = NBR_SHPMTS_FIVE_DAYS_EARLY +
                                             vgn_ship_five_early,
               NBR_SHPMTS_FOUR_DAYS_EARLY  = NBR_SHPMTS_FOUR_DAYS_EARLY +
                                             vgn_ship_four_early,
               NBR_SHPMTS_THREE_DAYS_EARLY = NBR_SHPMTS_THREE_DAYS_EARLY +
                                             vgn_ship_three_early,
               NBR_SHPMTS_TWO_DAYS_EARLY   = NBR_SHPMTS_TWO_DAYS_EARLY +
                                             vgn_ship_two_early,
               NBR_SHPMTS_ONE_DAY_EARLY    = NBR_SHPMTS_ONE_DAY_EARLY +
                                             vgn_ship_one_early,
               NBR_SHPMTS_ON_TIME          = NBR_SHPMTS_ON_TIME +
                                             vgn_ship_on_time,
               NBR_SHPMTS_ONE_DAY_LATE     = NBR_SHPMTS_ONE_DAY_LATE +
                                             vgn_ship_one_late,
               NBR_SHPMTS_TWO_DAYS_LATE    = NBR_SHPMTS_TWO_DAYS_LATE +
                                             vgn_ship_two_late,
               NBR_SHPMTS_THREE_DAYS_LATE  = NBR_SHPMTS_THREE_DAYS_LATE +
                                             vgn_ship_three_late,
               NBR_SHPMTS_FOUR_DAYS_LATE   = NBR_SHPMTS_FOUR_DAYS_LATE +
                                             vgn_ship_four_late,
               NBR_SHPMTS_FIVE_DAYS_LATE   = NBR_SHPMTS_FIVE_DAYS_LATE +
                                             vgn_ship_five_late,
               NBR_SHPMTS_SIX_DAYS_LATE    = NBR_SHPMTS_SIX_DAYS_LATE +
                                             vgn_ship_six_late,
               NBR_SHPMTS_OUT_RANGE_LATE   = NBR_SHPMTS_OUT_RANGE_LATE +
                                             vgn_ship_out_late,
               TOTAL_NBR_SHPMTS            = TOTAL_NBR_SHPMTS +
                                             vgn_adjust_amount,
               NBR_JIT_OUT_RANGE_EARLY     = NBR_JIT_OUT_RANGE_EARLY +
                                             vgn_jit_out_early,
               NBR_JIT_SIX_DAYS_EARLY      = NBR_JIT_SIX_DAYS_EARLY +
                                             vgn_jit_six_early,
               NBR_JIT_FIVE_DAYS_EARLY     = NBR_JIT_FIVE_DAYS_EARLY +
                                             vgn_jit_five_early,
               NBR_JIT_FOUR_DAYS_EARLY     = NBR_JIT_FOUR_DAYS_EARLY +
                                             vgn_jit_four_early,
               NBR_JIT_THREE_DAYS_EARLY    = NBR_JIT_THREE_DAYS_EARLY +
                                             vgn_jit_three_early,
               NBR_JIT_TWO_DAYS_EARLY      = NBR_JIT_TWO_DAYS_EARLY +
                                             vgn_jit_two_early,
               NBR_JIT_ONE_DAY_EARLY       = NBR_JIT_ONE_DAY_EARLY +
                                             vgn_jit_one_early,
               NBR_JIT_ON_TIME             = NBR_JIT_ON_TIME +
                                             vgn_jit_on_time,
               NBR_JIT_ONE_DAY_LATE        = NBR_JIT_ONE_DAY_LATE +
                                             vgn_jit_one_late,
               NBR_JIT_TWO_DAYS_LATE       = NBR_JIT_TWO_DAYS_LATE +
                                             vgn_jit_two_late,
               NBR_JIT_THREE_DAYS_LATE     = NBR_JIT_THREE_DAYS_LATE +
                                             vgn_jit_three_late,
               NBR_JIT_FOUR_DAYS_LATE      = NBR_JIT_FOUR_DAYS_LATE +
                                             vgn_jit_four_late,
               NBR_JIT_FIVE_DAYS_LATE      = NBR_JIT_FIVE_DAYS_LATE +
                                             vgn_jit_five_late,
               NBR_JIT_SIX_DAYS_LATE       = NBR_JIT_SIX_DAYS_LATE +
                                             vgn_jit_six_late,
               NBR_JIT_OUT_RANGE_LATE      = NBR_JIT_OUT_RANGE_LATE +
                                             vgn_jit_out_late,
               TOTAL_NBR_JIT_SHPMTS        = TOTAL_NBR_JIT_SHPMTS +
                                             vgn_total_jit_ship,
               NBR_VARBL_OUT_RANGE_EARLY   = NBR_VARBL_OUT_RANGE_EARLY +
                                             vgn_varbl_out_early,
               NBR_VARBL_SIX_DAYS_EARLY    = NBR_VARBL_SIX_DAYS_EARLY +
                                             vgn_varbl_six_early,
               NBR_VARBL_FIVE_DAYS_EARLY   = NBR_VARBL_FIVE_DAYS_EARLY +
                                             vgn_varbl_five_early,
               NBR_VARBL_FOUR_DAYS_EARLY   = NBR_VARBL_FOUR_DAYS_EARLY +
                                             vgn_varbl_four_early,
               NBR_VARBL_THREE_DAYS_EARLY  = NBR_VARBL_THREE_DAYS_EARLY +
                                             vgn_varbl_three_early,
               NBR_VARBL_TWO_DAYS_EARLY    = NBR_VARBL_TWO_DAYS_EARLY +
                                             vgn_varbl_two_early,
               NBR_VARBL_ONE_DAY_EARLY     = NBR_VARBL_ONE_DAY_EARLY +
                                             vgn_varbl_one_early,
               NBR_VARBL_ON_TIME           = NBR_VARBL_ON_TIME +
                                             vgn_varbl_on_time,
               NBR_VARBL_ONE_DAY_LATE      = NBR_VARBL_ONE_DAY_LATE +
                                             vgn_varbl_one_late,
               NBR_VARBL_TWO_DAYS_LATE     = NBR_VARBL_TWO_DAYS_LATE +
                                             vgn_varbl_two_late,
               NBR_VARBL_THREE_DAYS_LATE   = NBR_VARBL_THREE_DAYS_LATE +
                                             vgn_varbl_three_late,
               NBR_VARBL_FOUR_DAYS_LATE    = NBR_VARBL_FOUR_DAYS_LATE +
                                             vgn_varbl_four_late,
               NBR_VARBL_FIVE_DAYS_LATE    = NBR_VARBL_FIVE_DAYS_LATE +
                                             vgn_varbl_five_late,
               NBR_VARBL_SIX_DAYS_LATE     = NBR_VARBL_SIX_DAYS_LATE +
                                             vgn_varbl_six_late,
               NBR_VARBL_OUT_RANGE_LATE    = NBR_VARBL_OUT_RANGE_LATE +
                                             vgn_varbl_out_late
         WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
           AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code
           AND PRODUCT_BUSNS_LINE_FNCTN_ID = vgc_product_busns_line_fnctnid
           AND PRODUCT_BUSNS_LINE_ID = vgc_product_busns_line_id
           AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
           AND ORGANIZATION_KEY_ID = vgn_organization_key_id
           AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
           AND MRP_GROUP_CDE = vgc_mrp_group_cde
           AND STOCK_MAKE_CODE = vgc_stock_make_code
           AND DELIVERY_SMRY_TYPE = vgc_smry_type;
        IF SQL%NOTFOUND THEN
          /* Insert Record */
          INSERT INTO PROFIT_CENTER_SMRY
            (PROFIT_CENTER_SMRY_ID,
             DELIVERY_SMRY_TYPE,
             AMP_SHIPPED_MONTH,
             ORGANIZATION_KEY_ID,
             INDUSTRY_BUSINESS_CDE,
             PRODUCT_BUSNS_LINE_ID,
             PRODUCT_BUSNS_LINE_FNCTN_ID,
             PROFIT_CENTER_ABBR_NM,
             CUSTOMER_ACCT_TYPE_CDE,
             STOCK_MAKE_CODE,
             MRP_GROUP_CDE,
             DML_ORACLE_ID,
             DML_TMSTMP,
             NBR_SHPMTS_OUT_RANGE_EARLY,
             NBR_SHPMTS_SIX_DAYS_EARLY,
             NBR_SHPMTS_FIVE_DAYS_EARLY,
             NBR_SHPMTS_FOUR_DAYS_EARLY,
             NBR_SHPMTS_THREE_DAYS_EARLY,
             NBR_SHPMTS_TWO_DAYS_EARLY,
             NBR_SHPMTS_ONE_DAY_EARLY,
             NBR_SHPMTS_ON_TIME,
             NBR_SHPMTS_ONE_DAY_LATE,
             NBR_SHPMTS_TWO_DAYS_LATE,
             NBR_SHPMTS_THREE_DAYS_LATE,
             NBR_SHPMTS_FOUR_DAYS_LATE,
             NBR_SHPMTS_FIVE_DAYS_LATE,
             NBR_SHPMTS_SIX_DAYS_LATE,
             NBR_SHPMTS_OUT_RANGE_LATE,
             TOTAL_NBR_SHPMTS,
             NBR_JIT_OUT_RANGE_EARLY,
             NBR_JIT_SIX_DAYS_EARLY,
             NBR_JIT_FIVE_DAYS_EARLY,
             NBR_JIT_FOUR_DAYS_EARLY,
             NBR_JIT_THREE_DAYS_EARLY,
             NBR_JIT_TWO_DAYS_EARLY,
             NBR_JIT_ONE_DAY_EARLY,
             NBR_JIT_ON_TIME,
             NBR_JIT_ONE_DAY_LATE,
             NBR_JIT_TWO_DAYS_LATE,
             NBR_JIT_THREE_DAYS_LATE,
             NBR_JIT_FOUR_DAYS_LATE,
             NBR_JIT_FIVE_DAYS_LATE,
             NBR_JIT_SIX_DAYS_LATE,
             NBR_JIT_OUT_RANGE_LATE,
             TOTAL_NBR_JIT_SHPMTS,
             NBR_VARBL_OUT_RANGE_EARLY,
             NBR_VARBL_SIX_DAYS_EARLY,
             NBR_VARBL_FIVE_DAYS_EARLY,
             NBR_VARBL_FOUR_DAYS_EARLY,
             NBR_VARBL_THREE_DAYS_EARLY,
             NBR_VARBL_TWO_DAYS_EARLY,
             NBR_VARBL_ONE_DAY_EARLY,
             NBR_VARBL_ON_TIME,
             NBR_VARBL_ONE_DAY_LATE,
             NBR_VARBL_TWO_DAYS_LATE,
             NBR_VARBL_THREE_DAYS_LATE,
             NBR_VARBL_FOUR_DAYS_LATE,
             NBR_VARBL_FIVE_DAYS_LATE,
             NBR_VARBL_SIX_DAYS_LATE,
             NBR_VARBL_OUT_RANGE_LATE)
          VALUES
            (profit_center_smry_id_seq.NEXTVAL,
             vgc_smry_type,
             vid_amp_shipped_month,
             vgn_organization_key_id,
             vgc_industry_business_code,
             vgc_product_busns_line_id,
             vgc_product_busns_line_fnctnid,
             vgc_profit_center_abbr_nm,
             vgc_customer_acct_type_cde,
             vgc_stock_make_code,
             vgc_mrp_group_cde,
             vgc_job_id,
             SYSDATE,
             vgn_ship_out_early,
             vgn_ship_six_early,
             vgn_ship_five_early,
             vgn_ship_four_early,
             vgn_ship_three_early,
             vgn_ship_two_early,
             vgn_ship_one_early,
             vgn_ship_on_time,
             vgn_ship_one_late,
             vgn_ship_two_late,
             vgn_ship_three_late,
             vgn_ship_four_late,
             vgn_ship_five_late,
             vgn_ship_six_late,
             vgn_ship_out_late,
             vgn_adjust_amount,
             vgn_jit_out_early,
             vgn_jit_six_early,
             vgn_jit_five_early,
             vgn_jit_four_early,
             vgn_jit_three_early,
             vgn_jit_two_early,
             vgn_jit_one_early,
             vgn_jit_on_time,
             vgn_jit_one_late,
             vgn_jit_two_late,
             vgn_jit_three_late,
             vgn_jit_four_late,
             vgn_jit_five_late,
             vgn_jit_six_late,
             vgn_jit_out_late,
             vgn_total_jit_ship,
             vgn_varbl_out_early,
             vgn_varbl_six_early,
             vgn_varbl_five_early,
             vgn_varbl_four_early,
             vgn_varbl_three_early,
             vgn_varbl_two_early,
             vgn_varbl_one_early,
             vgn_varbl_on_time,
             vgn_varbl_one_late,
             vgn_varbl_two_late,
             vgn_varbl_three_late,
             vgn_varbl_four_late,
             vgn_varbl_five_late,
             vgn_varbl_six_late,
             vgn_varbl_out_late);
          vioc_action_taken := 'I';
        END IF;
        von_result_code := SQLCODE;
      END LOOP summary_type_loop;
    ELSIF (vioc_action_taken = 'D') THEN
      /* Delete the three rows */
      DELETE PROFIT_CENTER_SMRY
       WHERE AMP_SHIPPED_MONTH = vid_amp_shipped_month
         AND INDUSTRY_BUSINESS_CDE = vgc_industry_business_code
         AND PRODUCT_BUSNS_LINE_FNCTN_ID = vgc_product_busns_line_fnctnid
         AND PRODUCT_BUSNS_LINE_ID = vgc_product_busns_line_id
         AND PROFIT_CENTER_ABBR_NM = vgc_profit_center_abbr_nm
         AND ORGANIZATION_KEY_ID = vgn_organization_key_id
         AND CUSTOMER_ACCT_TYPE_CDE = vgc_customer_acct_type_cde
         AND MRP_GROUP_CDE = vgc_mrp_group_cde
         AND STOCK_MAKE_CODE = vgc_stock_make_code
         AND DELIVERY_SMRY_TYPE IN ('1', '2', '3');
    END IF;
  EXCEPTION
    WHEN ue_critical_db_error THEN
      DBMS_OUTPUT.PUT_LINE('PROFIT_CENTER2');
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('PROFIT_CENTER3');
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_PROFIT_CENTER_SMRY');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_profit_center_smry;
  /****************************************************************************/
  /* PROCEDURE:   p_adjust_opx_weekly_smry                                 */
  /* DESCRIPTION:  Adjusts summary rows for PROFIT_CENTER_SMRY                */
  /*               table for the supplied key.                                */
  /*               Updates the buckets for days early/late, and the           */
  /*               total number of shipments.                                 */
  /*               Inserts a record if none is present, and deletes a record  */
  /*               if the result is a row with zero shipments.                */
  /****************************************************************************/
  PROCEDURE p_adjust_opx_weekly_smry(vid_amp_shipped_date IN ORDER_ITEM_SHIPMENT.AMP_SHIPPED_DATE%TYPE,
                                     vioc_action_taken    IN OUT CHAR,
                                     von_result_code      OUT NUMBER) AS
    v_section      VARCHAR2(50);
    v_shipto_orgid ORDER_ITEM_SHIPMENT.HIERARCHY_CUSTOMER_ORG_ID%TYPE;
    v_exclude_cust BOOLEAN;
  BEGIN
    von_result_code := 0;
    -- check the shipment date if need to be included into SMRY table
    -- so it would not mix with manually created data sourced from excel
    IF vid_amp_shipped_date < kd_opx_smry_beg_dt THEN
      RETURN;
    END IF;
  
    -- get ShipTo OrgID  
    v_section := 'Get ShipTo OrgID';
    IF NOT
        Scdcommonbatch.GetOrgID(vgn_accounting_org_key_id, v_shipto_orgid) THEN
      -- something is wrong, raise error
      vgn_sql_result := -20105;
      DBMS_OUTPUT.PUT_LINE('App Error: Org Key ID not found: ' ||
                           vgn_accounting_org_key_id);
      RAISE ue_smry_update_error;
    END IF;
  
    -- check if OrgID and SoldTo exist in exclusion list
    v_section      := 'Check if Cust in exclusion list';
    v_exclude_cust := f_is_cust_in_exclusion_list(v_shipto_orgid ||
                                                  vgc_sold_to_customer_id,
                                                  vgn_sql_result);
    IF vgn_sql_result <> 0 THEN
      RAISE ue_smry_update_error;
    END IF;
    IF v_exclude_cust THEN
      RETURN; -- exclude current rec in updating SRMY table 
    END IF;
  
    -- get fiscal date info
    v_section := 'Get fiscal date info';
    IF NOT Scdcommonbatch.GetTYCOFiscalDt(vid_amp_shipped_date,
                                          vg_dps_rec.FISCAL_YEAR_ID,
                                          vg_dps_rec.FISCAL_QUARTER_ID,
                                          vg_dps_rec.FISCAL_MONTH_ID,
                                          vg_dps_rec.FISCAL_WEEK_ID) THEN
      -- something is wrong, raise error
      vgn_sql_result := -20103;
      RAISE ue_smry_update_error;
    END IF;
  
    -- get Company OrgID, Co Org Key ID, Region Org ID  
    v_section := 'Get Co/Reg OrgID';
    IF NOT Scdcommonbatch.GetCoOrgIDKIDRegID(vgn_organization_key_id,
                                             vid_amp_shipped_date,
                                             vg_dps_rec.ORGANIZATION_ID,
                                             vg_dps_rec.ORGANIZATION_KEY_ID,
                                             vg_dps_rec.REGION_ORG_ID) THEN
      -- something is wrong, raise error
      vgn_sql_result := -20104;
      RAISE ue_smry_update_error;
    END IF;
    IF vg_dps_rec.REGION_ORG_ID IS NULL THEN
      vg_dps_rec.REGION_ORG_ID := '*';
    END IF;
  
    IF vgn_adjust_amount < 1 THEN
      /* Get existing record */
      v_section := 'Check opx key exist';
      p_get_opx_weekly_smry(vgn_sql_result);
      IF (vgn_sql_result = 0) THEN
        IF (vgn_total_shipments + vgn_adjust_amount = 0) THEN
          vioc_action_taken := 'D';
        ELSE
          vioc_action_taken := 'U';
        END IF;
      ELSE
        DBMS_OUTPUT.PUT_LINE('OPX_WEEKLY_SMRY1');
        RAISE ue_critical_db_error;
      END IF;
    ELSE
      vioc_action_taken := 'U';
    END IF;
    IF (vioc_action_taken = 'U') THEN
      -- init schedule variance
      v_section                              := 'Get Schedule Variance';
      vg_dps_rec.EARLY_SHIP_TO_SCHEDULE_QTY  := 0;
      vg_dps_rec.ONTIME_SHIP_TO_SCHEDULE_QTY := 0;
      vg_dps_rec.LATE_SHIP_TO_SCHEDULE_QTY   := 0;
      CASE
        WHEN (vgn_SCHEDULE_TO_SHIP_VAR BETWEEN
             Scdcommonbatch.gDfltDaysEarly AND 0 AND
             NVL(vgc_CUSTOMER_TYPE_CODE, 'X') != 'J') OR
             (vgn_SCHEDULE_TO_SHIP_VAR = 0 AND vgc_CUSTOMER_TYPE_CODE = 'J') THEN
          vg_dps_rec.ONTIME_SHIP_TO_SCHEDULE_QTY := vgn_adjust_amount;
        WHEN vgn_SCHEDULE_TO_SHIP_VAR > Scdcommonbatch.gDfltDaysLate THEN
          vg_dps_rec.LATE_SHIP_TO_SCHEDULE_QTY := vgn_adjust_amount;
        WHEN (vgn_SCHEDULE_TO_SHIP_VAR < Scdcommonbatch.gDfltDaysEarly) OR
             (vgn_SCHEDULE_TO_SHIP_VAR BETWEEN
             Scdcommonbatch.gDfltDaysEarly AND - 1 AND
             vgc_CUSTOMER_TYPE_CODE = 'J') THEN
          vg_dps_rec.EARLY_SHIP_TO_SCHEDULE_QTY := vgn_adjust_amount;
      END CASE;
    
      -- init request variance
      v_section                             := 'Get Request Variance';
      vg_dps_rec.EARLY_SHIP_TO_REQUEST_QTY  := 0;
      vg_dps_rec.ONTIME_SHIP_TO_REQUEST_QTY := 0;
      vg_dps_rec.LATE_SHIP_TO_REQUEST_QTY   := 0;
      CASE
        WHEN vgn_REQUEST_TO_SHIP_VAR BETWEEN Scdcommonbatch.gDfltDaysEarly AND 0 THEN
          vg_dps_rec.ONTIME_SHIP_TO_REQUEST_QTY := vgn_adjust_amount;
        WHEN vgn_REQUEST_TO_SHIP_VAR > Scdcommonbatch.gDfltDaysLate THEN
          vg_dps_rec.LATE_SHIP_TO_REQUEST_QTY := vgn_adjust_amount;
        WHEN vgn_REQUEST_TO_SHIP_VAR < Scdcommonbatch.gDfltDaysEarly THEN
          vg_dps_rec.EARLY_SHIP_TO_REQUEST_QTY := vgn_adjust_amount;
      END CASE;
    
      -- init release variance
      v_section                             := 'Get Release Variance';
      vg_dps_rec.ONTIME_SHIP_TO_RELEASE_QTY := 0;
      vg_dps_rec.LATE_SHIP_TO_RELEASE_QTY   := 0;
      CASE
        WHEN (vgn_RELEASE_TO_SHIP_VAR BETWEEN Scdcommonbatch.gDfltDaysEarly AND 0 AND
             NVL(vgc_CUSTOMER_TYPE_CODE, 'X') != 'J') OR
             (vgn_RELEASE_TO_SHIP_VAR = 0 AND vgc_CUSTOMER_TYPE_CODE = 'J') THEN
          vg_dps_rec.ONTIME_SHIP_TO_RELEASE_QTY := vgn_adjust_amount;
        WHEN vgn_RELEASE_TO_SHIP_VAR > Scdcommonbatch.gDfltDaysLate THEN
          vg_dps_rec.LATE_SHIP_TO_RELEASE_QTY := vgn_adjust_amount;
        ELSE
          NULL; -- early has no meaning for warehouse performance           
      END CASE;
    
      -- Update record 
      UPDATE SCD_DELIVERY_PERFORMANCE_SMRY
         SET DML_USER_ID                 = vgc_job_id,
             DML_TS                      = SYSDATE,
             TOTAL_SHIPMENT_QTY          = TOTAL_SHIPMENT_QTY +
                                           vgn_adjust_amount,
             ONTIME_SHIP_TO_REQUEST_QTY  = ONTIME_SHIP_TO_REQUEST_QTY +
                                           vg_dps_rec.ONTIME_SHIP_TO_REQUEST_QTY,
             ONTIME_SHIP_TO_SCHEDULE_QTY = ONTIME_SHIP_TO_SCHEDULE_QTY +
                                           vg_dps_rec.ONTIME_SHIP_TO_SCHEDULE_QTY,
             EARLY_SHIP_TO_REQUEST_QTY   = EARLY_SHIP_TO_REQUEST_QTY +
                                           vg_dps_rec.EARLY_SHIP_TO_REQUEST_QTY,
             EARLY_SHIP_TO_SCHEDULE_QTY  = EARLY_SHIP_TO_SCHEDULE_QTY +
                                           vg_dps_rec.EARLY_SHIP_TO_SCHEDULE_QTY,
             LATE_SHIP_TO_REQUEST_QTY    = LATE_SHIP_TO_REQUEST_QTY +
                                           vg_dps_rec.LATE_SHIP_TO_REQUEST_QTY,
             LATE_SHIP_TO_SCHEDULE_QTY   = LATE_SHIP_TO_SCHEDULE_QTY +
                                           vg_dps_rec.LATE_SHIP_TO_SCHEDULE_QTY,
             LATE_SHIP_TO_RELEASE_QTY    = LATE_SHIP_TO_RELEASE_QTY +
                                           vg_dps_rec.LATE_SHIP_TO_RELEASE_QTY,
             ONTIME_SHIP_TO_RELEASE_QTY  = ONTIME_SHIP_TO_RELEASE_QTY +
                                           vg_dps_rec.ONTIME_SHIP_TO_RELEASE_QTY
       WHERE FISCAL_WEEK_ID = vg_dps_rec.FISCAL_WEEK_ID
         AND FISCAL_YEAR_ID = vg_dps_rec.FISCAL_YEAR_ID
         AND ORGANIZATION_KEY_ID = vg_dps_rec.ORGANIZATION_KEY_ID
         AND REGION_ORG_ID = vg_dps_rec.REGION_ORG_ID
         AND ACTUAL_SHIP_BUILDING_NBR = vgc_ACTUAL_SHIP_BUILDING_NBR
         AND MFG_BUILDING_NBR = vgc_MFG_BUILDING_NBR
         AND PROFIT_CENTER_ABBR_NM = vgc_PROFIT_CENTER_ABBR_NM
         AND PRODUCT_BUSNS_LINE_ID = vgc_PRODUCT_BUSNS_LINE_ID
         AND INDUSTRY_BUSINESS_CODE = vgc_INDUSTRY_BUSINESS_CODE;
    
      IF SQL%NOTFOUND THEN
        /* Insert Record */
        INSERT INTO SCD_DELIVERY_PERFORMANCE_SMRY
          (FISCAL_YEAR_ID,
           FISCAL_MONTH_ID,
           FISCAL_QUARTER_ID,
           FISCAL_WEEK_ID,
           ORGANIZATION_KEY_ID,
           ORGANIZATION_ID,
           ACTUAL_SHIP_BUILDING_NBR,
           PROFIT_CENTER_ABBR_NM,
           PRODUCT_BUSNS_LINE_ID,
           TOTAL_SHIPMENT_QTY,
           ONTIME_SHIP_TO_REQUEST_QTY,
           ONTIME_SHIP_TO_SCHEDULE_QTY,
           EARLY_SHIP_TO_REQUEST_QTY,
           EARLY_SHIP_TO_SCHEDULE_QTY,
           LATE_SHIP_TO_REQUEST_QTY,
           LATE_SHIP_TO_SCHEDULE_QTY,
           DML_USER_ID,
           DML_TS,
           LATE_SHIP_TO_RELEASE_QTY,
           ONTIME_SHIP_TO_RELEASE_QTY,
           REGION_ORG_ID,
           MFG_BUILDING_NBR,
           INDUSTRY_BUSINESS_CODE)
        VALUES
          (vg_dps_rec.FISCAL_YEAR_ID,
           vg_dps_rec.FISCAL_MONTH_ID,
           vg_dps_rec.FISCAL_QUARTER_ID,
           vg_dps_rec.FISCAL_WEEK_ID,
           vg_dps_rec.ORGANIZATION_KEY_ID,
           vg_dps_rec.ORGANIZATION_ID,
           vgc_ACTUAL_SHIP_BUILDING_NBR,
           vgc_PROFIT_CENTER_ABBR_NM,
           vgc_PRODUCT_BUSNS_LINE_ID,
           vgn_adjust_amount,
           vg_dps_rec.ONTIME_SHIP_TO_REQUEST_QTY,
           vg_dps_rec.ONTIME_SHIP_TO_SCHEDULE_QTY,
           vg_dps_rec.EARLY_SHIP_TO_REQUEST_QTY,
           vg_dps_rec.EARLY_SHIP_TO_SCHEDULE_QTY,
           vg_dps_rec.LATE_SHIP_TO_REQUEST_QTY,
           vg_dps_rec.LATE_SHIP_TO_SCHEDULE_QTY,
           vgc_job_id,
           SYSDATE,
           vg_dps_rec.LATE_SHIP_TO_RELEASE_QTY,
           vg_dps_rec.ONTIME_SHIP_TO_RELEASE_QTY,
           vg_dps_rec.REGION_ORG_ID,
           vgc_MFG_BUILDING_NBR,
           vgc_INDUSTRY_BUSINESS_CODE);
        vioc_action_taken := 'I';
      ELSE
        IF SQL%ROWCOUNT > 1 THEN
          v_section      := 'Updated rows > 1';
          vgn_sql_result := -20101;
          RAISE ue_critical_db_error;
        END IF;
      END IF;
      von_result_code := SQLCODE;
    ELSIF (vioc_action_taken = 'D') THEN
      -- Delete the three rows 
      DELETE SCD_DELIVERY_PERFORMANCE_SMRY
       WHERE FISCAL_WEEK_ID = vg_dps_rec.FISCAL_WEEK_ID
         AND FISCAL_YEAR_ID = vg_dps_rec.FISCAL_YEAR_ID
         AND ORGANIZATION_KEY_ID = vg_dps_rec.ORGANIZATION_KEY_ID
         AND REGION_ORG_ID = vg_dps_rec.REGION_ORG_ID
         AND ACTUAL_SHIP_BUILDING_NBR = vgc_ACTUAL_SHIP_BUILDING_NBR
         AND MFG_BUILDING_NBR = vgc_MFG_BUILDING_NBR
         AND PROFIT_CENTER_ABBR_NM = vgc_PROFIT_CENTER_ABBR_NM
         AND PRODUCT_BUSNS_LINE_ID = vgc_PRODUCT_BUSNS_LINE_ID
         AND INDUSTRY_BUSINESS_CODE = vgc_INDUSTRY_BUSINESS_CODE;
      IF SQL%ROWCOUNT > 1 THEN
        v_section      := 'Deleted rows > 1';
        vgn_sql_result := -20102;
        RAISE ue_critical_db_error;
      END IF;
    END IF;
  EXCEPTION
    WHEN ue_smry_update_error THEN
      DBMS_OUTPUT.PUT_LINE('OPX_WEEKLY_SMRY4 - ' || v_section);
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN ue_critical_db_error THEN
      DBMS_OUTPUT.PUT_LINE('FISCAL_WEEK_ID = ' ||
                           vg_dps_rec.FISCAL_WEEK_ID);
      DBMS_OUTPUT.PUT_LINE('FISCAL_YEAR_ID  = ' ||
                           vg_dps_rec.FISCAL_YEAR_ID);
      DBMS_OUTPUT.PUT_LINE('ORGANIZATION_KEY_ID = ' ||
                           vg_dps_rec.ORGANIZATION_KEY_ID);
      DBMS_OUTPUT.PUT_LINE('REGION_ORG_ID	 = ' || vg_dps_rec.REGION_ORG_ID);
      DBMS_OUTPUT.PUT_LINE('ACTUAL_SHIP_BUILDING_NBR	 = ' ||
                           vgc_ACTUAL_SHIP_BUILDING_NBR);
      DBMS_OUTPUT.PUT_LINE('MFG_BUILDING_NBR	 = ' || vgc_MFG_BUILDING_NBR);
      DBMS_OUTPUT.PUT_LINE('PROFIT_CENTER_ABBR_NM	 = ' ||
                           vgc_PROFIT_CENTER_ABBR_NM);
      DBMS_OUTPUT.PUT_LINE('PRODUCT_BUSNS_LINE_ID	 = ' ||
                           vgc_PRODUCT_BUSNS_LINE_ID);
      DBMS_OUTPUT.PUT_LINE('INDUSTRY_BUSINESS_CODE = ' ||
                           vgc_INDUSTRY_BUSINESS_CODE);
      DBMS_OUTPUT.PUT_LINE('OPX_WEEKLY_SMRY2 - ' || v_section);
      vioc_action_taken := 'E';
      von_result_code   := vgn_sql_result;
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('OPX_WEEKLY_SMRY3 - ' || v_section);
      vioc_action_taken := 'E';
      von_result_code   := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(von_result_code));
  END p_adjust_opx_weekly_smry;
  /****************************************************************************/
  /* PROCEDURE:    p_adjust_summaries                                         */
  /* DESCRIPTION:  Adjusts the summary rows for a supplied key.               */
  /*               Initialize any NULL values to spaces.                      */
  /*               Call the correct procedure for each summary table.         */
  /*               Return the number of summary rows inserted, updated, or    */
  /*               deleted and any sql error.                                 */
  /****************************************************************************/
  PROCEDURE p_adjust_summaries(vic_job_id                     IN ORDER_ITEM_SHIPMENT.DML_ORACLE_ID%TYPE,
                               vid_amp_shipped_date           IN ORDER_ITEM_SHIPMENT.AMP_SHIPPED_DATE%TYPE,
                               vin_organization_key_id        IN ORDER_ITEM_SHIPMENT.ORGANIZATION_KEY_ID%TYPE,
                               vic_team_code                  IN ORDER_ITEM_SHIPMENT.TEAM_CODE%TYPE,
                               vic_prodcn_cntrlr_code         IN ORDER_ITEM_SHIPMENT.PRODCN_CNTRLR_CODE%TYPE,
                               vic_controller_uniqueness_id   IN ORDER_ITEM_SHIPMENT.CONTROLLER_UNIQUENESS_ID%TYPE,
                               vic_stock_make_code            IN ORDER_ITEM_SHIPMENT.STOCK_MAKE_CODE%TYPE,
                               vic_product_line_code          IN ORDER_ITEM_SHIPMENT.PRODUCT_LINE_CODE%TYPE,
                               vic_product_code               IN ORDER_ITEM_SHIPMENT.PRODUCT_CODE%TYPE,
                               vic_prodcn_cntrlr_employee_nbr IN ORDER_ITEM_SHIPMENT.PRODCN_CNTLR_EMPLOYEE_NBR%TYPE,
                               vic_a_territory_nbr            IN ORDER_ITEM_SHIPMENT.A_TERRITORY_NBR%TYPE,
                               vic_actual_ship_building_nbr   IN ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_BUILDING_NBR%TYPE,
                               vic_actual_ship_location       IN ORDER_ITEM_SHIPMENT.ACTUAL_SHIP_LOCATION%TYPE,
                               vic_purchase_by_account_base   IN ORDER_ITEM_SHIPMENT.PURCHASE_BY_ACCOUNT_BASE%TYPE,
                               vic_ship_to_account_suffix     IN ORDER_ITEM_SHIPMENT.SHIP_TO_ACCOUNT_SUFFIX%TYPE,
                               vic_ww_account_nbr_base        IN ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_BASE%TYPE,
                               vic_ww_account_nbr_suffix      IN ORDER_ITEM_SHIPMENT.WW_ACCOUNT_NBR_SUFFIX%TYPE,
                               vic_customer_type_code         IN ORDER_ITEM_SHIPMENT.CUSTOMER_TYPE_CODE%TYPE,
                               vic_ship_facility_cmprsn_code  IN ORDER_ITEM_SHIPMENT.SHIP_FACILITY_CMPRSN_CODE%TYPE,
                               vin_release_to_ship_var        IN ORDER_ITEM_SHIPMENT.RELEASE_TO_SHIP_VARIANCE%TYPE,
                               vin_schedule_to_ship_var       IN ORDER_ITEM_SHIPMENT.SCHEDULE_TO_SHIP_VARIANCE%TYPE,
                               vin_varbl_schedule_ship_var    IN ORDER_ITEM_SHIPMENT.VARBL_SCHEDULE_SHIP_VARIANCE%TYPE,
                               vin_request_to_ship_var        IN ORDER_ITEM_SHIPMENT.REQUEST_TO_SHIP_VARIANCE%TYPE,
                               vin_varbl_request_ship_var     IN ORDER_ITEM_SHIPMENT.VARBL_REQUEST_SHIP_VARIANCE%TYPE,
                               vin_request_to_schedule_var    IN ORDER_ITEM_SHIPMENT.REQUEST_TO_SCHEDULE_VARIANCE%TYPE,
                               vic_customer_acct_type_cde     IN ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE,
                               vic_industry_code              IN ORDER_ITEM_SHIPMENT.INDUSTRY_CODE%TYPE,
                               vin_mfr_org_key_id             IN ORDER_ITEM_SHIPMENT.MFR_ORG_KEY_ID%TYPE,
                               vic_mfg_campus_id              IN ORDER_ITEM_SHIPMENT.MFG_CAMPUS_ID%TYPE,
                               vic_mfg_building_nbr           IN ORDER_ITEM_SHIPMENT.MFG_BUILDING_NBR%TYPE,
                               vic_industry_business_code     IN ORDER_ITEM_SHIPMENT.INDUSTRY_BUSINESS_CODE%TYPE, -- alex - added 11/99
                               vin_accounting_org_key_id      IN ORDER_ITEM_SHIPMENT.ACCOUNTING_ORG_KEY_ID%TYPE,
                               vic_product_busns_line_fnctnid IN ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_FNCTN_ID%TYPE,
                               vic_profit_center_abbr_nm      IN ORDER_ITEM_SHIPMENT.PROFIT_CENTER_ABBR_NM%TYPE,
                               vic_sold_to_customer_id        IN ORDER_ITEM_SHIPMENT.SOLD_TO_CUSTOMER_ID%TYPE,
                               vic_product_busns_line_id      IN ORDER_ITEM_SHIPMENT.PRODUCT_BUSNS_LINE_ID%TYPE,
                               vin_product_manager_global_id  IN ORDER_ITEM_SHIPMENT.PRODUCT_MANAGER_GLOBAL_ID%TYPE,
                               vic_sales_office_cde           IN ORDER_ITEM_SHIPMENT.SALES_OFFICE_CDE%TYPE,
                               vic_sales_group_cde            IN ORDER_ITEM_SHIPMENT.SALES_GROUP_CDE%TYPE,
                               vin_source_system_id           IN BUILDING_LOCATION_SMRY.SOURCE_SYSTEM_ID%TYPE,
                               vic_mrp_group_cde              IN ORDER_ITEM_SHIPMENT.MRP_GROUP_CDE%TYPE,
                               vin_adjust_amount              IN NUMBER,
                               vion_num_smrys_inserted        IN OUT NUMBER,
                               vion_num_smrys_updated         IN OUT NUMBER,
                               vion_num_smrys_deleted         IN OUT NUMBER,
                               von_result_code                OUT NUMBER) IS
    /* Declare local variables */
    update_prod_line CHAR;
    result_code      NUMBER;
    dummy            NUMBER;
    action           CHAR;
    shipped_month    TEAM_ORG_SMRY.AMP_SHIPPED_MONTH%TYPE;
    vlc_org_id       ORGANIZATIONS_DMN.COMPANY_ORGANIZATION_ID%TYPE;
  BEGIN
    shipped_month                  := TRUNC(vid_amp_shipped_date, 'MONTH');
    vion_num_smrys_inserted        := 0;
    vion_num_smrys_updated         := 0;
    vion_num_smrys_deleted         := 0;
    action                         := ' ';
    von_result_code                := 0;
    vgc_job_id                     := vic_job_id;
    vgn_organization_key_id        := vin_organization_key_id;
    vgc_team_code                  := vic_team_code;
    vgc_prodcn_cntrlr_code         := vic_prodcn_cntrlr_code;
    vgc_controller_uniqueness_id   := vic_controller_uniqueness_id;
    vgc_stock_make_code            := vic_stock_make_code;
    vgc_product_code               := vic_product_code;
    vgc_product_line_code          := vic_product_line_code;
    vgc_prodcn_cntrlr_employee_nbr := vic_prodcn_cntrlr_employee_nbr;
    vgc_a_territory_nbr            := vic_a_territory_nbr;
    vgc_actual_ship_building_nbr   := vic_actual_ship_building_nbr;
    vgc_actual_ship_location       := vic_actual_ship_location;
    vgc_purchase_by_account_base   := vic_purchase_by_account_base;
    vgc_ship_to_account_suffix     := vic_ship_to_account_suffix;
    vgc_ww_account_nbr_base        := vic_ww_account_nbr_base;
    vgc_ww_account_nbr_suffix      := vic_ww_account_nbr_suffix;
    vgc_customer_type_code         := vic_customer_type_code;
    vgc_ship_facility_cmprsn_code  := vic_ship_facility_cmprsn_code;
    vgn_release_to_ship_var        := vin_release_to_ship_var;
    vgn_schedule_to_ship_var       := vin_schedule_to_ship_var;
    vgn_varbl_schedule_ship_var    := vin_varbl_schedule_ship_var;
    vgn_request_to_ship_var        := vin_request_to_ship_var;
    vgn_varbl_request_ship_var     := vin_varbl_request_ship_var;
    vgn_request_to_schedule_var    := vin_request_to_schedule_var;
    vgn_adjust_amount              := vin_adjust_amount;
    vgc_customer_acct_type_cde     := vic_customer_acct_type_cde;
    vgc_industry_code              := vic_industry_code;
    vgn_mfr_org_key_id             := vin_mfr_org_key_id;
    vgc_mfg_campus_id              := vic_mfg_campus_id;
    vgc_mfg_building_nbr           := vic_mfg_building_nbr;
    vgc_industry_business_code     := vic_industry_business_code; -- alex - added 11/99
    vgn_accounting_org_key_id      := vin_accounting_org_key_id;
    vgc_product_busns_line_fnctnid := vic_product_busns_line_fnctnid;
    vgc_profit_center_abbr_nm      := vic_profit_center_abbr_nm;
    vgc_sold_to_customer_id        := vic_sold_to_customer_id;
    vgc_product_busns_line_id      := vic_product_busns_line_id;
    vgn_product_manager_global_id  := vin_product_manager_global_id;
    vgc_sales_office_cde           := vic_sales_office_cde;
    vgc_sales_group_cde            := vic_sales_group_cde;
    vgn_source_system_id           := vin_source_system_id;
    vgc_mrp_group_cde              := vic_mrp_group_cde;
  
    /* BUILDING_LOCATION_SMRY */
    p_adjust_bldg_loc_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 5;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 5;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 5;
    ELSIF (action = 'C') THEN
      /* 5th summary was not updated */
      vion_num_smrys_deleted := vion_num_smrys_updated + 4;
    ELSIF (action = 'A') THEN
      /* 5th summary was not inserted */
      vion_num_smrys_deleted := vion_num_smrys_inserted + 4;
    ELSE
      RAISE ue_smry_update_error;
    END IF;
  
    /* MFG_CAMPUS_BLDG_SMRY */
    --    if scdCommonBatch.GetCompanyOrgID(vgn_organization_key_id,
    --                          vid_amp_shipped_date,
    --                        vlc_org_id) then
    --    null;
    --  end if;
    --    if vlc_org_id != scdCommonBatch.gUSCoOrgID
    IF vin_mfr_org_key_id = 0 THEN
      GOTO cntrlr_prod_line_smry;
    END IF;
    p_adjust_mfg_camp_bldg_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      RAISE ue_smry_update_error;
    END IF;
    <<cntrlr_prod_line_smry>>
  /* CNTRLR_PROD_LINE_SMRY  - INT'L PRODUCT LINE */
    p_adjust_cntrlr_prod_line_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      RAISE ue_smry_update_error;
    END IF;
    /* CUSTOMER_ACCOUNT_SMRY */
    p_adjust_customer_acct_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      RAISE ue_smry_update_error;
    END IF;
  
    /* SCORECARD_ORG_SMRY */
    p_adjust_scorecard_org_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      /* error */
      RAISE ue_smry_update_error;
    END IF;
    /* TEAM_ORG_SMRY */
  
    p_adjust_team_org_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
  
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      /* error */
      RAISE ue_smry_update_error;
    END IF;
    /* INDUSTRY_CODE_SMRY */
    p_adjust_industry_code_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      /* error */
      RAISE ue_smry_update_error;
    END IF;
    /* PROFIT_CENTER_SMRY */
    p_adjust_profit_center_smry(shipped_month, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 3;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 3;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 3;
    ELSE
      /* error */
      RAISE ue_smry_update_error;
    END IF;
    /* OPX_WEEKLY_SMRY */
    p_adjust_opx_weekly_smry(vid_amp_shipped_date, action, result_code);
    IF (result_code <> 0) THEN
      RAISE ue_smry_update_error;
    END IF;
    IF (action = 'I') THEN
      vion_num_smrys_inserted := vion_num_smrys_inserted + 1;
    ELSIF (action = 'U') THEN
      vion_num_smrys_updated := vion_num_smrys_updated + 1;
    ELSIF (action = 'D') THEN
      vion_num_smrys_deleted := vion_num_smrys_deleted + 1;
    ELSE
      /* error */
      RAISE ue_smry_update_error;
    END IF;
  
    <<end_of_proc>>
    dummy := 1;
  EXCEPTION
    WHEN ue_smry_update_error THEN
      von_result_code := result_code;
    WHEN OTHERS THEN
      von_result_code := result_code;
      DBMS_OUTPUT.PUT_LINE('P_ADJUST_SUMMARIES');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE));
  END p_adjust_summaries;
END Pkg_Adjust_Summaries;
/
