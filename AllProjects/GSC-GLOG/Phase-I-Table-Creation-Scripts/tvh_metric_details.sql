REM This Script contains the following:
REM 1. Drop Table Statement
REM 2. Table creation script
REM 3. Comments
REM 4. Adding Constraints
REM 5. Public Synonym
REM 6. Sequence creation script to populate Primary Key
REM 7. Grants
REM 8. DB Trigger to populate Primary Key AND aduit columns
REM 9. Analyze Table

-- ==========================================================================================================

PROMPT DROP TABLE TVH_METRIC_DETAILS

DROP TABLE GSC.TVH_METRIC_DETAILS PURGE;

-- ================================================================================================================

PROMPT CREATE TABLE TVH_METRIC_DETAILS

CREATE TABLE TVH_METRIC_DETAILS
( TVH_METRIC_DETAIL_ID  NUMBER(10)   NOT NULL
, KPI_CDE                VARCHAR2(4)  NOT NULL
, KPI_METRIC_CDE         VARCHAR2(4)  NOT NULL
, REGION_ORGANIZATION_ID VARCHAR2(4)  NOT NULL
, FISCAL_YEAR_ID         NUMBER(4)    NOT NULL
, FISCAL_QUARTER_ID      NUMBER(2)
, FISCAL_MONTH_ID        NUMBER(2)
, METRIC_AMT             NUMBER       NOT NULL
, DML_USER_ID            VARCHAR2(30) NOT NULL
, DML_TS                 DATE         NOT NULL );

COMMENT ON TABLE GSC.TVH_METRIC_DETAILS                         IS 'Contains TVH (Total Kilos Handled) Metrics.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.TVH_METRIC_DETAIL_ID  IS 'Identifies a TVH Metric detail record.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.KPI_CDE 		 IS 'KPI Code that the Metric is associated to - ie TVH.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.KPI_METRIC_CDE	 IS 'Code that identifies the Metric - ie VH.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.REGION_ORGANIZATION_ID IS 'Identifies the Region Metric applies to.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.FISCAL_YEAR_ID	 IS 'Identifies the Fiscal Year that the Metric applies to.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.FISCAL_QUARTER_ID	 IS 'Identifies a Fiscal Quarter.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.FISCAL_MONTH_ID	 IS 'Identifies a Fiscal Month.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.METRIC_AMT 		 IS 'The actual data value.';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.DML_USER_ID		 IS 'User ID of the person who updated the record last';
COMMENT ON COLUMN GSC.TVH_METRIC_DETAILS.DML_TS 		 IS 'Date record was last updated';

-- ==========================================================================================================
PROMPT CREATE Primary key Constaint ON TVH_METRIC_DETAILS

ALTER TABLE GSC.TVH_METRIC_DETAILS
   ADD CONSTRAINT TVH_METRIC_DETAILS_PK 
   PRIMARY KEY (TVH_METRIC_DETAIL_ID) 
   USING INDEX TABLESPACE GSC_INDEX_A;

PROMPT CREATE Unique key Constaint ON TVH_METRIC_DETAILS

ALTER TABLE GSC.TVH_METRIC_DETAILS
   ADD CONSTRAINT TVH_METRIC_DETAILS_UK1 
   UNIQUE (KPI_CDE, 
           KPI_METRIC_CDE, 
           REGION_ORGANIZATION_ID, 
           FISCAL_YEAR_ID, 
           FISCAL_QUARTER_ID, 
           FISCAL_MONTH_ID) 
   USING INDEX TABLESPACE GSC_INDEX_A;

PROMPT CREATE Foreign key Constaint ON TVH_METRIC_DETAILS

ALTER TABLE GSC.TVH_METRIC_DETAILS
   ADD CONSTRAINT TVH_METRIC_DETAILS_FK1 
   FOREIGN KEY (KPI_CDE, KPI_METRIC_CDE) 
   REFERENCES KPI_METRICS (KPI_CDE, OPERATIONS_METRIC_CDE);
   
-- ==========================================================================================================

PROMPT Create public Synonym

DROP PUBLIC SYNONYM TVH_METRIC_DETAILS;

CREATE PUBLIC SYNONYM TVH_METRIC_DETAILS 
   FOR GSC.TVH_METRIC_DETAILS;

-- ==========================================================================================================

PROMPT Grants/Privileges

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES
   ON GSC.TVH_METRIC_DETAILS
   TO GSC_ADMIN
   WITH GRANT OPTION;
   
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES
   ON GSC.TVH_METRIC_DETAILS
   TO GSC_SOURCE, GSC_WEB;
   
GRANT SELECT, INSERT, UPDATE, DELETE
   ON GSC.TVH_METRIC_DETAILS
   TO GSC_PRODUCTION_ROLE;

-- ==========================================================================================================

PROMPT Create sequence 

DROP SEQUENCE GSC.TVH_METRIC_DETAILS_SEQ;

CREATE SEQUENCE GSC.TVH_METRIC_DETAILS_SEQ
START WITH 1
MAXVALUE 999999999999999999999999999
MINVALUE 1
NOCYCLE
NOCACHE
NOORDER;

DROP PUBLIC SYNONYM TVH_METRIC_DETAILS_SEQ;

CREATE PUBLIC SYNONYM TVH_METRIC_DETAILS_SEQ FOR GSC.TVH_METRIC_DETAILS_SEQ;

GRANT SELECT ON TVH_METRIC_DETAILS_SEQ TO GSC_SOURCE, GSC_WEB;

-- ==========================================================================================================
PROMPT Create DB Trigger to populate primary key and audit columns

CREATE OR REPLACE TRIGGER TVH_METRIC_DETAILS_AUDIT_BIU
BEFORE INSERT OR UPDATE
ON GSC.TVH_METRIC_DETAILS
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

   -- Database Trigger to pre-populate the Primary Key, Audit columns
   
DECLARE
 V_TVH_METRIC_DETAIL_ID NUMBER := 0;
 
BEGIN

   :NEW.dml_ts      := SYSDATE ;
   :NEW.dml_user_id := USER ;
   
   IF INSERTING THEN
      IF :NEW.TVH_METRIC_DETAIL_ID IS NULL THEN
         SELECT TVH_METRIC_DETAILS_SEQ.NEXTVAL
         INTO   V_TVH_METRIC_DETAIL_ID
         FROM   DUAL;
         :NEW.TVH_METRIC_DETAIL_ID := v_TVH_metric_detail_id;
      END IF;
   END IF;
   
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END TVH_METRIC_DETAILS_AUDIT_BIU;
/

-- ==========================================================================================================

PROMPT Analyze Table

BEGIN
   DBMS_STATS.GATHER_TABLE_STATS(USER, 'TVH_METRIC_DETAILS', estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );
END;
/

-- ==========================================================================================================