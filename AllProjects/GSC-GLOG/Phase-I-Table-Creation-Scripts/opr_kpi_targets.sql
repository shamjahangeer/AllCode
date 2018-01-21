
-- 12/26/2012

ALTER TABLE GSC.OPR_KPI_TARGETS
ADD ( COMMENTS VARCHAR2(100) );

BEGIN
   DBMS_STATS.GATHER_TABLE_STATS(USER, 'OPR_KPI_TARGETS', estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );
END;
/

