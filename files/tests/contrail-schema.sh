#!/bin/bash
/usr/lib/nagios/plugins/check_http -H localhost -p 8087 -u /  -r sandesh_uve.xml
