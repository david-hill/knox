cd /usr/sbin
for p in *; do if [ ! -L $p ]; then mv $p ../bin; fi; done
#mv iptables* ../bin
#mv ip6tables* ../bin
mv grub2-setpassword ../bin
mv mkdict ../bin
cd ../
mv sbin sbin.old
ln -s bin sbin
cd bin
yum reinstall iptables-legacy
