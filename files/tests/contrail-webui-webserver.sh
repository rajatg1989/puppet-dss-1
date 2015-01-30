#!/bin/bash
/usr/lib/nagios/plugins/check_http -H localhost -p 8143 --ssl -u /login
