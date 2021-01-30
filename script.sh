#!/bin/bash
# author Pawel Kalinowski


set -eu

echo "enter runtime period in minutes"
read PTIME
echo "enter sleep while time in seconds"
read STIME
DATE=`date +%y_%m_%d_%H-%M`
LOG="log_$DATE.txt"
VALUE1="Zaloguj się do My F-Secure"

run="$PTIME minute"
endtime=$(date -ud "$run" +%s)

basic_log() {
        echo $1
}

log() {
        basic_log "$1" | tee -a $LOG
}
while [[ $(date -u +%s) -le $endtime ]]
do
for c in `cat list.txt`; do 

      VALUE2=` curl -s $c | grep -o "Zaloguj się do My F-Secure" | uniq`
      CHECKC=`curl -s -o /dev/null -w "%{http_code}"  $c  | cut -c 1`
   if [ "$CHECKC" == 2 ] || [ "$CHECKC" == 3 ]
      then
        if [ "$VALUE1" == "$VALUE2" ]
          then
	    log "---------------------------------------------------------------------------"
            log  "URL $c" 
	    log  "STATUS OK"
	    log  " RESPONSE TIME  `curl -o /dev/null -s -w ' %{time_connect}s\n' $c`"; 
	    log  "`date`"
          else
	    log "---------------------------------------------------------------------------"
	    log "URL $c"
	    log "STATUS CRITICAL"
	    log "NOT CONTAIN VALUE $VALUE2"
            log "RESPONSE TIME `curl -o /dev/null -s -w ' %{time_connect}s\n' $c`";
	    log  "`date`"
	fi
        else
	    log "---------------------------------------------------------------------------"
	    log "URL $c"
            log "STATUS UNKNOWN" 
	    log "$c PAGE NOT FOUND OR NOT EXIST !"
	    log "RESPONSE TIME `curl -o /dev/null -s -w ' %{time_connect}s\n' $c`";
	    log  "`date`"
    fi
done
   sleep $STIME
done
log "DONE at `date`"

