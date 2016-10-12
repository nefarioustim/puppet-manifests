class firewall {
    class { "ufw":
        forward => "ACCEPT",
    }

    ufw::allow { "allow-ssh-from-all":
        port    => "22",
        proto   => "tcp",
    }
    ufw::allow { "allow-http-from-all":
        port    => "80",
        proto   => "tcp",
    }
    ufw::allow { "allow-https-from-all":
        port    => "443",
        proto   => "tcp",
    }
    ufw::allow { "allow-monit-from-all":
        port    => "2812",
        proto   => "tcp",
    }
    ufw::allow { "allow-supervisorctl-from-all":
        port    => "9009",
        proto   => "tcp",
    }
    ufw::allow { "allow-ntp-from-all":
        port    => "123",
        proto   => "udp",
    }

    ufw::limit { "22": }
}