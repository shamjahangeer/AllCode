CREATE OR REPLACE PACKAGE ScdTop20Cust IS

PROCEDURE Insert_Top20Cust
   (iCustID        IN  VARCHAR2
   ,iCustAcctType  IN  VARCHAR2
   ,iCustOrgKeyID  IN  VARCHAR2
   ,iBusiUnit      IN  VARCHAR2 
   ,iRegionOrgID   IN  VARCHAR2	 
   ,iUserID        IN  VARCHAR2
   ,oErrorNumber   OUT VARCHAR2
   ,oErrorDesc     OUT VARCHAR2
   );

PROCEDURE Delete_Top20Cust
   (iCustID        IN  VARCHAR2
   ,iCustAcctType  IN  VARCHAR2
   ,iCustOrgKeyID  IN  VARCHAR2
   ,iBusiUnit      IN  VARCHAR2
   ,iRegionOrgID   IN  VARCHAR2	 
   ,oErrorNumber   OUT VARCHAR2
   ,oErrorDesc     OUT VARCHAR2
   );

PROCEDURE Validate_Top20Cust
   (iCustOrgKeyID  IN  VARCHAR2
   ,iCustID	   IN  VARCHAR2
   ,iCustAcctType  IN  VARCHAR2
   ,iBusiUnit      IN  VARCHAR2
   ,iRegionID      IN  VARCHAR2
   ,oCustName      OUT VARCHAR2
   ,oValid         OUT VARCHAR2     
   ,oErrorNumber   OUT VARCHAR2
   ,oErrorDesc     OUT VARCHAR2
   );

PROCEDURE GetRowRestrictions
   (iUserID        IN  VARCHAR2
   ,oBusiUnit      OUT VARCHAR2		
   ,oErrorNumber   OUT VARCHAR2
   ,oErrorDesc     OUT VARCHAR2
   );

END ScdTop20Cust;
/
CREATE OR REPLACE PACKAGE BODY ScdTop20Cust IS

  PROCEDURE Insert_Top20Cust(iCustID       IN VARCHAR2,
                             iCustAcctType IN VARCHAR2,
                             iCustOrgKeyID IN VARCHAR2,
                             iBusiUnit     IN VARCHAR2,
                             iRegionOrgID  IN VARCHAR2,
                             iUserID       IN VARCHAR2,
                             oErrorNumber  OUT VARCHAR2,
                             oErrorDesc    OUT VARCHAR2) IS
    ln_ExistingCount NUMBER(2) := 0;
    ALREADY_EXISTS EXCEPTION;
    ls_CustID TOP_20_CUSTOMERS.CUSTOMER_ACCOUNT_ID%TYPE;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
    IF iCustAcctType = 'SOLD TO' THEN
      ls_CustID := SUBSTR(iCustID, 1, 8);
    ELSE
      ls_CustID := iCustID;
    END IF;
  
    SELECT COUNT(*)
      INTO ln_ExistingCount
      FROM TOP_20_CUSTOMERS
     WHERE CUSTOMER_ACCOUNT_ID = ls_CustID
       AND ACCOUNT_TYPE_CDE = iCustAcctType
       AND CUSTOMER_ORGANIZATION_KEY_ID = TO_NUMBER(iCustOrgKeyID)
       AND PROFIT_CENTER_ABBR_NM = iBusiUnit
       AND REGION_ORGANIZATION_ID = iRegionOrgID;
  
    IF ln_ExistingCount = 0 THEN
      INSERT INTO SCD.TOP_20_CUSTOMERS
        (CUSTOMER_ACCOUNT_ID,
         ACCOUNT_TYPE_CDE,
         CUSTOMER_ORGANIZATION_KEY_ID,
         REGION_ORGANIZATION_ID,
         PROFIT_CENTER_ABBR_NM,
         DML_USER_ID,
         DML_TS)
      VALUES
        (ls_CustID,
         iCustAcctType,
         iCustOrgKeyID,
         iRegionOrgID,
         iBusiUnit,
         iUserID,
         SYSDATE);
    ELSE
      RAISE ALREADY_EXISTS;
    END IF;
  
    COMMIT;
  
  EXCEPTION
    WHEN ALREADY_EXISTS THEN
      oErrorNumber := '-12';
      oErrorDesc   := 'A Top 20 customer already exists for that Business Unit (scdTop20Cust.Insert_Top20Cust)';
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdTop20Cust.Insert_Top20Cust)';
  END Insert_Top20Cust;

  PROCEDURE Delete_Top20Cust(iCustID       IN VARCHAR2,
                             iCustAcctType IN VARCHAR2,
                             iCustOrgKeyID IN VARCHAR2,
                             iBusiUnit     IN VARCHAR2,
                             iRegionOrgID  IN VARCHAR2,
                             oErrorNumber  OUT VARCHAR2,
                             oErrorDesc    OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    DELETE SCD.TOP_20_CUSTOMERS
     WHERE CUSTOMER_ACCOUNT_ID = iCustID
       AND ACCOUNT_TYPE_CDE = iCustAcctType
       AND CUSTOMER_ORGANIZATION_KEY_ID = TO_NUMBER(iCustOrgKeyID)
       AND PROFIT_CENTER_ABBR_NM = iBusiUnit
       AND REGION_ORGANIZATION_ID = iRegionOrgID;
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (ScdTop20Cust.Delete_Top20Cust)';
  END Delete_Top20Cust;

  PROCEDURE Validate_Top20Cust(iCustOrgKeyID IN VARCHAR2,
                               iCustID       IN VARCHAR2,
                               iCustAcctType IN VARCHAR2,
                               iBusiUnit     IN VARCHAR2,
                               iRegionID     IN VARCHAR2,
                               oCustName     OUT VARCHAR2,
                               oValid        OUT VARCHAR2,
                               oErrorNumber  OUT VARCHAR2,
                               oErrorDesc    OUT VARCHAR2) IS
    ln_ExistingCount NUMBER(2) := 0;
    ln_FocusCustMax  NUMBER(2) := 0;
    ALREADY_EXISTS EXCEPTION;
    ON_MAX_LIMIT EXCEPTION;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
    oValid       := 'T';
  
    CASE iCustAcctType
      WHEN 'WW' THEN
        SELECT WW_CSTMR_NAME
          INTO oCustName
          FROM GBL_CUSTOMER_WORLDWIDE_V
         WHERE WW_CSTMR_ACCT_NBR = iCustID;
      WHEN 'SHIP TO' THEN
        SELECT ST_NAME
          INTO oCustName
          FROM GBL_CUSTOMER_SHIP_TO st, ORGANIZATIONS_DMN od
         WHERE ST_COMPOSITE_KEY = od.ORGANIZATION_ID || iCustID
           AND od.RECORD_STATUS_CDE = 'C'
           AND od.ORGANIZATION_KEY_ID = TO_NUMBER(iCustOrgKeyID);
      ELSE
        SELECT PB_CSTMR_NAME
          INTO oCustName
          FROM GBL_CUSTOMER_PURCHASED_BY st, ORGANIZATIONS_DMN od
         WHERE PB_ACCT_ORG_ID = od.ORGANIZATION_ID
           AND PB_ACCT_NBR_BASE = SUBSTR(iCustID, 1, 8)
           AND od.RECORD_STATUS_CDE = 'C'
           AND od.ORGANIZATION_KEY_ID = TO_NUMBER(iCustOrgKeyID);
    END CASE;
  
    -- check if cust already exist
    SELECT COUNT(*)
      INTO ln_ExistingCount
      FROM TOP_20_CUSTOMERS
     WHERE CUSTOMER_ACCOUNT_ID = iCustID
       AND ACCOUNT_TYPE_CDE = iCustAcctType
       AND CUSTOMER_ORGANIZATION_KEY_ID = iCustOrgKeyID
       AND REGION_ORGANIZATION_ID = iRegionID
       AND PROFIT_CENTER_ABBR_NM = iBusiUnit;
    IF ln_ExistingCount > 0 THEN
      RAISE ALREADY_EXISTS;
    END IF;
  
    -- check if cust count in BU and Region >= limit
    SELECT COUNT(*)
      INTO ln_ExistingCount
      FROM TOP_20_CUSTOMERS
     WHERE PROFIT_CENTER_ABBR_NM = iBusiUnit
       AND REGION_ORGANIZATION_ID = iRegionID;
  
    -- get maximum limit
    ln_FocusCustMax := TO_NUMBER(Scdcommonbatch.GETPARAMVALUELOCAL('SCDFOCUSCUSTMAX'));
  
    IF ln_ExistingCount >= ln_FocusCustMax THEN
      RAISE ON_MAX_LIMIT;
    END IF;
  EXCEPTION
    WHEN ON_MAX_LIMIT THEN
      oErrorNumber := '-3';
      oErrorDesc   := 'Number of Focus customers already reach the ' ||
                      ln_FocusCustMax ||
                      ' maximum limit , please delete some before adding.';
      oValid       := 'F';
    WHEN ALREADY_EXISTS THEN
      oErrorNumber := '-2';
      oErrorDesc   := 'A Focus 20 customer already exists for the BU/Cust Nbr/Cust Type/Region combination.';
      oValid       := 'F';
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := '-1';
      oErrorDesc   := 'Invalid entry. ' || iCustAcctType ||
                      ' customer entered does exist in customer master table.';
      oValid       := 'F';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdTop20Cust.Validate_Top20Cust)';
  END Validate_Top20Cust;

  PROCEDURE GetRowRestrictions(iUserID      IN VARCHAR2,
                               oBusiUnit    OUT VARCHAR2,
                               oErrorNumber OUT VARCHAR2,
                               oErrorDesc   OUT VARCHAR2) IS
    Cursor bu_cur IS
      SELECT RSTRN_1
        FROM APLCTN_ROW_RSTRN
       WHERE APLCTN_SYSTEM_ID = 'DELIVERY_SCORECARD'
         AND SQL_ROW_RSTRN_NAME = 'SCD_BUSINESS_UNIT_RSTRN'
         AND USER_ID = iUserID
         AND RSTRN_1 IS NOT NULL;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
    oBusiUnit    := NULL;
    FOR bu_rec IN bu_cur LOOP
      IF oBusiUnit IS NOT NULL THEN
        oBusiUnit := oBusiUnit || ',';
      END IF;
      oBusiUnit := oBusiUnit || '~' || bu_rec.RSTRN_1 || '~';
    END LOOP;
    IF oBusiUnit IS NULL THEN
      oBusiUnit    := '';
      oErrorNumber := '-1';
      oErrorDesc   := 'Business Unit row restriction is not defined.';
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdTop20Cust.GetRowRestrictions)';
  END GetRowRestrictions;

END ScdTop20Cust;
/
