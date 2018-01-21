CREATE OR REPLACE PACKAGE scdMaintSCDOrgs
AS
--
-- Purpose: Maintain the Scorecard Organization Tables.
-- 			Add a row to the Scorecard Org Type and Scorecard Organizations
--			tables for each unique Org, and parent orgs, that exist on the
--			Scorecard Org Summary table.
-- 			Remove rows from the Scorecard Org Type and Scorecard Organizations
--          that do not exist on the Scorecard Org Summary table.
--
-- REVISIONS
-- Date          Author               Comments
-- ---------     ---------------      ------------------------------------------
-- Apr 2001      SJupko               New	  
--   

   PROCEDURE procMaintSCDOrgs(pivUserID    IN  VARCHAR2,
                              ponErrNumber OUT NUMBER,
                              ponErrDesc   OUT VARCHAR2);

END; -- Package Specification pkgMaintSCDOrgs
/
CREATE OR REPLACE Package Body scdMaintSCDOrgs AS

  gvdTmStmp  DATE := SYSDATE;
  gcvPgmName SCORECARD_PROCESS_LOG.SCD_PROCESS_NAME%TYPE := '';
  gvvErrStr  SCORECARD_PROCESS_LOG.SCD_PROCESS_TEXT%TYPE := '';

  gviRowsProcessed INTEGER := 0;
  gviLogLine       INTEGER := 0;
  gvnLogSeq        NUMBER;
  --
  --  Subordinate Functions and Procedures
  --
  --
  --  Exposed Functions and Procedures
  --
  /******************************************************************************
    NAME:     procMaintSCDOrgs
    Purpose: Maintain the Scorecard Organization Tables.
         Add a row to the Scorecard Org Type and Scorecard Organizations
         tables for each unique Org, and parent orgs, that exist on the
         Scorecard Org Summary table.
         Remove rows from the Scorecard Org Type and Scorecard Organizations
             that do not exist on the Scorecard Org Summary table.
  
    REVISIONS:
  
     Date       Author              Comments
     --------   ----------------      ------------------------------------------
     Apr 2000   SJupko                New
     Jul 2002   AOrbeta       Add OIO table in determaining existing ORGs
                          in DSCD application.  
    6/17/2004   AOrbeta         Make sure the current or most recent Org is 
                        selected from Org_DMN table, in this bug fix 
                    an Org_Level_Code changed was not reflected
                    into DSCD Org table.
  ******************************************************************************/
  PROCEDURE procMaintSCDOrgs(pivUserID    IN VARCHAR2,
                             ponErrNumber OUT NUMBER,
                             ponErrDesc   OUT VARCHAR2) IS
    lviTypesInserted INTEGER := 0;
    lviTypesDeleted  INTEGER := 0;
    lviOrgsInserted  INTEGER := 0;
    lviOrgsUpdated   INTEGER := 0;
    lviOrgsDeleted   INTEGER := 0;
    lviCursorId      INTEGER;
    lviDummy         INTEGER;
    lvnLevelNbr      INTEGER;
    lvvSelectStmt    VARCHAR2(500);
    lvvColumnOrg     VARCHAR2(30);
    lvvColumnType    VARCHAR2(30);
    lvvOrgId         ORGANIZATIONS_DMN.ORGANIZATION_ID%TYPE;
    lvvOrgType       ORGANIZATIONS_DMN.ORGANIZATION_TYPE_DESC%TYPE;
    lvvOrgTypeId     SCORECARD_ORG_TYPES.ORGANIZATION_TYPE_ID%TYPE;
  
    CURSOR cur_TempOrgs IS
      SELECT b.ORGANIZATION_KEY_ID, b.ORGANIZATION_LEVEL_CDE
        FROM ORGANIZATIONS_DMN b
       WHERE (RECORD_STATUS_CDE = 'C' OR
             EFFECTIVE_FROM_DT =
             (SELECT MAX(EFFECTIVE_FROM_DT)
                 FROM ORGANIZATIONS_DMN e
                WHERE e.ORGANIZATION_KEY_ID = b.ORGANIZATION_KEY_ID))
         AND (EXISTS (SELECT 'x'
                        FROM SCORECARD_ORG_SMRY a
                       WHERE a.ORGANIZATION_KEY_ID = b.ORGANIZATION_KEY_ID
                         AND ROWNUM <= 1) OR EXISTS
              (SELECT 'x'
                 FROM ORDER_ITEM_OPEN d
                WHERE d.ORGANIZATION_KEY_ID = b.ORGANIZATION_KEY_ID
                  AND ROWNUM <= 1) OR EXISTS
              (SELECT 'x'
                 FROM MFG_CAMPUS_BLDG_SMRY c
                WHERE c.MFR_ORG_KEY_ID = b.ORGANIZATION_KEY_ID
                  AND ROWNUM <= 1));
  
    CURSOR cur_AddOrgs IS
      SELECT ORGANIZATION_KEY_ID,
             ORGANIZATION_TYPE_ID,
             ORGANIZATION_ID,
             ORGANIZATION_SHORT_NM,
             ORGANIZATION_LEVEL_CDE
        FROM TEMP_SCORECARD_ORGANIZATIONS
      MINUS
      SELECT ORGANIZATION_KEY_ID,
             ORGANIZATION_TYPE_ID,
             ORGANIZATION_ID,
             ORGANIZATION_SHORT_NM,
             ORGANIZATION_LEVEL_CDE
        FROM SCORECARD_ORGANIZATIONS;
  
    CURSOR cur_DelOrgs IS
      SELECT ORGANIZATION_KEY_ID,
             ORGANIZATION_TYPE_ID,
             ORGANIZATION_ID,
             ORGANIZATION_SHORT_NM,
             ORGANIZATION_LEVEL_CDE
        FROM SCORECARD_ORGANIZATIONS
      MINUS
      SELECT ORGANIZATION_KEY_ID,
             ORGANIZATION_TYPE_ID,
             ORGANIZATION_ID,
             ORGANIZATION_SHORT_NM,
             ORGANIZATION_LEVEL_CDE
        FROM TEMP_SCORECARD_ORGANIZATIONS;
  
  BEGIN
    gcvPgmName       := 'MaintSCDOrgs';
    gviRowsProcessed := 0;
  
    SELECT SCD_PROCESS_LOG_SEQ.NextVal INTO gvnLogSeq FROM DUAL;
    DELETE FROM TEMP_SCORECARD_ORGANIZATIONS;
    FOR v_TempOrgs IN cur_TempOrgs LOOP
    
      lvnLevelNbr := to_number(LTRIM(v_TempOrgs.organization_level_cde,
                                     'LEVEL'));
      FOR i IN 1 .. lvnLevelNbr LOOP
        lvvOrgId      := NULL;
        lvvOrgType    := NULL;
        lviCursorId   := DBMS_SQL.OPEN_CURSOR;
        lvvColumnOrg  := 'LAYER' || to_char(i) || '_ORGANIZATION_ID';
        lvvColumnType := 'LAYER' || to_char(i) || '_ORGANIZATION_TYPE_DESC';
        lvvSelectStmt := 'SELECT DISTINCT ' || lvvColumnOrg || ', ' ||
                         lvvColumnType || ' FROM ORGANIZATIONS_DMN ' ||
                         'WHERE ORGANIZATION_KEY_ID = :OrgKeyId' ||
                         '  AND (RECORD_STATUS_CDE = ''C'' OR' ||
                         '       EFFECTIVE_FROM_DT = (SELECT MAX(EFFECTIVE_FROM_DT) ' ||
                         '   	  	  	 			      FROM ORGANIZATIONS_DMN ' ||
                         '							 WHERE ORGANIZATION_KEY_ID = :OrgKeyId))';
      
        DBMS_SQL.PARSE(lviCursorId, lvvSelectStmt, DBMS_SQL.NATIVE);
        DBMS_SQL.BIND_VARIABLE(lviCursorId,
                               ':OrgKeyId',
                               v_TempOrgs.organization_key_id);
        DBMS_SQL.DEFINE_COLUMN(lviCursorId, 1, lvvOrgId, 4);
        DBMS_SQL.DEFINE_COLUMN(lviCursorId, 2, lvvOrgType, 45);
        lviDummy := DBMS_SQL.EXECUTE(lviCursorId);
        LOOP
          IF DBMS_SQL.FETCH_ROWS(lviCursorId) = 0 THEN
            EXIT;
          END IF;
          DBMS_SQL.COLUMN_VALUE(lviCursorId, 1, lvvOrgId);
          DBMS_SQL.COLUMN_VALUE(lviCursorId, 2, lvvOrgType);
          IF lvvOrgId IS NOT NULL THEN
            BEGIN
              SELECT ORGANIZATION_TYPE_ID
                INTO lvvOrgTypeId
                FROM SCORECARD_ORG_TYPES
               WHERE ORGANIZATION_TYPE_DESC = lvvOrgType;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                SELECT SCD_ORG_SEQ.NextVal INTO lvvOrgTypeId FROM DUAL;
                INSERT INTO SCORECARD_ORG_TYPES
                  (ORGANIZATION_TYPE_ID,
                   ORGANIZATION_TYPE_DESC,
                   DML_USER_ID,
                   DML_TS)
                VALUES
                  (lvvOrgTypeId, lvvOrgType, pivUserId, gvdTmStmp);
                lviTypesInserted := lviTypesInserted + 1;
                gviRowsProcessed := gviRowsProcessed + 1;
            END;
            BEGIN
              SELECT ORGANIZATION_TYPE_ID
                INTO lvvOrgTypeId
                FROM TEMP_SCORECARD_ORGANIZATIONS
               WHERE ORGANIZATION_ID = lvvOrgId;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                INSERT INTO TEMP_SCORECARD_ORGANIZATIONS
                  (ORGANIZATION_KEY_ID,
                   ORGANIZATION_TYPE_ID,
                   ORGANIZATION_ID,
                   ORGANIZATION_SHORT_NM,
                   ORGANIZATION_LEVEL_CDE,
                   DML_USER_ID,
                   DML_TS)
                  SELECT a.ORGANIZATION_KEY_ID,
                         lvvOrgTypeId,
                         a.ORGANIZATION_ID,
                         a.ORGANIZATION_SHORT_NM,
                         a.ORGANIZATION_LEVEL_CDE,
                         pivUserId,
                         gvdTmStmp
                    FROM ORGANIZATIONS_DMN a
                   WHERE a.ORGANIZATION_ID = lvvOrgId
                     AND a.ORGANIZATION_TYPE_DESC = lvvOrgType
                     AND a.EFFECTIVE_TO_DT =
                         (SELECT MAX(b.EFFECTIVE_TO_DT)
                            FROM ORGANIZATIONS_DMN b
                           WHERE b.ORGANIZATION_ID = lvvOrgId
                             AND b.ORGANIZATION_TYPE_DESC = lvvOrgType);
                LviOrgsInserted  := lviOrgsInserted + 1;
                gviRowsProcessed := gviRowsProcessed + 1;
                IF MOD(gviRowsProcessed, 1000) = 0 THEN
                  COMMIT;
                END IF;
            END;
          END IF;
        END LOOP; -- End Cursor Loop
        DBMS_SQL.CLOSE_CURSOR(lviCursorId);
      
      END LOOP; -- End Org Level Loop
    END LOOP; -- End Temp Org Loop
    gviLogLine := 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('SCORECARD_ORG_TYPES Inserted: ' || lviTypesInserted));
    gviLogLine := gviLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('TEMP_SCORECARD_ORGANIZATIONS Inserted: ' || lviOrgsInserted));
    COMMIT; -- Commit Inserted Temp Orgs & Org Types
  
    lviOrgsInserted := 0;
    FOR v_AddOrgs IN cur_AddOrgs LOOP
      BEGIN
        INSERT INTO SCORECARD_ORGANIZATIONS
          (ORGANIZATION_KEY_ID,
           ORGANIZATION_TYPE_ID,
           ORGANIZATION_ID,
           ORGANIZATION_SHORT_NM,
           ORGANIZATION_LEVEL_CDE,
           DML_USER_ID,
           DML_TS)
        VALUES
          (v_AddOrgs.ORGANIZATION_KEY_ID,
           v_AddOrgs.ORGANIZATION_TYPE_ID,
           v_AddOrgs.ORGANIZATION_ID,
           v_AddOrgs.ORGANIZATION_SHORT_NM,
           v_AddOrgs.ORGANIZATION_LEVEL_CDE,
           pivUserId,
           gvdTmStmp);
        lviOrgsInserted  := lviOrgsInserted + 1;
        gviRowsProcessed := gviRowsProcessed + 1;
        IF MOD(gviRowsProcessed, 1000) = 0 THEN
          COMMIT;
        END IF;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          UPDATE SCORECARD_ORGANIZATIONS
             SET ORGANIZATION_TYPE_ID   = v_AddOrgs.ORGANIZATION_TYPE_ID,
                 ORGANIZATION_ID        = v_AddOrgs.ORGANIZATION_ID,
                 ORGANIZATION_SHORT_NM  = v_AddOrgs.ORGANIZATION_SHORT_NM,
                 ORGANIZATION_LEVEL_CDE = v_AddOrgs.ORGANIZATION_LEVEL_CDE,
                 DML_USER_ID            = pivUserId,
                 DML_TS                 = gvdTmStmp
           WHERE ORGANIZATION_KEY_ID = v_AddOrgs.ORGANIZATION_KEY_ID;
          lviOrgsUpdated   := lviOrgsUpdated + 1;
          gviRowsProcessed := gviRowsProcessed + 1;
      END;
    END LOOP; -- End Add Org Loop
    gviLogLine := gviLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('SCORECARD_ORGANIZATIONS Inserted: ' || lviOrgsInserted));
    gviLogLine := gviLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('SCORECARD_ORGANIZATIONS Updated: ' || lviOrgsUpdated));
    COMMIT;
  
    FOR v_DelOrgs IN cur_DelOrgs LOOP
      DELETE FROM SCORECARD_ORGANIZATIONS
       WHERE ORGANIZATION_KEY_ID = v_DelOrgs.ORGANIZATION_KEY_ID;
      lviOrgsDeleted   := lviOrgsDeleted + 1;
      gviRowsProcessed := gviRowsProcessed + 1;
      IF MOD(gviRowsProcessed, 1000) = 0 THEN
        COMMIT;
      END IF;
    END LOOP; -- End Delete Org Loop
    gviLogLine := gviLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('SCORECARD_ORGANIZATIONS Deleted: ' || lviOrgsDeleted));
  
    DELETE FROM SCORECARD_ORG_TYPES a
     WHERE NOT EXISTS
     (SELECT *
              FROM SCORECARD_ORGANIZATIONS b
             WHERE a.ORGANIZATION_TYPE_ID = b.ORGANIZATION_TYPE_ID);
  
    lviTypesDeleted := SQL%ROWCOUNT;
    gviLogLine      := gviLogLine + 1;
    INSERT INTO SCORECARD_PROCESS_LOG
      (SCD_PROCESS_LOG_SEQ,
       SCD_PROCESS_NAME,
       DML_ORACLE_ID,
       DML_TMSTMP,
       SCD_PROCESS_LINE,
       SCD_PROCESS_TEXT)
    VALUES
      (gvnLogSeq,
       gcvPgmName,
       pivUserId,
       gvdTmStmp,
       gviLogLine,
       ('SCORECARD_ORG_TYPES Deleted: ' || lviTypesDeleted));
  
    COMMIT;
    ponErrNumber := 0;
  
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      gvvErrStr    := 'FATAL ERROR: ' || TO_CHAR(SQLCODE) || ': ' ||
                      SUBSTR(SQLERRM, 1, 200);
      ponErrNumber := SQLCODE;
      ponErrDesc   := SUBSTR(SQLERRM, 1, 200);
      gviLogLine   := gviLogLine + 1;
      INSERT INTO SCORECARD_PROCESS_LOG
        (SCD_PROCESS_LOG_SEQ,
         SCD_PROCESS_NAME,
         DML_ORACLE_ID,
         DML_TMSTMP,
         SCD_PROCESS_LINE,
         SCD_PROCESS_TEXT)
      VALUES
        (gvnLogSeq, gcvPgmName, pivUserId, SYSDATE, gviLogLine, gvvErrStr);
      COMMIT;
  END procMaintSCDOrgs; -- Procedure procMaintSCDOrgs
END scdMaintSCDOrgs; -- Package Body scdMaintSCDOrgs
/
