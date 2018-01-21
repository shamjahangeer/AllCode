#! /bin/ksh

. $(dirname $0)/../bin/setEnv

echo "########################### Executing oracle_rac_patch_install.sh ###############################"

set -x

su - oracle -c "$DISK_LAUNCH_STAGING/Disk1/install/solaris/runInstaller -responseFile  $INSTALLER_HOME/response_files/rac920patch_1.rsp -silent > /tmp/dbpatchinstall.log"

set +x

echo "########################### Exiting oracle_rac_patch_install.sh  ###############################"


