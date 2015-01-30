#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check cassandra status
------------------------
  This script check cassandra status

__EOH__
       ;;
   esac
fi
echo "show host" | cqlsh ; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Cassandra is working fine"
  exit 0
else
  echo "CRITICAL: Cassandra is down"
  exit 2
fi
