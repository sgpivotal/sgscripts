#!/bin/bash

######################
#Require minimum amout of space in GB (Using an Intager)
export Space=10

# Sleep for X seconds between runnning Diags.
export sleeping='1'

# The number of times to run the Diag script.
export runs=3


export wdir=`pwd`
export cdd=`cd ..`


export diag='pcf-diag'

######################

export reqSpace=$(($Space * 1024 * 1024))


export LOG="diag-$(date +"%Y-%m-%d-%H-%M-%s")".log

if [[ ! -e $diag ]]; then
    mkdir $diag 
fi
cd $diag 

for i in {1..2}; do
export LOG="diag-$(date +"%Y-%m-%d-%H-%M-%s")"
mkdir -p $LOG 
cd $LOG

clear
echo "######## PCF DIAGS ########"
echo "######Collecting Logs######"
echo
echo "----- STARTING RUN $i -----"
date
echo
# Required Space in GB

#Available Space in GB
availSpace=$(df -k | awk 'NR==2 { print $4 }')

echo "Available space =$availSpace"
echo "Require free space =$reqSpace"
echo

if (( availSpace < reqSpace )); then
  echo "Not enough free space, exiting" >&2
  exit 1
else
echo "More than $reqSpace GB available, continuing...."

sleep 2
clear
fi


echo "PS -EF"
date &> ps-ef.log
ps -ef >> ps-ef.log

echo "LSOF"
date > lsof.log
lsof -n >> lsof.log

echo "Netstat"
date > netstat.log
netstat -ant >> netstat.log

echo "DF"
date > df.log
df -h >> df.log

#echo "FREE"
#date > free.log
#free -h >> free.log

#echo "PSTREE"
#date > pstree.log
#pstree -pan >> pstree.log

clear

# cd back to base dir
cd $wdir/$diag

echo "----- END OF RUN $i -----"
echo

$cdd
pwd

date
echo
echo "Sleeping for $sleeping seconds before the next run"

sleep $sleeping

done

$cdd
echo "Taring $wdir/$diag/"
tar -cvzf $wdir/$diag.tar.gz $wdir/$diag/;

echo "########################"
echo "Finished gathering logs"
echo "########################"

exit




