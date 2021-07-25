FROM centos
COPY rcm-tools.repo /etc/yum.repos.d/rcm-tools.repo
COPY resolv.conf /etc/resolv.conf
COPY ca.crt /etc/pki
COPY krb5.conf /etc/krb5.conf
COPY RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust extract
RUN cat /etc/resolv.conf
RUN echo "nameserver 10.5.30.160" >> /etc/resolv.conf && cat /etc/resolv.conf && echo "10.0.14.183 download.devel.redhat.com" >> /etc/hosts && ping -c1 10.5.30.160 && yum install -y krb5-workstation rhpkg
RUN cat /etc/resolv.conf

