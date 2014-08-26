class exim {
    package { "exim4":
        ensure => latest
    }

    file { "/etc/exim4/update-exim4.conf.conf":
        content => template("exim4/update-exim4.conf.conf.erb"),
        require => Package["exim4"]
    }

    exec { "update-exim4.conf":
        require => File["/etc/exim4/update-exim4.conf.conf"]
    }
}
