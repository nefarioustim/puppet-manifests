class chrisleappa {
    include apt

    apt::pparepo { "chris-lea/node.js":
        apt_key => "C7917B12",
        ensure => present
    }
}

class nodejs {
    require chrisleappa

    package { "nodejs":
        ensure => latest,
        require => Class['chrisleappa']
    }
}
