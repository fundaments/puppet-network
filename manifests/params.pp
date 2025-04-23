# Class: network::params
#
# Defines all the variables used in the module.
#
class network::params {

  $service_restart_exec = $facts['os']['family'] ? {
    'Debian'  => '/sbin/ifdown -a --force ; /sbin/ifup -a',
    'Solaris' => '/usr/sbin/svcadm restart svc:/network/physical:default',
    'RedHat'  => $facts['os']['release']['major'] ? {
      '8'     => 'nmcli connection reload',
      default => 'service network restart',
    },
    default   => 'service network restart',
  }

  $config_file_path = $facts['os']['family'] ? {
    'Debian' => '/etc/network/interfaces',
    'RedHat' => '/etc/sysconfig/network-scripts/ifcfg-eth0',
    'Suse'   => '/etc/sysconfig/network/ifcfg-eth0',
    default  => undef,
  }

  $config_file_mode = $facts['os']['family'] ? {
    default => '0644',
  }

  $config_file_owner = $facts['os']['family'] ? {
    default => 'root',
  }

  $config_file_group = $facts['os']['family'] ? {
    default => 'root',
  }

  $config_dir_path = $facts['os']['family'] ? {
    'Debian' => '/etc/network',
    'Redhat' => '/etc/sysconfig/network-scripts',
    'Suse'   => '/etc/sysconfig/network',
    default  => undef,
  }

  $package_name = $facts['os']['name'] ? {
    'Ubuntu' => 'ifupdown',
    default  => undef,
  }

  case $facts['os']['family'] {
    'Debian','RedHat','Amazon','Suse', 'Solaris': { }
    default: {
      fail("${facts['os']['name']} not supported.")
    }
  }
}
