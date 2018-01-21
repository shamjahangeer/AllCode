spool si_post_mig.lst

-- update the newly populated component properties with values safed from previous installation
prompt UPDATE CCE_COMPONENT_PROPERTIES
update cce_component_properties a set field_value = 
(select field_value from tmp_cce_comp_prop b, 
            cce_component c, cce_field_info f where
            b.comp_name = c.comp_name
            and b.field_enum_id = f.field_enum_id 
            and c.comp_id = a.comp_id
            and f.field_id = a.field_id   )
where (a.comp_id, a.FIELD_id) IN (SELECT m.comp_id, n.FIELD_id 
  FROM cce_component m,  tmp_cce_comp_prop l, cce_FIELD_INFO n
  WHERE m.comp_name = l.comp_name
  AND l.FIELD_ENUM_ID = n.FIELD_ENUM_ID);
  
  prompt UPDATE CCE_COMP_TYPE_PROPERTIES
update CCE_COMP_TYPE_PROPERTIES a set field_value = 
(select field_value from tmp_cce_comp_type_prop b, cce_field_info f where
             b.field_enum_id = f.field_enum_id 
            and b.comp_type = a.comp_type
            and f.field_id = a.field_id   )
where (a.comp_type, a.FIELD_id) IN (SELECT l.comp_type, n.FIELD_id 
  FROM tmp_cce_comp_type_prop l, cce_FIELD_INFO n
  WHERE l.FIELD_ENUM_ID = n.FIELD_ENUM_ID);


-- update with the latest component Id				
prompt UPDATE COMPID		
Update CCE_NE_CAPACITY_INFO set ADAPTER_COMP_ID =null;

Update CCE_ALARM_DATA a set ALARM_SOURCE_COMP_ID= 
	   (select b.comp_id from cce_component b, tmp_cce_comp c 
	   		   where b.comp_name = c.comp_name
			   and a.aLARM_SOURCE_COMP_ID = c.comp_id);
			   
Update CCE_ALARM_DATA a set ALARM_RAISED_COMP_ID =
	   (select b.comp_id from cce_component b, tmp_cce_comp c 
	   		   where b.comp_name = c.comp_name
			   and a.ALARM_RAISED_COMP_ID = c.comp_id);

Update CCE_ALARM_HISTORY_DATA a set ALARM_SOURCE_COMP_ID=
	   (select b.comp_id from cce_component b, tmp_cce_comp c 
	   		   where b.comp_name = c.comp_name
			   and a.aLARM_SOURCE_COMP_ID = c.comp_id);

Update CCE_ALARM_HISTORY_DATA a set ALARM_RAISED_COMP_ID=
	   (select b.comp_id from cce_component b, tmp_cce_comp c 
	   		   where b.comp_name = c.comp_name
			   and a.ALARM_RAISED_COMP_ID = c.comp_id);

Update CCE_AUDIT_DATA a set COMP_ID =
	   (select b.comp_id from cce_component b, tmp_cce_comp c 
	   		   where b.comp_name = c.comp_name
			   and a.comp_id = c.comp_id);

PROMPT update CCE_SECURITY_ROLE_CAP_ASSOC for user defined roles SYSTEM_DEFINED_IND=0 GUI
DELETE cce_security_role_cap_assoc
WHERE  capability_id IN (SELECT b.user_capability_id
                         FROM   (SELECT user_capability_name,
                                        permission
                                 FROM   tmp_cce_user_capability
                                 MINUS
                                 SELECT user_capability_name,
                                        permission
                                 FROM   cce_user_capability) a,
                                tmp_cce_user_capability b
                         WHERE  a.user_capability_name = b.user_capability_name
                         AND    a.permission = b.permission);
                         
UPDATE cce_security_role_cap_assoc srca
SET    capability_id = (SELECT updtd.user_capability_id
                        FROM   cce_user_capability updtd, 
                               tmp_cce_user_capability bk
                        WHERE  bk.user_capability_name = updtd.user_capability_name
                        AND    bk.permission = updtd.permission      
                        AND    bk.user_capability_id = srca.capability_id)
WHERE  srca.security_role_id IN (SELECT security_role_id
                                 FROM   cce_security_role sr            
                                 WHERE  sr.system_defined_ind = 0);
                                 
COMMIT;                	   

-- LTUSR00023493 No need as fixed in preconfig
--PROMPT Subscriber Class Wizard: remove item 'Both' from Assign Subscribers List
--delete from cce_list_of_values 
--where FIELD_ID = (select field_id from cce_field_info where field_enum_id = 800433)
--and lov_display_value = 'Both';

PROMPT Associating Capability based on product installation
exec CCE_ASSOCIATE_PROD_ROLE_CAP;

PROMPT Start Enabling ForeignKey Constraints***
EXEC subSMEnableRefCons;
PROMPT End Enabling ForeignKey Constraints***

drop table tmp_cce_comp;
drop table tmp_cce_comp_prop;
drop table tmp_cce_comp_type_prop;
--drop table tmp_cce_user_capability;

spool off