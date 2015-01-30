#!/bin/bash
set -e
sudo nova-manage service list | grep "nova-scheduler.*$(hostname).*enabled.*:-)"
