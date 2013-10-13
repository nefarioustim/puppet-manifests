class ondrejppa {
    include apt

    apt::pparepo { "ondrej/php5":
        apt_key => "E5267A6C",
        ensure => present
    }
}

class php($db_binding = false) {
    require ondrejppa

    package { [
            "php5-fpm",
            "php5-cli",
            "php-pear",
            "php5-mcrypt",
            "php5-gd",
        ]:
        ensure => latest,
        require => Class['ondrejppa'],
    }

    package { "php5-curl":
        require => Package["curl"]
    }

    case $db_binding {
        "mysql":        { package { "php5-mysql": ensure => latest } }
        "postgresql":   { package { "php5-pgsql": ensure => latest } }
    }

    file { "/etc/php5/fpm/php.ini":
        content => template("php/php.ini.erb"),
        notify => Service["php5-fpm"],
        require => Package["php5-fpm"]
    }

    service { "php5-fpm":
        ensure => running,
        hasrestart => true,
        require => Package["php5-fpm"],
    }
}

class php::composer {
    exec { "getcomposer":
        command => "curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer",
        user => "root",
        creates => "/usr/local/bin/composer",
        require => [
            Class["php"],
            Package["curl"]
        ],
    }
}
