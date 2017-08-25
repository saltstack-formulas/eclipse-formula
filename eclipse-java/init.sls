{%- from 'eclipse-java/settings.sls' import eclipse with context %}

{#- require a source_url - there may be no default download location for Eclipse #}

{%- if eclipse.source_url is defined %}

  {%- set archive_file = eclipse.prefix ~ '/' ~ eclipse.source_url.split('/') | last %}

eclipse-java-install-dir:
  file.directory:
    - name: {{ eclipse.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# curl fails (rc=23) if file exists, test -f misses corrupt archive
eclipse-java-remove-prev-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - file: eclipse-java-install-dir

eclipse-java-download-archive:
  cmd.run:
    - name: curl {{ eclipse.dl_opts }} -o '{{ archive_file }}' '{{ eclipse.source_url }}'
    - require:
      - file: eclipse-java-remove-prev-archive
    - require_in:
      - file: eclipse-java-unpacked-dir

eclipse-java-unpacked-dir:
  file.directory:
    - name: {{ eclipse.real_home }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require_in:
      - archive: eclipse-java-unpack-archive

  {%- if eclipse.source_hash and grains['saltversioninfo'] <= [2016, 11, 6] %}
    # See: https://github.com/saltstack/salt/pull/41914
eclipse-java-check-archive-hash:
  module.run:
    - name: file.check_hash
    - path: {{ archive_file }}
    - file_hash: {{ eclipse.source_hash }}
    - onchanges:
      - cmd: eclipse-java-download-archive
    - require_in:
      - archive: eclipse-java-unpack-archive
  {%- endif %}

eclipse-java-unpack-archive:
  archive.extracted:
    - name: {{ eclipse.real_home }}
    - source: file://{{ archive_file }}
    - archive_format: {{ eclipse.archive_type }} 
  {%- if eclipse.source_hash and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ eclipse.source_hash }}
  {%- endif %}
  {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ eclipse.unpack_opts }}
    - if_missing: {{ eclipse.realcmd }}
  {% else %}
    - options: {{ eclipse.unpack_opts }}
  {% endif %}
  {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
  {% endif %}
    - onchanges:
      - cmd: eclipse-java-download-archive

eclipse-java-update-home-symlink:
  file.symlink:
    - name: {{ eclipse.eclipse_home }}
    - target: {{ eclipse.real_home }}
    - force: True
    - onchanges:
      - archive: eclipse-java-unpack-archive
    - require_in:
      - file: eclipse-java-desktop-entry
      - file: eclipse-java-remove-archive

{% if eclipse.user != 'undefined' %}
eclipse-java-desktop-entry:
  file.managed:
    - source: salt://eclipse-java/files/eclipse-java.desktop
    - name: /home/{{ eclipse.user }}/Desktop/eclipse-java.desktop
    - user: {{ eclipse.user }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ eclipse.user }}
  {% endif %}
    - mode: 655
    - if_missing: /home/{{ eclipse.user }}/Desktop/eclipse-java.desktop
    - onchanges:
      - archive: eclipse-java-unpack-archive
{% endif %}

eclipse-java-remove-archive:
  file.absent:
    - names:
      - {{ archive_file }}
      - {{ archive_file }}.sha512
    - onchanges:
      - archive: eclipse-java-unpack-archive

{%- endif %}
