
node vagrant-ubuntu-trusty-32{


            nginx::vhost::createwebsite{"web1anything":
                    domain => "site1.puppet.nginx.in",
                    root => "/home/ubuntu/site1"
                   }

            nginx::vhost::createwebsite{"web2anything":
                    domain => "site2.puppet.nginx.in",
                    root => "/home/ubuntu/site2"
                     }


   $servers = [
        {
                     ip_address => '127.0.0.1',
                     hostname => 'site1.puppet.nginx.in'
        },
        {
                     ip_address => '127.0.0.1',
                     hostname => 'site2.puppet.nginx.in'
        },
         ]
           class { 'nginx::etchosts':
                    servername => $servers
                 }

}

