{%- from 'eclipse-java/settings.sls' import eclipse with context %}

#!/usr/bin/env bash
[[ -z "${1}" ]] && echo "Missing username as script argument." && exit 1

### Install popular Eclipse plugins. Should be salt-ized in future ###

#base
repos=http://download.eclipse.org/releases/neon/
features=org.eclipse.egit.feature.group

#Anyedit
repos=$repos,http://andrei.gmxhome.de/eclipse/
features=$features,AnyEditTools.feature.group

#maven-apt
repos=$repos,http://download.jboss.org/jbosstools/updates/m2e-extensions/m2e-apt
features=$features,org.eclipse.m2e.feature.feature.group,org.eclipse.m2e.wtp.feature.feature.group,org.eclipse.m2e.wtp.jaxrs.feature.feature.group,org.jboss.tools.maven.apt.core,org.jboss.tools.maven.apt.ui,org.jboss.tools.maven.apt.feature.feature.group

#jamon
repos=$repos,http://www.jamon.org/eclipse/updates
features=$features,org.jamon.project,org.jamon.eclipse.maven.configurator,org.jamon.processor

#subversion
repos=$repos,http://community.polarion.com/projects/subversive/download/eclipse/6.0/neon-site/
features=$features,org.eclipse.team.svn.feature.group,org.eclipse.team.svn.resource.ignore.rules.jdt.feature.group,org.polarion.eclipse.team.svn.connector.feature.group,org.polarion.eclipse.team.svn.connector.svnkit18.feature.group

#mpc
repos=$repos,http://download.eclipse.org/mpc/release/1.5.2/
features=$features,org.eclipse.eef.ext.widgets.reference.feature.feature.group,org.eclipse.eef.sdk.feature.feature.group

#atlas
repos=$repos,http://download.eclipse.org/mmt/atl/updates/releases/3.3/
features=$features,org.eclipse.m2m.atl.feature.group

#jautodoc
repos=$repos,http://jautodoc.sourceforge.net/update/
features=$features,net.sf.jautodoc

#jformdesign
repos=$repos,http://download.formdev.com/jformdesigner/eclipse/
features=$features,com.jformdesigner.feature.group

#findbugs
repos=$repos,http://findbugs.cs.umd.edu/eclipse/
features=$features,edu.umd.cs.findbugs.plugin.eclipse.feature.group

#checkstyle
repos=$repos,http://eclipse-cs.sourceforge.net/update/
features=$features,net.sf.eclipsecs.source.feature.group,net.sf.eclipsecs.feature.group,com.github.sevntu.checkstyle.checks.feature.feature.group

#Draw2d
repos=$repos,http://marketplace.obeonetwork.com/updates/od61/
features=$features,org.eclipse.draw2d.feature.group,org.eclipse.draw2d.sdk.feature.group

#gef
repos=$repos,http://download.eclipse.org/tools/gef/updates/releases/
features=$features,org.eclipse.gef.feature.group,org.eclipse.gef.sdk.feature.group,org.eclipse.gef.source.feature.group,org.eclipse.gef.all.feature.group,org.eclipse.gef.examples.feature.group,org.eclipse.zest.feature.group,org.eclipse.zest.sdk.feature.group,org.eclipse.gef.examples.source.feature.group

#Sirius
repos=$repos,http://download.eclipse.org/sirius/updates/releases/4.1.1/neon
features=$features,org.eclipse.sirius.runtime.feature.group,org.eclipse.sirius.doc.feature.feature.group,org.eclipse.eef.ext.widgets.reference.feature.feature.group,org.eclipse.eef.sdk.feature.feature.group

#colortheme
repos=$repos,http://eclipse-color-theme.github.io/update/
features=$features,com.github.eclipsecolortheme.feature.feature.group

#python
repos=$repos,http://www.pydev.org/updates/
features=$features,org.python.pydev.feature.feature.group,org.python.pydev.feature.source.feature.group,org.python.pydev.mylyn.feature.feature.group

#puppet
repos=$repos,http://downloads.puppetlabs.com/geppetto/updates/4.x/
features=$features,com.puppetlabs.geppetto.eclipse.ide.feature.group

echo installing plugins in {{ eclipse.eclipse_real_home }}
{{ eclipse.eclipse_real_home }}/eclipse \
   -nosplash \
   -application org.eclipse.equinox.p2.director \
   -repository $repos \
   -installIU $features \
   -destination {{ eclipse.eclipse_real_home }} \
   -roaming \
   -p2.ws gtk -p2.arch x86_64 \
   -profile epp.package.jee

[[ $? == 0 ]] && touch {{ eclipse.eclipse_real_home }}/.plugins_saltstate_done 2>/dev/null

