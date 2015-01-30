#
# base class for jenkins
#
class rjil::commonservices::jenkins {
  $packages = [
    'openjdk-7-jre-headless',
    'sbuild',
    'ubuntu-dev-tools',
    'npm',
    'python-lxml',
    'autoconf',
    'libtool',
    'haveged',
    'apt-cacher-ng',
    'debhelper',
    'pkg-config',
    'bundler',
    'libxml2-utils',
    'libffi-dev']

  package { $packages: ensure => 'installed' }

  include rjil::commonservices::jenkins::cloudenvs

  ::sudo::conf { 'jenkins_reprepro': content => 'jenkins ALL = (reprepro) NOPASSWD: /usr/bin/reprepro' }
}
