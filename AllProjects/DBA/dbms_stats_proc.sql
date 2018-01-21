To create a statistics on the Schema
----------------------------------------------------------------------------

BEGIN
 dbms_stats.gather_schema_stats (
     ownname          => 'CIADMIN', 
     estimate_percent => dbms_stats.auto_sample_size,
     cascade          =>true,     
     method_opt       => 'FOR ALL INDEXED COLUMNS AUTO',
     degree           => 34 
   );

WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);   
END;
/


To schedule a Job
------------------------------------------------------------------------------------------------------
dbms_scheduler.create_job (  
job_name            => 'TEST_JOB',  
job_type            => 'PLSQL_BLOCK',  
job_action          => 'BEGIN
						dbms_stats.gather_schema_stats (
						ownname          => ''CIADMIN'', 
						estimate_percent => dbms_stats.auto_sample_size,
						cascade          =>true,     
						method_opt       => ''FOR ALL INDEXED COLUMNS AUTO'',
						degree           => 34 
						);
						WHEN OTHERS THEN
						DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_STACK);   
						END;',  
number_of_arguments => 0,  
start_date          => sysdate +1/24/59, -- sysdate + 1 minute  
job_class           => 'ADMIN',  -- Priority Group  
enabled             => TRUE,  
auto_drop           => TRUE,  
comments            => 'Testrun');

---------------------------------------------------------------------------------------------------------------

BEGIN
    ---Creating the schedular
    dbms_scheduler.create_job (  
    job_name            => 'Archival_JOB4',  
    job_type            => 'PLSQL_BLOCK',  
    job_action          => 'BEGIN
                            CIADMIN.CIARCH_ARCHIVING_PRC;   
                            END;',  
    number_of_arguments => 0,  
    start_date          =>NULL,
    repeat_interval   =>'trunc(systimestamp) + 7',
    enabled             => TRUE,  
    auto_drop           => FALSE,  
    comments            => 'Runtime: Run at 6pm every Sunday');
END;
/
------------------------------------------------------------------------------------------------------------


To check whether the schedular is succeeded or not
-----------------------------------------------------------------------------------------------------

SELECT JOB_NAME, STATE FROM DBA_SCHEDULER_JOBS
WHERE JOB_NAME = 'TEST_JOB';


To find any error in the schedular
-----------------------------------------------------------------------------------------------------

SELECT * FROM DBA_SCHEDULER_JOB_RUN_DETAILS ORDER BY LOG_DATE DESC;


To Manually run a job
---------------------------------------------------------------------------------------------------------
BEGIN
  DBMS_SCHEDULER.run_job (job_name            => 'TEST_JOB',                          use_current_session => TRUE);
END;

To Drop a Job
------------------------------------------------------------------------------------------------------------
BEGIN
DBMS_SCHEDULER.DROP_JOB ('TEST_JOB');
END;
/




select num_rows,blocks,empty_blocks,AVG_SPACE,avg_row_len,chain_cnt,AVG_SPACE_FREELIST_BLOCKS ,NUM_FREELIST_BLOCKS
SAMPLE_SIZE,LAST_ANALYZED,GLOBAL_STATS,USER_STATS from dba_tables
where table_name='EAMS_PUBLISH_PACKAGE';



select  BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS,AVG_LEAF_BLOCKS_PER_KEY,AVG_DATA_BLOCKS_PER_KEY,CLUSTERING_FACTOR,
SAMPLE_SIZE,to_char(LAST_ANALYZED,'dd-mon-yyyy'),GLOBAL_STATS,USER_STATS,PCT_DIRECT_ACCESS
from dba_indexes
WHERE TABLE_NAME='EAMS_INGEST_PACKAGE' AND TABLE_OWNER='CIADMIN'
 

 
 
	  
	  
	  
	  
--what stistics are stored in db

http://www.idevelopment.info/data/Oracle/DBA_tips/Tuning/TUNING_17.shtml#Whatgetscollected