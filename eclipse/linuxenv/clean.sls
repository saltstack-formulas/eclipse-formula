# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

eclipse-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/eclipse
      - {{ eclipse.pkg.archive.name }}

        {% if eclipse.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

eclipse-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: eclipsehome
    - path: {{ eclipse.pkg.archive.name }}

eclipse-linuxenv-executable-alternatives-set:
  alternatives.remove:
    - name: eclipse
    - path: {{ eclipse.pkg.archive.name }}/eclipse

        {% endif %}
    {% endif %}
