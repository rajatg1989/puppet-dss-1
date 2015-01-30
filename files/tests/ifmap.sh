#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check ifmap status
------------------------
  This script check ifmap status

__EOH__
       ;;
   esac
fi
/usr/bin/ifmap-view  localhost 8443 reader reader | grep "project = default-project"; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Ifmap is working fine"
  exit 0
else
  echo "CRITICAL: Ifmap is down"
  exit 2
fi
