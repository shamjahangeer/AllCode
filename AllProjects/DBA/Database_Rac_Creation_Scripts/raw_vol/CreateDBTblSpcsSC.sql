--connect SYS/change_on_install as SYSDBA
set echo on
spool /opt/db01/app/oracle/admin/sc01d1qf/create/CreateDBTblSpcs.log

DROP TABLESPACE "CCE_CUSTOMER_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_CUSTOMER_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_customer_data' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 500M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SUBSCRIBER_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SUBSCRIBER_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_data_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

ALTER TABLESPACE "CCE_SUBSCRIBER_DATA"
  ADD DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_data_02' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M;

DROP TABLESPACE "CCE_SUBSCRIBER_SCG_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SUBSCRIBER_SCG_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_scg_data_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

ALTER TABLESPACE "CCE_SUBSCRIBER_SCG_DATA"
  ADD DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_scg_data_02' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M;

DROP TABLESPACE "CCE_RESOURCE_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_RESOURCE_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_resource_data' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 500M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SERVICE_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SERVICE_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_service_data' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 500M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SYS_COMP_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SYS_COMP_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_cce_sys_comp_data' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 500M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_LOG_DATA" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_LOG_DATA"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_log_data_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

ALTER TABLESPACE "CCE_LOG_DATA"
  ADD DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_log_data_02' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M;

DROP TABLESPACE "CCE_CUSTOMER_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_CUSTOMER_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_customer_index' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 250M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SUBSCRIBER_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SUBSCRIBER_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_index_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SUBSCRIBER_SCG_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SUBSCRIBER_SCG_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_sub_scg_index_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_RESOURCE_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_RESOURCE_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_resource_index' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 250M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SERVICE_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SERVICE_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_service_index' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 250M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_SYS_COMP_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_SYS_COMP_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_cce_sys_comp_index' SIZE 100M REUSE AUTOEXTEND ON NEXT  10M MAXSIZE 250M EXTENT MANAGEMENT LOCAL;

DROP TABLESPACE "CCE_LOG_INDEX" INCLUDING CONTENTS;
CREATE TABLESPACE "CCE_LOG_INDEX"
  LOGGING DATAFILE '/opt/db02/oradata/sc01d1qf/db_sc01d1qf_log_index_01' SIZE 100M REUSE AUTOEXTEND ON NEXT  100M MAXSIZE 2000M EXTENT MANAGEMENT LOCAL;

spool off
exit;
