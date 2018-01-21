CREATE OR REPLACE PACKAGE Scdpurge AS
/*****************************************************************************/
/* NAME:    scdPurge                                                         */
/* PURPOSE: Contains procedures for purging data from the following tables:  */
/*                 1. SCORECARD_USER_PROFILES                                */
/*   	           2. SCORECARD_USER_PREFERENCES                             */
/*                 3. SCORECARD_ANNOUNCEMENTS                                */
/*                 4. SCD_APPLICATION_USAGES                                 */
/*                 5. LOAD_MSG                                               */
/*                 6. SCORECARD_PROCESS_LOG                                  */
/*                 7. SCORECARD_HOLD_ORDERS                                  */
/*                 8. ORDER_ITEM_SHIPMENTS & Summaries                       */
/*                 9. SCD_DELIVERY_PERFORMANCE_SMRY                     */
/*                                                                           */
/*                                                                           */
/*	Date 		 Author    	 Description		 	 		                 */
/*  ---------    ---------   -------------                                   */
/*  June 2001    S.Jupko     Delivery Scorecard Re-write                     */
/*  Mar 2004	  A.Orbeta	 Add code to purge Op Ex Smry.				 */
--  May 2008                Add code to purge data security.   
--  Aug 2010                Add logic to make sure shipment records to be purge 
--                            are already copied into history. Also comment
--                            out the purge on OIS security.
--  Dec 2010                Purge temp excluded shipments table.
/*****************************************************************************/

PROCEDURE procUserProfiles (pivUserId    IN VARCHAR2,
                            ponErrorNbr  OUT NUMBER,
							ponErrorDesc OUT VARCHAR2);


PROCEDURE procUserPreferences (pivUserId    IN VARCHAR2,
                               ponErrorNbr  OUT NUMBER,
							   ponErrorDesc OUT VARCHAR2);

PROCEDURE procSCDAnnouncements (pivUserId    IN VARCHAR2,
                                ponErrorNbr  OUT NUMBER,
							    ponErrorDesc OUT VARCHAR2);

PROCEDURE procSCDApplUsages (pivUserId    IN VARCHAR2,
                             ponErrorNbr  OUT NUMBER,
							 ponErrorDesc OUT VARCHAR2);

PROCEDURE procLoadMsg (pivUserId    IN VARCHAR2,
                       ponErrorNbr  OUT NUMBER,
					   ponErrorDesc OUT VARCHAR2);

PROCEDURE procProcessLog (pivUserId    IN VARCHAR2,
                          ponErrorNbr  OUT NUMBER,
					      ponErrorDesc OUT VARCHAR2);

PROCEDURE procHoldOrders (pivUserId    IN VARCHAR2,
                          ponErrorNbr  OUT NUMBER,
					      ponErrorDesc OUT VARCHAR2);

PROCEDURE procShipments (pivUserId    IN VARCHAR2,
                         ponErrorNbr  OUT NUMBER,
					     ponErrorDesc OUT VARCHAR2);
						 
PROCEDURE procOpxWeeklySmry (pivUserId    IN VARCHAR2,
                            ponErrorNbr  OUT NUMBER,
							ponErrorDesc OUT VARCHAR2);						 

PROCEDURE procExcludedShips;

END Scdpurge;
/
CREATE OR REPLACE PACKAGE BODY Scdpurge AS

  gvnRetainMths  NUMBER;
  gvdPurgeDt     DATE;
  gvnRowsDeleted NUMBER := 0;
  gvnLogLine     NUMBER := 0;
  gvnLogSeq      NUMBER;

  /*****************************************************************************/
  /* Calculate Purge Date using default data retain months                     */
  /*****************************************************************************/
  PROCEDURE procCalcPurgeDt IS
  
  BEGIN
  
    SELECT PARAMETER_FIELD
      INTO gvnRetainMths
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'SCD02MTHS';
  
    gvdPurgeDt := LAST_DAY(ADD_MONTHS(SYSDATE, gvnRetainMths * -1));
  END procCalcPurgeDt;

  /*****************************************************************************/
  /* NAME:    procUserProfiles                                                 */
  /* PURPOSE: 1) This procedure is used to maintain user profiles.             */
  /*             The procedure will delete the inactive users that are no      */
  /*           longer with the comapany or older than the calculated purge dt*/
  /*****************************************************************************/
  PROCEDURE procUserProfiles(pivUserId    IN VARCHAR2,
                             ponErrorNbr  OUT NUMBER,
                             ponErrorDesc OUT VARCHAR2) IS
  
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    SELECT SCD_PROCESS_LOG_SEQ.NEXTVAL INTO gvnLogSeq FROM DUAL;
  
    DELETE FROM SCORECARD_USER_PROFILES
     WHERE ASOC_GLOBAL_ID IN
           (SELECT ASOC_GLOBAL_ID
              FROM GED_PUBLIC_VIEW
             WHERE ASOC_DELETE_DT IS NOT NULL);
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procUserProfiles',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_USER_PROFILES Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    procCalcPurgeDt;
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM SCORECARD_USER_PROFILES
     WHERE LAST_SYSTEM_ACCESS_DT <= gvdPurgeDt;
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procUserProfiles',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_USER_PROFILES Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procUserProfiles;

  /*****************************************************************************/
  /* NAME:    procUserPreferences                                              */
  /* PURPOSE: 1) This procedure is used to maintain user preferences.          */
  /*             The procedure will delete the inactive users that are no      */
  /*           longer with the comapany or older than the calculated purge dt*/
  /*****************************************************************************/

  PROCEDURE procUserPreferences(pivUserId    IN VARCHAR2,
                                ponErrorNbr  OUT NUMBER,
                                ponErrorDesc OUT VARCHAR2) IS
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    SELECT SCD_PROCESS_LOG_SEQ.NEXTVAL INTO gvnLogSeq FROM DUAL;
  
    DELETE FROM SCORECARD_USER_PREFERENCES
     WHERE ASOC_GLOBAL_ID IN
           (SELECT ASOC_GLOBAL_ID
              FROM GED_PUBLIC_VIEW
             WHERE ASOC_DELETE_DT IS NOT NULL);
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procUserPreferences',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_USER_PREFERENCES Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    procCalcPurgeDt;
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM SCORECARD_USER_PREFERENCES WHERE DML_TS <= gvdPurgeDt;
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procUserPreferences',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_USER_PREFERENCES Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procUserPreferences;

  /*****************************************************************************/
  /* NAME:    procSCDAnnouncements                                             */
  /* PURPOSE: 1) This procedure is used to maintain Scorecard Announcements.   */
  /*             The procedure will delete announcements that are older than   */
  /*             the calculated purge date                                     */
  /*****************************************************************************/
  PROCEDURE procSCDAnnouncements(pivUserId    IN VARCHAR2,
                                 ponErrorNbr  OUT NUMBER,
                                 ponErrorDesc OUT VARCHAR2) IS
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    procCalcPurgeDt;
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM SCORECARD_ANNOUNCEMENTS
     WHERE EFFECTIVE_DT <= gvdPurgeDt
       AND ACTIVE_INACTIVE_IND <> 'Y';
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'procSCDAnnouncements',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_ANNOUNCEMENTS Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procSCDAnnouncements;

  /*****************************************************************************/
  /* NAME:    procSCDApplUsages                                                */
  /* PURPOSE: 1) This procedure is used to maintain SCD Application Usages.    */
  /*             The procedure will delete usages that are older than          */
  /*             the calculated purge date                                     */
  /*****************************************************************************/
  PROCEDURE procSCDApplUsages(pivUserId    IN VARCHAR2,
                              ponErrorNbr  OUT NUMBER,
                              ponErrorDesc OUT VARCHAR2) IS
  
    lvnRetainDays NUMBER;
  
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    SELECT PARAMETER_FIELD
      INTO lvnRetainDays
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'USAGEDAYS';
  
    gvdPurgeDt := TRUNC(SYSDATE - lvnRetainDays);
    DBMS_OUTPUT.PUT_LINE('RETAIN DAYS: ' || lvnRetainDays);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM SCD_APPLICATION_USAGES WHERE DML_TS <= gvdPurgeDt;
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'procSCDAppleUsages',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCD_APPLICATION_USAGES Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procSCDApplUsages;

  /*****************************************************************************/
  /* NAME:    procLoadMsg                                                      */
  /* PURPOSE: 1) This procedure is used to maintain Load Message.              */
  /*             The procedure will delete load messages that are older than   */
  /*             the calculated purge date                                     */
  /*****************************************************************************/
  PROCEDURE procLoadMsg(pivUserId    IN VARCHAR2,
                        ponErrorNbr  OUT NUMBER,
                        ponErrorDesc OUT VARCHAR2) IS
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    SELECT PARAMETER_FIELD
      INTO gvnRetainMths
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD07MTHS';
  
    gvdPurgeDt := LAST_DAY(ADD_MONTHS(SYSDATE, gvnRetainMths * -1));
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM LOAD_MSG WHERE TRUNC(DML_TMSTMP) <= gvdPurgeDt;
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'procLoadMsg',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'LOAD_MSG Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procLoadMsg;

  /*****************************************************************************/
  /* NAME:    procProcessLog                                                   */
  /* PURPOSE: 1) This procedure is used to maintain the Process Log.           */
  /*             The procedure will delete process logs that are older than    */
  /*             the calculated purge date                                     */
  /*****************************************************************************/
  PROCEDURE procProcessLog(pivUserId    IN VARCHAR2,
                           ponErrorNbr  OUT NUMBER,
                           ponErrorDesc OUT VARCHAR2) IS
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    SELECT PARAMETER_FIELD
      INTO gvnRetainMths
      FROM DELIVERY_PARAMETER_LOCAL
     WHERE PARAMETER_ID = 'SCD07MTHS';
  
    gvdPurgeDt := LAST_DAY(ADD_MONTHS(SYSDATE, gvnRetainMths * -1));
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    DELETE FROM SCORECARD_PROCESS_LOG
     WHERE TRUNC(DML_TMSTMP) <= gvdPurgeDt;
  
    gvnRowsDeleted := SQL%ROWCOUNT;
    gvnLogLine     := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'procProcessLog',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_PROCESS_LOG Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procProcessLog;

  /*****************************************************************************/
  /* NAME:    procHoldOrders                                                   */
  /* PURPOSE: 1) This procedure is used to maintain the Scorecard Hold Orders. */
  /*             The procedure will delete Hold Orders rows that do not exist  */
  /*             on the Order Item Open table                                  */
  /*****************************************************************************/
  PROCEDURE procHoldOrders(pivUserId    IN VARCHAR2,
                           ponErrorNbr  OUT NUMBER,
                           ponErrorDesc OUT VARCHAR2) IS
    CURSOR c_sho IS
      SELECT sho.ROWID,
             org.organization_key_id ORGANIZATION_KEY_ID,
             sho.ORDER_NBR,
             sho.ORDER_ITEM_NBR
        FROM SCORECARD_HOLD_ORDERS sho, ORGANIZATIONS_DMN org
       WHERE sho.REPORTING_ORGANIZATION_ID = org.organization_id
         AND org.RECORD_STATUS_CDE = 'C';
    deleteCount INTEGER := 0;
    existCount  INTEGER := 0;
  BEGIN
    ponErrorNbr    := 0;
    ponErrorDesc   := NULL;
    gvnRowsDeleted := 0;
  
    FOR v_cursor IN c_sho LOOP
      SELECT COUNT(*)
        INTO existCount
        FROM ORDER_ITEM_OPEN
       WHERE ORGANIZATION_KEY_ID = v_cursor.ORGANIZATION_KEY_ID
         AND AMP_ORDER_NBR = v_cursor.ORDER_NBR
         AND ORDER_ITEM_NBR = v_cursor.ORDER_ITEM_NBR
         AND ROWNUM <= 1;
    
      IF existCount > 0 THEN
        DELETE FROM SCORECARD_HOLD_ORDERS WHERE ROWID = v_cursor.ROWID;
        existCount := 0;
      
        gvnRowsDeleted := gvnRowsDeleted + 1;
        IF MOD(gvnRowsDeleted, 1000) = 0 THEN
          COMMIT;
        END IF;
      END IF;
    END LOOP;
    gvnLogLine := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'procHoldOrders',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_HOLD_ORDERS Deleted:' || gvnRowsDeleted);
    COMMIT;
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procHoldOrders;

  /*****************************************************************************/
  /* NAME:    procShipments                                                    */
  /* PURPOSE: 1) This procedure is used to maintain the details and summaries. */
  /*             The procedure will delete details and summaries that are older*/
  /*             than the calculated purge date                                */
  /*****************************************************************************/
  PROCEDURE procShipments(pivUserId    IN VARCHAR2,
                          ponErrorNbr  OUT NUMBER,
                          ponErrorDesc OUT VARCHAR2) IS
    CURSOR cur_OIS(cvdPurgeDt DATE) IS
      SELECT /*+ INDEX(order_item_shipment oish_pf2) */
       ROWID,
       amp_order_nbr,
       order_item_nbr,
       shipment_id,
       organization_key_id
        FROM ORDER_ITEM_SHIPMENT
       WHERE AMP_SHIPPED_DATE <= cvdPurgeDt;
  
    CURSOR cur_BldgSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM BUILDING_LOCATION_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_CntrlrSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM CNTRLR_PROD_LINE_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_CustSmry1(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM CUSTOMER_ACCOUNT_SMRY_T1
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_CustSmry2(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM CUSTOMER_ACCOUNT_SMRY_T2
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_CustSmry3(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM CUSTOMER_ACCOUNT_SMRY_T3
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_IndSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM INDUSTRY_CODE_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_MfgSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM MFG_CAMPUS_BLDG_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_PCSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM PROFIT_CENTER_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_OrgSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM SCORECARD_ORG_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    CURSOR cur_TeamSmry(cvdPurgeDt DATE) IS
      SELECT ROWID
        FROM TEAM_ORG_SMRY
       WHERE AMP_SHIPPED_MONTH <= cvdPurgeDt;
  
    new_exception EXCEPTION;
    v_copy_hist_stat VARCHAR2(20);
    v_err_msg        VARCHAR2(200);
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    -- make sure the copy to history process was successfully completed
    v_copy_hist_stat := scdCommonBatch.GetParamValueLocal('CPYHISTSTAT');
    IF SUBSTR(v_copy_hist_stat, 1, 1) != 'C' THEN
      -- previous copy to hist process is not completed yet
      v_err_msg := 'User DefErr [Purge process failed since copy process for Copy Hist Dt=' ||
                   SUBSTR(v_copy_hist_stat, 3) ||
                   ' has not successfully completed yet - pls verify data]';
      RAISE new_exception;
    END IF;
  
    SELECT SCD_PROCESS_LOG_SEQ.NEXTVAL INTO gvnLogSeq FROM DUAL;
  
    procCalcPurgeDt;
    DBMS_OUTPUT.PUT_LINE('RETAIN MTHS: ' || gvnRetainMths);
    DBMS_OUTPUT.PUT_LINE('PURGE DATE: ' || gvdPurgeDt);
  
    -- make sure OIS recs to be purged have been copied to history
    IF TRUNC(gvdPurgeDt) > TO_DATE(SUBSTR(v_copy_hist_stat, 3)) THEN
      v_err_msg := 'User DefErr [Purge process can not proceed since the OIS recs to be purge ' ||
                   'may not be in history yet (Purge Dt=' ||
                   TO_CHAR(gvdPurgeDt, 'DD-MON-YYYY') || ' > Copy Hist Dt=' ||
                   SUBSTR(v_copy_hist_stat, 3) || ') - pls verify data]';
      RAISE new_exception;
    END IF;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_OIS(gvdPurgeDt) LOOP
      DELETE FROM ORDER_ITEM_SHIPMENT WHERE ROWID = v_cursor.ROWID;
    
      /*
      commented since the same records will now be in history table
      -- delete corresponding rec in data security table
      BEGIN
        DELETE FROM order_item_ship_data_security
        WHERE  amp_order_nbr       = v_cursor.amp_order_nbr
        AND    order_item_nbr      = v_cursor.order_item_nbr
        AND    shipment_id         = v_cursor.shipment_id
        AND    organization_key_id = v_cursor.organization_key_id
        ;
      
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          NULL; -- nothing to delete
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20101, SQLERRM || ' in delete data security');
      END;*/
    
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'ORDER_ITEM_SHIPMENT Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('ORDER_ITEM_SHIPMENT Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_BldgSmry(gvdPurgeDt) LOOP
      DELETE FROM BUILDING_LOCATION_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'BUILDING_LOCATION_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('BUILDING_LOCATION_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_CntrlrSmry(gvdPurgeDt) LOOP
      DELETE FROM CNTRLR_PROD_LINE_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'CNTRLR_PROD_LINE_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('CNTRLR_PROD_LINE_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_CustSmry1(gvdPurgeDt) LOOP
      DELETE FROM CUSTOMER_ACCOUNT_SMRY_T1 WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'CUSTOMER_ACCOUNT_SMRY_T1 Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('CUSTOMER_ACCOUNT_SMRY_T1 Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_CustSmry2(gvdPurgeDt) LOOP
      DELETE FROM CUSTOMER_ACCOUNT_SMRY_T2 WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'CUSTOMER_ACCOUNT_SMRY_T2 Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('CUSTOMER_ACCOUNT_SMRY_T2 Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_CustSmry3(gvdPurgeDt) LOOP
      DELETE FROM CUSTOMER_ACCOUNT_SMRY_T3 WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'CUSTOMER_ACCOUNT_SMRY_T3 Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('CUSTOMER_ACCOUNT_SMRY_T3 Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_IndSmry(gvdPurgeDt) LOOP
      DELETE FROM INDUSTRY_CODE_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'INDUSTRY_CODE_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('INDUSTRY_CODE_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_MfgSmry(gvdPurgeDt) LOOP
      DELETE FROM MFG_CAMPUS_BLDG_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'MFG_CAMPUS_BLDG_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('MFG_CAMPUS_BLDG_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_PCSmry(gvdPurgeDt) LOOP
      DELETE FROM PROFIT_CENTER_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'PROFIT_CENTER_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('PROFIT_CENTER_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_OrgSmry(gvdPurgeDt) LOOP
      DELETE FROM SCORECARD_ORG_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCORECARD_ORG_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('SCORECARD_ORG_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  
    gvnRowsDeleted := 0;
    FOR v_cursor IN cur_TeamSmry(gvdPurgeDt) LOOP
      DELETE FROM TEAM_ORG_SMRY WHERE ROWID = v_cursor.ROWID;
      gvnRowsDeleted := gvnRowsDeleted + 1;
      IF MOD(gvnRowsDeleted, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP;
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procShipments',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'TEAM_ORG_SMRY Deleted:' || gvnRowsDeleted);
    --DBMS_OUTPUT.PUT_LINE('TEAM_ORG_SMRY Deleted:' || gvnRowsDeleted);
    COMMIT;
  EXCEPTION
    WHEN new_exception THEN
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101, v_err_msg);
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200);
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procShipments;

  /*****************************************************************************/
  /* NAME:    procOpxWeeklySmry                                                 */
  /* PURPOSE: 1) This procedure is used to maintain weekly SMRY for Op Ex. */
  /*             The procedure will delete records that are older that the calculated   */
  /*           purge period which is the combination of fiscal year & fiscal quarter */
  /*****************************************************************************/
  PROCEDURE procOpxWeeklySmry(pivUserId    IN VARCHAR2,
                              ponErrorNbr  OUT NUMBER,
                              ponErrorDesc OUT VARCHAR2) IS
    v_purge_period VARCHAR2(9);
    v_rtn_param    DELIVERY_PARAMETER.PARAMETER_FIELD%TYPE;
    v_section      VARCHAR2(50);
  BEGIN
    ponErrorNbr  := 0;
    ponErrorDesc := NULL;
  
    -- get retention quarters param
    v_section := 'Get Purge Parameter';
    SELECT PARAMETER_FIELD
      INTO v_rtn_param
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'SCD02QTRS';
  
    -- caculate retention fiscal date using date_dmn table
    v_section := 'Calculate Purge Date';
    SELECT TYCO_ADD_MONTHS(SYSDATE, TO_NUMBER(v_rtn_param) * 3 * -1)
      INTO gvdPurgeDt
      FROM dual;
  
    -- get the year/quarter period to delete
    v_section := 'Get Fiscal Year & Quarter';
    SELECT TO_NUMBER(TO_CHAR(NVL(tyco_year_id, 0), 'FM0009') ||
                     TO_CHAR(NVL(tyco_quarter_id, 0), 'FM9'))
      INTO v_purge_period
      FROM date_dmn
     WHERE calendar_dt = gvdPurgeDt;
  
    -- purge old data  
    DELETE SCD_DELIVERY_PERFORMANCE_SMRY
     WHERE TO_NUMBER(TO_CHAR(NVL(fiscal_year_id, 9999), 'FM0009') ||
                     TO_CHAR(NVL(fiscal_quarter_id, 9), 'FM9')) <
           v_purge_period;
    gvnRowsDeleted := SQL%ROWCOUNT;
  
    v_section := 'Ge next Proces Log Seq';
    SELECT SCD_PROCESS_LOG_SEQ.NEXTVAL INTO gvnLogSeq FROM DUAL;
  
    -- create log record
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procOpxWeeklySmry',
       pivUserId,
       SYSDATE,
       gvnLogLine,
       'SCD_DELIVERY_PERFORMANCE_SMRY Deleted:' || gvnRowsDeleted);
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('RETAIN QUARTERS: ' || v_rtn_param);
    DBMS_OUTPUT.PUT_LINE('PURGE PERIOD: <' || v_purge_period);
  
  EXCEPTION
    WHEN OTHERS THEN
      ponErrorNbr  := SQLCODE;
      ponErrorDesc := SUBSTR(SQLERRM, 1, 200) || ' in ' || v_section;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                           SUBSTR(SQLERRM, 1, 200));
  END procOpxWeeklySmry;

  /****************************************************************************************/
  /* NAME:    procExcludedShips                                                           */
  /* PURPOSE: The procedure will delete records that are older that the calculated  DML_TS */
  /*           purge period based on DML_TS date                                          */
  /****************************************************************************************/
  PROCEDURE procExcludedShips IS
    v_purge_period VARCHAR2(9);
    v_rtn_param    DELIVERY_PARAMETER.PARAMETER_FIELD%TYPE;
    v_section      VARCHAR2(100);
    v_err_msg      VARCHAR2(200);
  BEGIN
    -- get retention quarters param
    v_section   := 'Get Purge Parameter - SCDEXSHIPSRTN';
    v_rtn_param := Scdcommonbatch.GetParamValueLocal('SCDEXSHIPSRTN');
  
    -- caculate retention based from last day from previous completed fiscal month
    v_section := 'Calculate Purge Date';
    SELECT TYCO_LAST_DAY(TYCO_ADD_MONTHS(SYSDATE,
                                         -1 * (TO_NUMBER(v_rtn_param) + 1)))
      INTO gvdPurgeDt
      FROM DUAL;
  
    -- purge old data  
    v_section := 'Delete records from EOIS tbl';
    DELETE EXCLUDED_ORDER_ITEM_SHIPMENTS WHERE DML_TS < gvdPurgeDt;
    gvnRowsDeleted := SQL%ROWCOUNT;
  
    v_section := 'Ge next Proces Log Seq';
    SELECT SCD_PROCESS_LOG_SEQ.NEXTVAL INTO gvnLogSeq FROM DUAL;
  
    -- create log record
    gvnLogLine := gvnLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       'procExcludedShips',
       USER,
       SYSDATE,
       gvnLogLine,
       'EXCLUDED_ORDER_ITEM_SHIPMENTS Deleted:' || gvnRowsDeleted);
  
    COMMIT;
  
    DBMS_OUTPUT.PUT_LINE('PURGE PERIOD (DML_TS): < ' || gvdPurgeDt);
    DBMS_OUTPUT.PUT_LINE('EXCLUDED TOIS RECORDS DELETED: ' ||
                         gvnRowsDeleted);
  EXCEPTION
    WHEN OTHERS THEN
      v_err_msg := SQLERRM;
      ROLLBACK;
      RAISE_APPLICATION_ERROR(-20101, v_err_msg || ' in ' || v_section);
  END procExcludedShips;

END Scdpurge;
/
