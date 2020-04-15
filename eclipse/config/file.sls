# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in eclipse and eclipse.config %}

    {%- if eclipse.pkg.use_upstream_source %}
        {%- set sls_package_install = tplroot ~ '.source.install' %}
    {%- elif eclipse.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.package.install' %}
    {%- endif %}
include:
  - {{ sls_package_install }}

eclipse-config-npmrc-file-managed-config_file:
  file.managed:
    - name: {{ eclipse.config_file }}
    - source: {{ files_switch(['npmrc.default.jinja'],
                              lookup='eclipse-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ eclipse.identity.rootuser }}
    - group: {{ eclipse.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
              {%- if eclipse.pkg.use_upstream_macapp %}
        path: {{ eclipse.pkg.macapp.name }}
              {%- else %}
        path: {{ eclipse.pkg.archive.name }}
              {%- endif %}
        config: {{ eclipse.config|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
