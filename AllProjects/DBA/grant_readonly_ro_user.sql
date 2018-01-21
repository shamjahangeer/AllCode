DECLARE
begin
    for x in (select object_name, object_type from user_objects)  
    loop
    
           if x.object_type not in('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TYPE', 'TYPE BODY') then    
               begin
                    execute immediate 'grant select on '|| x.object_name || ' to  ro_user';  
               exception
                   when others then
                       if SQLCODE <> '-942' then 
                           dbms_output.put_line('Object error:' || x.object_name||'  - SQLCODE'||SQLCODE||' - '||substr(SQLERRM,1,500));
                       end if;
               end;
           end if;
           
           if x.object_type in('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TYPE', 'TYPE BODY') then
               begin
                    execute immediate 'grant execute  on '|| x.object_name || ' to  ro_user';  
               exception
                   when others then
                       dbms_output.put_line('Object error:' || x.object_name||'  - SQLCODE'||SQLCODE||' - '||substr(SQLERRM,1,500));
               end;
           end if;
       
    end loop; 
end;
/
