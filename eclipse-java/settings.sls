{%- set p  = salt['pillar.get']('eclipse-java', {}) %}
{%- set g  = salt['grains.get']('eclipse-java', {}) %}

{%- set eclipse_user         = pillar['user'] %}
{%- set workspace            = '/home/' + eclipse_user + '/workspace' %}

{%- set plugin_config_script = workspace + '/config.sh' %}
{%- set metadata_plugins_dir = workspace + '/.metadata/.plugins/' %}

{%- set eclipse_home = salt['grains.get']('eclipse_home', salt['pillar.get']('eclipse_home', '/opt/eclipse' )) %}

{%- set relname = g.get('relname', p.get('relname', 'neon' )) %}
{%- set package = g.get('package', p.get('package', 'java' )) %}
{%- set release = g.get('release', p.get('release', '3' )) %}
{%- set mirror  = 'http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/' + relname + '/' + release %}
{%- set arch    = '-linux-gtk-x86_64' %}

{%- set default_prefix       = '/usr/share/java' %}
{%- set default_source_url   = mirror + '/eclipse-' + package + '-' + relname + '-' + release + arch + '.tar.gz' %}
{%- set default_source_hash  = default_source_url + '.sha512' %}
{%- set default_dl_opts      = ' -s ' %}
{%- set default_archive_type = 'tar' %}
{%- set default_symlink      = '/usr/bin/eclipse' %}
{%- set default_realcmd      = eclipse_home + '/eclipse' %}
{%- set default_alt_priority = '30' %}

{%- set source_url           = g.get('source_url', p.get('source_url', default_source_url )) %}
{%- if source_url == default_source_url %}
  {%- set source_hash        = default_source_hash %}
{%- else %}
  {%- set source_hash        = g.get('source_hash', p.get('source_hash', default_source_hash )) %}
{%- endif %}

{%- set prefix               = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set eclipse_real_home    = prefix + '/' + 'eclipse-java' + '-' + relname + '-' + release %}
{%- set default_unpack_opts  = 'z -C ' + eclipse_real_home + ' --strip-components=1' %}
{%- set dl_opts              = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set eclipse_symlink      = g.get('eclipse_symlink', p.get('eclipse_symlink', '/usr/bin/eclipse' )) %}
{%- set eclipse_realcmd      = g.get('eclipse_realcmd', p.get('eclipse_realcmd', eclipse_home + '/eclipse' )) %}
{%- set archive_type         = g.get('archive_type', p.get('archive_type', default_archive_type )) %}
{%- set unpack_opts          = g.get('unpack_opts', p.get('unpack_opts', default_unpack_opts )) %}
{%- set alt_priority         = g.get('alt_priority', p.get('alt_priority', default_alt_priority )) %}

{%- set eclipse = {} %}
{%- do eclipse.update( {  'relname'              : relname,
                          'package'              : package,
                          'release'              : release,
                          'source_url'           : source_url,
                          'source_hash'          : source_hash,
                          'eclipse_home'         : eclipse_home,
                          'dl_opts'              : dl_opts,
                          'unpack_opts'          : unpack_opts,
                          'archive_type'         : archive_type,
                          'prefix'               : prefix,
                          'eclipse_real_home'    : eclipse_real_home,
                          'eclipse_symlink'      : eclipse_symlink,
                          'eclipse_realcmd'      : eclipse_realcmd,
                          'eclipse_user'         : eclipse_user,
                          'workspace'            : workspace,
                          'plugin_config_script' : plugin_config_script,
                          'metadata_plugins_dir' : metadata_plugins_dir,
                          'alt_priority'         : alt_priority,
                     }) %}
