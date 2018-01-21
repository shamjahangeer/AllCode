orapwd file=/opt/db01/app/oracle/product/9.2.0/dbs/orapwSID1 password=change_on_install
dd if=/opt/db01/app/oracle/product/9.2.0/dbs/orapwSID1 of=/dev/vx/rdsk/racdg/db_SID_orapwd
rm /opt/db01/app/oracle/product/9.2.0/dbs/orapwSID1
ln -s /dev/vx/rdsk/racdg/db_SID_orapwd /opt/db01/app/oracle/product/9.2.0/dbs/orapwSID1
