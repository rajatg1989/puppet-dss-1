#!/usr/bin/env python
# This belongs in jiocloud.orchestrate, but since we're not really
# switching to consul yet, I didn't want to stick it there.

import json
import requests
import sys

token = sys.argv[1]

r = requests.get('http://localhost:8500/v1/catalog/service/consul')
out = ['%s:%s' % (x['Address'], x['ServicePort']) for x in r.json()]
r = requests.put('http://consuldiscovery.linux2go.dk/%s' % (token,), data=json.dumps(out))
print r
