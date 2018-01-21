CREATE OR REPLACE PACKAGE scdDetail IS
PROCEDURE procGetDetailData(iAcctOrg  IN NUMBER,
		  		   iCustNbr		IN	VARCHAR2,
				   iOrgDt		IN	VARCHAR2,
		  		   iIBC			IN	VARCHAR2,
		  		   iMfgOrgKeyId	IN	NUMBER,
				   iSoldToNbr	IN	VARCHAR2,
		  		   oCustName	OUT	VARCHAR2,
		  		   oIBCName		OUT	VARCHAR2,
		  		   oMfgOrgLvl	OUT	VARCHAR2,
		  		   oMfgOrgId	OUT	VARCHAR2,
		  		   oMfgOrgAbbrn	OUT	VARCHAR2,
		  		   oMfgPrntOrgLvl	OUT	VARCHAR2,
		  		   oMfgPrntOrgId	OUT	VARCHAR2,
		  		   oMfgPrntOrgAbbrn	OUT	VARCHAR2,
				   oSoldToName		OUT	VARCHAR2,				   
				   oErrorNbr	OUT	VARCHAR2,
				   oErrorDesc	OUT	VARCHAR2);

END scdDetail;
/
CREATE OR REPLACE PACKAGE BODY scdDetail IS
  PROCEDURE procGetDetailData(iAcctOrg         IN NUMBER,
                              iCustNbr         IN VARCHAR2,
                              iOrgDt           IN VARCHAR2,
                              iIBC             IN VARCHAR2,
                              iMfgOrgKeyId     IN NUMBER,
                              iSoldToNbr       IN VARCHAR2,
                              oCustName        OUT VARCHAR2,
                              oIBCName         OUT VARCHAR2,
                              oMfgOrgLvl       OUT VARCHAR2,
                              oMfgOrgId        OUT VARCHAR2,
                              oMfgOrgAbbrn     OUT VARCHAR2,
                              oMfgPrntOrgLvl   OUT VARCHAR2,
                              oMfgPrntOrgId    OUT VARCHAR2,
                              oMfgPrntOrgAbbrn OUT VARCHAR2,
                              oSoldToName      OUT VARCHAR2,
                              oErrorNbr        OUT VARCHAR2,
                              oErrorDesc       OUT VARCHAR2) IS
  
    lvvOrgId     VARCHAR2(4);
    lvvCustId    VARCHAR2(14);
    lvvErrorNbr  VARCHAR2(10);
    lvvErrorDesc VARCHAR2(200);
    lvvOrgDt     VARCHAR2(10);
    expApplError EXCEPTION;
  
  BEGIN
    oCustName        := NULL;
    oIBCName         := NULL;
    oMfgOrgLvl       := NULL;
    oMfgOrgId        := NULL;
    oMfgOrgAbbrn     := NULL;
    oMfgPrntOrgLvl   := NULL;
    oMfgPrntOrgId    := NULL;
    oMfgPrntOrgAbbrn := NULL;
    oSoldToName      := NULL;
    oErrorNbr        := '0';
    oErrorDesc       := NULL;
  
    -- get system date if date beginning of time  
    IF iOrgDt IN ('0001-01-01', '9999-99-99') THEN
      lvvOrgDt := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    ELSE
      lvvOrgDt := iOrgDt;
    END IF;
    scdCommon.RetrieveOrgId(iAcctOrg,
                            'H',
                            lvvOrgDt,
                            lvvOrgId,
                            lvvErrorNbr,
                            lvvErrorDesc);
    IF lvvErrorNbr <> '0' THEN
      RAISE expApplError;
    END IF;
    lvvCustId := lvvOrgId || iCustNbr;
    scdCommon.RetrieveCustName('S',
                               lvvCustId,
                               oCustName,
                               lvvErrorNbr,
                               lvvErrorDesc);
    IF lvvErrorNbr <> '0' THEN
      RAISE expApplError;
    END IF;
    lvvCustId := lvvOrgId || iSoldToNbr;
    scdCommon.RetrieveCustName('P',
                               lvvCustId,
                               oSoldToName,
                               lvvErrorNbr,
                               lvvErrorDesc);
    IF lvvErrorNbr <> '0' THEN
      RAISE expApplError;
    END IF;
    scdCommon.RetrieveIBCName(iIBC, oIBCName, lvvErrorNbr, lvvErrorDesc);
    IF lvvErrorNbr <> '0' THEN
      RAISE expApplError;
    END IF;
  
    SELECT a.ORGANIZATION_TYPE_DESC,
           a.ORGANIZATION_ID,
           a.ORGANIZATION_ABBREVIATED_NM,
           b.ORGANIZATION_TYPE_DESC,
           a.PARENT_ORGANIZATION_ID,
           b.ORGANIZATION_ABBREVIATED_NM
      INTO oMfgOrgLvl,
           oMfgOrgId,
           oMfgOrgAbbrn,
           oMfgPrntOrgLvl,
           oMfgPrntOrgId,
           oMfgPrntOrgAbbrn
      FROM ORGANIZATIONS_DMN a, ORGANIZATIONS_DMN b
     WHERE a.ORGANIZATION_KEY_ID = iMfgOrgKeyId
       AND a.EFFECTIVE_FROM_DT =
           (SELECT MAX(y.EFFECTIVE_FROM_DT)
              FROM ORGANIZATIONS_DMN y
             WHERE y.ORGANIZATION_KEY_ID = a.ORGANIZATION_KEY_ID
               AND y.ORGANIZATION_STATUS_CDE = '1')
       AND b.ORGANIZATION_ID = a.PARENT_ORGANIZATION_ID
       AND a.EFFECTIVE_FROM_DT BETWEEN b.EFFECTIVE_FROM_DT AND
           b.EFFECTIVE_TO_DT;
  EXCEPTION
    WHEN expApplError THEN
      oErrorNbr  := lvvErrorNbr;
      oErrorDesc := lvvErrorDesc;
    WHEN NO_DATA_FOUND THEN
      oErrorNbr  := '0';
      oErrorDesc := NULL;
    WHEN OTHERS THEN
      oErrorNbr  := TO_CHAR(SQLCODE);
      oErrorDesc := SQLERRM || ' in Package pkgDetail.procGetDetailData';
  END procGetDetailData;
END scdDetail;
/
