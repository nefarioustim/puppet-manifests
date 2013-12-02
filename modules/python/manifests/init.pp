class python($db_binding = false) {
    package { [
            'python',
            'python-dev',
            'python-setuptools'
        ]:
        ensure => latest,
    }
    exec { 'install-pip':
        command => 'easy_install pip',
        require => Package['python-setuptools'],
    }

    case $db_binding {
        "mysql": {
            package { "MySQL-python":
                ensure => latest,
                provider => pip,
                require => Exec['install-pip'],
            }
        }
        "postgresql": {
            package { "psycopg2":
                ensure => latest,
                provider => pip,
                require => Exec['install-pip'],
            }
        }
    }
}

class python::virtualenv {
    package { 'virtualenv':
        ensure => latest,
        provider => pip,
        require => Exec['install-pip'],
    }
}

class python::fabric {
    package { 'fabric':
        ensure => latest,
        provider => pip,
        require => Exec['install-pip'],
    }
}

class python::gunicorn {
    file { "/var/log/gunicorn":
        ensure => "directory",
        owner  => vagrant,
        group  => vagrant,
        mode   => 655,
    }
}

class python::supervisord {
    package { 'supervisor':
        ensure => latest,
        provider => pip,
        require => Exec['install-pip'],
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