#! /bin/ksh

. $(dirname $0)/../bin/setEnv

echo "##################Executing RAWVolCreationWrapper.sh #########################"

set -x

chmod -R 777 *
cd $INSTALLER_HOME/raw_vol
chmod -R 777 *

if [ $SUBSYSTEM = "SI" ]
then
	./si_RAWVolCreation.sh $DB_NAME $HOST1_IP $HOST2_IP
elif [ $SUBSYSTEM = "SM" ] && [ $SM_DB_TYPE = "Same" ]
then
	./sm_RAWVolCreation.sh $DB_NAME $HOST1_IP $HOST2_IP
elif [ $SUBSYSTEM = "SM" ] && [ $SM_DB_TYPE = "Separate" ]
then
	./sm_RAWVolCreation.sh $DB_NAME $HOST1_IP $HOST2_IP
	./sm2_RAWVolCreation.sh $BILLING_DB_NAME $HOST1_IP $HOST2_IP
fi

set +x

echo "##################Exiting RAWVolCreationWrapper.sh #########################"
