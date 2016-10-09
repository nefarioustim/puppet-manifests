class instaredis {
    class { 'redis':
        manage_repo => true,
        appendonly  => true,
    }
}
