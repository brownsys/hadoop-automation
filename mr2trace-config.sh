#!/bin/bash
#=======================================================================================
# Description: Configuration file for environmental variables used across hadoop scripts
#              for install, execution, tracing, etc.
#=======================================================================================

MR2TRACE_HOME="$HOME/nfs/mr2trace"
VERSION="hadoop-2.0.2-alpha"
HADOOP_COMMON="brownsys-hadoop"

MR2_CONFIG_SOURCE="$MR2TRACE_HOME/conf-deploy"
MR2_CONFIG_BASE="$MR2TRACE_HOME/conf-base"

MR2_SOURCE="$MR2TRACE_HOME/$VERSION/$HADOOP_COMMON/hadoop-dist/target/$VERSION"
CLUSTER_FILE="$MR2TRACE_HOME/cluster-nodes.txt"
SLAVES_FILE="$MR2TRACE_HOME/slaves"

PUSHER_BASE_ARGS="--ssh-options=-q"
PUSHER_ALL="$PUSHER_BASE_ARGS --show-host --hosts=$CLUSTER_FILE"
PUSHER_SLAVES="$PUSHER_BASE_ARGS --show-host --hosts=$SLAVES_FILE"

MASTER1="euc-nat.euc.smn.cs.brown.edu" #NameNode, JobHistoryServer
MASTER2="eucboss" #ResourceManager
TOTAL_NODES=`cat $SLAVES_FILE | wc -l`

