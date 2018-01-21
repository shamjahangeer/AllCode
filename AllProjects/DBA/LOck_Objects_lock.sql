SET feed off markup html on spool on
SPOOL Debug_On_Objects_Lock.xls;

select a.sid, a.serial#, a.username, b.sql_text
from v$session a, v$sqlarea b
where a.sql_address=b.address;

select blocking_session,sid,serial#,wait_class,seconds_in_wait
from
v$session a
where
blocking_session is not NULL
order by
blocking_session;

select 
  oracle_username
  os_user_name,
  locked_mode,
  object_name,
  object_type
from 
  v$locked_object a,dba_objects b
where 
  a.object_id = b.object_id;

  SPOOL off;
SET markup html off spool off;