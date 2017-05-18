# Manage Nginx
class nginx {
  package { 'nginx': ensure => installed }
 
  service { 'nginx':
    ensure => running,
    enable => true, # Start the service on system reboot.
    require => Package['nginx'] # Forcing the correct order.
  }
 
  exec { 'reload nginx':
    command     => '/usr/sbin/service nginx reload',
    require     => Package['nginx'],
    refreshonly => true,  # Execute only if some resource has changed.
  }
}
