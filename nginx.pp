class nginx {
    package { [
            "nginx",
        ]:
        ensure => latest,
    }

    file { "/etc/nginx/nginx.conf":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/nginx.conf",
        notify => Service["nginx"],
    }

    file { "/etc/nginx/conf.d/upstream.conf":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/upstream.conf",
        notify => Service["nginx"],
    }

    file { "/etc/nginx/sites-enabled/default":
        ensure => absent,
        notify => Service["nginx"],
    }

    file { "/etc/nginx/sites-available/vagrantsite":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/vhost.conf",
        notify => Service["nginx"],
    }

    file { "/etc/nginx/sites-enabled/vagrantsite":
        ensure => symlink,
        target => "/etc/nginx/sites-available/vagrantsite",
        notify => Service["nginx"],
    }

    service { "nginx":
        ensure => running,
        hasrestart => true,
    }
}