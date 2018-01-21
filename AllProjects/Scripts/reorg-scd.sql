SET TIMING ON TIME ON LINES 200 PAGES 200 VERI OFF
SET SERVEROUTPUT ON 

SPOOL C:\scd-reorg APPEND

DECLARE

 v_msg VARCHAR2(200);
 v_txt VARCHAR2(2000);
 v_ts1 VARCHAR2(200) := 'DBA_DATA_D';
 v_ts2 VARCHAR2(200) := 'SCD_DATA_B_20M';  --  'SCD_DATA_D';
 v_ts3 VARCHAR2(200) := 'SCD_INDEX_B_10M'; --  'SCD_INDEX_D';

BEGIN

   DBMS_OUTPUT.ENABLE(NULL);
   FOR tab_rec IN ( SELECT table_name FROM user_tables WHERE table_name IN ('&Table_name') )
   LOOP
      
      v_txt := NULL;
      v_msg:= 'Moving table: '||TAB_REC.table_name||' into '||v_ts1;
      BEGIN
         v_txt := 'ALTER TABLE '|| TAB_REC.table_name||' MOVE TABLESPACE '|| v_ts1;
         EXECUTE IMMEDIATE v_txt;
      EXCEPTION 
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_msg||SQLERRM);
      END;
      DBMS_OUTPUT.PUT_LINE(v_msg);
      v_msg:= NULL;

      v_txt := NULL;
      v_msg:= 'Moving table: '||TAB_REC.table_name||' into '||v_ts2;
      BEGIN
         v_txt := 'ALTER TABLE '|| TAB_REC.table_name||' MOVE TABLESPACE '|| v_ts2;
         EXECUTE IMMEDIATE v_txt;
      EXCEPTION 
         WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(v_msg||SQLERRM);
      END;
      DBMS_OUTPUT.PUT_LINE(v_msg);
      v_msg:= NULL;
      
      FOR ind_rec IN (SELECT index_name FROM user_indexes WHERE table_name = TAB_REC.table_name )
      LOOP
         v_txt := NULL;
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
      END LOOP;  -- ind_rec
      DBMS_OUTPUT.PUT_LINE(v_msg);
      v_msg:= NULL;

      v_txt := NULL;
      v_msg:= 'Analyze table: '||TAB_REC.table_name;
      v_txt := 'ANALYZE TABLE '|| TAB_REC.table_name||' ESTIMATE STATISTICS SAMPLE 30 PERCENT';
      EXECUTE IMMEDIATE v_txt;

   END LOOP;  -- tab_rec
   
END;
/

SPOOL OFF