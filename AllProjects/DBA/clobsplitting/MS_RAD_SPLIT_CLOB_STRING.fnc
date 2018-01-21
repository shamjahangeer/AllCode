CREATE OR REPLACE FUNCTION MS_RAD_Split_clob_string(sText IN clob, sDel IN VARCHAR2 := ',')
    RETURN ms_varchar2_array
IS

    nStartIdx PLS_INTEGER := 1;
    nEndIdx PLS_INTEGER := 1;
    oRet ms_varchar2_array := ms_varchar2_array();
    nSqlnum   NUMBER := 0;
    

BEGIN
    nSqlnum := 70;
    IF sText IS NULL THEN
        RETURN oRet;
    END IF;

    IF DBMS_LOB.getlength(sText) = 0 THEN
         RETURN oRet;
    END IF;

    LOOP
       nSqlnum := 10;
       nEndIdx := DBMS_LOB.INSTR(sText, sDel, nStartIdx);

       IF nEndIdx > 0 THEN

          oRet.Extend;
          oRet(oRet.LAST) := DBMS_LOB.SUBSTR(sText, nEndIdx - nStartIdx, nStartIdx);
          nStartIdx := nEndIdx + LENGTH(sDel);

       ELSE
          nSqlnum := 20;
          oRet.Extend;
          nSqlnum := 30;
          oRet(oRet.LAST) := DBMS_LOB.SUBSTR(lob_loc => sText, offset => nStartIdx);
          EXIT;

       END IF;

    END LOOP;

    RETURN oRet;
EXCEPTION
                when others then
                                rad_insert_log( 'ERROR :'||length(sText)||' - '||nSqlnum
                               , -1
                               , ' MS_RAD_Split_clob_string'
                               ,  SQLCODE||' - '|| substr(SQLERRM, 1, 500) 
                               , 'ERROR');
END  MS_RAD_Split_clob_string;