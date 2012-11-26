#!/bin/bash
#======================================================================================= 
# Description: Check to see that all master and slaves nodes are alive.
#======================================================================================= 

source mr2trace-config.sh

if [ `ssh $MASTER1 "jps" | egrep "NameNode|JobHistoryServer" | wc -l` == 2 ]; then
    if [ `ssh $MASTER2 "jps" | grep "ResourceManager" | wc -l` == 1 ]; then
	echo "Master-nodes are live!"
    else
	echo "Master startup failed on $MASTER2:"
	ssh $MASTER2 "jps"
	exit 1
    fi
else 
    echo "Master startup failed on $MASTER1:" 
    ssh $MASTER1 "jps"
    exit 1
fi

num=`lynx -dump $MASTER1:50070/dfshealth.jsp | grep "Live Nodes" | awk '{print $4}'`
if [ "$num" != "$TOTAL_NODES" ]; then
    echo "Only $num nodes are live, this should be $TOTAL_NODES"
    exit 1
else
    echo "All slave-nodes are live!"
fi
