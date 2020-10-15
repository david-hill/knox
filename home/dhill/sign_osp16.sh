#brew tag-pkg fast-datapath-rhel-8-candidate ovn2.11-2.11.1-46.el8fdp
#brew tag-pkg fast-datapath-rhel-8 ovn2.11-2.11.1-46.el8fdp
#brew call signBuild ovn2.11-2.11.1-46.el8fdp beta2

#openstack-cinder-15.1.1-0.20200403213515.cfa2d1b.el8ost
echo openstack-neutron-12.1.0-9.el7ost
echo path = http://download.eng.bos.redhat.com/brewroot/packages/openstack-nova/17.0.12/12.el7ost/data/signed/f21541eb/noarch/

brew tag-pkg rhos-16.0-rhel-8-hotfix openstack-tripleo-heat-templates-11.3.2-1.20200828163406.94ba270.el8ost
brew call signBuild openstack-tripleo-heat-templates-11.3.2-1.20200828163406.94ba270.el8ost beta2

brew tag-pkg rhos-16.0-rhel-8-hotfix python-paunch-5.3.3-1.20200826193407.ed2c015.el8ost
brew call signBuild python-paunch-5.3.3-1.20200826193407.ed2c015.el8ost beta2

