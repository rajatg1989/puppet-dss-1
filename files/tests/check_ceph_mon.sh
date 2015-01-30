#!/bin/bash

if [ $# -gt 0 ]; then
  case $1 in
    -h|--help|help)
      cat << __EOH__
$0 - To check ceph mon status
------------------------
  This script check ceph mon status

__EOH__
       ;;
   esac
fi
sudo ceph --admin-daemon /var/run/ceph/ceph-mon.$(hostname).asok  mon_status | grep -Eq '"state": "(leader|peon)"'; rv=$?
if [ $rv -eq 0 ]; then
  echo "OK: Ceph mon is working fine"
  exit 0
else
  echo "CRITICAL: Ceph Mon is down"
  exit 2
fi
