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

PROMPT DROP TABLE GLOG_METRIC_DETAILS_STG

DROP TABLE GLOG_METRIC_DETAILS_STG PURGE;

-- ================================================================================================================

PROMPT CREATE TABLE GLOG_METRIC_DETAILS_STG

CREATE TABLE GLOG_METRIC_DETAILS_STG
( KPI_CDE                     VARCHAR2(4)  NOT NULL
, KPI_METRIC_CDE              VARCHAR2(4)  NOT NULL
, REGION_ORGANIZATION_ID      VARCHAR2(4)  NOT NULL
, PROFIT_CENTER_GROUP_ID      VARCHAR2(10)
, PROFIT_CENTER_ABBR_NM       VARCHAR2(3)
, FISCAL_YEAR_ID              NUMBER(4)    
, FISCAL_QUARTER_ID           NUMBER(2)
, FISCAL_MONTH_ID             NUMBER(2)
-- , TOTAL_SCHEDULES_SHIPPED_AMT NUMBER(5)
, METRIC_AMT                  NUMBER       NOT NULL
, DML_USER_ID                 VARCHAR2(30) NOT NULL
, DML_TS                      DATE         NOT NULL );

COMMENT ON TABLE GSC.GLOG_METRIC_DETAILS_STG                              IS 'Stage table to contain GLOG Metrics data.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.KPI_CDE 		          IS 'KPI Code that the GLOG Metric Stage record associated to.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.KPI_METRIC_CDE	          IS 'Code that identifies the GLOG Metric Stage record Metric - ie CPL.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.REGION_ORGANIZATION_ID      IS 'Identifies the Region GLOG Metric Stage record applies to.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.PROFIT_CENTER_GROUP_ID      IS 'Identifies the Profit Center Group of GLOG Metric Stage record.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.PROFIT_CENTER_ABBR_NM       IS 'Specifies the Mge Profit Center Abbr Name of GLOG Metric Stage record.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.FISCAL_YEAR_ID	          IS 'Identifies the Fiscal Year that the GLOG Metric Stage record applies to.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.FISCAL_QUARTER_ID	          IS 'Identifies a Fiscal Quarter of the GLOG Metric Stage record.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.FISCAL_MONTH_ID	          IS 'Identifies a Fiscal Month of GLOG Metric Stage record .';
-- COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.TOTAL_SCHEDULES_SHIPPED_AMT IS 'The Total Schedules Shipped Amount of GLOG Metric Stage record.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.METRIC_AMT 		  IS 'The actual data value of a GLOG Metric Stage record.';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.DML_USER_ID		  IS 'User ID of the person who updated the record last';
COMMENT ON COLUMN GSC.GLOG_METRIC_DETAILS_STG.DML_TS 		          IS 'Date record was last updated';

-- ==========================================================================================================
PROMPT CREATE Unique key Constaint ON GLOG_METRIC_DETAILS_STG

ALTER TABLE GLOG_METRIC_DETAILS_STG
   ADD CONSTRAINT GLOG_METRIC_DETAILS_STG_UK1 
   UNIQUE (KPI_CDE, 
           KPI_METRIC_CDE, 
           REGION_ORGANIZATION_ID, 
           FISCAL_YEAR_ID, 
           FISCAL_QUARTER_ID, 
           FISCAL_MONTH_ID) 
   USING INDEX TABLESPACE GSC_INDEX_A;

-- ==========================================================================================================

PROMPT Create public Synonym

DROP PUBLIC SYNONYM GLOG_METRIC_DETAILS_STG;

CREATE PUBLIC SYNONYM GLOG_METRIC_DETAILS_STG 
   FOR GLOG_METRIC_DETAILS_STG;

-- ==========================================================================================================

PROMPT Grants/Privileges

GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES
   ON GLOG_METRIC_DETAILS_STG
   TO GSC_ADMIN
   WITH GRANT OPTION;
   
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES
   ON GLOG_METRIC_DETAILS_STG
   TO GSC_SOURCE, GSC_WEB;
   
GRANT SELECT, UPDATE    
   ON GLOG_METRIC_DETAILS_STG
   TO DCMS_SQL;
   
GRANT SELECT, INSERT, UPDATE, DELETE
   ON GLOG_METRIC_DETAILS_STG
   TO GSC_PRODUCTION_ROLE;

-- ==========================================================================================================
PROMPT Create DB Trigger to populate primary key and audit columns

CREATE OR REPLACE TRIGGER GLOG_METRIC_DTL_STG_AUDIT_BIU
BEFORE INSERT OR UPDATE
ON GLOG_METRIC_DETAILS_STG
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW

   -- Database Trigger to pre-populate the Audit columns
   
BEGIN

   :NEW.dml_ts      := SYSDATE ;
   :NEW.dml_user_id := USER ;
   
EXCEPTION
   WHEN OTHERS THEN
      RAISE;
END GLOG_METRIC_DTL_STG_AUDIT_BIU;
/

-- ==========================================================================================================

PROMPT Analyze Table

BEGIN
   DBMS_STATS.GATHER_TABLE_STATS(USER, 'GLOG_METRIC_DETAILS_STG', estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );
END;
/

-- ==========================================================================================================