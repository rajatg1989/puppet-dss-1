#!/bin/bash
##
# The contrail codebase we use does not support log configuration for most
# logs. The default is rotated based upon size. The non-configurable default
# size is too less (few MBs) and hence with the default retention of 10 logs,
# we end up with only few hours of logs for these. Hence this script collates
# these smaller files into a single daily logfile which can then be rotated
# via logrotate. The upstream has added config options for some modules but not
# all are still covered. Hence till upstream is completely patched, this will
# still be useful
##

contrail_logs=('contrail-api'
		'contrail-schema'
		'contrail-discovery'
		'contrail-collector'
		'vnc_openstack.err'
		'svc-monitor.err'
		'schema.err'
		'api-0-zk'
		'schema-zk'
		)

log_dir='/var/log/contrail/'
for log in ${contrail_logs[@]} 
do 
file="${log_dir}${log}"
file_log="${file}.log.1"
file_daily="${file}-daily.log"

if [[ "$log" =~ "err" ]]
then
    file_log="${file}.1"
    file_daily="${log_dir}contrail-${log}-daily.log"
fi
 
if [[ "$log" =~ "zk" ]]
then
    file_daily="${log_dir}contrail-${log}-daily.log"
fi

if [ -f "${file_log}" ]
then
	cat $file_log >> $file_daily
	rm  $file_log
fi

done