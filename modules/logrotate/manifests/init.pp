# ensure logrotate package is installed
# ensure that /etc/logrotate.d exists
# drop files in /etc/logrotate.d

class logrotate::base {
    package { logrotate:
        ensure => installed,
    }

    file { "/etc/logrotate.d":
        ensure => directory,
        owner => root,
        group => root,
        mode => "0755",
        require => Package[logrotate],
    }
}

define logrotate::file( $log, $options, $postrotate = "NONE" ) {
    # $options should be an array containing 1 or more logrotate directives (e.g. missingok, compress)
    include logrotate::base

    file { "/etc/logrotate.d/${name}":
        owner => root,
        group => root,
        mode => "0644",
        content => template("logrotate/logrotate.tpl"),
        require => File["/etc/logrotate.d"],
    }
}

# logrotate::file { "puppetmaster-production-masterhttp.log":
#     log => "/var/log/puppet.production/masterhttp.log",
#     options => [ 'compress', 'weekly', 'rotate 4' ],
#     postrotate => "[ -e /etc/init.d/puppetmaster-production ] && /etc/init.d/puppetmaster-production condrestart >/dev/null 2>&1 || true",
# }