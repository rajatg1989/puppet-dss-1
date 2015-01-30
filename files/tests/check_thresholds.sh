#!/bin/bash

# mv notification file to a new location and process the current
# list of notificates since the last time that we ran.
# The mv command has been selected as it is assumed that it
# can be used atomically
new_file=/tmp/collectd_notifications.log-`date +%Y%m%d%H%M%S`
FILE="/usr/lib/jiocloud/metrics/collectd_notifications.log"
sudo mv $FILE $new_file || exit 1
python /usr/lib/jiocloud/metrics/check_thresholds.py $new_file
