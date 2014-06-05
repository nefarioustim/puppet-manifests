class python::virtualenv {
    package { 'virtualenv':
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
    }
    package { 'virtualenvwrapper':
        ensure => latest,
        provider => pip,
        require => Package['virtualenv'],
    }
}
