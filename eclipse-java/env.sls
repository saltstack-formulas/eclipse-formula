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

# Add eclipse-home to alternatives system
eclipse-home-alt-install:
  alternatives.install:
    - name: eclipse-home
    - link: {{ eclipse.eclipse_home }}
    - path: {{ eclipse.eclipse_real_home }}
    - priority: {{ eclipse.alt_priority }}

eclipse-home-alt-set:
  alternatives.set:
    - name: eclipse-home
    - path: {{ eclipse.eclipse_real_home }}
    - require:
      - alternatives: eclipse-home-alt-install

# Add eclipse to alternatives system
eclipse-alt-install:
  alternatives.install:
    - name: eclipse
    - link: {{ eclipse.eclipse_symlink }}
    - path: {{ eclipse.eclipse_realcmd }}
    - priority: {{ eclipse.alt_priority }}
    - require:
      - alternatives: eclipse-home-alt-set

eclipse-alt-set:
  alternatives.set:
    - name: eclipse
    - path: {{ eclipse.eclipse_realcmd }}
    - require:
      - alternatives: eclipse-alt-install

