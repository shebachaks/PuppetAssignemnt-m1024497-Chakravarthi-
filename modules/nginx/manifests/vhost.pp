# Manage an Nginx virtual host
class nginx::vhost($domain='UNSET',$root='UNSET') {
 
 
  $default_parent_root = "/home/ubuntu/nginxsites-puppet"
#create the default parent root just once
        $dir_tree = [ "$default_parent_root" ]
                file { $dir_tree :
                owner   => 'ubuntu',
                group   => 'ubuntu',
                ensure  => 'directory',
                mode    => '777',
              }
# The one which the external world invokes

 define createwebsite( $domain="UNSET",$root='UNSET' ){

           include nginx  # Class was declared inside init.pp
 
 
          # Default value overrides
 
          if $domain == 'UNSET' {
          $vhost_domain = $name
           } else {
          $vhost_domain = $domain
           }    
 
         if $root == 'UNSET' {
         $vhost_root = "$default_parent_root/${name}"
         } else {
         $vhost_root = $root
         }
 
 
        # Creating the virtual host conf file out of the template in nginx/templates directory
 
        file { "/etc/nginx/sites-available/${vhost_domain}.conf":
        content => template('nginx/vhost.erb'), # vhost.erb is present in nginx/templates/
        require => Package['nginx'],
        notify  => Exec['reload nginx'], # Resource was declared in init.pp
        } 
 
       # Enabling the site by creating a sym link from sites-available to sites-enabled
 
        file { "/etc/nginx/sites-enabled/${vhost_domain}.conf":
        ensure  => link,
        target  => "/etc/nginx/sites-available/${vhost_domain}.conf",
        require => File["/etc/nginx/sites-available/${vhost_domain}.conf"],
        notify  => Exec['reload nginx'],
       } 
          addStaticFiles{ "staticfiles-${vhost_domain}puppet":
                 default_parent_root => $default_parent_root,
                 vhost_root => $vhost_root,
                 vhost_domain => $vhost_domain
 }
}
define addStaticFiles( $default_parent_root , $vhost_root , $vhost_domain ){
 
        include nginx::systeminformation
               $dir_tree = ["$vhost_root" ]
               file { $dir_tree :
                owner   => 'ubuntu',
                group   => 'ubuntu',
                ensure  => 'directory',
                mode    => '777',
              }->

               file {  ["$vhost_root/index.html"]:
               owner   => 'ubuntu',
               group   => 'ubuntu',
               source => "puppet:///modules/nginx/${vhost_domain}/index-html", # index.html was dropped under nginx/files/<your_domain>/index.html
               mode    => '755',
             }-> # This arrow ensures that the dir structure is created first.

               file {  ["$vhost_root/downtime.html"]:
               owner   => 'ubuntu',
               group   => 'ubuntu',
               source => "puppet:///modules/nginx/${vhost_domain}/downtime-html", 
               mode    => '755',
             }->

               file { [ "$vhost_root/systeminformation.html"] :
                       content => template("nginx/systeminformation.erb"),
                    }

 }
}
