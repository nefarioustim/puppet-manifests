class user($username, $groupname) {
    group { $groupname:
        ensure => present,
    }
    user { $username:
        ensure => present,
        groups => [
            "sudo",
            $groupname
        ],
        require => Group[$groupname]
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
        require => User[$username]
    }
    file { "/home/${username}/.inputrc":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/inputrc.erb"),
        require => User[$username]
    }
    file { "/home/${username}/.tmux.conf":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/tmux.conf.erb"),
        require => User[$username]
    }
    file { "/home/${username}/.environment":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/environment.erb"),
        require => User[$username]
    }
    file { "/home/${username}/.bash_aliases":
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/bash_aliases.erb"),
        require => User[$username]
    }
    file { "aws-config-path":
        path   => "/home/${username}/.aws",
        ensure => directory,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        require => User[$username]
    }
    file { "aws-config-path-root":
        path   => "/root/.aws",
        ensure => directory,
        mode   => 644,
    }
    file { "aws-config":
        path   => "/home/${username}/.aws/config",
        ensure => present,
        owner  => $username,
        group  => $groupname,
        mode   => 644,
        content => template("user/awsconfig.erb"),
        require => [
            User[$username],
            File["aws-config-path"]
        ]
    }
    file { "aws-config-root":
        path   => "/root/.aws/config",
        ensure => present,
        mode   => 644,
        content => template("user/awsconfig.erb"),
        require => File["aws-config-path"]
    }
}
