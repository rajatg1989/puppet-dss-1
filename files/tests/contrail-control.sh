#!/bin/bash
##
# For some reason check_http is not working where curl is working.
##
#/usr/lib/nagios/plugins/check_http -H localhost -p 8083 -u /  -r control_node.xml
curl -f http://localhost:8083/ | grep -q control_node.xml ; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Contrail-control is working fine"
  exit 0
else
  echo "CRITICAL: Contrail-control is down"
  exit 2
fi

