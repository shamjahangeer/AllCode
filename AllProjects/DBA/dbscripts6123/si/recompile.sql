-- Compile all invalid objects
    set head off
    set pagesize 0
    set echo off
    set verify off
    set feedback off
    set termout off

    spool recomp_ora_objects.sql

    SELECT 'ALTER '||
           decode(object_type, 'PACKAGE BODY', 'PACKAGE',
                  object_type) || ' ' ||
           object_name||' compile' ||
           decode(object_type, 'PACKAGE BODY', ' BODY') || ';' 
      FROM user_objects
     WHERE status = 'INVALID'
       and object_name not like 'BIN$%'
       and object_type in ( 'PACKAGE',
                            'PACKAGE BODY',
                            'PROCEDURE',
                            'VIEW',
                            'TRIGGER' )
    /

    spool off

    set feedback on
    set echo on
    set termout on

    spool recomp_ora_objects.lst

    @recomp_ora_objects.sql

    spool off