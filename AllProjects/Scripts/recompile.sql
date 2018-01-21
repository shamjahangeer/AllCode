-- Generates a list of invalid objects and compile statement

SET PAGES 50 TIMING ON

SELECT DISTINCT 'ALTER '||RPAD(DECODE(object_type, 'PACKAGE BODY', 'PACKAGE', object_type), 17, ' ') ||' '||RPAD(object_name, 30, ' ')||' COMPILE;'  "To Re-compile"
FROM   user_objects
WHERE  object_name NOT LIKE 'BIN%'
AND    status = 'INVALID'
ORDER BY 1
/

