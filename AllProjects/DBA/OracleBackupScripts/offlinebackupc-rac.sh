#!/usr/bin/sh
#
# Offline Complete backup of the RAC database
#
#
# MODIFIED
#     kmothuku   07/11/02  -  CREATION
#

Usage()
{
   echo "" >&2
   echo "Usage:  offlinebackupc-rac.sh <ORACLE_HOME> <ORACLE_SID> <BACKUP_DIR>" >&2
#   echo "Usage:  offlinebackupc-rac.sh $ORACLE_HOME $ORACLE_SID /global/cce_sm01n1if/oracle/db03/backup/offline" >&2
   echo "" >&2
   echo "          <ORACLE_HOME> - Oracle Home directory name" >&2
   echo "          <ORACLE_SID> - Oracle SID name to be backed-up" >&2
   echo "          <BACKUP_DIR> - Backup directory name" >&2
   echo "" >&2
   exit 1
}

#
# check usage
#
if [ $# != "3" ];then
  Usage;exit 1
fi


# set ORACLE environment
ORACLE_HOME=$1; export ORACLE_HOME
ORACLE_SID=$2; export ORACLE_SID
BACKUP_DIR=$3; export BACKUP_DIR

LOGDIR=/tmp; export LOGDIR
LOGFILE=${LOGDIR}/offlinec.backup.${ORACLE_SID}.log; export LOGFILE

echo ""
echo "offline complete database backup of ${ORACLE_SID}"
echo "Log will be written to ${LOGFILE}"
echo ""

# log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - Offline Complete database backup of ${ORACLE_SID} at `date` ****"
echo "Command:  $0 $1 $2 $3"
echo ""


# Check the access on backup directory

if [ ! -w "${BACKUP_DIR}" ]
then
  echo "ERROR: Target backup directory is not accesible"
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


# get the dirnames for archivelog, bdump, cdump and udump

echo "Getting dirnames of archivelog, bdump, cdump and udump ..."

sqlplus -S /nolog <<EOF
  WHENEVER SQLERROR EXIT 1
  CONN / AS SYSDBA
  SET TAB OFF
  SET TRIMSPOOL ON LINESIZE 150 PAGESIZE 0
  SET FEEDBACK OFF
  SPOOL ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp
  SELECT 'LOG_ARCHIVE_START,' || UPPER(RTRIM(value)) || ','
    FROM v\$parameter
   WHERE name = 'log_archive_start';
  SELECT 'LOG_ARCHIVE_DEST_STATE_1,' || UPPER(RTRIM(value)) || ','
    FROM v\$parameter
   WHERE name = 'log_archive_dest_state_1';
  SELECT 'LOG_ARCHIVE_DEST_STATE_2,' || UPPER(RTRIM(value)) || ','
    FROM v\$parameter
   WHERE name = 'log_archive_dest_state_2';
  SELECT 'LOG_ARCHIVE_DEST_1_TAG,' || SUBSTR(RTRIM(value), 10) || ','
    FROM v\$parameter
   WHERE name = 'log_archive_dest_1' AND value like 'LOCATION%';
  SELECT 'LOG_ARCHIVE_DEST_2_TAG,' || SUBSTR(RTRIM(value), 10) || ','
    FROM v\$parameter
   WHERE name = 'log_archive_dest_2' AND value like 'LOCATION%';
  SELECT 'BACKGROUND_DUMP_DEST,' || RTRIM(value) || ','
    FROM v\$parameter
   WHERE name = 'background_dump_dest';
  SELECT 'CORE_DUMP_DEST,' || RTRIM(value) || ','
    FROM v\$parameter
   WHERE name = 'core_dump_dest';
  SELECT 'USER_DUMP_DEST,' || RTRIM(value) || ','
    FROM v\$parameter
   WHERE name = 'user_dump_dest';
  SELECT 'ACTIVE_INSTANCES,' || COUNT(*) || ','
    FROM v\$active_instances;
  SPOOL OFF
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  cat ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


# checking for the active instances

ACTIVE_INSTANCES=`grep "ACTIVE_INSTANCES" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export ACTIVE_INSTANCES

if [ "${ACTIVE_INSTANCES}" -ne 1 ]
then
  echo ""
  echo "ACTIVE_INSTANCES=${ACTIVE_INSTANCES}"
  echo "ERROR: Other than the instance on the current node are running"
  echo "ACTION: Shutdown all the instances except the current instance on the node where offline backup will be taken for the database"
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


# get list of files to backup & prepare SQL*Plus command script executing backup

echo "Getting names of files to backup and Preparing command script ..."

sqlplus -S /nolog <<EOF
  WHENEVER SQLERROR EXIT 1
  CONN / AS SYSDBA
  SET TAB OFF
  SET TRIMSPOOL ON LINESIZE 200 PAGESIZE 0
  SET FEEDBACK OFF
  SPOOL ${LOGDIR}/offlinec.backup.${ORACLE_SID}.tmp1
-- copy data files
  SELECT '!dd if=' || RTRIM(name) || ' of=$BACKUP_DIR/\`basename ' || RTRIM(name) || '\` bs=' || block_size || ' count=' || blocks || ' skip=1 seek=1'
    FROM v\$datafile;
-- copy temp data files
  SELECT '!dd if=' || RTRIM(name) || ' of=$BACKUP_DIR/\`basename ' || RTRIM(name) || '\` bs=' || block_size || ' count=' || blocks || ' skip=1 seek=1'
    FROM v\$tempfile;
-- copy redo log files
  SELECT '!dd if=' || RTRIM(lf.member) || ' of=$BACKUP_DIR/\`basename ' || RTRIM(lf.member) || '\` bs=512 count=' || (l.bytes/512) || ' skip=1 seek=1'
    FROM v\$logfile lf, v\$log l
   WHERE lf.group# = l.group#;
-- copy control files
  SELECT '!dd if=' || RTRIM(name) || ' of=$BACKUP_DIR/\`basename ' || RTRIM(name) || '\`'
    FROM v\$controlfile;
  SPOOL OFF
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  cat ${LOGDIR}/offlinec.backup.${ORACLE_SID}.tmp1
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


# do backup 

echo "Copying files ..."

sqlplus -S /NOLOG <<EOF
  WHENEVER SQLERROR EXIT 1
  WHENEVER OSERROR EXIT 1
  SET ECHO ON
  CONN / AS SYSDBA
--
-- shutdown the database
--
  SHUTDOWN IMMEDIATE
  START ${LOGDIR}/offlinec.backup.${ORACLE_SID}.tmp1
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  echo ""
  echo "**** Backup ABORTED for data at `date` !!! ****"
  echo ""
  exit 1
fi


# backup archive log files

LOG_ARCHIVE_START=`grep "LOG_ARCHIVE_START" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export LOG_ARCHIVE_START
if [ "${LOG_ARCHIVE_START}" = "TRUE" ];then
{
  LOG_ARCHIVE_DEST_STATE_1=`grep "LOG_ARCHIVE_DEST_STATE_1" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export LOG_ARCHIVE_DEST_STATE_1
  if [ "${LOG_ARCHIVE_DEST_STATE_1}" != "DEFER" ];then
  {
    LOG_ARCHIVE_DEST_1=`grep "LOG_ARCHIVE_DEST_1_TAG" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}' | awk '{print $1}'`; export LOG_ARCHIVE_DEST_1
    if [ -n "${LOG_ARCHIVE_DEST_1}" ];then
    {
      FILES1=`ls ${LOG_ARCHIVE_DEST_1}`; export FILES1
      if [ -n "${FILES1}" ];then
      {
        echo ""
        echo "**** List of Archive Destination1 Log files ****"
        echo "${FILES1}"
        echo ""

        cd ${LOG_ARCHIVE_DEST_1}
        cp -p ${FILES1} ${BACKUP_DIR}
        rm ${FILES1}
      }
      fi
    }
    fi
  }
  fi

  LOG_ARCHIVE_DEST_STATE_2=`grep "LOG_ARCHIVE_DEST_STATE_2" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export LOG_ARCHIVE_DEST_STATE_2
  if [ "${LOG_ARCHIVE_DEST_STATE_2}" != "DEFER" ];then
  {
    LOG_ARCHIVE_DEST_2=`grep "LOG_ARCHIVE_DEST_2_TAG" ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}' | awk '{print $1}'`; export LOG_ARCHIVE_DEST_2
    if [ -n "${LOG_ARCHIVE_DEST_2}" ];then
    {
      FILES2=`ls ${LOG_ARCHIVE_DEST_2}`; export FILES2
      if [ -n "${FILES2}" ];then
      {
        echo ""
        echo "**** List of Archive Destination2 Log files ****"
        echo "${FILES2}"
        echo ""

        cd ${LOG_ARCHIVE_DEST_2}
        cp -p ${FILES2} ${BACKUP_DIR}
        rm ${FILES2}
      }
      fi
    }
    fi
  }
  fi
}
else
{
  echo ""
  echo "Database ${ORACLE_SID} is not ARCHIVELOG mode and hence no archive logs."
  echo ""
}
fi


# backup server parameter file
SPFILE=`awk -F= '{spfile = substr($2, 2, expr(length($2) - 2))} {print spfile}' ${ORACLE_HOME}/dbs/init${ORACLE_SID}.ora`; export SPFILE

echo ""
echo "**** Server parameter file ****"
echo "${SPFILE}"
echo ""

dd if=${SPFILE} of=${BACKUP_DIR}/`basename ${SPFILE}`

# backup password file
PWFILE=`ls -l ${ORACLE_HOME}/dbs/orapw${ORACLE_SID} | awk '{print $11}'`; export PWFILE

echo ""
echo "**** Password file ****"
echo "${PWFILE}"
echo ""

dd if=${PWFILE} of=${BACKUP_DIR}/`basename ${PWFILE}`


sqlplus -S /NOLOG <<EOF
  WHENEVER SQLERROR EXIT 1
  WHENEVER OSERROR EXIT 1
  CONN / AS SYSDBA
  SET ECHO ON
--
-- startup the database
--
  STARTUP
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  echo ""
  echo "**** Backup ABORTED for data at `date` !!! ****"
  echo ""
  exit 1
fi

echo ""
echo "**** Backup finished at `date` ****"
echo ""

echo ""
echo "**** Copying temp and log files generated during backup of ${ORACLE_SID} at `date` ****"
echo ""

cp ${LOGFILE} ${BACKUP_DIR}
cp ${LOGDIR}/offlinec.backup.${ORACLE_SID}.param.tmp ${BACKUP_DIR}
cp ${LOGDIR}/offlinec.backup.${ORACLE_SID}.tmp1 ${BACKUP_DIR}

echo ""
echo "**** End - Offline Complete database backup of ${ORACLE_SID} at `date` ****"
echo ""
