class magento( $db_username, $db_password, $version, $admin_username, $admin_password, $use_rewrites, $use_sample_data = false) {
    exec { "create-magentodb-db":
        unless => "/usr/bin/mysql -uroot -p${mysql::root_password} magentodb",
        command => "/usr/bin/mysqladmin -uroot -p${mysql::root_password} create magentodb",
        require => Service["mysql"]
    }

    exec { "grant-magentodb-db-all":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'%' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => [
            Service["mysql"],
            Exec["create-magentodb-db"]
        ]
    }

    exec { "grant-magentodb-db-localhost":
        unless => "/usr/bin/mysql -u${db_username} -p${db_password} magentodb",
        command => "/usr/bin/mysql -uroot -p${$mysql::root_password} -e \"grant all on *.* to magento@'localhost' identified by '${db_password}' WITH GRANT OPTION;\"",
        require => Exec["grant-magentodb-db-all"]
    }

    exec { "download-magento":
        cwd => "/tmp",
        command => "curl -O http://www.magentocommerce.com/downloads/assets/${version}/magento-${version}.tar.gz",
        creates => "/tmp/magento-${version}.tar.gz",
        require => Package["curl"]
    }

    exec { "untar-magento":
        cwd => "${::project_root}/public/",
        user  => "vagrant",
        command => "/bin/tar xvzf /tmp/magento-${version}.tar.gz",
        creates => "${::project_root}/public/magento",
        require => [
            Exec["download-magento"],
            User["vagrant"],
        ]
    }

    if $use_sample_data == true {
        exec { "sample-data-download":
            cwd => "/tmp",
            command => "curl -O http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz",
            creates => "/tmp/magento-sample-data-1.6.1.0.tar.gz",
            require => Package["curl"]
        }

        exec { "sample-data-untar":
            cwd => "/tmp",
            user  => "vagrant",
            command => "/bin/tar xvzf /tmp/magento-sample-data-1.6.1.0.tar.gz",
            creates => "/tmp/magento-sample-data-1.6.1.0",
            require => [
                Exec["sample-data-download"],
                User["vagrant"],
            ]
        }

        exec { "sample-data-copy-catalog":
            cwd => "${::project_root}/public/magento/media",
            user  => "vagrant",
            command => "cp -R /tmp/magento-sample-data-1.6.1.0/media/catalog .",
            require => [
                Exec["sample-data-untar"],
                Exec["untar-magento"]
            ]
        }

        exec { "sample-data-import-db":
            command => "/usr/bin/mysql -uroot -p${mysql::root_password} magentodb < /tmp/magento-sample-data-1.6.1.0/magento_sample_data_for_1.6.1.0.sql",
            require => [
                Exec["create-magentodb-db"],
                Exec["sample-data-copy-catalog"]
            ]
        }
    }

    exec { "setting-permissions":
        cwd => "${::project_root}/public/magento",
        command => "/bin/chmod 550 mage; /bin/chmod o+w var app/etc; /bin/chmod -R a+w media",
        require => [
            Exec["sample-data-import-db"],
            Exec["untar-magento"]
        ]
    }

    exec { "install-magento":
        cwd => "${::project_root}/public/magento",
        user => "vagrant",
        creates => "${::project_root}/public/magento/app/etc/local.xml",
        command => "/usr/bin/php -f install.php -- \
        --license_agreement_accepted \"yes\" \
        --locale \"en_GB\" \
        --timezone \"Europe/London\" \
        --default_currency \"GBP\" \
        --db_host \"localhost\" \
        --db_name \"magentodb\" \
        --db_user \"${db_username}\" \
        --db_pass \"${db_password}\" \
        --url \"http://magento.nefariousdesigns.co.uk\" \
        --use_rewrites \"${use_rewrites}\" \
        --use_secure \"no\" \
        --secure_base_url \"http://magento.nefariousdesigns.co.uk\" \
        --use_secure_admin \"no\" \
        --skip_url_validation \"yes\" \
        --admin_firstname \"Store\" \
        --admin_lastname \"Owner\" \
        --admin_email \"magento@example.com\" \
        --admin_username \"${admin_username}\" \
        --admin_password \"${admin_password}\"",
        require => [
            Package["php5-cli"],
            Exec["setting-permissions"],
            Exec["create-magentodb-db"]
        ],
    }

exec { "register-magento-channel":
    cwd     => "${::project_root}/public/magento",
    onlyif  => "/usr/bin/test `${::project_root}/public/magento/mage list-channels | wc -l` -lt 2",
    command => "${::project_root}/public/magento/mage mage-setup",
    require => Exec["install-magento"]
}
}
