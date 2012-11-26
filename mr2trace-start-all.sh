#!/bin/bash
#=======================================================================================
# Description: Main script to start Hadoop across entire cluster.
#=======================================================================================

source mr2trace-config.sh

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
