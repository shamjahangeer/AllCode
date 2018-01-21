CREATE OR REPLACE PROCEDURE fix_mfg_data
AS

 v_org_id               MANUFACTURING_SOURCE_ORGS.org_id%TYPE;           -- MFG Org
 v_org_key_id           ORDER_ITEM_SHIPMENT.mfr_org_key_id%TYPE;         -- MFG Org Key Id
 v_proc_type_cde        GCS_FROZEN_COST_V.gfc_procurement_type_cde%TYPE;
 v_plant_id             TEMP_ORDER_ITEM_SHIPMENT.actual_ship_building_nbr%TYPE;
 v_mfg_building_nbr     ORDER_ITEM_SHIPMENT.mfg_building_nbr%TYPE;
 v_default_mfg_plant_id ORDER_ITEM_SHIPMENT.default_manufacturing_plant_id%TYPE;
 l_tot_rec              NUMBER := 0;
 l_mis_rec              NUMBER := 0;
 l_map_rec              NUMBER := 0;
 k_max_date             CONSTANT DATE := TO_DATE('20991231','YYYYMMDD');

 CURSOR fix_mfr_org IS
  SELECT ois.part_key_id, ois.organization_key_id, ois.amp_shipped_date, ois.mfr_org_key_id, ois.ROWID row_id
  FROM   order_item_shipment ois
  WHERE  ois.mfg_building_nbr IN ('*', 'PUR')
  AND    ois.amp_shipped_date IS NOT NULL ;

 CURSOR get_mfr_org (v_part_key_id ORDER_ITEM_SHIPMENT.part_key_id%TYPE, v_org_id MANUFACTURING_SOURCE_ORGS.org_id%TYPE, v_amp_shipped_dt ORDER_ITEM_SHIPMENT.amp_shipped_date%TYPE) IS
  SELECT manufacturing_source_org_id
  FROM   manufacturing_source_orgs
  WHERE  part_key_id = v_part_key_id
  AND    org_id      = v_org_id
  AND   v_amp_shipped_dt BETWEEN effective_dt AND NVL(expiration_dt, k_max_date);

BEGIN

   FOR fix_mfr_org_rec IN fix_mfr_org
   LOOP
      -- Reset variables
      v_org_id               := NULL;
      v_org_key_id           := NULL;
      v_proc_type_cde        := NULL;
      v_mfg_building_nbr     := NULL;
      v_default_mfg_plant_id := NULL;

      -- Derive mfg bldg/plant
      IF Scdcommonbatch.get_mfg_bldg_plant(FIX_MFR_ORG_REC.organization_key_id, FIX_MFR_ORG_REC.part_key_id, v_mfg_building_nbr, v_default_mfg_plant_id ) THEN
         IF v_mfg_building_nbr IS NULL THEN
            -- determine if product is purchased
            -- Get Reporting Org Id
            IF scdCommonBatch.GetOrgIDV4(FIX_MFR_ORG_REC.amp_shipped_date, v_org_id) THEN
               FOR get_mfr_org_rec IN get_mfr_org (FIX_MFR_ORG_REC.part_key_id, v_org_id, FIX_MFR_ORG_REC.amp_shipped_date)
               LOOP
                  -- Get Mfg Org Key Id
                  IF scdCommonBatch.GetOrgKeyIDV4(GET_MFR_ORG_REC.manufacturing_source_org_id, FIX_MFR_ORG_REC.amp_shipped_date, v_org_key_id) THEN
                     -- Determine mfg_building_nbr
                     v_proc_type_cde := Scdcommonbatch.get_proc_type_cde(GET_MFR_ORG_REC.manufacturing_source_org_id, FIX_MFR_ORG_REC.part_key_id);
                     IF v_proc_type_cde = '2' THEN -- manufactured
                        IF Scdcommonbatch.get_mfg_bldg_plant(v_org_key_id, FIX_MFR_ORG_REC.part_key_id, v_mfg_building_nbr, v_default_mfg_plant_id ) THEN
                           IF v_mfg_building_nbr IS NULL THEN
                              v_mfg_building_nbr := '*';
                           END IF;
                        END IF;
                     ELSIF v_proc_type_cde IS NOT NULL THEN -- purchased
                        v_mfg_building_nbr := 'PUR'; -- set default value
                     END IF;  -- v_proc_type_cde

                     IF v_mfg_building_nbr IS NOT NULL THEN
                        l_map_rec := l_map_rec + 1;
                        /*
                        -- Update Order_item_shipment record
                        UPDATE order_item_shipment
                        SET    MFR_ORG_KEY_ID                 = v_org_key_id
                             , MFG_BUILDING_NBR               = v_mfg_building_nbr
                             , DEFAULT_MANUFACTURING_PLANT_ID = v_default_mfg_plant_id
                             , DML_ORACLE_ID                  = USER
                             , DML_TMSTMP                     = SYSDATE
                        WHERE  ROWID = FIX_MFR_ORG_REC.row_id;
                        */
                     ELSE
                        l_mis_rec := l_mis_rec + 1;
                     END IF;
                     END IF;
                  END IF;  -- Get Mfg Org Key Id
               END LOOP;  -- get_mfr_org
            END IF;  -- -- Get Reporting Org Id
         END IF;  -- v_mfg_building_nbr
      END IF;  -- Derive mfg bldg/plant

      l_tot_rec := l_tot_rec + 1;
      IF MOD(fix_mfr_org%ROWCOUNT, 20000) = 0 THEN
         COMMIT;
      END IF;
   END LOOP;  -- fix_mfr_org
   COMMIT;

   /*
   -- Fix the Summary Table data
   DELETE FROM MFG_CAMPUS_BLDG_SMRY;
   COMMIT;

   -- Refresh/Build Mfg Summary Table Data
   P_RESMRY_MFG_CAMPUS;
   COMMIT;
   */

   DBMS_OUTPUT.PUT_LINE('Total records:           '||TO_CHAR(l_tot_rec));
   DBMS_OUTPUT.PUT_LINE('Total records Matched:   '||TO_CHAR(l_map_rec));
   DBMS_OUTPUT.PUT_LINE('Total records Unmatched: '||TO_CHAR(l_mis_rec));

END fix_mfg_data;
/
