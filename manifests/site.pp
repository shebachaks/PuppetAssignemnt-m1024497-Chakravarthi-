node default{
        file { '/tmp/file1':
          ensure => file,
        }
        notify { "System is up": }
        file { '/tmp/file2':
          ensure => file,
        }
 }
