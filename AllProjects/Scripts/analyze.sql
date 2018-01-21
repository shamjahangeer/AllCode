-- This script analyzes a given table

SET VERI OFF TIMING ON

BEGIN
   DBMS_STATS.GATHER_TABLE_STATS(USER, '&Table_name', estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );
END;
/
