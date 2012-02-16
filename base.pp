#----------------------------------------
# Example base manifest
#----------------------------------------

# Import the manifests you require

import "python.pp"
import "nginx.pp"
import "node.pp"

# Set up provisioning stages. I usually keep this to three:
#
# pre for apt configuration, apt update/upgrade, and base packages
# main for most of the work
# last for final stage things like creating DB schemas

stage { "pre": before => Stage["main"] }
stage { "last": require => Stage["main"] }

# A basic class which represents stuff for my pre phase

class devbox {
    exec { "add-apt-repository ppa:chris-lea/node.js":
        path => "/usr/bin",
        user => "root",
        before => Exec["aptupdate"]
    }
    exec { "aptitude update --quiet --assume-yes":
        alias => "aptupdate",
        path => "/usr/bin",
        user => "root",
        timeout => 0,
        before => Package["build-essential"],
    }
    user { "vagrant":
        groups => [
            "sudo"
        ]
    }
    group { "puppet":
        ensure => present,
    }
    package { "build-essential":
        ensure => latest,
        before => Package["vim"],
    }
    package { [
            "vim",
            "python-software-properties",
            "aptitude"
        ]:
        ensure => latest,
    }
    package { "memcached":
        ensure => latest,
        before => Package["python-memcached"],
    }
    file { "/home/vagrant/.bashrc":
        owner  => vagrant,
        group  => vagrant,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/bashrc",
    }
    file { "/home/vagrant/.bash_aliases":
        owner  => vagrant,
        group  => vagrant,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/bash_aliases",
    }
    file { "/etc/motd":
        owner  => root,
        group  => root,
        mode   => 644,
        source => "puppet:////vagrant/puppet/files/motd",
    }
}

# Assign classes to phases

class { "devbox": stage => pre }

# Include imported classes (import doesn't do this automatically)

include python
include nginx
include nodejs
