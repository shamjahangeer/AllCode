
spool si_pre_mig.lst


PROMPT Start Disabling ForeignKey Constraints***
EXEC subSMDisableRefCons;
PROMPT End Disabling ForeignKey Constraints***


exec CCE_DROP_TABLE_IF_EXISTS('tmp_cce_comp');

exec CCE_DROP_TABLE_IF_EXISTS('tmp_cce_comp_prop');
exec CCE_DROP_TABLE_IF_EXISTS('tmp_cce_comp_type_prop');
PROMPT Drop existing tmp_cce_user_capability table
exec CCE_DROP_TABLE_IF_EXISTS('tmp_cce_user_capability');

create table tmp_cce_comp
(comp_id number,
comp_name varchar2(100));

insert into tmp_cce_comp (select comp_id, comp_name from cce_component);

create table tmp_cce_comp_prop
(comp_name varchar2(100),
 field_enum_id number,
 field_value varchar2(150)
);

create table tmp_cce_comp_type_prop
(comp_type number,
 field_enum_id number,
 field_value varchar2(150)
);

Prompt create tmp_cce_user_capability table for backup
create table tmp_cce_user_capability
( USER_CAPABILITY_ID            NUMBER          NOT NULL,
  USER_CAPABILITY_NAME          VARCHAR2(75 BYTE) NOT NULL,
  PERMISSION                    VARCHAR2(30 BYTE) NOT NULL
);

insert into tmp_cce_Comp_prop (comp_name, field_enum_id, field_value) (select comp_name, b.field_enum_id, field_value
from cce_component_properties cp, cce_field_info b, cce_component c 
where cp.field_id= b.field_id and c.comp_id = cp.comp_id);

insert into tmp_cce_comp_type_prop (comp_type, field_enum_id, field_value) (select comp_type, b.field_enum_id, field_value
from cce_comp_type_properties cp, cce_field_info b
where cp.field_id= b.field_id);


PROMPT Taking backup of CCE_USER_CAPABILITY
insert into tmp_cce_user_capability(USER_CAPABILITY_ID, USER_CAPABILITY_NAME ,PERMISSION) 
(select USER_CAPABILITY_ID, USER_CAPABILITY_NAME ,PERMISSION 
from CCE_USER_CAPABILITY);

delete from CCE_FIELD_INFO;
delete from CCE_FIELD_LOV_ASSOC;
delete from CCE_FIELD_GROUP_FLD_ASSOC;
delete from CCE_LIST_OF_VALUES;
delete from CCE_COMP_TYPE;


delete from CCE_FIELD_GROUP_INFO;
delete from CCE_COMP_FIELD_GROUP_ASSOC; 

 
delete from CCE_USER_CAPABILITY;
delete from CCE_SECURITY_ROLE_CAP_ASSOC where security_role_id in (select security_role_id from cce_security_role where SYSTEM_DEFINED_IND=1);
delete from CCE_REPORT_USER_CAP_ASSOC;
delete from CCE_PRODUCT;
delete from CCE_PRODUCT_CAPABILITY_ASSOC;
 
delete from CCE_COMPONENT;
delete from CCE_COMP_LOG_LEVEL;
delete from CCE_COMPONENT_PROPERTIES ;
delete from CCE_COMP_TYPE_PROPERTIES ;
delete from CCE_COMPONENT_HA_INFO;
delete from CCE_EVENT_FILE_CONFIG_DATA;
delete from CCE_COMPONENT_OP_INFO;

delete from CCE_ENTITY_FIELD_INFO;
delete from CCE_USER_LOV;
delete from CCE_USER_FIELD_FLD_ASSOC;
delete from CCE_OBJ_FEATURE;
delete from CCE_OBJ_FEATURE_ASSOC;
delete from CCE_OBJ_FEATURE_FIELD_ASSOC;

drop sequence CCE_SEQ_FIELDSYS_FIELDID;
drop sequence CCE_SEQ_USRCAPAB_USRCAPABID;
drop sequence CCE_SEQ_COMP_COMPID;
drop sequence CCE_SEQ_FIELD_GROUP_FG_ID;

PROMPT Creating Sequence 'CCE_SEQ_FIELDSYS_FIELDID'
CREATE SEQUENCE CCE_SEQ_FIELDSYS_FIELDID
 INCREMENT BY 1
 START WITH 1
 MAXVALUE 49999
 MINVALUE 1
 NOCYCLE
 CACHE 40
 ORDER
/


PROMPT Creating Sequence 'CCE_SEQ_USRCAPAB_USRCAPABID'
CREATE SEQUENCE CCE_SEQ_USRCAPAB_USRCAPABID
 INCREMENT BY 1
 START WITH 1
 MAXVALUE 65535
 MINVALUE 1
 NOCYCLE
 CACHE 40
 ORDER
/

PROMPT Creating Sequence 'CCE_SEQ_FIELD_GROUP_FG_ID'
CREATE SEQUENCE CCE_SEQ_FIELD_GROUP_FG_ID
 INCREMENT BY 1
 START WITH 50000
 NOMAXVALUE
 MINVALUE 50000
 NOCYCLE
 CACHE 40
 ORDER
/

-- wireless
PROMPT Creating Sequence 'CCE_SEQ_COMP_COMPID'
CREATE SEQUENCE CCE_SEQ_COMP_COMPID
 INCREMENT BY 1
 START WITH 1
 NOMAXVALUE
 MINVALUE 1
 NOCYCLE
 CACHE 40
 ORDER
/

spool off