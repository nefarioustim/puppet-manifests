class python3 {
    package { [
            'python3',
            'python3-dev',
            'python3-pip'
        ]:
        ensure => latest,
    }
    package { [
            'pipenv'
        ]:
        ensure => latest,
        provider => pip,
        require => Package['python3-pip'],
    }
}
