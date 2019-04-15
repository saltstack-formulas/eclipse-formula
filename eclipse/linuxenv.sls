{% from "eclipse/map.jinja" import eclipse with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

eclipse-home-symlink:
  file.symlink:
    - name: '{{ eclipse.epp.home }}/{{ eclipse.command }}'
    - target: '{{ eclipse.epp.realhome }}'
    - onlyif: test -d {{ eclipse.epp.realhome }}
    - force: True

# Update system profile with PATH
eclipse-config:
  file.managed:
    - name: /etc/profile.d/eclipse.sh
    - source: salt://eclipse/files/eclipse.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ eclipse.epp.home }}/eclipse'

  # Debian alternatives
  {% if eclipse.linux.altpriority > 0 %}
     {% if grains.os_family not in ('Arch',) %}

# Add eclipsehome to alternatives system
eclipse-home-alt-install:
  alternatives.install:
    - name: eclipsehome
    - link: '{{ eclipse.epp.home }}/{{ eclipse.command }}'
    - path: '{{ eclipse.epp.realhome }}'
    - priority: {{ eclipse.linux.altpriority }}
    - retry:
        attempts: 2
        until: True

eclipse-home-alt-set:
  alternatives.set:
    - name: eclipsehome
    - path: {{ eclipse.epp.realhome }}
    - onchanges:
      - alternatives: eclipse-home-alt-install
    - retry:
        attempts: 2
        until: True

# Add intelli to alternatives system
eclipse-alt-install:
  alternatives.install:
    - name: eclipse
    - link: {{ eclipse.linux.symlink }}
    - path: {{ eclipse.epp.realcmd }}
    - priority: {{ eclipse.linux.altpriority }}
    - require:
      - alternatives: eclipse-home-alt-install
      - alternatives: eclipse-home-alt-set
    - retry:
        attempts: 2
        until: True

eclipse-alt-set:
  alternatives.set:
    - name: eclipse
    - path: {{ eclipse.epp.realcmd }}
    - onchanges:
      - alternatives: eclipse-alt-install
    - retry:
        attempts: 2
        until: True

      {% endif %}
  {% endif %}

{% endif %}
