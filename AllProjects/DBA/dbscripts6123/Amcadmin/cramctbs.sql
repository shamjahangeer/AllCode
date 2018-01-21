--- &1: Path to the datafile
--- &2: ORACLE_SID or DB_NAME
set termout on
set echo on
set feedback on
spool crmkctbs
create tablespace AMC_DATA_TBS logging datafile
'&1/&2/amc_data_tbs_1.dbf'
size 100M reuse autoextend on next 10M
extent management LOCAL SEGMENT SPACE MANAGEMENT AUTO
;
create tablespace AMC_INDEX_TBS logging datafile
'&1/&2/amc_index_tbs_1.dbf'
size 100M reuse autoextend on next 10M
extent management LOCAL SEGMENT SPACE MANAGEMENT AUTO
;