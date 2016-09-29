class nginx {
    package { "nginx":
        ensure => latest,
    }

    file { "populate-nginx-conf":
        path => "/etc/nginx/nginx.conf",
        owner  => root,
        group  => root,
        mode   => "0644",
        content => template("nginx/nginx.conf.erb"),
        notify => Service["nginx"],
        require => Package["nginx"],
    }

    file { "populate-upstream-conf":
        path => "/etc/nginx/conf.d/upstream.conf",
        owner  => root,
        group  => root,
        mode   => "0644",
        content => template("nginx/upstream.conf.erb"),
        notify => Service["nginx"],
        require => Package["nginx"],
    }

    file { "remove-default-site":
        path => "/etc/nginx/sites-enabled/default",
        ensure => absent,
        notify => Service["nginx"],
        require => Package["nginx"],
    }

    service { "nginx":
        ensure => running,
        hasrestart => true,
        require => Package["nginx"],
    }
}
