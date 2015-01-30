#!/bin/bash -xe

. $(dirname $0)/common.sh

if [ ! -f ${project_tag}_ssh_config ]; then
  python -m jiocloud.apply_resources ssh_config --project_tag=${project_tag} ${mappings_arg} environment/${layout:-full}.yaml > ${project_tag}_ssh_config
fi

ssh -F ${project_tag}_ssh_config -l ${ssh_user:-jenkins} gcp1_${project_tag} '~jenkins/tempest/run_tempest.sh -N -- --load-list ~jenkins/tempest_tests.txt'

exit 0 
