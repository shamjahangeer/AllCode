create or replace procedure p_purge_process_log (result IN OUT NUMBER) IS

    retain_months        NUMBER := 0;
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

    DELETE FROM SCORECARD_PROCESS_LOG
    WHERE
        TO_DATE(DML_TMSTMP,'DD-MON-YYYY') <= purge_date ;

    DELETE FROM BOOK_BILL_SHIP_SMRY
    WHERE
        TO_DATE(REPORTED_AS_OF_DTE,'DD-MON-YYYY') <= purge_date ;

    DBMS_OUTPUT.PUT_LINE('NBR SCORECARD_PROCESS_LOG ROWS DELETED:  ' || SQL%ROWCOUNT);

    DBMS_OUTPUT.PUT_LINE('NBR BOOK_BILL_SHIP_SUMRY ROWS DELETED:  ' || SQL%ROWCOUNT);

    COMMIT ;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('P_PURGE_PROCESS_LOG') ;
            DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE)) ;
            result := SQLCODE ;
            ROLLBACK ;
END ;
/
