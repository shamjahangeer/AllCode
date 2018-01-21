#! /bin/ksh

. $(dirname $0)/../bin/setEnv

echo "##################Executing RACDBCreation.sh  #########################"

set -x

chmod -R 777 *
cd $INSTALLER_HOME/create_rac_db
chmod -R 777 *

if [ $SUBSYSTEM = "SI" ]
then
        su - oracle -c "cd $INSTALLER_HOME/create_rac_db;$INSTALLER_HOME/create_rac_db/dbcreate-rac.sh  $SUBSYSTEM $DB_NA
ME $DOMAIN_NAME $HOSTNAME $REMOTEHOST $LISTENER1_IP $LISTENER2_IP $HOST2_IP"
elif [ $SUBSYSTEM = "SM" ] && [ $SM_DB_TYPE = "Same" ]
then
        su - oracle -c "cd $INSTALLER_HOME/create_rac_db;$INSTALLER_HOME/create_rac_db/dbcreate-rac.sh  $SUBSYSTEM $DB_NA
ME $DOMAIN_NAME $HOSTNAME $REMOTEHOST $LISTENER1_IP $LISTENER2_IP $HOST2_IP"
elif [ $SUBSYSTEM = "SM" ] && [ $SM_DB_TYPE = "Separate" ]
then
        cp -rp $INSTALLER_HOME/create_rac_db $INSTALLER_HOME/create_rac_db1
        su - oracle -c "cd $INSTALLER_HOME/create_rac_db;$INSTALLER_HOME/create_rac_db/dbcreate-rac.sh  $SUBSYSTEM $DB_NA
ME $DOMAIN_NAME $HOSTNAME $REMOTEHOST $LISTENER1_IP $LISTENER2_IP $HOST2_IP"
BILL_SUBSYSTEM="Billing"
        su - oracle -c "cd $INSTALLER_HOME/create_rac_db1;$INSTALLER_HOME/create_rac_db1/dbcreate-rac.sh  $BILL_SUBSYSTEM
 $BILLING_DB_NAME $DOMAIN_NAME $HOSTNAME $REMOTEHOST $LISTENER1_IP $LISTENER2_IP $HOST2_IP"

fi

set +x

echo "##################Exiting RACDBCreation.sh #########################"
