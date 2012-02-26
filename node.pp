class nodejs {
    package { "python-software-properties":
        ensure => latest,
        before => Exec["addnoderepo"]
    }
    exec { "add-apt-repository ppa:chris-lea/node.js":
        alias => "addnoderepo",
        path => "/usr/bin",
        user => "root",
        before => Exec["aptupdate"]
    }
    exec { "aptitude update --quiet --assume-yes":
        alias => "aptupdate",
        path => "/usr/bin",
        user => "root",
        before => Package["nodejs"]
    }
    package { [
            "nodejs",
            "npm"
        ]:
        ensure => latest
    }
}