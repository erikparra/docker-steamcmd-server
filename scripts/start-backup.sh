#!/bin/bash
while true
do
        sleep ${BACKUP_INTERVAL}m
        cd ${SERVER_DIR}/Astro/Saved
        tar --warning=no-file-changed --exclude='./Config/CrashReportClient' -czf ${SERVER_DIR}/Backups/$(date '+%Y-%m-%d_%H.%M.%S').tar.gz ./SaveGames/ ./Config/
        cd ${SERVER_DIR}/Backups
        ls -1tr ${SERVER_DIR}/Backups | sort | head -n -${BACKUPS_TO_KEEP} | xargs -d '\n' rm -f --
        chmod -R ${DATA_PERM} ${SERVER_DIR}/Backups
done