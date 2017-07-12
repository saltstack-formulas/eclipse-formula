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
    - priority: 30
    - require:
      - eclipse-java-update-home-symlink

eclipse-home-alt-set:
  alternatives.set:
    - name: eclipse-home
    - path: {{ eclipse.eclipse_real_home }}
    - require:
      - eclipse-home-alt-install

# Add eclipse to alternatives system
eclipse-alt-install:
  alternatives.install:
    - name: eclipse
    - link: {{ eclipse.eclipse_symlink }}
    - path: {{ eclipse.eclipse_realcmd }}
    - priority: 30
    - onlyif: test -d {{ eclipse.eclipse_real_home }} && test -L {{ eclipse.eclipse_home }}
    - require:
      - eclipse-home-alt-install

eclipse-alt-set:
  alternatives.set:
    - name: eclipse
    - path: {{ eclipse.eclipse_realcmd }}
    - require:
      - eclipse-alt-install

# source PATH with ECLIPSE_HOME
eclipse-source-file:
  cmd.run:
  - name: source /etc/profile
  - cwd: /root

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
      - eclipse-alt-install
    - context:
      eclipse_real_home: {{ eclipse.eclipse_real_home }}

eclipse-extend-with-plugins-config-execute:
  cmd.run:
    - name: {{ eclipse.workspace }}/config.sh {{ eclipse.eclipse_user }}
    - cwd: /root
    - unless: test -f {{ eclipse.eclipse_home }}/.plugins_saltstate_done
    - require:
      - eclipse-extend-with-plugins-config-script

# Setup some developer plugin preferences in workspace.
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
    - eclipse-extend-with-plugins-config-execute

# few plugin preferences mayh ave user hardcoded, resolve
eclipse-plugin-replace-username-searchtags-workspace:
  cmd.run:
    - name: grep -rl isimpson {{ eclipse.workspace }} | xargs sed -i "s/isimpson/{{ eclipse.eclipse_user }}/g" 2>/dev/null
    - onlyif: test -d {{ eclipse.workspace }}
    - onchanges:
      - eclipse-plugin-workspace-plugin-prefs

# Setup SVN connector for Eclipse
{%- set svn_prefs   = eclipse.metadata_plugins_dir + '/org.eclipse.core.runtime/.settings/org.eclipse.team.svn.ui.prefs' %}
{%- set svn_version = '1.9.3' %}

eclipse-plugin-svn-connector-config:
  file.append:
    - name: {{ svn_prefs }}
    - text: "preference.core.svnconnector=org.eclipse.team.svn.connector.svnkit1{{ svn_version }}"
    - onlyif: test -f {{ svn_prefs }}
    - require:
      - eclipse-plugin-workspace-plugin-prefs

eclipse-plugin-svn-connector-dir:
  file.directory:
    - name: /home/{{ eclipse.eclipse_user }}/.subversion
    - user: {{ eclipse.eclipse_user }}
    - group: {{ eclipse.eclipse_user }}
    - recurse:
      - user
      - group
    - require:
      - eclipse-plugin-svn-connector-config

