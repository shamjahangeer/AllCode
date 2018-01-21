CREATE OR REPLACE PACKAGE Pkg_Variance_Calc
AS

/*
**********************************************************************************************************
* PACKAGE:     PKG_VARIANCE_CALC                                    
* DESCRIPTION:                                                      
* PROCEDURES:  P_COUNT_ELAPSED_DAYS                                 
*              P_VARIANCE_CALC                                      
* AUTHOR:      JOHN FASSANO  , COMPUTER AID INC,                    
* MODIFICATION LOG:                                                 
*                                                                   
*  Date       Programmer       Description
*  --------   ----------       ------------------------------------------------
*                                                                   
*  11/20/1996 J. FASSANO (CAI) NEW PROGRAM
*                                                                   
*  12/02/1996 B. ROSE          IF RELEASE DATE IS NULL, MOVE 'A' TO SHIP FAC CMPRSN CODE.                                
*  01/06/1997 J. FASSANO (CAI) SCHED TO RELEASE VARIANCE - CHANGE  TO BYPASS GRACE DAY IF TEMP HOLD PERIOD 
*                              IS EQUAL TO VARIANCE                                 
*  04/07/1997 J. FASSANO (CAI) SSR 3681 REL 2.0 CHANGE RELEASE TO SHIP TO INCLUDE ALL LOGIC FOR WAREHOUSE 
*                              LATES.
*  07/01/1997 J. FASSANO (CAI) CHANGE RELEASE TO SHIP TO INCLUDE LATE CODE LOGIC.
*                              CHANGE P_COUNT_ELAPSED_DAYS FOR PERFORMANCE.
*  02/01/1998 J. KARR (CAI)    USE AMP DFLT (3 DAYS EARLY) FOR JIT CUSTOMER IN REQUEST_TO_SHIP VARIANCE
*                              CALCULATION FOR CUST VAR VIEW.
*  02/27/1998 TANVEER          Changed the p_count_elapsed_days to roll week-ends to Monday (if week-end 
*                              indicators are not turned on)
*  04/11/2001 S. Jupko         DSCD Rewrite Changes
*  08/27/2002 Alex             Changed vln_weeks variable declaration
*  10/07/2002                  Added co_orgkey_id in accessing scd_holiday table.   
*  10/07/2003 Alex             Added pick_pack_days in calculating variance.  
*  11/18/2003 Alex             Enhanced logic on credit hold and overlap ofcredit hold and temp hold.
*  12/16/2003 Alex             Fix logic error in using pick pack days.
*  10/05/2004 Alex             Added urgent order logic for REQSHP AND REQSCH.
*  05/31/2005 Alex             Add logic to use the weekend and holiday tables to get the next working day. 
*                              Also make sure a value is assign to 1ston_date when there is creadit 
*                              hold/delivery block ovarlap.     
*  09/07/2006 Alex             Add logic to set RTS=0 when Distr Ship When Avail='Y' and Shipped Dt <= Sched Dt.              
*  11/10/2008 Alex             Add logic to recalculate Release to Ship when late and Consolidated flag='Y' 
*                              and _date is available.
*  10/16/2012 Kumar Emany      Modified P_COUNT_ELAPSED_DAYS Procedure for PPSOC related changes
*                              
**********************************************************************************************************
*/

PROCEDURE p_variance_CALC
( OIS        IN OUT TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE
, VON_RESULT OUT NUMBER );

END Pkg_Variance_Calc;
/

-- ===========================================================================================================
CREATE OR REPLACE PACKAGE BODY Pkg_Variance_Calc
AS

 VGN_CUST_VAR_WINDOW_DAYS_EARLY ORDER_ITEM_SHIPMENT.NBR_WINDOW_DAYS_EARLY%TYPE;
 VGD_START_DATE                 DATE;
 VGD_END_DATE                   DATE;
 VGN_VARIANCE_DAYS              NUMBER;
 VGN_CALC_VARIANCE              NUMBER;
 VGC_CALC_VARIANCE_CMPRSN_CODE  VARCHAR2(1);
 VGC_SAT_SHIP                   VARCHAR2(1);
 VGC_SUN_SHIP                   VARCHAR2(1);
 VGC_PREV_BLDG                  VARCHAR2(4) := '    ';
 VGC_PREV_LOC                   VARCHAR2(4) := '    ';
 VGC_BUILDING                   VARCHAR2(4);
 VGC_LOCATION                   VARCHAR2(4);
 VGC_CO_ORG_ID                  VARCHAR2(4);
 VGN_CO_ORGKEY_ID               SCORECARD_HOLIDAY.COMPANY_ORG_KEY_ID%TYPE;
 
 k_loca_00       CONSTANT VARCHAR2(2) := '00';
 k_loca_asterisk CONSTANT VARCHAR2(1) := '*';
 k_loca_HL       CONSTANT VARCHAR2(2) := 'HL';
 k_bldg_000      CONSTANT VARCHAR2(3) := '000';
 k_bldg_XSC      CONSTANT VARCHAR2(3) := 'XSC';
 k_begin_of_time CONSTANT DATE        := TO_DATE('00010101', 'YYYYMMDD');
 VGN_RESULT      NUMBER;
 
 /* tanveer 1/14/1999 added these to display as part of error message */
 vgc_amp_order_nbr  ORDER_ITEM_SHIPMENT.amp_order_nbr%TYPE;
 vgc_order_item_nbr ORDER_ITEM_SHIPMENT.order_item_nbr%TYPE;
 vgc_shipment_id    ORDER_ITEM_SHIPMENT.shipment_id%TYPE;
 /* end tanveer change */
 
 -- Added for PPSOC changes Kumar 10/16/2012
 vgc_data_source_desc ORDER_ITEM_SHIPMENT.data_source_desc%TYPE;
 
 UE_CRITICAL_DB_ERROR EXCEPTION;
 
 TYPE CommonFldsType IS RECORD (
 SCHEDULE_OFF_CREDIT_HOLD_DATE DATE,
 SCHEDULE_ON_CREDIT_HOLD_DATE  DATE,
 TEMP_HOLD_OFF_DATE            DATE,
 TEMP_HOLD_ON_DATE             DATE,
 AMP_SHIPPED_DATE              DATE,
 RELEASE_DATE                  DATE,
 CUSTOMER_EXPEDITE_DATE        DATE,
 CUSTOMER_REQUEST_DATE         DATE,
 CUSTOMER_TYPE_CODE            ORDER_ITEM_SHIPMENT.CUSTOMER_TYPE_CODE%TYPE,
 PICK_PACK_WORK_DAYS_QTY       ORDER_ITEM_SHIPMENT.PICK_PACK_WORK_DAYS_QTY%TYPE );
 
 gCommonFldsRec CommonFldsType;
 
 vgn_urgent_ord_offset_days NUMBER(1) := TO_NUMBER(scdcommonbatch.GetParamValueLocal('UrgentOrderOffsetDays'));

/*******************************************************************/
/* PROCEDURE:    P_COUNT_ELAPSED_DAYS                              */
/* DESCRIPTION:  Count the number of workdays between start and end*/
/*               dates. Weekends are not counted unless there is   */
/*               a match to the scorecard_wekend_ship table.       */
/*               Holidays are not counted.                         */
/*******************************************************************/

PROCEDURE p_count_elapsed_days 
AS

 vld_start_date   DATE;
 vld_end_date     DATE;
 vld_test_date    DATE;
 vlc_day_of_week  VARCHAR2(1);
 vln_holidays     NUMBER;
 vln_weeks        NUMBER; --(5);
 vln_remain       NUMBER(1);
 vln_weekend_days NUMBER(1);
 vln_day_of_week  NUMBER(1);
 vlb_work_day     BOOLEAN;

BEGIN

   IF vgd_start_date = k_begin_of_time THEN
      vgn_variance_days := -999;
      GOTO end_procedure;
   END IF;

   IF vgd_end_date = k_begin_of_time THEN
      vgn_variance_days := -999;
      GOTO end_procedure;
   END IF;

   IF Vgd_start_date = vgd_end_date THEN
      vgn_variance_days := 0;
      GOTO end_procedure;
   END IF;

   IF vgd_start_date < vgd_end_date THEN
      vld_start_date := vgd_start_date;
      vld_end_date   := vgd_end_date;
   ELSE
      vld_start_date := vgd_end_date;
      vld_end_date   := vgd_start_date;
   END IF;

   vld_test_date     := vld_start_date;
   vgn_variance_days := 0;

   /***************************************************************/
   /*   WEEKEND SHIP LOGIC                                        */
   /*     MATCH SCORECARD_WEEKEND_SHIP TABLE                      */
   /***************************************************************/
   IF vgc_building <> vgc_prev_bldg OR vgc_location <> vgc_prev_loc THEN
      BEGIN
         SELECT NVL(sat_ship_ind, 'N'), NVL(sun_ship_ind, 'N')
         INTO   vgc_sat_ship, vgc_sun_ship
         FROM   scorecard_weekend_ship
         WHERE  building_nbr = vgc_building
         AND    (location_code = vgc_location OR
                 location_code = k_loca_asterisk OR
                 location_code = k_loca_00); /* Added this condition - Tanveer 2/27/1998 */
      
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            vgc_sat_ship := 'N';
            vgc_sun_ship := 'N';
      END;
   END IF;

   vgc_prev_bldg := vgc_building;
   vgc_prev_loc  := vgc_location;

   /***************************************************************/
   /*   END OF WEEKEND SHIP LOGIC                                 */
   /***************************************************************/

   /***************************************************************/
   /*   COUNT ELAPSED DAYS                                        */
   /***************************************************************/
   vln_weekend_days := 2;
   IF vgc_sat_ship = 'Y' THEN
      vln_weekend_days := vln_weekend_days - 1;
   END IF;

   IF vgc_sun_ship = 'Y' THEN
      vln_weekend_days := vln_weekend_days - 1;
   END IF;
   vgn_variance_days := vld_end_date - vld_start_date;
   vln_weeks         := TRUNC(vgn_variance_days / 7);
   vln_remain        := vgn_variance_days - (vln_weeks * 7);
   vlc_day_of_week   := TO_CHAR(vld_start_date, 'D');
   vln_day_of_week   := TO_NUMBER(vlc_day_of_week, '9');

   /* Changed " VLN_REMAIN < (7 - VLN_DAY_OF_WEEK) " to
   " VLN_REMAIN <= (7 - VLN_DAY_OF_WEEK) " - Tanveer 2/27/1998 */

   IF vln_remain <= (7 - vln_day_of_week) THEN
      vgn_variance_days := vgn_variance_days - (vln_weeks * vln_weekend_days);
   ELSE
      vgn_variance_days := vgn_variance_days - ((vln_weeks + 1) * vln_weekend_days);
   END IF;

   /* Added the following new lines - Tanveer 2/27/1998 */
   IF TO_NUMBER(TO_CHAR(vld_end_date, 'D'), '9') = 1 AND vgc_sun_ship = 'N' AND
      TO_NUMBER(TO_CHAR(vld_start_date, 'D'), '9') <> 1 THEN
      vgn_variance_days := vgn_variance_days + 1;
   ELSIF TO_NUMBER(TO_CHAR(vld_start_date, 'D'), '9') = 1 AND
         vgc_sun_ship = 'N' AND
         TO_NUMBER(TO_CHAR(vld_end_date, 'D'), '9') <> 1 THEN
      vgn_variance_days := vgn_variance_days - 1;
   END IF;

   /* Commented this part of the original code - Tanveer 2/27/1998 */
   /* IF VLN_DAY_OF_WEEK = 1 THEN
       VGN_VARIANCE_DAYS :=VGN_VARIANCE_DAYS - 1;
   END IF; */

   /***************************************************************/
   /*   HOLIDAY TABLE PROCESSING                                  */
   /***************************************************************/
   /* TEST FOR HOLIDAYS FOR ALL LOCS IN A BUILDING                */
   /* LOCATION_CODE = '00' IN HOLIDAY TABLE                       */
   
   vln_holidays := 0;
   SELECT COUNT(*)
   INTO   vln_holidays
   FROM   scorecard_holiday
   WHERE  building_nbr = vgc_building
   AND    (location_code = vgc_location OR location_code = k_loca_00 OR
         location_code = k_loca_asterisk) /* Added this condition - Tanveer 2/27/1998 */
   AND    COMPANY_ORG_KEY_ID = VGN_CO_ORGKEY_ID
   AND    (co_holiday_date BETWEEN vld_start_date AND vld_end_date);

   IF vln_holidays > 0 THEN
      vgn_variance_days := vgn_variance_days - vln_holidays;

   -- Added for PPSOC changes Kumar 10/16/2012
   ELSE
      IF vgc_data_source_desc IN ( 'ADCSAPABC', 'TYCOSAPABC' ) THEN
         SELECT COUNT(*)
         INTO   vln_holidays
         FROM   scorecard_holiday
         WHERE  building_nbr = vgc_building
         AND    (location_code = vgc_location)
         AND    (co_holiday_date BETWEEN vld_start_date AND vld_end_date)
         -- AND    company_org_key_id = vgn_co_orgkey_id         
         ;
         IF vln_holidays > 0 THEN
            vgn_variance_days := vgn_variance_days - vln_holidays;
         END IF;         
      END IF;
   -- Added for PPSOC changes Kumar 10/16/2012
   END IF;

   /* SPECIAL PROCESSING FOR DOMESTIC SCHEDULES                   */
   /* DOMESTIC NATIONAL HOLIDAYS ARE LOADED AS BLDG = '000' AND   */
   /* LOCATION = '00'.                                            */
   /* DOMESTIC NATIONAL EXCEPTIONS ARE LOADED AS BLDG = 'XSC' AND */
   /* LOCATION = 'HL'.                                            */

   IF VGC_CO_ORG_ID = Scdcommonbatch.gUSCoOrgID THEN
      VLN_HOLIDAYS := 0;
      SELECT COUNT(*)
      INTO   VLN_HOLIDAYS
      FROM   SCORECARD_HOLIDAY
      WHERE  ((BUILDING_NBR = k_bldg_000 AND LOCATION_CODE = k_loca_00) OR
             (BUILDING_NBR = k_bldg_XSC AND LOCATION_CODE = k_loca_HL))
      AND    COMPANY_ORG_KEY_ID = VGN_CO_ORGKEY_ID
      AND    (CO_HOLIDAY_DATE BETWEEN VLD_START_DATE AND VLD_END_DATE);
      IF VLN_HOLIDAYS > 0 THEN
         VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS - VLN_HOLIDAYS;
      END IF;
   END IF;
   
   IF VGN_VARIANCE_DAYS > 999 THEN
      VGN_VARIANCE_DAYS := 999;
   END IF;

   IF vgd_start_date > vgd_end_date THEN
      vgn_variance_days := vgn_variance_days * -1;
   END IF;

   <<end_procedure>>
   NULL;

EXCEPTION
   WHEN OTHERS THEN
      VGN_RESULT := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_COUNT_ELAPSED_DAYS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(VGN_RESULT));
      /* tanveer 1/14/1999 added to display key as part of error message */
      DBMS_OUTPUT.PUT_LINE(vgc_amp_order_nbr || ' ' || vgc_order_item_nbr || ' ' || vgc_shipment_id);
      /* tanveer - end change */

END p_count_elapsed_days;

-- ----------------------------------------------------------------------------------------------------------
FUNCTION f_get_next_work_day(ref_dt DATE) RETURN DATE 
AS

 vld_next_work_dt DATE;
 vlb_is_work_day  BOOLEAN;
 vln_holidays     NUMBER(3);
 
BEGIN

   -- if null weekend is non-work day
   vgc_sat_ship := NVL(vgc_sat_ship, 'N');
   vgc_sun_ship := NVL(vgc_sun_ship, 'N');

   vlb_is_work_day  := TRUE;
   vld_next_work_dt := ref_dt;
   
   LOOP
      -- it's assumed weekend work day indicator already been determined 
      -- so need to access again the week end table
      IF TO_CHAR(vld_next_work_dt, 'D') = '1' THEN
         -- Sunday
         IF vgc_sun_ship = 'N' THEN
            vlb_is_work_day := FALSE;
         END IF;
      ELSIF TO_CHAR(vld_next_work_dt, 'D') = '7' THEN
         -- Saturday     
         IF vgc_sat_ship = 'N' THEN
            vlb_is_work_day := FALSE;
         END IF;
      ELSE
         vlb_is_work_day := TRUE;
      END IF;
   
      -- check maybe holiday
      IF vlb_is_work_day THEN
         --TEST FOR HOLIDAYS FOR ALL LOCS IN A BUILDING                
         --LOCATION_CODE = '00' IN HOLIDAY TABLE                       
         vln_holidays := 0;
         SELECT COUNT(*)
         INTO   vln_holidays
         FROM   scorecard_holiday
         WHERE  building_nbr = vgc_building
         AND    (location_code = vgc_location OR location_code = k_loca_00 OR
               location_code = k_loca_asterisk)
         AND    COMPANY_ORG_KEY_ID = VGN_CO_ORGKEY_ID
         AND    co_holiday_date = vld_next_work_dt;
      
         IF vln_holidays > 0 THEN
            vlb_is_work_day := FALSE;
         ELSE
            -- SPECIAL PROCESSING FOR DOMESTIC SCHEDULES                   
            -- DOMESTIC NATIONAL HOLIDAYS ARE LOADED AS BLDG = '000' AND   
            -- LOCATION = '00'.                                            
            -- DOMESTIC NATIONAL EXCEPTIONS ARE LOADED AS BLDG = 'XSC' AND 
            -- LOCATION = 'HL'.                                            
            IF VGC_CO_ORG_ID = Scdcommonbatch.gUSCoOrgID THEN
               VLN_HOLIDAYS := 0;
               SELECT COUNT(*)
               INTO   VLN_HOLIDAYS
               FROM   SCORECARD_HOLIDAY
               WHERE  ((BUILDING_NBR = k_bldg_000 AND
                      LOCATION_CODE = k_loca_00) OR
                      (BUILDING_NBR = k_bldg_XSC AND
                      LOCATION_CODE = k_loca_HL))
               AND    COMPANY_ORG_KEY_ID = VGN_CO_ORGKEY_ID
               AND    CO_HOLIDAY_DATE = vld_next_work_dt;
            
               IF vln_holidays > 0 THEN
                  vlb_is_work_day := FALSE;
               END IF;
            END IF;
         END IF;
      END IF;
   
      IF vlb_is_work_day THEN
         EXIT;
      ELSE
         vld_next_work_dt := vld_next_work_dt - 1;
      END IF;
   END LOOP;

   RETURN vld_next_work_dt;
   
EXCEPTION
   WHEN OTHERS THEN
      VGN_RESULT := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_COUNT_ELAPSED_DAYS');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(VGN_RESULT));
      DBMS_OUTPUT.PUT_LINE(vgc_amp_order_nbr || ' ' || vgc_order_item_nbr || ' ' || vgc_shipment_id);
   
END f_get_next_work_day;

-- ----------------------------------------------------------------------------------------------------------
PROCEDURE p_compute_variance_days
( vic_var_ind IN VARCHAR2
, OIS         IN CommonFldsType
, COMMIT_DATE IN OUT DATE ) 
AS

 CSTMR_COMMIT_DATE     DATE;
 vlb_credithold_on     BOOLEAN := FALSE;
 vlb_temphold_on       BOOLEAN := FALSE;
 vlb_overlap_on        BOOLEAN := FALSE;
 vlb_credit_is2nd      BOOLEAN := FALSE;
 vlb_temp_is2nd        BOOLEAN := FALSE;
 vlb_allhavedates      BOOLEAN := FALSE;
 vld_1ston_date        DATE;
 vld_1stoff_date       DATE;
 vld_2ndon_date        DATE;
 vld_2ndoff_date       DATE;
 vld_target_date       DATE;
 vln_tmp_commit        DATE;
 vlb_consider_pickpack BOOLEAN := TRUE;

BEGIN

   --  NOW CHECK TO SEE IF THERE WAS A VALID DATE EXCEPTION
   --   TO PREVENT AMP FROM MEETING THE COMMIT DATE.

   -- check for both credit hold AND temp hold
   IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL AND
      OIS.SCHEDULE_ON_CREDIT_HOLD_DATE IS NOT NULL AND
      OIS.TEMP_HOLD_OFF_DATE IS NOT NULL AND
      OIS.TEMP_HOLD_ON_DATE IS NOT NULL AND
      OIS.SCHEDULE_ON_CREDIT_HOLD_DATE <> k_begin_of_time AND
      OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE <> k_begin_of_time AND
      OIS.TEMP_HOLD_ON_DATE <> k_begin_of_time AND
      OIS.TEMP_HOLD_OFF_DATE <> k_begin_of_time THEN
      vlb_allhavedates := TRUE;
      -- check for overlap
      IF (OIS.TEMP_HOLD_ON_DATE BETWEEN OIS.SCHEDULE_ON_CREDIT_HOLD_DATE AND
         OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE OR
         OIS.TEMP_HOLD_OFF_DATE BETWEEN OIS.SCHEDULE_ON_CREDIT_HOLD_DATE AND
         OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE) OR
         (OIS.SCHEDULE_ON_CREDIT_HOLD_DATE BETWEEN OIS.TEMP_HOLD_ON_DATE AND
         OIS.TEMP_HOLD_OFF_DATE OR
         OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE BETWEEN OIS.TEMP_HOLD_ON_DATE AND
         OIS.TEMP_HOLD_OFF_DATE) THEN
         -- with overlap    
         IF COMMIT_DATE < OIS.TEMP_HOLD_ON_DATE AND
            COMMIT_DATE < OIS.SCHEDULE_ON_CREDIT_HOLD_DATE THEN
            -- commit < 1st on date
            vlb_overlap_on := TRUE;
            IF OIS.SCHEDULE_ON_CREDIT_HOLD_DATE < OIS.TEMP_HOLD_ON_DATE THEN
               vld_1ston_date := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
            ELSE
               vld_1ston_date := OIS.TEMP_HOLD_ON_DATE;
            END IF;
            IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE > OIS.TEMP_HOLD_OFF_DATE THEN
               vld_2ndoff_date  := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
               vlb_credit_is2nd := TRUE;
            ELSE
               vld_2ndoff_date := OIS.TEMP_HOLD_OFF_DATE;
               vlb_temp_is2nd  := TRUE;
            END IF;
            vlb_overlap_on := TRUE;
            GOTO end_chkdt_xceptn;
         ELSE
            -- commit >= 1st on date
            IF COMMIT_DATE BETWEEN OIS.SCHEDULE_ON_CREDIT_HOLD_DATE AND
               OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE OR
               COMMIT_DATE BETWEEN OIS.TEMP_HOLD_ON_DATE AND
               OIS.TEMP_HOLD_OFF_DATE THEN
               -- commit within one/or both date blocks
               vlb_overlap_on := TRUE;
               IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE > OIS.TEMP_HOLD_OFF_DATE THEN
                  vld_2ndoff_date               := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                  VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
                  vlb_credit_is2nd              := TRUE;
               ELSE
                  vld_2ndoff_date               := OIS.TEMP_HOLD_OFF_DATE;
                  VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
                  vlb_temp_is2nd                := TRUE;
               END IF;
               COMMIT_DATE := vld_2ndoff_date;
               IF OIS.SCHEDULE_ON_CREDIT_HOLD_DATE < OIS.TEMP_HOLD_ON_DATE THEN
                  vld_1ston_date := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
               ELSE
                  vld_1ston_date := OIS.TEMP_HOLD_ON_DATE;
               END IF;
               GOTO end_chkdt_xceptn;
               /*
               ELSIF COMMIT_DATE BETWEEN  
                    OIS.SCHEDULE_ON_CREDIT_HOLD_DATE AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE
                  OR COMMIT_DATE BETWEEN 
                     OIS.TEMP_HOLD_ON_DATE AND OIS.TEMP_HOLD_OFF_DATE THEN -- commit witin one of date blocks
                  IF COMMIT_DATE BETWEEN  
                      OIS.SCHEDULE_ON_CREDIT_HOLD_DATE AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE
                    AND OIS.TEMP_HOLD_OFF_DATE > OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE THEN
                    vlb_overlap_on := TRUE;
                       vld_2ndoff_date := OIS.TEMP_HOLD_OFF_DATE;
                    vlb_temp_is2nd := TRUE;            
                   COMMIT_DATE := vld_2ndoff_date;
                   VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
                   GOTO end_chkdt_xceptn;
                  ELSIF COMMIT_DATE BETWEEN OIS.TEMP_HOLD_ON_DATE AND OIS.TEMP_HOLD_OFF_DATE
                     AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE > OIS.TEMP_HOLD_OFF_DATE THEN 
                    vlb_overlap_on := TRUE;
                       vld_2ndoff_date := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                    vlb_credit_is2nd := TRUE;            
                   COMMIT_DATE := vld_2ndoff_date;
                   VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
                   GOTO end_chkdt_xceptn;
                 END IF;
               */
            END IF;
         END IF;
      ELSE
         -- no overlap
         -- determine the 1st AND 2nd dates
         IF OIS.TEMP_HOLD_OFF_DATE < OIS.SCHEDULE_ON_CREDIT_HOLD_DATE THEN
            vld_1ston_date   := OIS.TEMP_HOLD_ON_DATE;
            vld_1stoff_date  := OIS.TEMP_HOLD_OFF_DATE;
            vld_2ndon_date   := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
            vld_2ndoff_date  := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
            vlb_credit_is2nd := TRUE;
         ELSIF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE < OIS.TEMP_HOLD_ON_DATE THEN
            vld_1ston_date  := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
            vld_1stoff_date := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
            vld_2ndon_date  := OIS.TEMP_HOLD_ON_DATE;
            vld_2ndoff_date := OIS.TEMP_HOLD_OFF_DATE;
            vlb_temp_is2nd  := TRUE;
         END IF;
      
         IF COMMIT_DATE >= vld_2ndon_date THEN
            -- ignore 1st block date
            NULL;
         ELSIF COMMIT_DATE < vld_1ston_date AND
               vld_1stoff_date + 1 < vld_2ndon_date THEN
            -- with gap 
            vlb_credithold_on := TRUE;
            vlb_temphold_on   := TRUE;
            GOTO end_chkdt_xceptn;
         ELSIF COMMIT_DATE >= vld_1ston_date AND COMMIT_DATE <= vld_1stoff_date AND vlb_credit_is2nd AND vld_1stoff_date + 1 < vld_2ndon_date THEN
            -- with gap
            COMMIT_DATE                   := vld_1stoff_date;
            vlb_credithold_on             := TRUE;
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
            GOTO end_chkdt_xceptn;
         ELSIF COMMIT_DATE >= vld_1ston_date AND COMMIT_DATE <= vld_1stoff_date AND vlb_temp_is2nd AND vld_1stoff_date + 1 < vld_2ndon_date THEN
            -- with gap    
            COMMIT_DATE                   := vld_1stoff_date;
            vlb_temphold_on               := TRUE;
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
            GOTO end_chkdt_xceptn;
         ELSIF COMMIT_DATE >= vld_1ston_date AND vld_1stoff_date + 1 = vld_2ndon_date THEN
            -- no gap      
            COMMIT_DATE := vld_2ndoff_date;
            IF vlb_temp_is2nd THEN
               VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
            ELSE
               VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
            END IF;
            GOTO end_chkdt_xceptn;
         END IF;
      END IF;
   END IF;

   -- check for credit hold only
   IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL AND
      OIS.SCHEDULE_ON_CREDIT_HOLD_DATE IS NOT NULL AND
      OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE AND
      OIS.SCHEDULE_ON_CREDIT_HOLD_DATE <= COMMIT_DATE AND
      OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE <> k_begin_of_time THEN
      -- CASE - NO TEMP HOLD - CREDIT HOLD PREVENTED          
      -- AMP FROM MEETING COMMIT DATE                         
      COMMIT_DATE                   := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
      VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
      vlb_credithold_on             := TRUE;
   
      -- check for temp hold -- on_date available
   ELSIF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL AND
         OIS.TEMP_HOLD_ON_DATE IS NOT NULL AND
         OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE AND
         OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE AND
         OIS.TEMP_HOLD_OFF_DATE <> k_begin_of_time THEN
      -- CASE - NO CREDIT HOLD - TEMP HOLD PREVENTED          
      -- AMP FROM MEETING COMMIT DATE                         
      COMMIT_DATE                   := OIS.TEMP_HOLD_OFF_DATE;
      VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
      vlb_temphold_on               := TRUE;
   
   END IF;

   <<end_chkdt_xceptn>>
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   --%%% LATE CODE LOGIC
   --%%% NOTE: IF SHIPMENT IS MADE BETWEEN CUST RQST DATE
   --%%%       (CUST EXP) AND SCHEDULE DATE (COMMIT DATE).
   --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   -- CASE - EARLY TO CUST REQUEST                              
   IF vic_var_ind IN ('REQSHP', 'RELSCH') THEN
      GOTO start_not_late_coded;
   END IF;

   IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
      (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE) AND
      (OIS.CUSTOMER_EXPEDITE_DATE <> k_begin_of_time) THEN
      CSTMR_COMMIT_DATE := OIS.CUSTOMER_EXPEDITE_DATE;
   ELSE
      CSTMR_COMMIT_DATE := OIS.CUSTOMER_REQUEST_DATE;
   END IF;
   
   IF (CSTMR_COMMIT_DATE < COMMIT_DATE) AND
      (OIS.AMP_SHIPPED_DATE < CSTMR_COMMIT_DATE) AND
      (OIS.CUSTOMER_TYPE_CODE <> 'J' OR OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
      COMMIT_DATE := CSTMR_COMMIT_DATE;
      IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
         (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE) AND
         (OIS.CUSTOMER_EXPEDITE_DATE <> k_begin_of_time) THEN
         VGC_CALC_VARIANCE_CMPRSN_CODE := 'E';
      ELSE
         VGC_CALC_VARIANCE_CMPRSN_CODE := 'R';
      END IF;
   END IF;

   IF vic_var_ind = 'RELSHP' THEN
      IF (CSTMR_COMMIT_DATE < COMMIT_DATE) AND
         (OIS.AMP_SHIPPED_DATE <= COMMIT_DATE) AND
         (OIS.AMP_SHIPPED_DATE >= CSTMR_COMMIT_DATE)
        --     AND (OIS.RELEASE_DATE = CSTMR_COMMIT_DATE)
         AND
         (OIS.CUSTOMER_TYPE_CODE <> 'J' OR OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
         COMMIT_DATE := CSTMR_COMMIT_DATE;
         IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
            (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE) AND
            (OIS.CUSTOMER_EXPEDITE_DATE <> k_begin_of_time) THEN
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'E';
         ELSE
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'R';
         END IF;
      END IF;
   
      GOTO start_not_late_coded;
   END IF;

   -- CASE - IF MADE WITHIN RANGE, THEN CONSIDER ON-TIME        
   -- LATE CODED                                                
   IF (CSTMR_COMMIT_DATE < COMMIT_DATE) AND
      (OIS.AMP_SHIPPED_DATE < COMMIT_DATE) AND
      (OIS.AMP_SHIPPED_DATE >= CSTMR_COMMIT_DATE) AND
      (OIS.CUSTOMER_TYPE_CODE <> 'J' OR OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
      VGN_CALC_VARIANCE             := 0;
      VGC_CALC_VARIANCE_CMPRSN_CODE := 'L';
      RETURN;
   END IF;

   <<start_not_late_coded>>

   IF vic_var_ind = 'RELSCH' THEN
      vld_target_date := OIS.RELEASE_DATE;
   ELSE
      vld_target_date := OIS.AMP_SHIPPED_DATE;
   END IF;

   -- IF NOT LATE CODED, AND COMMIT DATE AND SHIP DATE             
   -- FALL WITHIN THE CREDIT/TEMP HOLD PERIOD THEN SHIPMENT IS ON TIME.
   IF vlb_overlap_on AND (vld_2ndoff_date >= COMMIT_DATE) AND
      (vld_1ston_date <= COMMIT_DATE) AND
      (vld_2ndoff_date >= vld_target_date) AND
      (vld_1ston_date <= vld_target_date) THEN
      VGN_CALC_VARIANCE := 0;
      IF vlb_credit_is2nd THEN
         VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
      ELSE
         VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
      END IF;
      RETURN;
      -- IF NOT LATE CODED, AND COMMIT DATE AND SHIP DATE             
      -- FALL WITHIN THE CREDIT HOLD PERIOD THEN SHIPMENT IS ON TIME.
   ELSIF vlb_credithold_on AND
         (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL) AND
         (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE) AND
         (OIS.SCHEDULE_ON_CREDIT_HOLD_DATE <= COMMIT_DATE) AND
         (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= vld_target_date) AND
         (OIS.SCHEDULE_ON_CREDIT_HOLD_DATE <= vld_target_date) THEN
      VGN_CALC_VARIANCE             := 0;
      VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
      RETURN;
      -- IF NOT LATE CODED, AND COMMIT DATE AND SHIP DATE             
      -- FALL WITHIN THE TEMPORARY HOLD PERIOD THEN SHIPMENT IS ON TIME.
   ELSIF vlb_temphold_on AND (OIS.TEMP_HOLD_OFF_DATE IS NOT NULL) AND
         (OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE) AND
         (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE) AND
         (OIS.TEMP_HOLD_OFF_DATE >= vld_target_date) AND
         (OIS.TEMP_HOLD_ON_DATE <= vld_target_date) THEN
      VGN_CALC_VARIANCE             := 0;
      VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
      RETURN;
   ELSE
      -- IF NOT LATE CODED, THEN CALCULATE THE VARIANCE
      IF vic_var_ind = 'RELSHP' THEN
         -- for release to ship only            
         IF OIS.RELEASE_DATE > COMMIT_DATE THEN
            COMMIT_DATE                   := OIS.RELEASE_DATE;
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'A';
         END IF;
      END IF;
   
      VGD_START_DATE := COMMIT_DATE;
      VGD_END_DATE   := vld_target_date;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
   
      VGN_CALC_VARIANCE := VGN_VARIANCE_DAYS;
   END IF;

   <<end_not_late_coded>>

   IF (VGC_CALC_VARIANCE_CMPRSN_CODE = 'T' OR
      VGC_CALC_VARIANCE_CMPRSN_CODE = 'C') AND (VGN_CALC_VARIANCE <> 0) AND
      (VGN_CALC_VARIANCE <> -999) THEN
      --ALLOW GRACE DAY - TAKES A DAY TO ALLOW SHIPMENT 
      --AFTER A TEMP HOLD OR CREDIT HOLD COMES OFF.     
      IF VGN_CALC_VARIANCE > 0 THEN
         IF OIS.PICK_PACK_WORK_DAYS_QTY != 0 AND vlb_consider_pickpack THEN
            VGN_CALC_VARIANCE     := VGN_CALC_VARIANCE -
                                     OIS.PICK_PACK_WORK_DAYS_QTY;
            vlb_consider_pickpack := FALSE;
         ELSE
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE - 1;
         END IF;
      ELSE
         VGN_CALC_VARIANCE := VGN_CALC_VARIANCE + 1;
      END IF;
   ELSIF VGN_CALC_VARIANCE > 0 AND
         VGC_CALC_VARIANCE_CMPRSN_CODE IN ('S', 'R') THEN
      -- check maybe temp_/credit_off dates is < COMMIT date 
      IF OIS.PICK_PACK_WORK_DAYS_QTY > 0 AND
         (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL OR
         OIS.TEMP_HOLD_OFF_DATE IS NOT NULL) AND
         NVL(OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE, k_begin_of_time) <
         COMMIT_DATE AND
         NVL(OIS.TEMP_HOLD_OFF_DATE, k_begin_of_time) < COMMIT_DATE THEN
      
         -- get new commit date and make sure it is working day 
         vln_tmp_commit := f_get_next_work_day(COMMIT_DATE - OIS.PICK_PACK_WORK_DAYS_QTY);
         --     IF TO_CHAR(vln_tmp_commit,'D') = '1' THEN 
         --        vln_tmp_commit := vln_tmp_commit - 2; -- a Sunday so make it a Friday
         --     ELSIF TO_CHAR(vln_tmp_commit,'D') = '7' THEN   
         --          vln_tmp_commit := vln_tmp_commit - 1; -- a Saturday so make it a Friday
         --     END IF;
      
         -- if highest _off date >= new commit date then recalc variance
         IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= vln_tmp_commit OR
            OIS.TEMP_HOLD_OFF_DATE >= vln_tmp_commit THEN
            IF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL THEN
               vln_tmp_commit                := OIS.TEMP_HOLD_OFF_DATE;
               VGC_CALC_VARIANCE_CMPRSN_CODE := 'T';
               IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE > vln_tmp_commit THEN
                  vln_tmp_commit                := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                  VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
               END IF;
            ELSE
               vln_tmp_commit                := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
               VGC_CALC_VARIANCE_CMPRSN_CODE := 'C';
            END IF;
            IF vln_tmp_commit IS NOT NULL THEN
               COMMIT_DATE := vln_tmp_commit;
            END IF;
         
            -- recalc variance base on new COMMIT date 
            VGD_START_DATE := COMMIT_DATE;
            VGD_END_DATE   := vld_target_date;
            P_COUNT_ELAPSED_DAYS;
            IF VGN_RESULT <> 0 THEN
               RAISE UE_CRITICAL_DB_ERROR;
            END IF;
            VGN_CALC_VARIANCE := VGN_VARIANCE_DAYS;
         
            -- consider pickpack days  
            IF VGN_CALC_VARIANCE > 0 THEN
               IF vlb_consider_pickpack THEN
                  VGN_CALC_VARIANCE     := VGN_CALC_VARIANCE - OIS.PICK_PACK_WORK_DAYS_QTY;
                  vlb_consider_pickpack := FALSE;
               ELSE
                  VGN_CALC_VARIANCE := VGN_CALC_VARIANCE - 1;
               END IF;
            ELSE
               VGN_CALC_VARIANCE := VGN_CALC_VARIANCE + 1;
            END IF;
         END IF;
      END IF;
   END IF;

   -- if there is overlap and occurs after the commit
   -- then subtract it out of variance
   IF vlb_overlap_on AND vld_1ston_date > COMMIT_DATE AND
      (vld_2ndoff_date > COMMIT_DATE) AND
      (vld_2ndoff_date <= vld_target_date) AND (VGN_CALC_VARIANCE <> 0) AND
      (VGN_CALC_VARIANCE <> -999) THEN
      VGD_START_DATE := vld_1ston_date;
      VGD_END_DATE   := vld_2ndoff_date;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      IF VGN_VARIANCE_DAYS <> -999 THEN
         IF vld_1ston_date > COMMIT_DATE THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF vld_2ndoff_date < vld_target_date THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF VGN_CALC_VARIANCE > 0 THEN
            IF OIS.PICK_PACK_WORK_DAYS_QTY != 0 AND vlb_consider_pickpack AND
               vld_2ndoff_date < vld_target_date THEN
               VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + OIS.PICK_PACK_WORK_DAYS_QTY;
               IF vld_2ndoff_date < vld_target_date -- restore what was added earlier
                THEN
                  VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS - 1;
               END IF;
               vlb_consider_pickpack := FALSE;
            END IF;
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE - VGN_VARIANCE_DAYS;
         ELSE
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE + VGN_VARIANCE_DAYS;
         END IF;
      END IF;
   END IF;

   --IF THERE WAS A CREDIT HOLD AFTER THE COMMIT DATE 
   --THEN SUBTRACT IT OUT OF THE VARIANCE.               
   IF (OIS.SCHEDULE_ON_CREDIT_HOLD_DATE > COMMIT_DATE) AND
      (vlb_credithold_on OR NOT vlb_allhavedates) AND
      (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE > COMMIT_DATE) AND
      (OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE <= vld_target_date) AND
      (VGN_CALC_VARIANCE <> 0) AND (VGN_CALC_VARIANCE <> -999) THEN
      VGD_START_DATE := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
      VGD_END_DATE   := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      IF VGN_VARIANCE_DAYS <> -999 THEN
         IF OIS.SCHEDULE_ON_CREDIT_HOLD_DATE > COMMIT_DATE THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE < vld_target_date AND
            NOT vlb_temphold_on THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF VGN_CALC_VARIANCE > 0 THEN
            IF OIS.PICK_PACK_WORK_DAYS_QTY != 0 AND vlb_consider_pickpack AND
               OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE < vld_target_date THEN
               VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + OIS.PICK_PACK_WORK_DAYS_QTY;
               IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE < vld_target_date AND
                  NOT vlb_temphold_on -- restore what was added earlier 
                THEN
                  VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS - 1;
               END IF;
               vlb_consider_pickpack := FALSE;
            END IF;
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE - VGN_VARIANCE_DAYS;
         ELSE
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE + VGN_VARIANCE_DAYS;
         END IF;
      END IF;
   END IF;

   --IF THERE WAS A TEMPORARY HOLD AFTER THE COMMIT DATE 
   --THEN SUBTRACT IT OUT OF THE VARIANCE.               
   IF (OIS.TEMP_HOLD_ON_DATE > COMMIT_DATE) AND
      (vlb_temphold_on OR NOT vlb_allhavedates) AND
      (OIS.TEMP_HOLD_OFF_DATE > COMMIT_DATE) AND
      (OIS.TEMP_HOLD_OFF_DATE <= vld_target_date) AND
      (VGN_CALC_VARIANCE <> 0) AND (VGN_CALC_VARIANCE <> -999) THEN
      VGD_START_DATE := OIS.TEMP_HOLD_ON_DATE;
      VGD_END_DATE   := OIS.TEMP_HOLD_OFF_DATE;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      IF VGN_VARIANCE_DAYS <> -999 THEN
         IF OIS.TEMP_HOLD_ON_DATE > COMMIT_DATE THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF OIS.TEMP_HOLD_OFF_DATE < vld_target_date AND NOT vlb_credithold_on THEN
            VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
         END IF;
         IF VGN_CALC_VARIANCE > 0 THEN
            IF OIS.PICK_PACK_WORK_DAYS_QTY != 0 AND vlb_consider_pickpack AND OIS.TEMP_HOLD_OFF_DATE < vld_target_date THEN
               VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + OIS.PICK_PACK_WORK_DAYS_QTY;
               IF OIS.TEMP_HOLD_OFF_DATE < vld_target_date AND
                  NOT vlb_credithold_on -- restore what was added earlier 
                THEN
                  VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS - 1;
               END IF;
               vlb_consider_pickpack := FALSE;
            END IF;
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE - VGN_VARIANCE_DAYS;
         ELSE
            VGN_CALC_VARIANCE := VGN_CALC_VARIANCE + VGN_VARIANCE_DAYS;
         END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN UE_CRITICAL_DB_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('BAD RETURN FROM COUNT_ELAPSED_DAYS in calc variance');
   WHEN OTHERS THEN
      VGN_RESULT := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('p_calc_variance_days');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(VGN_RESULT));
   
END p_compute_variance_days;

/*******************************************************************/
/* PROCEDURE:     P_VARIANCE_CALC                                  */
/* DESCRIPTION:  THE FOLLOWING VARIANCES ARE CALULATED FOR         */
/*               SHIPMENTS:                                        */
/*                 - SCHEDULE TO SHIP        SCHSHP                */
/*                 - REQUEST TO SHIP         REQSHP                */
/*                 - RECEIVED TO SHIP        RECSHP                */
/*                 - RELEASED TO SHIP        RELSHP                */
/*               OPENS:                                            */
/*                 - CURRENT TO REQUEST      CURREQ                */
/*                 - CURRENT TO SCHEDULE     CURSCH                */
/*               BOTH:                                             */
/*                 - REQUEST TO SCHEDULE     REQSCH                */
/*                 - RECEIVED TO SCHEDULE    RECSCH                */
/*                 - RECEIVED TO REQUESTE    RECREQ                */
/*                 - RELEASED TO SCHEDULE    RELSCH                */
/*******************************************************************/

PROCEDURE P_VARIANCE_CALC
( OIS        IN OUT TEMP_ORDER_ITEM_SHIPMENT%ROWTYPE
, VON_RESULT    OUT NUMBER ) 
AS
 
 COMMIT_DATE       DATE;
 CSTMR_COMMIT_DATE DATE;

BEGIN

   /* tanveer 1/14/1999 added to display as part of error message */
   vgc_amp_order_nbr  := ois.amp_order_nbr;
   vgc_order_item_nbr := ois.order_item_nbr;
   vgc_shipment_id    := ois.shipment_id;
   /* end change */
   
   -- Added for PPSOC changes Kumar 10/16/2012
   vgc_data_source_desc := ois.data_source_desc; 

   IF OIS.AMP_SHIPPED_DATE IS NOT NULL THEN
      VGC_BUILDING := OIS.ACTUAL_SHIP_BUILDING_NBR;
      VGC_LOCATION := OIS.ACTUAL_SHIP_LOCATION;
   ELSE
      VGC_BUILDING := OIS.INVENTORY_BUILDING_NBR;
      VGC_LOCATION := OIS.INVENTORY_LOCATION_CODE;
   END IF;

   IF ois.AMP_SHIPPED_DATE IS NOT NULL THEN
      IF Scdcommonbatch.GetCompanyOrgID(ois.organization_key_id,
                                        ois.amp_shipped_date,
                                        vgc_co_org_id) THEN
         IF Scdcommonbatch.GetOrgKeyIDV4(vgc_co_org_id,
                                         ois.amp_shipped_date,
                                         vgn_co_orgkey_id) THEN
            NULL;
         END IF;
      END IF;
   ELSE
      IF Scdcommonbatch.GetCompanyOrgID(ois.organization_key_id,
                                        ois.reported_as_of_date,
                                        vgc_co_org_id) THEN
         IF Scdcommonbatch.GetOrgKeyIDV4(vgc_co_org_id,
                                         ois.reported_as_of_date,
                                         vgn_co_orgkey_id) THEN
            NULL;
         END IF;
      END IF;
   END IF;

   -- init common columns
   gCommonFldsRec.SCHEDULE_OFF_CREDIT_HOLD_DATE := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
   gCommonFldsRec.SCHEDULE_ON_CREDIT_HOLD_DATE  := OIS.SCHEDULE_ON_CREDIT_HOLD_DATE;
   gCommonFldsRec.TEMP_HOLD_OFF_DATE            := OIS.TEMP_HOLD_OFF_DATE;
   gCommonFldsRec.TEMP_HOLD_ON_DATE             := OIS.TEMP_HOLD_ON_DATE;
   gCommonFldsRec.AMP_SHIPPED_DATE              := OIS.AMP_SHIPPED_DATE;
   gCommonFldsRec.RELEASE_DATE                  := OIS.RELEASE_DATE;
   gCommonFldsRec.CUSTOMER_EXPEDITE_DATE        := OIS.CUSTOMER_EXPEDITE_DATE;
   gCommonFldsRec.CUSTOMER_REQUEST_DATE         := OIS.CUSTOMER_REQUEST_DATE;
   gCommonFldsRec.CUSTOMER_TYPE_CODE            := OIS.CUSTOMER_TYPE_CODE;
   gCommonFldsRec.PICK_PACK_WORK_DAYS_QTY       := OIS.PICK_PACK_WORK_DAYS_QTY;

   IF OIS.AMP_SHIPPED_DATE IS NOT NULL THEN
      /*****************************************************************/
      /*   SCHEDULE TO SHIP                          SCHSHP            */
      /*****************************************************************/
      COMMIT_DATE                   := OIS.AMP_SCHEDULE_DATE;
      OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'S';
      IF (OIS.EARLIEST_EXPEDITE_DATE IS NOT NULL) AND
         (OIS.EARLIEST_EXPEDITE_DATE <= OIS.AMP_SCHEDULE_DATE) AND
         (OIS.EARLIEST_EXPEDITE_DATE <> k_begin_of_time) THEN
         COMMIT_DATE                   := OIS.EARLIEST_EXPEDITE_DATE;
         OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'X';
      END IF;
   
      /*
      /*   NOW CHECK TO SEE IF THERE WAS A VALID DATE EXCEPTION
      /*   TO PREVENT AMP FROM MEETING THE COMMIT DATE.
      /*                                                           */
      
      VGC_CALC_VARIANCE_CMPRSN_CODE := OIS.SCHEDULE_SHIP_CMPRSN_CODE;
      p_compute_variance_days('SCHSHP', gCommonFldsRec, COMMIT_DATE);
      
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      
      OIS.SCHEDULE_SHIP_CMPRSN_CODE := VGC_CALC_VARIANCE_CMPRSN_CODE;
      OIS.SCHEDULE_TO_SHIP_VARIANCE := VGN_CALC_VARIANCE;
      
      /*
        IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL
            AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE
            AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE <=
            OIS.AMP_SHIPPED_DATE THEN
                COMMIT_DATE := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'C';
        END IF;
        -- CHECK FOR TEMPORARY HOLD  
        IF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL
            AND OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE
            AND OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE
            AND (TO_CHAR(OIS.TEMP_HOLD_OFF_DATE ,'YYYYMMDD')
            <> '00010101') THEN
            IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL THEN
                IF OIS.TEMP_HOLD_OFF_DATE >
                    OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE THEN
                        --CASE - CREDIT HOLD COMING OFF WHEN IN TEMP HOLD
                        COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                        OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'T';
                END IF;
      
            ELSE
                -- CASE - NO CREDIT HOLD - TEMP HOLD PREVENTED          
                -- AMP FROM MEETING COMMIT DATE                         
                        COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                        OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'T';
            END IF;
        END IF;
        --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        --%%% LATE CODE LOGIC
        --%%% NOTE: IF SHIPMENT IS MADE BETWEEN CUST RQST DATE
        --%%%       (CUST EXP) AND SCHEDULE DATE (COMMIT DATE).
        --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        -- CASE - EARLY TO CUST REQUEST                              
        IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
            (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
            AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
            <> '00010101') THEN
                CSTMR_COMMIT_DATE := OIS.CUSTOMER_EXPEDITE_DATE;
        ELSE
                CSTMR_COMMIT_DATE := OIS.CUSTOMER_REQUEST_DATE;
        END IF;
        IF (CSTMR_COMMIT_DATE < COMMIT_DATE)
            AND (OIS.AMP_SHIPPED_DATE < CSTMR_COMMIT_DATE)
             AND (OIS.CUSTOMER_TYPE_CODE <> 'J' OR
                   OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
                COMMIT_DATE := CSTMR_COMMIT_DATE;
            IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
                (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
                AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
                <> '00010101') THEN
                    OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'E';
            ELSE
                OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'R';
            END IF;
        END IF;
        -- CASE - IF MADE WITHIN RANGE, THEN CONSIDER ON-TIME        
        -- LATE CODED                                                
        IF (CSTMR_COMMIT_DATE < COMMIT_DATE)
             AND (OIS.AMP_SHIPPED_DATE < COMMIT_DATE)
             AND (OIS.AMP_SHIPPED_DATE >= CSTMR_COMMIT_DATE)
             AND (OIS.CUSTOMER_TYPE_CODE <> 'J' OR
                   OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
                 OIS.SCHEDULE_TO_SHIP_VARIANCE := 0;
                 OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'L';
        ELSE
        -- IF NOT LATE CODED, AND COMMIT DATE AND SHIP DATE             
        -- FALL WITHIN THE TEMPORARY HOLD PERIOD THEN SHIPMENT IS ON TIME.
            IF (OIS.TEMP_HOLD_OFF_DATE IS NOT NULL)
                AND (OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE)
                AND (OIS.TEMP_HOLD_OFF_DATE >= OIS.AMP_SHIPPED_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE <= OIS.AMP_SHIPPED_DATE)
                AND (TO_CHAR(OIS.TEMP_HOLD_OFF_DATE ,'YYYYMMDD') <> '00010101') THEN
                    OIS.SCHEDULE_TO_SHIP_VARIANCE := 0;
                    OIS.SCHEDULE_SHIP_CMPRSN_CODE := 'T';
            ELSE
            -- IF NOT LATE CODED, THEN CALCULATE THE VARIANCE           
                VGD_START_DATE := COMMIT_DATE;
                VGD_END_DATE := OIS.AMP_SHIPPED_DATE;
                P_COUNT_ELAPSED_DAYS;
                IF VGN_RESULT <> 0 THEN
                    RAISE UE_CRITICAL_DB_ERROR;
                END IF;
                OIS.SCHEDULE_TO_SHIP_VARIANCE := VGN_VARIANCE_DAYS;
            END IF;
        END IF;
        IF (OIS.SCHEDULE_SHIP_CMPRSN_CODE = 'T'
            OR OIS.SCHEDULE_SHIP_CMPRSN_CODE = 'C')
            AND (OIS.SCHEDULE_TO_SHIP_VARIANCE <> 0)
            AND (OIS.SCHEDULE_TO_SHIP_VARIANCE <> -999) THEN
                --ALLOW GRACE DAY - TAKES A DAY TO ALLOW SHIPMENT 
                --AFTER A TEMP HOLD OR CREDIT HOLD COMES OFF.     
                IF OIS.SCHEDULE_TO_SHIP_VARIANCE > 0 THEN
                    OIS.SCHEDULE_TO_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE - 1;
                ELSE
                    OIS.SCHEDULE_TO_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE + 1;
                END IF;
        END IF;
        --IF THERE WAS A TEMPORARY HOLD AFTER THE COMMIT DATE 
        --THEN SUBTRACT IT OUT OF THE VARIANCE.               
        IF (OIS.TEMP_HOLD_ON_DATE > COMMIT_DATE)
            AND (OIS.TEMP_HOLD_OFF_DATE > COMMIT_DATE)
            AND (OIS.TEMP_HOLD_OFF_DATE <= OIS.AMP_SHIPPED_DATE)
            AND (OIS.SCHEDULE_TO_SHIP_VARIANCE <> 0)
            AND (OIS.SCHEDULE_TO_SHIP_VARIANCE <> -999) THEN
                VGD_START_DATE := OIS.TEMP_HOLD_ON_DATE;
                VGD_END_DATE := OIS.TEMP_HOLD_OFF_DATE;
                P_COUNT_ELAPSED_DAYS;
                IF VGN_RESULT <> 0 THEN
                    RAISE UE_CRITICAL_DB_ERROR;
                END IF;
                IF VGN_VARIANCE_DAYS <> -999 THEN
                    VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                    IF OIS.TEMP_HOLD_OFF_DATE < OIS.AMP_SHIPPED_DATE
                        THEN VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                    END IF;
                    IF OIS.SCHEDULE_TO_SHIP_VARIANCE > 0 THEN
                        OIS.SCHEDULE_TO_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE - VGN_VARIANCE_DAYS;
                    ELSE
                        OIS.SCHEDULE_TO_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE + VGN_VARIANCE_DAYS;
                    END IF;
                END IF;
        END IF;
      */
      
      IF OIS.SCHEDULE_TO_SHIP_VARIANCE > 0 THEN
         IF OIS.SCHEDULE_TO_SHIP_VARIANCE > OIS.NBR_WINDOW_DAYS_LATE THEN
            OIS.VARBL_SCHEDULE_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE - OIS.NBR_WINDOW_DAYS_LATE;
         ELSE
            OIS.VARBL_SCHEDULE_SHIP_VARIANCE := 0;
         END IF;
      ELSIF OIS.SCHEDULE_TO_SHIP_VARIANCE < 0 THEN
         IF OIS.SCHEDULE_TO_SHIP_VARIANCE = -999 THEN
            OIS.VARBL_SCHEDULE_SHIP_VARIANCE := -999;
         ELSIF OIS.SCHEDULE_TO_SHIP_VARIANCE <
               (OIS.NBR_WINDOW_DAYS_EARLY * -1) THEN
            OIS.VARBL_SCHEDULE_SHIP_VARIANCE := OIS.SCHEDULE_TO_SHIP_VARIANCE +
                                                OIS.NBR_WINDOW_DAYS_EARLY;
         ELSE
            OIS.VARBL_SCHEDULE_SHIP_VARIANCE := 0;
         END IF;
      ELSE
         OIS.VARBL_SCHEDULE_SHIP_VARIANCE := 0;
      END IF;
   
      /*****************************************************************/
      /*   REQUEST TO SHIP                            REQSHP           */
      /*****************************************************************/
      
      COMMIT_DATE                  := OIS.CUSTOMER_REQUEST_DATE;
      OIS.REQUEST_SHIP_CMPRSN_CODE := 'R';
   
      -- check if the record can be considered as urgent order
      IF OIS.CUSTOMER_ACCT_TYPE_CDE = 'I' AND
         OIS.ORDER_RECEIVED_DATE IS NOT NULL THEN
         IF OIS.CUSTOMER_REQUEST_DATE <> k_begin_of_time AND
            OIS.ORDER_RECEIVED_DATE <> k_begin_of_time THEN
            IF OIS.CUSTOMER_REQUEST_DATE >= OIS.ORDER_RECEIVED_DATE AND
               OIS.CUSTOMER_REQUEST_DATE != OIS.AMP_SHIPPED_DATE AND
               (OIS.CUSTOMER_REQUEST_DATE - OIS.ORDER_RECEIVED_DATE) < vgn_urgent_ord_offset_days THEN
               COMMIT_DATE                  := OIS.ORDER_RECEIVED_DATE +
                                               vgn_urgent_ord_offset_days;
               OIS.REQUEST_SHIP_CMPRSN_CODE := 'U';
            END IF;
         END IF;
      END IF;
   
      -- expedite date  
      IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL)
        --AND (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
         AND (OIS.CUSTOMER_EXPEDITE_DATE < COMMIT_DATE) AND
         (OIS.CUSTOMER_EXPEDITE_DATE <> k_begin_of_time) THEN
         COMMIT_DATE                  := OIS.CUSTOMER_EXPEDITE_DATE;
         OIS.REQUEST_SHIP_CMPRSN_CODE := 'E';
      END IF;
   
      /**                                                          **/
      /**  USE AMP DFLT (3 DAYS EARLY) FOR JIT CUSTOMER IN         **/
      /**  REQUEST_TO_SHIP VARIANCE CALCULATION FOR CUST VAR VIEW  **/
      /**                                                          **/
      IF OIS.CUSTOMER_TYPE_CODE = 'J' THEN
         VGN_CUST_VAR_WINDOW_DAYS_EARLY := 3;
      ELSE
         VGN_CUST_VAR_WINDOW_DAYS_EARLY := OIS.NBR_WINDOW_DAYS_EARLY;
      END IF;
   
      -- if Distributor Ship When Avail = Y then set RTS to 0
      IF OIS.DISTR_SHIP_WHEN_AVAIL_IND = 'Y' AND
         OIS.AMP_SHIPPED_DATE <= OIS.AMP_SCHEDULE_DATE THEN
         VGC_CALC_VARIANCE_CMPRSN_CODE := 'D';
         VGN_CALC_VARIANCE             := 0;
      ELSE
         /*   NOW CHECK TO SEE IF THERE WAS A VALID DATE EXCEPTION
         /*   TO PREVENT AMP FROM MEETING THE COMMIT DATE.
         /*                                                           */
         VGC_CALC_VARIANCE_CMPRSN_CODE := OIS.REQUEST_SHIP_CMPRSN_CODE;
         p_compute_variance_days('REQSHP', gCommonFldsRec, COMMIT_DATE);
         IF VGN_RESULT <> 0 THEN
            RAISE UE_CRITICAL_DB_ERROR;
         END IF;
      END IF;
      
      OIS.REQUEST_SHIP_CMPRSN_CODE := VGC_CALC_VARIANCE_CMPRSN_CODE;
      OIS.REQUEST_TO_SHIP_VARIANCE := VGN_CALC_VARIANCE;
      
      /*
        IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL
            AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE THEN
                COMMIT_DATE := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                OIS.REQUEST_SHIP_CMPRSN_CODE := 'C';
        END IF;
        -- CHECK FOR TEMPORARY HOLD  
        IF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL
            AND OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE
            AND (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE
            OR OIS.TEMP_HOLD_ON_DATE IS NULL) THEN
            IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL THEN
                IF OIS.TEMP_HOLD_OFF_DATE >
                    OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE THEN
                        --CASE - CREDIT HOLD COMING OFF WHEN IN TEMP HOLD
                        COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                        OIS.REQUEST_SHIP_CMPRSN_CODE := 'T';
                END IF;
      
            ELSE
                -- CASE - NO CREDIT HOLD - TEMP HOLD PREVENTED          
                -- AMP FROM MEETING COMMIT DATE                         
                        COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                        OIS.REQUEST_SHIP_CMPRSN_CODE := 'T';
            END IF;
        END IF;
        IF (OIS.TEMP_HOLD_OFF_DATE IS NOT NULL)
            AND (OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE)
            AND (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE)
            AND (OIS.TEMP_HOLD_OFF_DATE >= OIS.AMP_SHIPPED_DATE)
            AND (OIS.TEMP_HOLD_ON_DATE <= OIS.AMP_SHIPPED_DATE)
            AND (TO_CHAR(OIS.TEMP_HOLD_OFF_DATE ,'YYYYMMDD')
            <> '00010101') THEN
                OIS.REQUEST_TO_SHIP_VARIANCE := 0;
                OIS.REQUEST_SHIP_CMPRSN_CODE := 'T';
        ELSE
        -- IF NOT LATE CODED, THEN CALCULATE THE VARIANCE               
            VGD_START_DATE := COMMIT_DATE;
            VGD_END_DATE := OIS.AMP_SHIPPED_DATE;
            P_COUNT_ELAPSED_DAYS;
            IF VGN_RESULT <> 0 THEN
                RAISE UE_CRITICAL_DB_ERROR;
            END IF;
            OIS.REQUEST_TO_SHIP_VARIANCE := VGN_VARIANCE_DAYS;
        END IF;
        IF (OIS.REQUEST_SHIP_CMPRSN_CODE = 'T'
            OR OIS.REQUEST_SHIP_CMPRSN_CODE = 'C')
            AND (OIS.REQUEST_TO_SHIP_VARIANCE <> 0)
            AND (OIS.REQUEST_TO_SHIP_VARIANCE <> -999) THEN
                --ALLOW GRACE DAY - TAKES A DAY TO ALLOW SHIPMENT 
                --AFTER A TEMP HOLD OR CREDIT HOLD COMES OFF.     
                IF OIS.REQUEST_TO_SHIP_VARIANCE > 0  THEN
                    OIS.REQUEST_TO_SHIP_VARIANCE :=
                        OIS.REQUEST_TO_SHIP_VARIANCE - 1;
                ELSE
                    OIS.REQUEST_TO_SHIP_VARIANCE :=
                        OIS.REQUEST_TO_SHIP_VARIANCE + 1;
                END IF;
        END IF;
        --IF THERE WAS A TEMPORARY HOLD AFTER THE COMMIT DATE 
        --THEN SUBTRACT IT OUT OF THE VARIANCE.               
        IF (OIS.TEMP_HOLD_ON_DATE > COMMIT_DATE)
            AND (OIS.TEMP_HOLD_OFF_DATE > COMMIT_DATE)
            AND (OIS.TEMP_HOLD_OFF_DATE <= OIS.AMP_SHIPPED_DATE)
            AND (OIS.REQUEST_TO_SHIP_VARIANCE <> 0)
            AND (OIS.REQUEST_TO_SHIP_VARIANCE <> -999) THEN
                VGD_START_DATE := OIS.TEMP_HOLD_ON_DATE;
                VGD_END_DATE := OIS.TEMP_HOLD_OFF_DATE;
                P_COUNT_ELAPSED_DAYS;
                IF VGN_RESULT <> 0 THEN
                    RAISE UE_CRITICAL_DB_ERROR;
                END IF;
                IF VGN_VARIANCE_DAYS <> -999 THEN
                    VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                    IF OIS.TEMP_HOLD_OFF_DATE < OIS.AMP_SHIPPED_DATE
                        THEN VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                    END IF;
                    IF OIS.REQUEST_TO_SHIP_VARIANCE > 0 THEN
                        OIS.REQUEST_TO_SHIP_VARIANCE :=
                            OIS.REQUEST_TO_SHIP_VARIANCE - VGN_VARIANCE_DAYS;
                    ELSE
                        OIS.REQUEST_TO_SHIP_VARIANCE :=
                            OIS.REQUEST_TO_SHIP_VARIANCE + VGN_VARIANCE_DAYS;
                    END IF;
                END IF;
        END IF;
      */
      
      IF OIS.REQUEST_TO_SHIP_VARIANCE > 0 THEN
         IF OIS.REQUEST_TO_SHIP_VARIANCE > OIS.NBR_WINDOW_DAYS_LATE THEN
            OIS.VARBL_REQUEST_SHIP_VARIANCE := OIS.REQUEST_TO_SHIP_VARIANCE -
                                               OIS.NBR_WINDOW_DAYS_LATE;
         ELSE
            OIS.VARBL_REQUEST_SHIP_VARIANCE := 0;
         END IF;
      ELSIF OIS.REQUEST_TO_SHIP_VARIANCE < 0 THEN
         IF OIS.REQUEST_TO_SHIP_VARIANCE <
            (VGN_CUST_VAR_WINDOW_DAYS_EARLY * -1) THEN
            OIS.VARBL_REQUEST_SHIP_VARIANCE := OIS.REQUEST_TO_SHIP_VARIANCE +
                                               VGN_CUST_VAR_WINDOW_DAYS_EARLY;
         ELSE
            OIS.VARBL_REQUEST_SHIP_VARIANCE := 0;
         END IF;
      ELSE
         OIS.VARBL_REQUEST_SHIP_VARIANCE := 0;
      END IF;
      
      IF OIS.ORDER_RECEIVED_DATE IS NOT NULL THEN
         /*****************************************************************/
         /*   RECEIVED TO  SHIP                             RECSHP        */
         /*****************************************************************/
         VGD_START_DATE := OIS.ORDER_RECEIVED_DATE;
         VGD_END_DATE   := OIS.AMP_SHIPPED_DATE;
         P_COUNT_ELAPSED_DAYS;
         IF VGN_RESULT <> 0 THEN
            RAISE UE_CRITICAL_DB_ERROR;
         END IF;
         OIS.RECEIVED_TO_SHIP_VARIANCE := VGN_VARIANCE_DAYS;
         IF OIS.RECEIVED_TO_SHIP_VARIANCE > 0 THEN
            IF OIS.RECEIVED_TO_SHIP_VARIANCE > OIS.NBR_WINDOW_DAYS_LATE THEN
               OIS.VARBL_RECEIVED_SHIP_VARIANCE := OIS.RECEIVED_TO_SHIP_VARIANCE - OIS.NBR_WINDOW_DAYS_LATE;
            ELSE
               OIS.VARBL_RECEIVED_SHIP_VARIANCE := 0;
            END IF;
         ELSIF OIS.RECEIVED_TO_SHIP_VARIANCE < 0 THEN
            IF OIS.RECEIVED_TO_SHIP_VARIANCE = -999 THEN
               OIS.VARBL_RECEIVED_SHIP_VARIANCE := -999;
            ELSIF OIS.RECEIVED_TO_SHIP_VARIANCE <
                  (OIS.NBR_WINDOW_DAYS_EARLY * -1) THEN
               OIS.VARBL_RECEIVED_SHIP_VARIANCE := OIS.RECEIVED_TO_SHIP_VARIANCE + OIS.NBR_WINDOW_DAYS_EARLY;
            ELSE
               OIS.VARBL_RECEIVED_SHIP_VARIANCE := 0;
            END IF;
         ELSE
            OIS.VARBL_RECEIVED_SHIP_VARIANCE := 0;
         END IF;
      END IF;
      
      IF OIS.RELEASE_DATE IS NOT NULL THEN
         /*****************************************************************/
         /*   RELEASE  TO SHIP                          RELSHP            */
         /*****************************************************************/
         COMMIT_DATE                   := OIS.AMP_SCHEDULE_DATE;
         OIS.SHIP_FACILITY_CMPRSN_CODE := 'S';
         IF (OIS.CURRENT_EXPEDITE_DATE IS NOT NULL) AND
            (OIS.CURRENT_EXPEDITE_DATE <= OIS.AMP_SCHEDULE_DATE) AND
            (OIS.CURRENT_EXPEDITE_DATE <> k_begin_of_time) THEN
            COMMIT_DATE                   := OIS.CURRENT_EXPEDITE_DATE;
            OIS.SHIP_FACILITY_CMPRSN_CODE := 'X';
         END IF;
         
         /*
         /*   NOW CHECK TO SEE IF THERE WAS A VALID DATE EXCEPTION
         /*   TO PREVENT AMP FROM MEETING THE COMMIT DATE.
         /*                                                           */
         
         VGC_CALC_VARIANCE_CMPRSN_CODE := OIS.SHIP_FACILITY_CMPRSN_CODE;
         p_compute_variance_days('RELSHP', gCommonFldsRec, COMMIT_DATE);
         IF VGN_RESULT <> 0 THEN
            RAISE UE_CRITICAL_DB_ERROR;
         END IF;
      
         -- IF late then try to re-calc variance again for milkrun process
         -- if consolidation_indicator is set and _date is available
         IF VGN_VARIANCE_DAYS > 0 AND OIS.CONSOLIDATION_INDICATOR_CDE = 'Y' AND
            OIS.CONSOLIDATION_DT IS NOT NULL THEN
         
            VGC_CALC_VARIANCE_CMPRSN_CODE := 'M';
            VGD_START_DATE                := OIS.CONSOLIDATION_DT;
            VGD_END_DATE                  := OIS.AMP_SHIPPED_DATE;
            P_COUNT_ELAPSED_DAYS;
            IF VGN_RESULT <> 0 THEN
               RAISE UE_CRITICAL_DB_ERROR;
            END IF;
            VGN_CALC_VARIANCE := VGN_VARIANCE_DAYS;
         END IF;
      
         OIS.SHIP_FACILITY_CMPRSN_CODE := VGC_CALC_VARIANCE_CMPRSN_CODE;
         OIS.RELEASE_TO_SHIP_VARIANCE  := VGN_CALC_VARIANCE;
         
         /*
           IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL
               AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE
               AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE <= OIS.AMP_SHIPPED_DATE THEN
                   COMMIT_DATE := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                   OIS.SHIP_FACILITY_CMPRSN_CODE := 'C';
           END IF;
           -- CHECK FOR TEMPORARY HOLD  
           IF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL
               AND OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE
               AND OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE
               AND (TO_CHAR(OIS.TEMP_HOLD_OFF_DATE ,'YYYYMMDD')
               <> '00010101') THEN
               IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL THEN
                   IF OIS.TEMP_HOLD_OFF_DATE >
                       OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE THEN
                           --CASE - CREDIT HOLD COMING OFF WHEN IN TEMP HOLD
                           COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                           OIS.SHIP_FACILITY_CMPRSN_CODE := 'T';
                   END IF;
         
               ELSE
                   -- CASE - NO CREDIT HOLD - TEMP HOLD PREVENTED          
                   -- AMP FROM MEETING COMMIT DATE                         
                           COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                           OIS.SHIP_FACILITY_CMPRSN_CODE := 'T';
               END IF;
           END IF;
           --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           --%%% LATE CODE LOGIC
           --%%% NOTE: IF SHIPMENT IS MADE BETWEEN CUST RQST DATE
           --%%%       (CUST EXP) AND SCHEDULE DATE (COMMIT DATE).
           --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           -- CASE - EARLY TO CUST REQUEST                              
           IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
               (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
               AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
               <> '00010101') THEN
                   CSTMR_COMMIT_DATE := OIS.CUSTOMER_EXPEDITE_DATE;
           ELSE
                   CSTMR_COMMIT_DATE := OIS.CUSTOMER_REQUEST_DATE;
           END IF;
           IF (CSTMR_COMMIT_DATE < COMMIT_DATE)
               AND (OIS.AMP_SHIPPED_DATE < CSTMR_COMMIT_DATE)
                AND (OIS.CUSTOMER_TYPE_CODE <> 'J' OR
                      OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
                   COMMIT_DATE := CSTMR_COMMIT_DATE;
               IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
                   (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
                   AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD') <> '00010101') THEN
                       OIS.SHIP_FACILITY_CMPRSN_CODE := 'E';
               ELSE
                   OIS.SHIP_FACILITY_CMPRSN_CODE := 'R';
               END IF;
           END IF;
           -- CASE - IF MADE WITHIN RANGE, THEN CONSIDER ON-TIME        
           -- LATE CODED                                                
         --  DBMS_OUTPUT.PUT_LINE('REQ DATE ' || CSTMR_COMMIT_DATE);
         --  DBMS_OUTPUT.PUT_LINE('COM DATE ' || COMMIT_DATE);
         --  DBMS_OUTPUT.PUT_LINE('SHP DATE ' || OIS.AMP_SHIPPED_DATE);
         --  DBMS_OUTPUT.PUT_LINE('REL DATE ' || OIS.RELEASE_DATE);
           IF (CSTMR_COMMIT_DATE < COMMIT_DATE)
                AND (OIS.AMP_SHIPPED_DATE <= COMMIT_DATE)
                AND (OIS.AMP_SHIPPED_DATE >= CSTMR_COMMIT_DATE)
         --     AND (OIS.RELEASE_DATE = CSTMR_COMMIT_DATE)
                AND (OIS.CUSTOMER_TYPE_CODE <> 'J' OR
                      OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
                   COMMIT_DATE := CSTMR_COMMIT_DATE;
                   IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
                       (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
                       AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
                       <> '00010101') THEN
                          OIS.SHIP_FACILITY_CMPRSN_CODE := 'E';
                   ELSE
                       OIS.SHIP_FACILITY_CMPRSN_CODE := 'R';
                   END IF;
           END IF;
           -- IF NOT LATE CODED, AND COMMIT DATE AND SHIP DATE             
           -- FALL WITHIN THE TEMPORARY HOLD PERIOD THEN SHIPMENT IS ON TIME.
               IF (OIS.TEMP_HOLD_OFF_DATE IS NOT NULL)
                   AND (OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE)
                   AND (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE)
                   AND (OIS.TEMP_HOLD_OFF_DATE >= OIS.AMP_SHIPPED_DATE)
                   AND (OIS.TEMP_HOLD_ON_DATE <= OIS.AMP_SHIPPED_DATE)
                   AND (TO_CHAR(OIS.TEMP_HOLD_OFF_DATE ,'YYYYMMDD') <> '00010101') THEN
                       OIS.RELEASE_TO_SHIP_VARIANCE := 0;
                       OIS.SHIP_FACILITY_CMPRSN_CODE := 'T';
               ELSE
               -- IF NOT LATE CODED, THEN CALCULATE THE VARIANCE           
                   IF OIS.RELEASE_DATE > COMMIT_DATE THEN
                       COMMIT_DATE := OIS.RELEASE_DATE;
                       OIS.SHIP_FACILITY_CMPRSN_CODE := 'A';
                   END IF;
                   VGD_START_DATE := COMMIT_DATE;
                   VGD_END_DATE := OIS.AMP_SHIPPED_DATE;
                   P_COUNT_ELAPSED_DAYS;
                   IF VGN_RESULT <> 0 THEN
                       RAISE UE_CRITICAL_DB_ERROR;
                   END IF;
                   OIS.RELEASE_TO_SHIP_VARIANCE := VGN_VARIANCE_DAYS;
               END IF;
           IF (OIS.SHIP_FACILITY_CMPRSN_CODE = 'T'
               OR OIS.SHIP_FACILITY_CMPRSN_CODE = 'C')
               AND (OIS.RELEASE_TO_SHIP_VARIANCE <> 0)
               AND (OIS.RELEASE_TO_SHIP_VARIANCE <> -999) THEN
                   --ALLOW GRACE DAY - TAKES A DAY TO ALLOW SHIPMENT 
                   --AFTER A TEMP HOLD OR CREDIT HOLD COMES OFF.     
                   IF OIS.RELEASE_TO_SHIP_VARIANCE > 0 THEN
                       OIS.RELEASE_TO_SHIP_VARIANCE :=
                           OIS.RELEASE_TO_SHIP_VARIANCE - 1;
                   ELSE
                       OIS.RELEASE_TO_SHIP_VARIANCE :=
                           OIS.RELEASE_TO_SHIP_VARIANCE + 1;
                   END IF;
           END IF;
           --IF THERE WAS A TEMPORARY HOLD AFTER THE COMMIT DATE 
           --THEN SUBTRACT IT OUT OF THE VARIANCE.               
           IF (OIS.TEMP_HOLD_ON_DATE > COMMIT_DATE)
               AND (OIS.TEMP_HOLD_OFF_DATE > COMMIT_DATE)
               AND (OIS.TEMP_HOLD_OFF_DATE <= OIS.AMP_SHIPPED_DATE)
               AND (OIS.RELEASE_TO_SHIP_VARIANCE <> 0)
               AND (OIS.RELEASE_TO_SHIP_VARIANCE <> -999) THEN
                   VGD_START_DATE := OIS.TEMP_HOLD_ON_DATE;
                   VGD_END_DATE := OIS.TEMP_HOLD_OFF_DATE;
                   P_COUNT_ELAPSED_DAYS;
                   IF VGN_RESULT <> 0 THEN
                       RAISE UE_CRITICAL_DB_ERROR;
                   END IF;
                   IF VGN_VARIANCE_DAYS <> -999 THEN
                       VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                       IF OIS.TEMP_HOLD_OFF_DATE < OIS.AMP_SHIPPED_DATE
                           THEN VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                       END IF;
                       IF OIS.RELEASE_TO_SHIP_VARIANCE > 0 THEN
                           OIS.RELEASE_TO_SHIP_VARIANCE :=
                               OIS.RELEASE_TO_SHIP_VARIANCE - VGN_VARIANCE_DAYS;
                       ELSE
                           OIS.RELEASE_TO_SHIP_VARIANCE :=
                               OIS.SCHEDULE_TO_SHIP_VARIANCE + VGN_VARIANCE_DAYS;
                       END IF;
                   END IF;
           END IF;
         */
         
      ELSE
         OIS.RELEASE_TO_SHIP_VARIANCE  := 0;
         OIS.SHIP_FACILITY_CMPRSN_CODE := 'A';
      END IF;
      
   ELSE
      /*  END OF VARIANCE CALCUALTIONS FOR SHIPMENTS ONLY*/
      /*  CALCUALTIONS FO OPENS ONLY                     */
      /*****************************************************************/
      /*   CURRENT  TO  SCHEDULE                      CURSCH           */
      /*****************************************************************/
      IF OIS.REPORTED_AS_OF_DATE > OIS.AMP_SCHEDULE_DATE AND
         TO_CHAR(OIS.AMP_SCHEDULE_DATE, 'YYYYMMDD') <> '00010101' THEN
         VGD_START_DATE := OIS.AMP_SCHEDULE_DATE;
         VGD_END_DATE   := OIS.REPORTED_AS_OF_DATE;
         P_COUNT_ELAPSED_DAYS;
         IF VGN_RESULT <> 0 THEN
            RAISE UE_CRITICAL_DB_ERROR;
         END IF;
         OIS.CURRENT_TO_SCHEDULE_VARIANCE := VGN_VARIANCE_DAYS;
      ELSE
         OIS.CURRENT_TO_SCHEDULE_VARIANCE := 0;
      END IF;
   
      /*****************************************************************/
      /*   CURRENT  TO  REQUEST                        CURREQ          */
      /*****************************************************************/
      IF OIS.REPORTED_AS_OF_DATE > OIS.CUSTOMER_REQUEST_DATE AND
         OIS.CUSTOMER_REQUEST_DATE <> k_begin_of_time THEN
         VGD_START_DATE := OIS.CUSTOMER_REQUEST_DATE;
         VGD_END_DATE   := OIS.REPORTED_AS_OF_DATE;
         P_COUNT_ELAPSED_DAYS;
         IF VGN_RESULT <> 0 THEN
            RAISE UE_CRITICAL_DB_ERROR;
         END IF;
         OIS.CURRENT_TO_REQUEST_VARIANCE := VGN_VARIANCE_DAYS;
      ELSE
         OIS.CURRENT_TO_REQUEST_VARIANCE := 0;
      END IF;
   END IF; /*  END OF CALCULATIONS FOR OPENS ONLY                */

   /*  THIS SECTION CALCULATES VARIANCES FOR SHIPS AND OPENS   */
   /*****************************************************************/
   /*   REQUEST TO SCHEDULE                          REQSCH         */
   /*****************************************************************/
   OIS.REQUEST_SCHEDULE_CMPRSN_CODE := 'R';
   VGD_START_DATE                   := OIS.CUSTOMER_request_date;

   -- check if the record can be considered as urgent order
   IF OIS.CUSTOMER_ACCT_TYPE_CDE = 'I' AND
      OIS.ORDER_RECEIVED_DATE IS NOT NULL THEN
      IF OIS.CUSTOMER_REQUEST_DATE <> k_begin_of_time AND
         OIS.ORDER_RECEIVED_DATE <> k_begin_of_time THEN
         IF OIS.CUSTOMER_REQUEST_DATE >= OIS.ORDER_RECEIVED_DATE AND
            OIS.CUSTOMER_REQUEST_DATE != OIS.AMP_SCHEDULE_DATE AND
            (OIS.CUSTOMER_REQUEST_DATE - OIS.ORDER_RECEIVED_DATE) <
            vgn_urgent_ord_offset_days THEN
            VGD_START_DATE                   := OIS.ORDER_RECEIVED_DATE + vgn_urgent_ord_offset_days;
            OIS.REQUEST_SCHEDULE_CMPRSN_CODE := 'U';
         END IF;
      END IF;
   END IF;

   VGD_END_DATE := OIS.AMP_SCHEDULE_DATE;
   
   P_COUNT_ELAPSED_DAYS;
   
   IF VGN_RESULT <> 0 THEN
      RAISE UE_CRITICAL_DB_ERROR;
   END IF;
   
   OIS.REQUEST_TO_SCHEDULE_VARIANCE := VGN_VARIANCE_DAYS;

   IF OIS.ORDER_RECEIVED_DATE IS NOT NULL THEN
      /*************************************************************/
      /*   RECEIVED TO  REQUEST                      RECREQ        */
      /*************************************************************/
      VGD_START_DATE := OIS.ORDER_RECEIVED_DATE;
      VGD_END_DATE   := OIS.CUSTOMER_REQUEST_DATE;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      OIS.RECEIVED_TO_REQUEST_VARIANCE := VGN_VARIANCE_DAYS;
   
      /*************************************************************/
      /*   RECEIVED TO  SCHEDULE                       RECSCH      */
      /*************************************************************/
      VGD_START_DATE := OIS.ORDER_RECEIVED_DATE;
      VGD_END_DATE   := OIS.AMP_SCHEDULE_DATE;
      P_COUNT_ELAPSED_DAYS;
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      OIS.RECEIVED_TO_SCHEDULE_VARIANCE := VGN_VARIANCE_DAYS;
   END IF;
   
   /*************************************************************/
   /*       RELEASED TO  SCHEDULE                       RELSCH  */
   /*************************************************************/
   OIS.RELEASE_TO_SCHEDULE_VARIANCE := 0;
   
   IF OIS.RELEASE_DATE IS NOT NULL THEN
      COMMIT_DATE                      := OIS.AMP_SCHEDULE_DATE;
      OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'S';
      IF (OIS.EARLIEST_EXPEDITE_DATE IS NOT NULL) AND
         (OIS.EARLIEST_EXPEDITE_DATE <= OIS.AMP_SCHEDULE_DATE) AND
         (OIS.EARLIEST_EXPEDITE_DATE <> k_begin_of_time) THEN
         COMMIT_DATE                      := OIS.EARLIEST_EXPEDITE_DATE;
         OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'X';
      END IF;
      /*
      /* NOW CHECK TO SEE IF THERE WAS A VALID DATE EXCEPTION
      /* TO PREVENT AMP FROM MEETING THE COMMIT DATE.
      /*                                                       */
   
      VGC_CALC_VARIANCE_CMPRSN_CODE := OIS.RELEASE_SCHEDULE_CMPRSN_CODE;
      p_compute_variance_days('RELSCH', gCommonFldsRec, COMMIT_DATE);
      IF VGN_RESULT <> 0 THEN
         RAISE UE_CRITICAL_DB_ERROR;
      END IF;
      OIS.RELEASE_SCHEDULE_CMPRSN_CODE := VGC_CALC_VARIANCE_CMPRSN_CODE;
      OIS.RELEASE_TO_SCHEDULE_VARIANCE := VGN_CALC_VARIANCE;
      /*
            IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL
                AND OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE >= COMMIT_DATE THEN
                    COMMIT_DATE := OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE;
                    OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'C';
            END IF;
            -- CHECK FOR TEMPORARY HOLD 
            IF OIS.TEMP_HOLD_OFF_DATE = COMMIT_DATE AND OIS.TEMP_HOLD_ON_DATE = COMMIT_DATE THEN
                   NULL;
            ELSE
                IF OIS.TEMP_HOLD_OFF_DATE IS NOT NULL
                    AND OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE
                    AND OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE THEN
                    IF OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE IS NOT NULL THEN
                        IF OIS.TEMP_HOLD_OFF_DATE >
                            OIS.SCHEDULE_OFF_CREDIT_HOLD_DATE THEN
                       --CASE - CREDIT HOLD COMING OFF WHEN IN TEMP HOLD
                                COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                                OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'T';
                        END IF;
      
                    ELSE
                        -- CASE - NO CREDIT HOLD - TEMP HOLD PREVENTED  
                        -- AMP FROM MEETING COMMIT DATE                 
                                COMMIT_DATE := OIS.TEMP_HOLD_OFF_DATE;
                                OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'T';
                    END IF;
                END IF;
            END IF;
            --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            --%%% LATE CODE LOGIC
            --%%% NOTE: IF SHIPMENT IS MADE BETWEEN CUST RQST DATE
            --%%%   (CUST EXP) AND SCHEDULE DATE (COMMIT DATE).
            --%%%   REMOVED 4/18/97 PER USER REQUEST
            --%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            -- CASE - EARLY TO CUST REQUEST                          
      --    IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
      --        (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
      --        AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
      --        <> '00010101') THEN
      --            CSTMR_COMMIT_DATE := OIS.CUSTOMER_EXPEDITE_DATE;
      --    ELSE
      --            CSTMR_COMMIT_DATE := OIS.CUSTOMER_REQUEST_DATE;
      --    END IF;
      --    IF (CSTMR_COMMIT_DATE < COMMIT_DATE)
      --        AND (OIS.RELEASE_DATE <= CSTMR_COMMIT_DATE)
      --        AND (OIS.CUSTOMER_TYPE_CODE <> 'J' OR
      --        OIS.CUSTOMER_TYPE_CODE IS NULL) THEN
      --            COMMIT_DATE := CSTMR_COMMIT_DATE;
      --        IF (OIS.CUSTOMER_EXPEDITE_DATE IS NOT NULL) AND
      --            (OIS.CUSTOMER_EXPEDITE_DATE < OIS.CUSTOMER_REQUEST_DATE)
      --            AND (TO_CHAR(OIS.CUSTOMER_EXPEDITE_DATE ,'YYYYMMDD')
      --            <> '00010101') THEN
      --                OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'E';
      --        ELSE
      --            OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'R';
      --        END IF;
      --    END IF;
            -- CASE - IF MADE WITHIN RANGE, THEN CONSIDER ON-TIME    
            -- LATE CODED                                            
            -- IF COMMIT DATE AND SHIP DATE         
            -- FALL WITHIN THE TEMPORARY HOLD PERIOD THEN SHIPMENT IS ON TIME.
            IF (OIS.TEMP_HOLD_OFF_DATE IS NOT NULL)
                AND (OIS.TEMP_HOLD_OFF_DATE >= COMMIT_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE <= COMMIT_DATE)
                AND (OIS.TEMP_HOLD_OFF_DATE >= OIS.RELEASE_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE <= OIS.RELEASE_DATE) THEN
                    OIS.RELEASE_TO_SCHEDULE_VARIANCE := 0;
                    VGN_VARIANCE_DAYS := 0;
                    OIS.RELEASE_SCHEDULE_CMPRSN_CODE := 'T';
            ELSE
            -- IF NOT LATE CODED, THEN CALCULATE THE VARIANCE           
                 VGD_START_DATE := COMMIT_DATE;
                 VGD_END_DATE := OIS.RELEASE_DATE;
                 P_COUNT_ELAPSED_DAYS;
                 IF VGN_RESULT <> 0 THEN
                     RAISE UE_CRITICAL_DB_ERROR;
                 END IF;
                 OIS.RELEASE_TO_SCHEDULE_VARIANCE := VGN_VARIANCE_DAYS;
            END IF;
            IF (OIS.RELEASE_SCHEDULE_CMPRSN_CODE = 'T'
                OR OIS.RELEASE_SCHEDULE_CMPRSN_CODE = 'C')
                AND (OIS.RELEASE_TO_SCHEDULE_VARIANCE <> 0)
                AND (OIS.RELEASE_TO_SCHEDULE_VARIANCE <> -999) THEN
                    --ALLOW GRACE DAY - TAKES A DAY TO ALLOW SHIPMENT 
                    --AFTER A TEMP HOLD OR CREDIT HOLD COMES OFF. 
                    IF OIS.RELEASE_TO_SCHEDULE_VARIANCE > 0 THEN
                        OIS.RELEASE_TO_SCHEDULE_VARIANCE := OIS.RELEASE_TO_SCHEDULE_VARIANCE - 1;
                    ELSE
                        OIS.RELEASE_TO_SCHEDULE_VARIANCE := OIS.RELEASE_TO_SCHEDULE_VARIANCE + 1;
                    END IF;
            END IF;
       
            --IF THERE WAS A TEMPORARY HOLD AFTER THE COMMIT DATE 
            --THEN SUBTRACT IT OUT OF THE VARIANCE.           
            IF OIS.TEMP_HOLD_OFF_DATE = COMMIT_DATE
                AND OIS.TEMP_HOLD_ON_DATE = COMMIT_DATE THEN
                   NULL;
            ELSIF ((OIS.TEMP_HOLD_OFF_DATE <= COMMIT_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE >= OIS.RELEASE_DATE)
                AND (COMMIT_DATE > OIS.RELEASE_DATE)
                AND (OIS.RELEASE_TO_SCHEDULE_VARIANCE <> 0))
                OR ((OIS.TEMP_HOLD_OFF_DATE <= OIS.RELEASE_DATE)
                AND (OIS.TEMP_HOLD_ON_DATE >= COMMIT_DATE)
                AND (OIS.RELEASE_DATE > COMMIT_DATE)
                AND (OIS.RELEASE_TO_SCHEDULE_VARIANCE <> 0)
                AND (OIS.RELEASE_TO_SCHEDULE_VARIANCE <> -999)) THEN
                    VGD_START_DATE := OIS.TEMP_HOLD_ON_DATE;
                    VGD_END_DATE := OIS.TEMP_HOLD_OFF_DATE;
                    P_COUNT_ELAPSED_DAYS;
                    IF VGN_RESULT <> 0 THEN
                        RAISE UE_CRITICAL_DB_ERROR;
                    END IF;
                    IF VGN_VARIANCE_DAYS <> -999 THEN
                        VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                        -- DETERMINE IF A GRACE DAY NEEDS TO BE ADDED WHEN 
                        -- COMING OFF TEMP HOLD                         
                        IF  ABS(OIS.RELEASE_TO_SCHEDULE_VARIANCE) = VGN_VARIANCE_DAYS THEN
                                GOTO NO_GRACE_DAY;
                        END IF;
                        IF OIS.RELEASE_DATE < COMMIT_DATE THEN
                            IF OIS.TEMP_HOLD_OFF_DATE < COMMIT_DATE THEN
                                VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                            END IF;
                        ELSE
                            IF OIS.TEMP_HOLD_OFF_DATE < OIS.RELEASE_DATE THEN
                                VGN_VARIANCE_DAYS := VGN_VARIANCE_DAYS + 1;
                            END IF;
                        END IF;
                        <<NO_GRACE_DAY>>
                            NULL;
                        IF OIS.RELEASE_TO_SCHEDULE_VARIANCE > 0 THEN
                            OIS.RELEASE_TO_SCHEDULE_VARIANCE :=
                                OIS.RELEASE_TO_SCHEDULE_VARIANCE - VGN_VARIANCE_DAYS;
                        ELSE
                            OIS.RELEASE_TO_SCHEDULE_VARIANCE :=
                                OIS.RELEASE_TO_SCHEDULE_VARIANCE + VGN_VARIANCE_DAYS;
                        END IF;
                    END IF;
            END IF;
      */
      
   END IF;

EXCEPTION
   WHEN UE_CRITICAL_DB_ERROR THEN
      VON_RESULT := VGN_RESULT;
      DBMS_OUTPUT.PUT_LINE('BAD RETURN FROM COUNT_ELAPSED_DAYS');
   WHEN OTHERS THEN
      VON_RESULT := SQLCODE;
      VGN_RESULT := SQLCODE;
      DBMS_OUTPUT.PUT_LINE('P_VARIANCE_CALC');
      DBMS_OUTPUT.PUT_LINE('SQL ERROR: ' || SQLERRM(VGN_RESULT));
   
END P_VARIANCE_CALC;

END Pkg_Variance_Calc;
/

-- ===========================================================================================================
