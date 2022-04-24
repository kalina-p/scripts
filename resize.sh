!/bin/bash


# Author Kalina
# resize disk - please run "resize.sh /var"

for rs in $(ls /sys/class/block/sd*/device/rescan);do echo "1" > $rs;done && for                                                                                                                                rh in $(ls /sys/class/scsi_host/);do echo '- - -' > /sys/class/scsi_host/$rh/sc                                                                                                                               an ;done
 
#echo "Enter how many GB you want to add"
#echo
#read SIZE
echo
echo
############################################# End of user vars area ############                                                                                                                               #########
 
if [[ $1 =~ (/|/root|/boot|/dev|/shm)$ ]]
then
 
  echo " Bad path. Exit"
 
elif [[ -n $1 ]]
  then
 
  echo "Enter how many GB you want to add"
  echo
  read RESIZE
 
  VAR2=`df -Th | grep $1 | awk {'print$2'}`
 
  VAR3=`df -h | grep $1 | awk {'print$1'}`
 
  DISK=`lvdisplay --maps $VAR3 | grep "Physical volume" | awk {'print$3'}`
 
  SIZE=`df -h | grep $1 | awk {'print$2'}`
 
  DISK1=`lvdisplay --maps $VAR3 | grep "Physical volume" | awk {'print$3'} | sed                                                                                                                                's/\/dev\///g' | xargs`
 
  SCSI=`for c in $DISK1; do ls -d /sys/block/sd*/device/scsi_device/* |awk -F '[                                                                                                                               /]' '{print $4,"- SCSI",$7}' | grep $c; done`
 
############################################ START RESIZE ######################                                                                                                                               #########
  #echo "Selected mountpoint $1"
  echo "Filesystem path is: $VAR3"
  echo "Physical disk is:"   $DISK
  echo "Type is:            $VAR2"
  echo "Disk $1 have now $SIZE"
  echo "SCSI controller:"
  #echo "Disk i $1 will be expanded by $RESIZE GB"
  echo "$SCSI"
  echo
  echo "---------------------------"
 
  read -r -p "Are you sure? [y/N] " response
   if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
      pvresize $DISK > /dev/null 2>&1
 
      read -r -p "Disk $1 have now $SIZE and  will be expanded by $RESIZE GB select [y] Or, you can extend the disk with all the available space. Then select [n]
      " choice
        if [[ "$choice" =~ ^([yY][eE][sS]|[yY])$ ]]
         then
           lvextend -L +$RESIZE'G' $VAR3 > /dev/null 2>&1
         else
           lvextend -l +100%FREE $VAR3 > /dev/null 2>&1
         fi
         if [[ "$VAR2" =~ ^(ext1|ext2|ext3|ext4)$ ]]; then
           resize2fs $VAR3 > /dev/null 2>&1
 
         elif [ "$VAR2" == "xfs" ] ; then
           xfs_growfs -d $1 > /dev/null 2>&1
         else
           echo "unknow Type $VAR2"
         fi
 
      SIZE=`df -h | grep $1 | awk {'print$2'}`
      echo "SIZE AFTER RESIZE $SIZE"
      echo
     else
      echo "EXIT"
     fi
else
    echo "--- Empty path ---"
    echo
    echo "Exit"
fi
