sudo dnf upgrade --refresh
sudo dnf install dnf-plugin-system-upgrade
sudo cp etc/yum.repos.d/* /etc/yum.repos.d

if ! $(grep -qi rawhide /etc/redhat-release) ; then
    sudo dnf system-upgrade download --refresh --releasever=rawhide --nogpgcheck
    cd /etc/pki/rpm-gpg/
    ls  | sort -k1,1V | grep x86_64 | tail -1  | xargs -I% sudo ln -s % RPM-GPG-KEY-fedora-rawhide-x86_64
    sudo dnf system-upgrade reboot # https://bugzilla.redhat.com/show_bug.cgi?id=1612547
else
    sudo systemctl enable fstrim.service
    sudo systemctl start fstrim.service
    sudo yum install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-rawhide.noarch.rpm
    sudo yum install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-rawhide.noarch.rpm
    sudo yum install -y terminator vim google-chrome slack skypeforlinux vlc hexchat thunderbird rdesktop virt-manager rpm-build gcc meson perl-ExtUtils-Embed perl-devel dbus-glib-devel gtk2-devel iso-codes-devel libcanberra-devel libnotify-devel pciutils-devel libproxy-devel lua-devel openssl-devel python3-devel jenkins ntpdate ntp
    sudo cp root/.vimrc /root
    sudo cp home/dhill/.vimrc /home/dhill
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Music/* /home/dhill/Music/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Documents/* /home/dhill/Documents/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Desktop/* /home/dhill/Desktop/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Pictures/* /home/dhill/Pictures/
    rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress dhill@192.168.1.27:/home/dhill/Downloads/* /home/dhill/Downloads/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.27:/var/lib/jenkins/* /var/lib/jenkins/
    sudo rsync -avz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress 192.168.1.27:/home/jenkins/* /home/jenkins/
fi
