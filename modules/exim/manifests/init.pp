class exim {
    package { 'postfix':
        ensure => absent
    }

    package { "exim4":
        ensure => present
    }

    service { "exim4":
        ensure  => running,
        require => Package["exim4"]
    }


    file { "/etc/exim4/update-exim4.conf.conf":
        content => template("exim/update-exim4.conf.conf.erb"),
        require => Package["exim4"]
    }

    file { "/etc/exim4/exim4.conf.localmacros":
        content => template("exim/exim4.conf.localmacros.erb"),
        require => Package["exim4"]
    }

    file { "/etc/exim4/passwd.client":
        content => template("exim/passwd.client.erb"),
        require => Package["exim4"]
    }

    exec { "/usr/sbin/update-exim4.conf":
        subscribe   => File["/etc/exim4/update-exim4.conf.conf"],
        refreshonly => true,
        require     => Package["exim4"]
    }
}
