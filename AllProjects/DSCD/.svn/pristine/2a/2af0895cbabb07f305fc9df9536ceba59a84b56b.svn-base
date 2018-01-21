CREATE OR REPLACE PACKAGE scdAdhoc IS

  Procedure InsertStats(iGblId       IN VARCHAR2,
                        iServer      IN VARCHAR2,
                        iReferer     IN VARCHAR2,
                        iAgent       IN VARCHAR2,
                        iPage        IN VARCHAR2,
                        iIPAddr      IN VARCHAR2,
                        iHostNm      IN VARCHAR2,
                        iUserID      IN VARCHAR2,
                        iViewId      IN VARCHAR2,
                        iCategoryId  IN VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2);

End scdAdhoc;
/
CREATE OR REPLACE PACKAGE BODY scdAdhoc IS
  Procedure InsertStats(iGblId       IN VARCHAR2,
                        iServer      IN VARCHAR2,
                        iReferer     IN VARCHAR2,
                        iAgent       IN VARCHAR2,
                        iPage        IN VARCHAR2,
                        iIPAddr      IN VARCHAR2,
                        iHostNm      IN VARCHAR2,
                        iUserID      IN VARCHAR2,
                        iViewId      IN VARCHAR2,
                        iCategoryId  IN VARCHAR2,
                        oErrorNumber OUT VARCHAR2,
                        oErrorDesc   OUT VARCHAR2) IS
    ln_ViewID     SCD_APPLICATION_USAGES.SCORECARD_VIEW_ID%TYPE := NULL;
    ln_CategoryID SCD_APPLICATION_USAGES.SCORECARD_CATEGORY_ID%TYPE := NULL;
  BEGIN
  
    oErrorNumber := '0';
    oErrorDesc   := '';
  
    --IF iViewID <> '' AND Not iViewID IS NULL THEN
    ln_ViewID := TO_NUMBER(iViewID);
    --END IF;
    --IF iCategoryID <> '' AND Not iCategoryID IS NULL THEN
    ln_CategoryID := TO_NUMBER(iCategoryID);
    --END IF;
  
    INSERT INTO SCD_APPLICATION_USAGES
      (SCD_APPLICATION_USAGES_ID,
       ASOC_GLOBAL_ID,
       SERVER_NM,
       HTTP_BACK_URL_TXT,
       HTTP_USER_AGENT_TXT,
       URL_TXT,
       REMOTE_IP_ADDR,
       REMOTE_HOST_NM,
       SCORECARD_VIEW_ID,
       SCORECARD_CATEGORY_ID,
       DML_TS,
       DML_USER_ID)
    VALUES
      (SCD_APPLICATION_USAGES_ID_SEQ.NEXTVAL,
       iGblId,
       UPPER(iServer),
       UPPER(iReferer),
       UPPER(iAgent),
       UPPER(iPage),
       UPPER(iIPAddr),
       UPPER(iHostNm),
       ln_ViewID,
       ln_CategoryID,
       SYSDATE,
       UPPER(iUserId));
  
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      oErrorNumber := TO_CHAR(SQLCODE);
      oErrorDesc   := SQLERRM || ' (scdAdhoc.InsertStats)';
    
  END InsertStats;
END scdAdhoc;
/
