cat listener.ora >> /oracle/ora9i/product/9iR2/network/admin/listener.ora
# Stop Listener before configuring for new database
lsnrctl stop

# Configure Listener

# Start Listener after configuring for new database
lsnrctl start

### Configure Tnsnames
cat tnsnames.ora >> /oracle/ora9i/product/9iR2/network/admin/tnsnames.ora

### Restart the Database Instance
/oracle/ora9i/product/9iR2/bin/sqlplus /nolog <<EOF
connect SYS/change_on_install as SYSDBA
shutdown ;
startup ;
disconnect
EOF
