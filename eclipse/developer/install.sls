# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import eclipse as eclipse with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower in ('linux', 'darwin') %}

eclipse-developer-install-desktop-shortcut-clean:
  file.absent:
    - name: {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/Desktop/Eclipse
    - require_in:
      - file: eclipse-developer-install-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

eclipse-developer-install-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://eclipse/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ eclipse.identity.user }}
      homes: {{ eclipse.dir.homes }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ eclipse.identity.user }}
    - require:
      - file: eclipse-developer-install-desktop-shortcut-add
    - require_in:
      - file: eclipse-developer-install-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

eclipse-developer-install-desktop-shortcut-install:
  file.managed:
    - source: salt://eclipse/files/eclipse.desktop
    - name: '{{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/Desktop/Eclipse.desktop'
    - user: '{{ eclipse.identity.user }}'
    - makedirs: True
    - mode: 644
    - force: True
    - template: jinja
            {%- if eclipse.pkg.use_upstream_macapp %}
    - onlyif: test -f "{{ eclipse.pkg.macapp.name }}/eclipse"
    - context:
      home: '{{ eclipse.pkg.macapp.name }}'
            {%- else %}
    - onlyif: test -f {{ eclipse.pkg.archive.name }}/eclipse
    - context:
      home: '{{ eclipse.pkg.archive.name }}'
            {%- endif %}

        {% if eclipse.prefs.xmlurl or eclipse.prefs.xmldir %}

eclipse-developer-install-preferences-xml:
  file.managed:
    - onlyif: {{ eclipse.prefs.xmldir }}
    - unless: test -f {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - name: {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/{{ eclipse.prefs.xmlfile }}
    - source: {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - user: {{ eclipse.identity.user }}
    - makedirs: True
    - if_missing: {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/{{ eclipse.prefs.xmlfile }}
  cmd.run:
    - onlyif: {{ eclipse.prefs.xmlurl }}
    - unless: test -f {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - name: curl -o {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/{{ eclipse.prefs.xmlfile }} {{ eclipse.prefs.xmlurl }}  # noqa 204
    - runas: {{ eclipse.identity.user }}
    - if_missing: {{ eclipse.dir.homes }}/{{ eclipse.identity.user }}/{{ eclipse.prefs.xmlfile }}
    - retry: {{ eclipse.retry_option }}

        {% endif %}
    {% endif %}
