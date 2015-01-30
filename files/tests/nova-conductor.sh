#!/bin/bash
set -e
sudo nova-manage service list | grep "nova-conductor.*$(hostname).*enabled.*:-)"
