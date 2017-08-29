#!/bin/bash
set -e
if [ ! -d "/opt/alluxio" ]; then
    git clone -b branch-1.5 https://github.com/thaibui/alluxio.git /opt/alluxio
fi
cd /opt/alluxio
git pull
mvn -e clean package -DskipTests -Phadoop-2.7 -Phive -Dcheckstyle.skip=true -Dlicense.skip=true -Dfindbugs.skip=true -Dmaven.javadoc.skip=true
