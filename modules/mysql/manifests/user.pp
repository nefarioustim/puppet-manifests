define mysql::user($user = $title, $pass) {
    exec { "create-user-${user}-all":
        unless => "mysql -uroot -p${mysql::root_password} mysql -e \"SELECT user, host FROM user WHERE user='${user}' AND host='%';\"",
        path => "/bin:/usr/bin",
        command => "mysql -uroot -p${mysql::root_password} -e \"CREATE USER ${user}@'%' IDENTIFIED BY '${pass}'; GRANT ALL ON *.* TO ${user}@'%' WITH GRANT OPTION;\"",
        require => Class["mysql"],
    }

    exec { "create-user-${user}-localhost":
        unless => "mysql -uroot -p${mysql::root_password} mysql -e \"SELECT user, host FROM user WHERE user='${user}' AND host='localhost';\"",
        path => "/bin:/usr/bin",
        command => "mysql -uroot -p${mysql::root_password} -e \"CREATE USER ${user}@'localhost' IDENTIFIED BY '${pass}'; GRANT ALL ON *.* TO ${user}@'localhost' WITH GRANT OPTION;\"",
        require => Class["mysql"],
    }
}