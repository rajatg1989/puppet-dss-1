#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check rabbitmq status
------------------------
  This script check rabbitmq status

__EOH__
       ;;
   esac
fi

sudo rabbitmqctl status | grep -q running_applications; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Rabbitmq is working fine"
  exit 0
else
  echo "CRITICAL: Rabbitmq is down"
  exit 2
fi
