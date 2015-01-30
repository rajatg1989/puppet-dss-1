#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check memcache status
------------------------
  This script check memcache status

__EOH__
       ;;
   esac
fi

echo stats | nc localhost 11211 | grep uptime; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Memcached is working fine"
  exit 0
else
  echo "CRITICAL: Memcached is down"
  exit 2
fi
