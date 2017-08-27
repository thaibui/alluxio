#!/usr/bin/env bash
#
# Pre-installation script that ensures the required user and group are created.
#

set -o errexit

function ensure_user_and_group_exist {
    local user=$1
    local group=$2

    grep -i "^${group}:" /etc/group > /dev/null || groupadd --system ${group} || fail "Unable to create deployment group: '${group}'."
    id ${user} > /dev/null 2>&1 || useradd --system ${user} --create-home -g ${group} || fail "Unable to create deployment user account: '${user}'."
}

ensure_user_and_group_exist alluxio alluxio
