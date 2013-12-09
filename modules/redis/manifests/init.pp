class redis {
    apt::pparepo { "rwky/redis":
        apt_key => "5862E31D",
        ensure => present
    }

    package {'redis-server':
        ensure => latest,
        require => Apt::Pparepo["rwky/redis"],
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
