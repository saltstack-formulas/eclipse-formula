# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'environ' in eclipse and eclipse.environ %}
    {%- if eclipse.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

eclipse-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ eclipse.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='eclipse-config-file-file-managed-environ_file'
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
        environ: {{ eclipse.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
