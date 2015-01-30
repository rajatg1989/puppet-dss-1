#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check redis status
------------------------
  This script check redis status

__EOH__
       ;;
   esac
fi
redis-cli info | grep connected_clients &> /dev/null ; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Redis is working fine"
  exit 0
else
  echo "CRITICAL: Redis is down"
  exit 2
fi
