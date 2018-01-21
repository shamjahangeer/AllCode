CREATE OR REPLACE PROCEDURE p_ReSmry_MFG_Campus IS
/*************************************************************************
* Procedure:   p_ReSmry_MFG_Campus
* Description: Rebuild MFG_Campus Summary.
*************************************************************************/
vln_cnt				 NUMBER(10) := 0;
vln_max_cnt			 NUMBER := 5000;
--ois_rec				 ORDER_ITEM_SHIPMENT%ROWTYPE;
vlc_section			 VARCHAR2(50);
vgn_result			 NUMBER := 0;
vgc_smry_type	 	 VARCHAR2(1);
ue_critical_db_error EXCEPTION;

CURSOR smry_cur IS
SELECT  COUNT(*) total_ship
	   -- STS 1
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) sts_ship_out_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) sts_ship_six_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) sts_ship_five_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) sts_ship_four_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) sts_ship_three_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) sts_ship_two_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) sts_ship_one_early
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) sts_ship_on_time   
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) sts_ship_one_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) sts_ship_two_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) sts_ship_three_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) sts_ship_four_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) sts_ship_five_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) sts_ship_six_late
	   ,SUM(CASE WHEN SCHEDULE_TO_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) sts_ship_out_late
	   -- RTS 2	   
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) rts_ship_out_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) rts_ship_six_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) rts_ship_five_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) rts_ship_four_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) rts_ship_three_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) rts_ship_two_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) rts_ship_one_early
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) rts_ship_on_time   
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) rts_ship_one_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) rts_ship_two_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) rts_ship_three_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) rts_ship_four_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) rts_ship_five_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) rts_ship_six_late
	   ,SUM(CASE WHEN REQUEST_TO_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) rts_ship_out_late
	   -- RTS 3	   
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE < -6 THEN 1 ELSE 0 END) rtsch_ship_out_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -6 THEN 1 ELSE 0 END) rtsch_ship_six_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -5 THEN 1 ELSE 0 END) rtsch_ship_five_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -4 THEN 1 ELSE 0 END) rtsch_ship_four_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -3 THEN 1 ELSE 0 END) rtsch_ship_three_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -2 THEN 1 ELSE 0 END) rtsch_ship_two_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = -1 THEN 1 ELSE 0 END) rtsch_ship_one_early
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 0 THEN 1 ELSE 0 END) rtsch_ship_on_time   
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 1 THEN 1 ELSE 0 END) rtsch_ship_one_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 2 THEN 1 ELSE 0 END) rtsch_ship_two_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 3 THEN 1 ELSE 0 END) rtsch_ship_three_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 4 THEN 1 ELSE 0 END) rtsch_ship_four_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 5 THEN 1 ELSE 0 END) rtsch_ship_five_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE = 6 THEN 1 ELSE 0 END) rtsch_ship_six_late
	   ,SUM(CASE WHEN REQUEST_TO_SCHEDULE_VARIANCE > 6 THEN 1 ELSE 0 END) rtsch_ship_out_late	   
	   -- Variable STS 1	   	   	   	   	   	   	   	   
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) sts_varbl_out_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) sts_varbl_six_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) sts_varbl_five_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) sts_varbl_four_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) sts_varbl_three_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) sts_varbl_two_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) sts_varbl_one_early
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) sts_varbl_on_time   
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) sts_varbl_one_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) sts_varbl_two_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) sts_varbl_three_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) sts_varbl_four_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) sts_varbl_five_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) sts_varbl_six_late
	   ,SUM(CASE WHEN VARBL_SCHEDULE_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) sts_varbl_out_late
	   -- Variable RTS 2
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) rts_varbl_out_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) rts_varbl_six_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) rts_varbl_five_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) rts_varbl_four_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) rts_varbl_three_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) rts_varbl_two_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) rts_varbl_one_early
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) rts_varbl_on_time   
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) rts_varbl_one_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) rts_varbl_two_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) rts_varbl_three_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) rts_varbl_four_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) rts_varbl_five_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) rts_varbl_six_late
	   ,SUM(CASE WHEN VARBL_REQUEST_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) rts_varbl_out_late	 
	   -- JIT
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' THEN 1 ELSE 0 END) total_jit_ship
	   -- STS 1
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) sts_jit_out_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) sts_jit_six_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) sts_jit_five_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) sts_jit_four_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) sts_jit_three_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) sts_jit_two_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) sts_jit_one_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) sts_jit_on_time   
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) sts_jit_one_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) sts_jit_two_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) sts_jit_three_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) sts_jit_four_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) sts_jit_five_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) sts_jit_six_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND SCHEDULE_TO_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) sts_jit_out_late
	   -- RTS 2	   
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE < -6 THEN 1 ELSE 0 END) rts_jit_out_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -6 THEN 1 ELSE 0 END) rts_jit_six_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -5 THEN 1 ELSE 0 END) rts_jit_five_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -4 THEN 1 ELSE 0 END) rts_jit_four_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -3 THEN 1 ELSE 0 END) rts_jit_three_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -2 THEN 1 ELSE 0 END) rts_jit_two_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = -1 THEN 1 ELSE 0 END) rts_jit_one_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 0 THEN 1 ELSE 0 END) rts_jit_on_time   
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 1 THEN 1 ELSE 0 END) rts_jit_one_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 2 THEN 1 ELSE 0 END) rts_jit_two_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 3 THEN 1 ELSE 0 END) rts_jit_three_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 4 THEN 1 ELSE 0 END) rts_jit_four_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 5 THEN 1 ELSE 0 END) rts_jit_five_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE = 6 THEN 1 ELSE 0 END) rts_jit_six_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SHIP_VARIANCE > 6 THEN 1 ELSE 0 END) rts_jit_out_late
	   -- RTS 3	   
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE < -6 THEN 1 ELSE 0 END) rtsch_jit_out_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -6 THEN 1 ELSE 0 END) rtsch_jit_six_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -5 THEN 1 ELSE 0 END) rtsch_jit_five_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -4 THEN 1 ELSE 0 END) rtsch_jit_four_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -3 THEN 1 ELSE 0 END) rtsch_jit_three_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -2 THEN 1 ELSE 0 END) rtsch_jit_two_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = -1 THEN 1 ELSE 0 END) rtsch_jit_one_early
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 0 THEN 1 ELSE 0 END) rtsch_jit_on_time   
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 1 THEN 1 ELSE 0 END) rtsch_jit_one_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 2 THEN 1 ELSE 0 END) rtsch_jit_two_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 3 THEN 1 ELSE 0 END) rtsch_jit_three_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 4 THEN 1 ELSE 0 END) rtsch_jit_four_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 5 THEN 1 ELSE 0 END) rtsch_jit_five_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE = 6 THEN 1 ELSE 0 END) rtsch_jit_six_late
	   ,SUM(CASE WHEN CUSTOMER_TYPE_CODE = 'J' AND REQUEST_TO_SCHEDULE_VARIANCE > 6 THEN 1 ELSE 0 END) rtsch_jit_out_late 	     	   
	   ,ORGANIZATION_KEY_ID
	   ,TRUNC(AMP_SHIPPED_DATE,'MONTH') AMP_SHIPPED_MONTH	   
	   ,MFG_BUILDING_NBR
	   ,MFG_CAMPUS_ID
	   ,MFR_ORG_KEY_ID
	   ,PRODUCT_LINE_CODE
	   ,STOCK_MAKE_CODE	      	   
FROM    ORDER_ITEM_SHIPMENT ois	   	   	   	   	  
WHERE MFR_ORG_KEY_ID != 0
GROUP BY 
	    ORGANIZATION_KEY_ID
	   ,TRUNC(AMP_SHIPPED_DATE,'MONTH')		
	   ,MFG_BUILDING_NBR
	   ,MFG_CAMPUS_ID
	   ,MFR_ORG_KEY_ID
	   ,PRODUCT_LINE_CODE
	   ,STOCK_MAKE_CODE
;

smry_rec smry_cur%ROWTYPE;

  vgn_ship_out_early     NUMBER;
  vgn_ship_six_early     NUMBER;
  vgn_ship_five_early    NUMBER;
  vgn_ship_four_early    NUMBER;
  vgn_ship_three_early   NUMBER;
  vgn_ship_two_early     NUMBER;
  vgn_ship_one_early     NUMBER;
  vgn_ship_on_time       NUMBER;
  vgn_ship_one_late      NUMBER;
  vgn_ship_two_late      NUMBER;
  vgn_ship_three_late    NUMBER;
  vgn_ship_four_late     NUMBER;
  vgn_ship_five_late     NUMBER;
  vgn_ship_six_late      NUMBER;
  vgn_ship_out_late      NUMBER;
  vgn_jit_out_early      NUMBER;
  vgn_jit_six_early      NUMBER;
  vgn_jit_five_early     NUMBER;
  vgn_jit_four_early     NUMBER;
  vgn_jit_three_early    NUMBER;
  vgn_jit_two_early      NUMBER;
  vgn_jit_one_early      NUMBER;
  vgn_jit_on_time        NUMBER;
  vgn_jit_one_late       NUMBER;
  vgn_jit_two_late       NUMBER;
  vgn_jit_three_late     NUMBER;
  vgn_jit_four_late      NUMBER;
  vgn_jit_five_late      NUMBER;
  vgn_jit_six_late       NUMBER;
  vgn_jit_out_late       NUMBER;
  vgn_varbl_out_early    NUMBER;
  vgn_varbl_six_early    NUMBER;
  vgn_varbl_five_early   NUMBER;
  vgn_varbl_four_early   NUMBER;
  vgn_varbl_three_early  NUMBER;
  vgn_varbl_two_early    NUMBER;
  vgn_varbl_one_early    NUMBER;
  vgn_varbl_on_time      NUMBER;
  vgn_varbl_one_late     NUMBER;
  vgn_varbl_two_late     NUMBER;
  vgn_varbl_three_late   NUMBER;
  vgn_varbl_four_late    NUMBER;
  vgn_varbl_five_late    NUMBER;
  vgn_varbl_six_late     NUMBER;
  vgn_varbl_out_late     NUMBER;
  vgn_total_jit_ship     NUMBER;
  vgn_total_shipments    NUMBER;

PROCEDURE p_insert_smry_rec IS
BEGIN
  -- get correct values
  IF vgc_smry_type = '1' THEN -- STS
     vgn_ship_out_early := smry_rec.sts_ship_out_early;
     vgn_ship_six_early := smry_rec.sts_ship_six_early;
     vgn_ship_five_early := smry_rec.sts_ship_five_early;
     vgn_ship_four_early := smry_rec.sts_ship_four_early;
     vgn_ship_three_early := smry_rec.sts_ship_three_early;
     vgn_ship_two_early := smry_rec.sts_ship_two_early;
     vgn_ship_one_early := smry_rec.sts_ship_one_early;
     vgn_ship_on_time := smry_rec.sts_ship_on_time;
     vgn_ship_one_late := smry_rec.sts_ship_one_late;
     vgn_ship_two_late := smry_rec.sts_ship_two_late;
     vgn_ship_three_late := smry_rec.sts_ship_three_late;
     vgn_ship_four_late := smry_rec.sts_ship_four_late;
     vgn_ship_five_late := smry_rec.sts_ship_five_late;
     vgn_ship_six_late := smry_rec.sts_ship_six_late;
     vgn_ship_out_late := smry_rec.sts_ship_out_late;
     vgn_jit_out_early := smry_rec.sts_jit_out_early;
     vgn_jit_six_early := smry_rec.sts_jit_six_early;
     vgn_jit_five_early := smry_rec.sts_jit_five_early;
     vgn_jit_four_early := smry_rec.sts_jit_four_early;
     vgn_jit_three_early := smry_rec.sts_jit_three_early;
     vgn_jit_two_early := smry_rec.sts_jit_two_early;
     vgn_jit_one_early := smry_rec.sts_jit_one_early;
     vgn_jit_on_time := smry_rec.sts_jit_on_time;
     vgn_jit_one_late := smry_rec.sts_jit_one_late;
     vgn_jit_two_late := smry_rec.sts_jit_two_late;
     vgn_jit_three_late := smry_rec.sts_jit_three_late;
     vgn_jit_four_late := smry_rec.sts_jit_four_late;
     vgn_jit_five_late := smry_rec.sts_jit_five_late;
     vgn_jit_six_late := smry_rec.sts_jit_six_late;
     vgn_jit_out_late := smry_rec.sts_jit_out_late;
--     vgn_total_jit_ship := smry_rec.total_jit_ship;
     vgn_varbl_out_early := smry_rec.sts_varbl_out_early;
     vgn_varbl_six_early := smry_rec.sts_varbl_six_early;
     vgn_varbl_five_early := smry_rec.sts_varbl_five_early;
     vgn_varbl_four_early := smry_rec.sts_varbl_four_early;
     vgn_varbl_three_early := smry_rec.sts_varbl_three_early;
     vgn_varbl_two_early := smry_rec.sts_varbl_two_early;
     vgn_varbl_one_early := smry_rec.sts_varbl_one_early;
     vgn_varbl_on_time := smry_rec.sts_varbl_on_time;
     vgn_varbl_one_late := smry_rec.sts_varbl_one_late;
     vgn_varbl_two_late := smry_rec.sts_varbl_two_late;
     vgn_varbl_three_late := smry_rec.sts_varbl_three_late;
     vgn_varbl_four_late := smry_rec.sts_varbl_four_late;
     vgn_varbl_five_late := smry_rec.sts_varbl_five_late;
     vgn_varbl_six_late := smry_rec.sts_varbl_six_late;
     vgn_varbl_out_late := smry_rec.sts_varbl_out_late;
	 
  ELSIF vgc_smry_type = '2' THEN -- RTS
     vgn_ship_out_early := smry_rec.rts_ship_out_early;
     vgn_ship_six_early := smry_rec.rts_ship_six_early;
     vgn_ship_five_early := smry_rec.rts_ship_five_early;
     vgn_ship_four_early := smry_rec.rts_ship_four_early;
     vgn_ship_three_early := smry_rec.rts_ship_three_early;
     vgn_ship_two_early := smry_rec.rts_ship_two_early;
     vgn_ship_one_early := smry_rec.rts_ship_one_early;
     vgn_ship_on_time := smry_rec.rts_ship_on_time;
     vgn_ship_one_late := smry_rec.rts_ship_one_late;
     vgn_ship_two_late := smry_rec.rts_ship_two_late;
     vgn_ship_three_late := smry_rec.rts_ship_three_late;
     vgn_ship_four_late := smry_rec.rts_ship_four_late;
     vgn_ship_five_late := smry_rec.rts_ship_five_late;
     vgn_ship_six_late := smry_rec.rts_ship_six_late;
     vgn_ship_out_late := smry_rec.rts_ship_out_late;
     vgn_jit_out_early := smry_rec.rts_jit_out_early;
     vgn_jit_six_early := smry_rec.rts_jit_six_early;
     vgn_jit_five_early := smry_rec.rts_jit_five_early;
     vgn_jit_four_early := smry_rec.rts_jit_four_early;
     vgn_jit_three_early := smry_rec.rts_jit_three_early;
     vgn_jit_two_early := smry_rec.rts_jit_two_early;
     vgn_jit_one_early := smry_rec.rts_jit_one_early;
     vgn_jit_on_time := smry_rec.rts_jit_on_time;
     vgn_jit_one_late := smry_rec.rts_jit_one_late;
     vgn_jit_two_late := smry_rec.rts_jit_two_late;
     vgn_jit_three_late := smry_rec.rts_jit_three_late;
     vgn_jit_four_late := smry_rec.rts_jit_four_late;
     vgn_jit_five_late := smry_rec.rts_jit_five_late;
     vgn_jit_six_late := smry_rec.rts_jit_six_late;
     vgn_jit_out_late := smry_rec.rts_jit_out_late;
--     vgn_total_jit_ship := smry_rec.total_jit_ship;
     vgn_varbl_out_early := smry_rec.rts_varbl_out_early;
     vgn_varbl_six_early := smry_rec.rts_varbl_six_early;
     vgn_varbl_five_early := smry_rec.rts_varbl_five_early;
     vgn_varbl_four_early := smry_rec.rts_varbl_four_early;
     vgn_varbl_three_early := smry_rec.rts_varbl_three_early;
     vgn_varbl_two_early := smry_rec.rts_varbl_two_early;
     vgn_varbl_one_early := smry_rec.rts_varbl_one_early;
     vgn_varbl_on_time := smry_rec.rts_varbl_on_time;
     vgn_varbl_one_late := smry_rec.rts_varbl_one_late;
     vgn_varbl_two_late := smry_rec.rts_varbl_two_late;
     vgn_varbl_three_late := smry_rec.rts_varbl_three_late;
     vgn_varbl_four_late := smry_rec.rts_varbl_four_late;
     vgn_varbl_five_late := smry_rec.rts_varbl_five_late;
     vgn_varbl_six_late := smry_rec.rts_varbl_six_late;
     vgn_varbl_out_late := smry_rec.rts_varbl_out_late;
  
  ELSIF vgc_smry_type = '3' THEN -- RTSch
     vgn_ship_out_early := smry_rec.rtsch_ship_out_early;
     vgn_ship_six_early := smry_rec.rtsch_ship_six_early;
     vgn_ship_five_early := smry_rec.rtsch_ship_five_early;
     vgn_ship_four_early := smry_rec.rtsch_ship_four_early;
     vgn_ship_three_early := smry_rec.rtsch_ship_three_early;
     vgn_ship_two_early := smry_rec.rtsch_ship_two_early;
     vgn_ship_one_early := smry_rec.rtsch_ship_one_early;
     vgn_ship_on_time := smry_rec.rtsch_ship_on_time;
     vgn_ship_one_late := smry_rec.rtsch_ship_one_late;
     vgn_ship_two_late := smry_rec.rtsch_ship_two_late;
     vgn_ship_three_late := smry_rec.rtsch_ship_three_late;
     vgn_ship_four_late := smry_rec.rtsch_ship_four_late;
     vgn_ship_five_late := smry_rec.rtsch_ship_five_late;
     vgn_ship_six_late := smry_rec.rtsch_ship_six_late;
     vgn_ship_out_late := smry_rec.rtsch_ship_out_late;
     vgn_jit_out_early := smry_rec.rtsch_jit_out_early;
     vgn_jit_six_early := smry_rec.rtsch_jit_six_early;
     vgn_jit_five_early := smry_rec.rtsch_jit_five_early;
     vgn_jit_four_early := smry_rec.rtsch_jit_four_early;
     vgn_jit_three_early := smry_rec.rtsch_jit_three_early;
     vgn_jit_two_early := smry_rec.rtsch_jit_two_early;
     vgn_jit_one_early := smry_rec.rtsch_jit_one_early;
     vgn_jit_on_time := smry_rec.rtsch_jit_on_time;
     vgn_jit_one_late := smry_rec.rtsch_jit_one_late;
     vgn_jit_two_late := smry_rec.rtsch_jit_two_late;
     vgn_jit_three_late := smry_rec.rtsch_jit_three_late;
     vgn_jit_four_late := smry_rec.rtsch_jit_four_late;
     vgn_jit_five_late := smry_rec.rtsch_jit_five_late;
     vgn_jit_six_late := smry_rec.rtsch_jit_six_late;
     vgn_jit_out_late := smry_rec.rtsch_jit_out_late;
--     vgn_total_jit_ship := smry_rec.total_jit_ship;
     vgn_varbl_out_early := 0;
     vgn_varbl_six_early := 0;
     vgn_varbl_five_early := 0;
     vgn_varbl_four_early := 0;
     vgn_varbl_three_early := 0;
     vgn_varbl_two_early := 0;
     vgn_varbl_one_early := 0;
     vgn_varbl_on_time := 0;
     vgn_varbl_one_late := 0;
     vgn_varbl_two_late := 0;
     vgn_varbl_three_late := 0;
     vgn_varbl_four_late := 0;
     vgn_varbl_five_late := 0;
     vgn_varbl_six_late := 0;
     vgn_varbl_out_late := 0;	 
  END IF;    
  
  INSERT
  INTO MFG_CAMPUS_BLDG_SMRY
    (MFG_CAMPUS_BLDG_SMRY_SEQ,
    DELIVERY_SMRY_TYPE,
    AMP_SHIPPED_MONTH,
 	MFR_ORG_KEY_ID,
 	ORGANIZATION_KEY_ID,
    MFG_CAMPUS_ID,
    MFG_BUILDING_NBR,
    PRODUCT_LINE_CODE,
    DML_ORACLE_ID,
    DML_TMSTMP,
    STOCK_MAKE_CODE,
    NBR_SHPMTS_OUT_RANGE_EARLY,
    NBR_SHPMTS_SIX_DAYS_EARLY,
    NBR_SHPMTS_FIVE_DAYS_EARLY,
    NBR_SHPMTS_FOUR_DAYS_EARLY,
    NBR_SHPMTS_THREE_DAYS_EARLY,
    NBR_SHPMTS_TWO_DAYS_EARLY,
    NBR_SHPMTS_ONE_DAY_EARLY,
    NBR_SHPMTS_ON_TIME,
    NBR_SHPMTS_ONE_DAY_LATE,
    NBR_SHPMTS_TWO_DAYS_LATE,
    NBR_SHPMTS_THREE_DAYS_LATE,
    NBR_SHPMTS_FOUR_DAYS_LATE,
    NBR_SHPMTS_FIVE_DAYS_LATE,
    NBR_SHPMTS_SIX_DAYS_LATE,
    NBR_SHPMTS_OUT_RANGE_LATE,
    TOTAL_NBR_SHPMTS,
    NBR_JIT_OUT_RANGE_EARLY,
    NBR_JIT_SIX_DAYS_EARLY,
    NBR_JIT_FIVE_DAYS_EARLY,
    NBR_JIT_FOUR_DAYS_EARLY,
    NBR_JIT_THREE_DAYS_EARLY,
    NBR_JIT_TWO_DAYS_EARLY,
    NBR_JIT_ONE_DAY_EARLY,
    NBR_JIT_ON_TIME,
    NBR_JIT_ONE_DAY_LATE,
    NBR_JIT_TWO_DAYS_LATE,
    NBR_JIT_THREE_DAYS_LATE,
    NBR_JIT_FOUR_DAYS_LATE,
    NBR_JIT_FIVE_DAYS_LATE,
    NBR_JIT_SIX_DAYS_LATE,
    NBR_JIT_OUT_RANGE_LATE,
    TOTAL_NBR_JIT_SHPMTS,
    NBR_VARBL_OUT_RANGE_EARLY,
    NBR_VARBL_SIX_DAYS_EARLY,
    NBR_VARBL_FIVE_DAYS_EARLY,
    NBR_VARBL_FOUR_DAYS_EARLY,
    NBR_VARBL_THREE_DAYS_EARLY,
    NBR_VARBL_TWO_DAYS_EARLY,
    NBR_VARBL_ONE_DAY_EARLY,
    NBR_VARBL_ON_TIME,
    NBR_VARBL_ONE_DAY_LATE,
    NBR_VARBL_TWO_DAYS_LATE,
    NBR_VARBL_THREE_DAYS_LATE,
    NBR_VARBL_FOUR_DAYS_LATE,
    NBR_VARBL_FIVE_DAYS_LATE,
    NBR_VARBL_SIX_DAYS_LATE,
    NBR_VARBL_OUT_RANGE_LATE)
  VALUES
    (MFG_CAMPUS_BLDG_SMRY_SEQ.NEXTVAL,
    vgc_smry_type,
    smry_rec.amp_shipped_month,
	smry_rec.mfr_org_key_id,
	smry_rec.organization_key_id,
    smry_rec.mfg_campus_id,
    smry_rec.mfg_building_nbr,
    smry_rec.product_line_code,
    USER,
    SYSDATE,
	smry_rec.stock_make_code,
    vgn_ship_out_early,
    vgn_ship_six_early,
    vgn_ship_five_early,
    vgn_ship_four_early,
    vgn_ship_three_early,
    vgn_ship_two_early,
    vgn_ship_one_early,
    vgn_ship_on_time,
    vgn_ship_one_late,
    vgn_ship_two_late,
    vgn_ship_three_late,
    vgn_ship_four_late,
    vgn_ship_five_late,
    vgn_ship_six_late,
    vgn_ship_out_late,
    smry_rec.total_ship,
    vgn_jit_out_early,
    vgn_jit_six_early,
    vgn_jit_five_early,
    vgn_jit_four_early,
    vgn_jit_three_early,
    vgn_jit_two_early,
    vgn_jit_one_early,
    vgn_jit_on_time,
    vgn_jit_one_late,
    vgn_jit_two_late,
    vgn_jit_three_late,
    vgn_jit_four_late,
    vgn_jit_five_late,
    vgn_jit_six_late,
    vgn_jit_out_late,
    smry_rec.total_jit_ship,
    vgn_varbl_out_early,
    vgn_varbl_six_early,
    vgn_varbl_five_early,
    vgn_varbl_four_early,
    vgn_varbl_three_early,
    vgn_varbl_two_early,
    vgn_varbl_one_early,
    vgn_varbl_on_time,
    vgn_varbl_one_late,
    vgn_varbl_two_late,
    vgn_varbl_three_late,
    vgn_varbl_four_late,
    vgn_varbl_five_late,
    vgn_varbl_six_late,
    vgn_varbl_out_late);

EXCEPTION
  WHEN OTHERS THEN
    RAISE ue_critical_db_error;
END;	

PROCEDURE p_rebuild_smry IS

BEGIN
  vlc_section := 'Process TOIS';
  vln_cnt	  := 0;

  OPEN smry_cur;
  LOOP
	BEGIN
	  FETCH smry_cur INTO smry_rec;
	  EXIT WHEN (smry_cur%NOTFOUND);

	  vgc_smry_type := '1'; --STS
	  p_insert_smry_rec;
	  
	  vgc_smry_type := '2'; --RTS
	  p_insert_smry_rec;
	  
	  vgc_smry_type := '3'; --RTSch
	  p_insert_smry_rec;	  	  
	  
      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;
	END; 
  END LOOP;
  COMMIT;  
	 
  DBMS_OUTPUT.PUT_LINE('TOIS recs found: ' || vln_cnt);
EXCEPTION
  WHEN ue_critical_db_error THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_ReSmry_MFG_Campus - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(SQLCODE)) ;
    ROLLBACK ;
  WHEN OTHERS THEN
    vgn_result := SQLCODE;
    DBMS_OUTPUT.PUT_LINE('p_ReSmry_MFG_Campus - '||vlc_section) ;
    DBMS_OUTPUT.PUT_LINE('SQL Error:  ' || SQLERRM(SQLCODE)) ;
    ROLLBACK ;
END ;


BEGIN -- main block

   p_rebuild_smry;

END ;
/
