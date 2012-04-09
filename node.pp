import "aptrepo.pp"

class chrisleappa {
    pparepo { "chris-lea/node.js":
        apt_key => "C7917B12",
        ensure => present
    }
}

class nodejs {
    require chrisleappa

    package { [
            "nodejs",
            "npm"
        ]:
        ensure => latest,
        require => Class['chrisleappa']
    }
}
