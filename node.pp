class nodejs {
    package { [
            "nodejs",
            "npm"
        ]:
        ensure => latest
    }
}