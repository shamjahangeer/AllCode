#! /bin/ksh

echo "########################### Executing execRoot.sh ###############################"

. $(dirname $0)/../bin/setEnv

echo "Executing root.sh on the Local Node "
. $ORACLE_HOME/root.sh < $INSTALLER_HOME/response_files/execRoot.rsp

echo "Executing root.sh on the Remote Node "
rsh $REMOTEHOST -l root $ORACLE_HOME/root.sh < $INSTALLER_HOME/response_files/execRoot.rsp

echo "########################### Exiting execRoot.sh ###############################"


