CREATE OR REPLACE PROCEDURE KILL_SESSION_PRC AS 
CURSOR P_CURSOR IS 
select SID,SERIAL#  from  v$session where sid in (select session_id from (SELECT LPAD(' ',DECODE(l.xidusn,0,3,0)) || l.oracle_username "User Name",
o.owner, o.object_name, o.object_type,l.session_id
FROM v$locked_object l, dba_objects o
WHERE l.object_id = o.object_id
ORDER BY o.object_id, 1 desc));

V_CURSOR P_CURSOR%ROWTYPE;
BEGIN
OPEN P_CURSOR;
LOOP
FETCH P_CURSOR INTO V_CURSOR;
EXIT WHEN P_CURSOR% NOTFOUND;
EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '||''''||V_CURSOR.SID||','||V_CURSOR.SERIAL#||'''';
END LOOP;
CLOSE P_CURSOR;
END;