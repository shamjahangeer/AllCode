spool siwls_was_update.lst

PROMPT SELECT from  CCE_TASK_TYPE_INFO
SELECT  TASK_TYPE_PROP_VALUE from  CCE_TASK_TYPE_INFO WHERE TASK_TYPE_PROP_NAME = 'JNDI_NAME';

PROMPT update with WAS inforamtion for tasks that are inserted new for non-HA
UPDATE CCE_TASK_TYPE_INFO 
SET TASK_TYPE_PROP_VALUE = 'ejb/'||TASK_TYPE_PROP_VALUE 
WHERE TASK_TYPE_PROP_NAME = 'JNDI_NAME'
and 0 = (select nvl(issystemHA(),0) from dual)
and TASK_TYPE_PROP_VALUE not like 'ejb/%'
and TASK_TYPE_PROP_VALUE not like 'cell/clusters/%';

PROMPT update with WAS inforamtion for tasks preexist as non-HA tasks
UPDATE CCE_TASK_TYPE_INFO 
SET TASK_TYPE_PROP_VALUE = 'ejb/'|| SUBSTR(TASK_TYPE_PROP_VALUE, INSTR(TASK_TYPE_PROP_VALUE,'/', -1, 1)+1)  
WHERE TASK_TYPE_PROP_NAME = 'JNDI_NAME'
and 0 = (select nvl(issystemHA(),0) from dual)
and TASK_TYPE_PROP_VALUE not like 'ejb/%'
and TASK_TYPE_PROP_VALUE like 'cell/clusters/%';

PROMPT update with WAS inforamtion for tasks that are inserted new for HA
UPDATE CCE_TASK_TYPE_INFO 
SET TASK_TYPE_PROP_VALUE = 
		(select 'cell/clusters/' || comp_name || '/ejb/' ||TASK_TYPE_PROP_VALUE 
			from cce_component where comp_type = 8000
			and comp_ver_config_status_code = 'ACTIVE')   
WHERE TASK_TYPE_PROP_NAME = 'JNDI_NAME'
and 1 = (select issystemHA() from dual)
and TASK_TYPE_PROP_VALUE not like 'cell/clusters/%'
and TASK_TYPE_PROP_VALUE not like 'ejb/%';

PROMPT update with WAS inforamtion for tasks that preexist as HA tasks
UPDATE CCE_TASK_TYPE_INFO 
SET TASK_TYPE_PROP_VALUE = 
		(select 'cell/clusters/' || comp_name || '/ejb/' || SUBSTR(TASK_TYPE_PROP_VALUE, INSTR(TASK_TYPE_PROP_VALUE,'/', -1, 1)+1)  
			from cce_component where comp_type = 8000
			and comp_ver_config_status_code = 'ACTIVE')   
WHERE TASK_TYPE_PROP_NAME = 'JNDI_NAME'
and 1 = (select issystemHA() from dual)
and TASK_TYPE_PROP_VALUE not like 'cell/clusters/%'
and TASK_TYPE_PROP_VALUE like 'ejb/%';

PROMPT update with WsnInitialContextFactory
UPDATE CCE_TASK_TYPE_INFO 
SET TASK_TYPE_PROP_VALUE = 'com.ibm.websphere.naming.WsnInitialContextFactory'
WHERE TASK_TYPE_PROP_NAME = 'java.naming.factory.initial';

delete from CCE_TASK_TYPE_INFO 
WHERE TASK_TYPE_PROP_NAME = 'java.naming.security.credentials';

delete from CCE_TASK_TYPE_INFO 
WHERE TASK_TYPE_PROP_NAME = 'java.naming.security.principal';

PROMPT set Parent Comp Id 
UPDATE CCE_COMPONENT SET parent_comp_id =
(SELECT comp_id FROM CCE_COMPONENT WHERE comp_type = 8000),
parent_comp_version_no =
(SELECT comp_version_no FROM CCE_COMPONENT WHERE comp_type = 8000)
WHERE parent_comp_id IN
(SELECT comp_id FROM CCE_COMPONENT WHERE comp_type = 2043);


PROMPT select role of Processes before updating
select comp_name, comp_role, comp_commn_type, physical_comp_ind from cce_component where physical_comp_ind = 0
					 and comp_commn_type ='CMTS' order by  comp_name;
					   
PROMPT By default all processes are "Secondary" and will be turned on as Primary by Resource Group, in non-HA mode, it has to be primary
update cce_component a set comp_role =1 
                    where comp_role =2 
					 and physical_comp_ind = 0
					 and comp_commn_type ='CMTS' 
					 and 1 = ( SELECT 1 FROM dual
                                WHERE EXISTS
                                    (SELECT 1 FROM cce_component b where comp_ver_config_status_code = 'ACTIVE' and comp_type in (1019, 3002) and
                                    COMP_SEQ_IN_PARENT =1 and a.cluster_id = b.cluster_id )
                                AND EXISTS
                                    (SELECT 1 FROM cce_component c where comp_ver_config_status_code = 'INACTIVE' and comp_type in (1019, 3002) and
                                     COMP_SEQ_IN_PARENT =2 and a.cluster_id = c.cluster_id  )
                              );
                              

PROMPT select role of Processes before updating
select comp_name, comp_role, comp_commn_type, physical_comp_ind from cce_component where physical_comp_ind = 0
					 and comp_commn_type ='CMTS' order by  comp_name;                              

DELETE FROM CCE_SECURITY_ROLE_CAP_ASSOC
WHERE capability_id IN (  SELECT USER_CAPABILITY_ID FROM
CCE_USER_CAPABILITY WHERE user_capability_display_name 
IN ('Security - Sessions: Disconnect', 'Security - Users: Disconnect', 
'Security - Sessions: View'));

DELETE FROM CCE_USER_CAPABILITY
WHERE user_capability_display_name 
IN ('Security - Sessions: Disconnect', 'Security - Users: Disconnect', 
'Security - Sessions: View');

commit;

spool off
