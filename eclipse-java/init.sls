{%- from 'eclipse-java/settings.sls' import eclipse with context %}

{#- require a source_url - there may be no default download location for Eclipse #}

{%- if eclipse.source_url is defined %}

  {%- set archive_file = eclipse.prefix + '/' + eclipse.source_url.split('/') | last %}

eclipse-java-install-dir:
  file.directory:
    - name: {{ eclipse.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# curl fails (rc=23) if file exists
# and test -f cannot detect corrupt archive
{{ archive_file }}:
  file.absent:
    - require_in:
      - eclipse-java-download-archive

eclipse-java-download-archive:
  cmd.run:
    - name: curl {{ eclipse.dl_opts }} -o '{{ archive_file }}' '{{ eclipse.source_url }}'
    - require:
      - eclipse-java-install-dir
    - require_in:
      - eclipse-java-unpacked-dir

eclipse-java-unpacked-dir:
  file.directory:
    - name: {{ eclipse.eclipse_real_home }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - require_in:
      - eclipse-java-unpack-archive

eclipse-java-unpack-archive:
  archive.extracted:
    - name: {{ eclipse.eclipse_real_home }}
    - source: file://{{ archive_file }}
    {%- if eclipse.source_hash %}
    - source_hash: {{ eclipse.source_hash }}
    {%- endif %}
    - archive_format: {{ eclipse.archive_type }} 
    - options: {{ eclipse.unpack_opts }}
    - enforce_toplevel: False
    - clean: True
    - user: root
    - group: root
    - if_missing: {{ eclipse.eclipse_realcmd }}
    - require:
      - eclipse-java-unpacked-dir
      - eclipse-java-download-archive

eclipse-java-update-home-symlink:
  file.symlink:
    - name: {{ eclipse.eclipse_home }}
    - target: {{ eclipse.eclipse_real_home }}
    - force: True
    - require:
      - eclipse-java-unpack-archive
    - require_in:
      - eclipse-java-remove-archive
      - eclipse-java-remove-archive-hash
      - eclipse-java-desktop-entry

eclipse-java-desktop-entry:
  file.managed:
    - source: salt://eclipse-java/files/eclipse-java.desktop
    - name: /home/{{ pillar['user'] }}/Desktop/eclipse-java.desktop
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755

eclipse-java-remove-archive:
  file.absent:
    - name: {{ archive_file }}

{%- if eclipse.source_hash %}
eclipse-java-remove-archive-hash:
  file.absent:
    - name: {{ archive_file }}.sha512
{%- endif %}

{%- endif %}
