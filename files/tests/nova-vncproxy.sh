#!/bin/bash
set -e
/usr/lib/nagios/plugins/check_http -H localhost -p 6080 -u /vnc_auto.html
