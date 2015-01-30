#!/bin/bash
set -e
sudo cinder-manage service list | grep "cinder-scheduler.*$(hostname).*enabled.*:-)"
