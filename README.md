Puppet manifests
================

A small collection of Puppet modules which I reuse alongside Vagrant when building development VM environments. I have stuck some basic annotation in the files, and I will endeavour to keep these up to date as I write more.

Feel free to fork and add your own; I'm always interested in doing less work. At the moment this is a quick and dirty set of examples that I've hacked together in preparation for a blog post.

A note on structure
-----

Originally this was a flat repository of `.pp` manifest files. However, as my experience with Puppet has grown, I've started to build up an extensive library of separated _modules_ which allows me to parachute them in an out as I see fit.

In production, this often means using third-party modules added to your repo using git submodules (which can be a bit nasty) and then included into your base manifest. The more modern alternative is to use [Librarian Puppet][1] to handle this; giving you a better ability to include modules from [PuppetLabs][2] via git.

Summary of modules
-----

*   ### apt

    A lightweight alternative to the heavier [PuppetLabs apt module][3]. Allows you to add PPA sources to your sources.list.

*   ### hostname

    Allows you to update the hostname of your server.

*   ### libxml

    Installs the basic libxml packages.

*   ### logrotate

    Basic class and defined type for setting up logrotate on your logs.

*   ### mysql

    Parameterised class to install MySQL, set the root password, and create a vagrant user.

*   ### nginx

    Install nginx, provision nginx.conf and upstream.conf, and remove the default site. Will add virtual host support soon.

*   ### nodejs

    Install Node from the official PPA.

*   ### npm-provider

    A Puppet npm provider, allowing you to install packages with npm.

*   ### php

    Install the latest PHP5 from a PPA, and use an optional parameter to define which DB bindings to install.

*   ### postgres

    Installs PostGreSQL, recreates the primary cluster to use UTF-8, and adds defined types for adding roles and DBs.

*   ### python

    Basic set up for Python. Expects you to use virtualenv and pip to provision project specific requirements.

*   ### ruby

    Basic set up for Ruby and Gems. Needs to be updated to correctly depend on bundler to handle Gem provisioning.

*   ### user

    Parameterised class to set up a user with a nice environment and profile.

[1]: https://github.com/rodjek/librarian-puppet
[2]: https://github.com/puppetlabs
[3]: https://github.com/puppetlabs/puppetlabs-apt
