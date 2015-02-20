class coreenv {
    exec { "aptupdate":
        command => "aptitude update --quiet --assume-yes",
        user => "root",
        timeout => 0,
    }
    package { [
            "libffi-dev",
            "python-software-properties",
            "python-pip",
            "tmux",
            "vim",
            "curl",
        ]:
        ensure => latest,
        require => Exec["aptupdate"]
    }
}
