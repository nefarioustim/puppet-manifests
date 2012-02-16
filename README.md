Puppet manifests
================

A small collection of Puppet manifests which I reuse alongside Vagrant when building development VM environments. I have stuck some basic annotation in the files, and I will endeavour to keep these up to date as I write more.

Feel free to fork and add your own; I'm always interested in doing less work.

Current manifests
-----------------

* base.pp -- An example base manifest which will import and include others.
* nginx.pp -- A simple manifest for setting up nginx.
* node.pp -- A simple manifest for setting up NodeJS.
* python.pp -- A simple manifest for setting up Python, and a bunch of useful related libraries.
