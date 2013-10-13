class postgres {
    package { [
            "postgresql",
            "libpq-dev",
        ]:
        ensure => latest,
    }

    exec { "rebuild-cluster-as-utf8":
        command => "pg_dropcluster --stop 9.1 main;pg_createcluster --start -e UTF-8 9.1 main",
        onlyif => "test \$(su -c 'psql -lx' postgres | awk '/Encoding/ {printf tolower(\$3)}') = 'sql_asciisql_asciisql_ascii'",
        timeout => 60,
        environment => "PWD=/",
        notify => Service["postgresql"],
        require => Package["postgresql"],
    }

    service { "postgresql":
        ensure => running,
        enable => true,
        hasstatus => true,
        hasrestart => true,
        require => Package["postgresql"],
    }
}

define postgres::role($ensure, $password = false) {
    $passtext = $password ? {
        false => "",
        default => "PASSWORD '$password'"
    }
    case $ensure {
        present: {
            # The createuser command always prompts for the password.
            exec { "Create $name postgres role":
                command => "/usr/bin/psql -c \"CREATE ROLE $name WITH $passtext LOGIN\"",
                user => "postgres",
                unless => "/usr/bin/psql -c '\\du' | grep '^  *$name  *|'"
            }
        }
        absent:  {
            exec { "Remove $name postgres role":
                command => "/usr/bin/dropeuser $name",
                user => "postgres",
                onlyif => "/usr/bin/psql -c '\\du' | grep '$name  *|'"
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for postgres::role"
        }
    }
}

define postgres::database($ensure, $owner = false) {
    $ownerstring = $owner ? {
        false => "",
        default => "-O $owner"
    }
    case $ensure {
        present: {
            exec { "Create $name postgres db":
                command => "/usr/bin/createdb -E UTF8 $ownerstring $name",
                user => "postgres",
                unless => "/usr/bin/psql -l | grep '$name  *|'"
            }
        }
        absent:  {
            exec { "Remove $name postgres db":
                command => "/usr/bin/drop $name",
                onlyif => "/usr/bin/psql -l | grep '$name  *|'",
                user => "postgres"
            }
        }
        default: {
            fail "Invalid 'ensure' value '$ensure' for postgres::database"
        }
    }
}
