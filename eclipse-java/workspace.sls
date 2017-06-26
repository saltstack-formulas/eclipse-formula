{%- set p = salt['pillar.get']('user', {}) %}
{%- set g = salt['grains.get']('user', {}) %}

{%- set default_user	     = pillar['user'] %}
{%- set workspace	     = '/home/' + default_user + '/workspace' %}

{%- set plugin_config_script = workspace + '/config.sh' %}
{%- set metadata_plugins_dir = workspace + '/.metadata/.plugins/' %}

{%- set workspace = {} %}
{%- do workspace.update( {  'user'		   : user,
			    'workspace'		   : workspace,
                            'plugin_config_script' : plugin_config_script,
                            'metadata_plugins_dir' : metadata_plugins_dir,
                     }) %}
