#!/bin/bash
#
# Setting the Oracle Environment for the database server
#
#
# 
# Gururaj   01/Jan/2011  -  CREATION
#
# set ORACLE environment

ORACLE_HOME=/opt/db02/app/oracle/product/11.1.0/db_1; export ORACLE_HOME
export PATH=$ORACLE_HOME/bin:$PATH:
ORACLE_SID=ivt191;export ORACLE_SID
DUMP_DIR=/opt/db02/app/oracle/product/11.1.0/db_1/bin; export DUMP_DIR
LOG_DIR=/opt/db02/app/oracle/product/11.1.0/db_1/bin; export LOG_DIR
THISDATE=`date '+%Y%m%d'`;export THISDATE
export USER=exp_user 
export PWD=exp_user
ulimit unlimited

