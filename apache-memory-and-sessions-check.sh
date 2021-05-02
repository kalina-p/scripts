#!/bin/bash
# apache2 httpd httpd-prefork
# created by Kalina
# Simple script to check memoru usage and connections
BDIR=/tmp
DIR=httpd
SDIR=sessions
TDIR=top

mkdir -p $BDIR/$DIR/$SDIR
mkdir -p $BDIR/$DIR/$TDIR
 
while true; do
FNAME=$(date +%H_%M_%S)
CONNECTIONS=`ss -ant | grep -E ':80|:443' | wc -l`
top -n 1 -b  >/tmp/httpd/top/top_"$FNAME".txt &
 
echo "ilosc polaczen: $CONNECTIONS"  >>/tmp/httpd/sessions/sessions_"$FNAME".txt  &
ps -ylC httpd-prefork | awk '{x += $8;y += 1} END {print "Apache Memory Usage (MB): "x/1024; print "Average Process Size (MB): "x/((y-1)*1024)}' >> /tmp/kalina/sessions/sessions_"$FNAME".txt  &
 
sleep 10
done
