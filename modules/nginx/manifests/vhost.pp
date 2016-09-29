class nginx::vhost($hostname, $location, $htpasswd = false) {
    file { 'vhost-file':
        path => "/etc/nginx/conf.d/${hostname}.conf",
        owner  => root,
        group  => root,
        mode   => "0644",
        content => template("nginx/vhost.conf.erb"),
        notify => Service["nginx"],
    }
}
