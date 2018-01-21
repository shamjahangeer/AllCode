create or replace view scd.temp_oio_sched_dates_v
(schd_tyco_year_id, schd_tyco_month_of_year_id, date_group)
as
select distinct SCHD_TYCO_YEAR_ID, SCHD_TYCO_MONTH_OF_YEAR_ID,  
decode(sign(to_date('01-JAN-1950') - AMP_SCHEDULE_DATE),1,'UNSCHED',  
	decode(sign(sysdate - AMP_SCHEDULE_DATE),1,'PAST DUE'))  
from ORDER_ITEM_OPEN
;
