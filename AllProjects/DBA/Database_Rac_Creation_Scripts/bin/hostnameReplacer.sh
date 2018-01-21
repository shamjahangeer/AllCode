#! /bin/ksh

. $(dirname $0)/../bin/setEnv

cd $INSTALLER_HOME/response_files
echo "##################Executing hostnameReplacer.sh#########################"

set -x

sed 's/\^NODE1\^/'${HOSTNAME}'/g' $INSTALLER_HOME/response_files/rac920_full_1.rsp > $INSTALLER_HOME/response_files/rac920_full_1.rsp.temp
chmod 777 *.*
sed 's/\^NODE2\^/'${REMOTEHOST}'/g' $INSTALLER_HOME/response_files/rac920_full_1.rsp.temp > $INSTALLER_HOME/response_files/rac920_full_1.rsp.temp1
cp -f  $INSTALLER_HOME/response_files/rac920_full_1.rsp.temp1 $INSTALLER_HOME/response_files/rac920_full_1.rsp
chmod 777 *.*

sed 's/\^NODE1\^/'${HOSTNAME}'/g' $INSTALLER_HOME/response_files/rac920patch_1.rsp > $INSTALLER_HOME/response_files/rac920patch_1.rsp.temp
chmod 777 *.*
sed 's/\^NODE2\^/'${REMOTEHOST}'/g' $INSTALLER_HOME/response_files/rac920patch_1.rsp.temp > $INSTALLER_HOME/response_files/rac920patch_1.rsp.temp1
cp -f  $INSTALLER_HOME/response_files/rac920patch_1.rsp.temp1 $INSTALLER_HOME/response_files/rac920patch_1.rsp
chmod 777 *.*

set +x

echo "##################Exiting hostnameReplacer.sh#########################"
