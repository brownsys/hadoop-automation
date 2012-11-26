#!/bin/bash
#=======================================================================================
# Description: Start the master Hadoop processes on the nodes defined in the config.
#=======================================================================================

source mr2trace-config.sh

echo "Starting masters on $MASTER1 and $MASTER2"

ssh $MASTER2 "mr2-srv start resourcemanager" &> /dev/null

# If hadoop-tmp is empty we need to format it
fscontents=`ls $MR2_LOCAL_BASE/hadoop-tmp/ | wc -l`
if [ $fscontents == 0 ]; then
    ssh $MASTER1 "hdfs namenode -format"
   #ssh $MASTER1 "hadoop namenode -format" #&> /dev/null
    if [ $? == 1 ]; then
        echo "Namenode wasn't formatted correctly, exiting"
        exit 1
    fi
    echo "HDFS formatted correctly"
fi

ssh $MASTER1 "mr2-srv start namenode; mr2-srv start historyserver" &> /dev/null

# Check to see if hdfs is working okay.
ssh $MASTER1 "hdfs dfs -ls /" &> /dev/null
if [ $? == 1 ]; then
    echo "HDFS is not responding, exiting!"
    exit 1
fi

echo "Waiting for steady state..."
sleep 8
