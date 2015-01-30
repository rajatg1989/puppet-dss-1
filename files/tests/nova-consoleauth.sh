#!/bin/bash
set -e
sudo nova-manage service list | grep "nova-consoleauth.*$(hostname).*enabled.*:-)"
