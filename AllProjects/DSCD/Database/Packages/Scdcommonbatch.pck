CREATE OR REPLACE PACKAGE Scdcommonbatch IS
  /******************************************************************************/
  /*                                                                            */
  /* PACKAGE:     scdCommonBatch                                                */
  /*                                                                            */
  /* Description:                                                               */
  /*   This package contains procedures and/or functions that relate to items   */
  /*   that are used by a number of different areas in the application.         */
  /*   User Interface specific items should not be contained within this        */
  /*   package.                                                                 */
  /******************************************************************************/

  TYPE OrgKeyIDOrgIDType IS RECORD(
    OrgKeyID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
    OrgID    ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE);
  TYPE OrgKeyIDOrgIDTab IS TABLE OF OrgKeyIDOrgIDType INDEX BY VARCHAR2(20);
  OrgKeyIDOrgIDTable OrgKeyIDOrgIDTab;

  TYPE OrgKeyIDOrgIDTab2 IS TABLE OF OrgKeyIDOrgIDType INDEX BY BINARY_INTEGER;
  OrgKeyIDOrgIDTable2 OrgKeyIDOrgIDTab2;

  TYPE OrgKeyIDCoOrgIDType IS RECORD(
    OrgKeyID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
    CoOrgID  ORGANIZATIONS_DMN.COMPANY_ORGANIZATION_ID%TYPE);
  TYPE OrgKeyIDCoOrgIDTab IS TABLE OF OrgKeyIDCoOrgIDType INDEX BY VARCHAR2(20);
  OrgKeyIDCoOrgIDTable OrgKeyIDCoOrgIDTab;

  gUSCoOrgID CONSTANT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE := '0048';
  gDfltOrgID     ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE := NULL;
  gDfltOrgKeyID  ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE := 0;
  gDfltOrgCode   ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE := NULL;
  gDfltDaysEarly NUMBER(2) := -3;
  gDfltDaysLate  NUMBER(2) := 0;
  gZeroPartKeyID  CONSTANT ORDER_ITEM_SHIPMENT.PART_KEY_ID%TYPE := 0;
  gZero711PartNbr CONSTANT ORDER_ITEM_SHIPMENT.SBMT_PART_NBR%TYPE := '000000000';

  PROCEDURE GetDSCDDaysParam;

  PROCEDURE GetOrgKeyID(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                        oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                        oErrorNumber OUT NUMBER,
                        oErrorDesc   OUT VARCHAR2);

  FUNCTION GetOrgKeyIDV2(iOrgID    IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                         oOrgKeyID OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgKeyIDV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                         iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                         oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgKeyIDV4(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                         iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                         oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetMfgOrgKeyID(iOrgCode  IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                          oOrgKeyID OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION IsValidOrgCode(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                          iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE)
    RETURN BOOLEAN;

  FUNCTION IsValidOrgCodeV2(iOrgCode IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION IsValidOrgID(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                        iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCompanyOrgCode(iOrgCode   IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                             oCoOrgCode OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCompanyOrgCodeV2(iOrgID     IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                               oCoOrgCode OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCompanyOrgCodeV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                               iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                               oCoOrgCode   OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgID(iOrgKeyID IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                    oOrgID    OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgIDV2(iOrgCode IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                      oOrgID   OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgIDV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgID       OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgIDV4(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgID       OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetShipToOrgID(iOrgCode IN GBL_SHIP_TO_ACCT_ORG.ORG_CODE%TYPE,
                          oOrgID   OUT GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetOrgCode(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgCode     OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCompanyOrgID(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                           iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                           oCoOrgID     OUT ORGANIZATIONS_DMN.COMPANY_ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCustAcctType(iOrgID        IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_ORG_ID%TYPE,
                           iAcctNbrBase  IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_BASE%TYPE,
                           iAcctNbrSufx  IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_SUFX%TYPE,
                           oCustAcctType OUT TEMP_ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetGIMNProdMgrGlobalID(iBrandName IN VARCHAR2,
                                  iClassType IN VARCHAR2,
                                  iBusiCode  IN VARCHAR2,
                                  iOrgID     IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                  oGlobalID  OUT GBL_ASSOCIATES.ASOC_GLOBAL_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetSourceSystemID(iSrcSysDesc IN VARCHAR2) RETURN NUMBER;

  FUNCTION GetTYCOFiscalDt(iCalendarDt IN DATE,
                           oYearID     OUT DATE_DMN.TYCO_YEAR_ID%TYPE,
                           oQuarterID  OUT DATE_DMN.TYCO_QUARTER_ID%TYPE,
                           oMonthID    OUT DATE_DMN.TYCO_MONTH_OF_YEAR_ID%TYPE,
                           oWeekID     OUT DATE_DMN.TYCO_WEEK_OF_YEAR_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetCoOrgIDKIDRegID(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                              iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                              oCoOrgID     OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                              oCoOrgKID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                              oRegOrgID    OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN;

  FUNCTION GetParamValueLocal(iParamID VARCHAR2) RETURN VARCHAR2;

  FUNCTION GetParamValue(iParamID VARCHAR2) RETURN VARCHAR2;

  FUNCTION get_hiercust_slsterrnbr(i_st_acct_org_id   VARCHAR2,
                                   i_st_acct_nbr_base VARCHAR2,
                                   i_st_acct_nbr_sufx VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION get_shipto_industry_code(i_st_acct_org_id   VARCHAR2,
                                    i_st_acct_nbr_base VARCHAR2,
                                    i_st_acct_nbr_sufx VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION get_ibc_code(i_industry_cde VARCHAR2) RETURN VARCHAR2;

  FUNCTION get_physical_building(i_plant_id VARCHAR2, i_loc_id VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION get_mfg_bldg_plant(i_mfg_org_kid IN NUMBER,
                              i_part_kid    IN NUMBER,
                              o_bldg_id     OUT VARCHAR2,
                              o_plant_id    OUT VARCHAR2) RETURN BOOLEAN;

  FUNCTION get_proc_type_cde(i_org_id VARCHAR2, i_part_kid NUMBER)
    RETURN VARCHAR2;

  FUNCTION get_sap_vendor_id(i_part_kid   IN NUMBER,
                             i_plant_id   IN VARCHAR2,
                             o_vendor_id  OUT VARCHAR2,
                             o_vendor_kid OUT NUMBER) RETURN BOOLEAN;

END Scdcommonbatch;
/
CREATE OR REPLACE PACKAGE BODY Scdcommonbatch IS

  TYPE GetOrgKeyIDType IS RECORD(
    OrgCode  ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    OrgKeyID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE);
  gSavGetOrgKeyIDRec GetOrgKeyIDType := NULL;

  TYPE GetOrgKeyIDV2Type IS RECORD(
    OrgID    ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    OrgKeyID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE);
  gSavGetOrgKeyIDV2Rec GetOrgKeyIDV2Type := NULL;

  TYPE GetOrgKeyIDV3Type IS RECORD(
    OrgCode     ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    OrgKeyID    ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE);
  gSavGetOrgKeyIDV3Rec GetOrgKeyIDV3Type := NULL;

  TYPE GetOrgKeyIDV4Type IS RECORD(
    OrgID       ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    OrgKeyID    ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE);
  gSavGetOrgKeyIDV4Rec GetOrgKeyIDV4Type := NULL;

  TYPE GetMfgOrgKeyIDType IS RECORD(
    OrgCode  ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    OrgKeyID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE);
  gSavGetMfgOrgKeyIDRec GetMfgOrgKeyIDType := NULL;

  TYPE IsValidOrgCodeType IS RECORD(
    OrgCode     ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    RetVal      BOOLEAN);
  gSavIsValidOrgCodeRec IsValidOrgCodeType := NULL;

  TYPE IsValidOrgCodeV2Type IS RECORD(
    OrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    RetVal  BOOLEAN);
  gSavIsValidOrgCodeV2Rec IsValidOrgCodeV2Type := NULL;

  TYPE IsValidOrgIDType IS RECORD(
    OrgID       ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    RetVal      BOOLEAN);
  gSavIsValidOrgIDRec IsValidOrgIDType := NULL;

  TYPE GetCompanyOrgCodeType IS RECORD(
    OrgCode   ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    CoOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE);
  gSavGetCompanyOrgCodeRec GetCompanyOrgCodeType := NULL;

  TYPE GetCompanyOrgCodeV2Type IS RECORD(
    OrgID     ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    CoOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE);
  gSavGetCompanyOrgCodeV2Rec GetCompanyOrgCodeV2Type := NULL;

  TYPE GetCompanyOrgCodeV3Type IS RECORD(
    OrgCode     ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    CoOrgCode   ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE);
  gSavGetCompanyOrgCodeV3Rec GetCompanyOrgCodeV3Type := NULL;

  TYPE GetCompanyOrgIDType IS RECORD(
    OrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    CoOrgID ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE);
  gSavGetCompanyOrgIDRec GetCompanyOrgIDType := NULL;

  TYPE GetOrgIDV2Type IS RECORD(
    OrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    OrgID   ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE);
  gSavGetOrgIDV2Rec GetOrgIDV2Type := NULL;

  TYPE GetOrgIDV3Type IS RECORD(
    OrgCode     ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    OrgID       ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE);
  gSavGetOrgIDV3Rec GetOrgIDV3Type := NULL;

  TYPE GetOrgCodeType IS RECORD(
    OrgID       ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    EffectiveDt ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
    OrgCode     ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE);
  gSavGetOrgCodeRec GetOrgCodeType := NULL;

  TYPE GetShipToOrgIDType IS RECORD(
    OrgCode GBL_SHIP_TO_ACCT_ORG.ORG_CODE%TYPE,
    OrgID   GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE);
  gSavShipToOrgIDRec GetShipToOrgIDType := NULL;

  TYPE GetCustAcctTypeType IS RECORD(
    OrgID        GBL_CUSTOMER_SHIP_TO.ST_ACCT_ORG_ID%TYPE,
    AcctNbrBase  GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_BASE%TYPE,
    AcctNbrSufx  GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_SUFX%TYPE,
    CustAcctType TEMP_ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE);
  gSavCustAcctTypeRec GetCustAcctTypeType := NULL;

  TYPE TYCOFiscalDtType IS RECORD(
    YearID    DATE_DMN.TYCO_YEAR_ID%TYPE,
    QuarterID DATE_DMN.TYCO_QUARTER_ID%TYPE,
    MonthID   DATE_DMN.TYCO_MONTH_OF_YEAR_ID%TYPE,
    WeekID    DATE_DMN.TYCO_WEEK_OF_YEAR_ID%TYPE);
  TYPE TYCOFiscalDtTypeTab IS TABLE OF TYCOFiscalDtType INDEX BY BINARY_INTEGER;
  TYCOFiscalDtTable TYCOFiscalDtTypeTab;

  TYPE CoOrgIDKIDRegIDRec IS RECORD(
    CoOrgID  ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    CoOrgKID ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
    RegOrgID ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE);
  TYPE CoOrgIDKIDRegIDTab IS TABLE OF CoOrgIDKIDRegIDRec INDEX BY VARCHAR2(20);
  CoOrgIDKIDRegIDTable CoOrgIDKIDRegIDTab;

  TYPE RecordSet IS REF CURSOR;
  TYPE GIMNType IS RECORD(
    Class_S_Name    VARCHAR2(10),
    Business_Code   VARCHAR2(40),
    GimnOrgID       VARCHAR2(30),
    Role_ID         NUMBER(10),
    ROLE_NM         VARCHAR2(50),
    Global_ID       NUMBER(8),
    Temp_ID         NUMBER(8),
    FIRST_NAME      GED_PUBLIC_VIEW.FIRST_NAME%TYPE,
    MI              GED_PUBLIC_VIEW.MIDDLE_INITIAL%TYPE,
    LAST_NAME       GED_PUBLIC_VIEW.LAST_NAME%TYPE,
    NETWORK_USER_ID GED_PUBLIC_VIEW.NETWORK_USER_ID%TYPE,
    Email_Addr      GBL_AMP_DEFINED_MAILBOXES.INTERNET_MAILBOX_PUBLIC_NM%TYPE,
    EmpORG          VARCHAR2(4),
    Local_Id        VARCHAR2(12),
    DialCode        VARCHAR2(5),
    PhoneNO         VARCHAR2(25),
    Pind            VARCHAR2(1));
  gGIMNRec GIMNType;

  TYPE GetGIMNProdMgrGlobalIDType IS RECORD(
    ClassType VARCHAR2(10),
    BusiCode  VARCHAR2(40),
    OrgID     ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
    GlobalID  GBL_ASSOCIATES.ASOC_GLOBAL_ID%TYPE);
  gSavGIMNProdMgrGlobalIDRec GetGIMNProdMgrGlobalIDType := NULL;

  -- define hier customer sales terr lookup table
  TYPE hiercust_slsterr_lookup_table IS TABLE OF GBL_SALES_TERRITORIES.SALES_TERRITORY_NBR%TYPE INDEX BY VARCHAR2(16);
  hiercust_slsterrnbr_table hiercust_slsterr_lookup_table;

  -- define shipto cust lookup table
  TYPE shipto_indu_code_lookup_table IS TABLE OF GBL_CUSTOMER_SHIP_TO.ST_INDUSTRY_CODE%TYPE INDEX BY VARCHAR2(16);
  shipto_indu_code_table shipto_indu_code_lookup_table;

  -- define industry code lookup table
  TYPE industry_code_lookup_table IS TABLE OF GBL_INDUSTRY.INDUSTRY_BUSINESS_CODE%TYPE INDEX BY GBL_INDUSTRY.INDUSTRY_CODE%TYPE;
  industry_code_table industry_code_lookup_table;

  -- define plant_location lookup table
  TYPE plant_location_lookup_table IS TABLE OF PLANT_STORAGE_LOC_BLD_XREF.BUILDING_ID%TYPE INDEX BY VARCHAR2(9);
  plant_location_table plant_location_lookup_table;

  -- define SAP Mfg Bldg Xref lookup table
  TYPE MfgBldgXrefRec IS RECORD(
    Bldg_ID  co_org_matl_dflt_mfr_bldg_xref.dflt_manufacturing_building_id%TYPE,
    Plant_ID co_org_matl_dflt_mfr_bldg_xref.dflt_manufacturing_plant_id%TYPE);
  TYPE MfgBldgXrefTab IS TABLE OF MfgBldgXrefRec INDEX BY VARCHAR2(25);
  MfgBldgXrefTable MfgBldgXrefTab;

  -- define SAP Vendor Xref lookup table
  TYPE SAPVendorXrefRec IS RECORD(
    Vendor_ID  scd.sap_vendor_xref_v.vendor_id%TYPE,
    Vendor_KID scd.sap_vendor_xref_v.vendors_key_id%TYPE);
  TYPE SAPVendorXrefTab IS TABLE OF SAPVendorXrefRec INDEX BY VARCHAR2(25);
  SAPVendorXrefTable SAPVendorXrefTab;

  -- define plant_location lookup table
  TYPE proc_type_lookup_table IS TABLE OF gcs_frozen_cost_v.gfc_procurement_type_cde%TYPE INDEX BY VARCHAR2(20);
  proc_type_table proc_type_lookup_table;

  gSavSrcSysID   BUILDING_LOCATION_SMRY.SOURCE_SYSTEM_ID%TYPE := NULL;
  gSavSrcSysDesc ORDER_ITEM_SHIPMENT.DATA_SOURCE_DESC%TYPE := NULL;

  PROCEDURE GetDSCDDaysParam IS
    l_param_val     DELIVERY_PARAMETER.PARAMETER_FIELD%TYPE;
    v_error_section VARCHAR2(50);
  BEGIN
    v_error_section := 'Get Days Early';
    SELECT TO_NUMBER(PARAMETER_FIELD) * -1
      INTO Scdcommonbatch.gDfltDaysEarly
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'DED358';
  
    v_error_section := 'Get Days Late';
    SELECT TO_NUMBER(PARAMETER_FIELD)
      INTO Scdcommonbatch.gDfltDaysLate
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'DED359';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20101,
                              'Parameter not found in Package scdCommonBatch.GetDSCDDaysParam section ' ||
                              v_error_section);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetDSCDDaysParam section ' ||
                              v_error_section);
  END;

  FUNCTION TrimZeroOrgCode(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                           iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                           oOrgCode     OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE := RTRIM(iOrgCode);
    llen     NUMBER := LENGTH(lOrgCode);
    lcnt     NUMBER(5);
  
  BEGIN
    IF llen = 1 THEN
      oOrgCode := lOrgCode;
      RETURN TRUE;
    ELSIF SUBSTR(lOrgCode, llen, 1) != '0' THEN
      oOrgCode := lOrgCode;
      RETURN TRUE;
    ELSIF lOrgCode IS NULL OR llen = 0 THEN
      oOrgCode := lOrgCode;
      RETURN FALSE;
    ELSIF lOrgCode = '0A0' AND iEffectiveDt < TO_DATE('22-APR-2001') THEN
      oOrgCode := '0A00';
      RETURN TRUE;
    END IF;
  
    LOOP
      lcnt := 0;
      SELECT COUNT(*)
        INTO lcnt
        FROM ORGANIZATIONS_DMN
       WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
         AND RECORD_STATUS_CDE = 'C'
         AND ROWNUM < 2;
    
      IF lcnt > 0 THEN
        oOrgCode := lOrgCode;
        RETURN TRUE;
      END IF;
    
      lOrgCode := SUBSTR(lOrgCode, 1, llen - 1);
      llen     := llen - 1;
      IF llen = 1 OR SUBSTR(lOrgCode, llen, 1) != '0' THEN
        oOrgCode := lOrgCode;
        RETURN TRUE;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.TrimZeroOrgCode');
  END;

  PROCEDURE GetOrgKeyID(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                        oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                        oErrorNumber OUT NUMBER,
                        oErrorDesc   OUT VARCHAR2) IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    oErrorNumber := 0;
    oErrorDesc   := NULL;
  
    IF iOrgCode = gSavGetOrgKeyIDRec.OrgCode THEN
      oOrgKeyID := gSavGetOrgKeyIDRec.OrgKeyID;
      RETURN;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, NULL, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORGANIZATION_KEY_ID
      INTO oOrgKeyID
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND RECORD_STATUS_CDE = 'C';
  
    gSavGetOrgKeyIDRec.OrgKeyID := oOrgKeyID;
    gSavGetOrgKeyIDRec.OrgCode  := iOrgCode;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgKeyID                   := gDfltOrgKeyID;
      gSavGetOrgKeyIDRec.OrgKeyID := gDfltOrgKeyID;
      gSavGetOrgKeyIDRec.OrgCode  := iOrgCode;
      oErrorDesc                  := 'Input OrgCode not found in ORGANIZATIONS_DMN table.';
    WHEN OTHERS THEN
      oErrorNumber := SQLCODE;
      oErrorDesc   := SQLERRM || ' in Package scdCommonBatch.GetOrgKeyID';
  END;

  FUNCTION GetOrgKeyIDV2(iOrgID    IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                         oOrgKeyID OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN IS
  
  BEGIN
    IF iOrgID = gSavGetOrgKeyIDV2Rec.OrgID THEN
      oOrgKeyID := gSavGetOrgKeyIDV2Rec.OrgKeyID;
      RETURN TRUE;
    END IF;
  
    SELECT ORGANIZATION_KEY_ID
      INTO oOrgKeyID
      FROM ORGANIZATIONS_DMN
     WHERE ORGANIZATION_ID = iOrgID
       AND RECORD_STATUS_CDE = 'C';
  
    gSavGetOrgKeyIDV2Rec.OrgKeyID := oOrgKeyID;
    gSavGetOrgKeyIDV2Rec.OrgID    := iOrgID;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgKeyID                     := gDfltOrgKeyID;
      gSavGetOrgKeyIDV2Rec.OrgKeyID := gDfltOrgKeyID;
      gSavGetOrgKeyIDV2Rec.OrgID    := iOrgID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgKeyIDV2');
  END;

  FUNCTION GetOrgKeyIDV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                         iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                         oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    IF iOrgCode = gSavGetOrgKeyIDV3Rec.OrgCode AND
       iEffectiveDt = gSavGetOrgKeyIDV3Rec.EffectiveDt THEN
      oOrgKeyID := gSavGetOrgKeyIDV3Rec.OrgKeyID;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, iEffectiveDt, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORGANIZATION_KEY_ID
      INTO oOrgKeyID
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    gSavGetOrgKeyIDV3Rec.OrgKeyID    := oOrgKeyID;
    gSavGetOrgKeyIDV3Rec.OrgCode     := iOrgCode;
    gSavGetOrgKeyIDV3Rec.EffectiveDt := iEffectiveDt;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgKeyID                        := gDfltOrgKeyID;
      gSavGetOrgKeyIDV3Rec.OrgKeyID    := gDfltOrgKeyID;
      gSavGetOrgKeyIDV3Rec.OrgCode     := iOrgCode;
      gSavGetOrgKeyIDV3Rec.EffectiveDt := iEffectiveDt;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgKeyIDV3');
  END;

  FUNCTION GetOrgKeyIDV4(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                         iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                         oOrgKeyID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN IS
  
  BEGIN
    IF iOrgID = gSavGetOrgKeyIDV4Rec.OrgID AND
       iEffectiveDt = gSavGetOrgKeyIDV4Rec.EffectiveDt THEN
      oOrgKeyID := gSavGetOrgKeyIDV4Rec.OrgKeyID;
      RETURN TRUE;
    END IF;
  
    SELECT ORGANIZATION_KEY_ID
      INTO oOrgKeyID
      FROM ORGANIZATIONS_DMN
     WHERE ORGANIZATION_ID = iOrgID
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    gSavGetOrgKeyIDV4Rec.OrgKeyID    := oOrgKeyID;
    gSavGetOrgKeyIDV4Rec.OrgID       := iOrgID;
    gSavGetOrgKeyIDV4Rec.EffectiveDt := iEffectiveDt;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgKeyID                        := gDfltOrgKeyID;
      gSavGetOrgKeyIDV4Rec.OrgKeyID    := gDfltOrgKeyID;
      gSavGetOrgKeyIDV4Rec.OrgID       := iOrgID;
      gSavGetOrgKeyIDV4Rec.EffectiveDt := iEffectiveDt;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgKeyIDV4');
  END;

  FUNCTION GetMfgOrgKeyID(iOrgCode  IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                          oOrgKeyID OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    IF iOrgCode = gSavGetMfgOrgKeyIDRec.OrgCode THEN
      oOrgKeyID := gSavGetMfgOrgKeyIDRec.OrgKeyID;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, NULL, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORGANIZATION_KEY_ID
      INTO oOrgKeyID
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND ROWNUM <= 1;
  
    gSavGetMfgOrgKeyIDRec.OrgKeyID := oOrgKeyID;
    gSavGetMfgOrgKeyIDRec.OrgCode  := iOrgCode;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgKeyID                      := gDfltOrgKeyID;
      gSavGetMfgOrgKeyIDRec.OrgKeyID := gDfltOrgKeyID;
      gSavGetMfgOrgKeyIDRec.OrgCode  := iOrgCode;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetMfgOrgKeyID');
  END;

  FUNCTION IsValidOrgCode(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                          iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
    lCount   NUMBER := 0;
  
  BEGIN
    IF iOrgCode = gSavIsValidOrgCodeRec.OrgCode AND
       iEffectiveDt = gSavIsValidOrgCodeRec.EffectiveDt THEN
      RETURN gSavIsValidOrgCodeRec.RetVal;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, iEffectiveDt, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT COUNT(*)
      INTO lCount
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    IF lCount > 0 THEN
      gSavIsValidOrgCodeRec.RetVal := TRUE;
    ELSE
      gSavIsValidOrgCodeRec.RetVal := FALSE;
    END IF;
  
    gSavIsValidOrgCodeRec.OrgCode     := iOrgCode;
    gSavIsValidOrgCodeRec.EffectiveDt := iEffectiveDt;
    RETURN gSavIsValidOrgCodeRec.RetVal;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.IsValidOrgCode');
  END;

  FUNCTION IsValidOrgCodeV2(iOrgCode IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
    lCount   NUMBER := 0;
  
  BEGIN
    IF iOrgCode = gSavIsValidOrgCodeV2Rec.OrgCode THEN
      RETURN gSavIsValidOrgCodeV2Rec.RetVal;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, NULL, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT COUNT(*)
      INTO lCount
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND RECORD_STATUS_CDE = 'C';
  
    IF lCount > 0 THEN
      gSavIsValidOrgCodeV2Rec.RetVal := TRUE;
    ELSE
      gSavIsValidOrgCodeV2Rec.RetVal := FALSE;
    END IF;
  
    gSavIsValidOrgCodeV2Rec.OrgCode := iOrgCode;
    RETURN gSavIsValidOrgCodeV2Rec.RetVal;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.IsValidOrgCodeV2');
  END;

  FUNCTION IsValidOrgID(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                        iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE)
    RETURN BOOLEAN IS
  
    lCount NUMBER := 0;
  
  BEGIN
    IF iOrgID = gSavIsValidOrgIDRec.OrgID AND
       iEffectiveDt = gSavIsValidOrgIDRec.EffectiveDt THEN
      RETURN gSavIsValidOrgIDRec.RetVal;
    END IF;
  
    SELECT COUNT(*)
      INTO lCount
      FROM ORGANIZATIONS_DMN
     WHERE ORGANIZATION_ID = iOrgID
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    IF lCount > 0 THEN
      gSavIsValidOrgIDRec.RetVal := TRUE;
    ELSE
      gSavIsValidOrgIDRec.RetVal := FALSE;
    END IF;
  
    gSavIsValidOrgIDRec.OrgID       := iOrgID;
    gSavIsValidOrgIDRec.EffectiveDt := iEffectiveDt;
    RETURN gSavIsValidOrgIDRec.RetVal;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.IsValidOrgID');
  END;

  FUNCTION GetCompanyOrgCode(iOrgCode   IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                             oCoOrgCode OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode       ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
    lDfltCoOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE := NULL;
  
  BEGIN
    IF iOrgCode = gSavGetCompanyOrgCodeRec.OrgCode THEN
      oCoOrgCode := gSavGetCompanyOrgCodeRec.CoOrgCode;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, NULL, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ISO_LEGACY_PREFERRED_ORG_CDE
      INTO oCoOrgCode
      FROM ORGANIZATIONS_DMN
     WHERE COMPANY_ORGANIZATION_ID =
           (SELECT COMPANY_ORGANIZATION_ID
              FROM ORGANIZATIONS_DMN
             WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
               AND RECORD_STATUS_CDE = 'C')
       AND RECORD_STATUS_CDE = 'C'
       AND ORGANIZATION_TYPE_DESC LIKE 'COMPANY%';
  
    gSavGetCompanyOrgCodeRec.CoOrgCode := oCoOrgCode;
    gSavGetCompanyOrgCodeRec.OrgCode   := iOrgCode;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCoOrgCode                         := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeRec.CoOrgCode := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeRec.OrgCode   := iOrgCode;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCompanyOrgCode');
  END;

  FUNCTION GetCompanyOrgCodeV2(iOrgID     IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                               oCoOrgCode OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lDfltCoOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE := NULL;
  
  BEGIN
    IF iOrgID = gSavGetCompanyOrgCodeV2Rec.OrgID THEN
      oCoOrgCode := gSavGetCompanyOrgCodeV2Rec.CoOrgCode;
      RETURN TRUE;
    END IF;
  
    SELECT ISO_LEGACY_PREFERRED_ORG_CDE
      INTO oCoOrgCode
      FROM ORGANIZATIONS_DMN
     WHERE COMPANY_ORGANIZATION_ID =
           (SELECT COMPANY_ORGANIZATION_ID
              FROM ORGANIZATIONS_DMN
             WHERE ORGANIZATION_ID = iOrgID
               AND RECORD_STATUS_CDE = 'C')
       AND RECORD_STATUS_CDE = 'C'
       AND ORGANIZATION_TYPE_DESC LIKE 'COMPANY%';
  
    gSavGetCompanyOrgCodeV2Rec.CoOrgCode := oCoOrgCode;
    gSavGetCompanyOrgCodeV2Rec.OrgID     := iOrgID;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCoOrgCode                           := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeV2Rec.CoOrgCode := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeV2Rec.OrgID     := iOrgID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCompanyOrgCodeV2');
  END;

  FUNCTION GetCompanyOrgCodeV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                               iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                               oCoOrgCode   OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode       ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
    lDfltCoOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE := NULL;
  
  BEGIN
    IF iOrgCode = gSavGetCompanyOrgCodeV3Rec.OrgCode AND
       iEffectiveDt = gSavGetCompanyOrgCodeV3Rec.EffectiveDt THEN
      oCoOrgCode := gSavGetCompanyOrgCodeV3Rec.CoOrgCode;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, iEffectiveDt, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ISO_LEGACY_PREFERRED_ORG_CDE
      INTO oCoOrgCode
      FROM ORGANIZATIONS_DMN
     WHERE COMPANY_ORGANIZATION_ID =
           (SELECT COMPANY_ORGANIZATION_ID
              FROM ORGANIZATIONS_DMN
             WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
               AND EFFECTIVE_FROM_DT <= iEffectiveDt
               AND EFFECTIVE_TO_DT >= iEffectiveDt)
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt
       AND ORGANIZATION_TYPE_DESC LIKE 'COMPANY%';
  
    gSavGetCompanyOrgCodeV3Rec.EffectiveDt := iEffectiveDt;
    gSavGetCompanyOrgCodeV3Rec.CoOrgCode   := oCoOrgCode;
    gSavGetCompanyOrgCodeV3Rec.OrgCode     := iOrgCode;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCoOrgCode                             := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeV3Rec.CoOrgCode   := lDfltCoOrgCode;
      gSavGetCompanyOrgCodeV3Rec.OrgCode     := iOrgCode;
      gSavGetCompanyOrgCodeV3Rec.EffectiveDt := iEffectiveDt;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCompanyOrgCodeV3');
  END;

  FUNCTION GetOrgID(iOrgKeyID IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                    oOrgID    OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
  BEGIN
    IF iOrgKeyID IS NOT NULL THEN
      oOrgID := OrgKeyIDOrgIDTable2(iOrgKeyID).OrgID;
      RETURN TRUE;
    ELSE
      oOrgID := gDfltOrgID;
      RETURN FALSE;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT ORGANIZATION_ID
          INTO oOrgID
          FROM ORGANIZATIONS_DMN
         WHERE ORGANIZATION_KEY_ID = iOrgKeyID
           AND RECORD_STATUS_CDE = 'C';
      
        OrgKeyIDOrgIDTable2(iOrgKeyID).OrgID := oOrgID;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          oOrgID := gDfltOrgID;
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM ||
                                  ' in Package scdCommonBatch.GetOrgID');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgID');
  END;

  FUNCTION GetOrgIDV2(iOrgCode IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                      oOrgID   OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    IF iOrgCode = gSavGetOrgIDV2Rec.OrgCode THEN
      oOrgID := gSavGetOrgIDV2Rec.OrgID;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, NULL, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORGANIZATION_ID
      INTO oOrgID
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND RECORD_STATUS_CDE = 'C';
  
    gSavGetOrgIDV2Rec.OrgCode := iOrgCode;
    gSavGetOrgIDV2Rec.OrgID   := oOrgID;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgID                    := gDfltOrgID;
      gSavGetOrgIDV2Rec.OrgCode := iOrgCode;
      gSavGetOrgIDV2Rec.OrgID   := gDfltOrgID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgIDV2');
  END;

  FUNCTION GetOrgIDV3(iOrgCode     IN ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgID       OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
    lOrgCode ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    IF iOrgCode = gSavGetOrgIDV3Rec.OrgCode AND
       iEffectiveDt = gSavGetOrgIDV3Rec.EffectiveDt THEN
      oOrgID := gSavGetOrgIDV3Rec.OrgID;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, iEffectiveDt, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORGANIZATION_ID
      INTO oOrgID
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = lOrgCode
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    gSavGetOrgIDV3Rec.OrgCode     := iOrgCode;
    gSavGetOrgIDV3Rec.EffectiveDt := iEffectiveDt;
    gSavGetOrgIDV3Rec.OrgID       := oOrgID;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgID                        := gDfltOrgID;
      gSavGetOrgIDV3Rec.OrgCode     := iOrgCode;
      gSavGetOrgIDV3Rec.EffectiveDt := iEffectiveDt;
      gSavGetOrgIDV3Rec.OrgID       := gDfltOrgID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgIDV3');
  END;

  FUNCTION GetOrgIDV4(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgID       OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
    lIdxKey VARCHAR2(20);
  
  BEGIN
    IF iOrgKeyID IS NULL OR iEffectiveDt IS NULL THEN
      oOrgID := gDfltOrgID;
      RETURN FALSE;
    ELSE
      lIdxKey := TO_CHAR(iOrgKeyID) || TO_CHAR(iEffectiveDt, 'yyyyddd');
      oOrgID  := OrgKeyIDOrgIDTable(lIdxKey).OrgID;
      RETURN TRUE;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT ORGANIZATION_ID
          INTO oOrgID
          FROM ORGANIZATIONS_DMN
         WHERE ORGANIZATION_KEY_ID = iOrgKeyID
           AND EFFECTIVE_FROM_DT <= iEffectiveDt
           AND EFFECTIVE_TO_DT >= iEffectiveDt;
      
        OrgKeyIDOrgIDTable(lIdxKey).OrgID := oOrgID;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          oOrgID := gDfltOrgID;
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM ||
                                  ' in Package scdCommonBatch.GetOrgIDV4');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgIDV4');
  END;

  FUNCTION GetShipToOrgID(iOrgCode IN GBL_SHIP_TO_ACCT_ORG.ORG_CODE%TYPE,
                          oOrgID   OUT GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE)
    RETURN BOOLEAN IS
  
    lDfltOrgID GBL_SHIP_TO_ACCT_ORG.ORG_ID%TYPE := NULL;
    lOrgCode   ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
  
  BEGIN
    IF iOrgCode = gSavShipToOrgIDRec.OrgCode THEN
      oOrgID := gSavShipToOrgIDRec.OrgID;
      RETURN TRUE;
    END IF;
  
    IF NOT TrimZeroOrgCode(iOrgCode, SYSDATE, lOrgCode) THEN
      RAISE NO_DATA_FOUND;
    END IF;
  
    SELECT ORG_ID
      INTO oOrgID
      FROM GBL_SHIP_TO_ACCT_ORG
     WHERE ORG_CODE = lOrgCode;
  
    gSavShipToOrgIDRec.OrgCode := iOrgCode;
    gSavShipToOrgIDRec.OrgID   := oOrgID;
  
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgID                     := lDfltOrgID;
      gSavShipToOrgIDRec.OrgCode := iOrgCode;
      gSavShipToOrgIDRec.OrgID   := lDfltOrgID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetShipToOrgID');
  END;

  FUNCTION GetOrgCode(iOrgID       IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                      iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                      oOrgCode     OUT ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE)
    RETURN BOOLEAN IS
  
  BEGIN
    IF iOrgID = gSavGetOrgCodeRec.OrgID AND
       iEffectiveDt = gSavGetOrgCodeRec.EffectiveDt THEN
      oOrgCode := gSavGetOrgCodeRec.OrgCode;
      RETURN TRUE;
    END IF;
  
    SELECT ISO_LEGACY_PREFERRED_ORG_CDE
      INTO oOrgCode
      FROM ORGANIZATIONS_DMN
     WHERE ORGANIZATION_ID = iOrgID
       AND EFFECTIVE_FROM_DT <= iEffectiveDt
       AND EFFECTIVE_TO_DT >= iEffectiveDt;
  
    gSavGetOrgCodeRec.OrgID       := iOrgID;
    gSavGetOrgCodeRec.OrgCode     := oOrgCode;
    gSavGetOrgCodeRec.EffectiveDt := iEffectiveDt;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgCode                      := gDfltOrgCode;
      gSavGetOrgCodeRec.OrgCode     := gDfltOrgCode;
      gSavGetOrgCodeRec.OrgID       := iOrgID;
      gSavGetOrgCodeRec.EffectiveDt := iEffectiveDt;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetOrgCode');
  END;

  FUNCTION GetCompanyOrgID(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                           iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                           oCoOrgID     OUT ORGANIZATIONS_DMN.COMPANY_ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
    lIdxKey VARCHAR2(20);
  
  BEGIN
    IF iOrgKeyID IS NULL OR iEffectiveDt IS NULL THEN
      oCoOrgID := gDfltOrgID;
      RETURN FALSE;
    ELSE
      lIdxKey  := TO_CHAR(iOrgKeyID) || TO_CHAR(iEffectiveDt, 'yyyyddd');
      oCoOrgID := OrgKeyIDCoOrgIDTable(lIdxKey).CoOrgID;
      RETURN TRUE;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT COMPANY_ORGANIZATION_ID
          INTO oCoOrgID
          FROM ORGANIZATIONS_DMN
         WHERE ORGANIZATION_KEY_ID = iOrgKeyID
           AND EFFECTIVE_FROM_DT <= iEffectiveDt
           AND EFFECTIVE_TO_DT >= iEffectiveDt;
      
        OrgKeyIDCoOrgIDTable(lIdxKey).CoOrgID := oCoOrgID;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          oCoOrgID := gDfltOrgID;
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM ||
                                  ' in Package scdCommonBatch.GetCompanyOrgID');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCompanyOrgID');
  END;

  FUNCTION GetCustAcctType(iOrgID        IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_ORG_ID%TYPE,
                           iAcctNbrBase  IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_BASE%TYPE,
                           iAcctNbrSufx  IN GBL_CUSTOMER_SHIP_TO.ST_ACCT_NBR_SUFX%TYPE,
                           oCustAcctType OUT TEMP_ORDER_ITEM_SHIPMENT.CUSTOMER_ACCT_TYPE_CDE%TYPE)
    RETURN BOOLEAN IS
  
    lCustAcctType GBL_CUSTOMER_SHIP_TO.ST_ACCT_TYPE_CODE%TYPE;
  
  BEGIN
    IF iOrgID = gSavCustAcctTypeRec.OrgID AND
       iAcctNbrBase = gSavCustAcctTypeRec.AcctNbrBase AND
       iAcctNbrSufx = gSavCustAcctTypeRec.AcctNbrSufx THEN
      oCustAcctType := gSavCustAcctTypeRec.CustAcctType;
      RETURN TRUE;
    END IF;
  
    SELECT ST_ACCT_TYPE_CODE
      INTO lCustAcctType
      FROM GBL_CUSTOMER_SHIP_TO
     WHERE ST_ACCT_ORG_ID = iOrgID
       AND ST_ACCT_NBR_BASE = iAcctNbrBase
       AND ST_ACCT_NBR_SUFX = iAcctNbrSufx;
  
    IF lCustAcctType IN ('05', '06') THEN
      oCustAcctType := 'I';
    ELSE
      oCustAcctType := 'T';
    END IF;
  
    gSavCustAcctTypeRec.OrgID        := iOrgID;
    gSavCustAcctTypeRec.AcctNbrBase  := iAcctNbrBase;
    gSavCustAcctTypeRec.AcctNbrSufx  := iAcctNbrSufx;
    gSavCustAcctTypeRec.CustAcctType := oCustAcctType;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCustAcctType                    := 'T';
      gSavCustAcctTypeRec.OrgID        := NULL;
      gSavCustAcctTypeRec.AcctNbrBase  := NULL;
      gSavCustAcctTypeRec.AcctNbrSufx  := NULL;
      gSavCustAcctTypeRec.CustAcctType := oCustAcctType;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCustAccntType');
  END;

  FUNCTION GetGIMNProdMgrGlobalID(iBrandName IN VARCHAR2,
                                  iClassType IN VARCHAR2,
                                  iBusiCode  IN VARCHAR2,
                                  iOrgID     IN ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                                  oGlobalID  OUT GBL_ASSOCIATES.ASOC_GLOBAL_ID%TYPE)
    RETURN BOOLEAN IS
  
    lCount       NUMBER(5) := 0;
    lResult      RecordSet;
    lRole        VARCHAR2(1) := '2'; --Product Manager
    lGIMNRec     GIMNType;
    lErrorNumber VARCHAR2(10);
    lErrorDesc   VARCHAR2(200);
    lnot_found EXCEPTION;
  
  BEGIN
    IF iClassType = gSavGIMNProdMgrGlobalIDRec.ClassType AND
       iBusiCode = gSavGIMNProdMgrGlobalIDRec.BusiCode AND
       iOrgID = gSavGIMNProdMgrGlobalIDRec.OrgID THEN
      oGlobalID := gSavGIMNProdMgrGlobalIDRec.GlobalID;
      RETURN TRUE;
    END IF;
    -- ignore Brand Name param since not needed in new APN compliant function   
    --Gim_Public.Get_All_Mfg_Contacts(iClassType,iBusiCode,lRole,iOrgID,lResult,lErrorNumber,lErrorDesc);
    ICS_SOURCE.ICS_WEB_SVCS.Get_All_Mfg_Contacts(iClassType,
                                                 iBusiCode,
                                                 lRole,
                                                 iOrgID,
                                                 lResult,
                                                 lErrorNumber,
                                                 lErrorDesc);
    IF lResult IS NOT NULL THEN
      LOOP
        FETCH lResult
          INTO lGIMNRec;
        EXIT WHEN lResult%NOTFOUND;
      
        IF lGIMNRec.Pind = 'P' THEN
          lCount := lCount + 1;
        
          oGlobalID                            := lGIMNRec.Global_ID;
          gSavGIMNProdMgrGlobalIDRec.ClassType := iClassType;
          gSavGIMNProdMgrGlobalIDRec.BusiCode  := iBusiCode;
          gSavGIMNProdMgrGlobalIDRec.OrgID     := iOrgID;
          gSavGIMNProdMgrGlobalIDRec.GlobalID  := oGlobalID;
          EXIT;
        END IF;
      END LOOP;
      IF lCount <= 0 THEN
        RAISE lnot_found;
      END IF;
      RETURN TRUE;
    ELSE
      IF lErrorNumber <> '0' THEN
        RAISE_APPLICATION_ERROR(-20101,
                                lErrorDesc ||
                                ' called GIM_PUBLIC in Package scdCommonBatch.GetGIMNProdMgrGlobalID');
      ELSE
        RAISE lnot_found;
      END IF;
    END IF;
  
  EXCEPTION
    WHEN lnot_found THEN
      oGlobalID                            := NULL;
      gSavGIMNProdMgrGlobalIDRec.ClassType := iClassType;
      gSavGIMNProdMgrGlobalIDRec.BusiCode  := iBusiCode;
      gSavGIMNProdMgrGlobalIDRec.OrgID     := iOrgID;
      gSavGIMNProdMgrGlobalIDRec.GlobalID  := oGlobalID;
      RETURN FALSE;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20102,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetGIMNProdMgrGlobalID');
  END;

  FUNCTION GetSourceSystemID(iSrcSysDesc IN VARCHAR2) RETURN NUMBER IS
  BEGIN
    IF iSrcSysDesc = gSavSrcSysDesc THEN
      RETURN gSavSrcSysID;
    END IF;
  
    SELECT SOURCE_SYSTEM_ID
      INTO gSavSrcSysID
      FROM SCD_SOURCE_SYSTEMS_V
     WHERE DATA_SOURCE_DESC = iSrcSysDesc;
    gSavSrcSysDesc := iSrcSysDesc;
    RETURN gSavSrcSysID;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetSourceSystemID');
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetSourceSystemID');
  END;

  FUNCTION GetTYCOFiscalDt(iCalendarDt IN DATE,
                           oYearID     OUT DATE_DMN.TYCO_YEAR_ID%TYPE,
                           oQuarterID  OUT DATE_DMN.TYCO_QUARTER_ID%TYPE,
                           oMonthID    OUT DATE_DMN.TYCO_MONTH_OF_YEAR_ID%TYPE,
                           oWeekID     OUT DATE_DMN.TYCO_WEEK_OF_YEAR_ID%TYPE)
    RETURN BOOLEAN IS
  
    lIdxKey BINARY_INTEGER;
    New_Exception EXCEPTION;
  BEGIN
    IF iCalendarDt IS NULL THEN
      RAISE New_Exception;
    ELSE
      lIdxKey    := TO_NUMBER(TO_CHAR(iCalendarDt, 'yyyyddd'));
      oYearID    := TYCOFiscalDtTable(lIdxKey).YearID;
      oQuarterID := TYCOFiscalDtTable(lIdxKey).QuarterID;
      oMonthID   := TYCOFiscalDtTable(lIdxKey).MonthID;
      oWeekID    := TYCOFiscalDtTable(lIdxKey).WeekID;
      RETURN TRUE;
    END IF;
  EXCEPTION
    WHEN New_Exception THEN
      RAISE_APPLICATION_ERROR(-20104,
                              'Input parameter Calendar Date cannot be null' ||
                              '  in Package scdCommonBatch.GetTYCOFiscalDt');
      RETURN FALSE;
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT TYCO_QUARTER_ID,
               TYCO_YEAR_ID,
               TYCO_MONTH_OF_YEAR_ID,
               TYCO_WEEK_OF_YEAR_ID
          INTO oQuarterID, oYearID, oMonthID, oWeekID
          FROM DATE_DMN
         WHERE CALENDAR_DT = iCalendarDt;
      
        TYCOFiscalDtTable(lIdxKey).YearID := oYearID;
        TYCOFiscalDtTable(lIdxKey).QuarterID := oQuarterID;
        TYCOFiscalDtTable(lIdxKey).MonthID := oMonthID;
        TYCOFiscalDtTable(lIdxKey).WeekID := oWeekID;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20103,
                                  'Calendar Dt: ' || iCalendarDt ||
                                  ' not found in DATE_DMN table in Package scdCommonBatch.GetTYCOFiscalDt');
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20102,
                                  SQLERRM ||
                                  ' in Package scdCommonBatch.GetTYCOFiscalDt');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetTYCOFiscalDt');
  END;

  FUNCTION GetCoOrgIDKIDRegID(iOrgKeyID    IN ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                              iEffectiveDt IN ORGANIZATIONS_DMN.EFFECTIVE_FROM_DT%TYPE,
                              oCoOrgID     OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE,
                              oCoOrgKID    OUT ORGANIZATIONS_DMN.ORGANIZATION_KEY_ID%TYPE,
                              oRegOrgID    OUT ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE)
    RETURN BOOLEAN IS
  
    lIdxKey VARCHAR2(20);
    New_Exception EXCEPTION;
  BEGIN
    IF iOrgKeyID IS NULL OR iEffectiveDt IS NULL THEN
      RAISE New_Exception;
    ELSE
      lIdxKey   := TO_CHAR(iOrgKeyID) || TO_CHAR(iEffectiveDt, 'yyyyddd');
      oCoOrgID  := CoOrgIDKIDRegIDTable(lIdxKey).CoOrgID;
      oCoOrgKID := CoOrgIDKIDRegIDTable(lIdxKey).CoOrgKID;
      oRegOrgID := CoOrgIDKIDRegIDTable(lIdxKey).RegOrgID;
      RETURN TRUE;
    END IF;
  
  EXCEPTION
    WHEN New_Exception THEN
      RAISE_APPLICATION_ERROR(-20104,
                              'Input parameter Org Key ID and/or Effective Date cannot be null' ||
                              '  in Package scdCommonBatch.GetCoOrgIDKIDRegID');
      RETURN FALSE;
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT cod.ORGANIZATION_ID,
               cod.ORGANIZATION_KEY_ID,
               cod.REGION_ORGANIZATION_ID
          INTO oCoOrgID, oCoOrgKID, oRegOrgID
          FROM ORGANIZATIONS_DMN od, ORGANIZATIONS_DMN cod
         WHERE od.ORGANIZATION_KEY_ID = iOrgKeyID
           AND iEffectiveDt BETWEEN od.EFFECTIVE_FROM_DT AND
               od.EFFECTIVE_TO_DT
           AND od.COMPANY_ORGANIZATION_ID = cod.ORGANIZATION_ID
           AND od.EFFECTIVE_FROM_DT BETWEEN cod.EFFECTIVE_FROM_DT AND
               cod.EFFECTIVE_TO_DT;
      
        CoOrgIDKIDRegIDTable(lIdxKey).CoOrgID := oCoOrgID;
        CoOrgIDKIDRegIDTable(lIdxKey).CoOrgKID := oCoOrgKID;
        CoOrgIDKIDRegIDTable(lIdxKey).RegOrgID := oRegOrgID;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          oCoOrgID  := gDfltOrgID;
          oCoOrgKID := NULL;
          oRegOrgID := NULL;
          RAISE_APPLICATION_ERROR(-20103,
                                  'Org Key ID + Date : ' ||
                                  TO_CHAR(iOrgKeyID) || ' + ' ||
                                  TO_CHAR(iEffectiveDt, 'YYYY-MM-DD') ||
                                  ' combination not found in ORGANIZATIONS_DMN table in Package scdCommonBatch.GetCoOrgIDKIDRegID');
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20101,
                                  SQLERRM ||
                                  ' in Package scdCommonBatch.GetCoOrgIDKIDRegID');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20102,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetCoOrgIDKIDRegID');
  END;

  FUNCTION GetParamValueLocal(iParamID VARCHAR2) RETURN VARCHAR2 IS
    l_param_val     DELIVERY_PARAMETER_LOCAL.PARAMETER_FIELD%TYPE;
    v_error_section VARCHAR2(50);
  BEGIN
    v_error_section := 'Get Param Value';
    SELECT PARAMETER_FIELD
      INTO l_param_val
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE UPPER(PARAMETER_ID) = UPPER(iParamID);
  
    RETURN l_param_val;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20101,
                              iParamID ||
                              '-param ID not found in Package scdCommonBatch.GetParamValueLocal section ' ||
                              v_error_section);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetParamValueLocal section ' ||
                              v_error_section);
  END;

  FUNCTION GetParamValue(iParamID VARCHAR2) RETURN VARCHAR2 IS
    l_param_val     DELIVERY_PARAMETER.PARAMETER_FIELD%TYPE;
    v_error_section VARCHAR2(50);
  BEGIN
    v_error_section := 'Get Param Value';
    SELECT PARAMETER_FIELD
      INTO l_param_val
      FROM DELIVERY_PARAMETER
     WHERE UPPER(PARAMETER_ID) = UPPER(iParamID);
  
    RETURN l_param_val;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20101,
                              iParamID ||
                              '-param ID not found in Package scdCommonBatch.GetParamValue section ' ||
                              v_error_section);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20101,
                              SQLERRM ||
                              ' in Package scdCommonBatch.GetParamValue section ' ||
                              v_error_section);
  END;

  FUNCTION get_hiercust_slsterrnbr(i_st_acct_org_id   VARCHAR2,
                                   i_st_acct_nbr_base VARCHAR2,
                                   i_st_acct_nbr_sufx VARCHAR2)
    RETURN VARCHAR2 IS
    v_slsterrnbr GBL_TERRITORY_ASSIGNMENTS.SALES_TERRITORY_NBR%TYPE;
    v_search_key VARCHAR2(16);
  BEGIN
    IF i_st_acct_org_id IS NOT NULL AND i_st_acct_nbr_base IS NOT NULL AND
       i_st_acct_nbr_sufx IS NOT NULL THEN
      v_search_key := i_st_acct_org_id || '~' || i_st_acct_nbr_base || '~' ||
                      i_st_acct_nbr_sufx;
      v_slsterrnbr := hiercust_slsterrnbr_table(v_search_key);
    END IF;
    RETURN v_slsterrnbr;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT SALES_TERRITORY_NBR
          INTO v_slsterrnbr
          FROM GBL_CURRENT.GBL_TERRITORY_ASSIGNMENTS
         WHERE ST_ACCT_ORG_ID = i_st_acct_org_id
           AND ST_ACCT_NBR_BASE = i_st_acct_nbr_base
           AND ST_ACCT_NBR_SUFX = i_st_acct_nbr_sufx
           AND TERRITORY_ASSIGNMENT_TYPE_CDE = 'A'
           AND ROWNUM <= 1;
      
        hiercust_slsterrnbr_table(v_search_key) := v_slsterrnbr;
        RETURN v_slsterrnbr;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_hiercust_slsterrnbr-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_hiercust_slsterrnbr-1');
  END get_hiercust_slsterrnbr;

  FUNCTION get_shipto_industry_code(i_st_acct_org_id   VARCHAR2,
                                    i_st_acct_nbr_base VARCHAR2,
                                    i_st_acct_nbr_sufx VARCHAR2)
    RETURN VARCHAR2 IS
    v_industry_cde GBL_CUSTOMER_SHIP_TO.ST_INDUSTRY_CODE%TYPE;
    v_search_key   VARCHAR2(16);
  BEGIN
    IF i_st_acct_org_id IS NOT NULL AND i_st_acct_nbr_base IS NOT NULL AND
       i_st_acct_nbr_sufx IS NOT NULL THEN
      v_search_key   := i_st_acct_org_id || '~' || i_st_acct_nbr_base || '~' ||
                        i_st_acct_nbr_sufx;
      v_industry_cde := shipto_indu_code_table(v_search_key);
    END IF;
    RETURN v_industry_cde;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT ST_INDUSTRY_CODE
          INTO v_industry_cde
          FROM GBL_CURRENT.GBL_CUSTOMER_SHIP_TO
         WHERE ST_ACCT_ORG_ID = i_st_acct_org_id
           AND ST_ACCT_NBR_BASE = i_st_acct_nbr_base
           AND ST_ACCT_NBR_SUFX = i_st_acct_nbr_sufx
           AND ROWNUM <= 1;
      
        shipto_indu_code_table(v_search_key) := v_industry_cde;
        RETURN v_industry_cde;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_shipto_industry_code-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_shipto_industry_code-1');
  END get_shipto_industry_code;

  FUNCTION get_ibc_code(i_industry_cde VARCHAR2) RETURN VARCHAR2 IS
    v_ibc GBL_INDUSTRY.INDUSTRY_BUSINESS_CODE%TYPE;
  BEGIN
    IF i_industry_cde IS NOT NULL THEN
      v_ibc := industry_code_table(i_industry_cde);
    END IF;
    RETURN v_ibc;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT INDUSTRY_BUSINESS_CODE
          INTO v_ibc
          FROM GBL_CURRENT.GBL_INDUSTRY
         WHERE INDUSTRY_CODE = i_industry_cde
           AND ROWNUM <= 1;
      
        industry_code_table(i_industry_cde) := v_ibc;
        RETURN v_ibc;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_ibc_code-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_ibc_code-1');
  END get_ibc_code;

  FUNCTION get_physical_building(i_plant_id VARCHAR2, i_loc_id VARCHAR2)
    RETURN VARCHAR2 IS
    v_bldg_id PLANT_STORAGE_LOC_BLD_XREF.BUILDING_ID%TYPE;
  BEGIN
    IF i_plant_id IS NOT NULL AND i_loc_id IS NOT NULL THEN
      v_bldg_id := plant_location_table(i_plant_id || '~' || i_loc_id);
    END IF;
    RETURN v_bldg_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT BUILDING_ID
          INTO v_bldg_id
          FROM PLANT_STORAGE_LOC_BLD_XREF
         WHERE PLANT_ID = i_plant_id
           AND STORAGE_LOCATION_ID = i_loc_id
           AND ROWNUM <= 1;
      
        plant_location_table(i_plant_id || '~' || i_loc_id) := v_bldg_id;
        RETURN v_bldg_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RETURN NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_physical_building-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_physical_building-1');
  END get_physical_building;

  FUNCTION get_mfg_bldg_plant(i_mfg_org_kid IN NUMBER,
                              i_part_kid    IN NUMBER,
                              o_bldg_id     OUT VARCHAR2,
                              o_plant_id    OUT VARCHAR2) RETURN BOOLEAN IS
    v_lookup_key         VARCHAR2(25);
    v_parent_mfg_org_kid NUMBER := NULL;
  BEGIN
    IF i_mfg_org_kid = 0 OR i_part_kid = 0 THEN
      o_bldg_id  := NULL;
      o_plant_id := NULL;
      RETURN FALSE;
    END IF;
    v_lookup_key := TO_NUMBER(i_mfg_org_kid) || '~' ||
                    TO_NUMBER(i_part_kid);
    o_bldg_id    := MfgBldgXrefTable(v_lookup_key).Bldg_ID;
    o_plant_id   := MfgBldgXrefTable(v_lookup_key).Plant_ID;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT dflt_manufacturing_building_id, dflt_manufacturing_plant_id
          INTO o_bldg_id, o_plant_id
          FROM gbl_current.matl_mfg_bldg_xref
         WHERE company_organization_key_id = i_mfg_org_kid
           AND part_key_id = i_part_kid
           AND ROWNUM <= 1;
      
        MfgBldgXrefTable(v_lookup_key).Bldg_ID := o_bldg_id;
        MfgBldgXrefTable(v_lookup_key).Plant_ID := o_plant_id;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          /*      this is fixed by using the view
          -- temp fix for not found 1082,1883,1472,1460 that might exist in parent org listed below
          IF i_mfg_org_kid = 1000 then -- org_key_id for 1082
            v_parent_mfg_org_kid := 35; -- org_key_id for 0048
          ELSIF i_mfg_org_kid = 1858 then -- org_key_id for 1883
            v_parent_mfg_org_kid := 387; -- org_key_id for 0406
          ELSIF i_mfg_org_kid = 1448 then -- org_key_id for 1472
            v_parent_mfg_org_kid := 895; -- org_key_id for 0955
          ELSIF i_mfg_org_kid = 1434 then -- org_key_id for 1460
            v_parent_mfg_org_kid := 391; -- org_key_id for 0410 
          END IF;          
          
          IF v_parent_mfg_org_kid IS NOT NULL THEN
            BEGIN
              SELECT dflt_manufacturing_building_id
                    ,dflt_manufacturing_plant_id
              INTO   o_bldg_id
                    ,o_plant_id
              FROM   co_org_matl_dflt_mfr_bldg_xref
              WHERE  company_organization_key_id = v_parent_mfg_org_kid
              AND    part_key_id                 = i_part_kid
              AND    ROWNUM <= 1
              ;
          
              MfgBldgXrefTable(v_lookup_key).Bldg_ID  := o_bldg_id;   
              MfgBldgXrefTable(v_lookup_key).Plant_ID := o_plant_id;
              RETURN TRUE;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL; 
              WHEN OTHERS THEN
                RAISE_APPLICATION_ERROR(-20403,SQLERRM||' error occurred in function Scdcommonbatch.get_mfg_bldg_plant-3');
            END;
          END IF;*/
          MfgBldgXrefTable(v_lookup_key).Bldg_ID := NULL;
          MfgBldgXrefTable(v_lookup_key).Plant_ID := NULL;
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_mfg_bldg_plant-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_mfg_bldg_plant-1');
  END get_mfg_bldg_plant;

  FUNCTION get_proc_type_cde(i_org_id VARCHAR2, i_part_kid NUMBER)
    RETURN VARCHAR2 IS
    v_proc_type_cde gcs_frozen_cost_v.gfc_procurement_type_cde%TYPE := NULL;
    v_lookup_key    VARCHAR2(20);
  BEGIN
    IF i_org_id IS NOT NULL AND i_part_kid IS NOT NULL THEN
      v_lookup_key    := i_org_id || '~' || TO_CHAR(i_part_kid);
      v_proc_type_cde := proc_type_table(v_lookup_key);
    END IF;
    RETURN v_proc_type_cde;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT gfc_procurement_type_cde
          INTO v_proc_type_cde
          FROM gcs_frozen_cost_v
         WHERE gfc_org_id = i_org_id
           AND gfc_part_key_id = i_part_kid
           AND sysdate between gfc_eff_date and
               nvl(gfced_exp_date, '31-dec-9999')
           AND ROWNUM <= 1;
      
        proc_type_table(v_lookup_key) := v_proc_type_cde;
        RETURN v_proc_type_cde;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          proc_type_table(v_lookup_key) := NULL;
          RETURN NULL;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_physical_building-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_physical_building-1');
  END get_proc_type_cde;

  FUNCTION get_sap_vendor_id(i_part_kid   IN NUMBER,
                             i_plant_id   IN VARCHAR2,
                             o_vendor_id  OUT VARCHAR2,
                             o_vendor_kid OUT NUMBER) RETURN BOOLEAN IS
    v_lookup_key VARCHAR2(25);
  BEGIN
    IF i_part_kid = 0 OR i_plant_id is NULL THEN
      o_vendor_id  := NULL;
      o_vendor_kid := NULL;
      RETURN FALSE;
    END IF;
    v_lookup_key := TO_NUMBER(i_part_kid) || '~' || i_plant_id;
    o_vendor_id  := SAPVendorXrefTable(v_lookup_key).Vendor_ID;
    o_vendor_kid := SAPVendorXrefTable(v_lookup_key).Vendor_KID;
    RETURN TRUE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        SELECT vendor_id, vendors_key_id
          INTO o_vendor_id, o_vendor_kid
          FROM scd.sap_vendor_xref_v
         WHERE part_key_id = i_part_kid
           AND plant_id = i_plant_id
           AND ROWNUM <= 1;
      
        SAPVendorXrefTable(v_lookup_key).Vendor_ID := o_vendor_id;
        SAPVendorXrefTable(v_lookup_key).Vendor_KID := o_vendor_kid;
        RETURN TRUE;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          SAPVendorXrefTable(v_lookup_key).Vendor_ID := NULL;
          SAPVendorXrefTable(v_lookup_key).Vendor_KID := NULL;
          RETURN FALSE;
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20403,
                                  SQLERRM ||
                                  ' error occurred in function Scdcommonbatch.get_sap_vendor_id-2');
      END;
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20403,
                              SQLERRM ||
                              ' error occurred in function Scdcommonbatch.get_sap_vendor_id-1');
  END get_sap_vendor_id;

END Scdcommonbatch;
/
