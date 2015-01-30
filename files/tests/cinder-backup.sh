#!/bin/bash
set -e
if [ -f /root/openrc ]; then
  source /root/openrc
  cinder backup-list
  sudo cinder-manage service list | grep "cinder-backup.*$(hostname).*enabled.*:-)"
else
  echo "Critical: Openrc doesn't exist"
  exit 2
fi
