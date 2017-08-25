{%- from 'eclipse-java/settings.sls' import eclipse with context %}

# Update system profile with PATH
eclipse-config:
  file.managed:
    - name: /etc/profile.d/eclipse-java.sh
    - source: salt://eclipse-java/files/eclipse-java.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      eclipse_home: {{ eclipse.eclipse_home }}

{% if eclipse.user != 'undefined' %}
  {% if eclipse.prefs_url != 'undefined' %}

eclipse-get-preferences-importfile-from-url:
  cmd.run:
    - name: curl -s -o /home/{{ eclipse.user }}/.eclipse/my-preferences.xml '{{ eclipse.prefs_url }}'
    - if_missing: /home/{{ eclipse.user }}/my-preferences.xml

  {% elif eclipse.prefs_path != 'undefined' and eclipse.user != 'undefined' %}

eclipse-get-preferences-importfile-from-path:
  file.managed:
    - name: /home/{{ eclipse.user }}/my-preferences.xml
    - source: {{ eclipse.prefs_path }}
    - if_missing: /home/{{ eclipse.user }}/my-preferences.xml

  {% endif %}

eclipse-preferences-file-perms:
  file.managed:
    - name: /home/{{ eclipse.user }}/my-preferences.xml
    - replace: False
    - mode: 644
    - user: {{ eclipse.user }}
   {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
   {% else %}
    - group: {{ eclipse.user }}
   {% endif %}
    - onchanges:
      - cmd: eclipse-get-preferences-importfile-from-url
      - file: eclipse-get-preferences-importfile-from-path
{% endif %}

# Add eclipse-home to alternatives system
eclipse-home-alt-install:
  alternatives.install:
    - name: eclipse-home
    - link: {{ eclipse.eclipse_home }}
    - path: {{ eclipse.real_home }}
    - priority: {{ eclipse.alt_priority }}

eclipse-home-alt-set:
  alternatives.set:
    - name: eclipse-home
    - path: {{ eclipse.real_home }}
    - onchanges:
      - alternatives: eclipse-home-alt-install

# Add eclipse to alternatives system
eclipse-alt-install:
  alternatives.install:
    - name: eclipse
    - link: {{ eclipse.symlink }}
    - path: {{ eclipse.realcmd }}
    - priority: {{ eclipse.alt_priority }}
    - onchanges:
      - alternatives: eclipse-home-alt-install
      - alternatives: eclipse-home-alt-set

eclipse-alt-set:
  alternatives.set:
    - name: eclipse
    - path: {{ eclipse.realcmd }}
    - onchanges:
      - alternatives: eclipse-alt-install

