create user ciadmin identified by ciadmin  default tablespace leapstone_128k_dat temporary tablespace temp;
create user cmadmin identified by cmadmin  default tablespace leapstone_128k_dat temporary tablespace temp;
create user ciarch identified by ciarch default tablespace leapstone_1m_ciarc temporary tablespace temp;
create user cmarch identified by cmarch default tablespace leapstone_1m_cmarc temporary tablespace temp;
create user ceidb identified by ceidb default tablespace leapstone_1m_ceidb temporary tablespace temp;

grant connect, create session,resource to ciarch;
grant connect, create session,resource to cmarch;
grant connect, create session,resource,create database link to ciadmin;
grant connect, create session,create database link ,resource,create trigger to cmadmin;
GRANT QUERY REWRITE TO ciadmin;
GRANT QUERY REWRITE TO cmadmin;
GRANT CREATE SYNONYM to ciadmin;
GRANT CREATE SYNONYM to cmadmin;
GRANT CREATE PUBLIC SYNONYM to ciadmin,cmadmin;
grant connect, create session,create database link ,resource,create trigger to ceidb;

grant select on pending_trans$ to public;
grant select on dba_2pc_pending to public;
grant select on dba_pending_transactions to public;
grant execute on dbms_system to ciadmin,cmadmin;

alter user ciadmin QUOTA UNLIMITED ON  EAMS_MOT_128K_DAT;
alter user ciadmin QUOTA UNLIMITED ON  EAMS_MOT_128K_IDX;
grant select on dBA_ROLE_PRIVS to public;

grant connect, create session,resource to ciarch;
grant connect, create session,resource to cmarch;
grant connect, create session,resource,create database link to ciadmin;
grant connect, create session,create database link ,resource,create trigger to cmadmin;

grant create session, alter session, create procedure, create table, create view, select any table to ciadmin,cmadmin,ceidb;
grant select any dictionary to ciadmin,cmadmin;
grant create sequence to ciadmin,cmadmin;

-- granting privileages required for Data Management
execute dbms_java.grant_permission( upper('CIADMIN'), 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,delete,execute' );
execute dbms_java.grant_permission( upper('CIADMIN'), 'SYS:java.lang.RuntimePermission', 'readFileDescriptor', NULL );
execute dbms_java.grant_permission( upper('CIADMIN'), 'SYS:java.lang.RuntimePermission', 'writeFileDescriptor', NULL );
execute dbms_java.grant_permission( upper('CIADMIN'), 'SYS:java.util.PropertyPermission', '<<ALL FILES>>', 'read,write,execute' );
commit;
execute dbms_java.grant_permission( upper('CMADMIN'), 'SYS:java.io.FilePermission', '<<ALL FILES>>', 'read,write,delete,execute' );
execute dbms_java.grant_permission( upper('CMADMIN'), 'SYS:java.lang.RuntimePermission', 'readFileDescriptor', NULL );
execute dbms_java.grant_permission( upper('CMADMIN'), 'SYS:java.lang.RuntimePermission', 'writeFileDescriptor', NULL );
execute dbms_java.grant_permission( upper('CMADMIN'), 'SYS:java.util.PropertyPermission', '<<ALL FILES>>', 'read,write,execute' );
commit;
