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

echo "Customizing and replacing config files..."
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

# Combine config files and binaries locally before deploy
TMP_HADOOP_DIST="/tmp/hadoop-install"
rm -rf $TMP_HADOOP_DIST
cp -r $MR2_SOURCE $TMP_HADOOP_DIST
cp $MR2_CONFIG_SOURCE/* $TMP_HADOOP_DIST/etc/hadoop/

echo "Cleaning/installing"    
for node in `cat $CLUSTER_FILE`; do
    ssh $node "bash -s" < mr2trace-local-clean.sh
    if [ $? != 0 ]; then echo "local clean error on $node"; exit 1; fi
    #rsync -at "$TMP_HADOOP_DIST" $node:"$MR2_LOCAL_BASE"
    scp -rq "$TMP_HADOOP_DIST" $node:"$MR2_LOCAL_BASE"
    if [ $? != 0 ]; then echo "scp error on $node"; exit 1; fi
    echo "$node done"
done
rm -rf $TMP_HADOOP_DIST