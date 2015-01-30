#!/bin/bash
set -e
sudo nova-manage service list | grep "nova-cert.*$(hostname).*enabled.*:-)"
