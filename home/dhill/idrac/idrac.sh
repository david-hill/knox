#!/bin/bash

echo -n 'Host: '
read drachost

echo -n 'Username: '
read dracuser

echo -n 'Password: '
read -s dracpwd
echo

java -cp avctKVM.jar -Djava.library.path=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.192.b12-0.fc30.x86_64/jre/lib com.avocent.idrac.kvm.Main ip=$drachost kmport=5900 vport=5900 user=$dracuser passwd=$dracpwd apcp=1 version=2 vmprivilege=true "helpurl=https://$drachost:443/help/contents.html"
