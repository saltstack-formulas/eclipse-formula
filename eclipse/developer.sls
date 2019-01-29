{% from "eclipse/map.jinja" import eclipse with context %}

{% if eclipse.prefs.user %}
   {% if grains.os != 'Windows' %}

eclipse-desktop-shortcut-clean:
  file.absent:
    - name: '{{ eclipse.homes }}{{ eclipse.prefs.user }}/Desktop/Eclipse'
    - require_in:
      - file: eclipse-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

eclipse-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://eclipse/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ eclipse.prefs.user }}
      homes: {{ eclipse.homes }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ eclipse.prefs.user }}
    - require:
      - file: eclipse-desktop-shortcut-add
    - require_in:
      - file: eclipse-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

eclipse-desktop-shortcut-install:
  file.managed:
    - source: salt://eclipse/files/eclipse.desktop
    - name: {{ eclipse.homes }}{{ eclipse.prefs.user }}/Desktop/Eclipse.desktop
    - user: {{ eclipse.prefs.user }}
    - makedirs: True
       {% if eclipse.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ eclipse.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ eclipse.epp.realcmd }}
    - context:
      home: {{ eclipse.epp.realhome }}
      command: {{ eclipse.command }}
   {% endif %}

  {% if eclipse.prefs.xmlurl or eclipse.prefs.xmldir %}

eclipse-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - name: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
    - source: {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - user: {{ eclipse.prefs.user }}
    - makedirs: True
       {% if eclipse.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ eclipse.prefs.group }}
       {% endif %}
    - if_missing: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
  cmd.run:
    - unless: test -f {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - name: curl -o {{eclipse.homes}}{{eclipse.prefs.user}}/{{eclipse.prefs.xmlfile}} {{eclipse.prefs.xmlurl}}
    - runas: {{ eclipse.prefs.user }}
    - if_missing: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
    {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: 3
        until: True
        interval: 60
        splay: 10
    {%- endif %}

  {% endif %}
{% endif %}

