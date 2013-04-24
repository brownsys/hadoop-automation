#!/bin/bash
#=======================================================================================
# Description: Ensure that Hadoop environment variables are set correctly and then
#              wipe out local installation of hadoop. Also if the first argument is 
#              'clean' this will cause HDFS to be wiped as well.
#=======================================================================================

source $HOME/nfs/hadoop-automation/mr2trace-config.sh

if [ -z $HADOOP_CONTAINER_LOGS ] | [ -z $MR2_LOCAL_BASE ] |
    [ -z $HADOOP_HOME ] | [ -z $MR2_SOURCE ] | 
    [ -z $HADOOP_CONF_DIR ] | [ -z $MR2_CONFIG_SOURCE ]; then
    echo "Hadoop environment variable not-set, cannot continue."
    exit 1
fi

if [ "clean" == "$1" ]; then
    echo "Cleaning hdfs!"
    rm -rf $MR2_LOCAL_BASE/hadoop-tmp/*
    mkdir -p $MR2_LOCAL_BASE/hadoop-tmp
else
    echo "No cleaning hdfs!"
fi

rm -rf "$HADOOP_CONTAINER_LOGS"
mkdir -p "$HADOOP_CONTAINER_LOGS"
mkdir -p "$HADOOP_HOME"
rm -rf "$HADOOP_HOME"
cp -R "$MR2_SOURCE" "$HADOOP_HOME"
rm -rf "$HADOOP_CONF_DIR/"
cp -R "$MR2_CONFIG_SOURCE" "$HADOOP_CONF_DIR"
