# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}

{%- if 'config' in eclipse and eclipse.config %}
       {%- if eclipse.pkg.use_upstream_macapp %}
           {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
       {%- else %}
           {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
       {%- endif %}

include:
  - {{ sls_package_clean }}

eclipse-config-clean-file-absent:
  file.absent:
    - names:
      - {{ eclipse.config_file }}
      - {{ eclipse.environ_file }}
    - require:
      - sls: {{ sls_package_clean }}

{%- endif %}
