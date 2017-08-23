{%- set p  = salt['pillar.get']('eclipse-java', {}) %}
{%- set g  = salt['grains.get']('eclipse-java', {}) %}

{%- set eclipse_home         = salt['grains.get']('eclipse_home', salt['pillar.get']('eclipse_home', '/opt/eclipse' )) %}
{%- set eclipse_user         = salt['grains.get']('user', salt['pillar.get']('user')) %}
{%- set svn_version          = salt['grains.get']('svn_version', salt['pillar.get']('svn_version', '1.9.3' )) %}

{%- set name                 = g.get('name', p.get('name', 'neon' )) %}
{%- set package              = g.get('package', p.get('package', 'java' )) %}
{%- set release              = g.get('release', p.get('release', '3' )) %}
{%- set mirror               = 'http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/' %}
{%- set mirrorpath           = mirror + name + '/' + release %}
{%- set arch                 = '-linux-gtk-x86_64' %}

{%- set default_prefix       = '/usr/share/java' %}
{%- set default_source_url   = mirrorpath + '/eclipse-' + package + '-' + name + '-' + release + arch + '.tar.gz' %}
{%- set default_real_home    = default_prefix + '/eclipse-java-' + name + '-' + release %}
{%- set default_dl_opts      = ' -s ' %}
{%- set default_archive_type = 'tar' %}
{%- set default_symlink      = '/usr/bin/eclipse' %}
{%- set default_realcmd      = default_real_home + '/eclipse' %}
{%- set default_alt_priority = '30' %}
{%- set default_unpack_opts  = 'z -C ' + default_real_home + ' --strip-components=1' %}

{% if salt['grains.get']('saltversioninfo') <= [2016, 11, 6] %}
   #### hash for eclipse java neon linux x64 tarball ####
    {%- set default_source_hash  = "md5=74962bf6d674fda7da30aafdb5f6ce86" %}
{% else %}
    {%- set default_source_hash  = default_source_url + '.sha512' %}
{% endif %}

{%- set source_url           = g.get('source_url', p.get('source_url', default_source_url )) %}
{%- if source_url == default_source_url %}
  {%- set source_hash        = default_source_hash %}
{%- else %}
  {%- set source_hash        = g.get('source_hash', p.get('source_hash', default_source_hash )) %}
{%- endif %}

{%- set prefix               = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set eclipse_real_home    = g.get('realhome', p.get('realhome', default_real_home )) %}
{%- set dl_opts              = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set unpack_opts          = g.get('unpack_opts', p.get('unpack_opts', default_unpack_opts )) %}
{%- set eclipse_symlink      = g.get('eclipse_symlink', p.get('eclipse_symlink', '/usr/bin/eclipse' )) %}
{%- set eclipse_realcmd      = g.get('eclipse_realcmd', p.get('eclipse_realcmd', eclipse_home + '/eclipse' )) %}
{%- set archive_type         = g.get('archive_type', p.get('archive_type', default_archive_type )) %}
{%- set alt_priority         = g.get('alt_priority', p.get('alt_priority', default_alt_priority )) %}
{%- set eclipse_workspace    = '/home/' + eclipse_user + '/workspace' %}
{%- set metadata_plugins     = eclipse_workspace + '/.metadata/.plugins/' %}

{%- set eclipse = {} %}
{%- do eclipse.update( {  'eclipse_home'         : eclipse_home,
                          'eclipse_user'         : eclipse_user,
                          'svn_version'          : svn_version,
                          'source_url'           : source_url,
                          'source_hash'          : source_hash,
                          'dl_opts'              : dl_opts,
                          'unpack_opts'          : unpack_opts,
                          'archive_type'         : archive_type,
                          'prefix'               : prefix,
                          'eclipse_real_home'    : eclipse_real_home,
                          'eclipse_symlink'      : eclipse_symlink,
                          'eclipse_realcmd'      : eclipse_realcmd,
                          'alt_priority'         : alt_priority,
                          'eclipse_workspace'    : eclipse_workspace,
                          'metadata_plugins'     : metadata_plugins,
                     }) %}
