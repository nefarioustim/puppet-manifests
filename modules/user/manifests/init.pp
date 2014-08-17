class user($username = $name, $groupname, $projectpath) {
    group { $groupname:
        ensure => present,
    }
    user { $username:
        ensure => present,
        groups => [
            "sudo",
            $groupname
        ],
        shell => "/bin/bash",
        home => "/home/$username",
        require => Group[$groupname]
    }
    exec { "$username homedir":
        command => "/bin/cp -R /etc/skel /home/$username; /bin/chown -R $username:$groupname /home/$username",
        creates => "/home/$username",
        require => User[$username],
    }
    user { "www-data":
        ensure => present,
        groups => [$groupname],
    }
    file { "/home/${username}/.bashrc":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/bashrc.erb"),
        require => Exec["$username homedir"]
    }
    file { "/home/${username}/.inputrc":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/inputrc.erb"),
        require => Exec["$username homedir"]
    }
    file { "/home/${username}/.tmux.conf":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/tmux.conf.erb"),
        require => Exec["$username homedir"]
    }
    file { "/home/${username}/.environment":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/environment.erb"),
        require => Exec["$username homedir"]
    }
    file { "/home/${username}/.bash_aliases":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/bash_aliases.erb"),
        require => Exec["$username homedir"]
    }
    file { "aws-config-path":
        path   => "/home/${username}/.aws",
        ensure => directory,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        require => Exec["$username homedir"]
    }
    file { "aws-config":
        path   => "/home/${username}/.aws/config",
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/awsconfig.erb"),
        require => [
            Exec["$username homedir"],
            File["aws-config-path"]
        ]
    }
}
