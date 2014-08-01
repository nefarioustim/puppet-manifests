class redis {
    apt::ppa { "ppa:rwky/redis": }

    package {'redis-server':
        ensure => latest,
        require => Apt::Ppa["rwky/redis"],
    }

    file {'/etc/redis/redis.conf':
        ensure => file,
        content => template("redis/redis.conf.erb"),
        require => Package['redis-server'],
    }

    service {'redis-server':
        ensure => running,
        subscribe => File['/etc/redis/redis.conf'],
        require => Package['redis-server']
    }
}
