class nginx {
    include apt
    include instassl

    apt::source { "nginx":
        location    => 'http://nginx.org/packages/mainline/ubuntu/',
        release     => $lsbdistcodename,
        repos       => 'nginx',
        key         => '7BD9BF62',
        key_source  => 'http://nginx.org/keys/nginx_signing.key'
    }

    package { "nginx":
        ensure      => latest,
        require     => Apt::Source['nginx'],
    }

    file { "/etc/nginx/nginx.conf":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("nginx/nginx.conf.erb"),
        notify      => Service["nginx"],
        require     => [
            Class["instassl"],
            Package["nginx"]
        ]
    }

    file { "nginx-monit-conf-dir":
        path        => "/etc/monit/conf.d",
        ensure      => 'directory',
        mode        => '0755',
    }

    file { "/etc/monit/conf.d/nginx":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("nginx/nginx.monit.erb"),
        require     => File["nginx-monit-conf-dir"]
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
