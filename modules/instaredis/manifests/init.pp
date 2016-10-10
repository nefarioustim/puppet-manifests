class instaredis {
    package { "redis-server":
        ensure => latest
    }

    file { "/etc/redis/redis.conf":
        ensure => file,
        content => template("redis/redis.conf.erb"),
        require => Package["redis-server"],
        notify => Service["redis-server"]
    }

    service { "redis-server":
        ensure => running,
        subscribe => File["/etc/redis/redis.conf"],
        require => Package["redis-server"]
    }
}
