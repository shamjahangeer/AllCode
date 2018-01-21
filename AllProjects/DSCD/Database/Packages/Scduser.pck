CREATE OR REPLACE PACKAGE Scduser IS

PROCEDURE List_User_Roles
		(iLoginId			IN  VARCHAR2,
		oCommaDelimitedList	OUT VARCHAR2,
		oErrorNumber		OUT VARCHAR2,
		oErrorDesc			OUT VARCHAR2);

FUNCTION Is_Role(iLoginId     IN VARCHAR2,
                 iRoleName    IN VARCHAR2)RETURN BOOLEAN;

PROCEDURE UpdateProfile
		(iUId			IN  VARCHAR2,
		iAMPId			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE UpdatePreference
		(iGlobalID		IN  VARCHAR2,
		iNetworkID		IN 	VARCHAR2,
		iDaysEarly		IN 	VARCHAR2,
		iDaysLate		IN 	VARCHAR2,
		iSmryType		IN 	VARCHAR2,
		iOrgTypeID		IN 	VARCHAR2,
		iOrgID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE GetPreference
		(iGlobalID		IN  VARCHAR2,
		oDaysEarly		OUT VARCHAR2,
		oDaysLate		OUT VARCHAR2,
		oSmryType		OUT VARCHAR2,
		oOrgTypeID		OUT VARCHAR2,
		oOrgID			OUT VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE GetCorpDefault
		(oDaysEarly		OUT VARCHAR2,
		oDaysLate		OUT VARCHAR2,
		oSmryType		OUT VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);

PROCEDURE GetGlobalId
		(iNetworkId		IN  VARCHAR2,
		oGblId			OUT VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);
		
PROCEDURE UpdateOrgIDPref
		(iGlobalID		IN  VARCHAR2,
		iNetworkID		IN 	VARCHAR2,
		iOrgTypeID		IN 	VARCHAR2,
		iOrgID			IN 	VARCHAR2,
		oErrorNumber	OUT VARCHAR2,
		oErrorDesc		OUT VARCHAR2);		

END Scduser;
/
CREATE OR REPLACE PACKAGE BODY Scduser IS

  /******************************************************************************/
  /*                                                                            */
  /*package variables                                                           */
  /*                                                                            */
  /******************************************************************************/

  /******************************************************************************/
  /*                                                                            */
  /* PROCEDURE:   List_User_Roles                                               */
  /* DESC:        This procedure gets the all the roles for which a user is     */
  /*              authorized and returns them in a comma delimited list.        */
  /******************************************************************************/
  PROCEDURE List_User_Roles(iLoginId            IN VARCHAR2,
                            oCommaDelimitedList OUT VARCHAR2,
                            oErrorNumber        OUT VARCHAR2,
                            oErrorDesc          OUT VARCHAR2) IS
  
    counter       NUMBER(3);
    sql_role_name VARCHAR2(50);
    IsRoleEmpty   VARCHAR2(5);
  
    INFINITE_LOOP EXCEPTION;
  BEGIN
    oCommaDelimitedList := '';
    oErrorNumber        := '0';
    oErrorDesc          := '';
  
    userrole.RoleOpen(iLoginId);
    counter := 0;
  
    LOOP
      userrole.RoleFetch(sql_role_name, IsRoleEmpty);
    
      EXIT WHEN IsRoleEmpty = 'YES' OR counter = 100; --Use counter to avoid endless loops
    
      oCommaDelimitedList := oCommaDelimitedList || sql_role_name || ',';
      counter             := counter + 1;
    
    END LOOP;
  
    IF LENGTH(oCommaDelimitedList) > 1 THEN
      --Remove last comma
      oCommaDelimitedList := SUBSTR(oCommaDelimitedList,
                                    1,
                                    (LENGTH(oCommaDelimitedList) - 1));
    ELSE
      oCommaDelimitedList := '';
    END IF;
  
    IF counter = 100 THEN
      RAISE INFINITE_LOOP;
    END IF;
  
    userrole.RoleClose;
  EXCEPTION
    WHEN INFINITE_LOOP THEN
      userrole.RoleClose;
      oErrorNumber := '-1';
      oErrorDesc   := 'Infinite loop (scdUser.List_User_Roles)';
    WHEN OTHERS THEN
      userrole.RoleClose;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || '(scdUser.List_User_Roles)';
    
  END List_User_Roles;

  FUNCTION Is_Role(iLoginId IN VARCHAR2, iRoleName IN VARCHAR2)
    RETURN BOOLEAN IS
    counter       NUMBER(3);
    sql_role_name VARCHAR2(50);
    IsRoleEmpty   VARCHAR2(5);
    IsRole        BOOLEAN;
    INFINITE_LOOP EXCEPTION;
  BEGIN
    IsRole  := FALSE;
    counter := 0;
    IF iLoginId IS NOT NULL AND iRoleName IS NOT NULL THEN
      --SEE IF USER HAS SPECIFIED ROLE
      userrole.RoleOpen(iLoginId);
      LOOP
        userrole.RoleFetch(sql_role_name, IsRoleEmpty);
        EXIT WHEN IsRoleEmpty = 'YES' OR IsRole OR counter = 100; --Use counter to avoid endless loops
        IF sql_role_name = iRoleName THEN
          IsRole := TRUE;
        END IF;
        counter := counter + 1;
      END LOOP;
      userrole.RoleClose;
    ELSIF iRoleName IS NULL THEN
      -- SEE IF USER HAS ANY ROLE AT ALL.  IF SO, RETURN TRUE
      userrole.RoleOpen(iLoginId);
      LOOP
        userrole.RoleFetch(sql_role_name, IsRoleEmpty);
        EXIT WHEN IsRoleEmpty = 'YES' OR counter > 0; --Use counter to avoid endless loops
        counter := counter + 1;
      END LOOP;
      userrole.RoleClose;
      IF counter > 0 THEN
        IsRole := TRUE;
      END IF;
    END IF;
    RETURN IsRole;
  EXCEPTION
    WHEN INFINITE_LOOP THEN
      userrole.RoleClose;
      RETURN FALSE;
    WHEN OTHERS THEN
      userrole.RoleClose;
      RETURN FALSE;
    
  END Is_Role;

  PROCEDURE UpdateProfile(iUId         IN VARCHAR2,
                          iAMPId       IN VARCHAR2,
                          oErrorNumber OUT VARCHAR2,
                          oErrorDesc   OUT VARCHAR2) IS
    lUId SCORECARD_USER_PROFILES.ASOC_GLOBAL_ID%TYPE := TO_NUMBER(iUId);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    UPDATE SCORECARD_USER_PROFILES
       SET LAST_SYSTEM_ACCESS_DT = SYSDATE,
           DML_TS                = SYSDATE,
           DML_USER_ID           = iAMPId
     WHERE ASOC_GLOBAL_ID = lUId
       AND NETWORK_USER_ID = iAMPId;
  
    IF SQL%NOTFOUND THEN
      INSERT INTO SCORECARD_USER_PROFILES
        (SCD_USER_PROFILE_ID,
         ASOC_GLOBAL_ID,
         NETWORK_USER_ID,
         LAST_SYSTEM_ACCESS_DT,
         DML_TS,
         DML_USER_ID)
      VALUES
        (SCD_USER_PROFILE_ID_SEQ.NEXTVAL,
         lUId,
         iAMPId,
         SYSDATE,
         SYSDATE,
         iAMPId);
    END IF;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdUser.UpdateProfile)';
      ROLLBACK;
  END UpdateProfile;

  PROCEDURE UpdatePreference(iGlobalID    IN VARCHAR2,
                             iNetworkID   IN VARCHAR2,
                             iDaysEarly   IN VARCHAR2,
                             iDaysLate    IN VARCHAR2,
                             iSmryType    IN VARCHAR2,
                             iOrgTypeID   IN VARCHAR2,
                             iOrgID       IN VARCHAR2,
                             oErrorNumber OUT VARCHAR2,
                             oErrorDesc   OUT VARCHAR2) IS
    lGlobalID SCORECARD_USER_PREFERENCES.ASOC_GLOBAL_ID%TYPE := TO_NUMBER(iGlobalID);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    UPDATE SCORECARD_USER_PREFERENCES
       SET DML_TS                    = SYSDATE,
           DML_USER_ID               = iNetworkID,
           PFR_NBR_WINDOW_DAYS_EARLY = TO_NUMBER(iDaysEarly),
           PFR_NBR_WINDOW_DAYS_LATE  = TO_NUMBER(iDaysLate),
           PFR_DELIVERY_SMRY_TYPE    = iSmryType,
           PFR_ORGANIZATION_TYPE_ID  = TO_NUMBER(iOrgTypeID),
           PFR_ORGANIZATION_ID       = iOrgID
     WHERE SCD_USER_PREFERENCES_ID =
           (SELECT MAX(SCD_USER_PREFERENCES_ID)
              FROM SCORECARD_USER_PREFERENCES
             WHERE ASOC_GLOBAL_ID = lGlobalID);
  
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        INSERT INTO SCORECARD_USER_PREFERENCES
          (SCD_USER_PREFERENCES_ID,
           USER_PREFERENCES_SHORT_DESC,
           ASOC_GLOBAL_ID,
           DML_TS,
           DML_USER_ID,
           PFR_NBR_WINDOW_DAYS_EARLY,
           PFR_NBR_WINDOW_DAYS_LATE,
           PFR_DELIVERY_SMRY_TYPE,
           PFR_ORGANIZATION_TYPE_ID,
           PFR_ORGANIZATION_ID)
        VALUES
          (SCD_USER_PREFERENCES_ID_SEQ.NEXTVAL,
           'LAST',
           lGlobalID,
           SYSDATE,
           iNetworkID,
           TO_NUMBER(iDaysEarly),
           TO_NUMBER(iDaysLate),
           iSmryType,
           TO_NUMBER(iOrgTypeID),
           iOrgID);
      EXCEPTION
        WHEN OTHERS THEN
          oErrorNumber := TO_CHAR(SQLCODE);
          oErrorDesc   := SQLERRM || ' (scdUser.UpdatePreference)';
          ROLLBACK;
      END;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdUser.UpdatePreference)';
      ROLLBACK;
  END UpdatePreference;

  PROCEDURE GetPreference(iGlobalID    IN VARCHAR2,
                          oDaysEarly   OUT VARCHAR2,
                          oDaysLate    OUT VARCHAR2,
                          oSmryType    OUT VARCHAR2,
                          oOrgTypeID   OUT VARCHAR2,
                          oOrgID       OUT VARCHAR2,
                          oErrorNumber OUT VARCHAR2,
                          oErrorDesc   OUT VARCHAR2) IS
    lGlobalID SCORECARD_USER_PREFERENCES.ASOC_GLOBAL_ID%TYPE := TO_NUMBER(iGlobalID);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT PFR_NBR_WINDOW_DAYS_EARLY,
           PFR_NBR_WINDOW_DAYS_LATE,
           PFR_DELIVERY_SMRY_TYPE,
           PFR_ORGANIZATION_TYPE_ID,
           PFR_ORGANIZATION_ID
      INTO oDaysEarly, oDaysLate, oSmryType, oOrgTypeID, oOrgID
      FROM SCORECARD_USER_PREFERENCES
     WHERE SCD_USER_PREFERENCES_ID =
           (SELECT MAX(SCD_USER_PREFERENCES_ID)
              FROM SCORECARD_USER_PREFERENCES
             WHERE ASOC_GLOBAL_ID = lGlobalID);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oDaysEarly := '';
      oDaysLate  := '';
      oSmryType  := '';
      oOrgTypeID := '';
      oOrgID     := '';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdUser.GetPreference)';
  END GetPreference;

  PROCEDURE GetCorpDefault(oDaysEarly   OUT VARCHAR2,
                           oDaysLate    OUT VARCHAR2,
                           oSmryType    OUT VARCHAR2,
                           oErrorNumber OUT VARCHAR2,
                           oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
    oDaysEarly   := '';
    oDaysLate    := '';
    oSmryType    := '';
  
    SELECT PARAMETER_FIELD
      INTO oDaysEarly
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'DED358';
  
    SELECT PARAMETER_FIELD
      INTO oDaysLate
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'DED359';
  
    SELECT PARAMETER_FIELD
      INTO oSmryType
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'DED231';
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := '-1';
      oErrorDesc   := 'Corporate default(s) is not found. (scdUser.GetCorpDefault)';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdUser.GetCorpDefault)';
  END GetCorpDefault;
  /**********************************************************************************************************
  ***   This procedure is used to get a gbl id from the user profiles table if the gbl id does not
  ***   exist in CSS.  If not in User profiles we create a negative number.
  **********************************************************************************************************/
  PROCEDURE GetGlobalId(iNetworkId   IN VARCHAR2,
                        oGblId       OUT VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2)
  
   IS
    lnGblId NUMBER;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := NULL;
  
    BEGIN
      SELECT ASOC_GLOBAL_ID
        INTO oGblId
        FROM SCORECARD_USER_PROFILES
       WHERE NETWORK_USER_ID = UPPER(iNetworkId);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        SELECT SCORECARD_GLOBAL_ID_SEQ.NEXTVAL INTO lnGblId FROM DUAL;
        lnGblId := lnGblId * (-1);
        oGblId  := TO_CHAR(lnGblId);
      WHEN TOO_MANY_ROWS THEN
        SELECT TO_CHAR(MAX(ASOC_GLOBAL_ID))
          INTO oGblId
          FROM SCORECARD_USER_PROFILES
         WHERE NETWORK_USER_ID = UPPER(iNetworkId);
      WHEN OTHERS THEN
        SELECT SCORECARD_GLOBAL_ID_SEQ.NEXTVAL INTO lnGblId FROM DUAL;
        lnGblId := lnGblId * (-1);
        oGblId  := TO_CHAR(lnGblId);
    END;
  
  EXCEPTION
    WHEN OTHERS THEN
      SELECT SCORECARD_GLOBAL_ID_SEQ.NEXTVAL INTO lnGblId FROM DUAL;
      lnGblId := lnGblId * (-1);
      oGblId  := TO_CHAR(lnGblId);
  END GetGlobalId;

  PROCEDURE UpdateOrgIDPref(iGlobalID    IN VARCHAR2,
                            iNetworkID   IN VARCHAR2,
                            iOrgTypeID   IN VARCHAR2,
                            iOrgID       IN VARCHAR2,
                            oErrorNumber OUT VARCHAR2,
                            oErrorDesc   OUT VARCHAR2) IS
    lGlobalID SCORECARD_USER_PREFERENCES.ASOC_GLOBAL_ID%TYPE := TO_NUMBER(iGlobalID);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    UPDATE SCORECARD_USER_PREFERENCES
       SET DML_TS               = SYSDATE,
           DML_USER_ID          = iNetworkID,
           ORGANIZATION_TYPE_ID = TO_NUMBER(iOrgTypeID),
           ORGANIZATION_ID      = iOrgID
     WHERE SCD_USER_PREFERENCES_ID =
           (SELECT MAX(sup.SCD_USER_PREFERENCES_ID)
              FROM SCORECARD_USER_PREFERENCES sup,
                   (SELECT MAX(DML_TS) AS Latest
                      FROM SCORECARD_USER_PREFERENCES
                     WHERE ASOC_GLOBAL_ID = lGlobalID) Dates
             WHERE sup.ASOC_GLOBAL_ID = lGlobalID
               AND sup.DML_TS = Dates.Latest);
  
    COMMIT;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        INSERT INTO SCORECARD_USER_PREFERENCES
          (SCD_USER_PREFERENCES_ID,
           USER_PREFERENCES_SHORT_DESC,
           ASOC_GLOBAL_ID,
           DML_TS,
           DML_USER_ID,
           ORGANIZATION_TYPE_ID,
           ORGANIZATION_ID)
        VALUES
          (SCD_USER_PREFERENCES_ID_SEQ.NEXTVAL,
           'LAST',
           lGlobalID,
           SYSDATE,
           iNetworkID,
           TO_NUMBER(iOrgTypeID),
           iOrgID);
        COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          oErrorNumber := TO_CHAR(SQLCODE);
          oErrorDesc   := SQLERRM || ' (scdUser.UpdOrgIDPref)';
          ROLLBACK;
      END;
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdUser.UpdOrgIDPref)';
      ROLLBACK;
  END UpdateOrgIDPref;

END Scduser;
/
