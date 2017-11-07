{% from "eclipse/map.jinja" import eclipse with context %}

{% if eclipse.prefs.user not in (None, 'undefined', 'undefined_user') %}

# Install some favourite plugins
eclipse-extend-with-plugins-config-script:
  file.managed:
    - name: {{ eclipse.epp.workspace }}/config.sh
    - source: salt://eclipse/files/config.sh
    - template: jinja
    - makedirs: True
    - mode: 744
    - user: {{ eclipse.prefs.user }}
  {% if grains.os_family in ('Suse') or grains.os in ('SUSE') %}
    - group: users
  {% else %}
    - group: {{ eclipse.prefs.user }}
  {% endif %}
    - force: True
    - context:
      home: {{ eclipse.epp.realhome }}
      command: {{ eclipse.command }}

eclipse-extend-with-plugins-config-execute:
  cmd.run:
    - name: {{ eclipse.epp.workspace }}/config.sh {{ eclipse.prefs.user }}
    - cwd: {{ eclipse.epp.workspace }}
    - require:
      - eclipse-extend-with-plugins-config-script

# Add plugin preferences to workspace
eclipse-plugin-workspace-plugin-prefs:
  file.recurse:
    - name: {{ eclipse.epp.metadata }}
    - source: salt://eclipse/files/plugin-prefs
    - force: True
    - file_mode: 744
    - dir_mode: 755
    - makedirs: True
    - user: {{ eclipse.prefs.user }}
  {% if grains.os_family in ('Suse') or grains.os in ('SUSE') %}
    - group: users
  {% else %}
    - group: {{ eclipse.prefs.user }}
  {% endif %}
    - onchanges:
      - eclipse-extend-with-plugins-config-execute

# if some shipped plugins need <user>, assume isimpson is hardcoded
eclipse-plugin-replace-username-searchtags-workspace:
  cmd.run:
    - name: grep -rl isimpson {{ eclipse.epp.workspace }} | xargs sed -i "s/isimpson/{{ eclipse.prefs.user }}/g" 2>/dev/null
    - onlyif: test -d {{ eclipse.epp.workspace }}
    - onchanges:
      - eclipse-plugin-workspace-plugin-prefs

  {% if eclipse.plugins.svn.version not in (None, 'undefined', '', 0) %}
    {% if grains.os not in ('Windows', 'MacOS') %}
     # Only tested on Linux so far

# Setup SVN connector for Eclipse
eclipse-plugin-svn-connector-config:
  file.append:
    - name: {{ eclipse.epp.metadata }}/{{ eclipse.plugins.svn.prefs_path }}
    - text: "preference.core.svnconnector=org.eclipse.team.svn.connector.svnkit1{{ eclipse.plugins.svn.version }}"
    - onlyif: test -f {{ eclipse.epp.metadata }}/{{ eclipse.plugins.svn.prefs_path }}
    - onchanges:
      - eclipse-plugin-workspace-plugin-prefs

eclipse-plugin-svn-connector-dir:
  file.directory:
    - name: {{ eclipse.homes }}{{ eclipse.prefs.user }}/.subversion
    - user: {{ eclipse.prefs.user }}
  {% if grains.os_family in ('Suse') or grains.os in ('SUSE') %}
    - group: users
  {% else %}
    - group: {{ eclipse.prefs.user }}
  {% endif %}
    - recurse:
      - user
      - group
    - onchanges:
      - eclipse-plugin-svn-connector-config

    {% endif %}
  {% endif %}

{% endif %}
