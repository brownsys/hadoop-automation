#!/bin/bash
#=======================================================================================
# Description: Stop all Hadoop services across cluster, also verify that they have
#              actually been shutdown.
#=======================================================================================

source $HOME/nfs/hadoop-automation/mr2trace-config.sh

# Stop slave services
pusher $PUSHER_SLAVES "mr2-srv stop datanode; mr2-srv stop nodemanager" > /dev/null

# Stop master services
ssh $MASTER1 "mr2-srv stop namenode; mr2-srv stop resourcemanager; mr2-srv stop historyserver" > /dev/null
ssh $MASTER2 "mr2-srv stop namenode; mr2-srv stop resourcemanager; mr2-srv stop historyserver" > /dev/null

procs=`pusher $PUSHER_ALL "jps" | egrep -v "Jps|XTraceServer" | wc -l`
if [ $procs == "0" ]; then
    echo "All processes stopped okay"
else
    echo "Did not stop all services, $procs still running!"
    pusher $PUSHER_ALL "jps" | egrep -v "Jps|XTraceServer"
    exit 1
fi