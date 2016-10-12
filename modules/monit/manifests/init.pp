class monit {
    package { "monit":
        ensure      => latest
    }

    file { "/etc/monit/monitrc":
        owner       => root,
        group       => root,
        mode        => "0700",
        content     => template("monit/monitrc.erb"),
        notify      => Service["monit"],
        require     => Package["monit"]
    }

    file { "/etc/monit/conf.d/filesystem":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("monit/filesystem.erb"),
        notify      => Service["monit"],
        require     => Package["monit"]
    }

    file { "/etc/monit/conf.d/supervisor":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("monit/supervisor.erb"),
        notify      => Service["monit"],
        require     => Package["monit"]
    }

    service { "monit":
        ensure      => running,
        enable      => true,
        hasrestart  => true,
        hasstatus   => false,
        require     => Package['monit']
    }
}