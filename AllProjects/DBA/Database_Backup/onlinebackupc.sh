#!/usr/bin/sh
#
# Online Complete backup of the database
#
#
# MODIFIED
#     kmothuku   07/11/02  -  CREATION
#

Usage()
{
   echo "" >&2
   echo "Usage:  onlinebackupc.sh <ORACLE_HOME> <ORACLE_SID> <BACKUP_DIR>" >&2
#   echo "Usage:  onlinebackupc.sh $ORACLE_HOME $ORACLE_SID /opt/db03/backup/online" >&2
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
LOGFILE=${LOGDIR}/onlinec.backup.${ORACLE_SID}.log; export LOGFILE

echo ""
echo "online complete database backup of ${ORACLE_SID}"
echo "Log will be written to ${LOGFILE}"
echo ""

# log file

exec >>${LOGFILE}
exec 2>&1

echo ""
echo "**** Start - Online Complete database backup of ${ORACLE_SID} at `date` ****"
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
  SET TRIMSPOOL ON LINESIZE 350 PAGESIZE 0
  SET FEEDBACK OFF
  SPOOL ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp
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
  SPOOL OFF
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  cat ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


# get list of files to backup 

echo "Getting names of files to backup ..."

sqlplus -S /nolog <<EOF
  WHENEVER SQLERROR EXIT 1
  CONN / AS SYSDBA
  SET TAB OFF
  SET TRIMSPOOL ON LINESIZE 350 PAGESIZE 0
  SET FEEDBACK OFF
  SPOOL ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1
  SELECT RTRIM(d.tablespace_name) || ',' ||
         RTRIM(d.file_name) || ',' ||
         TO_CHAR(v.block_size) || ',' ||
         TO_CHAR(v.blocks) || ','
    FROM sys.dba_data_files d, v\$datafile v
   WHERE d.file_id = v.file#
     AND d.status = 'AVAILABLE'
   ORDER BY tablespace_name;
  SPOOL OFF
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  cat ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1
  echo ""
  echo "**** Backup ABORTED at `date` !!! ****"
  echo ""
  exit 1
fi


echo "ORACLE_HOME,${ORACLE_HOME},0,0," > ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp
echo "ORACLE_SID,${ORACLE_SID},0,0," >> ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp
echo "BACKUP_DIR,${BACKUP_DIR},0,0," >> ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp
cat ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1 >> ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp


# prepare SQL*Plus command script executing backup

echo "Preparing command script ..."

awk 'BEGIN { prev_tbs = ""                       # no tablespace processed yet
             home = ""                           # no ORACLE home directory
             sid = ""                            # no ORACLE instance name
             target = ""                         # no target directory
             num = 1                             # start number for files
           }
           { FS = ",[ \t]*|[ \t]+" }             # input fields separated by comma and/or blanks and tabs
           { tablespace = $1                     # extract tablespace and file
             filename = $2                       #   name from SQL*Plus output
             blocksize = $3                      #   data block size
             blocks = $4                         #   data file offset blocks
             if (tablespace == "ORACLE_HOME")         # if at the begining of files
             {
                home = filename
             }
             else
             {
                if (tablespace == "ORACLE_SID")         # if at the begining of files
                {
                   sid = filename
                }
                else
                {
                   if (tablespace == "BACKUP_DIR")         # if at the begining of files
                   {
                      target = filename
                   }
                   else
                   {
                      if (prev_tbs != tablespace)         # if at the begining of files
                      {                                   #   of next tablespace:
                        if (length(prev_tbs) > 0)         # end backup of previous tbsp
                           print "ALTER TABLESPACE " prev_tbs " END BACKUP;"
                           print ""
                        print "ALTER TABLESPACE " tablespace " BEGIN BACKUP;"
                      }
                      print "!cp " filename " " target "/`basename " filename "`." num
#                      print "!dd if=" filename " of=" target "/`basename " filename "`." num " bs=" blocksize " count=" blocks " skip=1 seek=1"
                      prev_tbs=tablespace
                      num = num + 1
                   }
                }
             }
           }
     END   { if (length(prev_tbs) > 0)           # end backup of last tabspace
                print "ALTER TABLESPACE " prev_tbs " END BACKUP;"
             print ""
           }
    ' ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp \
      >${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1

# do backup 

echo "Copying files ..."

sqlplus -S /NOLOG <<EOF
  WHENEVER SQLERROR EXIT 1
  WHENEVER OSERROR EXIT 1
  SET ECHO ON
  CONN / AS SYSDBA
  START ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1
  ALTER SYSTEM SWITCH LOGFILE;
  ARCHIVE LOG STOP;
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


# backup archive log files, control file and init file

LOG_ARCHIVE_DEST_1=`grep "LOG_ARCHIVE_DEST_1_TAG" ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}' | awk '{print $1}'`; export LOG_ARCHIVE_DEST_1
LOG_ARCHIVE_DEST_2=`grep "LOG_ARCHIVE_DEST_2_TAG" ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}' | awk '{print $1}'`; export LOG_ARCHIVE_DEST_2
FILES1=`ls ${LOG_ARCHIVE_DEST_1}`; export FILES1
FILES2=`ls ${LOG_ARCHIVE_DEST_2}`; export FILES2

sqlplus -S /NOLOG <<EOF
  WHENEVER SQLERROR EXIT 1
  WHENEVER OSERROR EXIT 1
  SET ECHO ON
  CONN / AS SYSDBA
  ARCHIVE LOG START;
  ALTER DATABASE BACKUP CONTROLFILE TO TRACE;
  EXIT 0
EOF

EXITCODE=$?
export EXITCODE

if [ "$EXITCODE" -ne 0 ]
then
  echo "ERROR: SQL*Plus exit code: $EXITCODE"
  echo ""
  echo "**** Backup ABORTED for archive log files, control file at `date` !!! ****"
  echo ""
  exit 1
fi

LOG_ARCHIVE_DEST_STATE_1=`grep "LOG_ARCHIVE_DEST_STATE_1" ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export LOG_ARCHIVE_DEST_STATE_1
if [ "${LOG_ARCHIVE_DEST_STATE_1}" != "DEFER" ];then
{
  if [ -n "${LOG_ARCHIVE_DEST_1}" ];then
  {
    if [ -n "${FILES1}" ];then
    {
      echo ""
      echo "**** List of Archive Destination1 Log files ****"
      echo "${FILES1}"
      echo ""

      cd ${LOG_ARCHIVE_DEST_1}
      cp -p ${FILES1} ${BACKUP_DIR}
##      rm ${FILES1}
    }
    fi
  }
  fi
}
fi

LOG_ARCHIVE_DEST_STATE_2=`grep "LOG_ARCHIVE_DEST_STATE_2" ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export LOG_ARCHIVE_DEST_STATE_2
if [ "${LOG_ARCHIVE_DEST_STATE_2}" != "DEFER" ];then
{
  if [ -n "${LOG_ARCHIVE_DEST_2}" ];then
  {
    if [ -n "${FILES2}" ];then
    {
      echo ""
      echo "**** List of Archive Destination2 Log files ****"
      echo "${FILES2}"
      echo ""

      cd ${LOG_ARCHIVE_DEST_2}
      cp -p ${FILES2} ${BACKUP_DIR}
##      rm ${FILES2}
    }
    fi
  }
  fi
}
fi


USER_DUMP_DEST=`grep "USER_DUMP_DEST" ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp | awk '{ FS = ",[ \t]*|[ \t]+" } {print $2}'`; export USER_DUMP_DEST
cd ${USER_DUMP_DEST}
find `grep "CREATE CONTROLFILE" *.trc | awk -F: '{print $1}'` -type f -mtime -1 -exec cp -p {} ${BACKUP_DIR} \;
cp -p ${ORACLE_HOME}/dbs/spfile${ORACLE_SID}.ora ${BACKUP_DIR}

echo ""
echo "**** Backup finished at `date` ****"
echo ""

echo ""
echo "**** Copying temp and log files generated during backup of ${ORACLE_SID} at `date` ****"
echo ""

cp ${LOGFILE} ${BACKUP_DIR}
cp ${LOGDIR}/onlinec.backup.${ORACLE_SID}.param.tmp ${BACKUP_DIR}
cp ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp ${BACKUP_DIR}
cp ${LOGDIR}/onlinec.backup.${ORACLE_SID}.tmp1 ${BACKUP_DIR}

echo ""
echo "**** End - Online Complete database backup of ${ORACLE_SID} at `date` ****"
echo ""
