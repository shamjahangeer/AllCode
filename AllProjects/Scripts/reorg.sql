-- Use this script to reorg a table
-- DO NOT USE THIS FOR SCD Schema

SET TIMING ON TIME ON LINES 200 PAGES 200 VERI OFF
SET SERVEROUTPUT ON 

-- ==========================================================================================================

DECLARE

 v_msg VARCHAR2(200);
 v_txt VARCHAR2(2000);
 v_ts1 VARCHAR2(200) := '&v_ts1';
 v_ts3 VARCHAR2(200) := '&v_ts3';

BEGIN

   DBMS_OUTPUT.ENABLE(NULL);
   FOR tab_rec IN ( SELECT table_name FROM user_tables WHERE  table_name = '&table_name' )
   LOOP
      
      v_msg:= 'Moving table: '||TAB_REC.table_name||' into '||v_ts1;
      BEGIN
         v_txt := 'ALTER TABLE '|| TAB_REC.table_name||' MOVE ';
         EXECUTE IMMEDIATE v_txt;
      EXCEPTION 
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_msg||SQLERRM);
      END;
      DBMS_OUTPUT.PUT_LINE(v_msg);
      v_msg:= NULL;

      FOR ind_rec IN (SELECT index_name FROM user_indexes WHERE table_name = TAB_REC.table_name AND index_type NOT IN ('DOMAIN', 'LOB') )
      LOOP
         v_msg:= 'Rebuilding Index: '||IND_REC.index_name||' into '||v_ts3;
         BEGIN
            v_txt := 'ALTER INDEX '|| IND_REC.index_name||' REBUILD TABLESPACE '|| v_ts3||' PARALLEL 4';
            EXECUTE IMMEDIATE v_txt;

            v_txt := 'ALTER INDEX '|| IND_REC.index_name||' NOPARALLEL';
            EXECUTE IMMEDIATE v_txt;

         EXCEPTION 
            WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE(v_msg||SQLERRM);
         END;         
         DBMS_OUTPUT.PUT_LINE(v_msg);
         v_msg:= NULL;
      END LOOP;  -- ind_rec

      v_msg:= 'Analyze table: '||TAB_REC.table_name;
      DBMS_STATS.GATHER_TABLE_STATS(USER, TAB_REC.table_name, estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );

   END LOOP;  -- tab_rec
   
END;
/
