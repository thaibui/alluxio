#!/usr/bin/env bash

set -o errexit

cp /opt/alluxio/deploy/ambari/recipe/alluxio-masterd /etc/init.d/
cp /opt/alluxio/deploy/ambari/recipe/alluxio-workerd /etc/init.d/
cp /opt/alluxio/deploy/ambari/recipe/alluxio-proxyd /etc/init.d/

chkconfig --add alluxio-masterd
chkconfig --add alluxio-workerd
chkconfig --add alluxio-proxyd

# Add log dir
mkdir -p /var/log/alluxio
chown -R alluxio:alluxio /var/log/alluxio

# Add directory for pidfile
mkdir -p /var/run/alluxio
chown -R alluxio:alluxio /var/run/alluxio

# Add alluxio permissions to alluxio working directory
chown -R alluxio:alluxio /opt/alluxio

# Format journal local directory
sudo -u alluxio ./bin/alluxio format -s
