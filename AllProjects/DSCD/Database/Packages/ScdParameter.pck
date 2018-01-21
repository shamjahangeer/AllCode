CREATE OR REPLACE PACKAGE ScdParameter IS

PROCEDURE UpdateParamLocal
		(iParamID		IN  VARCHAR2,
		iParamValue		IN 	VARCHAR2,
		iUserID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE AddParamLocal
		(iParamID		IN  VARCHAR2,
		iParamDesc		IN 	VARCHAR2,
		iParamValue		IN 	VARCHAR2,
		iParamType		IN 	VARCHAR2,
		iUserID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE UpdateWeekendShip
		(iKeyBldgNbr	IN  VARCHAR2,
		iKeyLocCode		IN 	VARCHAR2,
		iBldgNbr		IN  VARCHAR2,
		iLocCode		IN 	VARCHAR2,
		iSatShipInd		IN 	VARCHAR2,
		iSunShipInd		IN 	VARCHAR2,
		iUserID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE InsertWeekendShip
		(iBldgNbr		IN  VARCHAR2,
		iLocCode		IN 	VARCHAR2,
		iSatShipInd		IN 	VARCHAR2,
		iSunShipInd		IN 	VARCHAR2,
		iUserID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE DeleteWeekendShip
		(iBldgNbr		IN  VARCHAR2,
		iLocCode		IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);
		
PROCEDURE UpdParamLocalPrcsInd
		(iPrcsID		IN  VARCHAR2,
		iPrcsInd		IN 	VARCHAR2,
		iUserID			IN	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);		

END ScdParameter;
/
CREATE OR REPLACE PACKAGE BODY ScdParameter IS

  PROCEDURE UpdateParamLocal(iParamID     IN VARCHAR2,
                             iParamValue  IN VARCHAR2,
                             iUserID      IN VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    UPDATE DELIVERY_PARAMETER_LOCAL
       SET PARAMETER_FIELD = Upper(iParamValue),
           DML_ORACLE_ID   = iUserID,
           DML_TMSTMP      = SYSDATE
     WHERE PARAMETER_ID = iParamID;
  
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'No record found for that Param ID. (scdParameter.UpdateParamLocal)';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.UpdateParamLocal.';
      ROLLBACK;
  END UpdateParamLocal;

  PROCEDURE AddParamLocal(iParamID     IN VARCHAR2,
                          iParamDesc   IN VARCHAR2,
                          iParamValue  IN VARCHAR2,
                          iParamType   IN VARCHAR2,
                          iUserID      IN VARCHAR2,
                          oErrorNumber OUT VARCHAR2,
                          oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    INSERT INTO DELIVERY_PARAMETER_LOCAL
      (PARAMETER_ID,
       PARAMETER_DESCRIPTION,
       PARAMETER_FIELD,
       PARAMETER_UPDATE_TYPE,
       DML_ORACLE_ID,
       DML_TMSTMP)
    VALUES
      (Upper(iParamID),
       iParamDesc,
       Upper(iParamValue),
       iParamType,
       iUserID,
       SYSDATE);
  
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'Record already exist for that Param ID. (scdParameter.AddParamLocal)';
      ROLLBACK;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.AddParamLocal.';
      ROLLBACK;
  END AddParamLocal;

  PROCEDURE UpdateWeekendShip(iKeyBldgNbr  IN VARCHAR2,
                              iKeyLocCode  IN VARCHAR2,
                              iBldgNbr     IN VARCHAR2,
                              iLocCode     IN VARCHAR2,
                              iSatShipInd  IN VARCHAR2,
                              iSunShipInd  IN VARCHAR2,
                              iUserID      IN VARCHAR2,
                              oErrorNumber OUT VARCHAR2,
                              oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    UPDATE SCORECARD_WEEKEND_SHIP
       SET BUILDING_NBR  = iBldgNbr,
           LOCATION_CODE = iLocCode,
           SAT_SHIP_IND  = iSatShipInd,
           SUN_SHIP_IND  = iSunShipInd,
           DML_ORACLE_ID = iUserID,
           DML_TMSTMP    = SYSDATE
     WHERE BUILDING_NBR = iKeyBldgNbr
       AND LOCATION_CODE = iKeyLocCode;
  
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'No record found for that Bldg Nbr, Loc Code. (scdParameter.UpdateWeekendShip)';
    WHEN DUP_VAL_ON_INDEX THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'Record already exist for that Bldg Nbr, Loc Code. (scdParameter.InsertWeekendShip)';
      ROLLBACK;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.UpdateWeekendShip.';
      ROLLBACK;
  END UpdateWeekendShip;

  PROCEDURE InsertWeekendShip(iBldgNbr     IN VARCHAR2,
                              iLocCode     IN VARCHAR2,
                              iSatShipInd  IN VARCHAR2,
                              iSunShipInd  IN VARCHAR2,
                              iUserID      IN VARCHAR2,
                              oErrorNumber OUT VARCHAR2,
                              oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    INSERT INTO SCORECARD_WEEKEND_SHIP
      (BUILDING_NBR,
       LOCATION_CODE,
       SAT_SHIP_IND,
       SUN_SHIP_IND,
       DML_ORACLE_ID,
       DML_TMSTMP)
    VALUES
      (iBldgNbr, iLocCode, iSatShipInd, iSunShipInd, iUserID, SYSDATE);
  
    COMMIT;
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'Record already exist for that Bldg Nbr, Loc Code. (scdParameter.InsertWeekendShip)';
      ROLLBACK;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.InsertWeekendShip.';
      ROLLBACK;
  END InsertWeekendShip;

  PROCEDURE DeleteWeekendShip(iBldgNbr     IN VARCHAR2,
                              iLocCode     IN VARCHAR2,
                              oErrorNumber OUT VARCHAR2,
                              oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    DELETE SCORECARD_WEEKEND_SHIP
     WHERE BUILDING_NBR = iBldgNbr
       AND LOCATION_CODE = iLocCode;
  
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'No record found for that Bldg Nbr, Loc Code. (scdParameter.DeleteWeekendShip)';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.DeleteWeekendShip.';
      ROLLBACK;
  END DeleteWeekendShip;

  PROCEDURE UpdParamLocalPrcsInd(iPrcsID      IN VARCHAR2,
                                 iPrcsInd     IN VARCHAR2,
                                 iUserID      IN VARCHAR2,
                                 oErrorNumber OUT VARCHAR2,
                                 oErrorDesc   OUT VARCHAR2) IS
    ParamID   DELIVERY_PARAMETER_LOCAL.PARAMETER_ID%TYPE;
    ParamDesc DELIVERY_PARAMETER_LOCAL.PARAMETER_DESCRIPTION%TYPE;
    OrgCde    ORGANIZATIONS_DMN.ISO_LEGACY_PREFERRED_ORG_CDE%TYPE;
    New_Exception EXCEPTION;
    ErrDesc  VARCHAR2(500);
    FoundInd NUMBER(3) := 0;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
    ParamID      := 'PRCS' || Upper(iPrcsID);
  
    SELECT COUNT(*)
      INTO FoundInd
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = ParamID;
  
    IF FoundInd > 0 THEN
      UpdateParamLocal(ParamID,
                       iPrcsInd,
                       iUserID,
                       oErrorNumber,
                       oErrorDesc);
    
      IF oErrorNumber <> '0' THEN
        ErrDesc := SQLERRM || ' while updating record';
        RAISE New_Exception;
      END IF;
    ELSE
      -- not found -- derive OrgID
      BEGIN
        IF to_number(iPrcsID) > 0 THEN
          SELECT REPORTING_ORGANIZATION_ID
            INTO ParamDesc
            FROM COSTED_ADR43_SUBMISSIONS
           WHERE DATA_SOURCE_ID = to_number(iPrcsID)
             AND SOURCE_ID NOT LIKE 'DFLT%'
             AND EXPIRATION_DT IS NULL;
        END IF;
      EXCEPTION
        WHEN INVALID_NUMBER THEN
          IF Upper(iPrcsID) in ('0B', '0S') THEN
            OrgCde := '0';
          ELSE
            OrgCde := Upper(iPrcsID);
          END IF;
        
          IF Not scdCommonBatch.GetOrgIDV2(OrgCde, ParamDesc) THEN
            ParamDesc := 'OrgID not found';
          END IF;
        WHEN NO_DATA_FOUND THEN
          ParamDesc := 'OrgID not found';
        WHEN TOO_MANY_ROWS THEN
          ParamDesc := 'OrgID is > 1';
        WHEN OTHERS THEN
          IF Abs(SQLCODE) = 6502 THEN
            IF Upper(iPrcsID) in ('0B', '0S') THEN
              OrgCde := '0';
            ELSE
              OrgCde := Upper(iPrcsID);
            END IF;
          
            IF Not scdCommonBatch.GetOrgIDV2(OrgCde, ParamDesc) THEN
              ParamDesc := 'OrgID not found';
            END IF;
          ELSE
            oErrorNumber := TO_CHAR(SQLCODE);
            ErrDesc      := SQLERRM || ' while getting OrgID';
            RAISE New_Exception;
          END IF;
      END;
    
      AddParamLocal(ParamID,
                    ParamDesc,
                    iPrcsInd,
                    '3',
                    iUserID,
                    oErrorNumber,
                    oErrorDesc);
    
      IF oErrorNumber <> '0' THEN
        ErrDesc := SQLERRM || ' while inserting record';
        RAISE New_Exception;
      END IF;
    
    END IF;
  EXCEPTION
    WHEN New_Exception THEN
      oErrorDesc := ErrDesc || ' in (scdParameter.UpdPrcsParamLocal)';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' in scdParameter.UpdPrcsParamLocal.';
      ROLLBACK;
  END UpdParamLocalPrcsInd;

END ScdParameter;
/
