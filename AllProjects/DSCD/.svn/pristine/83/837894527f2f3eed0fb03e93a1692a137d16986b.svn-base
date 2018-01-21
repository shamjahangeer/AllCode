CREATE OR REPLACE PACKAGE PKG_SCORECARD_USER_PREFERENCES AS

  /*****************************************************************************/
  /* PACKAGE:     PKG_SCORECARD_USER_PREFERENCES                               */
  /* DESCRIPTION: 1) This program will delete inactive employees from the      */
  /*           SCORECARD_USER_PREFERENCES table that are no longer with  */
  /*                 the company.                                              */
  /*              2) This program will also delete the users, if they haven't  */
  /*                 accessed the system in the last sixteen months.           */
  /*                                                             */
  /* 1.0   05/15/2001  F. Hafiz -- DSCD REWRITE                                */
  /*****************************************************************************/

  PROCEDURE p_inactive_employees(VIC_JOB_ID  IN SCORECARD_PROCESS_LOG.DML_ORACLE_ID%TYPE,
                                 VION_RESULT IN OUT NUMBER);

  PROCEDURE p_inactive_users(VGC_JOB_ID  IN SCORECARD_PROCESS_LOG.DML_ORACLE_ID%TYPE,
                             VION_RESULT IN OUT NUMBER);

End PKG_SCORECARD_USER_PREFERENCES;
/
create or replace package body PKG_SCORECARD_USER_PREFERENCES AS

  PROCEDURE p_inactive_employees(VIC_JOB_ID  IN SCORECARD_PROCESS_LOG.DML_ORACLE_ID%TYPE,
                                 VION_RESULT IN OUT NUMBER) IS
  
    /*****************************************************************************/
    /* PROCEDURE:   p_inactive_employees                                         */
    /*                                                                           */
    /* DESCRIPTION: 1) This procedure will delete inactive employees from the    */
    /*           SCORECARD_USER_PREFERENCES table that are no longer with  */
    /*                 the company.                                              */
    /*****************************************************************************/
  
    CURSOR user_preferences IS
    
      SELECT ASOC_GLOBAL_ID
        FROM GED_PUBLIC_VIEW
       WHERE ASOC_DELETE_DT IS NOT NULL
         AND ASOC_GLOBAL_ID IN
             (SELECT DISTINCT ASOC_GLOBAL_ID FROM SCORECARD_USER_PREFERENCES);
  
    /* LOCAL VARIABLES */
  
    v_asoc_global_id   NUMBER;
    v_retain_months    NUMBER;
    m_purge_date       DATE;
    num_rows_processed NUMBER := 0;
    v_log_line         NUMBER := 0;
    rows_deleted       NUMBER := 0;
  
  BEGIN
  
    OPEN user_preferences;
  
    LOOP
    
      FETCH user_preferences
        INTO v_asoc_global_id;
    
      EXIT WHEN(user_preferences%NOTFOUND);
    
      DELETE FROM SCORECARD_USER_PREFERENCES
       WHERE ASOC_GLOBAL_ID = V_ASOC_GLOBAL_ID;
    
      num_rows_processed := num_rows_processed + 1;
    
    END LOOP;
  
    /* ENTER RESULTS INTO PROCESS LOG */
  
    v_log_line := v_log_line + 1;
  
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (SCD_PROCESS_LOG_SEQ.NEXTVAL,
       'P_USER_PROFILES',
       VIC_JOB_ID,
       SYSDATE,
       v_log_line,
       ('**** ' || num_rows_processed || ' DELETED'));
  
    CLOSE user_preferences;
  
    COMMIT;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_INACTIVE_EMPLOYEES SQL ERROR:  ' ||
                           sqlerrm(vion_result));
    
  END P_INACTIVE_EMPLOYEES;

  /*****************************************************************************/
  /* PROCEDURE:   p_inactive_users                                             */
  /*                                                                           */
  /* DESCRIPTION: This procedure will delete the users, if they haven't        */
  /*              accessed the system in the last sixteen months.              */
  /*****************************************************************************/

  PROCEDURE p_inactive_users(VGC_JOB_ID  IN SCORECARD_PROCESS_LOG.DML_ORACLE_ID%TYPE,
                             VION_RESULT IN OUT NUMBER) IS
  
    /* LOCAL VARIABLES */
  
    v_retain_months NUMBER;
    m_purge_date    DATE;
    rows_deleted    NUMBER := 0;
    v_log_line      NUMBER := 0;
  
  BEGIN
  
    SELECT PARAMETER_FIELD
      INTO v_retain_months
      FROM DELIVERY_PARAMETER
     WHERE PARAMETER_ID = 'SCD02MTHS';
  
    /* Calculate Purge Date */
    m_purge_date := LAST_DAY(ADD_MONTHS(SYSDATE, v_retain_months * -1));
  
    /* Deletes all SCORECARD_USER_PROLIES rows older than the data retention limit.
    The retention date is calculated using the SCD02MTHS parameter in the
    DELIVERY_PRAMETER table */
  
    DELETE FROM SCORECARD_USER_PREFERENCES WHERE DML_TS < m_purge_date;
  
    rows_deleted := SQL%ROWCOUNT;
  
    IF rows_deleted >= 0 THEN
    
      /* ENTER RESULTS INTO PROCESS LOG */
    
      INSERT INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'PKG_SCORECARD_USER_PREFERENCES',
         VGC_JOB_ID,
         SYSDATE,
         v_log_line,
         ('**** ' || rows_deleted || ' DELETED'));
    END IF;
  
    COMMIT;
  
  EXCEPTION
  
    WHEN OTHERS THEN
      vion_result := SQLCODE;
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('P_INACTIVE_USERS SQL ERROR:  ' ||
                           sqlerrm(vion_result));
    
  END P_INACTIVE_USERS;
END PKG_SCORECARD_USER_PREFERENCES;
/
