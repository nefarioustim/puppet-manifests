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
    user { "www-user":
        ensure => present,
        groups => [ "sudo" ]
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
}
