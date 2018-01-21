if [ $# -ne 1 ]
then
   echo "Usage: $0 Please pass the parameter as full or migrate"
   exit 127
fi

cd /opt/cce/installers

latestBuild=`ls eams_rxx_*.bin | tail -1`
echo "latest Build ::  "$latestBuild


if [ $1 = "migrate" ] 
then
     echo "executing the build for migration installion"
     ./AutomationMigrationBuildInstall_vf.sh $latestBuild
fi

if [ $1 = "full" ]
then
cd /scripts/oracle/autobuildinstallscripts
source ./Oracle_Env_Files.sh
echo "inside the full build installartion"
$ORACLE_HOME/bin/sqlplus -s /nolog << EOF
connect $DB_USER/$DB_PASSWORD@$DATABASE AS SYSDBA

SET HEAD OFF
SET PAGESIZE 0
SET LINESIZE 120
SET ECHO OFF
SET VERIFY OFF
SET TERMOUT OFF
SET FEEDBACK OFF
SET TIMING OFF
SET TIME OFF
SET TRIMOUT ON
declare
v_count number;
begin
select count(1)
into v_count
from dba_users
where username in ('CIADMIN','CMADMIN','CIARCH','CMARCH');
dbms_output.put_line(v_count);
if v_count >0 then
--spool /tmp/DBSchemaVerification.lst
  @@eams_drop_users.sql
  @@eams_drop_ts.sql
  @@eams_create_ts.sql $DB_DATA_FILE
  @@eams_create_users.sql
end if;
end;

--spool off;
EOF
cd /opt/cce/installers/
echo "executing the build for full installation"
./AutomationFullBuildInstall_vf.sh $latestBuild 
fi

#./start_vf.sh $latestBuild
#echo "latest build is :"$latestBuild
echo "Hello Team,"> mailContent.txt
echo "   Following are the errors while installing migration build">>mailContent.txt
echo " ">>mailContent.txt
echo " ">>mailContent.txt
find /opt/cce/installers/logs/  -name "$latestBuild*.log" | xargs grep ORA-*  > oralog1.txt
cat oralog1.txt >> mailContent.txt
count=0
while read line
do
	count=$[count+1]	
       # echo "Count is : "$count
done < oralog1.txt
echo "count is ::"$count
echo " ">>mailContent.txt
echo " ">>mailContent.txt
echo "Kind Regards,">>mailContent.txt
echo "DB TEAM">>mailContent.txt
if [ $count > 0 ]
then
	echo "inside the mail condition "
	mail -s "ORA Error(Total Errors: "$count")"  tfk673@motorola.com  < mailContent.txt
fi

if [ $count =  0 ]
then
        mail -s "No error found" tfk673@motorola.com
fi

