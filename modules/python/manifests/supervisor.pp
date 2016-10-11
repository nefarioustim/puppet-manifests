class python::supervisor {
    package { "supervisor":
        ensure      => latest
    }

    file { "/etc/supervisor/supervisord.conf":
        owner       => root,
        group       => root,
        mode        => "0644",
        source      => "puppet:///modules/python/supervisord.conf",
        require     => Package["supervisor"],
        notify      => Service["supervisor"]
    }

    service { "supervisor":
        ensure      => running,
        subscribe   => File["/etc/supervisor/supervisord.conf"],
        require     => Package["supervisor"]
    }
}
