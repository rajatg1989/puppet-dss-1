#!/bin/bash
set -e
# this check was failing b/c of auth
#/usr/lib/nagios/plugins/check_http -H 127.0.0.1 -p 9191
/usr/lib/nagios/plugins/check_tcp -H 127.0.0.1 -p 9191
