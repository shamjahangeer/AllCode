CREATE OR REPLACE PROCEDURE P_Team_Load( VIC_JOB_ID IN CHAR,
   VION_RESULT IN OUT NUMBER) IS
TEAM         SCORECARD_TEAM%ROWTYPE;
TEAM_ROWID ROWID;
NBR_ROWS_INSERTED    NUMBER := 0;
NBR_ROWS_UPDATED     NUMBER := 0;
NBR_ROWS_DELETED     NUMBER := 0;
NBR_ROWS_FLAGGED     NUMBER := 0;
TMP_ROWS_PROCESSED   NUMBER := 0;
TEAM_ROWS_PROCESSED  NUMBER := 0;
PURGE_DATE           DATE;
ROW_COUNT            NUMBER := 0;
RETAIN_MONTHS        NUMBER := 0;
LOG_LINE             NUMBER := 0;
SQL_ERROR            CHAR(70);
CURSOR CUR_TEMP_TEAM IS
    SELECT DISTINCT tst.TEAM_CODE,
           od.ORGANIZATION_KEY_ID TEAM_DIV_ORG_KEY_ID,
           ABBRD_DESC,
           DSCRPTN
       FROM TEMP_SCORECARD_TEAM tst, ORGANIZATIONS_DMN od
	   WHERE RTRIM(tst.TEAM_DIV_ORG_CODE, '0') = od.ISO_LEGACY_PREFERRED_ORG_CDE;

TMP_TEAM  CUR_TEMP_TEAM%ROWTYPE;

CURSOR CUR_TEAM IS
    SELECT TEAM_CODE,
           TEAM_DIV_ORG_KEY_ID,
		   EXPIRATION_DATE,
       ROWID
       FROM SCORECARD_TEAM;
BEGIN
/*********************************************************************/
/* THIS FIRST LOOP TESTS FOR ADDS AND CHANGES BY COMPARING THE       */
/* TEMP_SCORECARD_TEAM TABLE TO THE SCORECARD_TEAM TABLE.            */
/*********************************************************************/
   OPEN CUR_TEMP_TEAM;
   LOOP
      FETCH CUR_TEMP_TEAM
      INTO
         TMP_TEAM.TEAM_CODE,
         TMP_TEAM.TEAM_DIV_ORG_KEY_ID,
         TMP_TEAM.ABBRD_DESC,
         TMP_TEAM.DSCRPTN;
      EXIT WHEN (CUR_TEMP_TEAM%NOTFOUND);
      TMP_ROWS_PROCESSED := TMP_ROWS_PROCESSED + 1;
      BEGIN
         SELECT
           ABBRD_DESC,
           DSCRPTN,
           EXPIRATION_DATE,
           ROWID
         INTO
           TEAM.ABBRD_DESC,
           TEAM.DSCRPTN,
           TEAM.EXPIRATION_DATE,
           TEAM_ROWID
         FROM
           SCORECARD_TEAM
         WHERE
           TEAM_CODE = TMP_TEAM.TEAM_CODE AND
           TEAM_DIV_ORG_KEY_ID  = TMP_TEAM.TEAM_DIV_ORG_KEY_ID;
         IF TEAM.ABBRD_DESC <> TMP_TEAM.ABBRD_DESC
            OR TEAM.DSCRPTN <> TMP_TEAM.DSCRPTN
            OR TEAM.EXPIRATION_DATE IS NOT NULL THEN
               UPDATE SCORECARD_TEAM
               SET ABBRD_DESC = TMP_TEAM.ABBRD_DESC,
               DSCRPTN = TMP_TEAM.DSCRPTN,
               DML_TMSTMP = SYSDATE,
               EXPIRATION_DATE = NULL
               WHERE ROWID = TEAM_ROWID;
               NBR_ROWS_UPDATED := NBR_ROWS_UPDATED + 1;
         END IF;
         EXCEPTION
           WHEN NO_DATA_FOUND THEN
              INSERT
                INTO SCORECARD_TEAM(
				  TEAM_CODE,
				  TEAM_DIV_ORG_KEY_ID,
				  DML_ORACLE_ID,
				  DML_TMSTMP,
				  ABBRD_DESC,
				  DSCRPTN,
				  EXPIRATION_DATE)
                VALUES(
                  TMP_TEAM.TEAM_CODE,
                  TMP_TEAM.TEAM_DIV_ORG_KEY_ID,
                  VIC_JOB_ID,
                  SYSDATE,
                  TMP_TEAM.ABBRD_DESC,
                  TMP_TEAM.DSCRPTN,
                  NULL);
               NBR_ROWS_INSERTED := NBR_ROWS_INSERTED + 1;
      END;  /* BEGIN*/
   END LOOP;
   CLOSE CUR_TEMP_TEAM;
    /* COMMIT AFTER ADDS AND UPDATES */
    COMMIT;
/*********************************************************************/
/* THIS SECOND LOOP TESTS FOR DELETES BY SCANNING THE SCORECARD_TEAM */
/* TABLE AND SELECTING TEMP_SCORECARD_TEAM. IF THE BUILDING IS ON    */
/* THE SCORECARD_TEAM BUT NOT ON THE TEMP_SCORECARD_TEAM AND THE EXP- */
/* IRATION DATE IS LESS THAN THE PURGE DATE THE ROW IS DELETED FROM  */
/* SCORECARD_TEAM.                                                   */
/*********************************************************************/
/*********************************************************************/
/* CALCULATE PURGE DATE                                              */
/*********************************************************************/
    SELECT
      PARAMETER_FIELD
    INTO
      RETAIN_MONTHS
    FROM
      DELIVERY_PARAMETER
    WHERE
      PARAMETER_ID = 'SCD02MTHS';
    /* CALCULATE PURGE DATE */
    PURGE_DATE := LAST_DAY(ADD_MONTHS(SYSDATE, RETAIN_MONTHS * -1));
   OPEN CUR_TEAM;
   LOOP
      FETCH CUR_TEAM
      INTO
         TEAM.TEAM_CODE,
         TEAM.TEAM_DIV_ORG_KEY_ID,
         TEAM.EXPIRATION_DATE,
         TEAM_ROWID;
      EXIT WHEN (CUR_TEAM%NOTFOUND);
      TEAM_ROWS_PROCESSED := TEAM_ROWS_PROCESSED + 1;
      ROW_COUNT := 0;
      SELECT
        COUNT(*)
      INTO
        ROW_COUNT
      FROM
        (SELECT DISTINCT tst.TEAM_CODE,
		                 tst.TEAM_DIV_ORG_CODE,
						 od.ORGANIZATION_KEY_ID TEAM_DIV_ORG_KEY_ID
         FROM TEMP_SCORECARD_TEAM tst, ORGANIZATIONS_DMN od
	     WHERE RTRIM(tst.TEAM_DIV_ORG_CODE, '0') = od.ISO_LEGACY_PREFERRED_ORG_CDE) temp
      WHERE
        temp.TEAM_CODE = TEAM.TEAM_CODE AND
        temp.TEAM_DIV_ORG_KEY_ID  = TEAM.TEAM_DIV_ORG_KEY_ID ;
      IF ROW_COUNT = 0 THEN
         IF TEAM.EXPIRATION_DATE IS NULL THEN
            UPDATE SCORECARD_TEAM
               SET EXPIRATION_DATE = SYSDATE
               WHERE ROWID = TEAM_ROWID;
            NBR_ROWS_FLAGGED := NBR_ROWS_FLAGGED + 1;
         ELSIF TEAM.EXPIRATION_DATE < PURGE_DATE THEN
            DELETE FROM SCORECARD_TEAM
               WHERE ROWID = TEAM_ROWID;
            NBR_ROWS_DELETED := NBR_ROWS_DELETED + 1;
         END IF;
      END IF;
   END LOOP;
   CLOSE CUR_TEAM;
    /* COMMIT AFTER DELETES */
    COMMIT;
    /* ENTER RESULTS INTO PROCESS LOG */
      LOG_LINE := LOG_LINE + 1;
      INSERT
      INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_Team_Load',
         VIC_JOB_Id,
         SYSDATE,
         LOG_LINE,
         ('**** ' || NBR_ROWS_INSERTED || '  INSERTED'));
      LOG_LINE := LOG_LINE + 1;
      INSERT
      INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_Team_Load',
         VIC_JOB_ID,
         SYSDATE,
         LOG_LINE,
         ('**** ' || NBR_ROWS_UPDATED || '  UPDATED'));
      LOG_LINE := LOG_LINE + 1;
      INSERT
      INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_Team_Load',
         VIC_JOB_ID,
         SYSDATE,
         LOG_LINE,
         ('**** ' || NBR_ROWS_DELETED || '  DELETED'));
      LOG_LINE := LOG_LINE + 1;
      INSERT
      INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (SCD_PROCESS_LOG_SEQ.NEXTVAL,
         'P_Team_Load',
         VIC_JOB_ID,
         SYSDATE,
         LOG_LINE,
         ('**** ' || NBR_ROWS_FLAGGED || '  FLAGGED'));
    COMMIT;
    EXCEPTION
      WHEN OTHERS THEN
        VION_RESULT := SQLCODE;
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('P_Team_Load');
        DBMS_OUTPUT.PUT_LINE('SQL ERROR: '|| SQLERRM(VION_RESULT));
        LOG_LINE := LOG_LINE + 1;
        SQL_ERROR := SQLERRM(VION_RESULT);
        INSERT
        INTO SCORECARD_PROCESS_LOG
          (SCD_PROCESS_LOG_SEQ,
           SCD_PROCESS_NAME,
           DML_ORACLE_ID,
           DML_TMSTMP,
           SCD_PROCESS_LINE,
           SCD_PROCESS_TEXT)
        VALUES
          (SCD_PROCESS_LOG_SEQ.NEXTVAL,
           'P_Team_Load',
           VIC_JOB_ID,
           SYSDATE,
           LOG_LINE,
           ('DBER ' || SUBSTR(SQL_ERROR, 1, 70)));
        LOG_LINE := LOG_LINE + 1;
        INSERT
        INTO SCORECARD_PROCESS_LOG
          (SCD_PROCESS_LOG_SEQ,
           SCD_PROCESS_NAME,
           DML_ORACLE_ID,
           DML_TMSTMP,
           SCD_PROCESS_LINE,
           SCD_PROCESS_TEXT)
        VALUES
          (SCD_PROCESS_LOG_SEQ.NEXTVAL,
           'P_Team_Load',
           VIC_JOB_ID,
           SYSDATE,
           LOG_LINE,
           ('DBER ' || 'TMP ROWS: ' || TMP_ROWS_PROCESSED ||
                       'TEAM ROWS: ' || TEAM_ROWS_PROCESSED ));
        COMMIT;   /* COMMIT THE ERROR MSG */
  END P_Team_Load;
/
