# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}

eclipse-macos-app-install-curl:
  file.directory:
    - name: {{ eclipse.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ eclipse.dir.tmp }}/eclipse-{{ eclipse.version }} {{ eclipse.pkg.macapp.source }}
    - unless: test -f {{ eclipse.dir.tmp }}/eclipse-{{ eclipse.version }}
    - require:
      - file: eclipse-macos-app-install-curl
      - pkg: eclipse-macos-app-install-curl
    - retry: {{ eclipse.retry_option }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
eclipse-macos-app-install-checksum:
  module.run:
    - onlyif: {{ eclipse.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ eclipse.dir.tmp }}/eclipse-{{ eclipse.version }}
    - file_hash: {{ eclipse.pkg.macapp.source_hash }}
    - require:
      - cmd: eclipse-macos-app-install-curl
    - require_in:
      - macpackage: eclipse-macos-app-install-macpackage
  file.absent:
    - name: {{ eclipse.dir.tmp }}/eclipse-{{ eclipse.version }}
    - onfail:
      - module: eclipse-macos-app-install-checksum

eclipse-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ eclipse.dir.tmp }}/eclipse-{{ eclipse.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: eclipse-macos-app-install-curl

    {%- else %}

eclipse-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The eclipse macpackage is only available on MacOS

    {%- endif %}
