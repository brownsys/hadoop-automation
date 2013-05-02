#!/bin/bash
#=======================================================================================
# Description: Start the master Hadoop processes on the nodes defined in the config.
#=======================================================================================

source mr2trace-config.sh

echo "Starting masters on $MASTER1 and $MASTER2"

ssh $MASTER2 "mr2-srv start resourcemanager" &> /dev/null

# If hadoop-tmp is empty we need to format it
fscontents=`ssh $MASTER1 'ls $MR2_LOCAL_BASE/hadoop-tmp/ | wc -l'`
if [ $fscontents == 0 ]; then
    ssh $MASTER1 "hdfs namenode -format"
    if [ $? == 1 ]; then
        echo "Namenode wasn't formatted correctly, exiting"
        exit 1
    fi
    echo "HDFS formatted correctly"
fi
sleep 2

ssh $MASTER1 "mr2-srv start namenode; mr2-srv start historyserver" &> /dev/null
if [ $? != 0 ]; then echo "namenode and/or history server failed to start"; exit 1; fi

sleep 5

# Check to see if hdfs is working okay.
output=`ssh $MASTER1 "hdfs dfs -ls /"`
if [ $? == 1 ]; then
    echo "HDFS is not responding, exiting!"
    echo "stdout:" $output
    exit 1
fi

echo "Waiting for steady state before starting slaves..."
sleep 8
