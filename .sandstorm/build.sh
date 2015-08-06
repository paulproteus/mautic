#!/bin/bash
# Checks if there's a composer.json, and if so, installs/runs composer.

set -euo pipefail

cd /opt/app

if [ -f /opt/app/composer.json ] ; then
    if [ ! -f composer.phar ] ; then
        curl -sS https://getcomposer.org/installer | php
    fi
    php composer.phar install
fi

PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_CACHE_DIR="/opt/app/app/cache/prod"
# Make sure the parent directory exists
mkdir -p $(dirname "$PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_CACHE_DIR")
# If the thing doesn't exist, make it a symlink to /var/mautic-cache
#
# We actually create /var/mautic-cache in launcher.sh.
#
# ! -h means "is not a symbolic link".
if [ ! -h "$PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_CACHE_DIR" ] ; then
    ln -s /var/mautic-cache "$PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_CACHE_DIR"
fi

PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_LOG_DIR="/opt/app/app/logs"
if [ ! -h "$PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_LOG_DIR" ] ; then
    ln -s /var/mautic-log "$PLACE_IN_MAUTIC_REPO_WHERE_IT_EXPECTS_LOG_DIR"
fi
