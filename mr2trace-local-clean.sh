#!/bin/bash
#=======================================================================================
# Description: Ensure that Hadoop environment variables are set correctly and then
#              wipe out local installation of hadoop. 
#=======================================================================================

echo -n `hostname`": "

if [ -z $HADOOP_CONTAINER_LOGS ] || [ -z $MR2_LOCAL_BASE ] ||
    [ -z $HADOOP_HOME ] || [ -z $HADOOP_CONF_DIR ]; then
    echo "Hadoop environment variable(s) not-set, cannot continue."
    exit 1
fi

rm -rf $MR2_LOCAL_BASE/hadoop-tmp/* 
rm -rf $HADOOP_CONTAINER_LOGS 
rm -rf $HADOOP_HOME 
rm -rf $HADOOP_SERVICE_LOGS/* 
rm -rf $HADOOP_CONF_DIR

mkdir -p $MR2_LOCAL_BASE/hadoop-tmp
mkdir -p $HADOOP_CONTAINER_LOGS 
mkdir -p $HADOOP_HOME
echo "Cleaned hdfs"
