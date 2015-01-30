## Class: rjil::system::accounts
## Purpose is to group all system user account actions in single class

class rjil::system::accounts (
  $active_users,
  $sudo_users,
  $local_users,
) {

  ## Make sure root user doesnt have any passord set.
  ## If set, revert it.
  user { 'root':
    name     => 'root',
    ensure   => present,
    password => '*',
  }

  class { 'ssh::server':
    options => {
      'PasswordAuthentication' => 'no',
      'PermitRootLogin'        => 'no',
      'Banner'                 => '/etc/issue.net',
      'Ciphers'                => 'aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com',
      'MACs'                   => 'hmac-sha1-etm@openssh.com,umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-ripemd160-etm@openssh.com,hmac-sha1-96-etm@openssh.com,hmac-sha1,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-ripemd160'
    },
  }

  ## Add all local users which are set as active
  ## The idea is to specify details of all users and
  ## override the users in different hierarichy like
  ## environment wide, role wide etc

  create_resources('rjil::system::accounts::instance',$local_users,{active_users => $active_users})

  ## setup sudoers
  class { 'sudo':
    purge => false,
    config_file_replace => false,
  }

  create_resources('rjil::system::accounts::sudo', $sudo_users, {active_users => $active_users})

  rjil::jiocloud::consul::service { "ssh":
    port          => 22,
    check_command => "/usr/lib/nagios/plugins/check_ssh -t 5 ${::ipaddress}"
  }
}
