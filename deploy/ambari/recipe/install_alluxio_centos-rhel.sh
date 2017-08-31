#!/bin/bash
set -e
if [ ! -d "/opt/alluxio" ]; then
    git clone -b branch-1.5 https://github.com/thaibui/alluxio.git /opt/alluxio
fi
cd /opt/alluxio
git pull
mvn -e clean package -DskipTests -Phadoop-2.7 -Phive -Dcheckstyle.skip=true -Dlicense.skip=true -Dfindbugs.skip=true -Dmaven.javadoc.skip=true

# link alluxio client runtime jar to hive-server2 and hive client auxlib directory

# get the current HDP version. assuming that there's only 1 version running, else it will break the automation
HDP_VERSION=`ls /usr/hdp/ | grep -v current`

mkdir -p /usr/hdp/$HDP_VERSION/hive-server2/auxlib
mkdir -p /usr/hdp/$HDP_VERSION/hive-server2-hive2/auxlib
ln -s /opt/alluxio/core/client/runtime/target/alluxio-core-client-runtime-1.5.1-SNAPSHOT-jar-with-dependencies.jar \
  /usr/hdp/$HDP_VERSION/hive-server2/auxlib/alluxio-core-client-runtime.jar
ln -s /opt/alluxio/core/client/runtime/target/alluxio-core-client-runtime-1.5.1-SNAPSHOT-jar-with-dependencies.jar \
  /usr/hdp/$HDP_VERSION/hive-server2-hive2/auxlib/alluxio-core-client-runtime.jar
