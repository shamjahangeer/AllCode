#!/usr/bin/sh
#
# RAW Volume Creation
#

Usage()
{
   echo "" >&2
   echo "Usage:  RAWVolCreation.sh <SI_DBNAME> <SM_DBNAME> <BILLING_DB> <CUR_NODE> <OTHER_NODE>" >&2
   echo "" >&2
   echo "          <SI_DBNAME> - SI Database Name" >&2
   echo "          <SM_DBNAME> - SM database Name" >&2
   echo "" >&2
   exit 1
}

#
# check usage
#
if [ $# != "5" ];then
  Usage;exit 1
fi

SI_DBNAME=$1; export SI_DBNAME
SM_DBNAME=$2; export SM_DBNAME
BA_DBNAME=$3; export BA_DBNAME
CUR_NODE=$4; export CUR_NODE
OTHER_NODE=$5; export OTHER_NODE

LOGDIR=/tmp; export LOGDIR
LOGFILE=${LOGDIR}/RAWVolumeCreation.log; export LOGFILE

echo ""
echo "RAW Volume Creation"
echo "Log will be written to ${LOGFILE}"
echo ""

### log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - RAW Volume Creation at `date` ****"
echo "Command:  $0 $1 $2 "
echo ""

cp si_makevols_for_racdg.txt si_makevols_for_racdg.txt.orig
cp si_makevols_for_racdg_2.txt si_makevols_for_racdg_2.txt.orig
cp sm_makevols_for_racdg.txt sm_makevols_for_racdg.txt.orig
cp sm_makevols_for_racdg_2.txt sm_makevols_for_racdg_2.txt.orig
cp sm2_makevols_for_racdg.txt sm2_makevols_for_racdg.txt.orig
cp sm2_makevols_for_racdg_2.txt sm2_makevols_for_racdg_2.txt.orig

sed 's/DBNAME/'${SI_DBNAME}'/g' si_makevols_for_racdg.txt > si_makevols_for_racdg.txt.tmp
sed 's/DBNAME/'${SI_DBNAME}'/g' si_makevols_for_racdg_2.txt > si_makevols_for_racdg_2.txt.tmp
sed 's/DBNAME/'${SM_DBNAME}'/g'  sm_makevols_for_racdg.txt > sm_makevols_for_racdg.txt.tmp
sed 's/DBNAME/'${SM_DBNAME}'/g'  sm_makevols_for_racdg_2.txt > sm_makevols_for_racdg_2.txt.tmp
sed 's/DBNAME/'${BA_DBNAME}'/g'  sm2_makevols_for_racdg.txt > sm2_makevols_for_racdg.txt.tmp
sed 's/DBNAME/'${BA_DBNAME}'/g'  sm2_makevols_for_racdg_2.txt > sm2_makevols_for_racdg_2.txt.tmp

mv si_makevols_for_racdg.txt.tmp si_makevols_for_racdg.txt
mv si_makevols_for_racdg_2.txt.tmp si_makevols_for_racdg_2.txt
mv sm_makevols_for_racdg.txt.tmp sm_makevols_for_racdg.txt
mv sm_makevols_for_racdg_2.txt.tmp sm_makevols_for_racdg_2.txt
mv sm2_makevols_for_racdg.txt.tmp sm2_makevols_for_racdg.txt
mv sm2_makevols_for_racdg_2.txt.tmp sm2_makevols_for_racdg_2.txt

rsh $OTHER_NODE mkdir /opt/db01/app/oracle/rawvol
rcp -p /opt/db01/app/oracle/rawvol/si_makevols_for_racdg.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rcp -p /opt/db01/app/oracle/rawvol/si_makevols_for_racdg_2.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rcp -p /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rcp -p /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg_2.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rcp -p /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rcp -p /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg_2.txt  $OTHER_NODE:/opt/db01/app/oracle/rawvol/
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/si_makevols_for_racdg.txt
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/si_makevols_for_racdg_2.txt
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg.txt
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg_2.txt
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg.txt
rsh $OTHER_NODE chmod +x /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg_2.txt

VXSTAT=`vxdctl -c mode |/bin/awk '{print $6}'`
if [ "$VXSTAT" = "MASTER" ]; 
then
    sh ./si_makevols_for_racdg.txt
    sh ./si_makevols_for_racdg_2.txt
    sh ./sm_makevols_for_racdg.txt
    sh ./sm_makevols_for_racdg_2.txt
    sh ./sm2_makevols_for_racdg.txt
    sh ./sm2_makevols_for_racdg_2.txt
    exit 0
else
    VXSTAT2=`rsh $OTHER_NODE vxdctl -c mode |/bin/awk '{print $6}'`
    if [ "$VXSTAT2" != "MASTER" ];
    then
       exit 1
    else
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/si_makevols_for_racdg.txt
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/si_makevols_for_racdg_2.txt
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg.txt
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/sm_makevols_for_racdg_2.txt
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg.txt
       rsh $OTHER_NODE /opt/db01/app/oracle/rawvol/sm2_makevols_for_racdg_2.txt
       exit 0
    fi
fi

rsh $OTHER_NODE rm -r /opt/db01/app/oracle/rawvol

EXITCODE=$?; export EXITCODE
if [ "$EXITCODE" -ne 0 ]
then
  echo "   "
  echo "**** Creating AW Volumeled failed at `date` !!! ****"
  echo ""
  exit 1
fi

echo "**** End - RAW volume Creation at `date` ****"
echo ""
