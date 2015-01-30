#!/bin/bash

while getopts ':t:h' opt
do
    case $opt in
      t)
          etcd_discovery_token=$OPTARG
          ;;
      h)
          echo "Usage: $0 [-t TOKEN] [-h]"
          echo ""
          echo " -t TOKEN  Use TOKEN as token for etcd discovery service"
          echo " -h        Show this help screen"
          echo ""
          exit 0
          ;;
      *)
          echo Unknown argument
          exit 1
          ;;
    esac
done

sed -e "s/%ETCD_DISCOVERY_TOKEN%/${etcd_discovery_token}/" < userdata.tmpl

exit 0
