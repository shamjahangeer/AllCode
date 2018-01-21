-- Use this script to get the table size

SET VERI OFF LINES 200 PAGES 50 TIMING ON

COLUMN type       FORMAT A6
COLUMN table_name FORMA  A30
COLUMN size_meg   FORMAT 9999999

SELECT tbl.type, tbl.tablespace_name, ue.segment_name table_name, SUM(ue.bytes)/(1024*1024) size_meg 
FROM   user_extents ue
     , (
       SELECT 'Table' type, table_name table_name, tablespace_name FROM user_tables  WHERE table_name = UPPER('&&table_name')
       UNION ALL
       SELECT 'Index' type, index_name table_name, tablespace_name FROM user_indexes WHERE table_name = UPPER('&&table_name')
       ) tbl
WHERE  ue.segment_name = tbl.table_name
GROUP BY tbl.type, tbl.tablespace_name, ue.segment_name
ORDER BY 1,2, 3;

UNDEFINE table_name

