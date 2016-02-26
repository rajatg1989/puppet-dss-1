#!/bin/bash
#
# Parallel provisioning for vagrant
#
  
up() {
  . newtokens.sh
  export layout=full
  if [ ! -n $consul_discovery_token ]; then
    echo "Error fetching consul discovery token, exiting"
    exit 100
  fi
  echo "export consul_discovery_token=$consul_discovery_token" >> vagrant_keys
  #source vagrant_keys
  vagrant up --no-provision
}

provision() {
  source vagrant_keys
  sleep 5
  if [ ! -n $consul_discovery_token ]; then
    echo "Error fetching consul discovery token, exiting"
    exit 100
  fi
  for i in `vagrant status | grep running | awk '{print $1}'`; do 
    vagrant provision $i &
  done
}

destroy() {
  source vagrant_keys
  vagrant destroy -f
  sed -i "s/$consul_discovery_token/token_value/g" vagrant_keys
}

cleanup() {
  source vagrant_keys
  vagrant destroy -f
  rm -f vagrant_keys
}

case $1 in
  'destroy')
    destroy
    ;;
  'up')
    up
    provision
    ;;
  'provision')
    provision
    ;;
  'cleanup')
    cleanup
    ;;
  'reset')
    destroy
    up
    provision
    ;;
  *)
    echo "Invalid operation. Valid operations are destroy, up, provision,reset,initialize,cleanup"
    exit 100
    ;;
esac
