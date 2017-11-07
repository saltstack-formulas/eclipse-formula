{% from "eclipse/map.jinja" import eclipse with context %}

{% if eclipse.prefs.user not in (None, 'undefined', 'undefined_user', '',) %}

  {% if grains.os == 'MacOS' %}
eclipse-desktop-shortcut-clean:
  file.absent:
    - name: '{{ eclipse.homes }}{{ eclipse.prefs.user }}/Desktop/Eclipse'
    - require_in:
      - file: eclipse-desktop-shortcut-add
  {% endif %}

eclipse-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://eclipse/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ eclipse.prefs.user }}
      homes: {{ eclipse.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ eclipse.prefs.user }}
    - require:
      - file: eclipse-desktop-shortcut-add
   {% elif grains.os not in ('Windows',) %}
   #Linux
  file.managed:
    - source: salt://eclipse/files/eclipse.desktop
    - name: {{ eclipse.homes }}{{ eclipse.prefs.user }}/Desktop/Eclipse.desktop
    - user: {{ eclipse.prefs.user }}
    - makedirs: True
      {% if grains.os_family in ('Suse',) %} 
    - group: users
      {% else %}
    - group: {{ eclipse.prefs.user }}
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
   {% if eclipse.prefs.xmldir %}
  file.managed:
    - onlyif: test -f {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - name: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
    - source: {{ eclipse.prefs.xmldir }}/{{ eclipse.prefs.xmlfile }}
    - user: {{ eclipse.prefs.user }}
    - makedirs: True
        {% if grains.os_family in ('Suse',) %}
    - group: users
        {% elif grains.os not in ('MacOS',) %}
        #inherit Darwin ownership
    - group: {{ eclipse.prefs.user }}
        {% endif %}
    - if_missing: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{eclipse.homes}}{{eclipse.prefs.user}}/{{eclipse.prefs.xmlfile}} {{eclipse.prefs.xmlurl}}
    - runas: {{ eclipse.prefs.user }}
    - if_missing: {{ eclipse.homes }}{{ eclipse.prefs.user }}/{{ eclipse.prefs.xmlfile }}
   {% endif %}

  {% endif %}

{% endif %}

