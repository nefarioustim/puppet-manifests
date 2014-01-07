#----------------------------------------
# Example base manifest
#----------------------------------------

# Set up provisioning stages. I usually keep this to three:
#
# pre for apt configuration, apt update/upgrade, and base packages
# main for most of the work
# last for final stage things like creating DB schemas

$project_name = 'my-project'  # Used as a directory reference in user module

stage { "pre": before => Stage["main"] }
stage { "last": require => Stage["main"] }

# A basic class which represents stuff for my pre phase

class devbox {
    hostname { "update-hostname":
        hostname => "magento.nefariousdesigns.co.uk"
    }
    exec { "aptupdate":
        command => "aptitude update --quiet --assume-yes",
        user => "root",
        timeout => 0,
    }
    group { "puppet":
        ensure => present,
    }
    package { "build-essential":
        ensure => latest,
    }
    package { [
            "python-software-properties",
            "tmux",
            "vim",
            "curl",
            "git",
            "git-flow",
            "aptitude",
            "memcached",
        ]:
        ensure => latest,
        require => Exec["aptupdate"]
    }
}

# Assign classes to phases

class { "devbox": stage => pre }

# Set-up a vagrant user using the user module

if $virtual == 'virtualbox' {
    class { "user":
        stage => pre,
        username => 'vagrant',
        groupname => 'vagrant'
    }
}

include nginx # Include a basic module

class { "mysql": root_password => "monkeys" } # Include a parameterised class

class { "php": db_binding => "mysql" }
include php::composer

include nodejs
