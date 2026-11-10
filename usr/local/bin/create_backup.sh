#!/bin/sh

set -e

FILENAME=/mnt/sda1/backups/backup-${HOSTNAME}-$(date +%Y%m%d-%H%M%S).tar.gz
LINK_LATEST=/mnt/sda1/backup_latest.tar.gz

mkdir -p $(dirname "${FILENAME}")
mkdir -p $(dirname "${LINK_LATEST}")

/sbin/sysupgrade -k -u -v -b ${FILENAME}

[[ -L ${LINK_LATEST} ]] && rm ${LINK_LATEST}
ln -s ${FILENAME} ${LINK_LATEST}

exit 0

