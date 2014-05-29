class python::virtualenv {
    package { 'virtualenv':
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
    }
}
