#!/bin/bash
set -e
######################
#This script gathers the following log
#ps -ef
#lsof -n
#netstat -ant
#df -h
#free -h
#pstree -pan
# It runs 10 times and sleeps for 600 seconds between runs. 
# These logs are then saved to a file called diag.tar.gz

######################

# Sleep for X seconds between runnning Diags.
export sleeping='600'


# Save output to folder pcf-diag
export diag='pcf-diag'

export dateformat='%Y-%m-%d-%H-%M-%s'

######################

export wdir=`pwd`
export cdd=`cd ..`

export LOG="diag-$(date +"$dateformat")".log

if [[ ! -e $diag ]]; then
    mkdir $diag 
fi
cd $diag 

# Number of time to run the script 10
for i in {1..10}; do
export LOG="diag-$(date +"$dateformat")"
mkdir -p $LOG 
cd $LOG

clear
echo "######## PCF DIAGS ########"
echo "######Collecting Logs######"
echo
echo "----- STARTING RUN $i -----"
date
echo


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

echo "FREE"
date > free.log
free -h >> free.log

echo "PSTREE"
date > pstree.log
pstree -pan >> pstree.log

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




