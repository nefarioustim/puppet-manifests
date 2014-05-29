class python::supervisor {
    package { 'supervisor':
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
    }
    file { "/etc/supervisor.d":
        ensure => directory,
        owner => root,
        group => root,
        mode => 655,
    }
    file { "/etc/supervisord.conf":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:///modules/python/supervisord.conf",
    }
    file { "/etc/init.d/supervisord":
        owner  => root,
        group  => root,
        mode   => 655,
        source => "puppet:///modules/python/supervisord.initd",
    }
    service { "supervisord":
        ensure => stopped,
        hasrestart => true,
    }
}
