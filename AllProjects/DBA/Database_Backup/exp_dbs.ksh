#!/bin/ksh

set -x
/usr2/opt/oracle_daily_backups/bin/exp_db.sh eams
/usr2/opt/oracle_daily_backups/bin/exp_db.sh wpsdb
/usr2/opt/oracle_daily_backups/bin/exp_db.sh eamsdemo
/usr2/opt/oracle_daily_backups/bin/exp_db.sh wpsdbqa
/usr2/opt/oracle_daily_backups/bin/exp_db.sh eamstest
/usr2/opt/oracle_daily_backups/bin/exp_db.sh eamsivt
/usr2/opt/oracle_daily_backups/bin/exp_db.sh cvrqadb1
/usr2/opt/oracle_daily_backups/bin/exp_db.sh wpsdb01

/usr2/opt/oracle_daily_backups/bin/purge_dir.ksh