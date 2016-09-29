class nginx($upstream) {
    package { "nginx":
        ensure      => latest,
        require     => Anchor['nginx::apt_repo'],
    }

    anchor { 'nginx::apt_repo' : }

    apt::source { 'nginx':
        location    => 'http://nginx.org/packages/mainline/ubuntu/',
        release     => $lsbdistcodename,
        repos       => 'nginx',
        key         => '7BD9BF62',
        key_source  => 'http://nginx.org/keys/nginx_signing.key',
        notify      => Exec['apt_get_update_for_nginx'],
    }

    exec { 'apt_get_update_for_nginx':
        command     => '/usr/bin/apt-get update',
        timeout     => 240,
        returns     => [ 0, 100 ],
        refreshonly => true,
        before      => Anchor['nginx::apt_repo'],
    }

    file { "/etc/nginx/nginx.conf":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("nginx/nginx.conf.erb"),
        notify      => Service["nginx"],
        require     => Package["nginx"]
    }

    file { "/etc/nginx/conf.d/upstream.conf":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("nginx/upstream.conf.erb"),
        notify      => Service["nginx"],
        require     => Package["nginx"]
    }

    file { "/etc/nginx/conf.d/default.conf":
        ensure      => absent,
        notify      => Service["nginx"],
        require     => Package["nginx"]
    }

    file { "/etc/nginx/conf.d/example_ssl.conf":
        ensure      => absent,
        notify      => Service["nginx"],
        require     => Package["nginx"]
    }

    service { "nginx":
        ensure      => running,
        hasrestart  => true,
        require     => Package["nginx"]
    }
}
