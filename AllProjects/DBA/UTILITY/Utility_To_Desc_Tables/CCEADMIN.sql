spool /tmp/ciadmin_tables_desc.lst

Prompt Creating external directory and granting read and write permission on ciadmin.
--Below statement should Run as sysdba

create or replace directory ext_dir as '/tmp'
/
grant read, write on directory ext_dir to ciadmin
/

Prompt Creating table ext_table_csv  as ciadmin

create table ext_table_csv (
TNAME    Varchar2(50)
)
organization external (
  type              oracle_loader
  default directory ext_dir
  access parameters (
    records delimited  by newline
    fields  terminated by ','
    missing field values are null
  )
  location ('CMTABLES.CSV')
)
reject limit unlimited
/

spool off;
