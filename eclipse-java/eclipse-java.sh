{%- from 'eclipse-java/settings.sls' import eclipse with context %}

export ECLIPSE_HOME={{ eclipse.eclipse_home }}
export PATH=$ECLIPSE/bin:$PATH
