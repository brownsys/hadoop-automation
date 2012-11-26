#!/bin/bash
#=======================================================================================
# Description: Main script to start Hadoop across entire cluster.
#=======================================================================================

source mr2trace-config.sh

error=`pusher $PUSHER_ALL "command -v mr2-srv >/dev/null 2>&1 || { echo >&2 'I require foo but it is not installed.  Aborting.'; exit 1; }"`
if [ "$error" ]; then 
    echo "One or more machines do not have mr2-srv in their path, exiting:"
    echo $error | sed 's/ing. /ing.\n/g'
    exit 1
fi

# Stopping all services across cluster
./mr2trace-stop-all.sh

# Install a new clean copy of mr2 across all nodes in euc
./mr2trace-push-install.sh clean

# Start up master nodes
./mr2trace-start-masters.sh
if [ $? == 1 ]; then
    echo "Failed to start masters."
    exit 1
fi

# Start up slave nodes
./mr2trace-start-slaves.sh

# Are all nodes accounted for?
sleep 10
./mr2trace-all-nodes-okay.sh
