define supervisorprog($user, $command, $directory, $numprocs = 1, $autostart = true, $enviro = '') {
    include python::supervisord

    file { "/etc/supervisor.d/${title}.conf":
        content => template("supervisorprog/program.conf.erb"),
        notify => Service["supervisord"]
    }
}
