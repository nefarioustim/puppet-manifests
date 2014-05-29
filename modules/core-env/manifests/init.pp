class core-env {
    package { [
            "python-software-properties",
            "python-pip",
            "tmux",
            "vim",
            "curl",
        ]:
        ensure => latest
    }
}
