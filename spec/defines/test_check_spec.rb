require 'spec_helper'

describe 'rjil::test::check' do
  let :facts do
    {
      :operatingsystem => 'Ubuntu',
      :osfamily        => 'Debian',
      :lsbdistid       => 'ubuntu',
    }
  end


  let (:title)  { 'foo' }

  context 'with http port' do
    let :params do
      {
        :name => 'foo',
        :port => 80,
      }
    end

    it 'should create an http based service check' do
      should contain_class('rjil::test::base')
      should contain_file('/usr/lib/jiocloud/tests/service_checks/foo.sh') \
        .with_content(/\/usr\/lib\/nagios\/plugins\/check_http -H 127.0.0.1 -p 80/) \
        .with_owner('root') \
        .with_group('root') \
        .with_mode('0755')
    end
  end

  context 'with https' do
    let :params do       
      {                  
        :name => 'foo',  
        :ssl  => true,
        :port => 80,     
      }                  
    end

    it 'should create an https service check' do
      should contain_file('/usr/lib/jiocloud/tests/service_checks/foo.sh') \
        .with_content(/\/usr\/lib\/nagios\/plugins\/check_http -S -H 127.0.0.1 -p 80/)
    end
  end

  context 'with tcp' do
    let :params do     
      {                
        :name => 'foo',
        :type => 'tcp',
        :port => 80,   
      }                
    end

    it 'should create an tcp service check' do
      should contain_file('/usr/lib/jiocloud/tests/service_checks/foo.sh') \
        .with_content(/\/usr\/lib\/nagios\/plugins\/check_tcp -H 127.0.0.1 -p 80/)
    end
  end

  context 'with udp' do
    let :params do      
      {                 
        :name    => 'foo', 
        :type    => 'udp',
        :address => '10.1.0.1',
        :port    => 80, 
      }                 
    end                 
     
    it 'should create a udp service check with provided address' do
      should contain_file('/usr/lib/jiocloud/tests/service_checks/foo.sh') \
        .with_content(/netcat -z -v -u 10.1.0.1  80/)
    end
  end

  context 'with proc' do
    let :params do
      {
        :name => 'foo',
        :type => 'proc',
      }
    end
     
    it 'should create a process service check' do
      should contain_file('/usr/lib/jiocloud/tests/service_checks/foo.sh') \
        .with_content(/\/usr\/lib\/nagios\/plugins\/check_killall_0 foo/)
    end
  end

  context 'with validation process check' do
    let :params do                          
      {                                     
        :name       => 'foo',                     
        :type       => 'proc',                    
        :check_type => 'validation',
      }                                     
    end                                     
     
    it 'should create a process validation check' do   
      should contain_file('/usr/lib/jiocloud/tests/foo.sh') \
        .with_content(/\/usr\/lib\/nagios\/plugins\/check_killall_0 foo/)
    end
  end

  context 'with random check_type' do
    let :params do                    
      {                               
        :name       => 'foo',         
        :type       => 'proc',        
        :check_type => 'blah', 
      }                               
    end

    it 'should error out' do
      expect {
        should compile
      }.to raise_error(Puppet::Error, /Invalid check_type - blah/)
    end
  end
end

