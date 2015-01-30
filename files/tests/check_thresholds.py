#!/usr/bin/env python
import argparse
import re
import sys
import urllib3
import urllib

#
# This class is used to parse collectd log notifications. It returns 0,1,2
#   - 0 - no failures
#   - 1 - only warnings
#   - 2 - failures
#
# In the case that warnings or failures exist, it will also print the information
# about those failures and warning to stdout
#
class NotificationParser:
    # go through all events in a file of a given type, and just keep a record
    # of the last event for each type.
    def parse(self, filename):
        data_hash = {}
        with open(filename, 'r') as f:
            for line in f:
                try:
                    spl_line = line.split(', ')
                    m     = re.search('Notification: severity = (OKAY|WARNING|FAILURE)', spl_line.pop(0))
                    if m:
                        n     = spl_line[1].split(' = ')
                        level = m.group(1)
                        name  = n[1]
                        local_data = {}
                        for l in spl_line:
                            # assumes that message is the last field, so it we have
                            # encountered it, then all remaining text should be
                            # considered part of the message
                            if 'message' in local_data:
                                local_data['message']+=l
                            else:
                                data = l.split(' = ', 2)
                                local_data[data[0]] = data[1]
                        data_hash[name] = [level, local_data['message']]
                except:
                    print "Line: %s, lead to an unexpected exception, skipping" % line
        return data_hash

    def update_service_status(self, status, service_name, note=''):
        http = urllib3.PoolManager()
        note = urllib.quote(note)
        url = "http://localhost:8500/v1/agent/check/%s/service:metric_thresholds_%s?note=%s" % (status, service_name, note)
        r = http.request('GET', url)

    def send_alerts(self, data):
        for k, v in data.iteritems():
            if v[0] == 'OKAY':
                resp = self.update_service_status('pass', k, v[1])
            elif v[0] == 'WARNING':
                resp = self.update_service_status('warn', k, v[1])
            elif v[0] == 'FAILURE':
                resp = self.update_service_status('fail', k, v[1])

if __name__ == '__main__':
    argparser = argparse.ArgumentParser()
    argparser.add_argument('filename', help='Notification file to parse')
    args = argparser.parse_args()
    notification_parser = NotificationParser()
    data = notification_parser.parse(args.filename)
    notification_parser.send_alerts(data)
