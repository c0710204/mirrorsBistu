#!/bin/bash
[[ $UID == 0 ]] || { echo "Must be root to run this script."; exit 0; }
LOCK="/data/sync_sh/lock"
LOG="/data/sync_sh/log"
 
while true; do
echo -e "\nstart sync @ `date`" | tee -a $LOG
 
if [ -f $LOCK ]; then
 echo "another sync is running, I exiting..." | tee -a $LOG
 exit 1
fi
touch $LOCK
 
st=`date +%s`
rsync --timeout=120 --exclude=".~tmp~" -avP --delete-excluded --progress rsync://archive.ubuntu.com/ubuntu/pool/ /data/mirrors/ubuntu/pool/
res=$?
if [ $res -eq 0 ]; then
 echo "rsync pool succ" | tee -a $LOG
 et=`date +%s`
 echo "pool sync use $(( $et-$st )) sec = $(( ($et-$st)/60 )):$(( ($et-$st)%60 ))" | tee -a $LOG
else
 echo "rsync pool failed" $res | tee -a $LOG
fi
 
st=`date +%s`
rsync --timeout=120 --exclude=".~tmp~" -avP --delete-excluded --progress rsync://archive.ubuntu.com/ubuntu/ /data/mirrors/ubuntu/
res=$?
if [ $res -eq 0 ]; then
        echo "rsync all succ" | tee -a $LOG
        et=`date +%s`
        echo "all sync use $(( $et-$st )) sec = $(( ($et-$st)/60 )):$(( ($et-$st)%60 ))" | tee -a $LOG
else
        echo "rsync all failed" $res | tee -a $LOG
fi
 
df | grep "/data" | tee -a $LOG
echo -e "end sync @ `date`" | tee -a $LOG
 
rm $LOCK
 
sleep 7200
done
