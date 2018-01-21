# Configure Listener


# Start Listener after configuring for new database
lsnrctl start

### Restart the Database Instance
/opt/db01/app/oracle/product/9.2.0/bin/sqlplus /nolog <<EOF
connect SYS/change_on_install@SID1.DOMAIN_NAME as SYSDBA
shutdown ;
startup ;
disconnect
EOF

srvctl add database -d SID -o /opt/db01/app/oracle/product/9.2.0 
srvctl add instance -d SID -i SID1 -n NODE1NAME
srvctl add instance -d SID -i SID2 -n NODE2NAME
