#! /bin/ksh

. $(dirname $0)/../bin/setEnv

echo "################## Executing oracle_rac_install.sh ######################"

set -x

su - oracle -c "$DISK_LAUNCH_STAGING/Disk1/install/solaris/runInstaller -responseFile  $INSTALLER_HOME/response_files/rac920_full_1.rsp -silent > /tmp/dbinstall.log"

set +x

echo "################## Exiting oracle_rac_install.sh ######################"
