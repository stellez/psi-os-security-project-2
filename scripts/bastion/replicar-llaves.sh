#!/bin/bash
REQUIRED_PKG="sshpass"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi
su - web01 -c "sshpass -p psi-web-01 scp -o StrictHostKeyChecking=accept-new -r .ssh/ web01@10.0.0.2:~"
su - web02 -c "sshpass -p psi-web-02 scp -o StrictHostKeyChecking=accept-new -r .ssh/ web02@10.0.0.2:~"
su - dba01 -c "sshpass -p psi-dba-01 scp -o StrictHostKeyChecking=accept-new -r .ssh/ dba01@10.0.0.3:~"
su - dba02 -c "sshpass -p psi-dba-02 scp -o StrictHostKeyChecking=accept-new -r .ssh/ dba02@10.0.0.3:~"
su - adm01 -c "sshpass -p psi-adm-01 scp -o StrictHostKeyChecking=accept-new -r .ssh/ adm01@10.0.0.2:~"
su - adm01 -c "sshpass -p psi-adm-01 scp -o StrictHostKeyChecking=accept-new -r .ssh/ adm01@10.0.0.3:~"
su - adm02 -c "sshpass -p psi-adm-02 scp -o StrictHostKeyChecking=accept-new -r .ssh/ adm02@10.0.0.2:~"
su - adm02 -c "sshpass -p psi-adm-02 scp -o StrictHostKeyChecking=accept-new -r .ssh/ adm02@10.0.0.3:~"
