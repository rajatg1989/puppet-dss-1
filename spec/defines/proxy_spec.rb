require 'spec_helper'

describe 'rjil::system::proxy' do
  let (:facts) { {
    :operatingsystem => 'Ubuntu',
    :osfamily        => 'Debian',
    :lsbdistid       => 'ubuntu',
    :concat_basedir  => '/tmp'
  } }
  let(:title) { 'test_proxy' }
  context 'with defaults' do
    let (:params) { { :name => 'testname', } }
    it do
      should contain_file_line('testname-proxy').with({
        'ensure' => 'absent',
        'line'   => 'testname_proxy="false"',
        'match'  => '^testname_proxy='
      })
    end
  end

  context 'with url' do
    let (:params) { {
      :name => 'ftp',
      :url  => 'ftp://foobar:1234/'
    } }
    it do
      should contain_file_line('ftp-proxy').with({
        'ensure' => 'present',
        'line'   => 'ftp_proxy="ftp://foobar:1234/"',
        'match'  => '^ftp_proxy='
      })
    end
  end
end

