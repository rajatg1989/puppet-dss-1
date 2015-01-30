#!/bin/bash -ex

read snapshot_version_active  < /etc/snapshot_version_active
read snapshot_version_pending < /etc/snapshot_version

puppet apply -e "class { 'rjil::jiocloud::sources': snapshot_version => $snapshot_version_pending }"

# Update package lists
apt-get update
# Upgrade just this one package
apt-get install jiocloud-puppet

# Handle any preupgrade things we want to do
puppet apply -e "class { 'rjil::jiocloud::preupgrade': from_version => $snapshot_version_active }"

# Upgrade all packages
apt-get dist-upgrade

# Run Puppet
puppet apply /etc/manifests/site.pp

# Record that we have upgraded. Yay.
echo snapshot_version_pending > /etc/snapshot_version_active
