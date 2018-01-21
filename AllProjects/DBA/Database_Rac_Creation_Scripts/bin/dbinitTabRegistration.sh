#! /bin/ksh

. $(dirname $0)/../bin/setEnv

echo "##################Executing dbinitTabRegistration.sh #########################"

set -x

### Registering to dbstart ###
cp $INSTALLER_HOME/init_d/dbstart $ORACLE_HOME/bin
chown oracle:oinstall $ORACLE_HOME/bin/dbstart
chmod 755 $ORACLE_HOME/bin/dbstart
rcp -p $ORACLE_HOME/bin/dbstart  $REMOTEHOST:$ORACLE_HOME/bin
#############################

### Registering racconfiginfo ###
mkdir -p /var/opt/oracle
cp $INSTALLER_HOME/init_d/srvConfig.loc /var/opt/oracle
chown oracle:oinstall /var/opt/oracle/srvConfig.loc
chmod 755 /var/opt/oracle/srvConfig.loc
rcp -p /var/opt/oracle/srvConfig.loc  $REMOTEHOST:/var/opt/oracle
#############################

### Registering dbora to init.d ###
cp $INSTALLER_HOME/init_d/dbora /etc/init.d
ln -s /etc/init.d/dbora /etc/rc0.d/K10dbora
ln -s /etc/init.d/dbora /etc/rc3.d/S99dbora
rcp /etc/init.d/dbora $REMOTEHOST:/etc/init.d
rsh $REMOTEHOST -l root ln -s /etc/init.d/dbora /etc/rc0.d/K10dbora
rsh $REMOTEHOST -l root ln -s /etc/init.d/dbora /etc/rc3.d/S99dbora
#############################


### Registering Volume for RAC configfile ###
##vxassist  -g racdg  make db_rac_srvcfg1 100M layout=log
##vxedit -g racdg set user=oracle group=dba db_rac_srvcfg1

VXSTAT=`vxdctl -c mode |/bin/awk '{print $6}'`
if [ "$VXSTAT" = "MASTER" ];
then
	vxassist  -g racdg  make db_rac_srvcfg1 100M layout=log
	vxedit -g racdg set user=oracle group=dba db_rac_srvcfg1
    	exit 0
else
    VXSTAT2=`rsh $EMOTEHOST vxdctl -c mode |/bin/awk '{print $6}'`
    if [ "$VXSTAT2" != "MASTER" ];
    then
        exit 1
    else
	vxassist  -g racdg  make db_rac_srvcfg1 100M layout=log
        vxedit -g racdg set user=oracle group=dba db_rac_srvcfg1
        exit 0
    fi
fi

su - oracle -c "gsdctl stop"
su - oracle -c "rsh $REMOTEHOST /opt/db01/app/oracle/product/9.2.0/bin/gsdctl stop"
su - oracle -c "srvconfig -init"

su - oracle -c "gsdctl start"
su - oracle -c "rsh $REMOTEHOST /opt/db01/app/oracle/product/9.2.0/bin/gsdctl start"
###################################################

set +x

echo "##################Exiting dbinitTabRegistration.sh #########################"
