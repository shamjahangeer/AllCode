-- solar_gdwp2

-- MPS

SELECT 'GRANT SELECT ON '||RPAD(table_name, 30, ' ')||' TO SAO_READ;'
FROM   user_tab_privs
WHERE  owner = USER
AND    grantee = 'SAO_SOURCE'
AND    privilege = 'SELECT'
ORDER BY 1;

SELECT 'GRANT SELECT ON '||RPAD(table_name, 30, ' ')||' TO SAO_READ;'
FROM   user_tab_privs
WHERE  owner = USER
AND    grantee = 'SAO_SOURCE'
AND    privilege = 'SELECT'
ORDER BY 1;

-- Scorpion@gdwv2

-- MPS

SELECT 'GRANT SELECT ON '||RPAD(table_name, 30, ' ')||' TO SAO_READ;'
FROM   user_tab_privs
WHERE  owner = USER
AND    grantee = 'SAO_SOURCE'
AND    privilege = 'SELECT'
AND    table_name NOT IN ( 'MPS_FO_RECPT_DETAIL_BAK0722'
                         , 'MPS_FO_RECPT_HEADER_BAK0722'
                         , 'MPS_RECPT_HIST_0721_BAK'
                         , 'MPS_RECPT_HIST_0725'
                         , 'MPS_RECPT_HIST_0809_BAK' )
ORDER BY 1;

-- MPS_SAP

SELECT 'GRANT SELECT ON '||RPAD(table_name, 30, ' ')||' TO SAO_READ;'
FROM   user_tab_privs
WHERE  owner = USER
AND    grantee = 'SAO_SOURCE'
AND    privilege = 'SELECT'
ORDER BY 1;

