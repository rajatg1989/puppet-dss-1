require 'spec_helper'

describe 'rjil::db::instance' do

  let(:facts) {
    {
      :osfamily => 'Debian'
    }
  }
  
  let :default_params do
    {
      :ensure  => 'present',
      :db      => 'nova',
      :pass    => 'nova',
      :user    => 'nova',
      :charset => 'utf8',
      :grant   => ['ALL'],
      :table   => 'nova.*',
    }
  end
  
  let(:title){ 'nova' }

  context 'default resources' do
  
    let (:params) { default_params }
    it 'should contain default resources' do
      should contain_mysql_database('nova').with(
        {
          'ensure'   => 'present',
          'charset'  => 'utf8',
          'provider' => 'mysql',
          'require'  => 'Class[Mysql::Server]',
          'before'   => 'Mysql_user[nova@%]',
        }
      )
      should contain_mysql_user('nova@%').with(
        {
          'ensure'        => 'present',
          'password_hash' => '*0BE3B501084D35F4C66DD3AC4569EAE5EA738212',
          'provider'      => 'mysql',
          'require'       => 'Class[Mysql::Server]',
        }
      )
      should contain_mysql_grant('nova@%/nova.*').with(
        {
          'privileges' => ['ALL'],
          'provider'   => 'mysql',
          'user'       => 'nova@%',
          'table'      => 'nova.*',
          'require'    => ['Mysql_user[nova@%]', 'Class[Mysql::Server]']
        }
      )
    end
  end

  context 'with ensure absent' do
    
    let (:params) { default_params.merge(
      {
        :ensure => 'absent'
      }
      ) }
    it 'should not contain mysql grant resources with ensure absent' do
      should contain_mysql_database('nova')
      should contain_mysql_user('nova@%')
      should_not contain_mysql_grant('nova@%/nova.*')
    end
  end
end
