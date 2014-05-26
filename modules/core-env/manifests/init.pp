class core-env {
    package { [
            "python-software-properties",
            "tmux",
            "vim",
            "curl",
        ]:
        ensure => latest
    }
}
