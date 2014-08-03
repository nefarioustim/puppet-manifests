class ruby {
    package { "bundler":
        ensure => latest,
        provider => "gem"
    }
}