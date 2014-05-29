class python {
    package { [
            'python',
            'python-dev'
        ]:
        ensure => latest,
    }
}
