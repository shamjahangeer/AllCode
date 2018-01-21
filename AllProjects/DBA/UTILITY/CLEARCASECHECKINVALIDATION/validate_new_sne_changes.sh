#!/usr/bin/ksh

TEST_HOME=`dirname $0`

SCRIPT_DIR=${TEST_HOME}/sne_1/db/scripts
SNE_TAR=${TEST_HOME}/new_sne_files.tar
CHANGED_FILES=${TEST_HOME}/sne_changed_files.lst

tar tvf $SNE_TAR | awk '{print $9}' > $CHANGED_FILES
CHANGED_FILES_STR=`cat $CHANGED_FILES`

echo "New/Changed Scripts"
echo "---------------------------------"
echo "$CHANGED_FILES_STR\n"

cd $SCRIPT_DIR
chmod -R u+rw $SCRIPT_DIR/
tar xvf $SNE_TAR

#
# Test environment validation
#

if [[ ! -a "${TEST_HOME}/sne_properties" ]] then 
   print "Property file ${TEST_HOME}/sne_properties not found!"  
   exit 1 
else
   . $TEST_HOME/sne_properties
fi  

#
# Clean up the previous installed info
#

export ORACLE_HOME

CURRENT_DIR=`pwd`
mkdir -p $CURRENT_DIR/sne_db_install_logs

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF
  SET HEAD OFF
  SET PAGESIZE 0
  SET LINESIZE 120
  SET ECHO OFF
  SET VERIFY OFF
  SET TERMOUT OFF
  SET FEEDBACK OFF
  SET TIMING OFF
  SET TIME OFF
  SET TRIMOUT ON

  -- login as SNE
  connect $DB_USER/$DB_PASSWD@$DB_NAME
  SPOOL sne_db_install_logs/sne_db_global_name.lst   
  SELECT GLOBAL_NAME FROM GLOBAL_NAME;
  SPOOL OFF
EOF

SNE_DB_NAME=`cat sne_db_install_logs/sne_db_global_name.lst`
SNE_DB_NAME=`echo $SNE_DB_NAME | sed 's/ +$//'`

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF1
  CONNECT $CM_ADMIN/$CM_ADMIN_PWD@$DB_NAME
  -- SET SERVEROUTPUT ON 

  DECLARE
    l_cluster_id cce_cluster.cluster_id%TYPE;
  BEGIN
    BEGIN
      SELECT cluster_id
      INTO   l_cluster_id
      FROM   cce_cluster
      WHERE  cluster_name = '$SNE_INST_ID';
                  
      DELETE cce_cluster_db_info
      WHERE  cluster_id = l_cluster_id;
      
      dbms_output.put_line (SQL%ROWCOUNT||' records deleted from cce_cluster_db_info.');
              
      DELETE cce_cluster_sa_assoc
      WHERE  cluster_id = l_cluster_id;
      
      dbms_output.put_line (SQL%ROWCOUNT||' records deleted from cce_cluster_sa_assoc.');
                        
      DELETE cce_cluster
      WHERE  cluster_id = l_cluster_id;
      
      dbms_output.put_line (SQL%ROWCOUNT||' records deleted from cce_cluster.');  
      
      COMMIT;  
      
      EXCEPTION
        WHEN OTHERS THEN
             dbms_output.put_line ('No SNE entry found for SNE $SNE_INST_ID');  
    END;
  END;
  /

  DECLARE
    l_cluster_name CONSTANT VARCHAR2(80) := '$SNE_INST_ID';
  BEGIN
    EXECUTE IMMEDIATE 'BEGIN CCE_DP_MAINT#PKG.clean_cmsne(:in_cluster_name); END;' 
    USING l_cluster_name;
     
    EXCEPTION
      WHEN OTHERS THEN NULL;
  END;
  /  

  DECLARE
    TYPE obj_varchar_tab IS TABLE OF VARCHAR2(30);
     
    l_int INTEGER;
    l_stmt VARCHAR2(1024);
     
    l_tables obj_varchar_tab := obj_varchar_tab('CCE_SUBSET',
                                                'CCE_SCHD_JOB_ERR',
                                                'CCE_DATA_SCHEMA_SUBSET_ASSOC',
                                                'CCE_DB_INSTANCE',
                                                'CCE_REFRESH_GROUP',
                                                'CCE_REPL_COL_CHG',
                                                'CCE_REPL_SCRIPT_RUN',
                                                'CCE_DATA_SCHEMA',
                                                'CCE_REPL_SCRIPT',
                                                'CCE_REPL_TAB',
                                                'CCE_SCRIPT_BATCH',
                                                'CCE_SCHD_JOB_STEP',
                                                'CCE_SCHD_JOB_TRBL_SHNG',
                                                'CCE_SCHD_JOB_TYPE',
                                                'CCE_SCHD_JOB_RUN',
                                                'CCE_SCHD_JOB_RUN_DETAIL');

    l_sequences obj_varchar_tab := obj_varchar_tab('CCE_DATA_SCHEMA_ID_SEQ',
                                                   'CCE_REFRESH_GROUP_ID_SEQ',
                                                   'CCE_REPL_COL_CHG_ID_SEQ',
                                                   'CCE_REPL_SCRIPT_ID_SEQ',
                                                   'CCE_REPL_TAB_ID_SEQ',
                                                   'CCE_SCHD_JOB_RUN_ID_SEQ',
                                                   'CCE_SUBSET_ID_SEQ');

    l_packages obj_varchar_tab := obj_varchar_tab('CCE_SUBSET#PKG',
                                                  'CCE_REPL_COL_CHG#PKG',
                                                  'CCE_SCHD_JOB_STEP#PKG',
                                                  'CCE_SCHD_JOB_TRBL_SHNG#PKG',
                                                  'CCE_SCHD_JOB_TYPE#PKG',
                                                  'CCE_SCHD_JOB_RUN#PKG',
                                                  'CCE_SCHD_JOB_RUN_DETAIL#PKG',
                                                  'CCE_REPL_TAB#PKG',
                                                  'CCE_REPL_SCRIPT_RUN#PKG',
                                                  'CCE_REPL_SCRIPT#PKG',
                                                  'CCE_CLUSTER_DB_INFO#PKG',
                                                  'CCE_CLUSTER_SA_ASSOC#PKG',
                                                  'CCE_DATA_SCHEMA#PKG',
                                                  'CCE_DATA_SCHEMA_SUBSET#PKG',
                                                  'CCE_DB_INSTANCE#PKG',
                                                  'CCE_DP_MAINT#PKG',
                                                  'CCE_INSTALL#PKG',
                                                  'CCE_LIBRARY#PKG',
                                                  'CCE_MV_MAINT#PKG',
                                                  'CCE_REFRESH_GROUP#PKG',
                                                  'CCE_SCRIPT_BATCH#PKG');

  BEGIN
    SELECT 1
    INTO   l_int
    FROM   cce_cluster 
    WHERE  cluster_name != '$SNE_INST_ID'
    AND    cluster_type = 'SNE'
    AND    ROWNUM = 1;
     
    BEGIN  
      EXECUTE IMMEDIATE 'BEGIN CCE_INSTALL#PKG.uninstall_sne(:in_db_global_name, :in_sneadmin_username); END;'
      USING UPPER('$SNE_DB_NAME'), UPPER('$DB_USER');
         
      COMMIT;
       
      EXCEPTION
        WHEN OTHERS THEN NULL; 
    END;
     
    EXCEPTION
      WHEN NO_DATA_FOUND THEN 
           FOR i IN 1..l_tables.COUNT LOOP
               l_stmt:='DROP TABLE '||l_tables(i)||' CASCADE CONSTRAINTS';
               dbms_output.put_line(l_stmt);

               BEGIN
                 EXECUTE IMMEDIATE l_stmt;

                 EXCEPTION
                   WHEN OTHERS THEN
                        IF SQLCODE !=-942 THEN
                           RAISE;    
                        END IF;
               END;  
           END LOOP i;

           FOR j IN 1..l_sequences.COUNT LOOP
               l_stmt:='DROP SEQUENCE '||l_sequences(j);
               dbms_output.put_line(l_stmt);

               BEGIN
                 EXECUTE IMMEDIATE l_stmt;

                 EXCEPTION
                   WHEN OTHERS THEN
                        IF SQLCODE != -2289 THEN
                           RAISE;        
                        END IF;
               END;
           END LOOP j;

           FOR k IN 1..l_packages.COUNT LOOP
               l_stmt:='DROP PACKAGE '||l_packages(k);  
               dbms_output.put_line(l_stmt);

               BEGIN
                 EXECUTE IMMEDIATE l_stmt;

                 EXCEPTION
                   WHEN OTHERS THEN
                        IF SQLCODE !=-4043 THEN
                           RAISE;
                        END IF;
               END;
           END LOOP k;
  END;
  /
EOF1

$ORACLE_HOME/bin/sqlplus -s /nolog << EOF2
  CONNECT $DB_USER/$DB_PASSWD@$DB_NAME
  SET SERVEROUTPUT ON 

  CREATE OR REPLACE PROCEDURE cleanup_schema AS 
    l_trials INTEGER := 0;
    l_cluster_id INTEGER;
    l_cnt INTEGER;
    l_init_obj_count INTEGER;
    l_sql VARCHAR2(1024);

    FUNCTION any_objects RETURN BOOLEAN IS      
      l_obj_count INTEGER;
    BEGIN
      SELECT COUNT(*)
      INTO   l_obj_count
      FROM   user_objects
      WHERE  object_name != 'CLEANUP_SCHEMA';
      
      IF l_trials = 0 THEN 
         l_init_obj_count := l_obj_count;
      END IF;
      
      IF l_obj_count > 0 THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
    END any_objects;
    
    PROCEDURE drop_obj IS
    
    BEGIN
      FOR rec IN (SELECT * 
                  FROM   user_objects 
                  WHERE  object_type NOT IN ('PACKAGE BODY')
                  AND    object_name != 'CLEANUP_SCHEMA') LOOP
                  
          BEGIN      
            IF rec.object_type = 'TABLE' THEN
               EXECUTE IMMEDIATE 'DROP '||rec.object_type||' '||rec.object_name||' CASCADE CONSTRAINTS'; 
            ELSE
               EXECUTE IMMEDIATE 'DROP '||rec.object_type||' "'||rec.object_name||'"';
            END IF;
            
            EXCEPTION 
              WHEN OTHERS THEN NULL;               
          END;         
      END LOOP rec;
      
      EXECUTE IMMEDIATE 'PURGE RECYCLEBIN';    
    END drop_obj;
    
    PROCEDURE remove_dbms_job IS
    
      l_jobs INTEGER := 0;
      
    BEGIN
      FOR rec IN (SELECT * 
                  FROM   user_jobs) LOOP                
          dbms_job.remove(rec.job);    
          
          l_jobs := l_jobs + 1;
      END LOOP rec;
      
      COMMIT;
      
      dbms_output.put_line(l_jobs||' DBMS jobs have been cleaned up from schema '||USER||'.');
    END remove_dbms_job;
      
  BEGIN
    -- Make sure this script is called by passing wrong schema parameters so we clean up CMADMIN by accident.
    /*
    BEGIN   
      SELECT COUNT(*)
      INTO   l_cnt
      FROM   user_part_tables a
      WHERE  table_name IN ('CCE_ORDER_COUPON_ASSOC','CCE_ORDER_DETAILS','CCE_ORDER_GRANTS','CCE_ORDER_ITEM_DETAILS','CCE_ORDER_ITEM_PROMO_ASSOC','CCE_ORDER_NOTIFN_INFO','CCE_SUB_PROMO_ASSOC');
      
      IF l_cnt < 7 THEN
         raise_application_error(-20000, 'Schema '||USER||' is a NOT a SNEADMIN schema. Script cleanup_schema.sql can only be used to clean up SNEADMIN schemas!!!');         
      END IF;                 
    END;
    */

    -- Doublechecke and make sure this script is called by passing wrong schema parameters so we clean up cmadmin by accident.
    BEGIN   
      l_sql := 'SELECT a.cluster_id '||CHR(10)||
               'FROM   cce_data_schema a '||CHR(10)||
               'WHERE  a.schema_role = ''CM'' '||CHR(10)||
               'AND    a.schema_name = USER '||CHR(10)||
               'AND    a.db_instance_name = (SELECT GLOBAL_NAME FROM GLOBAL_NAME) ';
                
      EXECUTE IMMEDIATE l_sql INTO l_cluster_id;
       
      raise_application_error(-20000, 'Schema '||USER||' is a CMADMIN schema. Script cleanup_schema.sql cannot be used to clean up CM ADMIN schema!!!'); 

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL; 
        WHEN OTHERS THEN 
             IF SQLCODE != -942 THEN -- table or view does not exist
                RAISE;
             END IF;               
    END;
         
    remove_dbms_job;
    
    WHILE any_objects LOOP
          drop_obj;
          
          l_trials := l_trials + 1;
          
          IF l_trials > 10 THEN
             raise_application_error(-20000, 'The deinstaller is not able to clean up all objects in schema '||USER||'.'); 
          END IF;        
    END LOOP;
    
    dbms_output.put_line(l_init_obj_count||' objects have been cleaned up from schema '||USER||'.');  
  END;
  /

  exec cleanup_schema;

  DROP PROCEDURE cleanup_schema;
EOF2

#
# Run installer manually
#

$SCRIPT_DIR/snesetup.sh $CM_ADMIN $CM_ADMIN_PWD $CI_ADMIN $CI_ADMIN_PWD

