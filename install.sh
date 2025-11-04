sudo dnf upgrade --refresh -y
sudo dnf install dnf-plugin-system-upgrade -y
sudo cp etc/yum.repos.d/* /etc/yum.repos.d
sudo cp etc/sysconfig/network-scripts/* /etc/sysconfig/network-scripts
sudo cp etc/krb5.conf /etc/krb5.conf

mkdir -p /etc/opt/chrome/policies/managed
cp etc/opt/chrome/policies/managed/* etc/opt/chrome/policies/managed

sudo systemctl restart NetworkManager

if ! $(grep -qi rawhide /etc/redhat-release) ; then
    sudo dnf system-upgrade download --refresh --releasever=rawhide --nogpgcheck
    cd /etc/pki/rpm-gpg/
    ls  | sort -k1,1V | grep x86_64 | tail -1  | xargs -I% sudo ln -s % RPM-GPG-KEY-fedora-rawhide-x86_64
    sudo dnf system-upgrade reboot # https://bugzilla.redhat.com/show_bug.cgi?id=1612547
else
    wget https://password.corp.redhat.com/RH-IT-Root-CA.crt -O /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
    wget https://certs.corp.redhat.com/certs/2022-IT-Root-CA.pem -O /etc/pki/ca-trust/source/anchors/2022-IT-Root-CA.pem
    wget https://certs.corp.redhat.com/certs/Current-IT-Root-CAs.pem -O /etc/pki/ca-trust/source/anchors/Current-IT-Root-CAs.pem
#    wget https://download.devel.redhat.com/rel-eng/RCMTOOLS/rcm-tools-fedora.repo
#    sudo cp rcm-tools-fedora.repo /etc/yum.repos.d/
    sudo cp RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors
    sudo usermod -g wheel dhill
    sudo update-ca-trust extract
    sudo systemctl enable fstrim.service
    sudo systemctl start fstrim.service
    sudo timedatectl set-timezone America/Montreal
    sudo hostnamectl set-hostname knox.orion
    sudo yum install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
    sudo yum install -y https://github.com/ringcentral/ringcentral-community-app/releases/download/v0.0.11/ringcentral-community-app-0.0.11.x86_64.rpm
    sudo yum install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm
    sudo yum install -y https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
    sudo yum install -y https://binaries.webex.com/WebexDesktop-CentOS-Official-Package/Webex.rpm --nogpgcheck
    sudo dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo
    sudo yum install -y https://download.devel.redhat.com/rel-eng/RCMTOOLS/RCMTOOLS-2.0-updates-F-33-20201007.0/compose/Everything/x86_64/os/Packages/brewkoji-1.24-1.fc33eng.noarch.rpm https://download.devel.redhat.com/rel-eng/RCMTOOLS/RCMTOOLS-2.0-updates-F-33-20201007.0/compose/Everything/x86_64/os/Packages/python3-brewkoji-1.24-1.fc33eng.noarch.rpm
    sudo yum install -y rhpkg
    sudo yum install -y gdm terminator vim google-chrome slack skypeforlinux vlc hexchat thunderbird rdesktop virt-manager rpm-build gcc dbus-glib-devel gtk2-devel iso-codes-devel pciutils-devel lua-devel openssl-devel ntpdate ntp git-review nicotine+ transmission linphone sshuttle libvirt-client VirtualBox vinagre net-snmp net-snmp-utils icedtea-web tmux screen libnsl shairport-sync dnf-utils yum-utils nmap strace uptimed xdotool python3-reno libguestfs-tools python2-pyxattr python-pep8 python3-tox libpq-devel collectl mysql-server gimp meson perl-devel perl-ExtUtils-Embed libcanberra-devel dbus-glib-devel libnotify-devel libproxy-devel python3-devel python3-koji krb5-workstation koji npm chrome-gnome-shell nvidia-driver nvidia-settings flex ncurses-devel bison rdopkg oidentd alsa-lib-devel cargo hunspell-devel libXt-devel libcurl-devel llvm-devel nasm nss-devel nspr-devel nss-static pulseaudio-libs-devel rust startup-notification-devel yasm cups libvirt virt-viewer NetworkManager-openvpn NetworkManager-openvpn-gnome firefox lm_sensors alsa-utils pavucontrol pulseaudio-utils gedit libreoffice xorg-x11-xfs-utils xorg-x11-xfs gnome-themes gdb libselinux-python libsemanage-python ansible facter hiera gnome-extensions-app snapd gnome-tweaks perf gtkglext-libs wine-core iotop yubikey-personalization-gui nautilus runc git-lfs gnome-calculator
    sudo rpm -ivh --nodeps http://rpm.anydesk.com/fedora/x86_64/Packages/anydesk_6.2.0-1_x86_64.rpm
    sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
    sudo yum install fontconfig java-11-openjdk
    sudo yum install jenkins
    sudo yum groupinstall -y Fonts
    sudo yum groupinstall -y 'GNOME Desktop Environment'
    sudo yum install -y https://zoom.us/client/latest/zoom_x86_64.rpm
    sudo systemctl set-default graphical
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo cp root/.vimrc /root
    sudo cp home/dhill/.vimrc /home/dhill
    sudo cp home/dhill/.bash_profile /home/dhill
    sudo cp etc/ssh/sshd_config /etc/ssh
    sudo cp etc/ntp.conf /etc
    sudo cp etc/snmp/* /etc/snmp/
    sudo systemctl restart ntpd
    sudo systemctl enable ntpd
    sudo cp etc/pki/tls/certs/* /etc/pki/tls/certs/
    sudo cp etc/NetworkManager/system-connections/* /etc/NetworkManager/system-connections
    sudo chmod 600 /etc/NetworkManager/system-connections/*
    export CHROME_VERSION=91.0.4472.164-1
    sudo yum install -y https://dl.google.com/linux/chrome/rpm/stable/x86_64/google-chrome-stable-${CHROME_VERSION}.x86_64.rpm
    sudo systemctl restart NetworkManager
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.37:/home/dhill/.ssh/ /root/.ssh/
    sudo chown root:root /root/.ssh -R
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.37:/etc/pki/tls/certs/2015-RH-IT-ROOT-CA.pem /etc/pki/tls/certs/2015-RH-IT-ROOT-CA.pem
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.37:/home/dhill/ /home/dhill/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.37:/var/lib/jenkins/ /var/lib/jenkins/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.37:/home/jenkins/ /home/jenkins/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.37:/var/lib/libvirt/images /var/lib/libvirt/images
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.37:/etc/libvirt/qemu/ /etc/libvirt/qemu/
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
    sudo cp usr/share/applications/icq.desktop /usr/share/applications/icq.desktop
    sudo cp etc/selinux/config /etc/selinux
    sudo cp etc/sysconfig/oidentd /etc/sysconfig
    sudo cp etc/oidentd.conf /etc/
    sudo cp etc/gdm/* /etc/gdm/
    sudo setenforce 0
    sudo systemctl enable snapd
    sudo systemctl start snapd
    sudo systemctl enable snmpd
    sudo systemctl start snmpd
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    sudo systemctl enable oidentd
    sudo systemctl start oidentd
    sudo systemctl enable sshd
    sudo systemctl start sshd
    sudo systemctl enable shairport-sync
    sudo systemctl start shairport-sync
    sudo systemctl enable uptimed
    sudo systemctl start uptimed
    sudo firewall-cmd --zone=internal --add-service snmp --permanent
    sudo firewall-cmd --zone=FedoraWorkstation --add-service snmp --permanent
    sudo firewall-cmd --zone=internal --add-port=113/tcp --permanent
    sudo firewall-cmd --zone=FedoraWorkstation --add-port=113/tcp --permanent
    sudo firewall-cmd --zone=internal --add-port=161/tcp --permanent
    sudo firewall-cmd --zone=FedoraWorkstation --add-port=161/tcp --permanent
    sudo firewall-cmd --zone=FedoraServer --add-port=161/tcp --permanent
    sudo firewall-cmd --zone=internal --add-port=161/udp --permanent
    sudo firewall-cmd --zone=FedoraWorkstation --add-port=161/udp --permanent
    sudo firewall-cmd --zone=FedoraServer --add-port=161/udp --permanent
    sudo firewall-cmd --reload
    sudo usermod -G libvirt dhill
    sudo cp etc/libvirt/libvirtd.conf /etc/libvirt
    sudo systemctl restart libvirtd
    sudo cp usr/lib/jvm/java-1.8.0-openjdk-1.8.0.192.b12-0.fc30.x86_64/jre/lib/security/java.security /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.192.b12-0.fc30.x86_64/jre/lib/security/java.security
    sudo cp etc/crypto-policies/back-ends/java.config /etc/crypto-policies/back-ends/java.config
    sudo cp usr/bin/google-chrome /usr/bin/google-chrome
    sudo snap install icq-im
    sudo snap install whatsdesk
    sudo snap install skype
    sudo snap install signal-desktop
    sudo cp /var/lib/snapd/snap/whatsdesk/current/meta/gui/icon.png /usr/share/pixmaps/whatsapp.png
    sudo cp usr/share/applications/whatsapp.desktop /usr/share/applications/whatsapp.desktop
    sudo cp usr/share/applications/whatsapp.desktop /home/dhill/.config/autostart
fi
