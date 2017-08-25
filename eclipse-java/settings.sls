{%- set p  = salt['pillar.get']('eclipse-java', {}) %}
{%- set g  = salt['grains.get']('eclipse-java', {}) %}

{%- set eclipse_home           = salt['grains.get']('eclipse_home', salt['pillar.get']('eclipse_home', '/opt/eclipse'))%}
{%- set svn_version            = salt['grains.get']('svn_version', salt['pillar.get']('svn_version', 'undefined')) %}
{%- set default_svn_prefs_path = '/org.eclipse.core.runtime/.settings/org.eclipse.team.svn.ui.prefs' %}

{%- set name                   = g.get('name', p.get('name', 'neon' )) %}
{%- set package                = g.get('package', p.get('package', 'java' )) %}
{%- set release                = g.get('release', p.get('release', '3' )) %}
{%- set mirror                 = 'http://eclipse.mirror.rafal.ca/technology/epp/downloads/release/' %}
{%- set mirrorpath             = mirror ~ name ~ '/' ~ release %}
{%- set arch                   = '-linux-gtk-x86_64' %}

{%- set default_user           = 'undefined_user' %}
{%- set default_prefs_url      = 'undefined' %}
{%- set default_prefs_path     = 'undefined' %}
{%- set default_prefix         = '/usr/share/java' %}
{%- set default_source_url     = mirrorpath ~ '/eclipse-' ~ package ~ '-' ~ name ~ '-' ~ release ~ arch ~ '.tar.gz' %}
{%- set default_real_home      = default_prefix ~ '/eclipse-java-' ~ name ~ '-' ~ release %}
{%- set default_dl_opts        = ' -s ' %}
{%- set default_archive_type   = 'tar' %}
{%- set default_symlink        = '/usr/bin/eclipse' %}
{%- set default_realcmd        = default_real_home ~ '/eclipse' %}
{%- set default_alt_priority   = '30' %}
{%- set default_unpack_opts    = 'z -C ' ~ default_real_home ~ ' --strip-components=1' %}

{% if salt['grains.get']('saltversioninfo') <= [2016, 11, 6] %}
   #### hash for eclipse java neon linux x64 tarball ####
    {%- set default_source_hash  = "md5=74962bf6d674fda7da30aafdb5f6ce86" %}
{% else %}
    {%- set default_source_hash  = default_source_url ~ '.sha512' %}
{% endif %}

{%- set source_url     = g.get('source_url', p.get('source_url', default_source_url )) %}
{%- if source_url == default_source_url %}
  {%- set source_hash  = default_source_hash %}
{%- else %}
  {%- set source_hash  = g.get('source_hash', p.get('source_hash', default_source_hash )) %}
{%- endif %}

{%- set prefs_url      = g.get('prefs_url', p.get('prefs_url', default_prefs_url )) %}
{%- set prefs_path     = g.get('prefs_path', p.get('prefs_path', default_prefs_path )) %}
{%- set user           = g.get('default_user', salt['pillar.get']('default_user', p.get('default_user', default_user)) %}
{%- set prefix         = g.get('prefix', p.get('prefix', default_prefix )) %}
{%- set real_home      = g.get('realhome', p.get('realhome', default_real_home )) %}
{%- set dl_opts        = g.get('dl_opts', p.get('dl_opts', default_dl_opts)) %}
{%- set unpack_opts    = g.get('unpack_opts', p.get('unpack_opts', default_unpack_opts )) %}
{%- set symlink        = g.get('symlink', p.get('symlink', '/usr/bin/eclipse' )) %}
{%- set realcmd        = g.get('realcmd', p.get('realcmd', real_home ~ '/eclipse' )) %}
{%- set archive_type   = g.get('archive_type', p.get('archive_type', default_archive_type )) %}
{%- set alt_priority   = g.get('alt_priority', p.get('alt_priority', default_alt_priority )) %}
{%- set workspace      = '/home/' ~ user ~ '/workspace' %}
{%- set metadata       = workspace ~ '/.metadata/.plugins/' %}
{%- set svn_prefs_path = g.get('svn_prefs_path', p.get('svn_prefs_path', default_svn_prefs_path )) %}

{%- set eclipse = {} %}
{%- do eclipse.update( {  'eclipse_home'     : eclipse_home,
                          'svn_version'      : svn_version,
                          'source_url'       : source_url,
                          'source_hash'      : source_hash,
                          'user'             : user,
                          'prefs_url'        : prefs_url,
                          'prefs_path'       : prefs_path,
                          'prefix'           : prefix,
                          'dl_opts'          : dl_opts,
                          'unpack_opts'      : unpack_opts,
                          'archive_type'     : archive_type,
                          'real_home'        : real_home,
                          'symlink'          : symlink,
                          'realcmd'          : realcmd,
                          'alt_priority'     : alt_priority,
                          'workspace'        : workspace,
                          'metadata'         : metadata,
                          'svn_prefs_path'   : svn_prefs_path,
                     }) %}
