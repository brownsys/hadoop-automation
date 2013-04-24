#!/bin/bash
#=======================================================================================
# Description: Install Hadoop across an entire cluster. This also generates new config
#              files based on the MASTER values set in mr2trace-config.sh
#=======================================================================================

source mr2trace-config.sh

if [ ! -d "$MR2_SOURCE" ]; then
    echo "Fatal error, path does not exist:"
    echo "$MR2_SOURCE:" $MR2_SOURCE
    exit 1
fi

echo -n "Customizing and replacing config files..."
# Create config files based on mr2trace-config values
rm -rf "$MR2_CONFIG_SOURCE"
cp -r "$MR2_CONFIG_BASE" "$MR2_CONFIG_SOURCE"
HADOOP_NM_TEMP="$MR2_LOCAL_BASE/hadoop-tmp"
CORE_SITE=$MR2_CONFIG_SOURCE/core-site.xml
MAPRED_SITE=$MR2_CONFIG_SOURCE/mapred-site.xml
YARN_SITE=$MR2_CONFIG_SOURCE/yarn-site.xml
sed -i s@"EUC_HADOOP_TMP_DIR"@"$HADOOP_NM_TEMP"@g "$CORE_SITE"
sed -i s/"EUC_NAMENODE"/"$MASTER1"/g "$CORE_SITE"
sed -i s/"EUC_JOBHISTORY"/"$MASTER1"/g "$MAPRED_SITE"
sed -i s/"EUC_HADOOP_RESOURCEMANAGER"/"$MASTER2"/g "$YARN_SITE"
sed -i s@"EUC_HADOOP_NM_LOGS"@"$HADOOP_CONTAINER_LOGS"@g "$YARN_SITE"
sed -i s@"EUC_HADOOP_NM_DIR"@"$HADOOP_NM_TEMP/nm-local-dir"@g "$YARN_SITE"
echo "[ DONE ]"

echo "Clear existing, copy fresh, and configure mr2 install"
if [ -n "$1" ] && [ "clean" == "$1" ]; then
    echo "Cleaning/installing"
    pusher $PUSHER_ALL "bash $MR2TRACE_HOME/mr2trace-local-install.sh clean"
else
    echo "Installing"
    pusher $PUSHER_ALL "bash $MR2TRACE_HOME/mr2trace-local-install.sh"
fi
