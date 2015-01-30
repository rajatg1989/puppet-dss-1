require 'spec_helper'

describe 'rjil::localuser' do
  let :facts do
    {
      :operatingsystem  => 'Ubuntu',
      :osfamily         => 'Debian',
      :lsbdistid        => 'ubuntu',
    }
  end

  let (:title)  { 'foouser' }

  context 'with defaults' do
    let :params do
      {
        :name       => 'foouser',
        :realname   => 'fooname',
        :sshkeys    => 'abcdefghijklmnopqrstuvwxyz',
        :shell      => '/bin/bash',
      }
    end

    it do
      should contain_group('foouser').with_ensure('present')

      should contain_user('foouser') \
        .with_ensure('present') \
        .with_comment('fooname') \
        .with_gid('foouser') \
        .with_groups( ['sudo'] ) \
        .with_home('/home/foouser') \
        .with_managehome(true) \
        .with_membership('minimum') \
        .with_shell('/bin/bash') \
        .with_require( ['Group[foouser]'] )

      should contain_file('foouser_sshdir') \
        .with_group('foouser') \
        .with_owner('foouser') \
        .with_mode('0700') \
        .with_require( ['User[foouser]'] )

      should contain_file('foouser_keys') \
        .with_content('abcdefghijklmnopqrstuvwxyz') \
        .with_group('foouser') \
        .with_mode('0400') \
        .with_owner('foouser') \
        .with_require( ['File[foouser_sshdir]'] )
    end
  end

end

