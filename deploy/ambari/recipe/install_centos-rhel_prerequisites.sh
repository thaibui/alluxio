#!/bin/bash
set -e

# Assumtions
# 1. Java & Java Open JDK are already installed
# 2. Python and easy_install is installed

# Install Maven
if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: maven is not installed. Installing it ...' >&2
  MAVEN_VERSION=3.5.3
  aws s3 cp s3://bdap-private-artifacts/maven/apache-maven-$MAVEN_VERSION-bin.tar.gz /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz
  tar -xzvf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt
  export PATH=/opt/apache-maven-$MAVEN_VERSION/bin:$PATH
fi

# Install supervisord for easy ambari process management
easy_install supervisor
# Configure, require root access
export PATH=/usr/local/bin:$PATH
echo_supervisord_conf > /etc/supervisord.conf
