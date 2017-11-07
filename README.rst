========
eclipse
========

Formula to configure the selected Eclipse release and edition (default java) published by the Eclipse Foundation packaging project (epp), and mirrored by IBM. The table below shows supported eclipse edition codes:

- java (formula default) = Eclipse IDE for Java
- jee = Eclipse IDE for Java EE
- cpp = Eclipse IDE for C/C++
- committers = Eclipse IDE for Eclipse Committers
- php = Eclipse for PHP
- dsl = Eclipse for DSL
- javascript = Eclipse for JavaScript and Web
- modeling = Eclipse Modelling tools
- rcp = Eclipse IDE for RCP
- parallel = Eclipse IDE for Parallel Applications
- testing = Eclipse for Testers
- scout = Eclipse for Scout

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``eclipse``
------------
Downloads the archive from Eclipse Foundation website, unpacks locally and installs the IDE on the Operating System.


``eclipse.developer``
------------
Create Desktop shortcuts. Optionally get preferences file from url/share and save into 'user' (pillar) home directory.


``eclipse.plugins``
---------------------
Extend with popular plugins sourced via URL and natively installed via the eclipse IDE API


``eclipse.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for debian alternatives in supported Linux distributions (i.e. not Archlinux).

.. note::

Enable Debian alternatives by setting nonzero 'altpriority' pillar value; otherwise feature is disabled.


Please see the pillar.example for configuration.
Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
