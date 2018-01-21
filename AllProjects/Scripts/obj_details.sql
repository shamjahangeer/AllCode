-- This script generates the list of all constraints/indexes of a given table.

SET VERI OFF

SET LINES 200
SET PAGES 2000

COLUMN "Column"    FORMAT A30
COLUMN "Type"      FORMAT A4
COLUMN "Tab Owner" FORMAT A16
COLUMN "Table"     FORMAT A35 
BREAK ON "Tab Owner" ON table_name ON constraint_type SKIP 1

PROMPT Table Details

SELECT ats.owner          "Tab Owner"
     , ats.table_name     "Table"
     , ats.num_rows       "#Rows"
     , ats.last_analyzed  "Analyzed"
     , ac.constraint_name "Constraint"
     , ac.constraint_type "Type"
     , ac.status          "Status"
     , ac.position        "Pos"
     , ac.column_name     "Column" 
     , ats.tablespace_name
FROM   all_tables ats
     , (
       SELECT ac.owner
            , ac.table_name
            , ac.status
            , ac.constraint_type
            , ac.constraint_name
            , acc.position
            , acc.column_name
       FROM   all_cons_columns acc
            , all_constraints  ac
       WHERE  ac.constraint_type <> 'C'
       AND    ac.owner            = acc.owner
       AND    ac.table_name       = acc.table_name
       AND    ac.constraint_name  = acc.constraint_name
       ) ac
WHERE  UPPER(ats.table_name) IN UPPER('&&tbl_name')
AND    ats.owner              = UPPER('&&Enter_owner')
AND    ats.owner              = ac.owner      (+)
AND    ats.table_name         = ac.table_name (+)
ORDER BY ats.owner, ats.table_name, ac.status, ac.constraint_type, ac.constraint_name, ac.position;

PROMPT Index Details

COLUMN "Ind Type"  FORMAT A21
COLUMN "Index"     FORMAT A30
COLUMN "Pos"       FORMAT 999 
BREAK ON table_name ON "Ind Type" ON "Index" SKIP 1

SELECT aii.table_owner     "Tab Owner"
     , ai.table_name       "Table"
     , ai.index_type       "Ind Type"
     , ai.status           "Status"
     , ai.index_name       "Index"
     , aii.column_position "Pos"
     , aii.column_name     "Column"
     , ai.last_analyzed    "Analyzed"
     , ai.tablespace_name
FROM   all_indexes ai, all_ind_columns aii
WHERE  UPPER(aI.table_name) IN UPPER('&&tbl_name')
AND    ai.owner              = UPPER('&&Enter_owner')
AND    ai.table_name         = aii.table_name
AND    ai.owner              = aii.index_owner
AND    ai.owner              = aii.table_owner
AND    ai.index_name         = aii.index_name
ORDER BY aii.table_owner, ai.tablespace_name, ai.table_name, ai.status, ai.index_name, aii.column_position;

CLEAR COLUMNS BREAKS

UNDEFINE tbl_name
UNDEFINE Enter_owner

