#!/bin/bash
set -e
if [ -f /root/openrc ]; then
  source /root/openrc
  cinder list
else
  echo "Critical: Openrc doesn't exist"
  exit 2
fi
