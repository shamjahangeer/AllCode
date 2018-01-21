#!/usr/bin/ksh

WORK_DIR=/home/xdpr38/util
LAST_CHECKED=$WORK_DIR/sne_last_checked
LAST_TESTED=$WORK_DIR/sne_last_tested
NEW_SCRIPTS=$WORK_DIR/new_sne_files.log
SCRIPT_TAR_FILE=$WORK_DIR/new_sne_files.tar

if [[ ! -a "${LAST_TESTED}" ]] then 
   LAST_TESTED_SCRIPT=sne_rxx_$(date "+%y%m%d")_00_All.bin 
else
   LAST_TESTED_SCRIPT=`cat $LAST_TESTED`
fi

integer i=1
while ((i <= 9));
do 
  NEXT_SCRIPT=sne_rxx_$(date "+%y%m%d")_0${i}_All.bin 

  if [[ $NEXT_SCRIPT > $LAST_TESTED_SCRIPT ]] then
     FOUND_NEXT_SCRIPT="1"
     break
  fi  

  (( i = i + 1));
done

if [[ $FOUND_NEXT_SCRIPT = "1" ]] then
   SCRIPT_FILE=$NEXT_SCRIPT

   if [[ -a "/relarea/installers/${SCRIPT_FILE}" ]] then 
      sleep 120
      scp /relarea/installers/$SCRIPT_FILE cceadmin@nj14-mlpar57:/appl/cce/installer_test
      echo $SCRIPT_FILE > $LAST_TESTED
      ssh cceadmin@nj14-mlpar57 '/appl/cce/installer_test/sne_installer_test.sh'
   else
      echo "Installation script /relarea/installers/${SCRIPT_FILE} not available."

      #
      # Check the SNE DB code changes
      #

      if [[ ! -a "${LAST_CHECKED}" ]] then
         LAST_VERIFIED=$0
      else
         LAST_VERIFIED=$LAST_CHECKED
      fi  

      cd /vobs/cce_base/common/src/db/dbschema/
      find ./sne* -type f -newer $LAST_VERIFIED > $NEW_SCRIPTS

      touch $LAST_CHECKED

      if [[ -s /home/xdpr38/util/new_sne_files.log ]] then
         tar -cvf $SCRIPT_TAR_FILE `cat $NEW_SCRIPTS` 
         scp $SCRIPT_TAR_FILE cceadmin@nj14-mlpar57:/appl/cce/installer_test 
         ssh cceadmin@nj14-mlpar57 '/appl/cce/installer_test/validate_new_sne_changes.sh > /appl/cce/installer_test/validate_new_sne_changes.log 2>&1; /appl/cce/installer_test/validate_new_sne_changes_notification.sh /appl/cce/installer_test/validate_new_sne_changes.log'
      else
         SUBJECT="No new changes delivered in the SNE DB source codes"
         echo $SUBJECT
         # mailx -s "$SUBJECT" xdpr38@motorola.com < $NEW_SCRIPTS
      fi
   fi   
fi

