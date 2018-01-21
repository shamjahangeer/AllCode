-- Sathia -- modified function to avoid string buffer too small and invalid number errors
create or replace FUNCTION ms_rad_common_elements_clob (i_clob1 IN CLOB, i_clob2 IN CLOB, i_delimiter IN VARCHAR2)
  RETURN CLOB
IS
 
    cStr VARCHAR2(4000) := null;
    x_stmt NUMBER:= 60;
    x_common_element_CLOB_OUT   CLOB := null;
         
BEGIN
    x_stmt := 60;
    --x_common_element_CLOB_OUT := ''; 
    for i in ( select x.column_value as common_field from table(ms_rad_split_string_clob(i_clob1, i_delimiter)) x
                intersect
                select y.column_value as common_field from table(ms_rad_split_string_clob(i_clob2, i_delimiter)) y
             )
    loop
        x_stmt := 70;
        cStr := i.common_field;
        -- this will fail if string is more than 40000 char or reaches 32K
        x_common_element_CLOB_OUT := x_common_element_CLOB_OUT||','||to_clob(cStr);
        
        dbms_output.put_line(tO_CHAR(x_common_element_CLOB_OUT));
            
    end loop;
    
    RETURN trim(',' from x_common_element_CLOB_OUT);
    
EXCEPTION
    when others then
                    rad_insert_log( 'ERROR : length of strin at while concating'||length(x_common_element_CLOB_OUT)+length(','||cStr)
                     ||' - Error statement :'||x_stmt
                   , -1
                   , 'ms_rad_split_string_clob'
                   ,  SQLCODE||' - '|| substr(SQLERRM,1, 500)
                   , 'ERROR');
 

    RETURN null;
END ms_rad_common_elements_clob;