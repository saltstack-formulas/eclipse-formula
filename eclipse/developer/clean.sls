# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

eclipse-developer-clean-file-absent:
  file.absent:
    - names:
      - {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/Desktop/Eclipse
      - /tmp/mac_shortcut.sh
      - {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/Desktop/Eclipse.desktop
