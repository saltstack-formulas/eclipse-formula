# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if eclipse.identity.user and grains.os != 'Windows' %}

eclipse-plugins-extensions-config-install:
  file.managed:
    - name: '{{ eclipse.dir.workspace }}/configure-plugins.sh'
    - source: salt://eclipse/files/configure-plugins.shell
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: '{{ eclipse.identity.user }}'
    - force: True
    - context:
      home: '{{ eclipse.pkg.macapp.name if eclipse.pkg.use_upstream_macapp else eclipse.pkg.archive.name }}'
  cmd.run:
    - name: {{ eclipse.dir.workspace }}/configure-plugins.sh {{ eclipse.identity.user }}
    - cwd: {{ eclipse.dir.workspace }}
    - require:
      - file: eclipse-plugins-extensions-config-install
    - onlyif:
      - test -f /usr/bin/java
      - {{ eclipse.edition == 'java' }}

eclipse-plugins-add-preferences-to-workspace:
  file.recurse:
    - name: {{ eclipse.dir.plugins }}
    - source: salt://eclipse/files/plugin-prefs
    - force: True
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - user: {{ eclipse.identity.user }}
    - onchanges:
      - cmd: eclipse-plugins-extensions-config-install

    # replace pattern 'isimpson' with username
eclipse-plugins-replace-username-pattern-in-workspace:
  cmd.run:
    - name: grep -rl isimpson {{ eclipse.dir.workspace }} | xargs sed -i -e "s/isimpson/{{ eclipse.identity.user }}/g" 2>/dev/null
    - onlyif: test -d {{ eclipse.dir.workspace }}
    - onchanges:
      - file: eclipse-plugins-add-preferences-to-workspace

        {% if eclipse.plugins.svn.version %}

eclipse-plugins-setup-svn-connector-config:
  file.append:
    - name: {{ eclipse.dir.plugins }}/{{ eclipse.plugins.svn.prefs_path }}
    - text: "preference.core.svnconnector=org.eclipse.team.svn.connector.svnkit1{{ eclipse.plugins.svn.version }}"
    - onlyif: test -f {{ eclipse.dir.plugins }}/{{ eclipse.plugins.svn.prefs_path }}
    - onchanges:
      - cmd: eclipse-plugins-replace-username-pattern-in-workspace
    - unless: test "`uname`" = "Darwin"

eclipse-plugin-svn-connector-dir:
  file.directory:
    - name: {{ eclipse.dir.homes }}{{ eclipse.identity.user }}/.subversion
    - user: {{ eclipse.identity.user }}
    - recurse:
      - user
      - group
    - onchanges:
      - file: eclipse-plugins-setup-svn-connector-config
    - unless: test "`uname`" = "Darwin"

        {% endif %}
    {% endif %}
