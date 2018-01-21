CREATE OR REPLACE PACKAGE Scdsearch IS

  PROCEDURE RetrieveSession(iSessionId           IN VARCHAR2,
                            oViewId              OUT VARCHAR2,
                            oCategoryId          OUT VARCHAR2,
                            oWindowId            OUT VARCHAR2,
                            oStartDt             OUT VARCHAR2,
                            oEndDt               OUT VARCHAR2,
                            oDaysEarly           OUT VARCHAR2,
                            oDaysLate            OUT VARCHAR2,
                            oMonthDailyInd       OUT VARCHAR2,
                            oSmryType            OUT VARCHAR2,
                            oCurrentHist         OUT VARCHAR2,
                            oOrgType             OUT VARCHAR2,
                            oOrgId               OUT VARCHAR2,
                            oCustAcctTypeCde     OUT VARCHAR2,
                            oPart                OUT VARCHAR2,
                            oPlant               OUT VARCHAR2,
                            oLocation            OUT VARCHAR2,
                            oAcctOrgID           OUT VARCHAR2,
                            oShipTo              OUT VARCHAR2,
                            oSoldTo              OUT VARCHAR2,
                            oWWCust              OUT VARCHAR2,
                            oInvOrgID            OUT VARCHAR2,
                            oController          OUT VARCHAR2,
                            oCntlrEmpNbr         OUT VARCHAR2,
                            oStkMake             OUT VARCHAR2,
                            oTeam                OUT VARCHAR2,
                            oProdCde             OUT VARCHAR2,
                            oProdLne             OUT VARCHAR2,
                            oIBC                 OUT VARCHAR2,
                            oIC                  OUT VARCHAR2,
                            oMfgCampus           OUT VARCHAR2,
                            oMfgBulding          OUT VARCHAR2,
                            oComparisonType      OUT VARCHAR2,
                            oOpenShpOrder        OUT VARCHAR2,
                            oProfitCtr           OUT VARCHAR2,
                            oCompetencyBusCde    OUT VARCHAR2,
                            oOrgDt               OUT VARCHAR2,
                            oSubCompetencyBusCde OUT VARCHAR2,
                            oProdMgr             OUT VARCHAR2,
                            oLeadTimeType        OUT VARCHAR2,
                            oSalesOffice         OUT VARCHAR2,
                            oSalesGroup          OUT VARCHAR2,
                            oMfgOrgType          OUT VARCHAR2,
                            oMfgOrgId            OUT VARCHAR2,
                            oGamAcct             OUT VARCHAR2,
                            oPartKeyID           OUT VARCHAR2,
                            oMrpGroupCde         OUT VARCHAR2,
                            oProdHostOrgID       OUT VARCHAR2,
                            oErrorNumber         OUT VARCHAR2,
                            oErrorDesc           OUT VARCHAR2);

  PROCEDURE UpdateSession(iAmpID               IN VARCHAR2,
                          iSessionId           IN VARCHAR2,
                          iViewId              IN VARCHAR2,
                          iCategoryId          IN VARCHAR2,
                          iWindowId            IN VARCHAR2,
                          iStartDt             IN VARCHAR2,
                          iEndDt               IN VARCHAR2,
                          iDaysEarly           IN VARCHAR2,
                          iDaysLate            IN VARCHAR2,
                          iMonthDailyInd       IN VARCHAR2,
                          iSmryType            IN VARCHAR2,
                          iCurrentHist         IN VARCHAR2,
                          iOrgType             IN VARCHAR2,
                          iOrgId               IN VARCHAR2,
                          iCustAcctTypeCde     IN VARCHAR2,
                          iPart                IN VARCHAR2,
                          iPlant               IN VARCHAR2,
                          iLocation            IN VARCHAR2,
                          iAcctOrgID           IN VARCHAR2,
                          iShipTo              IN VARCHAR2,
                          iSoldTo              IN VARCHAR2,
                          iWWCust              IN VARCHAR2,
                          iInvOrgID            IN VARCHAR2,
                          iController          IN VARCHAR2,
                          iCntlrEmpNbr         IN VARCHAR2,
                          iStkMake             IN VARCHAR2,
                          iTeam                IN VARCHAR2,
                          iProdCde             IN VARCHAR2,
                          iProdLne             IN VARCHAR2,
                          iIBC                 IN VARCHAR2,
                          iIC                  IN VARCHAR2,
                          iMfgCampus           IN VARCHAR2,
                          iMfgBulding          IN VARCHAR2,
                          iComparisonType      IN VARCHAR2,
                          iOpenShpOrder        IN VARCHAR2,
                          iProfitCtr           IN VARCHAR2,
                          iCompetencyBusCde    IN VARCHAR2,
                          iOrgDt               IN VARCHAR2,
                          iSubCompetencyBusCde IN VARCHAR2,
                          iProdMgr             IN VARCHAR2,
                          iLeadTimeType        IN VARCHAR2,
                          iSalesOffice         IN VARCHAR2,
                          iSalesGroup          IN VARCHAR2,
                          iMfgOrgType          IN VARCHAR2,
                          iMfgOrgId            IN VARCHAR2,
                          iGamAcct             IN VARCHAR2,
                          iPartKeyID           IN VARCHAR2,
                          iMrpGroupCde         IN VARCHAR2,
                          iProdHostOrgID       IN VARCHAR2,
                          oErrorNumber         OUT VARCHAR2,
                          oErrorDesc           OUT VARCHAR2);

  PROCEDURE RetrieveLastSession(iGlobalID    IN VARCHAR2,
                                oSessionID   OUT VARCHAR2,
                                oErrorNumber OUT VARCHAR2,
                                oErrorDesc   OUT VARCHAR2);

  PROCEDURE CreateCurrentSession(iGlobalID    IN VARCHAR2,
                                 oSessionID   OUT VARCHAR2,
                                 oErrorNumber OUT VARCHAR2,
                                 oErrorDesc   OUT VARCHAR2);

  PROCEDURE ResetToDefaults(iGlobalID    IN VARCHAR2,
                            oSessionID   OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2);

  PROCEDURE Purge_Old_Sessions(iGlobalId    IN VARCHAR2,
                               oErrorNumber OUT VARCHAR2,
                               oErrorDesc   OUT VARCHAR2);

  PROCEDURE Purge_Sessions(iGlobalId    IN VARCHAR2,
                           oErrorNumber OUT VARCHAR2,
                           oErrorDesc   OUT VARCHAR2);

  PROCEDURE SaveUserLog(iAmpID               IN VARCHAR2,
                        iViewId              IN VARCHAR2,
                        iCategoryId          IN VARCHAR2,
                        iWindowId            IN VARCHAR2,
                        iStartDt             IN VARCHAR2,
                        iEndDt               IN VARCHAR2,
                        iDaysEarly           IN VARCHAR2,
                        iDaysLate            IN VARCHAR2,
                        iMonthDailyInd       IN VARCHAR2,
                        iSmryType            IN VARCHAR2,
                        iCurrentHist         IN VARCHAR2,
                        iOrgType             IN VARCHAR2,
                        iOrgId               IN VARCHAR2,
                        iCustAcctTypeCde     IN VARCHAR2,
                        iPart                IN VARCHAR2,
                        iPlant               IN VARCHAR2,
                        iLocation            IN VARCHAR2,
                        iAcctOrgID           IN VARCHAR2,
                        iShipTo              IN VARCHAR2,
                        iSoldTo              IN VARCHAR2,
                        iWWCust              IN VARCHAR2,
                        iInvOrgID            IN VARCHAR2,
                        iController          IN VARCHAR2,
                        iCntlrEmpNbr         IN VARCHAR2,
                        iStkMake             IN VARCHAR2,
                        iTeam                IN VARCHAR2,
                        iProdCde             IN VARCHAR2,
                        iProdLne             IN VARCHAR2,
                        iIBC                 IN VARCHAR2,
                        iIC                  IN VARCHAR2,
                        iMfgCampus           IN VARCHAR2,
                        iMfgBulding          IN VARCHAR2,
                        iComparisonType      IN VARCHAR2,
                        iOpenShpOrder        IN VARCHAR2,
                        iProfitCtr           IN VARCHAR2,
                        iCompetencyBusCde    IN VARCHAR2,
                        iOrgDt               IN VARCHAR2,
                        iSubCompetencyBusCde IN VARCHAR2,
                        iProdMgr             IN VARCHAR2,
                        iLeadTimeType        IN VARCHAR2,
                        iSalesOffice         IN VARCHAR2,
                        iSalesGroup          IN VARCHAR2,
                        iMfgOrgType          IN VARCHAR2,
                        iMfgOrgId            IN VARCHAR2,
                        iGamAcct             IN VARCHAR2,
                        iPartKeyID           IN VARCHAR2,
                        iMrpGroupCde         IN VARCHAR2,
                        iProdHostOrgID       IN VARCHAR2,
                        oErrorNumber         OUT VARCHAR2,
                        oErrorDesc           OUT VARCHAR2);

END Scdsearch;
/
CREATE OR REPLACE PACKAGE BODY Scdsearch IS

  /******************************************************************************/
  /*                                                                            */
  /*package variables                                                           */
  /*                                                                            */
  /******************************************************************************/
  /* These are search screen non-user defaults: */

  l_def_USER_PREFERENCES_SHORT_D SCORECARD_USER_PREFERENCES.USER_PREFERENCES_SHORT_DESC%TYPE := 'LAST';
  l_def_SCORECARD_VIEW_ID        SCORECARD_USER_PREFERENCES.SCORECARD_VIEW_ID%TYPE := 1;
  l_def_SCORECARD_CATEGORY_ID    SCORECARD_USER_PREFERENCES.SCORECARD_CATEGORY_ID%TYPE := 2;
  l_def_SCORECARD_WINDOW_ID      SCORECARD_USER_PREFERENCES.SCORECARD_WINDOW_ID%TYPE := 1;
  l_def_START_DT                 SCORECARD_USER_PREFERENCES.START_DT%TYPE := SYSDATE;
  l_def_END_DT                   SCORECARD_USER_PREFERENCES.END_DT%TYPE := SYSDATE;
  l_def_NBR_WINDOW_DAYS_EARLY    SCORECARD_USER_PREFERENCES.NBR_WINDOW_DAYS_EARLY%TYPE := 3;
  l_def_NBR_WINDOW_DAYS_LATE     SCORECARD_USER_PREFERENCES.NBR_WINDOW_DAYS_LATE%TYPE := 0;
  l_def_MONTHLY_DAILY_IND        SCORECARD_USER_PREFERENCES.MONTHLY_DAILY_IND%TYPE := '1';
  l_def_DELIVERY_SMRY_TYPE       SCORECARD_USER_PREFERENCES.DELIVERY_SMRY_TYPE%TYPE := '2';
  l_def_CURRENT_HISTORY_IND      SCORECARD_USER_PREFERENCES.CURRENT_HISTORY_IND%TYPE := 'C';
  l_def_ORGANIZATION_TYPE_ID     SCORECARD_USER_PREFERENCES.ORGANIZATION_TYPE_ID%TYPE := '9003';
  l_def_ORGANIZATION_ID          SCORECARD_USER_PREFERENCES.ORGANIZATION_ID%TYPE := NULL;
  l_def_CUSTOMER_ACCT_TYPE_CDE   SCORECARD_USER_PREFERENCES.CUSTOMER_ACCT_TYPE_CDE%TYPE := '0';
  l_def_PART_NBR                 SCORECARD_USER_PREFERENCES.PART_NBR%TYPE := NULL;
  l_def_PLANT_ID                 SCORECARD_USER_PREFERENCES.PLANT_ID%TYPE := NULL;
  l_def_PLANT_LOCATION_ID        SCORECARD_USER_PREFERENCES.PLANT_LOCATION_ID%TYPE := NULL;
  l_def_ACCOUNTING_ORGANIZATION  SCORECARD_USER_PREFERENCES.ACCOUNTING_ORGANIZATION_ID%TYPE := NULL;
  l_def_SHIP_TO_CUSTOMER_ID      SCORECARD_USER_PREFERENCES.SHIP_TO_CUSTOMER_ID%TYPE := NULL;
  l_def_SOLD_TO_CUSTOMER_ID      SCORECARD_USER_PREFERENCES.SOLD_TO_CUSTOMER_ID%TYPE := NULL;
  l_def_WW_CUSTOMER_ACCOUNT_NBR  SCORECARD_USER_PREFERENCES.WW_CUSTOMER_ACCOUNT_NBR%TYPE := NULL;
  l_def_INVENTORY_ORGANIZATION   SCORECARD_USER_PREFERENCES.INVENTORY_ORGANIZATION_ID%TYPE := NULL;
  l_def_PRODCN_CNTRLR_CODE       SCORECARD_USER_PREFERENCES.PRODCN_CNTRLR_CODE%TYPE := NULL;
  l_def_PRODCN_CNTLR_EMPLOYEE    SCORECARD_USER_PREFERENCES.PRODCN_CNTLR_EMPLOYEE_NBR%TYPE := NULL;
  l_def_STOCK_MAKE_CODE          SCORECARD_USER_PREFERENCES.STOCK_MAKE_CODE%TYPE := NULL;
  l_def_TEAM_CODE                SCORECARD_USER_PREFERENCES.TEAM_CODE%TYPE := NULL;
  l_def_PRODUCT_CODE             SCORECARD_USER_PREFERENCES.PRODUCT_CODE%TYPE := NULL;
  l_def_PRODUCT_LINE_CODE        SCORECARD_USER_PREFERENCES.PRODUCT_LINE_CODE%TYPE := NULL;
  l_def_INDUSTRY_BUSINESS_CODE   SCORECARD_USER_PREFERENCES.INDUSTRY_BUSINESS_CODE%TYPE := NULL;
  l_def_INDUSTRY_CODE            SCORECARD_USER_PREFERENCES.INDUSTRY_CODE%TYPE := NULL;
  l_def_MFG_CAMPUS_ID            SCORECARD_USER_PREFERENCES.MFG_CAMPUS_ID%TYPE := NULL;
  l_def_MFG_BUILDING_NBR         SCORECARD_USER_PREFERENCES.MFG_BUILDING_NBR%TYPE := NULL;
  l_def_COMPARISON_TYPE_CDE      SCORECARD_USER_PREFERENCES.COMPARISON_TYPE_CDE%TYPE := '1';
  l_def_OPEN_SHIPPED_ORDER_CDE   SCORECARD_USER_PREFERENCES.OPEN_SHIPPED_ORDER_CDE%TYPE := '1';
  l_def_PRODUCT_BUSNS_LINE_FNCTN SCORECARD_USER_PREFERENCES.PRODUCT_BUSNS_LINE_FNCTN_ID%TYPE := NULL;
  l_def_PROFIT_CENTER_ABBR_NM    SCORECARD_USER_PREFERENCES.PROFIT_CENTER_ABBR_NM%TYPE := NULL;
  l_def_ORGANIZATION_STRUCTURE_R SCORECARD_USER_PREFERENCES.ORGANIZATION_STRUCTURE_REF_DT%TYPE := SYSDATE;
  l_def_DML_TS                   SCORECARD_USER_PREFERENCES.DML_TS%TYPE := SYSDATE;
  l_def_DML_USER_ID              SCORECARD_USER_PREFERENCES.DML_USER_ID%TYPE := 'SCD_SOURCE';
  l_def_PRODUCT_BUSNS_LINE_ID    SCORECARD_USER_PREFERENCES.PRODUCT_BUSNS_LINE_ID%TYPE := NULL;
  l_def_PRODUCT_MANAGER_NM       SCORECARD_USER_PREFERENCES.PRODUCT_MANAGER_NM%TYPE := NULL;
  l_def_LEADTIME_TYPE_CDE        SCORECARD_USER_PREFERENCES.LEADTIME_TYPE_CDE%TYPE := '1';
  l_def_SALES_OFFICE_CDE         SCORECARD_USER_PREFERENCES.SALES_OFFICE_CDE%TYPE := NULL;
  l_def_SALES_GROUP_CDE          SCORECARD_USER_PREFERENCES.SALES_GROUP_CDE%TYPE := NULL;
  l_def_MFG_ORGANIZATION_TYPE_ID SCORECARD_USER_PREFERENCES.ORGANIZATION_TYPE_ID%TYPE := '1636';
  l_def_MFG_ORGANIZATION_ID      SCORECARD_USER_PREFERENCES.ORGANIZATION_ID%TYPE := NULL;
  l_def_Gam_Acct_Cde             SCORECARD_USER_PREFERENCES.GAM_ACCT_CDE%TYPE := NULL;
  l_def_PART_KEY_ID              SCORECARD_USER_PREFERENCES.PART_KEY_ID%TYPE := NULL;
  l_def_MRP_GROUP_CDE            SCORECARD_USER_PREFERENCES.MRP_GROUP_CDE%TYPE := NULL;
  l_def_PRODUCT_HOST_ORG_ID      SCORECARD_USER_PREFERENCES.PRODUCT_HOST_ORG_ID%TYPE := NULL;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:   RetrieveSession                                               */
  /* DESC:        This procedure gets the last session of search by session id  */
  /*                                                                            */
  /******************************************************************************/
  PROCEDURE RetrieveSession(iSessionId           IN VARCHAR2,
                            oViewId              OUT VARCHAR2,
                            oCategoryId          OUT VARCHAR2,
                            oWindowId            OUT VARCHAR2,
                            oStartDt             OUT VARCHAR2,
                            oEndDt               OUT VARCHAR2,
                            oDaysEarly           OUT VARCHAR2,
                            oDaysLate            OUT VARCHAR2,
                            oMonthDailyInd       OUT VARCHAR2,
                            oSmryType            OUT VARCHAR2,
                            oCurrentHist         OUT VARCHAR2,
                            oOrgType             OUT VARCHAR2,
                            oOrgId               OUT VARCHAR2,
                            oCustAcctTypeCde     OUT VARCHAR2,
                            oPart                OUT VARCHAR2,
                            oPlant               OUT VARCHAR2,
                            oLocation            OUT VARCHAR2,
                            oAcctOrgID           OUT VARCHAR2,
                            oShipTo              OUT VARCHAR2,
                            oSoldTo              OUT VARCHAR2,
                            oWWCust              OUT VARCHAR2,
                            oInvOrgID            OUT VARCHAR2,
                            oController          OUT VARCHAR2,
                            oCntlrEmpNbr         OUT VARCHAR2,
                            oStkMake             OUT VARCHAR2,
                            oTeam                OUT VARCHAR2,
                            oProdCde             OUT VARCHAR2,
                            oProdLne             OUT VARCHAR2,
                            oIBC                 OUT VARCHAR2,
                            oIC                  OUT VARCHAR2,
                            oMfgCampus           OUT VARCHAR2,
                            oMfgBulding          OUT VARCHAR2,
                            oComparisonType      OUT VARCHAR2,
                            oOpenShpOrder        OUT VARCHAR2,
                            oProfitCtr           OUT VARCHAR2,
                            oCompetencyBusCde    OUT VARCHAR2,
                            oOrgDt               OUT VARCHAR2,
                            oSubCompetencyBusCde OUT VARCHAR2,
                            oProdMgr             OUT VARCHAR2,
                            oLeadTimeType        OUT VARCHAR2,
                            oSalesOffice         OUT VARCHAR2,
                            oSalesGroup          OUT VARCHAR2,
                            oMfgOrgType          OUT VARCHAR2,
                            oMfgOrgId            OUT VARCHAR2,
                            oGamAcct             OUT VARCHAR2,
                            oPartKeyID           OUT VARCHAR2,
                            oMrpGroupCde         OUT VARCHAR2,
                            oProdHostOrgID       OUT VARCHAR2,
                            oErrorNumber         OUT VARCHAR2,
                            oErrorDesc           OUT VARCHAR2) IS
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT SCORECARD_VIEW_ID,
           SCORECARD_CATEGORY_ID,
           SCORECARD_WINDOW_ID,
           TO_CHAR(START_DT, 'YYYY-MM-DD'),
           TO_CHAR(END_DT, 'YYYY-MM-DD'),
           NBR_WINDOW_DAYS_EARLY,
           NBR_WINDOW_DAYS_LATE,
           MONTHLY_DAILY_IND,
           DELIVERY_SMRY_TYPE,
           CURRENT_HISTORY_IND,
           ORGANIZATION_TYPE_ID,
           ORGANIZATION_ID,
           CUSTOMER_ACCT_TYPE_CDE,
           PART_NBR,
           PLANT_ID,
           PLANT_LOCATION_ID,
           ACCOUNTING_ORGANIZATION_ID,
           SHIP_TO_CUSTOMER_ID,
           SOLD_TO_CUSTOMER_ID,
           WW_CUSTOMER_ACCOUNT_NBR,
           INVENTORY_ORGANIZATION_ID,
           PRODCN_CNTRLR_CODE,
           PRODCN_CNTLR_EMPLOYEE_NBR,
           STOCK_MAKE_CODE,
           TEAM_CODE,
           PRODUCT_CODE,
           PRODUCT_LINE_CODE,
           INDUSTRY_BUSINESS_CODE,
           INDUSTRY_CODE,
           MFG_CAMPUS_ID,
           MFG_BUILDING_NBR,
           COMPARISON_TYPE_CDE,
           OPEN_SHIPPED_ORDER_CDE,
           PRODUCT_BUSNS_LINE_ID,
           PRODUCT_BUSNS_LINE_FNCTN_ID,
           PROFIT_CENTER_ABBR_NM,
           PRODUCT_MANAGER_NM,
           LEADTIME_TYPE_CDE,
           SALES_OFFICE_CDE,
           SALES_GROUP_CDE,
           MFG_ORGANIZATION_TYPE_ID,
           MFG_ORGANIZATION_ID,
           TO_CHAR(ORGANIZATION_STRUCTURE_REF_DT, 'YYYY-MM-DD'),
           GAM_ACCT_CDE,
           PART_KEY_ID,
           MRP_GROUP_CDE,
           PRODUCT_HOST_ORG_ID
      INTO oViewId,
           oCategoryId,
           oWindowId,
           oStartDt,
           oEndDt,
           oDaysEarly,
           oDaysLate,
           oMonthDailyInd,
           oSmryType,
           oCurrentHist,
           oOrgType,
           oOrgId,
           oCustAcctTypeCde,
           oPart,
           oPlant,
           oLocation,
           oAcctOrgID,
           oShipTo,
           oSoldTo,
           oWWCust,
           oInvOrgID,
           oController,
           oCntlrEmpNbr,
           oStkMake,
           oTeam,
           oProdCde,
           oProdLne,
           oIBC,
           oIC,
           oMfgCampus,
           oMfgBulding,
           oComparisonType,
           oOpenShpOrder,
           oCompetencyBusCde,
           oSubCompetencyBusCde,
           oProfitCtr,
           oProdMgr,
           oLeadTimeType,
           oSalesOffice,
           oSalesGroup,
           oMfgOrgType,
           oMfgOrgId,
           oOrgDt,
           oGamAcct,
           oPartKeyID,
           oMrpGroupCde,
           oProdHostOrgID
      FROM SCORECARD_USER_PREFERENCES
     WHERE SCD_USER_PREFERENCES_ID = TO_NUMBER(iSessionId);
    /*Anyone who wants to cut and paste
          oViewId
          oCategoryId
          oWindowId
          oStartDt
          oEndDt
          oDaysEarly
          oDaysLate
          oMonthDailyInd
          oSmryType
          oCurrentHist
        oOrgType
          oOrgId
          oCustAcctTypeCde
          oPart
          oPlant
          oLocation
          oAcctOrgID
          oShipTo
          oSoldTo
          oWWCust
          oInvOrgID
          oController
          oCntlrEmpNbr
          oStkMake
          oTeam
          oProdCde
          oProdLne
          oIBC
          oIC
          oMfgCampus
          oMfgBulding
          oComparisonType
          oOpenShpOrder
          oProfitCtr
          oCompetencyBusCde
          oOrgDt
    */
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.RetrieveSession)';
    
  END RetrieveSession;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  UpdateSession                                                  */
  /* DESC:       This procedure updates the last search session by session id   */
  /*                                                                            */
  /******************************************************************************/
  PROCEDURE UpdateSession(iAmpID               IN VARCHAR2,
                          iSessionId           IN VARCHAR2,
                          iViewId              IN VARCHAR2,
                          iCategoryId          IN VARCHAR2,
                          iWindowId            IN VARCHAR2,
                          iStartDt             IN VARCHAR2,
                          iEndDt               IN VARCHAR2,
                          iDaysEarly           IN VARCHAR2,
                          iDaysLate            IN VARCHAR2,
                          iMonthDailyInd       IN VARCHAR2,
                          iSmryType            IN VARCHAR2,
                          iCurrentHist         IN VARCHAR2,
                          iOrgType             IN VARCHAR2,
                          iOrgId               IN VARCHAR2,
                          iCustAcctTypeCde     IN VARCHAR2,
                          iPart                IN VARCHAR2,
                          iPlant               IN VARCHAR2,
                          iLocation            IN VARCHAR2,
                          iAcctOrgID           IN VARCHAR2,
                          iShipTo              IN VARCHAR2,
                          iSoldTo              IN VARCHAR2,
                          iWWCust              IN VARCHAR2,
                          iInvOrgID            IN VARCHAR2,
                          iController          IN VARCHAR2,
                          iCntlrEmpNbr         IN VARCHAR2,
                          iStkMake             IN VARCHAR2,
                          iTeam                IN VARCHAR2,
                          iProdCde             IN VARCHAR2,
                          iProdLne             IN VARCHAR2,
                          iIBC                 IN VARCHAR2,
                          iIC                  IN VARCHAR2,
                          iMfgCampus           IN VARCHAR2,
                          iMfgBulding          IN VARCHAR2,
                          iComparisonType      IN VARCHAR2,
                          iOpenShpOrder        IN VARCHAR2,
                          iProfitCtr           IN VARCHAR2,
                          iCompetencyBusCde    IN VARCHAR2,
                          iOrgDt               IN VARCHAR2,
                          iSubCompetencyBusCde IN VARCHAR2,
                          iProdMgr             IN VARCHAR2,
                          iLeadTimeType        IN VARCHAR2,
                          iSalesOffice         IN VARCHAR2,
                          iSalesGroup          IN VARCHAR2,
                          iMfgOrgType          IN VARCHAR2,
                          iMfgOrgId            IN VARCHAR2,
                          iGamAcct             IN VARCHAR2,
                          iPartKeyID           IN VARCHAR2,
                          iMrpGroupCde         IN VARCHAR2,
                          iProdHostOrgID       IN VARCHAR2,
                          oErrorNumber         OUT VARCHAR2,
                          oErrorDesc           OUT VARCHAR2) IS
    lv_StartDt VARCHAR2(20) := iStartDt;
    lv_EndDt   VARCHAR2(20) := iEndDt;
    ld_StartDt DATE;
    ld_EndDt   DATE;
    lv_Test    VARCHAR2(20);
    INVALID_USER EXCEPTION;
    INVALID_SESSION EXCEPTION;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    IF iMonthDailyInd = '2' THEN
      IF lv_StartDt = '' OR lv_StartDt IS NULL THEN
        lv_StartDt := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
      END IF;
      IF lv_EndDt = '' OR lv_EndDt IS NULL THEN
        lv_EndDt := lv_StartDt;
      END IF;
      ld_StartDt := TO_DATE(lv_StartDt, 'YYYY-MM-DD');
      ld_EndDt   := TO_DATE(lv_EndDt, 'YYYY-MM-DD');
    ELSE
      IF lv_StartDt = '' OR lv_StartDt IS NULL THEN
        lv_StartDt := TO_CHAR(SYSDATE, 'YYYY-MM');
      END IF;
      IF lv_EndDt = '' OR lv_EndDt IS NULL THEN
        lv_EndDt := lv_StartDt;
      END IF;
      ld_StartDt := TO_DATE(lv_StartDt || '-01', 'YYYY-MM-DD');
      ld_EndDt   := LAST_DAY(TO_DATE(lv_EndDt || '-01', 'YYYY-MM-DD'));
    END IF;
  
    BEGIN
      SELECT DML_USER_ID
        INTO lv_Test
        FROM SCORECARD_USER_PREFERENCES
       WHERE SCD_USER_PREFERENCES_ID = TO_NUMBER(iSessionId);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE INVALID_SESSION;
    END;
  
    IF lv_Test = 'SCD_SOURCE' OR lv_Test = UPPER(iAmpID) THEN
    
      UPDATE SCORECARD_USER_PREFERENCES
         SET SCORECARD_VIEW_ID             = iViewId,
             SCORECARD_CATEGORY_ID         = iCategoryId,
             SCORECARD_WINDOW_ID           = iWindowId,
             START_DT                      = ld_StartDt,
             END_DT                        = ld_EndDt,
             NBR_WINDOW_DAYS_EARLY         = iDaysEarly,
             NBR_WINDOW_DAYS_LATE          = iDaysLate,
             MONTHLY_DAILY_IND             = iMonthDailyInd,
             DELIVERY_SMRY_TYPE            = iSmryType,
             CURRENT_HISTORY_IND           = iCurrentHist,
             ORGANIZATION_TYPE_ID          = iOrgType,
             ORGANIZATION_ID               = iOrgId,
             CUSTOMER_ACCT_TYPE_CDE        = UPPER(iCustAcctTypeCde),
             PART_NBR                      = UPPER(iPart),
             PLANT_ID                      = UPPER(iPlant),
             PLANT_LOCATION_ID             = UPPER(iLocation),
             ACCOUNTING_ORGANIZATION_ID    = UPPER(iAcctOrgID),
             SHIP_TO_CUSTOMER_ID           = UPPER(iShipTo),
             SOLD_TO_CUSTOMER_ID           = UPPER(iSoldTo),
             WW_CUSTOMER_ACCOUNT_NBR       = UPPER(iWWCust),
             INVENTORY_ORGANIZATION_ID     = UPPER(iInvOrgID),
             PRODCN_CNTRLR_CODE            = UPPER(iController),
             PRODCN_CNTLR_EMPLOYEE_NBR     = UPPER(iCntlrEmpNbr),
             STOCK_MAKE_CODE               = UPPER(iStkMake),
             TEAM_CODE                     = UPPER(iTeam),
             PRODUCT_CODE                  = UPPER(iProdCde),
             PRODUCT_LINE_CODE             = UPPER(iProdLne),
             INDUSTRY_BUSINESS_CODE        = UPPER(iIBC),
             INDUSTRY_CODE                 = UPPER(iIC),
             MFG_CAMPUS_ID                 = UPPER(iMfgCampus),
             MFG_BUILDING_NBR              = UPPER(iMfgBulding),
             COMPARISON_TYPE_CDE           = UPPER(iComparisonType),
             OPEN_SHIPPED_ORDER_CDE        = iOpenShpOrder,
             PRODUCT_BUSNS_LINE_ID         = UPPER(iCompetencyBusCde),
             PRODUCT_BUSNS_LINE_FNCTN_ID   = UPPER(iSubCompetencyBusCde),
             PROFIT_CENTER_ABBR_NM         = UPPER(iProfitCtr),
             ORGANIZATION_STRUCTURE_REF_DT = TO_DATE(iOrgDt, 'YYYY-MM-DD'),
             PRODUCT_MANAGER_NM            = UPPER(iProdMgr),
             LEADTIME_TYPE_CDE             = iLeadTimeType,
             SALES_OFFICE_CDE              = UPPER(iSalesOffice),
             SALES_GROUP_CDE               = UPPER(iSalesGroup),
             MFG_ORGANIZATION_TYPE_ID      = iMfgOrgType,
             MFG_ORGANIZATION_ID           = iMfgOrgId,
             DML_TS                        = SYSDATE,
             DML_USER_ID                   = UPPER(iAmpID),
             GAM_ACCT_CDE                  = UPPER(iGamAcct),
             PART_KEY_ID                   = iPartKeyID,
             MRP_GROUP_CDE                 = UPPER(iMrpGroupCde),
             PRODUCT_HOST_ORG_ID           = iProdHostOrgID
       WHERE SCD_USER_PREFERENCES_ID = TO_NUMBER(iSessionId);
    ELSE
      RAISE INVALID_USER;
    END IF;
  
    COMMIT;
  EXCEPTION
    WHEN INVALID_USER THEN
      oErrorNumber := '-13';
      oErrorDesc   := 'You are not the owner of this session and are not permitted to alter it. (scdSearch.UpdateSession)';
    WHEN INVALID_SESSION THEN
      oErrorNumber := '-11';
      oErrorDesc   := 'Session Not Found. (scdSearch.UpdateSession)';
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.UpdateSession)';
  END UpdateSession;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  RetrieveLastSession                                            */
  /* DESC:       This procedure retrieves the most recent record in the         */
  /*             user_preferences table for the user and returns the session id.*/
  /******************************************************************************/
  PROCEDURE RetrieveLastSession(iGlobalID    IN VARCHAR2,
                                oSessionID   OUT VARCHAR2,
                                oErrorNumber OUT VARCHAR2,
                                oErrorDesc   OUT VARCHAR2) IS
    lv_GUID SCORECARD_USER_PREFERENCES.ASOC_GLOBAL_ID%TYPE;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    lv_GUID := TO_NUMBER(iGlobalID);
  
    SELECT TO_CHAR(MAX(sup.SCD_USER_PREFERENCES_ID))
      INTO oSessionID
      FROM SCORECARD_USER_PREFERENCES sup,
           (SELECT MAX(DML_TS) AS Latest
              FROM SCORECARD_USER_PREFERENCES
             WHERE ASOC_GLOBAL_ID = lv_GUID) Dates
     WHERE sup.ASOC_GLOBAL_ID = lv_GUID
       AND sup.DML_TS = Dates.Latest;
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oSessionID := '';
    WHEN OTHERS THEN
      oSessionID   := '';
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.RetrieveLastSession)';
    
  END RetrieveLastSession;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  CreateCurrentSession                                           */
  /* DESC:       This procedure creates a new record in the user_preferences    */
  /*             table and returns the session id.                              */
  /******************************************************************************/
  PROCEDURE CreateCurrentSession(iGlobalID    IN VARCHAR2,
                                 oSessionID   OUT VARCHAR2,
                                 oErrorNumber OUT VARCHAR2,
                                 oErrorDesc   OUT VARCHAR2) IS
  
    lv_SessionID_char VARCHAR2(8);
    ln_NewSessionID   SCORECARD_USER_PREFERENCES.SCD_USER_PREFERENCES_ID%TYPE;
    ln_SessionID      SCORECARD_USER_PREFERENCES.SCD_USER_PREFERENCES_ID%TYPE;
  
    RETRIEVE_LAST_SESSION_ERROR EXCEPTION;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    RetrieveLastSession(iGlobalID,
                        lv_SessionID_char,
                        oErrorNumber,
                        oErrorDesc);
  
    IF oErrorNumber <> '0' THEN
      RAISE RETRIEVE_LAST_SESSION_ERROR;
    END IF;
  
    SELECT SCD_USER_PREFERENCES_ID_SEQ.NEXTVAL
      INTO ln_NewSessionID
      FROM DUAL;
  
    IF lv_SessionID_char IS NULL OR lv_SessionID_char = '' THEN
      INSERT INTO SCORECARD_USER_PREFERENCES
        (SCD_USER_PREFERENCES_ID,
         USER_PREFERENCES_SHORT_DESC,
         ASOC_GLOBAL_ID,
         SCORECARD_VIEW_ID,
         SCORECARD_CATEGORY_ID,
         SCORECARD_WINDOW_ID,
         START_DT,
         END_DT,
         NBR_WINDOW_DAYS_EARLY,
         NBR_WINDOW_DAYS_LATE,
         MONTHLY_DAILY_IND,
         DELIVERY_SMRY_TYPE,
         CURRENT_HISTORY_IND,
         ORGANIZATION_TYPE_ID,
         ORGANIZATION_ID,
         CUSTOMER_ACCT_TYPE_CDE,
         PART_NBR,
         PLANT_ID,
         PLANT_LOCATION_ID,
         ACCOUNTING_ORGANIZATION_ID,
         SHIP_TO_CUSTOMER_ID,
         SOLD_TO_CUSTOMER_ID,
         WW_CUSTOMER_ACCOUNT_NBR,
         INVENTORY_ORGANIZATION_ID,
         PRODCN_CNTRLR_CODE,
         PRODCN_CNTLR_EMPLOYEE_NBR,
         STOCK_MAKE_CODE,
         TEAM_CODE,
         PRODUCT_CODE,
         PRODUCT_LINE_CODE,
         INDUSTRY_BUSINESS_CODE,
         INDUSTRY_CODE,
         MFG_CAMPUS_ID,
         MFG_BUILDING_NBR,
         COMPARISON_TYPE_CDE,
         OPEN_SHIPPED_ORDER_CDE,
         PRODUCT_BUSNS_LINE_ID,
         PRODUCT_BUSNS_LINE_FNCTN_ID,
         PROFIT_CENTER_ABBR_NM,
         ORGANIZATION_STRUCTURE_REF_DT,
         PRODUCT_MANAGER_NM,
         LEADTIME_TYPE_CDE,
         SALES_OFFICE_CDE,
         SALES_GROUP_CDE,
         MFG_ORGANIZATION_TYPE_ID,
         MFG_ORGANIZATION_ID,
         DML_TS,
         DML_USER_ID,
         GAM_ACCT_CDE,
         PART_KEY_ID,
         MRP_GROUP_CDE,
         PRODUCT_HOST_ORG_ID)
      VALUES
        (ln_NewSessionID, --SCD_USER_PREFERENCES_ID,
         l_def_USER_PREFERENCES_SHORT_D,
         TO_NUMBER(iGlobalID), --ASOC_GLOBAL_ID,
         l_def_SCORECARD_VIEW_ID,
         l_def_SCORECARD_CATEGORY_ID,
         l_def_SCORECARD_WINDOW_ID,
         l_def_START_DT,
         l_def_END_DT,
         l_def_NBR_WINDOW_DAYS_EARLY,
         l_def_NBR_WINDOW_DAYS_LATE,
         l_def_MONTHLY_DAILY_IND,
         l_def_DELIVERY_SMRY_TYPE,
         l_def_CURRENT_HISTORY_IND,
         l_def_ORGANIZATION_TYPE_ID,
         l_def_ORGANIZATION_ID,
         l_def_CUSTOMER_ACCT_TYPE_CDE,
         l_def_PART_NBR,
         l_def_PLANT_ID,
         l_def_PLANT_LOCATION_ID,
         l_def_ACCOUNTING_ORGANIZATION,
         l_def_SHIP_TO_CUSTOMER_ID,
         l_def_SOLD_TO_CUSTOMER_ID,
         l_def_WW_CUSTOMER_ACCOUNT_NBR,
         l_def_INVENTORY_ORGANIZATION,
         l_def_PRODCN_CNTRLR_CODE,
         l_def_PRODCN_CNTLR_EMPLOYEE,
         l_def_STOCK_MAKE_CODE,
         l_def_TEAM_CODE,
         l_def_PRODUCT_CODE,
         l_def_PRODUCT_LINE_CODE,
         l_def_INDUSTRY_BUSINESS_CODE,
         l_def_INDUSTRY_CODE,
         l_def_MFG_CAMPUS_ID,
         l_def_MFG_BUILDING_NBR,
         l_def_COMPARISON_TYPE_CDE,
         l_def_OPEN_SHIPPED_ORDER_CDE,
         l_def_PRODUCT_BUSNS_LINE_ID,
         l_def_PRODUCT_BUSNS_LINE_FNCTN,
         l_def_PROFIT_CENTER_ABBR_NM,
         l_def_ORGANIZATION_STRUCTURE_R,
         l_def_PRODUCT_MANAGER_NM,
         l_def_LEADTIME_TYPE_CDE,
         l_def_SALES_OFFICE_CDE,
         l_def_SALES_GROUP_CDE,
         l_def_MFG_ORGANIZATION_TYPE_ID,
         l_def_MFG_ORGANIZATION_ID,
         l_def_DML_TS,
         l_def_DML_USER_ID,
         L_DEF_Gam_Acct_Cde,
         l_def_PART_KEY_ID,
         l_def_MRP_GROUP_CDE,
         l_def_PRODUCT_HOST_ORG_ID);
    ELSE
    
      ln_SessionID := TO_NUMBER(lv_SessionID_char);
    
      INSERT INTO SCORECARD_USER_PREFERENCES
        (SCD_USER_PREFERENCES_ID,
         USER_PREFERENCES_SHORT_DESC,
         ASOC_GLOBAL_ID,
         SCORECARD_VIEW_ID,
         SCORECARD_CATEGORY_ID,
         SCORECARD_WINDOW_ID,
         START_DT,
         END_DT,
         NBR_WINDOW_DAYS_EARLY,
         NBR_WINDOW_DAYS_LATE,
         MONTHLY_DAILY_IND,
         DELIVERY_SMRY_TYPE,
         CURRENT_HISTORY_IND,
         ORGANIZATION_TYPE_ID,
         ORGANIZATION_ID,
         CUSTOMER_ACCT_TYPE_CDE,
         PART_NBR,
         PLANT_ID,
         PLANT_LOCATION_ID,
         ACCOUNTING_ORGANIZATION_ID,
         SHIP_TO_CUSTOMER_ID,
         SOLD_TO_CUSTOMER_ID,
         WW_CUSTOMER_ACCOUNT_NBR,
         INVENTORY_ORGANIZATION_ID,
         PRODCN_CNTRLR_CODE,
         PRODCN_CNTLR_EMPLOYEE_NBR,
         STOCK_MAKE_CODE,
         TEAM_CODE,
         PRODUCT_CODE,
         PRODUCT_LINE_CODE,
         INDUSTRY_BUSINESS_CODE,
         INDUSTRY_CODE,
         MFG_CAMPUS_ID,
         MFG_BUILDING_NBR,
         COMPARISON_TYPE_CDE,
         OPEN_SHIPPED_ORDER_CDE,
         PRODUCT_BUSNS_LINE_ID,
         PRODUCT_BUSNS_LINE_FNCTN_ID,
         PROFIT_CENTER_ABBR_NM,
         ORGANIZATION_STRUCTURE_REF_DT,
         PFR_NBR_WINDOW_DAYS_EARLY,
         PFR_NBR_WINDOW_DAYS_LATE,
         PFR_DELIVERY_SMRY_TYPE,
         PFR_ORGANIZATION_TYPE_ID,
         PFR_ORGANIZATION_ID,
         PRODUCT_MANAGER_NM,
         LEADTIME_TYPE_CDE,
         SALES_OFFICE_CDE,
         SALES_GROUP_CDE,
         MFG_ORGANIZATION_TYPE_ID,
         MFG_ORGANIZATION_ID,
         DML_TS,
         DML_USER_ID,
         Gam_Acct_Cde,
         PART_KEY_ID,
         MRP_GROUP_CDE,
         PRODUCT_HOST_ORG_ID)
        SELECT ln_NewSessionID, --SCD_USER_PREFERENCES_ID
               'LAST', --USER_PREFERENCES_SHORT_DESC,
               ASOC_GLOBAL_ID,
               SCORECARD_VIEW_ID,
               SCORECARD_CATEGORY_ID,
               SCORECARD_WINDOW_ID,
               START_DT,
               END_DT,
               NBR_WINDOW_DAYS_EARLY,
               NBR_WINDOW_DAYS_LATE,
               MONTHLY_DAILY_IND,
               DELIVERY_SMRY_TYPE,
               CURRENT_HISTORY_IND,
               ORGANIZATION_TYPE_ID,
               ORGANIZATION_ID,
               CUSTOMER_ACCT_TYPE_CDE,
               PART_NBR,
               PLANT_ID,
               PLANT_LOCATION_ID,
               ACCOUNTING_ORGANIZATION_ID,
               SHIP_TO_CUSTOMER_ID,
               SOLD_TO_CUSTOMER_ID,
               WW_CUSTOMER_ACCOUNT_NBR,
               INVENTORY_ORGANIZATION_ID,
               PRODCN_CNTRLR_CODE,
               PRODCN_CNTLR_EMPLOYEE_NBR,
               STOCK_MAKE_CODE,
               TEAM_CODE,
               PRODUCT_CODE,
               PRODUCT_LINE_CODE,
               INDUSTRY_BUSINESS_CODE,
               INDUSTRY_CODE,
               MFG_CAMPUS_ID,
               MFG_BUILDING_NBR,
               COMPARISON_TYPE_CDE,
               OPEN_SHIPPED_ORDER_CDE,
               PRODUCT_BUSNS_LINE_ID,
               PRODUCT_BUSNS_LINE_FNCTN_ID,
               PROFIT_CENTER_ABBR_NM,
               ORGANIZATION_STRUCTURE_REF_DT,
               PFR_NBR_WINDOW_DAYS_EARLY,
               PFR_NBR_WINDOW_DAYS_LATE,
               PFR_DELIVERY_SMRY_TYPE,
               PFR_ORGANIZATION_TYPE_ID,
               PFR_ORGANIZATION_ID,
               PRODUCT_MANAGER_NM,
               LEADTIME_TYPE_CDE,
               SALES_OFFICE_CDE,
               SALES_GROUP_CDE,
               MFG_ORGANIZATION_TYPE_ID,
               MFG_ORGANIZATION_ID,
               SYSDATE, --DML_TS
               DML_USER_ID,
               GAM_ACCT_CDE,
               PART_KEY_ID,
               MRP_GROUP_CDE,
               PRODUCT_HOST_ORG_ID
          FROM SCORECARD_USER_PREFERENCES
         WHERE SCD_USER_PREFERENCES_ID = ln_SessionID;
    
      UPDATE SCORECARD_USER_PREFERENCES
         SET USER_PREFERENCES_SHORT_DESC = 'OLD'
       WHERE SCD_USER_PREFERENCES_ID = ln_SessionID;
    
    END IF;
  
    oSessionID := TO_CHAR(ln_NewSessionID);
  
    Purge_Old_Sessions(iGlobalID, oErrorNumber, oErrorDesc);
  
    COMMIT;
    --dbms_output.put_line('Session:  '||oSessionID);
    --dbms_output.put_line('Error#:  '||oErrorNumber);
    --dbms_output.put_line('Desc:  '||oErrorDesc);
  EXCEPTION
    WHEN RETRIEVE_LAST_SESSION_ERROR THEN
      oSessionID := '';
      oErrorDesc := oErrorDesc ||
                    ' (While Retrieving Last Session) (scdSearch.CreateCurrentSession)';
      --dbms_output.put_line('Session:  '||oSessionID);
    --dbms_output.put_line('Error#:  '||oErrorNumber);
    --dbms_output.put_line('Desc:  '||oErrorDesc);
    WHEN OTHERS THEN
      ROLLBACK;
      oSessionID   := '';
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.CreateCurrentSession)';
    
    --dbms_output.put_line('Session:  '||oSessionID);
    --dbms_output.put_line('Error#:  '||oErrorNumber);
    --dbms_output.put_line('Desc:  '||oErrorDesc);
  END CreateCurrentSession;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  ResetToDefaults                                                */
  /* DESC:       This procedure creates a new record in the user_preferences    */
  /*             table, sets the defaults and returns the session id.           */
  /******************************************************************************/
  PROCEDURE ResetToDefaults(iGlobalID    IN VARCHAR2,
                            oSessionID   OUT VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2) IS
    lv_SessionID_char VARCHAR2(8);
    ln_SessionID      SCORECARD_USER_PREFERENCES.SCD_USER_PREFERENCES_ID%TYPE;
  
    ln_Days_Early    SCORECARD_USER_PREFERENCES.NBR_WINDOW_DAYS_EARLY%TYPE;
    ln_Days_Late     SCORECARD_USER_PREFERENCES.NBR_WINDOW_DAYS_LATE%TYPE;
    lv_Delivery_Smry SCORECARD_USER_PREFERENCES.DELIVERY_SMRY_TYPE%TYPE;
    ln_Org_Type_ID   SCORECARD_USER_PREFERENCES.ORGANIZATION_TYPE_ID%TYPE;
    lv_Org_ID        SCORECARD_USER_PREFERENCES.ORGANIZATION_ID%TYPE;
  
    ln_PFR_Days_Early    SCORECARD_USER_PREFERENCES.PFR_NBR_WINDOW_DAYS_EARLY%TYPE;
    ln_PFR_Days_Late     SCORECARD_USER_PREFERENCES.PFR_NBR_WINDOW_DAYS_LATE%TYPE;
    lv_PFR_Delivery_Smry SCORECARD_USER_PREFERENCES.PFR_DELIVERY_SMRY_TYPE%TYPE;
    ln_PFR_Org_Type_ID   SCORECARD_USER_PREFERENCES.PFR_ORGANIZATION_TYPE_ID%TYPE;
    lv_PFR_Org_ID        SCORECARD_USER_PREFERENCES.PFR_ORGANIZATION_ID%TYPE;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    RetrieveLastSession(iGlobalID,
                        lv_SessionID_char,
                        oErrorNumber,
                        oErrorDesc);
  
    ln_SessionID := TO_NUMBER(lv_SessionID_char);
  
    SELECT NBR_WINDOW_DAYS_EARLY,
           NBR_WINDOW_DAYS_LATE,
           DELIVERY_SMRY_TYPE,
           ORGANIZATION_TYPE_ID,
           ORGANIZATION_ID,
           PFR_NBR_WINDOW_DAYS_EARLY,
           PFR_NBR_WINDOW_DAYS_LATE,
           PFR_DELIVERY_SMRY_TYPE,
           PFR_ORGANIZATION_TYPE_ID,
           PFR_ORGANIZATION_ID
      INTO ln_Days_Early,
           ln_Days_Late,
           lv_Delivery_Smry,
           ln_Org_Type_ID,
           lv_Org_ID,
           ln_PFR_Days_Early,
           ln_PFR_Days_Late,
           lv_PFR_Delivery_Smry,
           ln_PFR_Org_Type_ID,
           lv_PFR_Org_ID
      FROM SCORECARD_USER_PREFERENCES
     WHERE SCD_USER_PREFERENCES_ID = ln_SessionID;
  
    IF ln_PFR_Days_Early IS NULL THEN
      ln_Days_Early := l_def_NBR_WINDOW_DAYS_EARLY;
    ELSE
      ln_Days_Early := ln_PFR_Days_Early;
    END IF;
  
    IF ln_PFR_Days_Late IS NULL THEN
      ln_Days_Late := l_def_NBR_WINDOW_DAYS_LATE;
    ELSE
      ln_Days_Late := ln_PFR_Days_Late;
    END IF;
  
    IF lv_PFR_Delivery_Smry IS NULL THEN
      lv_Delivery_Smry := l_def_DELIVERY_SMRY_TYPE;
    ELSE
      lv_Delivery_Smry := lv_PFR_Delivery_Smry;
    END IF;
  
    IF ln_PFR_Org_Type_ID IS NULL THEN
      ln_Org_Type_ID := l_def_ORGANIZATION_TYPE_ID;
    ELSE
      ln_Org_Type_ID := ln_PFR_Org_Type_ID;
    END IF;
  
    IF lv_PFR_Org_ID IS NULL THEN
      lv_Org_ID := l_def_ORGANIZATION_ID;
    ELSE
      lv_Org_ID := lv_PFR_Org_ID;
    END IF;
  
    Purge_Sessions(iGlobalId, oErrorNumber, oErrorDesc);
  
    CreateCurrentSession(iGlobalID,
                         lv_SessionID_char,
                         oErrorNumber,
                         oErrorDesc);
  
    ln_SessionID := TO_NUMBER(lv_SessionID_char);
    oSessionID   := lv_SessionID_char;
  
    UPDATE SCORECARD_USER_PREFERENCES
       SET NBR_WINDOW_DAYS_EARLY     = ln_Days_Early,
           NBR_WINDOW_DAYS_LATE      = ln_Days_Late,
           DELIVERY_SMRY_TYPE        = lv_Delivery_Smry,
           ORGANIZATION_TYPE_ID      = ln_Org_Type_ID,
           ORGANIZATION_ID           = lv_Org_ID,
           PFR_NBR_WINDOW_DAYS_EARLY = ln_PFR_Days_Early,
           PFR_NBR_WINDOW_DAYS_LATE  = ln_PFR_Days_Late,
           PFR_DELIVERY_SMRY_TYPE    = lv_PFR_Delivery_Smry,
           PFR_ORGANIZATION_TYPE_ID  = ln_PFR_Org_Type_ID,
           PFR_ORGANIZATION_ID       = lv_PFR_Org_ID
     WHERE SCD_USER_PREFERENCES_ID = ln_SessionID;
  
    COMMIT;
    --dbms_output.put_line('Session:  '||oSessionID);
    --dbms_output.put_line('Error#:  '||oErrorNumber);
    --dbms_output.put_line('Desc:  '||oErrorDesc);
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      oSessionID   := '';
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.ResetToDefaults)';
    
    --dbms_output.put_line('Session:  '||oSessionID);
    --dbms_output.put_line('Error#:  '||oErrorNumber);
    --dbms_output.put_line('Desc:  '||oErrorDesc);
  END ResetToDefaults;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  Purge_Old_Sessions                                             */
  /* DESC:       Removes a user's sessions that are older than 24 hours.        */
  /*             Does not remove most recent record, even if it is old enough.  */
  /******************************************************************************/
  PROCEDURE Purge_Old_Sessions(iGlobalId    IN VARCHAR2,
                               oErrorNumber OUT VARCHAR2,
                               oErrorDesc   OUT VARCHAR2) IS
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    DELETE FROM SCORECARD_USER_PREFERENCES
     WHERE ASOC_GLOBAL_ID = TO_NUMBER(iGlobalId)
       AND DML_TS < (SYSDATE - 1) /* older than 24 hrs */
       AND DML_TS <>
           (SELECT MAX(DML_TS)
              FROM SCORECARD_USER_PREFERENCES
             WHERE ASOC_GLOBAL_ID = TO_NUMBER(iGlobalId))
       AND UPPER(USER_PREFERENCES_SHORT_DESC) = 'OLD';
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.Purge_Old_Sessions)';
  END Purge_Old_Sessions;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  Purge_Sessions                                                 */
  /* DESC:       Removes all of a user's sessions                               */
  /*                                                                            */
  /******************************************************************************/
  PROCEDURE Purge_Sessions(iGlobalId    IN VARCHAR2,
                           oErrorNumber OUT VARCHAR2,
                           oErrorDesc   OUT VARCHAR2) IS
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    DELETE FROM SCORECARD_USER_PREFERENCES
     WHERE ASOC_GLOBAL_ID = TO_NUMBER(iGlobalId);
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.Purge_Sessions)';
  END Purge_Sessions;

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:  SaveUserLog                                                    */
  /* DESC:       This procedure saves each set of search criteria               */
  /*                                                                            */
  /******************************************************************************/
  PROCEDURE SaveUserLog(iAmpID               IN VARCHAR2,
                        iViewId              IN VARCHAR2,
                        iCategoryId          IN VARCHAR2,
                        iWindowId            IN VARCHAR2,
                        iStartDt             IN VARCHAR2,
                        iEndDt               IN VARCHAR2,
                        iDaysEarly           IN VARCHAR2,
                        iDaysLate            IN VARCHAR2,
                        iMonthDailyInd       IN VARCHAR2,
                        iSmryType            IN VARCHAR2,
                        iCurrentHist         IN VARCHAR2,
                        iOrgType             IN VARCHAR2,
                        iOrgId               IN VARCHAR2,
                        iCustAcctTypeCde     IN VARCHAR2,
                        iPart                IN VARCHAR2,
                        iPlant               IN VARCHAR2,
                        iLocation            IN VARCHAR2,
                        iAcctOrgID           IN VARCHAR2,
                        iShipTo              IN VARCHAR2,
                        iSoldTo              IN VARCHAR2,
                        iWWCust              IN VARCHAR2,
                        iInvOrgID            IN VARCHAR2,
                        iController          IN VARCHAR2,
                        iCntlrEmpNbr         IN VARCHAR2,
                        iStkMake             IN VARCHAR2,
                        iTeam                IN VARCHAR2,
                        iProdCde             IN VARCHAR2,
                        iProdLne             IN VARCHAR2,
                        iIBC                 IN VARCHAR2,
                        iIC                  IN VARCHAR2,
                        iMfgCampus           IN VARCHAR2,
                        iMfgBulding          IN VARCHAR2,
                        iComparisonType      IN VARCHAR2,
                        iOpenShpOrder        IN VARCHAR2,
                        iProfitCtr           IN VARCHAR2,
                        iCompetencyBusCde    IN VARCHAR2,
                        iOrgDt               IN VARCHAR2,
                        iSubCompetencyBusCde IN VARCHAR2,
                        iProdMgr             IN VARCHAR2,
                        iLeadTimeType        IN VARCHAR2,
                        iSalesOffice         IN VARCHAR2,
                        iSalesGroup          IN VARCHAR2,
                        iMfgOrgType          IN VARCHAR2,
                        iMfgOrgId            IN VARCHAR2,
                        iGamAcct             IN VARCHAR2,
                        iPartKeyID           IN VARCHAR2,
                        iMrpGroupCde         IN VARCHAR2,
                        iProdHostOrgID       IN VARCHAR2,
                        oErrorNumber         OUT VARCHAR2,
                        oErrorDesc           OUT VARCHAR2) IS
  
    ln_UserLogID      SCORECARD_USER_LOGS.SCD_USER_LOGS_ID%TYPE;
    lv_StartDt        VARCHAR2(20) := iStartDt;
    lv_EndDt          VARCHAR2(20) := iEndDt;
    ld_StartDt        DATE;
    ld_EndDt          DATE;

  BEGIN

    IF lv_StartDt = '' OR lv_StartDt IS NULL THEN
      lv_StartDt := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    END IF;
    IF lv_EndDt = '' OR lv_EndDt IS NULL THEN
      lv_EndDt := lv_StartDt;
    END IF;
    IF length(lv_StartDt) < 10 THEN
      IF length(lv_StartDt) = 7 THEN
        lv_StartDt := lv_StartDt || '-01';
      ELSE
        lv_StartDt := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
      END IF;
    END IF;
    IF length(lv_EndDt) < 10 THEN
      IF length(lv_EndDt) = 7 THEN
        lv_EndDt := lv_EndDt || '-01';
      ELSE
        lv_EndDt := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
      END IF;
    END IF;

    ld_StartDt := TO_DATE(lv_StartDt, 'YYYY-MM-DD');
    ld_EndDt   := TO_DATE(lv_EndDt, 'YYYY-MM-DD');

    oErrorNumber := '0';
    oErrorDesc   := '';

    SELECT nvl(max(SCD_USER_LOGS_ID),0) + 1
      INTO ln_UserLogID
      FROM SCORECARD_USER_LOGS;

    INSERT INTO SCORECARD_USER_LOGS
      (SCD_USER_LOGS_ID,
       SCORECARD_VIEW_ID,
       SCORECARD_CATEGORY_ID,
       SCORECARD_WINDOW_ID,
       START_DT,
       END_DT,
       NBR_WINDOW_DAYS_EARLY,
       NBR_WINDOW_DAYS_LATE,
       MONTHLY_DAILY_IND,
       DELIVERY_SMRY_TYPE,
       CURRENT_HISTORY_IND,
       ORGANIZATION_TYPE_ID,
       ORGANIZATION_ID,
       CUSTOMER_ACCT_TYPE_CDE,
       PART_NBR,
       PLANT_ID,
       PLANT_LOCATION_ID,
       ACCOUNTING_ORGANIZATION_ID,
       SHIP_TO_CUSTOMER_ID,
       SOLD_TO_CUSTOMER_ID,
       WW_CUSTOMER_ACCOUNT_NBR,
       INVENTORY_ORGANIZATION_ID,
       PRODCN_CNTRLR_CODE,
       PRODCN_CNTLR_EMPLOYEE_NBR,
       STOCK_MAKE_CODE,
       TEAM_CODE,
       PRODUCT_CODE,
       PRODUCT_LINE_CODE,
       INDUSTRY_BUSINESS_CODE,
       INDUSTRY_CODE,
       MFG_CAMPUS_ID,
       MFG_BUILDING_NBR,
       COMPARISON_TYPE_CDE,
       OPEN_SHIPPED_ORDER_CDE,
       PRODUCT_BUSNS_LINE_ID,
       PRODUCT_BUSNS_LINE_FNCTN_ID,
       PROFIT_CENTER_ABBR_NM,
       ORGANIZATION_STRUCTURE_REF_DT,
       PRODUCT_MANAGER_NM,
       LEADTIME_TYPE_CDE,
       SALES_OFFICE_CDE,
       SALES_GROUP_CDE,
       MFG_ORGANIZATION_TYPE_ID,
       MFG_ORGANIZATION_ID,
       DML_TS,
       DML_USER_ID,
       GAM_ACCT_CDE,
       PART_KEY_ID,
       MRP_GROUP_CDE,
       PRODUCT_HOST_ORG_ID)
    VALUES
      (ln_UserLogID,
       iViewId,
       iCategoryId,
       iWindowId,
       ld_StartDt,
       ld_EndDt,
       iDaysEarly,
       iDaysLate,
       iMonthDailyInd,
       iSmryType,
       iCurrentHist,
       iOrgType,
       iOrgId,
       iCustAcctTypeCde,
       iPart,
       iPlant,
       iLocation,
       iAcctOrgID,
       iShipTo,
       iSoldTo,
       iWWCust,
       iInvOrgID,
       iController,
       iCntlrEmpNbr,
       iStkMake,
       iTeam,
       iProdCde,
       iProdLne,
       iIBC,
       iIC,
       iMfgCampus,
       iMfgBulding,
       iComparisonType,
       iOpenShpOrder,
       iCompetencyBusCde,
       iSubCompetencyBusCde,
       iProfitCtr,
       TO_DATE(iOrgDt, 'YYYY-MM-DD'),
       iProdMgr,
       iLeadTimeType,
       iSalesOffice,
       iSalesGroup,
       iMfgOrgType,
       iMfgOrgId,
       SYSDATE,
       iAmpID,
       iGamAcct,
       iPartKeyID,
       iMrpGroupCde,
       iProdHostOrgID);
    
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdSearch.SaveUserLog)';
  END SaveUserLog;

END Scdsearch;
/
