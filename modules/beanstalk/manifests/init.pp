class beanstalk ($status='running', $listen_addr='0.0.0.0', $listen_port='11300') {
    package { "beanstalkd":
        ensure => latest,
    }

    file { "beanstalkd-default":
        path => "/etc/default/beanstalkd",
        ensure => present,
        content => template('beanstalk/beanstalkd.erb'),
        notify => Service['beanstalkd'],
        require => Package['beanstalkd'],
    }

    service { "beanstalkd":
        ensure => $status,
        require => Package['beanstalkd'],
    }
}
