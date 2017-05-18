
class nginx::systeminformation {

       $systeminfodata = [
                               {
                              metric => $::puppetversion,
                              description => "version of the puppet"
                             },
                             {
                              metric => $::rubyversion,
                              description => "version of the ruby"
                             },
                            {
                              metric => $::kernelmajversion,
                              description => "major version of the kernel"
                             },
                             {
                              metric => $::kernelrelease,
                              description => "release of the kernel"
                             }
                         ]
                      }
