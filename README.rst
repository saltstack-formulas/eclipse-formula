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

``eclipse-java.env``
----------------
Full integration with linux alternatives system

``eclipse-java.plugins``
---------------------
Extend Eclipse with popular plugins sourced via URL and set up and configure via Eclipse IDE API.

Please see the pillar.example for configuration.
Tested on Ubuntu 16.04, Fedora 25
