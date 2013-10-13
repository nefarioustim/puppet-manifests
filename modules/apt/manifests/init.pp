class apt {}

# Setup a PPA repo, where the name is "user/ppaname", e.g. "blueyed/ppa" ("ppa" being the default)
define apt::pparepo($apt_key = "", $ensure = present, $keyserver = "keyserver.ubuntu.com") {
    $name_for_file = regsubst($name, '/', '-', 'G')

    $file = "/etc/apt/sources.list.d/pparepo-${name_for_file}.list"
    file { "$file": }

    case $ensure {
        present: {
            File["$file"] {
                content => "deb http://ppa.launchpad.net/$name/ubuntu precise main\n",
                notify => Exec["apt-update-${name}"]
            }
            File["$file"] { ensure => file }
            apt::key { "$apt_key": }
            exec { "apt-update-${name}":
                refreshonly => true,
                command => "/usr/bin/apt-get update",
                require => [Apt::Key["$apt_key"], File["$file"]]
            }
        }
        absent:  {
            File["$file"] { ensure => false }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for pparepo"
        }
    }
}

# source http://projects.puppetlabs.com/projects/1/wiki/Apt_Keys_Patterns
define apt::key($ensure = present, $keyserver = "keyserver.ubuntu.com") {
    $grep_for_key = "apt-key list | grep '^pub' | sed -r 's.^pub\\s+\\w+/..' | grep '^$name'"
        case $ensure {
        present: {
            exec { "Import $name to apt keystore":
                path        => "/bin:/usr/bin",
                environment => "HOME=/root",
                command     => "gpg --keyserver $keyserver --recv-keys $name && gpg --export --armor $name | apt-key add -",
                user        => "root",
                group       => "root",
                unless      => "$grep_for_key",
                logoutput   => on_failure,
            }
        }
        absent:  {
            exec { "Remove $name from apt keystore":
                path    => "/bin:/usr/bin",
                environment => "HOME=/root",
                command => "apt-key del $name",
                user    => "root",
                group   => "root",
                onlyif  => "$grep_for_key",
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for apt::key"
        }
    }
}
