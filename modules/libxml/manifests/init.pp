class libxml {
    package { "libxml2":
        ensure => latest,
    }

    package { "libxslt1.1":
        ensure => latest,
    }

    package { "libxml2-dev":
        ensure => latest,
    }

    package { "libxslt-dev":
        ensure => latest,
    }
}
