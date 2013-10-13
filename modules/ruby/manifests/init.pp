class ruby {
    package { [
            "ruby1.9.1",
            "rubygems"
        ]:
        ensure => latest
    }
    package { [
            "compass"
        ]:
        ensure => latest,
        provider => "gem",
        require => Package["rubygems"]
    }
}