#!/bin/bash
##
# For some reason check_http is not working where curl is working.
##
#/usr/lib/nagios/plugins/check_http -H localhost -p 8092 -u /  -r dns.xml
curl -f http://localhost:8092/ | grep -q dns.xml ; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: contrail-dns is working fine"
  exit 0
else
  echo "CRITICAL: contrail-dns is down"
  exit 2
fi

