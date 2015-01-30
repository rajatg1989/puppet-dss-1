require 'spec_helper'

describe 'rjil::jiocloud::consul::consul_alerts' do

  describe 'with defaults' do

    it 'should configure consul-alerts using defaults' do
      should contain_package('consul-alerts').with_ensure('present')
      should contain_consul_kv('consul-alerts/config/checks/enabled').with_value('false')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/enabled').with_value('false')
      should contain_consul_kv('consul-alerts/config/checks/check_thresold').with_value('30')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/cluster_name').with_value('consul-alerts')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/username').with_value('WatchBot')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/channel').with_value('consul-alerts')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/url').with_ensure('absent')
      should contain_file('/etc/init/consul-alerts.conf')
      should contain_service('consul-alerts').with(
        'ensure' => 'stopped',
        'enable' => 'false',
      )
    end
  end

  describe 'with slack_url' do

    let :facts do
      {'slack_url' => 'http://some_url/'}
    end
    it 'should configure consul-alerts using defaults' do
      should contain_package('consul-alerts').with_ensure('present')
      should contain_consul_kv('consul-alerts/config/checks/enabled').with_value('true')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/enabled').with_value('true')
      should contain_consul_kv('consul-alerts/config/checks/check_thresold').with_value('30')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/cluster_name').with_value('consul-alerts')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/username').with_value('WatchBot')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/channel').with_value('consul-alerts')
      should contain_consul_kv('consul-alerts/config/notifiers/slack/url').with_value('http://some_url/')
      should contain_file('/etc/init/consul-alerts.conf')
      should contain_service('consul-alerts').with(
        'ensure' => 'running',
        'enable' => 'true',
      )
    end
  end

end
