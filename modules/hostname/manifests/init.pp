define hostname($name, $domain) {
    $hostname = "${name}.${domain}"

    host { "${hostname}":
        ensure  => present,
        ip      => $ipaddress,
        name    => $hostname,
        notify  => Service['hostname'],
    }

    file { '/etc/mailname':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => "0644",
        content => "${domain}\n",
    }

    file { '/etc/hostname':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => "0644",
        content => "${hostname}\n",
        notify => Service['hostname'],
    }

    service { "hostname":
        ensure => running,
        hasrestart => true
    }
}
