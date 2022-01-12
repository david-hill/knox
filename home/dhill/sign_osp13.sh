#brew tag-pkg rhos-13.0-rhel-7-hotfix python-os-brick-2.3.9-8.el7ost
#brew call signBuild python-os-brick-2.3.9-8.el7ost beta2

brew tag-pkg rhos-13.0-rhel-7-hotfix openstack-nova-17.0.13-38.el7ost
brew call signBuild openstack-nova-17.0.13-38.el7ost beta2

echo openstack-nova-17.0.13-38.el7ost
echo path = http://download.eng.bos.redhat.com/brewroot/packages/openstack-nova/17.0.12/12.el7ost/data/signed/f21541eb/noarch/

