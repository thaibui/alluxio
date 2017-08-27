#!/bin/bash
set -e

# Install Centos 6 prerequisites
source <(curl -s https://raw.githubusercontent.com/thaibui/alluxio/branch-1.5/deploy/ambari/recipe/install_centos-rhel_prerequisites.sh?$RANDOM)
