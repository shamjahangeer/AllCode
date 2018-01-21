create or replace procedure p_purge_daf_tgt (result IN OUT NUMBER) IS
/************************************************************************
* Procedure:   p_purge_daf_tgt
* Description: This stored pocedure is used to purge data from DAF
*              target tables -- billing_tgt, booking_tgt, backlog_tgt.
*
*-----------------------------------------------------------------------
* Revisions Log:
* 1.0   05/01/2000  A. Orbeta   Original Version
* 		06/07/2004	   			Removed reference to obsoleted BOOKING_TGT table.
************************************************************************/

    vln_days        NUMBER := 0;
    vld_purge_date  DATE;
	vlc_tbl_name	VARCHAR2(30);
	vln_del_cnt		NUMBER(10) := 0;
	vln_max_del		NUMBER := 10000;

	CURSOR backlog_cur (vid_purge_date IN DATE) IS
		   SELECT rowid
		   FROM   BACKLOG_TGT
		   WHERE  DML_TS < vid_purge_date;

BEGIN
	-- purge billing table
	vlc_tbl_name := 'DELIVERY_PARAMETER_LOCAL';
    SELECT	PARAMETER_FIELD
    INTO    vln_days
    FROM    DELIVERY_PARAMETER_LOCAL
    WHERE   PARAMETER_ID = 'SCD16BILL';

    vld_purge_date := SYSDATE - vln_days;

	vlc_tbl_name := 'BILLING_TGT';
    DELETE FROM BILLING_TGT
    WHERE  DML_TS < vld_purge_date;

    COMMIT ;
    DBMS_OUTPUT.PUT_LINE('BILLING_TGT RECS DELETED: ' || SQL%ROWCOUNT);

/*
  	obsoleted
	-- purge booking table
	vlc_tbl_name := 'DELIVERY_PARAMETER_LOCAL';
    SELECT	PARAMETER_FIELD
    INTO    vln_days
    FROM    DELIVERY_PARAMETER_LOCAL
    WHERE   PARAMETER_ID = 'SCD16BOOK';

    vld_purge_date := SYSDATE - vln_days;

	vlc_tbl_name := 'BOOKING_TGT';
    DELETE FROM BOOKING_TGT
    WHERE  DML_TS < vld_purge_date;

    COMMIT ;
    DBMS_OUTPUT.PUT_LINE('BOOKING_TGT RECS DELETED: ' || SQL%ROWCOUNT);
*/
	
	-- purge backlog table
	vlc_tbl_name := 'DELIVERY_PARAMETER_LOCAL';
    SELECT	PARAMETER_FIELD
    INTO    vln_days
    FROM    DELIVERY_PARAMETER_LOCAL
    WHERE   PARAMETER_ID = 'SCD16BACK';

    vld_purge_date := SYSDATE - vln_days;
	vlc_tbl_name := 'BACKLOG_TGT';

	vln_del_cnt	:= 0;
	FOR backlog_rec IN backlog_cur (vld_purge_date) LOOP
       DELETE FROM BACKLOG_TGT
       WHERE  rowid = backlog_rec.rowid;

   	   vln_del_cnt := vln_del_cnt + 1;
   	   IF MOD(vln_del_cnt, vln_max_del) = 0 THEN
	      COMMIT;
	   END IF;
	END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('BACKLOG_TGT RECS DELETED: ' || vln_del_cnt);

    EXCEPTION
        WHEN OTHERS THEN
            result := SQLCODE ;
            DBMS_OUTPUT.PUT_LINE('P_PURGE_DAF_TGT - '||vlc_tbl_name) ;
            DBMS_OUTPUT.PUT_LINE('SQL ERROR:  ' || SQLERRM(SQLCODE)) ;
            ROLLBACK ;
END ;
/
