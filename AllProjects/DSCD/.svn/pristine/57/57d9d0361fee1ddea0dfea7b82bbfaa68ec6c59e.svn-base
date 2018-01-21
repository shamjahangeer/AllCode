create or replace procedure p_fix_budget_rate_amt AS

CURSOR amt_cur IS
  SELECT rowid
        ,iso_currency_code_1
        ,local_currency_billed_amount
        ,budget_rate_book_bill_amt
        ,AMP_ORDER_NBR
        ,ORDER_ITEM_NBR
        ,SHIPMENT_ID
  FROM   order_item_shipment
--  WHERE  dml_tmstmp >= to_date('27-sep-2008 10:00','dd-mon-yyyy hh24:mi')  
/*WHERE  dml_tmstmp >= to_date('01-MAY-2008 08:00','dd-mon-yyyy hh24:mi')  
AND amp_shipped_date > '01-MAY-2008'  
AND dml_oracle_id ='SCDU39800' */ 
where database_load_date >= '03-oct-2011'
and dml_tmstmp < to_date('06-oct-2011 13:00','dd-mon-yyyy hh24:mi')
;
vgc_io_status 	  	 VARCHAR2(20);
vgn_io_sqlcode	    NUMBER;
vgc_io_sqlerrm	    VARCHAR2(260);
vgn_result			 NUMBER := 0;
vgn_cnt				 NUMBER(10) := 0;
vgn_max_cnt			 NUMBER := 10000;
vgc_section			 VARCHAR2(50);
vgd_fy_1st_day		 DATE := to_date('01-oct-2011');
ue_critical_db_error EXCEPTION;
begin
  FOR amt_rcur IN amt_cur LOOP
  
    vgc_section := 'calc budget rate';
    cor_curr_exchg_rates.convert_currency_amt
                 (vgc_io_status,
                  vgn_io_sqlcode,
                  vgc_io_sqlerrm,
                  amt_rcur.budget_rate_book_bill_amt,
                  amt_rcur.local_currency_billed_amount,
                  amt_rcur.iso_currency_code_1,
                  'USD',
                  vgd_fy_1st_day,
                  '1');  -- 1 = budget rate
    if vgc_io_status != 'OK' then
      if vgn_io_sqlcode = +100 then
        amt_rcur.budget_rate_book_bill_amt := NULL;
      else
        vgn_result := vgn_io_sqlcode;
        RAISE ue_critical_db_error;
      end if;
    end if;

    vgc_section := 'update table';
       
    UPDATE order_item_shipment
    SET	  budget_rate_book_bill_amt = amt_rcur.budget_rate_book_bill_amt
    WHERE  rowid = amt_rcur.rowid;

    vgn_cnt := vgn_cnt + 1;
/*    IF MOD(vgn_cnt, vgn_max_cnt) = 0 THEN
      COMMIT;
    END IF;*/
	
  END LOOP;
  dbms_output.put_line('CNT: '||vgn_cnt);
exception
  WHEN ue_critical_db_error THEN
	 rollback;
	 dbms_output.put_line(vgc_io_sqlerrm);  
  when others then
	 rollback;
	 dbms_output.put_line(sqlerrm);  
end;
/
