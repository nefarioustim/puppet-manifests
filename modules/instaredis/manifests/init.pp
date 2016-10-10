class instaredis {
    apt::ppa { "ppa:chris-lea/redis-server": }

    package { "redis-server":
        ensure => latest,
        require => Apt::Ppa["ppa:chris-lea/redis-server"],
    }

    # file { "/etc/redis/redis.conf":
    #     ensure => file,
    #     content => template("redis/redis.conf.erb"),
    #     require => Package["redis-server"],
    #     notify => Service["redis-server"]
    # }

    service { "redis-server":
        ensure => running,
        subscribe => File["/etc/redis/redis.conf"],
        require => Package["redis-server"]
    }
}
