#!/bin/bash

set -e

function fail {
  echo "CRITICAL: $@"
  exit 2
}

<%- if @disk =~ /loop/ %>
osdid=`df -h | grep "/dev/<%= @disk %>p[0-9]" | awk '{print $NF}' | cut -f2 -d-`
<%- else %>
osdid=`df -h | grep "/dev/<%= @disk %>[^a-z]" | awk '{print $NF}' | cut -f2 -d-`
<%- end %>
ps -efw | grep ceph-osd | grep osd.${osdid}.pid || fail "osd failed"
