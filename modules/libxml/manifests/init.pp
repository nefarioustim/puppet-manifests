class libxml {
    package { [
            "libxml2",
            "libxslt1.1",
            "libxml2-dev",
            "libxslt-dev",
        ]:
        ensure => latest,
    }
}
