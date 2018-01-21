CREATE OR REPLACE PACKAGE scdCommon IS
  PROCEDURE RetrieveIBCName(iIBC         IN VARCHAR2,
                            oIBCName     OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveCustName(iCustType    IN VARCHAR2,
                             iCustId      IN VARCHAR2,
                             oCustName    OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveView(iViewId      IN VARCHAR2,
                         oViewDesc    OUT VARCHAR2,
                         oErrorNumber OUT VARCHAR2,
                         oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveCategory(iCatId       IN VARCHAR2,
                             oCatDesc     OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgNameAbbrn(iOrgKeyId     IN VARCHAR2,
                                 iHistCurrInd  IN VARCHAR2,
                                 iOrgDt        IN VARCHAR2,
                                 oOrgNameAbbrn OUT VARCHAR2,
                                 oErrorNumber  OUT VARCHAR2,
                                 oErrorDesc    OUT VARCHAR2);

  PROCEDURE RetrieveOrgLevel(iOrgId       IN VARCHAR2,
                             iHistCurrInd IN VARCHAR2,
                             iOrgDt       IN VARCHAR2,
                             oOrgLevel    OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgKeyId(iOrgId       IN VARCHAR2,
                             iHistCurrInd IN VARCHAR2,
                             iOrgDt       IN VARCHAR2,
                             oOrgKeyId    OUT NUMBER,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgId(iOrgKeyId    IN NUMBER,
                          iHistCurrInd IN VARCHAR2,
                          iOrgDt       IN VARCHAR2,
                          oOrgId       OUT VARCHAR2,
                          oErrorNumber OUT VARCHAR2,
                          oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgIdFromCde(iOrgCde      IN VARCHAR2,
                                 oOrgId       OUT VARCHAR2,
                                 oOrgDesc     OUT VARCHAR2,
                                 oErrorNumber OUT VARCHAR2,
                                 oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgInfo(iOrgId       IN VARCHAR2,
                            iHistCurrInd IN VARCHAR2,
                            iOrgDt       IN VARCHAR2,
                            oOrgLevel    OUT VARCHAR2,
                            oOrgType     OUT VARCHAR2,
                            oOrgName     OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrievePart(iPart        IN VARCHAR2,
                         oPartDesc    OUT VARCHAR2,
                         oErrorNumber OUT VARCHAR2,
                         oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetExcelSeq(oExcelSeqId  OUT VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveOrgType(iOrgTypeId   IN VARCHAR2,
                            oOrgTypeDesc OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveDAFDataSrc(iDataSrcId   IN VARCHAR2,
                               oSrcId       OUT VARCHAR2,
                               oDataSrcDesc OUT VARCHAR2,
                               oErrorNumber OUT VARCHAR2,
                               oErrorDesc   OUT VARCHAR2);
END scdCommon;
/
CREATE OR REPLACE PACKAGE BODY scdCommon IS
  PROCEDURE RetrieveCustName(iCustType    IN VARCHAR2,
                             iCustId      IN VARCHAR2,
                             oCustName    OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
  
    lvvOrgId    VARCHAR2(4);
    lvvAcctBase VARCHAR2(8);
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iCustType = 'S' THEN
      SELECT ST_NAME
        INTO oCustName
        FROM GBL_CUSTOMER_SHIP_TO
       WHERE ST_COMPOSITE_KEY = iCustId;
    ELSIF iCustType = 'P' THEN
      lvvOrgId    := SUBSTR(iCustId, 1, 4);
      lvvAcctBase := SUBSTR(iCustId, 5, 8);
      SELECT PB_CSTMR_NAME
        INTO oCustName
        FROM GBL_CUSTOMER_PURCHASED_BY
       WHERE PB_ACCT_ORG_ID = lvvOrgId
         AND PB_ACCT_NBR_BASE = lvvAcctBase;
    ELSIF iCustType = 'W' THEN
      SELECT WW_CSTMR_NAME
        INTO oCustName
        FROM GBL_CUSTOMER_WORLDWIDE
       WHERE WW_CSTMR_ACCT_NBR = iCustId;
    ELSE
      oCustName := NULL;
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCustName    := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveCustName';
  END RetrieveCustName;

  PROCEDURE RetrieveIBCName(iIBC         IN VARCHAR2,
                            oIBCName     OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT GIB_SHORT_NAME
      INTO oIBCName
      FROM GBL_INDUSTRY_BUSINESS
     WHERE GIB_INDUSTRY_BUSINESS_CODE = iIBC;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oIBCName     := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveIBCName';
  END RetrieveIBCName;

  PROCEDURE RetrieveView(iViewId      IN VARCHAR2,
                         oViewDesc    OUT VARCHAR2,
                         oErrorNumber OUT VARCHAR2,
                         oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT SCORECARD_VIEW_DESC
      INTO oViewDesc
      FROM SCORECARD_VIEWS
     WHERE SCORECARD_VIEW_ID = iViewId;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oViewDesc    := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveView';
  END RetrieveView;

  PROCEDURE RetrieveCategory(iCatId       IN VARCHAR2,
                             oCatDesc     OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT SCORECARD_CATEGORY_DESC
      INTO oCatDesc
      FROM SCORECARD_CATEGORIES
     WHERE SCORECARD_CATEGORY_ID = iCatId;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oCatDesc     := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveCategory';
  END RetrieveCategory;

  PROCEDURE RetrieveOrgNameAbbrn(iOrgKeyId     IN VARCHAR2,
                                 iHistCurrInd  IN VARCHAR2,
                                 iOrgDt        IN VARCHAR2,
                                 oOrgNameAbbrn OUT VARCHAR2,
                                 oErrorNumber  OUT VARCHAR2,
                                 oErrorDesc    OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iHistCurrInd = 'C' THEN
      SELECT ORGANIZATION_ABBREVIATED_NM
        INTO oOrgNameAbbrn
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_KEY_ID = iOrgKeyId
         AND RECORD_STATUS_CDE = 'C';
    ELSE
      SELECT ORGANIZATION_ABBREVIATED_NM
        INTO oOrgNameAbbrn
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_KEY_ID = iOrgKeyId
         AND (EFFECTIVE_FROM_DT <= to_date(iOrgDt, 'YYYY-MM-DD') AND
             EFFECTIVE_TO_DT >= to_date(iOrgDt, 'YYYY-MM-DD'));
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgNameAbbrn := NULL;
      oErrorNumber  := '0';
      oErrorDesc    := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM ||
                      ' in Package scdCommon.RetrieveOrgNameAbbrn';
  END RetrieveOrgNameAbbrn;

  PROCEDURE RetrieveOrgLevel(iOrgId       IN VARCHAR2,
                             iHistCurrInd IN VARCHAR2,
                             iOrgDt       IN VARCHAR2,
                             oOrgLevel    OUT VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iHistCurrInd = 'C' THEN
      SELECT ORGANIZATION_LEVEL_CDE
        INTO oOrgLevel
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND RECORD_STATUS_CDE = 'C';
    ELSE
      SELECT ORGANIZATION_LEVEL_CDE
        INTO oOrgLevel
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND (EFFECTIVE_FROM_DT <= to_date(iOrgDt, 'YYYY-MM-DD') AND
             EFFECTIVE_TO_DT >= to_date(iOrgDt, 'YYYY-MM-DD'));
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      oOrgLevel    := NULL;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveOrgLevel';
  END RetrieveOrgLevel;

  PROCEDURE RetrieveOrgKeyId(iOrgId       IN VARCHAR2,
                             iHistCurrInd IN VARCHAR2,
                             iOrgDt       IN VARCHAR2,
                             oOrgKeyId    OUT NUMBER,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iHistCurrInd = 'C' THEN
      SELECT ORGANIZATION_KEY_ID
        INTO oOrgKeyId
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND RECORD_STATUS_CDE = 'C';
    ELSE
      SELECT ORGANIZATION_KEY_ID
        INTO oOrgKeyId
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND (EFFECTIVE_FROM_DT <= to_date(iOrgDt, 'YYYY-MM-DD') AND
             EFFECTIVE_TO_DT >= to_date(iOrgDt, 'YYYY-MM-DD'));
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      oOrgKeyId    := NULL;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveOrgKeyId';
  END RetrieveOrgKeyId;

  PROCEDURE RetrieveOrgId(iOrgKeyId    IN NUMBER,
                          iHistCurrInd IN VARCHAR2,
                          iOrgDt       IN VARCHAR2,
                          oOrgId       OUT VARCHAR2,
                          oErrorNumber OUT VARCHAR2,
                          oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iHistCurrInd = 'C' THEN
      SELECT ORGANIZATION_ID
        INTO oOrgId
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_KEY_ID = iOrgKeyId
         AND RECORD_STATUS_CDE = 'C';
    ELSE
      SELECT ORGANIZATION_ID
        INTO oOrgId
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_KEY_ID = iOrgKeyId
         AND (EFFECTIVE_FROM_DT <= to_date(iOrgDt, 'YYYY-MM-DD') AND
             EFFECTIVE_TO_DT >= to_date(iOrgDt, 'YYYY-MM-DD'));
    END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      oOrgId       := NULL;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveOrgId';
  END RetrieveOrgId;

  PROCEDURE RetrieveOrgIdFromCde(iOrgCde      IN VARCHAR2,
                                 oOrgId       OUT VARCHAR2,
                                 oOrgDesc     OUT VARCHAR2,
                                 oErrorNumber OUT VARCHAR2,
                                 oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT ORGANIZATION_ID, ORGANIZATION_SHORT_NM
      INTO oOrgId, oOrgDesc
      FROM ORGANIZATIONS_DMN
     WHERE ISO_LEGACY_PREFERRED_ORG_CDE = iOrgCde
       AND RECORD_STATUS_CDE = 'C';
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgId       := NULL;
      oOrgDesc     := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oOrgId       := NULL;
      oOrgDesc     := NULL;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM ||
                      ' in Package scdCommon.RetrieveOrgIdFromCde';
  END RetrieveOrgIdFromCde;

  PROCEDURE RetrieveOrgInfo(iOrgId       IN VARCHAR2,
                            iHistCurrInd IN VARCHAR2,
                            iOrgDt       IN VARCHAR2,
                            oOrgLevel    OUT VARCHAR2,
                            oOrgType     OUT VARCHAR2,
                            oOrgName     OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    IF iHistCurrInd = 'C' THEN
      SELECT ORGANIZATION_LEVEL_CDE,
             ORGANIZATION_TYPE_DESC,
             ORGANIZATION_SHORT_NM
        INTO oOrgLevel, oOrgType, oOrgName
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND RECORD_STATUS_CDE = 'C';
    ELSE
      SELECT ORGANIZATION_LEVEL_CDE,
             ORGANIZATION_TYPE_DESC,
             ORGANIZATION_SHORT_NM
        INTO oOrgLevel, oOrgType, oOrgName
        FROM ORGANIZATIONS_DMN
       WHERE ORGANIZATION_ID = iOrgId
         AND (EFFECTIVE_FROM_DT <= to_date(iOrgDt, 'YYYY-MM-DD') AND
             EFFECTIVE_TO_DT >= to_date(iOrgDt, 'YYYY-MM-DD'));
    END IF;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oOrgLevel    := NULL;
      oOrgType     := NULL;
      oOrgName     := NULL;
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveOrgInfo';
  END RetrieveOrgInfo;

  PROCEDURE RetrievePart(iPart        IN VARCHAR2,
                         oPartDesc    OUT VARCHAR2,
                         oErrorNumber OUT VARCHAR2,
                         oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT PART_DSCRPTN
      INTO oPartDesc
      FROM GBL_PART
     WHERE PART_NBR = iPart;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oPartDesc    := 'Desc Not Found';
      oErrorNumber := '0';
      oErrorDesc   := NULL;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrievePart';
  END RetrievePart;

  PROCEDURE RetExcelSeq(oExcelSeqId  OUT VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2)
  
   IS
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT scorecard_interface_seq.NEXTVAL INTO oExcelSeqId FROM DUAL;
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetExcelSeq';
  END RetExcelSeq;

  PROCEDURE RetrieveOrgType(iOrgTypeId   IN VARCHAR2,
                            oOrgTypeDesc OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT ORGANIZATION_TYPE_DESC
      INTO oOrgTypeDesc
      FROM SCORECARD_ORG_TYPES
     WHERE ORGANIZATION_TYPE_ID = TO_NUMBER(iOrgTypeId);
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveOrgType';
  END RetrieveOrgType;

  PROCEDURE RetrieveDAFDataSrc(iDataSrcId   IN VARCHAR2,
                               oSrcId       OUT VARCHAR2,
                               oDataSrcDesc OUT VARCHAR2,
                               oErrorNumber OUT VARCHAR2,
                               oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    SELECT SRC_ID, DATA_SRC_DESC
      INTO oSrcId, oDataSrcDesc
      FROM DATA_SRCS
     WHERE DATA_SRC_ID = TO_NUMBER(iDataSrcId);
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in Package scdCommon.RetrieveDAFDataSrc';
  END RetrieveDAFDataSrc;
END scdCommon;
/
