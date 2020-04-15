# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}

eclipse-macos-app-clean-files:
  file.absent:
    - names:
      - {{ eclipse.dir.tmp }}
      - /Applications/Eclipse.app

    {%- else %}

eclipse-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The eclipse macpackage is only available on MacOS

    {%- endif %}
