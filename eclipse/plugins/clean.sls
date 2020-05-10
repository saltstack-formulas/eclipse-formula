# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

eclipse-plugins-extensions-config-clean:
  file.absent:
    - names:
      - {{ eclipse.dir.workspace }}/configure-plugins.sh*
      - {{ eclipse.dir.plugins }}/{{ eclipse.plugins.svn.prefs_path }}
      - {{ eclipse.dir.homes }}{{ eclipse.identity.user }}/.subversion
