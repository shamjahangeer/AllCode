CREATE OR REPLACE PROCEDURE p_restate_budget_bkbl_amt (von_result OUT NUMBER) IS
/*************************************************************************
* Procedure:   p_restate_budget_bkbl_amt
* Description: Restate budget book/bill amount at fistday of fiscal year.
* 09/30/04 	Alex   Change code to process based on dbload_date instead of
* 				   amp_shipped_date.	
*************************************************************************/
vgn_cnt				 NUMBER(10) := 0;
vgn_max_cnt			 NUMBER := 10000;
vgc_section			 VARCHAR2(50);
vgn_result			 NUMBER := 0;
vgd_fy_1st_day		 DATE := NULL;
vgn_orgkid 			 NUMBER;
vgd_sdate 			 DATE;
vgc_io_status 	  	 VARCHAR2(20);
vgn_io_sqlcode	   	 NUMBER;
vgc_io_sqlerrm	     VARCHAR2(260);
ue_critical_db_error EXCEPTION;


PROCEDURE p_restate_bkbl_amt_ois (vin_orgkid in number, vid_sdate DATE, vid_edate DATE) IS

CURSOR ois_cur (vin_orgkid number, vid_sdate DATE, vid_edate DATE) IS
SELECT rowid
	   ,iso_currency_code_1
	   ,local_currency_billed_amount
	   ,budget_rate_book_bill_amt
--	   ,EXTENDED_BOOK_BILL_AMOUNT
--	   ,reported_as_of_date
	   ,AMP_ORDER_NBR
	   ,ORDER_ITEM_NBR
	   ,SHIPMENT_ID
FROM   order_item_shipment
WHERE  organization_key_id = vin_orgkid
--AND	   amp_shipped_date	between vid_sdate and vid_edate
AND	   database_load_date	between vid_sdate and vid_edate
AND	   reported_as_of_date >= vid_sdate
;

CURSOR orgkid_cur (vin_orgkid number, vid_sdate date, vid_edate DATE) IS
SELECT distinct organization_key_id
--	  ,to_date('01-'||to_char(amp_shipped_date,'mon-yyyy')) mo_1stday
FROM   order_item_shipment
WHERE  organization_key_id >= vin_orgkid
--and  organization_key_id <= vin_orgkid
--AND	   amp_shipped_date    >= vid_sdate
--and 	 amp_shipped_date<='24-APR-2000'
AND	   database_load_date	between vid_sdate and vid_edate
AND	   reported_as_of_date >= vid_sdate
order by organization_key_id
--	  ,to_date('01-'||to_char(amp_shipped_date,'mon-yyyy'))
;

vld_fiscal_date DATE;
vld_sdate		DATE;
vld_edate		DATE;

BEGIN
  vgn_cnt	  := 0;

  FOR orgkid_rec IN orgkid_cur(vin_orgkid, vid_sdate, vid_edate) LOOP
  	vgn_orgkid := orgkid_rec.organization_key_id;
--	vld_sdate  := orgkid_rec.mo_1stday;
--	vld_edate  := LAST_DAY(vld_sdate);
	vld_sdate  := vid_sdate;
	vld_edate  := vid_edate;

    FOR ois_rec IN ois_cur(vgn_orgkid, vld_sdate, vld_edate) LOOP
/*
      vgc_section := 'get prev mo fiscal date';
 	  SELECT TYCO_ADD_MONTHS(TYCO_LAST_DAY(ois_rec.REPORTED_AS_OF_DATE),-1)
	  INTO   vld_fiscal_date
	  FROM   dual;

      vgc_section := 'calc bal sheet';
  	  cor_curr_exchg_rates.convert_currency_amt
	 					 (vgc_io_status,
    				   	  vgn_io_sqlcode,
    				   	  vgc_io_sqlerrm,
    				   	  ois_rec.EXTENDED_BOOK_BILL_AMOUNT,
    					  ois_rec.local_currency_billed_amount,
    					  ois_rec.iso_currency_code_1,
    					  'USD',
    					  vld_fiscal_date,
    					  '2');  -- 1 = balance sheet
	  if vgc_io_status != 'OK' then
	 	 if vgn_io_sqlcode = +100 then
		 	if ois_rec.iso_currency_code_1 != 'BRL' then
		       DBMS_OUTPUT.PUT_LINE('*       AMP_ORDER_NBR:  ' || ois_rec.AMP_ORDER_NBR);
		       DBMS_OUTPUT.PUT_LINE('*      ORDER_ITEM_NBR:  ' || ois_rec.ORDER_ITEM_NBR);
		       DBMS_OUTPUT.PUT_LINE('*         SHIPMENT_ID:  ' || ois_rec.SHIPMENT_ID);
		       vgn_result := vgn_io_sqlcode;
		       RAISE ue_critical_db_error;
			end if;
		 else
		    vgn_result := vgn_io_sqlcode;
		    RAISE ue_critical_db_error;
		 end if;
	  end if;
*/
      vgc_section := 'calc budget rate';
  	  cor_curr_exchg_rates.convert_currency_amt
	 					 (vgc_io_status,
    				   	  vgn_io_sqlcode,
    				   	  vgc_io_sqlerrm,
    				   	  ois_rec.budget_rate_book_bill_amt,
    					  ois_rec.local_currency_billed_amount,
    					  ois_rec.iso_currency_code_1,
    					  'USD',
    					  vgd_fy_1st_day,
    					  '1');  -- 1 = budget rate
	  if vgc_io_status != 'OK' then
	 	 if vgn_io_sqlcode = +100 then
		    ois_rec.budget_rate_book_bill_amt := NULL;
		 else
		    vgn_result := vgn_io_sqlcode;
		    RAISE ue_critical_db_error;
		 end if;
	  end if;

	  vgc_section := 'update ois';
/*
	  if ois_rec.EXTENDED_BOOK_BILL_AMOUNT is not null then
      UPDATE order_item_shipment
      SET	 budget_rate_book_bill_amt = ois_rec.budget_rate_book_bill_amt
--	 		,EXTENDED_BOOK_BILL_AMOUNT = ois_rec.EXTENDED_BOOK_BILL_AMOUNT
      WHERE  rowid = ois_rec.rowid;
	  elsif ois_rec.iso_currency_code_1 !='BRL'
	  		AND ois_rec.EXTENDED_BOOK_BILL_AMOUNT is null then
		    vgn_result := vgn_io_sqlcode;
		    RAISE ue_critical_db_error;
	  else
*/
      UPDATE order_item_shipment
      SET	 budget_rate_book_bill_amt = ois_rec.budget_rate_book_bill_amt
      WHERE  rowid = ois_rec.rowid;
--	  end if;

      vgn_cnt := vgn_cnt + 1;
      IF MOD(vgn_cnt, vgn_max_cnt) = 0 THEN
         COMMIT;
      END IF;

	END LOOP; -- ois cur

  END LOOP; -- orgkid cur
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('OIS recs processed: ' || vgn_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt_ois - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt_ois - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
END ;


PROCEDURE p_restate_bkbl_amt_oio (vin_orgkid in number) IS

CURSOR oio_cur (vin_orgkid number) IS
SELECT rowid
	   ,iso_currency_code_1
	   ,local_currency_billed_amount
	   ,budget_rate_book_bill_amt
--	   ,EXTENDED_BOOK_BILL_AMOUNT
--	   ,reported_as_of_date
FROM   order_item_open
WHERE  organization_key_id = vin_orgkid
;

CURSOR orgkid_cur (vin_orgkid number) IS
SELECT distinct organization_key_id
FROM   order_item_open
WHERE  organization_key_id >= vin_orgkid
AND organization_key_id in (929,1056,1255,1295,1296,1448,1449)
order by organization_key_id
;

vld_fiscal_date DATE;

BEGIN
  vgn_cnt	  := 0;

  FOR orgkid_rec IN orgkid_cur(vin_orgkid) LOOP
  	vgn_orgkid := orgkid_rec.organization_key_id;

    FOR oio_rec IN oio_cur(vgn_orgkid) LOOP
/*
      vgc_section := 'get prev mo fiscal date';
 	  SELECT TYCO_ADD_MONTHS(TYCO_LAST_DAY(oio_rec.REPORTED_AS_OF_DATE),-1)
	  INTO   vld_fiscal_date
	  FROM   dual;

      vgc_section := 'calc bal sheet';
  	  cor_curr_exchg_rates.convert_currency_amt
	 					 (vgc_io_status,
    				   	  vgn_io_sqlcode,
    				   	  vgc_io_sqlerrm,
    				   	  oio_rec.EXTENDED_BOOK_BILL_AMOUNT,
    					  oio_rec.local_currency_billed_amount,
    					  oio_rec.iso_currency_code_1,
    					  'USD',
    					  vld_fiscal_date,
    					  '2');  -- 1 = balance sheet
	  if vgc_io_status != 'OK' then
	 	 if vgn_io_sqlcode = +100 then
		    oio_rec.EXTENDED_BOOK_BILL_AMOUNT := NULL;
		 else
		    vgn_result := vgn_io_sqlcode;
		    RAISE ue_critical_db_error;
		 end if;
	  end if;
*/
      vgc_section := 'calc budget rate';
  	  cor_curr_exchg_rates.convert_currency_amt
	 					 (vgc_io_status,
    				   	  vgn_io_sqlcode,
    				   	  vgc_io_sqlerrm,
    				   	  oio_rec.budget_rate_book_bill_amt,
    					  oio_rec.local_currency_billed_amount,
    					  oio_rec.iso_currency_code_1,
    					  'USD',
    					  vgd_fy_1st_day,
    					  '1');  -- 1 = budget rate
	  if vgc_io_status != 'OK' then
	 	 if vgn_io_sqlcode = +100 then
		    oio_rec.budget_rate_book_bill_amt := NULL;
		 else
		    vgn_result := vgn_io_sqlcode;
		    RAISE ue_critical_db_error;
		 end if;
	  end if;

	  vgc_section := 'update oio';
      UPDATE order_item_open
      SET	 budget_rate_book_bill_amt = oio_rec.budget_rate_book_bill_amt
--	 		,EXTENDED_BOOK_BILL_AMOUNT = oio_rec.EXTENDED_BOOK_BILL_AMOUNT
      WHERE  rowid = oio_rec.rowid;

      vgn_cnt := vgn_cnt + 1;
      IF MOD(vgn_cnt, vgn_max_cnt) = 0 THEN
         COMMIT;
      END IF;

	END LOOP; -- ois cur

  END LOOP; -- orgkid cur
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('OIO recs processed: ' || vgn_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt_oio - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt_oio - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(vgn_result)) ;
    ROLLBACK ;
END ;


BEGIN -- main block
  vgc_section := 'get fiscal yr first day';
  select to_date(parameter_field)
  into   vgd_fy_1st_day
  from   delivery_parameter_local
  where  parameter_id='SCDFY1STDAY';

  vgc_section := 'get ois min org_key_id';
  select min(organization_key_id)
  into	 vgn_orgkid
  from   order_item_shipment
--  where	 organization_key_id=776
  ;

  vgc_section := 'get min amp_shipped_date';
  select min(amp_shipped_date)
  into	 vgd_sdate
  from   order_item_shipment
  where  organization_key_id = vgn_orgkid
--  and 	 amp_shipped_date='25-SEP-2010'
  ;

  vgd_sdate := '25-sep-2010';  
  -- restate budget_book_bill_amt for ois
  p_restate_bkbl_amt_ois(vgn_orgkid, vgd_sdate,'26-sep-2010');
  if vgn_result != 0 then
  	 return;
  end if;

/*  vgc_section := 'get oio min org_key_id';
  select min(organization_key_id)
  into	 vgn_orgkid
  from   order_item_open
--  where	 organization_key_id=380
  ;

  -- restate budget_book_bill_amt for oio
  p_restate_bkbl_amt_oio(vgn_orgkid);*/

  von_result := vgn_result;
exception
  when no_data_found then
    von_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error : ' || SQLERRM(von_result)) ;
  when others then
    von_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_restate_budget_bkbl_amt - '||vgc_section) ;
	DBMS_OUTPUT.PUT_LINE('org key id: ' || vgn_orgkid);
    DBMS_OUTPUT.PUT_LINE('SQL Error : ' || SQLERRM(von_result)) ;
END ;
/
