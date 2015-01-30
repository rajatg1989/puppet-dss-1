#!/bin/bash
/usr/lib/nagios/plugins/check_http -H localhost -p 8081 -u /analytics/uves  -r virtual-networks
