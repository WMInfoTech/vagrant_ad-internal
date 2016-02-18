#!/bin/bash
#
# vagrant pre-puppet provisoning script.
# Runs before puppet (See the Vagrantfile):
#  runs apt-get update (otherwise pkgs can't get installed)
#  installs ruby-dev (pre-req for librarian-puppet)
#  installs librarian-puppet via gem
#  runs librarian-puppet to install puppet modules
#  creates /tmp/pre-puppet.ran file, so another provision won't bother running this script
#
PROGNAME=pre-puppet.sh
RANFILE=/tmp/pre-puppet.ran
#
if [ -f ${RANFILE} ]; then
  sudo /opt/puppetlabs/bin/puppet apply --modulepath=/vagrant/puppet/modules /vagrant/puppet/manifests/site.pp
  exit 0
fi
#
sudo apt-get purge puppet puppetlabs-release -y
wget http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb
sudo dpkg -i puppetlabs-release-pc1-trusty.deb
sudo apt-get update
sudo apt-get install puppet-agent -y
rm *.deb
sudo /opt/puppetlabs/bin/puppet apply --modulepath=/vagrant/puppet/modules /vagrant/puppet/manifests/site.pp
date > ${RANFILE}
exit 0
