class python3 {
    package { [
            'python',
            'python-dev',
            'python-pip',
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
        provider => pip3,
        require => Package['python3-pip', 'python-pip'],
    }
}
