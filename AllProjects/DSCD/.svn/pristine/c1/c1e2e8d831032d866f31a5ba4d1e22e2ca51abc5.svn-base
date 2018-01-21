CREATE OR REPLACE PROCEDURE p_fix_tam_orders is

CURSOR ois_cur IS
  SELECT *
    FROM ssa.TEMP_SA_BACKFILL_TAM_ORDERS
  ;
   
vln_cnt	  			  NUMBER(10):=0;
vln_cnt_upd			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=100000;
g_error_section     VARCHAR2(50):= NULL;
New_Exception       EXCEPTION;
BEGIN
   g_error_section := 'Upd OIS tbl';
   FOR ois_rec IN ois_cur LOOP

      UPDATE ORDER_ITEM_SHIPMENT
      SET    schd_agr_cancel_indicator_cde = ois_rec.schd_agr_cancel_indicator_cde,
             consumed_sa_order_number_id   = ois_rec.consumed_sa_order_number_id,
             consumed_sa_order_item_nbr_id = ois_rec.consumed_sa_order_item_nbr_id
      WHERE  amp_order_nbr = ois_rec.order_nbr
      and    order_item_nbr= ois_rec.order_item_nbr
      AND    ORDER_TYPE_ID = 'TAM' 
      and    database_load_date between '01-AUG-2010' and '12-NOV-2010'
      and    consumed_sa_order_number_id is null
--and   amp_order_nbr='3018593713'
--and   order_item_nbr='000025'
      ;     

      vln_cnt_upd := vln_cnt_upd + SQL%ROWCOUNT;
      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;
   COMMIT;

   DBMS_OUTPUT.PUT_LINE('recs found: '||vln_cnt);   
   DBMS_OUTPUT.PUT_LINE('recs updated: '||vln_cnt_upd);   
EXCEPTION
  WHEN New_Exception THEN
  	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM||' - '||g_error_section);
  WHEN OTHERS THEN
  	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM);  	      
END;
/
