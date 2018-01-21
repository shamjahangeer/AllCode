if [ $# -ne 1 ]
then
   echo "Usage: $0 <Config parameter path like /opt/cce/configParam.txt>"
   exit 127
fi
while read line
   do

     #get the Provider , ContentPath and SpoolPath from each line
      echo $line
      find /vobs/eams_cce_bpm/Videoflow/Operation  -type f | xargs grep "$line" >> /opt/cce/searchres.txt

    done <$1

