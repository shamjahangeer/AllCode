SELECT LPAD(' ',DECODE(l.xidusn,0,3,0)) || l.oracle_username "User Name",
o.owner, o.object_name, o.object_type,l.session_id
FROM v$locked_object l, dba_objects o
WHERE l.object_id = o.object_id
ORDER BY o.object_id, 1 desc

---------------------------------

SELECT  distinct LPAD(' ',DECODE(l.xidusn,0,3,0)) || l.oracle_username "User Name",
o.owner, o.object_name, o.object_type,l.session_id,locked_mode,type
FROM v$locked_object l, dba_objects o,v$lock vl
WHERE l.object_id = o.object_id
and vl.sid=l.session_id;

-------------------------



FOR FINDING THE LOCKED MODE DESCRIPTION

SELECT * FROM V$LOCK

0 - none
1 - null (NULL)
2 - row-S (SS)
3 - row-X (SX)
4 - share (S)
5 - S/Row-X (SSX)
6 - exclusive (X)


rowshare:--Allow concurrent access to a table for select but prohibits locking the table
rowexclusive:--Same as rowshare and prohibits locking in the share mode
share:--SHARE permits concurrent queries but prohibits updates to the locked table
exclusive:--EXCLUSIVE permits queries on the locked table but prohibits any other activity on it
sharerowexclusive:--SHARE ROW EXCLUSIVE is used to look at a whole table and to allow others to look at rows in the table but to prohibit
				  --others from locking the table in SHARE mode or from updating rows.

NOWAIT-- NOWAIT if you want the database to return control to you immediately if the specified table, partition, or table subpartition is already locked by another user. In this case, the database returns a message indicating that the table, partition, or subpartition is already locked by another user.
	   --If you omit this clause, then the database waits until the table is available, locks it, and returns control to you.

ex:

LOCK TABLE employees
   IN EXCLUSIVE MODE 
   NOWAIT;