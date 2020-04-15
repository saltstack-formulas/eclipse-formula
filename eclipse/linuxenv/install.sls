# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

eclipse-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/eclipse
    - target: {{ eclipse.pkg.archive.name }}
    - onlyif: test -d {{ eclipse.pkg.archive.name }}
    - force: True

        {% if eclipse.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

eclipse-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: eclipsehome
    - link: /opt/eclipse
    - path: {{ eclipse.pkg.archive.name }}
    - priority: {{ eclipse.linux.altpriority }}
    - retry: {{ eclipse.retry_option }}

eclipse-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: eclipsehome
    - path: {{ eclipse.pkg.archive.name }}
    - onchanges:
      - alternatives: eclipse-linuxenv-home-alternatives-install
    - retry: {{ eclipse.retry_option }}

eclipse-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: eclipse
    - link: {{ eclipse.linux.symlink }}
    - path: {{ eclipse.pkg.archive.name }}/eclipse
    - priority: {{ eclipse.linux.altpriority }}
    - require:
      - alternatives: eclipse-linuxenv-home-alternatives-install
      - alternatives: eclipse-linuxenv-home-alternatives-set
    - retry: {{ eclipse.retry_option }}

eclipse-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: eclipse
    - path: {{ eclipse.pkg.archive.name }}/eclipse
    - onchanges:
      - alternatives: eclipse-linuxenv-executable-alternatives-install
    - retry: {{ eclipse.retry_option }}

        {% endif %}
    {% endif %}
