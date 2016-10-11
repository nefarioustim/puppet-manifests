class instaredis {
    apt::ppa { "ppa:chris-lea/redis-server": }

    package { "redis-server":
        ensure => latest,
        require => Apt::Ppa["ppa:chris-lea/redis-server"],
    }

    file { "/etc/redis/redis.conf":
        owner       => root,
        group       => root,
        mode        => "0644",
        content => template("instaredis/redis.conf.erb"),
        require => Package["redis-server"],
        notify => Service["redis-server"]
    }

    service { "redis-server":
        ensure => running,
        subscribe => File["/etc/redis/redis.conf"],
        require => Package["redis-server"]
    }
}
