{% from "eclipse/map.jinja" import eclipse with context %}

# Cleanup first
eclipse-remove-prev-archive:
  file.absent:
    - name: '{{ eclipse.tmpdir }}/{{ eclipse.dl.archive_name }}'
    - require_in:
      - eclipse-extract-dirs

eclipse-extract-dirs:
  file.directory:
    - names:
      - '{{ eclipse.tmpdir }}'
      - '{{ eclipse.epp.home }}'
{% if grains.os not in ('MacOS', 'Windows',) %}
      - '{{ eclipse.epp.realhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - require_in:
      - eclipse-download-archive

eclipse-download-archive:
  cmd.run:
    - name: curl {{ eclipse.dl.opts }} -o '{{ eclipse.tmpdir }}/{{ eclipse.dl.archive_name }}' {{ eclipse.dl.src_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ eclipse.dl.retries }}
        interval: {{ eclipse.dl.interval }}
      {% endif %}

{%- if eclipse.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',) %}
eclipse-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ eclipse.tmpdir }}/{{ eclipse.dl.archive_name }}'
     - file_hash: {{ eclipse.dl.src_hashsum }}
     - onchanges:
       - cmd: eclipse-download-archive
     - require_in:
       - archive: eclipse-package-install
  {%- endif %}
{%- endif %}

eclipse-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ eclipse.tmpdir }}/{{ eclipse.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  # Linux
  archive.extracted:
    - source: 'file://{{ eclipse.tmpdir }}/{{ eclipse.dl.archive_name }}'
    - name: '{{ eclipse.epp.realhome }}'
    - archive_format: {{ eclipse.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ eclipse.dl.unpack_opts }}
    - if_missing: '{{ eclipse.epp.realcmd }}'
       {% else %}
    - options: {{ eclipse.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if eclipse.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ eclipse.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: eclipse-download-archive
    - require_in:
      - eclipse-remove-archive

eclipse-remove-archive:
  file.absent:
    - name: '{{ eclipse.tmpdir }}'
    - onchanges:
{%- if grains.os in ('Windows',) %}
      - pkg: eclipse-package-install
{%- elif grains.os in ('MacOS',) %}
      - macpackage: eclipse-package-install
{% else %}
      #Unix
      - archive: eclipse-package-install

{% endif %}
