-- Sathia -- modified function to avoid string buffer too small and invalid number errors
create or replace FUNCTION ms_rad_split_string_clob (i_string IN CLOB, i_delimiter IN VARCHAR2)
  RETURN ms_varchar2_array PIPELINED
IS

    oStr ms_varchar2_array;
    cStr VARCHAR2(4000) := null;
    x_stmt NUMBER:= 60;
BEGIN
    x_stmt := 60;
    BEGIN
      oStr := MS_RAD_Split_clob_string(i_string, i_delimiter);
      IF oStr.COUNT > 0 THEN
        FOR i IN oStr.FIRST .. oStr.LAST
        LOOP
            select cast(oStr(i) as varchar2(4000)) into cStr from dual;
            BEGIN
                PIPE ROW (cStr);
            exception
               when  no_data_needed then null;
                when others then
                                rad_insert_log( 'ERROR :'||cStr
                               , -1
                               , 'ms_rad_split_string_clob'
                               ,  SQLCODE||' - '|| substr(SQLERRM, 1, 500)
                               , 'ERROR');
            END;
        END LOOP;
      END IF;
    END;

    RETURN;
END ms_rad_split_string_clob;