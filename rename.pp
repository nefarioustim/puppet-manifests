define rename() {
    host { "$hostname": ensure => absent }

    host { "$fqdn": ensure => absent }

    $alias = regsubst($name, '^([^.]*).*$', '\1')

    host { "$name":
        ensure => present,
        ip     => $ipaddress,
        alias  => $alias ? {
            "$hostname" => undef,
            default     => $alias
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
