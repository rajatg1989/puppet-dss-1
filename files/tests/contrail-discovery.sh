#!/bin/bash
/usr/lib/nagios/plugins/check_http -H localhost -p 5998 -u /services.json  -r IfmapServer
