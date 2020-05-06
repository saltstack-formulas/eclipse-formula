# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

eclipse-package-archive-install:
  pkg.installed:
    - names: {{ eclipse.pkg.deps }}
    - require_in:
      - file: eclipse-package-archive-install
  file.directory:
    - name: {{ eclipse.pkg.archive.name }}
    - user: {{ eclipse.identity.rootuser }}
    - group: {{ eclipse.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: eclipse-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(eclipse.pkg.archive) }}
    - retry: {{ eclipse.retry_option }}
    - user: {{ eclipse.identity.rootuser }}
    - group: {{ eclipse.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: eclipse-package-archive-install

    {%- if eclipse.linux.altpriority|int == 0 %}

eclipse-archive-install-file-symlink-eclipse:
  file.symlink:
    - name: /usr/local/bin/eclipse
    - target: {{ eclipse.pkg.archive.name }}/eclipse
    - force: True
    - onlyif: {{ eclipse.kernel|lower != 'windows' }}
    - require:
      - archive: eclipse-package-archive-install

    {%- endif %}
