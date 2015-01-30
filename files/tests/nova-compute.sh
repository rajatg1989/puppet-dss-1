#!/bin/bash
set -e
/usr/lib/nagios/plugins/check_procs -c 1:1 -C nova-compute
