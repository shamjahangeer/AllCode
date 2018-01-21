CREATE OR REPLACE PACKAGE Pkg_Cust_Ww_Xref AS
  /****************************************************************************/
  /* PACKAGE:     pkg_cust_ww_xref                                            */
  /* DESCRIPTION: Contains procedures for Loading the Customer /              */
  /*              Worldwide cross reference.                                  */
  /*                                                                          */
  /* PROCEDURES:  p_get_cust_xref                                             */
  /*              p_load_cust_xref                                            */
  /*              p_monthly_purge                                             */
  /*              p_load_from_ships                                           */
  /*              p_load_from_opens                                           */
  /*                                                                          */
  /* AUTHOR:      John Fassano  , Computer Aid Inc,      July, 1996           */
  /****************************************************************************/
  /* MODIFICATION LOG:                                                      */
  /*                                                                          */
  /*  12/23/96 -  CHANGE PARAMETER_ID TO SCD02MTHS        J. FASSANO          */
  /*                                                       (CAI)              */
  /*  04/04/01 - ADDED HANDLING OF ACCOUNTING_ORG_KEY_ID  M. GONZALES  (CAI)  */
  /*             COLUMN                                                       */
  /*  12/17/04 - Alpha Part project.                                    */
  /****************************************************************************/

  PROCEDURE P_LOAD_CUST_XREF(VIC_TYPE_OF_LOAD IN CHAR,
                             VIC_JOB_ID       IN LOAD_MSG.DML_ORACLE_ID%TYPE,
                             VIN_COMMIT_COUNT IN NUMBER,
                             VION_RESULT      IN OUT NUMBER);
  PROCEDURE P_MONTHLY_PURGE(VIC_JOB_ID       IN LOAD_MSG.DML_ORACLE_ID%TYPE,
                            VIN_COMMIT_COUNT IN NUMBER,
                            VION_RESULT      IN OUT NUMBER);
END Pkg_Cust_Ww_Xref;
/
CREATE OR REPLACE PACKAGE BODY Pkg_Cust_Ww_Xref AS
  ORDER_ITEM_SHIP ORDER_ITEM_SHIPMENT%ROWTYPE;
  VGC_JOB_ID      LOAD_MSG.DML_ORACLE_ID%TYPE;
  UE_CRITICAL_DB_ERROR EXCEPTION;
  VGN_SQL_RESULT   NUMBER;
  VGN_COMMIT_COUNT NUMBER;
  /****************************************************************************/
  /* PROCEDURE:   P_GET_CUST_XREF                                             */
  /* DESCRIPTION: RETRIEVES THE SCORECARD_CUSTOMER_WW_XREF                    */
  /****************************************************************************/
  FUNCTION F_GET_CUST_XREF(VON_SQLCODE OUT NUMBER) RETURN INTEGER IS
    vCnt INTEGER;
  BEGIN
    VON_SQLCODE := 0;
    SELECT COUNT(*)
      INTO vCnt
      FROM SCORECARD_CUSTOMER_WW_XREF
     WHERE ACCOUNTING_ORG_KEY_ID = ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID
       AND PURCHASE_BY_ACCOUNT_BASE =
           ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE
       AND SHIP_TO_ACCOUNT_SUFFIX = ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX
       AND WW_ACCOUNT_NBR_BASE = ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE
       AND WW_ACCOUNT_NBR_SUFFIX = ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX
       AND NBR_WINDOW_DAYS_EARLY = ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY
       AND NBR_WINDOW_DAYS_LATE = ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE;
    RETURN(vCnt);
  EXCEPTION
    WHEN OTHERS THEN
      VON_SQLCODE := SQLCODE;
      -- Return Non-zero count on error
      RETURN(1);
  END f_GET_CUST_XREF;

  /****************************************************************************/
  /* PROCEDURE:     P_LOAD_FROM_SHIPS                                         */
  /* DESCRIPTION:   THE ORDER_ITEM_SHIPMENT TABLE IS USED TO RETRIEVE         */
  /*                ALL COMBINATIONS OF WORLDWIDE,CUSTOMER,DAYS EARLY,        */
  /*                AND DAYS LATE.                                            */
  /*                THE RESULTS ARE USED TO INSERT ROWS INTO THE              */
  /*                SCORECARD_CUSTOMER_WW_XREF TABLE.                                       */
  /****************************************************************************/
  PROCEDURE P_LOAD_FROM_SHIPS AS
    NUM_ROWS_PROCESSED NUMBER := 0;
    CURSOR OIS_WW_CUST IS
      SELECT ACCOUNTING_ORG_KEY_ID,
             PURCHASE_BY_ACCOUNT_BASE,
             SHIP_TO_ACCOUNT_SUFFIX,
             WW_ACCOUNT_NBR_BASE,
             WW_ACCOUNT_NBR_SUFFIX,
             NVL(NBR_WINDOW_DAYS_EARLY, 0),
             NVL(NBR_WINDOW_DAYS_LATE, 0),
             MAX(AMP_SHIPPED_DATE)
        FROM ORDER_ITEM_SHIPMENT
       GROUP BY ACCOUNTING_ORG_KEY_ID,
                PURCHASE_BY_ACCOUNT_BASE,
                SHIP_TO_ACCOUNT_SUFFIX,
                WW_ACCOUNT_NBR_BASE,
                WW_ACCOUNT_NBR_SUFFIX,
                NBR_WINDOW_DAYS_EARLY,
                NBR_WINDOW_DAYS_LATE;
  BEGIN
    VGN_SQL_RESULT := 0;
    /* OPEN CURSOR */
    OPEN OIS_WW_CUST;
    LOOP
      /* FETCH A RECORD */
      FETCH OIS_WW_CUST
        INTO ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID, ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE, ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX, ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE, ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX, ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY, ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE, ORDER_ITEM_SHIP.AMP_SHIPPED_DATE;
      /* EXIT LOOP WHEN THERE ARE NO MORE RECORDS TO PROCESS. */
      EXIT WHEN(OIS_WW_CUST%NOTFOUND);
    
      INSERT INTO SCORECARD_CUSTOMER_WW_XREF
        (WW_ACCOUNT_NBR_BASE,
         WW_ACCOUNT_NBR_SUFFIX,
         ACCOUNTING_ORG_KEY_ID,
         PURCHASE_BY_ACCOUNT_BASE,
         SHIP_TO_ACCOUNT_SUFFIX,
         NBR_WINDOW_DAYS_EARLY,
         NBR_WINDOW_DAYS_LATE,
         DML_ORACLE_ID,
         DML_TMSTMP,
         AMP_SHIPPED_DATE)
      VALUES
        (ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE,
         ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX,
         ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID,
         ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE,
         ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX,
         ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY,
         ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE,
         VGC_JOB_ID,
         SYSDATE,
         ORDER_ITEM_SHIP.AMP_SHIPPED_DATE);
      NUM_ROWS_PROCESSED := NUM_ROWS_PROCESSED + 1;
      IF (MOD(NUM_ROWS_PROCESSED, VGN_COMMIT_COUNT) = 0) THEN
        COMMIT;
      END IF;
    END LOOP;
    CLOSE OIS_WW_CUST;
  
    /* ENTER RESULTS INTO LOAD_MSG FILE */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       VGC_JOB_ID,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       0,
       0,
       0,
       NUM_ROWS_PROCESSED,
       0,
       0);
    /* DO ONE LAST COMMIT */
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      VGN_SQL_RESULT := SQLCODE;
      ROLLBACK;
      P_Write_Error(NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    'DBER', /* STATUS */
                    'I',
                    VGC_JOB_ID,
                    VGN_SQL_RESULT,
                    SQLERRM(VGN_SQL_RESULT));
      COMMIT; /* COMMIT THE ERROR MSG */
  END P_LOAD_FROM_SHIPS;
  /****************************************************************************/
  /* PROCEDURE:     P_LOAD_FROM_OPENS                                         */
  /* DESCRIPTION:   THE ORDER_ITEM_OPEN TABLE IS USED TO RETRIEVE         */
  /*                ALL COMBINATIONS OF WORLDWIDE,CUSTOMER,DAYS EARLY,        */
  /*                AND DAYS LATE.                                            */
  /*                THE RESULTS ARE USED TO INSERT ROWS INTO THE              */
  /*                SCORECARD_CUSTOMER_WW_XREF TABLE.                                       */
  /****************************************************************************/
  PROCEDURE P_LOAD_FROM_OPENS AS
    NUM_ROWS_PROCESSED NUMBER := 0;
    TEMP_ROWID         ROWID;
    CURSOR OIO_WW_CUST IS
      SELECT ACCOUNTING_ORG_KEY_ID,
             PURCHASE_BY_ACCOUNT_BASE,
             SHIP_TO_ACCOUNT_SUFFIX,
             WW_ACCOUNT_NBR_BASE,
             WW_ACCOUNT_NBR_SUFFIX,
             NVL(NBR_WINDOW_DAYS_EARLY, 0),
             NVL(NBR_WINDOW_DAYS_LATE, 0)
        FROM ORDER_ITEM_OPEN
       GROUP BY ACCOUNTING_ORG_KEY_ID,
                PURCHASE_BY_ACCOUNT_BASE,
                SHIP_TO_ACCOUNT_SUFFIX,
                WW_ACCOUNT_NBR_BASE,
                WW_ACCOUNT_NBR_SUFFIX,
                NBR_WINDOW_DAYS_EARLY,
                NBR_WINDOW_DAYS_LATE;
  BEGIN
    VGN_SQL_RESULT := 0;
    /* OPEN CURSOR */
    OPEN OIO_WW_CUST;
    LOOP
      /* FETCH A RECORD */
      FETCH OIO_WW_CUST
        INTO ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID, ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE, ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX, ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE, ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX, ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY, ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE;
      /* EXIT LOOP WHEN THERE ARE NO MORE RECORDS TO PROCESS. */
      EXIT WHEN(OIO_WW_CUST%NOTFOUND);
    
      IF F_GET_CUST_XREF(VGN_SQL_RESULT) = 0 THEN
        INSERT INTO SCORECARD_CUSTOMER_WW_XREF
          (WW_ACCOUNT_NBR_BASE,
           WW_ACCOUNT_NBR_SUFFIX,
           ACCOUNTING_ORG_KEY_ID,
           PURCHASE_BY_ACCOUNT_BASE,
           SHIP_TO_ACCOUNT_SUFFIX,
           NBR_WINDOW_DAYS_EARLY,
           NBR_WINDOW_DAYS_LATE,
           DML_ORACLE_ID,
           DML_TMSTMP,
           AMP_SHIPPED_DATE)
        VALUES
          (ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_BASE,
           ORDER_ITEM_SHIP.WW_ACCOUNT_NBR_SUFFIX,
           ORDER_ITEM_SHIP.ACCOUNTING_ORG_KEY_ID,
           ORDER_ITEM_SHIP.PURCHASE_BY_ACCOUNT_BASE,
           ORDER_ITEM_SHIP.SHIP_TO_ACCOUNT_SUFFIX,
           ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_EARLY,
           ORDER_ITEM_SHIP.NBR_WINDOW_DAYS_LATE,
           VGC_JOB_ID,
           SYSDATE,
           NULL);
        NUM_ROWS_PROCESSED := NUM_ROWS_PROCESSED + 1;
        IF (MOD(NUM_ROWS_PROCESSED, VGN_COMMIT_COUNT) = 0) THEN
          COMMIT;
        END IF;
      ELSE
        IF VGN_SQL_RESULT <> 0 THEN
          RAISE UE_CRITICAL_DB_ERROR;
        END IF;
      END IF;
    END LOOP;
    CLOSE OIO_WW_CUST;
    /* ENTER RESULTS INTO LOAD_MSG FILE */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       VGC_JOB_ID,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       '****',
       0,
       0,
       0,
       NUM_ROWS_PROCESSED,
       0,
       0);
    /* DO ONE LAST COMMIT */
    COMMIT;
  EXCEPTION
    WHEN UE_CRITICAL_DB_ERROR THEN
      P_Write_Error(NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    'DBER', /* STATUS */
                    'I',
                    VGC_JOB_ID,
                    VGN_SQL_RESULT,
                    SQLERRM(VGN_SQL_RESULT));
      ROLLBACK;
    WHEN OTHERS THEN
      VGN_SQL_RESULT := SQLCODE;
      ROLLBACK;
      P_Write_Error(NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    'DBER', /* STATUS */
                    'I',
                    VGC_JOB_ID,
                    VGN_SQL_RESULT,
                    SQLERRM(VGN_SQL_RESULT));
      COMMIT; /* COMMIT THE ERROR MSG */
  END P_LOAD_FROM_OPENS;
  /****************************************************************************/
  /* PROCEDURE:     P_LOAD_CUST_XEF                                           */
  /* DESCRIPTION:   THE SCORECARD_CUSTOMER_XREF TABLE IS LOADED               */
  /*                FROM THE ORDER_ITEM_SHIPMENT AND/OR THE ORDRE_ITEM        */
  /*                _OPEN DEPENDING ON THE TYPE OF LOAD REQUESTED.            */
  /****************************************************************************/
  PROCEDURE P_LOAD_CUST_XREF(VIC_TYPE_OF_LOAD IN CHAR,
                             VIC_JOB_ID       IN LOAD_MSG.DML_ORACLE_ID%TYPE,
                             VIN_COMMIT_COUNT IN NUMBER,
                             VION_RESULT      IN OUT NUMBER) AS
  BEGIN
    VION_RESULT      := 0;
    VGC_JOB_ID       := VIC_JOB_ID;
    VGN_COMMIT_COUNT := VIN_COMMIT_COUNT;
    /* TEST FOR TYPE OF LOAD */
    IF VIC_TYPE_OF_LOAD = 'B' THEN
      P_LOAD_FROM_SHIPS;
      IF VGN_SQL_RESULT = 0 THEN
        P_LOAD_FROM_OPENS;
      END IF;
    ELSIF VIC_TYPE_OF_LOAD = 'S' THEN
      P_LOAD_FROM_SHIPS;
    ELSE
      P_LOAD_FROM_OPENS;
    END IF;
    VION_RESULT := VGN_SQL_RESULT;
  END P_LOAD_CUST_XREF;
  /****************************************************************************/
  /* PROCEDURE:   P_MONTHLY_PURGE                                             */
  /* DESCRIPTION: DELETES ALL SCORECARD_CUSTOMER_WW_XREF ROWS OLDER THAN THE  */
  /*              DATA RETENTION LIMIT. THE RETENTION DATE IS CALCULATED USING*/
  /*              THE SCD02MTHS PARAMETER IN THE DELIVERY_PARAMETER TABLE.    */
  /****************************************************************************/
  PROCEDURE P_MONTHLY_PURGE(VIC_JOB_ID       IN LOAD_MSG.DML_ORACLE_ID%TYPE,
                            VIN_COMMIT_COUNT IN NUMBER,
                            VION_RESULT      IN OUT NUMBER) IS
    CURSOR CUR_CUST_XREF_ROW(NINES_DATE DATE, PURGE_DATE DATE) IS
      SELECT ROWID
        FROM SCORECARD_CUSTOMER_WW_XREF
       WHERE ((AMP_SHIPPED_DATE > NINES_DATE) AND
             (AMP_SHIPPED_DATE <= PURGE_DATE))
         AND (ROWNUM <= VIN_COMMIT_COUNT);
    ACTION             CHAR;
    COMMIT_COUNT       NUMBER := 0;
    NUM_ROWS_PROCESSED NUMBER := 0;
    RETAIN_MONTHS      NUMBER := 0;
    DISCARD_COUNT      NUMBER;
    M_PURGE_DATE       DATE;
    M_NINES_DATE       DATE;
    XREF_ROWID         ROWID;
    SQL_RESULT         NUMBER;
  BEGIN
    VGC_JOB_ID   := VIC_JOB_ID;
    M_NINES_DATE := TO_DATE('0001001', 'YYYYDDD');
    SELECT PARAMETER_FIELD
      INTO RETAIN_MONTHS
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'SCD02MTHS';
    /* CALCULATE PURGE DATE */
    M_PURGE_DATE := LAST_DAY(ADD_MONTHS(SYSDATE, RETAIN_MONTHS * -1));
    OPEN CUR_CUST_XREF_ROW(M_NINES_DATE, M_PURGE_DATE);
    LOOP
      FETCH CUR_CUST_XREF_ROW
        INTO XREF_ROWID;
      EXIT WHEN(CUR_CUST_XREF_ROW%NOTFOUND);
      DELETE FROM SCORECARD_CUSTOMER_WW_XREF WHERE ROWID = XREF_ROWID;
      NUM_ROWS_PROCESSED := NUM_ROWS_PROCESSED + 1;
      IF (MOD(NUM_ROWS_PROCESSED, VIN_COMMIT_COUNT) = 0) THEN
        COMMIT;
        CLOSE CUR_CUST_XREF_ROW;
        OPEN CUR_CUST_XREF_ROW(M_NINES_DATE, M_PURGE_DATE);
      END IF;
    END LOOP;
    CLOSE CUR_CUST_XREF_ROW;
    /* DO ONE LAST COMMIT */
    COMMIT;
    /* ENTER RESULTS INTO LOAD_MSG FILE */
    INSERT INTO LOAD_MSG
      (LOAD_MSG_SEQ,
       DML_ORACLE_ID,
       DML_TMSTMP,
       ORGANIZATION_KEY_ID,
       AMP_ORDER_NBR,
       ORDER_ITEM_NBR,
       SHIPMENT_ID,
       DATABASE_LOAD_DATE,
       AMP_SHIPPED_DATE,
       AMP_SCHEDULE_DATE,
       PART_KEY_ID,
       STATUS,
       NBR_DETAILS_INSERTED,
       NBR_DETAILS_MODIFIED,
       NBR_DETAILS_DELETED,
       NBR_SMRYS_INSERTED,
       NBR_SMRYS_MODIFIED,
       NBR_SMRYS_DELETED)
    VALUES
      (LOAD_MSG_SEQ.NEXTVAL,
       VGC_JOB_ID,
       SYSDATE,
       NULL,
       NULL,
       NULL,
       NULL,
       M_PURGE_DATE,
       NULL,
       NULL,
       NULL,
       '****',
       NULL,
       NULL,
       NULL,
       NULL,
       NULL,
       NUM_ROWS_PROCESSED);
  EXCEPTION
    WHEN UE_CRITICAL_DB_ERROR THEN
      VION_RESULT := VGN_SQL_RESULT;
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(VION_RESULT));
      ROLLBACK;
      P_Write_Error(ORDER_ITEM_SHIP.ORGANIZATION_KEY_ID,
                    ORDER_ITEM_SHIP.AMP_ORDER_NBR,
                    ORDER_ITEM_SHIP.ORDER_ITEM_NBR,
                    ORDER_ITEM_SHIP.SHIPMENT_ID,
                    ORDER_ITEM_SHIP.DATABASE_LOAD_DATE,
                    ORDER_ITEM_SHIP.AMP_SHIPPED_DATE,
                    ORDER_ITEM_SHIP.AMP_SCHEDULE_DATE,
                    ORDER_ITEM_SHIP.PART_KEY_ID,
                    'DBER',
                    'D',
                    VGC_JOB_ID,
                    VION_RESULT,
                    SQLERRM(VION_RESULT));
      COMMIT; /* COMMIT THE ERROR MSG */
    WHEN OTHERS THEN
      VION_RESULT := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(VION_RESULT));
      P_Write_Error(ORDER_ITEM_SHIP.ORGANIZATION_KEY_ID,
                    ORDER_ITEM_SHIP.AMP_ORDER_NBR,
                    ORDER_ITEM_SHIP.ORDER_ITEM_NBR,
                    ORDER_ITEM_SHIP.SHIPMENT_ID,
                    ORDER_ITEM_SHIP.DATABASE_LOAD_DATE,
                    ORDER_ITEM_SHIP.AMP_SHIPPED_DATE,
                    ORDER_ITEM_SHIP.AMP_SCHEDULE_DATE,
                    ORDER_ITEM_SHIP.PART_KEY_ID,
                    'DBER',
                    'D',
                    VGC_JOB_ID,
                    VION_RESULT,
                    SQLERRM(VION_RESULT));
      COMMIT; /* COMMIT THE ERROR MSG */
  END P_MONTHLY_PURGE;
END Pkg_Cust_Ww_Xref;
/
