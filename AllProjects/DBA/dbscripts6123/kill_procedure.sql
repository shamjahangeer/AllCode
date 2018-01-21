DECLARE                                                                         
loopcounter  NUMBER := 1;                                                       
BEGIN                                                                           
   WHILE loopcounter > 0 LOOP                                                  
        select count(*) into loopcounter from v$session where username in (UPPER('$ORACLE_USER'),UPPER('$ARCHIVE_USER'));
   END LOOP;                                                                    
END;                                                                            
/                                                                               
