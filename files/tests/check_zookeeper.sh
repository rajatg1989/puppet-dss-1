#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check zookeeper status
------------------------
  This script check zookeeper status

__EOH__
       ;;
   esac
fi

sudo /usr/share/zookeeper/bin/zkServer.sh status &> /dev/null; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Zookeeper is working fine"
  exit 0
else
  echo "CRITICAL: Zookeeper is down"
  exit 2
fi
