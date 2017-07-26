{%- from 'eclipse-java/settings.sls' import eclipse with context %}

include:
- eclipse-java

# Install some favourite plugins
eclipse-extend-with-plugins-config-script:
  file.managed:
    - name: {{ eclipse.workspace }}/config.sh
    - source: salt://eclipse-java/files/config.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ eclipse.eclipse_user }}
    - group: {{ eclipse.eclipse_user }}
    - force: True
    - require:
      - file: eclipse-java-update-home-symlink
    - context:
      eclipse_real_home: {{ eclipse.eclipse_real_home }}

eclipse-extend-with-plugins-config-execute:
  cmd.run:
    - name: {{ eclipse.workspace }}/config.sh {{ eclipse.eclipse_user }}
    - cwd: /root
    - unless: test -f {{ eclipse.eclipse_home }}/.plugins_saltstate_done
    - require:
      - file: eclipse-extend-with-plugins-config-script

# Add plugin preferences to workspace
eclipse-plugin-workspace-plugin-prefs:
  file.recurse:
  - name: {{ eclipse.metadata_plugins_dir }}
  - source: salt://eclipse-java/files/plugin-prefs
  - force: True
  - file_mode: 744
  - dir_mode: 755
  - makedirs: True
  - user: {{ eclipse.eclipse_user }}
  - group: {{ eclipse.eclipse_user }}
  - require:
    - cmd: eclipse-extend-with-plugins-config-execute

# if some shipped plugins need <user>, assume isimpson is hardcoded
eclipse-plugin-replace-username-searchtags-workspace:
  cmd.run:
    - name: grep -rl isimpson {{ eclipse.workspace }} | xargs sed -i "s/isimpson/{{ eclipse.eclipse_user }}/g" 2>/dev/null
    - onlyif: test -d {{ eclipse.workspace }}
    - onchanges:
      - file: eclipse-plugin-workspace-plugin-prefs

# Setup SVN connector for Eclipse
{%- set svn_prefs   = eclipse.metadata_plugins_dir + '/org.eclipse.core.runtime/.settings/org.eclipse.team.svn.ui.prefs' %}
{%- set svn_version = '1.9.3' %}

eclipse-plugin-svn-connector-config:
  file.append:
    - name: {{ svn_prefs }}
    - text: "preference.core.svnconnector=org.eclipse.team.svn.connector.svnkit1{{ svn_version }}"
    - onlyif: test -f {{ svn_prefs }}
    - require:
      - file: eclipse-plugin-workspace-plugin-prefs

eclipse-plugin-svn-connector-dir:
  file.directory:
    - name: /home/{{ eclipse.eclipse_user }}/.subversion
    - user: {{ eclipse.eclipse_user }}
    - group: {{ eclipse.eclipse_user }}
    - recurse:
      - user
      - group
    - require:
      - file: eclipse-plugin-svn-connector-config

