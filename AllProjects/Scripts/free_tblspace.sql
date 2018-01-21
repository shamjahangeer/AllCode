-- This script lists the tablespaces and quotas for a given Schema

SET PAGES 25 LINES 200

SELECT tablespace_name, SUM(us) "Used Space(MB)", SUM(fs) "Free Space(MB)", SUM(us) + SUM(fs) "Total Space(MB)"
FROM   ( SELECT tablespace_name, SUM(bytes)/1024/1024 fs, 0 us
         FROM   user_free_space
         GROUP BY tablespace_name
         UNION ALL
         SELECT tablespace_name, 0 fs, SUM(bytes)/1024/1024 us
         FROM   user_segments
         GROUP BY tablespace_name )
GROUP BY tablespace_name
ORDER BY tablespace_name;
