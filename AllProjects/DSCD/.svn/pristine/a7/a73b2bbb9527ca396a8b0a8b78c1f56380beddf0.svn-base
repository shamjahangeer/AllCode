CREATE OR REPLACE PACKAGE ScdAnnounce IS

  PROCEDURE RetrieveMsg(oTxtDate     OUT VARCHAR2,
                        oTxtMsg      OUT VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2);

  PROCEDURE InsertMsg(iAmpID       IN VARCHAR2,
                      iEffectiveDt IN VARCHAR2,
                      iActive      IN VARCHAR2,
                      iPlanned     IN VARCHAR2,
                      iTxtMsg      IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2);

  PROCEDURE RetrieveByDate(iEffectiveDt IN VARCHAR2,
                           oActive      OUT VARCHAR2,
                           oPlanned     OUT VARCHAR2,
                           oTxtMsg      OUT VARCHAR2,
                           oAmpID       OUT VARCHAR2,
                           oEnteredDt   OUT VARCHAR2,
                           oErrorNumber OUT VARCHAR2,
                           oErrorDesc   OUT VARCHAR2);

  PROCEDURE UpdateMsg(iAmpID       IN VARCHAR2,
                      iEffectiveDt IN VARCHAR2,
                      iActive      IN VARCHAR2,
                      iPlanned     IN VARCHAR2,
                      iTxtMsg      IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2);

  PROCEDURE DeleteMsg(iEffectiveDt IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2);

END ScdAnnounce;
/
CREATE OR REPLACE PACKAGE BODY ScdAnnounce IS

  PROCEDURE RetrieveMsg(oTxtDate     OUT VARCHAR2,
                        oTxtMsg      OUT VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2) IS
  
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT to_char(EFFECTIVE_DT, 'mm/dd/yyyy'), MESSAGE_TXT
      INTO oTxtDate, oTxtMsg
      FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT =
           (SELECT max(EFFECTIVE_DT)
              FROM SCD.SCORECARD_ANNOUNCEMENTS
             WHERE upper(ACTIVE_INACTIVE_IND) = 'Y'
               AND EFFECTIVE_DT <= TRUNC(SYSDATE))
       AND ROWNUM = 1
       AND upper(ACTIVE_INACTIVE_IND) = 'Y';
  
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      oTxtDate := to_char(sysdate, 'mm/dd/yyyy');
      oTxtMsg  := '';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || 'in scdAnnounce.RetrieveCurrent';
  END RetrieveMsg;

  PROCEDURE InsertMsg(iAmpID       IN VARCHAR2,
                      iEffectiveDt IN VARCHAR2,
                      iActive      IN VARCHAR2,
                      iPlanned     IN VARCHAR2,
                      iTxtMsg      IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2) IS
    ln_ExistingCount NUMBER(2) := 0;
    ALREADY_EXISTS EXCEPTION;
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT COUNT(*)
      INTO ln_ExistingCount
      FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD');
  
    IF ln_ExistingCount = 0 THEN
    
      INSERT INTO SCD.SCORECARD_ANNOUNCEMENTS
        (EFFECTIVE_DT,
         ACTIVE_INACTIVE_IND,
         PLANNED_IND,
         MESSAGE_TXT,
         DML_TS,
         DML_USER_ID)
      VALUES
        (TO_DATE(iEffectiveDt, 'YYYY-MM-DD'),
         UPPER(iActive),
         UPPER(iPlanned),
         iTxtMsg,
         SYSDATE,
         UPPER(iAmpID));
    ELSE
      RAISE ALREADY_EXISTS;
    END IF;
  
    COMMIT;
  
  EXCEPTION
    WHEN ALREADY_EXISTS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'Can Not Add New Announcement.  An Announcement Already Exists for ' ||
                      iEffectiveDt || '.  (scdAnnounce.InsertMsg)';
    WHEN OTHERS THEN
      ROLLBACK;
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdAnnounce.InsertMsg)';
  END InsertMsg;

  PROCEDURE RetrieveByDate(iEffectiveDt IN VARCHAR2,
                           oActive      OUT VARCHAR2,
                           oPlanned     OUT VARCHAR2,
                           oTxtMsg      OUT VARCHAR2,
                           oAmpID       OUT VARCHAR2,
                           oEnteredDt   OUT VARCHAR2,
                           oErrorNumber OUT VARCHAR2,
                           oErrorDesc   OUT VARCHAR2) IS
    ln_Count NUMBER(2);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT COUNT(DML_TS)
      INTO ln_Count
      FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD')
       AND DML_TS =
           (SELECT MAX(DML_TS)
              FROM SCD.SCORECARD_ANNOUNCEMENTS
             WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD')
               AND UPPER(ACTIVE_INACTIVE_IND) = 'Y')
       AND UPPER(ACTIVE_INACTIVE_IND) = 'Y';
  
    IF ln_Count > 1 THEN
      DELETE FROM SCD.SCORECARD_ANNOUNCEMENTS
       WHERE DML_TS <>
             (SELECT MAX(DML_TS)
                FROM SCD.SCORECARD_ANNOUNCEMENTS
               WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD')
                 AND UPPER(ACTIVE_INACTIVE_IND) <> 'Y')
         AND EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD');
    END IF;
  
    SELECT UPPER(ACTIVE_INACTIVE_IND),
           UPPER(PLANNED_IND),
           MESSAGE_TXT,
           TO_CHAR(DML_TS, 'YYYY-MM-DD'),
           DML_USER_ID
      INTO oActive, oPlanned, oTxtMsg, oEnteredDt, oAmpID
      FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD');
  
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'More Than One Announcement Existed For The Entered Date.  Could Not Determine Which Is Most Current.  (scdAnnounce.RetrieveMsg)';
    WHEN NO_DATA_FOUND THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := 'No Record Found (scdAnnounce.RetrieveMsg)';
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdAnnounce.RetrieveMsg)';
  END RetrieveByDate;

  PROCEDURE UpdateMsg(iAmpID       IN VARCHAR2,
                      iEffectiveDt IN VARCHAR2,
                      iActive      IN VARCHAR2,
                      iPlanned     IN VARCHAR2,
                      iTxtMsg      IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2) IS
    ln_Count NUMBER(2);
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    SELECT COUNT(DML_TS)
      INTO ln_Count
      FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD')
       AND DML_TS =
           (SELECT MAX(DML_TS)
              FROM SCD.SCORECARD_ANNOUNCEMENTS
             WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD'));
  
    IF ln_Count > 1 THEN
      DeleteMsg(iEffectiveDt, oErrorNumber, oErrorDesc);
      ln_Count := 0;
    END IF;
  
    IF ln_Count < 1 THEN
      InsertMsg(iAmpID,
                iEffectiveDt,
                iActive,
                iPlanned,
                iTxtMsg,
                oErrorNumber,
                oErrorDesc);
    ELSE
      UPDATE SCD.SCORECARD_ANNOUNCEMENTS
         SET ACTIVE_INACTIVE_IND = UPPER(iActive),
             PLANNED_IND         = UPPER(iPlanned),
             MESSAGE_TXT         = iTxtMsg,
             DML_TS              = SYSDATE,
             DML_USER_ID         = UPPER(iAmpID)
       WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD');
    END IF;
  
  END UpdateMsg;

  PROCEDURE DeleteMsg(iEffectiveDt IN VARCHAR2,
                      oErrorNumber OUT VARCHAR2,
                      oErrorDesc   OUT VARCHAR2) IS
  BEGIN
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    DELETE FROM SCD.SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT = TO_DATE(iEffectiveDt, 'YYYY-MM-DD');
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdAnnounce.DeleteMsg)';
  END DeleteMsg;

END ScdAnnounce;
/
