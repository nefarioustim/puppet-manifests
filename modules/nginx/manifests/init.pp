class nginx {
    file { "/etc/nginx/nginx.conf":
        owner  => root,
        group  => root,
        mode   => 644,
        content => template("nginx/nginx.conf.erb"),
        notify => Service["nginx"]
    }

    file { "/etc/nginx/conf.d/upstream.conf":
        owner  => root,
        group  => root,
        mode   => 644,
        content => template("nginx/upstream.conf.erb"),
        notify => Service["nginx"]
    }

    file { "/etc/nginx/conf.d/default.conf":
        ensure => absent,
        notify => Service["nginx"]
    }

    file { "/etc/nginx/conf.d/example_ssl.conf":
        ensure => absent,
        notify => Service["nginx"]
    }

    service { "nginx":
        ensure => running,
        hasrestart => true
    }
}
