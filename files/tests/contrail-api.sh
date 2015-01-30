#!/bin/bash
/usr/lib/nagios/plugins/check_http -H localhost -p 8082 -u /virtual-networks  -r default-virtual-network
