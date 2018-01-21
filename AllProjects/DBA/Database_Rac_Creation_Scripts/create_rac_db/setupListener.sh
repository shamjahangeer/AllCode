#! /bin/ksh

#BLOCK="$(<listener1_block.ora)"

BLOCK="kota \n albert"

sed 's/\^TAG\^/'${BLOCK}'/g' listener1.ora > /tmp/listener1.ora

