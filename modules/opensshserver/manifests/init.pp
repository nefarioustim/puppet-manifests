class opensshserver {
    package { "openssh-server":
        ensure => latest
    }

    service { "ssh":
        ensure    => running,
        hasstatus => true,
        subscribe => File["/etc/ssh/sshd_config"],
        require   => Package["openssh-server"],
    }

    file { "/etc/ssh/sshd_config":
        ensure      => present,
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("opensshserver/sshd_config.erb"),
        require     => Package["openssh-server"]
    }
}