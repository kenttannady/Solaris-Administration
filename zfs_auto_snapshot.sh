#!/bin/bash
# /opt/scripts/zfs_auto_snapshot.sh
THRESHOLD=80
POOL="apppool"
LOG="/var/log/zfs_auto_snapshot.log"

check_usage() {
    USAGE=$(zfs list -o used,avail -Hp $POOL | awk '{print $1/($1+$2)*100}')
    echo $USAGE
}

while true; do
    USAGE=$(check_usage)
    if (( $(echo "$USAGE > $THRESHOLD" | bc -l) )); then
        TIMESTAMP=$(date +%Y%m%d_%H%M)
        zfs snapshot $POOL/appdata@auto_$TIMESTAMP
        echo "[$(date)] Created snapshot auto_$TIMESTAMP (Usage: ${USAGE}%)" >> $LOG
    fi
    sleep 3600  # Check hourly
done
