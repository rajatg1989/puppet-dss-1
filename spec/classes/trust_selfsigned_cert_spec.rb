require 'spec_helper'
require 'hiera-puppet-helper'

describe 'rjil::trust_selfsigned_cert' do

  let :params do
    {
      :cert               => '/etc/ssl/certs/jiocloud.com.crt',
      :ssl_cert_package   => 'jiocloud-ssl-certificate',
    }
  end

  let :facts do
    {
      :operatingsystem  => 'Ubuntu',
      :osfamily         => 'Debian',
      :lsbdsitid        => 'ubuntu',
    }
  end

  context 'with defaults' do
    it do
      should contain_package('ca-certificates')

      should contain_package('jiocloud-ssl-certificate')

      should contain_file('/usr/local/share/ca-certificates/selfsigned.crt') \
        .with_ensure('link') \
        .with_source('/etc/ssl/certs/jiocloud.com.crt') \
        .that_notifies('Exec[update-cacerts]')

      should contain_exec('update-cacerts') \
        .with_command('update-ca-certificates --fresh') \
        .with_refreshonly(true)
    end
  end
end

