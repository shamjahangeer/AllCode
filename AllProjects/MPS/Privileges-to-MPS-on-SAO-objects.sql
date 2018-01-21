-- ==========================================================================================================

-- 08/23/2011

-- SAO

GRANT SELECT ON                                    SOM_DATA_STREAMS TO MPS_SOURCE;

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES    ON SOM_EXTRACT_AUDIT TO MPS_SOURCE;

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES    ON SOM_EXTRACT_DATA TO MPS_SOURCE;

GRANT SELECT,INSERT,UPDATE,DELETE,REFERENCES    ON SOM_DB_ERROR_LOG  TO MPS_SOURCE;

GRANT SELECT                                    ON SOM_QUERIES  TO MPS_SOURCE;

-- ==========================================================================================================

-- SAO_SOURCE

GRANT EXECUTE ON DB_ERROR_LOGGER TO MPS;

GRANT EXECUTE ON DB_ERROR_LOGGER TO MPS_SOURCE;

GRANT EXECUTE ON PKG_GEN_QUERY   TO MPS_SOURCE;
