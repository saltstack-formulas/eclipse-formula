========
eclipse-java
========

Formula to set up and configure Eclipse IDE (for Java) from tarball archive sourced via URL. 


.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``eclipse-java``
------------

Downloads the tarball from the eclipse-java:source_url configured as either a pillar or grain and will not do anything
if source_url is omitted. Then unpacks the archive into eclipse-java:prefix (defaults to /usr/share/java/eclipse-java).
Will use the alternatives system to link the installation to eclipse-java_home. Please see the pillar.example for configuration.

An addition to allow easy use - places a eclipse-java profile in /etc/profile.d - this way the PATH is set correctly for all system users.
An addition for extensibility - plugin-settings.sls - this way a default set of plugins are sourced via URL during set up and configuration of the Eclipse IDE.

Tested on Ubuntu 16.04

===
Release note
===
Further testing on Fedora/Centos is planned.
