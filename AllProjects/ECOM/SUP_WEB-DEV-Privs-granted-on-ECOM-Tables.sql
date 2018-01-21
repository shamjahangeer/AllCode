GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON ABC                            TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON APPCODES                       TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON APPCODES_OLD                   TO SUP_WEB;
GRANT SELECT                                     ON APPLICATIONS_SEQ_NUM           TO SUP_WEB;
GRANT SELECT                                     ON APPLICATION_SEQ_NUM            TO SUP_WEB;
GRANT SELECT                                     ON APPL_INDUSTRY                  TO SUP_WEB;
GRANT SELECT                                     ON APPL_OTHER_CATEGORIES          TO SUP_WEB;
GRANT SELECT                                     ON APPL_PRODUCT_CATEGORIES        TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON BATCH_JOBS                     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON BRANDS                         TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CARRIER_ID                     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CARRIER_TRACKING               TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CATALOG_COUNTRY                TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CATALOG_LANGUAGE               TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CHAINED_ROWS                   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, SELECT ON CORPORATE_PARTS                TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CORPORATE_PARTS_STG            TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, SELECT ON CORPORATE_PART_ALIASES         TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CORPORATE_PART_ALIASES_STG     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CORPORATE_PART_CNTRL_REC_STG   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CORPORATE_PART_TRANS_EXCPT_LOG TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CORPORATE_PART_TRANS_LOG       TO SUP_WEB;
GRANT SELECT                                     ON CORPORATE_PART_TRAN_ID_SEQ     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CURRENCY_FORMAT                TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON CUSTOMER_AUTHS_MOVED_TO_PBD    TO SUP_WEB;
GRANT SELECT                                     ON DIST_REGIONS                   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON ECOM_SERVERS_AND_SITES         TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON EMPLOYEES                      TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON EMPLOYEE_SHIP_TO_ADDRESS       TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON FAQ_ANSWERS                    TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON FAQ_QUESTIONS                  TO SUP_WEB;
GRANT INSERT, SELECT, UPDATE                     ON FSE_SEARCH_LOG                 TO SUP_WEB;
GRANT SELECT                                     ON FSE_SEARCH_SEQ                 TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON GBL_ACC_ORG                    TO SUP_WEB;
GRANT SELECT                                     ON GBL_ALL_TERRITORY_ASSIGNMENTS  TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON GBL_CURRENCY_TYPE              TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON GBL_STATE                      TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON GOAL_TYPES                     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON IMC_PRICES_MOVED_TO_PBD        TO SUP_WEB;
GRANT SELECT                                     ON INDUSTRIES                     TO SUP_WEB;
GRANT SELECT                                     ON INDUSTRY                       TO SUP_WEB;
GRANT SELECT                                     ON ISD_REQUESTS_SEQ               TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON LOCATION_CONTACTS              TO SUP_WEB;
GRANT SELECT                                     ON LOCATION_ORG                   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MESSAGE                        TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MESSAGE_ID_XREF                TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MESSAGE_TRNSLN                 TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MESSAGE_XREF_EXTEN             TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MIL_SPEC_CROSS_REFERENCE       TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON MISSING_BRANDS                 TO SUP_WEB;
GRANT SELECT                                     ON NL_OTHER_CATEGORIES            TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON NSN_CROSS_REFERENCE            TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON OIN_OPEN_ORDER_REQUEST         TO SUP_WEB;
GRANT SELECT                                     ON OIN_SEQ                        TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PART_NUMBER_CROSS_REFERENCE    TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PART_TYPES                     TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PERSON_TABLE                   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PLAN_TABLE                     TO SUP_WEB;
GRANT SELECT                                     ON PRODUCT_CATEGORIES             TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PROJECT_STATUS_CODES           TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PROJECT_SUB_TYPE               TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON PROJECT_TYPE_TABLE             TO SUP_WEB;
GRANT SELECT                                     ON REQUEST_DETAILS_SEQ            TO SUP_WEB;
GRANT SELECT                                     ON REQUEST_HEADERS_SEQ            TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON SHIP_TO_NO_SUFX_LOCS           TO SUP_WEB;
GRANT SELECT                                     ON SMI_DISTRIBUTOR_CONTACTS       TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON SQL_BUF                        TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON STG_GBL_ALL_TERRITORY_ASSIGN   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON STG_MIL_SPEC_CROSS_REFERENCE   TO SUP_WEB;
GRANT DELETE, INSERT, SELECT, UPDATE             ON SUPPLIER_LOC_TED_SOURCES       TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON TEMP_BRAND_CROSS_REF           TO SUP_WEB;
GRANT DELETE, INSERT, SELECT, UPDATE             ON TEMP_LDAP_CUST                 TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON TEMP_LOAD_PNXREF               TO SUP_WEB;
GRANT DELETE, INSERT, SELECT, UPDATE             ON TEMP_SELF_REG_CUST             TO SUP_WEB;
GRANT DELETE, INSERT, SELECT, UPDATE             ON TEMP_SELF_REG_CUST_REP         TO SUP_WEB;
GRANT SELECT                                     ON VEW_ACCT_ORG_ID_ISO_CTRY_CDE   TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON WORDS                          TO SUP_WEB;
GRANT DELETE, INSERT, REFERENCES, SELECT, UPDATE ON XREF_FORM_SUBMISSION           TO SUP_WEB;
