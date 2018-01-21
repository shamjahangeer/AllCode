--******************************************************

--Author: Gururaja Rao Y.
--Date:17Mar2011
--Usage:CCE_UTILITY_PRC(1,0,'SCHEMANAME') --Renaming Oracle Objects
--Usage:CCE_UTILITY_PRC(0,1,'SCHEMANAME') --Dropping Oracle Objects

--******************************************************
--spool /tmp/CCEUTILITY.lst;
spool c:\cceutility.lst;
set serverout on
set termout off;
set feedback off;
set linesize 3000;


BEGIN
CCE_UTILITY_PRC(0,1,'CIADMIN');
END;
/
SPOOL OFF;
