echo "Creating diskstatus.log file, please wait..."

echo "DISKSTATUS INFORMATION" > diskstatus.log
echo " " >> diskstatus.log

dbcli describe-system >> diskstatus.log

echo "=========== [ DBSTORAGE INFO ] ===========" >> diskstatus.log
dbcli list-dbstorages >> diskstatus.log

echo " " >> diskstatus.log

for DBSTORAGE in $(dbcli list-dbstorages | tail -n +4 | cut -d " " -f1)
do
  dbcli describe-dbstorage -i $DBSTORAGE >> diskstatus.log
done

echo "=========== [ DISK INFO ] ===========" >> diskstatus.log
dbadmcli show disk >> diskstatus.log

echo " " >> diskstatus.log

for DISKGROUP in $(dbadmcli show diskgroup | tail -n +3 | cut -d " " -f1)
do
  dbadmcli show diskgroup $DISKGROUP >> diskstatus.log
  echo " " >> diskstatus.log
done

for DISK in $(dbadmcli show disk | tail -n +3 | cut -d " " -f1)
do
  echo "=========== [ DISK: $DISK ] ===========" >> diskstatus.log
  dbadmcli show disk $DISK >> diskstatus.log
  dbadmcli show disk $DISK -getlog >> diskstatus.log
done

echo "=========== [ Storage INFO ] ===========" >> diskstatus.log
dbadmcli show storage >> diskstatus.log

echo "=========== [ Storage ERRORS ] ===========" >> diskstatus.log
dbadmcli show storage -errors | tail -n 100 >> diskstatus.log
