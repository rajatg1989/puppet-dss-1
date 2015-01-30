require 'spec_helper'

describe 'rjil::jiocloud::dns::entry' do
  before(:each) do
    MockFunction.new('dns_resolve') { |f|
      f.stubs(:call).with(['some.other.host']).returns('2.3.4.5,5.6.7.8')
    }
  end

  let (:facts) { {
    :operatingsystem => 'Ubuntu',
    :osfamily        => 'Debian',
    :lsbdistid       => 'ubuntu',
    :concat_basedir  => '/tmp'
  } }
  let(:title) { 'somehost' }
  context 'with defaults' do
    let (:params) { { :name => 'testname', } }
    it do
      expect { should compile }.to raise_error(Puppet::Error,/neither IP nor CNAME/)
    end
  end
  context 'with ip' do
    let (:params) { { :name => 'testname',
                      :ip => '1.2.3.4' } }
    it do
      should contain_host('testname').with({'ip' => '1.2.3.4'}).that_notifies("Class[Dnsmasq::Reload]")
    end
  end
  context 'with cname' do
    let (:params) { { :name => 'testname',
                      :cname => 'some.other.host' } }
    it do
      should contain_host('testname').with({'ip' => '2.3.4.5'}).that_notifies("Class[Dnsmasq::Reload]")
    end
  end
end
