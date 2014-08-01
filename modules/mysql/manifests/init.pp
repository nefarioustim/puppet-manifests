class mysql($root_password) {
    package { [
            "mysql-server",
            "mysql-client",
            "libmysqlclient-dev"
        ]:
        ensure => latest
    }

    file { "/etc/mysql/my.cnf":
        content => template("mysql/my.cnf.erb"),
        require => Package["mysql-server"],
        notify => Service["mysql"]
    }

    exec { "set-root-password":
        subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
        refreshonly => true,
        unless => "mysqladmin -uroot -p${root_password} status",
        path => "/bin:/usr/bin",
        command => "mysqladmin -uroot password ${root_password}",
    }

    exec { "create-vagrant-user-all":
      unless => "mysqladmin -uvagrant -pvagrant status",
      path => "/bin:/usr/bin",
      command => "mysql -uroot -p${root_password} -e \"CREATE USER vagrant@'%' IDENTIFIED BY 'vagrant'; GRANT ALL ON *.* TO vagrant@'%' WITH GRANT OPTION;\"",
      require => Service["mysql"],
    }

    exec { "create-vagrant-user-localhost":
      unless => "mysqladmin -uvagrant -pvagrant status",
      path => "/bin:/usr/bin",
      command => "mysql -uroot -p${root_password} -e \"CREATE USER vagrant@'localhost' IDENTIFIED BY 'vagrant'; GRANT ALL ON *.* TO vagrant@'localhost' WITH GRANT OPTION;\"",
      require => Service["mysql"],
    }

    service { "mysql":
        require => [ Package["mysql-server"], Exec["set-root-password"] ],
        hasstatus => true,
    }
}
