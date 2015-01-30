require 'spec_helper'

describe 'rjil::apparmor::rule' do
  let(:title) { 'somehost' }

  context 'with create rule' do

    let :params do
      {
        :name     => 'rule1/* r',
        :file_path => '/etc/apparmor.d/test'
      }
    end

    it 'should create an apparmor rule' do
      should contain_class('rjil::apparmor')

      should contain_file_line('apparmor_rule_rule1/* r').with (
        {
          :ensure => 'present',
          :line   => 'rule1/* r',
          :path   => '/etc/apparmor.d/test',
          :notify => 'Service[apparmor]'
        }
      )
    end
  end

  context 'without file_path' do
    let :params do
      {
        :name     => 'rule1/* r',
      }
    end

    it 'should throw compile error' do
      expect { should compile }.to raise_error(Puppet::Error,/file_path should be set to an existing apparmor rule file/)
    end
  end

  context 'with create rule_file' do

    let :params do
      {
        :name     => '/tmp/file',
        :content  => 'rule file contents',
      }
    end

    it 'should create rulefile' do
      should contain_file('/tmp/file').with (
        {
          :ensure => 'present',
          :content => 'rule file contents',
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :notify  => 'Service[apparmor]',
        }
      )
    end
  end
end
