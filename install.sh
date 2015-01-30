#!/bin/bash
release="$(lsb_release -cs)"
wget -O puppet.deb http://apt.puppetlabs.com/puppetlabs-release-${release}.deb
dpkg -i puppet.deb
apt-get update
apt-get install -y puppet git
sudo puppet module install saz/ssh
git clone https://github.com/JioCloud/puppet-rjil
ln -s ${PWD}/puppet-rjil /etc/puppet/modules/rjil
cat <<EOF > /etc/puppet/manifests/site.pp
include rjil::server
EOF

cat <<EOF
Add any additional users to be set up on this host by adding them to
/etc/puppet/manifests/site.pp like so:

  realize( Rjil::Localuser['rohit'],
           Rjil::Localuser['amar'],
           < etc. etc. >
         )

Once you're done, run:

  puppet apply /etc/puppet/manifests/site.pp

EOF
