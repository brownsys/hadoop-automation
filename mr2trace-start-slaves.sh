#!/bin/bash
#=======================================================================================
# Description: Start slave services across all slave nodes.
#=======================================================================================

source mr2trace-config.sh

echo "Starting slaves"
pusher $PUSHER_SLAVES "mr2-srv start nodemanager; mr2-srv start datanode" > /dev/null


