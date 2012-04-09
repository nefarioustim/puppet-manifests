define rename() {
    $alias = regsubst($name, '^([^.]*).*$', '\1')

    host { "newhost":
        ensure => present,
        ip     => $ipaddress,
        name  => "$title",
        host_aliases  => $alias ? {
            "$title" => undef,
            default     => $alias,
        },
        before => Exec['hostname'],
    }

    file { '/etc/mailname':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 644,
        content => "${name}\n",
    }

    file { '/etc/hostname':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => 644,
        content => "${name}\n",
        notify  => Exec['hostname'],
    }

    exec { 'hostname':
        command     => '/etc/init.d/hostname start',
        refreshonly => true,
    }
}
