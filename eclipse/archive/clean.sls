# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}

eclipse-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ eclipse.pkg.archive.name }}
      - {{ eclipse.dir.archive }}/eclipse
