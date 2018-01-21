CREATE OR REPLACE PROCEDURE p_pop_mfg_bldg_hist IS

CURSOR ois_cur IS
--old cur
/*   SELECT default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,od.organization_id,ois.part_key_id,ois.mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr
    FROM  order_item_shipment ois, organizations_dmn od
--where 1=1
    where (mfg_building_nbr is null or mfg_building_nbr = '*')
    and default_manufacturing_plant_id is null
    and data_source_desc = 'TYCOSAPABC'
    and ois.organization_key_id=od.organization_key_id
    and od.record_status_cde='C'
and amp_order_nbr in ('3015366051')*/

--2nd run
/*   SELECT \*+ NO_INDEX(ois) *\
          default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,od.organization_id,ois.part_key_id,ois.mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr
    FROM  order_item_shipment ois, organizations_dmn od
--where 1=1
    where ((mfg_building_nbr='PUR' or mfg_building_nbr = '*' and ois.organization_key_id!=ois.mfr_org_key_id)
           or (mfg_building_nbr = '*' and mfr_org_key_id=1000)
          )
    and default_manufacturing_plant_id is null
    and data_source_desc = 'TYCOSAPABC'
    and ois.mfr_org_key_id=od.organization_key_id
    and od.record_status_cde='C'*/

--3rd run    
/*   SELECT \*+ NO_INDEX(ois) *\
          default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,od.organization_id,ois.part_key_id,ois.mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr
    FROM  order_item_shipment ois, organizations_dmn od,co_org_matl_dflt_mfr_bldg_xref mbx
--where 1=1
    where mfg_building_nbr = '*'
    and default_manufacturing_plant_id is null
--    and data_source_desc = 'TYCOSAPABC'
    and ois.mfr_org_key_id=od.organization_key_id
    and od.record_status_cde='C'    
    and ((mbx.company_organization_key_id = ois.mfr_org_key_id)
         or (ois.mfr_org_key_id = 1000 and mbx.company_organization_key_id = 35)
        )  
    AND mbx.part_key_id                 = ois.part_key_id*/
--and amp_order_nbr='219469'

/*   SELECT \*+ NO_INDEX(ois) *\
          default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,od.organization_id,ois.part_key_id,ois.mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr
    FROM  order_item_shipment ois, organizations_dmn od,co_org_matl_dflt_mfr_bldg_xref mbx
--where 1=1
    where mfg_building_nbr = '*'
    and default_manufacturing_plant_id is null
--    and data_source_desc = 'TYCOSAPABC'
    and ois.mfr_org_key_id=od.organization_key_id
    and od.record_status_cde='C'    
    and ois.mfr_org_key_id = 1000   
    and mbx.company_organization_key_id = 35
    AND mbx.part_key_id                 = ois.part_key_id*/
--and amp_order_nbr='954086'

--4rd run    
   SELECT /*+ NO_INDEX(ois) */
          default_manufacturing_plant_id,mfg_building_nbr,vendor_id,vendor_key_id,od.organization_id,ois.part_key_id,ois.mfr_org_key_id
         ,ois.rowid,ois.actual_ship_building_nbr
    FROM  order_item_shipment ois, organizations_dmn od,co_org_matl_dflt_mfr_bldg_xref mbx
--where 1=1
    where mfg_building_nbr = '*'
    and default_manufacturing_plant_id is null
--    and data_source_desc = 'TYCOSAPABC'
    and ois.mfr_org_key_id=od.organization_key_id
    and od.record_status_cde='C'    
    and ((mbx.company_organization_key_id = ois.mfr_org_key_id)
         or (ois.mfr_org_key_id = 1858 and mbx.company_organization_key_id = 387)
         or (ois.mfr_org_key_id = 1448 and mbx.company_organization_key_id = 895)
         or (ois.mfr_org_key_id = 1434 and mbx.company_organization_key_id = 391)                  
        )  
    AND mbx.part_key_id                 = ois.part_key_id
--AND ois.part_key_id in (5038135,1975962)
--and amp_order_nbr in ('3021791385','3022416786')
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
    if ois_rec.mfg_building_nbr='PUR' then
      ois_rec.vendor_id:=null;
      ois_rec.vendor_key_id:=null;
    end if;

    -- determine if product is purchased
    v_proc_type_cde:=Scdcommonbatch.get_proc_type_cde(ois_rec.organization_id,ois_rec.part_key_id);  

    IF v_proc_type_cde = '2' THEN -- manufactured              
      -- derive mfg bldg/plant
      IF Scdcommonbatch.get_mfg_bldg_plant(ois_rec.mfr_org_key_id
                                          ,ois_rec.part_key_id
                                          ,ois_rec.mfg_building_nbr
                                          ,ois_rec.default_manufacturing_plant_id
                                          ) THEN
        NULL;
      END IF;
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

--    IF (v_proc_type_cde is not null and ois_rec.mfg_building_nbr!='*') or 
--       (ois_rec.mfg_building_nbr='*' and ois_rec.vendor_key_id is not null)  then
      UPDATE ORDER_ITEM_SHIPMENT
      SET	 default_manufacturing_plant_id =ois_rec.default_manufacturing_plant_id
            ,mfg_building_nbr               =ois_rec.mfg_building_nbr
            ,vendor_id                      =ois_rec.vendor_id
            ,vendor_key_id                  =ois_rec.vendor_key_id
      WHERE  ROWID = ois_rec.ROWID;
     
      vln_cnt := vln_cnt + 1;
      IF MOD(vln_cnt, vln_max_cnt) = 0 THEN
         COMMIT;
      END IF;
--    end if;

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
