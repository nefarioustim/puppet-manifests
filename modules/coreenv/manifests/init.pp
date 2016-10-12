class coreenv {
    include apt

    package { [
            "libffi-dev",
            "python-software-properties",
            "python-pip",
            "tmux",
            "vim",
            "curl",
            "ufw"
        ]:
        ensure => latest,
        require => Class["apt"]
    }
}
