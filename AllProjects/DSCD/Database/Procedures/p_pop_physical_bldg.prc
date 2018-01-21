CREATE OR REPLACE PROCEDURE p_pop_physical_bldg IS

CURSOR ois_cur IS
   SELECT STORAGE_LOCATION_ID,ACTUAL_SHIP_BUILDING_NBR
         ,ois.rowid 
    FROM  order_item_shipment ois
    where STORAGE_LOCATION_ID is not null
    and ACTUAL_SHIP_FROM_BUILDING_ID is null
--and amp_order_nbr='3015314785'
   ; 
  
vln_cnt	  			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=10000;
g_error_section       VARCHAR2(50):= NULL;
New_Exception         EXCEPTION;
BEGIN
 
   g_error_section := 'Upd OIS tbl';
   FOR ois_rec IN ois_cur LOOP

  	  UPDATE ORDER_ITEM_SHIPMENT
	  SET	   ACTUAL_SHIP_FROM_BUILDING_ID = Scdcommonbatch.get_physical_building(ois_rec.ACTUAL_SHIP_BUILDING_NBR
                                                                               ,ois_rec.STORAGE_LOCATION_ID
                                                                               )
	  WHERE  ROWID = ois_rec.ROWID;
   
      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;

   END LOOP;
   COMMIT;
   
   DBMS_OUTPUT.PUT_LINE('recs updated: '||vln_cnt);
EXCEPTION
  WHEN New_Exception THEN
  	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM||' - '||g_error_section);
  WHEN OTHERS THEN
   	 ROLLBACK;
  	 DBMS_OUTPUT.PUT_LINE(SQLERRM);  	      
END;
/
