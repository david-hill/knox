[dhill@collab-shell ~]$ cat osp13_sign.sh 
brew tag-pkg rhos-13.0-rhel-7-hotfix openstack-heat-agents-1.5.4-4.el7ost
brew call signBuild openstack-heat-agents-1.5.4-4.el7ost beta2

echo openstack-neutron-12.1.0-9.el7ost
echo path = http://download.eng.bos.redhat.com/brewroot/packages/openstack-nova/17.0.12/12.el7ost/data/signed/f21541eb/noarch/

