sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo cp etc/yum.repos.d/* /etc/yum.repos.d
sudo cp etc/sysconfig/network-scripts/* /etc/sysconfig/network-scripts
sudo systemctl restart NetworkManager

if ! $(grep -qi rawhide /etc/redhat-release) ; then
    sudo dnf system-upgrade download --refresh --releasever=rawhide --nogpgcheck
    cd /etc/pki/rpm-gpg/
    ls  | sort -k1,1V | grep x86_64 | tail -1  | xargs -I% sudo ln -s % RPM-GPG-KEY-fedora-rawhide-x86_64
    sudo dnf system-upgrade reboot # https://bugzilla.redhat.com/show_bug.cgi?id=1612547
else
    wget https://password.corp.redhat.com/RH-IT-Root-CA.crt
    sudo cp RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors
    sudo update-ca-trust extract
    sudo systemctl enable fstrim.service
    sudo systemctl start fstrim.service
    sudo timedatectl set-timezone America/Montreal
    sudo hostnamectl set-hostname knox.orion
    sudo yum install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
    sudo yum install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm
    sudo yum install -y terminator vim google-chrome slack skypeforlinux vlc hexchat thunderbird rdesktop virt-manager rpm-build gcc meson perl-ExtUtils-Embed perl-devel dbus-glib-devel gtk2-devel iso-codes-devel libcanberra-devel libnotify-devel pciutils-devel libproxy-devel lua-devel openssl-devel python3-devel jenkins ntpdate ntp git-review nicotine+ transmission linphone sshuttle libvirt-client VirtualBox vinagre net-snmp net-snmp-utils icedtea-web tmux screen libnsl shairport-sync dnf-utils yum-utils nmap strace uptimed xdotool python3-reno libguestfs-tools python2-pyxattr python-pep8
    sudo cp root/.vimrc /root
    sudo cp home/dhill/.vimrc /home/dhill
    sudo cp etc/ntp.conf /etc
    sudo cp etc/snmp/* /etc/snmp/
    sudo systemctl restart ntpd
    sudo systemctl enable ntpd
    sudo cp etc/pki/tls/certs/* /etc/pki/tls/certs/
    sudo cp etc/NetworkManager/system-connections/* /etc/NetworkManager/system-connections
    sudo systemctl restart NetworkManager
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Music/ /home/dhill/Music/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Documents/ /home/dhill/Documents/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Desktop/ /home/dhill/Desktop/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Pictures/ /home/dhill/Pictures/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Downloads/ /home/dhill/Downloads/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.27:/var/lib/jenkins/ /var/lib/jenkins/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.27:/home/jenkins/ /home/jenkins/
    cd rpms
    for package in *.rpm; do
      sudo yum install -y $package
    done
    sudo yum install -y flash-player-ppapi
    mkdir tmp
    tar zxvf *.gz -C tmp
    sudo mv tmp/libflashplayer.so /usr/lib64/mozilla/plugins
    cp linux-brprinter-installer-2.2.0-1.gz tmp/
    gunzip -c linux-brprinter-installer-2.2.0-1.gz > tmp/linux-brprinter-installer-2.2.0-1
    chmod 755 tmp/linux-brprinter-installer-2.2.0-1
    echo "Y" | sudo tmp/./linux-brprinter-installer-2.2.0-1 dcp-7030
    rm -rf tmp
    sudo cp /usr/lib64/flash-plugin/libpepflashplayer.so /usr/lib64/mozilla/plugins
    sudo cp etc/selinux/config /etc/selinux
    sudo cp etc/gdm/* /etc/gdm/
    sudo setenforce 0
    sudo systemctl enable snmpd
    sudo systemctl start snmpd
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl enable sshd
    sudo systemctl start sshd
    sudo systemctl enable shairport-sync
    sudo systemctl start shairport-sync
    sudo systemctl enable uptimed
    sudo systemctl start uptimed
    sudo firewall-cmd --zone=internal --add-service snmp --permanent
    sudo firewall-cmd --zone=FedoraWorkstation --add-service snmp --permanent
    sudo firewall-cmd --reload
    cp usr/lib/jvm/java-1.8.0-openjdk-1.8.0.192.b12-0.fc30.x86_64/jre/lib/security/java.security /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.192.b12-0.fc30.x86_64/jre/lib/security/java.security
    cp etc/crypto-policies/back-ends/java.config /etc/crypto-policies/back-ends/java.config
fi
