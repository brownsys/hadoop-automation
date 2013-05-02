#!/bin/bash
#=======================================================================================
# Description: Configuration file for environmental variables used across hadoop scripts
#              for install, execution, tracing, etc.
#=======================================================================================

MR2TRACE_HOME="$HOME/nfs/hadoop-automation"
VERSION="hadoop-2.0.4-alpha"
HADOOP_GIT_NAME="brownsys-hadoop"

# Path to pre-built version of hadoop binaries
MR2_SOURCE="$MR2TRACE_HOME/$VERSION/$HADOOP_GIT_NAME/hadoop-dist/target/$VERSION"

MR2_CONFIG_SOURCE="$MR2TRACE_HOME/conf-deploy"
MR2_CONFIG_BASE="$MR2TRACE_HOME/conf-base"

CLUSTER_FILE="$MR2TRACE_HOME/cluster-nodes.txt"
SLAVES_FILE="$MR2TRACE_HOME/slaves"

PUSHER_BASE_ARGS="--ssh-options=-q"
PUSHER_ALL="$PUSHER_BASE_ARGS --show-host --hosts=$CLUSTER_FILE"
PUSHER_SLAVES="$PUSHER_BASE_ARGS --show-host --hosts=$SLAVES_FILE"

MASTER1="euc04" #NameNode, JobHistoryServer
MASTER2="euc05" #ResourceManager
TOTAL_NODES=`cat $SLAVES_FILE | wc -l`

