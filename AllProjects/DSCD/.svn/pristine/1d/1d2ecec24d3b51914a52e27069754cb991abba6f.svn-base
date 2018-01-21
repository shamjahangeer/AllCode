CREATE OR REPLACE PROCEDURE p_fix_mfg_bldg IS

CURSOR ois_cur IS
   SELECT /*+ NO_INDEX(ois) */
          default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,mso.manufacturing_source_org_id,ois.part_key_id,od_mfg.organization_key_id mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr,rpt_od.organization_id rpt_org_id
--,ois.source_id,ois.*
         ,ois.organization_key_id,ois.amp_shipped_date,dml_tmstmp,ois.amp_order_nbr,ois.order_item_nbr,ois.shipment_id
    FROM  order_item_shipment ois, organizations_dmn rpt_od,organizations_dmn od_mfg
         ,MANUFACTURING_SOURCE_ORGS mso
    where (mfg_building_nbr = '*' or mfg_building_nbr = 'PUR')
    and default_manufacturing_plant_id is null
    and (ois.mfr_org_key_id=1865 or ois.organization_key_id=1865)
--    and ois.amp_shipped_date >= '01-oct-2011'
    and rpt_od.record_status_cde='C' 
    and rpt_od.organization_key_id=ois.organization_key_id   
    and mso.org_id=rpt_od.organization_id  
    and ois.part_key_id = mso.part_key_id     
    and ois.amp_shipped_date BETWEEN mso.EFFECTIVE_DT AND NVL(trim(mso.EXPIRATION_DT),'31-dec-2099')     
    and od_mfg.organization_id=mso.manufacturing_source_org_id 
    and od_mfg.record_status_cde='C'
--    and ois.part_key_id=8465712
   ; 
  
vln_cnt	  			  NUMBER(10):=0;
vln_max_cnt			  NUMBER(10):=10000;
--v_plant_id          VARCHAR2(4):= NULL;
v_proc_type_cde     VARCHAR2(4):= NULL;
g_error_section       VARCHAR2(50):= NULL;
New_Exception         EXCEPTION;
BEGIN
 
   g_error_section := 'Upd OIS tbl';
   FOR ois_rec IN ois_cur LOOP
      ois_rec.vendor_id:=null;
      ois_rec.vendor_key_id:=null;

      IF Scdcommonbatch.get_mfg_bldg_plant(ois_rec.mfr_org_key_id
                                          ,ois_rec.part_key_id
                                          ,ois_rec.mfg_building_nbr
                                          ,ois_rec.default_manufacturing_plant_id
                                          ) THEN
        NULL;
      END IF;
      IF ois_rec.mfg_building_nbr IS NOT NULL THEN
        -- if found then no need to check if product is purchase or not
        GOTO end_mfgbldg;
      ELSE
        ois_rec.mfg_building_nbr := '*';
      END IF;      

      -- determine if product is purchased
      v_proc_type_cde:=Scdcommonbatch.get_proc_type_cde(ois_rec.manufacturing_source_org_id,ois_rec.part_key_id);  

      IF v_proc_type_cde = '2' THEN -- manufactured              
        IF ois_rec.mfg_building_nbr IS NULL THEN
          ois_rec.mfg_building_nbr:='*';
        END IF;
      ELSIF v_proc_type_cde IS NOT NULL THEN -- purchased
        ois_rec.mfg_building_nbr:='PUR'; -- set default value

        -- derive vendor id        
        IF Scdcommonbatch.get_sap_vendor_id(ois_rec.part_key_id
                                           ,ois_rec.actual_ship_building_nbr
                                           ,ois_rec.vendor_id
                                           ,ois_rec.vendor_key_id
                                           ) THEN
          NULL;
        END IF;                  
      END IF;          
    
      IF ois_rec.mfg_building_nbr IS NULL THEN
        ois_rec.mfg_building_nbr:='*';
      END IF;
      IF ois_rec.mfr_org_key_id IS NULL THEN
        ois_rec.mfr_org_key_id:=0;
      END IF;
      
      <<end_mfgbldg>>          

      UPDATE ORDER_ITEM_SHIPMENT
      SET	 default_manufacturing_plant_id =ois_rec.default_manufacturing_plant_id
            ,mfg_building_nbr               =ois_rec.mfg_building_nbr
            ,mfr_org_key_id                 =ois_rec.mfr_org_key_id
            ,vendor_id                      =ois_rec.vendor_id
            ,vendor_key_id                  =ois_rec.vendor_key_id
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
