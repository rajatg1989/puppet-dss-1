# packages etc required for tools/commonservices
class rjil::commonservices::tools {
  $tools_pkgs = ['php5-snmp', 'php5-gmp', 'git', 'python-dev', 'python-pip', 'python-virtualenv', 'build-essential','libmysqlclient-dev','reprepro','apt-mirror']

  package { $tools_pkgs: }

  class { 'apache::mod::rewrite': }
}
