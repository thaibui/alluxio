#!/bin/bash
set -e
if [ ! -d "/opt/alluxio" ]; then
    git clone -b branch-1.5 https://github.com/thaibui/alluxio.git /opt/alluxio
fi
cd /opt/alluxio
git pull
mvn -e clean package -DskipTests -Phive -Dcheckstyle.skip=true -Dlicense.skip=true
