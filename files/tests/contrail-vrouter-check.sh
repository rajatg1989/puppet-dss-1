#!/bin/bash

log_file="/var/log/consul/contrail-vrouter-check.log"
test_cmd='curl -s -m 5 -o /dev/null http://localhost:8085/Snh_ItfReq?name='
lock_file='/var/run/contrail-vrouter-restart.err.lock'

last_step='Curl'

##
# Perform the check
##

${test_cmd}
rv=$?

##
# If it succeeds, delete any lockfile, exit 0
##
if [ $rv == 0 ]
then
    if [ -f $lock_file ]
    then
        rm $lock_file
    fi
    exit $rv
fi

##
# If it fails, check for lock file.
# If lock file exists, exit 2.
# If lock file does not exist, create it, issue the restart, exit 1.
# Exit code status per existing code
# 0 - OK
# 1 - WARNING
# 2 - CRITICAL
# 3 - Param Error
# 4+- Other Error
##

if [ $rv == 28 ]
then
    if [ -f $lock_file ]
    then
        exit 2
    fi
    echo "[WARN] `date` `hostname` [`date +%s`] Restarting vrouter ">>${log_file}
    echo "[ERROR] `date`" >>${lock_file}
    last_step='Agent restart'
    service contrail-vrouter-agent restart
    exit 1
fi
if [ $rv != 0 ]
then
    ##
    # Non-28 Error happening, need to check what is it
    # No need to put a lock file here as restart (and hence lock) are done only
    # on exit 28 of curl
    ##
    echo "[ERROR] `date` `hostname` [`date +%s`] ${last_step} failure - code ${rv}">>${log_file}
    exit $rv
fi
