#!/bin/ash
set -e

/root/google-cloud-sdk/bin/gcloud auth activate-service-account --key-file $GCLOUD_KEY_FILE

echo "$CRONTAB_TIME /root/insert.sh" >> /etc/crontabs/root
crond -f
