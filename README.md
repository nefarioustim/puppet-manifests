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

*   [__apt__][4]

    A lightweight alternative to the heavier [PuppetLabs apt module][3]. Allows you to add PPA sources to your sources.list.

*   [__hostname__][5]

    Allows you to update the hostname of your server.

*   [__libxml__][6]

    Installs the basic libxml packages.

*   [__logrotate__][7]

    Basic class and defined type for setting up logrotate on your logs.

*   [__mysql__][8]

    Parameterised class to install MySQL, set the root password, and create a vagrant user.

*   [__nginx__][9]

    Install nginx, provision nginx.conf and upstream.conf, and remove the default site. Will add virtual host support soon.

*   [__nodejs__][10]

    Install Node from the official PPA.

*   [__npm-provider__][11]

    A Puppet npm provider, allowing you to install packages with npm.

*   [__php__][12]

    Install the latest PHP5 from a PPA, and use an optional parameter to define which DB bindings to install.

*   [__postgres__][13]

    Installs PostGreSQL, recreates the primary cluster to use UTF-8, and adds defined types for adding roles and DBs.

*   [__python__][14]

    Basic set up for Python. Expects you to use virtualenv and pip to provision project specific requirements.

*   [__ruby__][15]

    Basic set up for Ruby and Gems. Needs to be updated to correctly depend on bundler to handle Gem provisioning.

*   [__user__][16]

    Parameterised class to set up a user with a nice environment and profile.

[1]: https://github.com/rodjek/librarian-puppet
[2]: https://github.com/puppetlabs
[3]: https://github.com/puppetlabs/puppetlabs-apt
[4]: modules/apt/manifests/init.pp
[5]: modules/hostname/manifests/init.pp
[6]: modules/libxml/manifests/init.pp
[7]: modules/logrotate/manifests/init.pp
[8]: modules/mysql/manifests/init.pp
[9]: modules/nginx/manifests/init.pp
[10]: modules/nodejs/manifests/init.pp
[11]: modules/npm-provider/lib/puppet/provider/package/npm.rb
[12]: modules/php/manifests/init.pp
[13]: modules/postgres/manifests/init.pp
[14]: modules/python/manifests/init.pp
[15]: modules/ruby/manifests/init.pp
[16]: modules/user/manifests/init.pp