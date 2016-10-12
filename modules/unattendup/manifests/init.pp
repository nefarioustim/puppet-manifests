class unattendup {
    package { "unattended-upgrades":
        ensure      => latest
    }

    exec { "activate-unattended-upgrades":
        command     => "dpkg-reconfigure --priority=low unattended-upgrades",
        require     => Package["unattended-upgrades"]
    }

    file { "/etc/apt/apt.conf.d/20auto-upgrades":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("unattendup/20auto-upgrades.erb"),
        require     => Exec["activate-unattended-upgrades"]
    }

    file { "/etc/apt/apt.conf.d/50unattended-upgrades":
        owner       => root,
        group       => root,
        mode        => "0644",
        content     => template("unattendup/50unattended-upgrades.erb"),
        require     => Exec["activate-unattended-upgrades"]
    }
}