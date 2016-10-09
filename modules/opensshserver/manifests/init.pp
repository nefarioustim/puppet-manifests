class opensshserver {
    package { "openssh-server":
        ensure => latest
    }

    service { "ssh":
        ensure      => running,
        hasstatus   => true,
        require     => Package["openssh-server"],
    }

    file { "/etc/ssh/sshd_config":
        ensure      => present,
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("opensshserver/sshd_config.erb"),
        notify      => Service["ssh"],
        require     => Package["openssh-server"]
    }
}