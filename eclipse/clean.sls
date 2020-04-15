# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}

    {%- if grains.kernel|lower in ('linux', 'darwin',) %}

include:
  - {{ '.macapp' if eclipse.pkg.use_upstream_macapp else '.archive' }}.clean
  - .config.clean
  - .developer.clean
  - .plugins.clean
  - .linuxenv.clean

    {%- else %}

eclipse-not-available-to-install:
  test.show_notification:
    - text: |
        The eclipse package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
