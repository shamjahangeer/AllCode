-- 09/17/2012

SET LINES 120
COLUMN stmts FORMAT A120
COLUMN OBJECT_NAME FORMAT A30

SELECT 'CREATE SYNONYM'||' '||RPAD(SUBSTR(object_name, INSTR(object_name, '_', 1) +1), 30, ' ')||' '||'FOR'||' MPS_SAP.'||RPAD(object_name, 30, ' ')||' ;' Stmts
FROM   user_objects
WHERE  TRUNC(created) = TRUNC(sysdate)
ORDER BY 1;

STMTS                                                                                                                                                   
------------------------------------------------------------------------------------------                                                              
CREATE SYNONYM BOM_HEADERS_V                  FOR MPS_SAP.E01_BOM_HEADERS_V              ;                                                              
CREATE SYNONYM BOM_ITEMS_V                    FOR MPS_SAP.E01_BOM_ITEMS_V                ;                                                              
CREATE SYNONYM CORPORATE_PARTS                FOR MPS_SAP.E01_CORPORATE_PARTS            ;                                                              
CREATE SYNONYM EQUIPMENT_MAIN_DATA_V          FOR MPS_SAP.E01_EQUIPMENT_MAIN_DATA_V      ;                                                              
CREATE SYNONYM GBL_IND_DRILL_DOWN_LAYERS      FOR MPS_SAP.E01_GBL_IND_DRILL_DOWN_LAYERS  ;                                                              
CREATE SYNONYM GBL_MGE_PROFIT_CENTER_RELS     FOR MPS_SAP.E01_GBL_MGE_PROFIT_CENTER_RELS ;                                                              
CREATE SYNONYM GBL_PRODUCT                    FOR MPS_SAP.E01_GBL_PRODUCT                ;                                                              
CREATE SYNONYM GBL_PRODUCT_LINE               FOR MPS_SAP.E01_GBL_PRODUCT_LINE           ;                                                              
CREATE SYNONYM GBL_SAP_PROFIT_CENTERS         FOR MPS_SAP.E01_GBL_SAP_PROFIT_CENTERS     ;                                                              
CREATE SYNONYM INFOREC_PUR_ORGS               FOR MPS_SAP.E01_INFOREC_PUR_ORGS           ;                                                              
CREATE SYNONYM MASTER_CODES                   FOR MPS_SAP.E01_MASTER_CODES               ;                                                              
CREATE SYNONYM MATERIALS                      FOR MPS_SAP.E01_MATERIALS                  ;                                                              
CREATE SYNONYM MATERIAL_PLANTS                FOR MPS_SAP.E01_MATERIAL_PLANTS            ;                                                              
CREATE SYNONYM MATERIAL_SLS_ORGS              FOR MPS_SAP.E01_MATERIAL_SLS_ORGS          ;                                                              
CREATE SYNONYM MATERIAL_VALUATIONS            FOR MPS_SAP.E01_MATERIAL_VALUATIONS        ;                                                              
CREATE SYNONYM MFR_EFF_REPT_DETAILS           FOR MPS_SAP.E01_MFR_EFF_REPT_DETAILS       ;                                                              
CREATE SYNONYM OPERATIONS_CAPACITY_REQR       FOR MPS_SAP.E01_OPERATIONS_CAPACITY_REQR   ;                                                              
CREATE SYNONYM OPERATIONS_SCHEDULING          FOR MPS_SAP.E01_OPERATIONS_SCHEDULING      ;                                                              
CREATE SYNONYM ORGANIZATIONS_DMN              FOR MPS_SAP.E01_ORGANIZATIONS_DMN          ;                                                              
CREATE SYNONYM PLANNED_PROD_ORDERS_V          FOR MPS_SAP.E01_PLANNED_PROD_ORDERS_V      ;                                                              
CREATE SYNONYM PRODUCTION_ORDERS              FOR MPS_SAP.E01_PRODUCTION_ORDERS          ;                                                              
CREATE SYNONYM PROD_ORDERS_HEADERS_V          FOR MPS_SAP.E01_PROD_ORDERS_HEADERS_V      ;                                                              
CREATE SYNONYM PROD_ORDERS_OPERATIONS_V       FOR MPS_SAP.E01_PROD_ORDERS_OPERATIONS_V   ;                                                              
CREATE SYNONYM PROD_ORDER_DPNT_REQ_V          FOR MPS_SAP.E01_PROD_ORDER_DPNT_REQ_V      ;                                                              
CREATE SYNONYM PROD_PLANNING_VERSIONS_V       FOR MPS_SAP.E01_PROD_PLANNING_VERSIONS_V   ;                                                              
CREATE SYNONYM ROUTING_OPERATIONS_V           FOR MPS_SAP.E01_ROUTING_OPERATIONS_V       ;                                                              
CREATE SYNONYM SOURCE_LISTS                   FOR MPS_SAP.E01_SOURCE_LISTS               ;                                                              
CREATE SYNONYM VENDORS                        FOR MPS_SAP.E01_VENDORS                    ;                                                              
CREATE SYNONYM VENDORS_DMN                    FOR MPS_SAP.E01_VENDORS_DMN                ;                                                              
CREATE SYNONYM WORK_CENTERS_HEIR_TREE         FOR MPS_SAP.E01_WORK_CENTERS_HEIR_TREE     ;                                                              
CREATE SYNONYM WORK_CENTER_CAPACITIES_V       FOR MPS_SAP.E01_WORK_CENTER_CAPACITIES_V   ;                                                              
CREATE SYNONYM WORK_CENTER_HEADERS_V          FOR MPS_SAP.E01_WORK_CENTER_HEADERS_V      ;                                                              

32 rows selected.

