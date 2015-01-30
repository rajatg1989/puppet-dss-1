#!/bin/bash
set -e
/usr/lib/nagios/plugins/check_mysql -f /etc/mysql/debian.cnf 
