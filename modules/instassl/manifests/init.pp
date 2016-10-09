class instassl {
    class { "openssl":
        package_ensure         => latest,
        ca_certificates_ensure => latest,
    }

    openssl::dhparam { 'dhparam.pem':
        ensure => 'present',
        size   => 4096,
        owner  => 'www-data',
        group  => 'www-data',
        mode   => '0640',
        path   => '/etc/ssl/certs/dhparam.pem'
    }
}