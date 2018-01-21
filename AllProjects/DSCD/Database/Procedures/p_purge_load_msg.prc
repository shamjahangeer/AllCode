create or replace procedure p_purge_load_msg (result IN OUT NUMBER) IS

    retain_months        NUMBER := 0;
    discard_count        NUMBER := 0;
    purge_date           DATE;
BEGIN
    SELECT
        PARAMETER_FIELD
    INTO
        retain_months
    FROM
        DELIVERY_PARAMETER_LOCAL
    WHERE
        PARAMETER_ID = 'SCD07MTHS' ;

    purge_date := LAST_DAY(ADD_MONTHS(SYSDATE, retain_months * -1));

    DELETE FROM LOAD_MSG
    WHERE
        TO_DATE(DML_TMSTMP,'DD-MON-YYYY') <= purge_date ;

    DBMS_OUTPUT.PUT_LINE('NBR DELETED:  ' || SQL%ROWCOUNT);

    COMMIT ;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('P_PURGE_LOAD_MSG') ;
            DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE)) ;
            result := SQLCODE ;
            ROLLBACK ;
END ;
/
