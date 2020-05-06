# -*- coding: utf-8 -*-
# vim: ft=yaml
---
eclipse:
  # editions: java,jee,cpp,committers,php,dsl,
  #           javascript,modeling,rcp,parallel,testing,scout
  edition: cpp
  release: 2020-03
  version: R-incubation
  environ_file: /etc/default/eclipse.sh
  environ:
    a: b
  identity:
    user: root
  pkg:
    use_upstream_archive: true
    use_upstream_macapp: false
    deps:
      - curl
      - tar
      - gzip
        {%- if grains.os_family == 'Debian' %}
      - default-jre
        {%- elif grains.os_family == 'RedHat' %}
      - java-11-openjdk-devel
      - java-11-openjdk
        {%- elif grains.os_family == 'Suse' %}
      - java-1_8_0-openjdk-devel
        {%- elif grains.os_family == 'Arch' %}
      - jre-openjdk
        {%- endif %}
    archive:
      uri: http://eclipse.bluemix.net/packages
      # yamllint disable-line rule:line-length
      source_hash: https://eclipse.bluemix.net/packages/2020-03/data/eclipse-cpp-2020-03-R-incubation-linux-gtk-x86_64.tar.gz.sha512
  linux:
    symlink: /usr/local/bin/eclipse
    altpriority: 171
