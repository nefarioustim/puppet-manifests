class python {
    package { [
            'python',
            'python-dev'
        ]:
        ensure => latest,
    }
    package { [
            'pytest',
            'pytest-cov',
            'mock'
        ]:
        ensure => latest,
        provider => pip,
        require => Package['python-pip'],
    }
}
