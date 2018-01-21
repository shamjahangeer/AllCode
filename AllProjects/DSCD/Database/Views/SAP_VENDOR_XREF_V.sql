create or replace view scd.sap_vendor_xref_v as
select "PART_KEY_ID","PLANT_ID","WWAN","VENDOR_ID","VENDORS_KEY_ID" from (
   select  subx.part_key_id
           , subx.plant_id
           , subx.wwan
           , subx.vendor_id
           , subx.vendors_key_id
--           , subx.vendor_nm
   from (
      select cp.part_key_id
           , x.plant_id
           , v.worldwide_vendor_id as wwan
           , v.vendor_id
           , v.vendors_key_id
--           , v.vendor_nm
           , row_number() over (partition by cp.part_key_id, x.plant_id order by 1 desc) xrownum
       from vnc.source_lists x
       join vendors_dmn v
           on x.vendor_id=v.vendor_id
           and x.org_id=v.company_organization_id
           and v.record_status_cde='C'
           and v.source_system_id='1'
       join corporate_parts cp
           on x.material_id = cp.tyco_electronics_corp_part_nbr
       where x.fixed_vendor_ind='X'
           and x.valid_to_dt>trunc(sysdate)
       group by cp.part_key_id
           , x.plant_id
           , v.worldwide_vendor_id
           , v.vendor_id
           , v.vendors_key_id
--           , v.vendor_nm
       order by cp.part_key_id
           , x.plant_id ) subx
   where subx.xrownum=1
  )

;
