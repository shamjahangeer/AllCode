CREATE TABLE MPS_SAP.E01_GBL_IND_DRILL_DOWN_LAYERS
AS SELECT * FROM GBL_CURRENT.GBL_INDUSTRY_DRILL_DOWN_LAYERS;

CREATE TABLE E01_MATERIAL_PLANTS 
AS SELECT * FROM material_plants WHERE plant_id IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE MPS_SAP.E01_GBL_PRODUCT
AS SELECT * FROM GBL_CURRENT.GBL_PRODUCT;

CREATE TABLE MPS_SAP.E01_GBL_PRODUCT_LINE
AS SELECT * FROM GBL_CURRENT.GBL_PRODUCT_LINE;

CREATE TABLE MPS_SAP.E01_GBL_SAP_PROFIT_CENTERS
AS SELECT * FROM GBL_CURRENT.GBL_SAP_PROFIT_CENTERS;

CREATE TABLE MPS_SAP.E01_GBL_MGE_PROFIT_CENTER_RELS
AS SELECT * FROM GBL_CURRENT.GBL_MGE_PROFIT_CENTER_RELS 
WHERE MGE_PROFIT_CENTER_ABBREV_ID = 'AUT';

CREATE TABLE MPS_SAP.E01_MASTER_CODES
AS SELECT * FROM MASTER.MASTER_CODES;

CREATE TABLE MPS_SAP.E01_ORGANIZATIONS_DMN
AS SELECT * FROM MASTER.ORGANIZATIONS_DMN;

CREATE TABLE MPS_SAP.E01_SOURCE_LISTS
AS SELECT * FROM VNC.SOURCE_LISTS
WHERE plant_id IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE MPS_SAP.E01_INFOREC_PUR_ORGS
AS SELECT * FROM VNC.INFOREC_PUR_ORGS
WHERE plant_id IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE E01_WORK_CENTER_CAPACITIES_V 
AS SELECT * FROM SOD.WORK_CENTER_CAPACITIES_V;

CREATE TABLE E01_WORK_CENTER_HEADERS_V 
AS SELECT * FROM SOD.WORK_CENTER_HEADERS_V;

CREATE TABLE E01_MATERIALS
AS SELECT * FROM GBL_CURRENT.MATERIALS
WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_MATERIAL_VALUATIONS
AS SELECT * FROM GBL_CURRENT.MATERIAL_VALUATIONS
WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_MATERIAL_SLS_ORGS
AS SELECT * FROM GBL_CURRENT.MATERIAL_SLS_ORGS
WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_VENDORS_DMN 
AS SELECT * FROM CMD.VENDORS_DMN
WHERE vendor_id IN (SELECT VENDOR_ID FROM E01_SOURCE_LISTS
                    UNION
                    SELECT VENDOR_ID FROM E01_INFOREC_PUR_ORGS
                    UNION
                    SELECT SUPPLIER_ID FROM MPS_SUPPLIERS);

CREATE TABLE E01_VENDORS 
AS SELECT * FROM VNC.VENDORS
WHERE vendor_id IN (SELECT VENDOR_ID FROM E01_SOURCE_LISTS
                    UNION
                    SELECT VENDOR_ID FROM E01_INFOREC_PUR_ORGS
                    UNION
                    SELECT SUPPLIER_ID FROM MPS_SUPPLIERS);

CREATE TABLE E01_BOM_HEADERS_V 
AS SELECT * FROM SOD.BOM_HEADERS_V
WHERE MATERIAL_NUMBER IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_BOM_ITEMS_V 
AS SELECT * FROM SOD.BOM_ITEMS_V
WHERE PARENT_MATERIAL_NUMBER IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_PLANNED_PROD_ORDERS_V 
AS SELECT * FROM SOD.PLANNED_PRODUCTION_ORDERS_V
WHERE PLANNING_PLANT IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE E01_PROD_ORDERS_HEADERS_V 
AS SELECT * FROM SOD.PROD_ORDERS_HEADERS_V
WHERE PLANT_ID IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE E01_PROD_ORDERS_OPERATIONS_V 
AS SELECT * FROM SOD.PROD_ORDERS_OPERATIONS_V
WHERE PLANT_ID IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE E01_PROD_PLANNING_VERSIONS_V 
AS SELECT * FROM SOD.PRODUCTION_PLANNING_VERSIONS_V
WHERE PLANT IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE E01_ROUTING_OPERATIONS_V 
AS SELECT * FROM SOD.ROUTING_OPERATIONS_V
WHERE MATERIAL_NBR IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_CORPORATE_PARTS
AS SELECT * FROM GBL_CURRENT.CORPORATE_PARTS
WHERE TYCO_ELECTRONICS_CORP_PART_NBR IN (SELECT material_id FROM E01_material_plants);

CREATE TABLE E01_MFR_EFF_REPT_DETAILS  
AS SELECT * FROM MER.MFR_EFFICIENCY_REPT_DETAILS
WHERE CFRM_PLANT_ID IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');
 
CREATE TABLE E01_EQUIPMENT_MAIN_DATA_V
AS SELECT * FROM EQUIPMENT_MAIN_DATA_V;

CREATE TABLE E01_OPERATIONS_CAPACITY_REQR
AS SELECT * FROM OPERATIONS_CAPACITY_REQR
WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_OPERATIONS_SCHEDULING
AS SELECT * FROM   OPERATIONS_SCHEDULING
WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

CREATE TABLE E01_WORK_CENTERS_HEIR_TREE
AS SELECT * FROM WORK_CENTERS_HEIRARCHY_TREE;

CREATE TABLE E01_PRODUCTION_ORDERS
AS SELECT * FROM PRODUCTION_ORDERS
WHERE PLANT_ID IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

CREATE TABLE MPS_SAP.E01_PROD_ORDER_DPNT_REQ_V
AS SELECT * FROM SOD.PROD_ORDER_DPNT_REQUIREMENTS_V
WHERE PLANT = '0809';

-- CREATE TABLE MPS_SAP.E01_GLOBAL_INVENTORIES_DAILY
-- AS SELECT * FROM GIN_CURRENT.GLOBAL_INVENTORIES_DAILY
-- WHERE plant_id IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

-- CREATE TABLE MPS_SAP.E01_VENDOR_CONTACTS_V
-- AS SELECT * FROM TCM.VENDOR_CONTACTS_V;

-- CREATE TABLE MPS_SAP.E01_ORDER_ITEM_OPEN
-- AS SELECT * FROM SCD.ORDER_ITEM_OPEN
-- WHERE INVENTORY_BUILDING_NBR IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

-- CREATE TABLE MPS_SAP.E01_ORDER_ITEM_SHIPMENT
-- AS SELECT * FROM SCD.ORDER_ITEM_SHIPMENT
-- WHERE ACTUAL_SHIP_BUILDING_NBR IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

-- CREATE TABLE E01_MATL_MFG_BLDG_XREF 
-- AS SELECT * FROM GBL_CURRENT.MATL_MFG_BLDG_XREF
-- WHERE MATERIAL_ID IN (SELECT MATERIAL_ID FROM E01_MATERIAL_PLANTS);

-- CREATE TABLE E01_FDC_SCHD_AGREEMENT_KINEXIS
-- AS SELECT * FROM FDC_SCHD_AGREEMENTS_KINEXIS
-- WHERE PLANT_ID IN (select PLANT_ID from MPS_PLANTS where REGIONAL_BU_CDE = 'E01');

DECLARE
BEGIN
   FOR i IN (SELECT table_name FROM user_tables WHERE table_name NOT LIKE 'BIN%' AND table_name LIKE 'E01_%')
   LOOP
      DBMS_STATS.GATHER_TABLE_STATS(USER, I.table_name, estimate_percent => 20, method_opt => 'for all columns size 1', cascade => true, degree => 2 );
   END LOOP;
END;
/

/*
-- DROP Table statements:

DROP TABLE E01_BOM_HEADERS_V 
DROP TABLE E01_BOM_ITEMS_V 
DROP TABLE E01_CORPORATE_PARTS
DROP TABLE E01_EQUIPMENT_MAIN_DATA_V
DROP TABLE E01_GBL_IND_DRILL_DOWN_LAYERS
DROP TABLE E01_GBL_MGE_PROFIT_CENTER_RELS
DROP TABLE E01_GBL_PRODUCT
DROP TABLE E01_GBL_PRODUCT_LINE
DROP TABLE E01_GBL_SAP_PROFIT_CENTERS
DROP TABLE E01_INFOREC_PUR_ORGS
DROP TABLE E01_MASTER_CODES
DROP TABLE E01_MATERIAL_PLANTS 
DROP TABLE E01_MATERIAL_SLS_ORGS
DROP TABLE E01_MATERIAL_VALUATIONS
DROP TABLE E01_MATERIALS
DROP TABLE E01_MFR_EFF_REPT_DETAILS  
DROP TABLE E01_OPERATIONS_CAPACITY_REQR
DROP TABLE E01_OPERATIONS_SCHEDULING
DROP TABLE E01_ORGANIZATIONS_DMN
DROP TABLE E01_PLANNED_PROD_ORDERS_V 
DROP TABLE E01_PROD_ORDERS_HEADERS_V 
DROP TABLE E01_PROD_ORDERS_OPERATIONS_V 
DROP TABLE E01_PROD_PLANNING_VERSIONS_V 
DROP TABLE E01_PRODUCTION_ORDERS
DROP TABLE E01_ROUTING_OPERATIONS_V 
DROP TABLE E01_SOURCE_LISTS
DROP TABLE E01_VENDORS 
DROP TABLE E01_VENDORS_DMN 
DROP TABLE E01_WORK_CENTER_CAPACITIES_V 
DROP TABLE E01_WORK_CENTER_HEADERS_V 
DROP TABLE E01_WORK_CENTERS_HEIR_TREE

-- DROP TABLE E01_FDC_SCHD_AGREEMENT_KINEXIS
-- DROP TABLE E01_GLOBAL_INVENTORIES_DAILY
-- DROP TABLE E01_MATL_MFG_BLDG_XREF 
-- DROP TABLE E01_ORDER_ITEM_OPEN
-- DROP TABLE E01_ORDER_ITEM_SHIPMENT
-- DROP TABLE E01_VENDOR_CONTACTS_V

*/
