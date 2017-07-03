class fail2ban {

    package { "fail2ban":
        ensure      => latest,
        ensure      => running,
        require     => Package["fail2ban"]
    }

}
