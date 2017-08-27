{%- from 'eclipse-java/settings.sls' import eclipse with context %}

{% if eclipse.user != 'undefined_user' %}

# Install some favourite plugins
eclipse-extend-with-plugins-config-script:
  file.managed:
    - name: {{ eclipse.workspace }}/config.sh
    - source: salt://eclipse-java/files/config.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ eclipse.user }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ eclipse.user }}
  {% endif %}
    - force: True
    - context:
      real_home: {{ eclipse.real_home }}

eclipse-extend-with-plugins-config-execute:
  cmd.run:
    - name: {{ eclipse.workspace }}/config.sh {{ eclipse.user }}
    - cwd: /root
    - require:
      - eclipse-extend-with-plugins-config-script

# Add plugin preferences to workspace
eclipse-plugin-workspace-plugin-prefs:
  file.recurse:
    - name: {{ eclipse.metadata }}
    - source: salt://eclipse-java/files/plugin-prefs
    - force: True
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - user: {{ eclipse.user }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ eclipse.user }}
  {% endif %}
    - onchanges:
      - eclipse-extend-with-plugins-config-execute

# if some shipped plugins need <user>, assume isimpson is hardcoded
eclipse-plugin-replace-username-searchtags-workspace:
  cmd.run:
    - name: grep -rl isimpson {{ eclipse.workspace }} | xargs sed -i "s/isimpson/{{ eclipse.user }}/g" 2>/dev/null
    - onlyif: test -d {{ eclipse.workspace }}
    - onchanges:
      - eclipse-plugin-workspace-plugin-prefs

  {% if eclipse.svn_version != 'undefined' %}
# Setup SVN connector for Eclipse
eclipse-plugin-svn-connector-config:
  file.append:
    - name: {{ eclipse.metadata }}/{{ eclipse.svn_prefs_path }}
    - text: "preference.core.svnconnector=org.eclipse.team.svn.connector.svnkit1{{ eclipse.svn_version }}"
    - onlyif: test -f {{ eclipse.metadata }}/{{ eclipse.svn_prefs_path }}
    - onchanges:
      - eclipse-plugin-workspace-plugin-prefs

eclipse-plugin-svn-connector-dir:
  file.directory:
    - name: /home/{{ eclipse.user }}/.subversion
    - user: {{ eclipse.user }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ eclipse.user }}
  {% endif %}
    - recurse:
      - user
      - group
    - onchanges:
      - eclipse-plugin-svn-connector-config

  {% endif %}
{% endif %}
