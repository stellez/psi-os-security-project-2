#!/bin/bash
echo "Ingrese la IP publica del BASTION HOST"
read REPLY
BASTION_HOST=$REPLY

REQUIRED_PKG="sshpass"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
  echo "No $REQUIRED_PKG. Setting up $REQUIRED_PKG."
  sudo apt-get --yes install $REQUIRED_PKG
fi

su - web01 -c "ssh-keygen -b 4096 -f ~web01/.ssh/id_rsa -N 'Me encanta Linux'"
su - web01 -c "printf 'Host 10.0.0.2\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - web01 -c "echo 'psi-web-01' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id web01@$BASTION_HOST"

su - web02 -c "ssh-keygen -b 4096 -f ~web02/.ssh/id_rsa -N 'Me encanta Linux'"
su - web02 -c "printf 'Host 10.0.0.2\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - web02 -c "echo 'psi-web-02' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id web02@$BASTION_HOST"

su - dba01 -c "ssh-keygen -b 4096 -f ~dba01/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba01 -c "printf 'Host 10.0.0.3\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - dba01 -c "echo 'psi-dba-01' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id dba01@$BASTION_HOST"

su - dba02 -c "ssh-keygen -b 4096 -f ~dba02/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba02 -c "printf 'Host 10.0.0.3\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - dba02 -c "echo 'psi-dba-02' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id dba02@$BASTION_HOST"

su - adm01 -c "ssh-keygen -b 4096 -f ~adm01/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm01 -c "printf 'Host 10.0.0.2\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n\rHost 10.0.0.3\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - adm01 -c "echo 'psi-adm-01' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id adm01@$BASTION_HOST"

su - adm02 -c "ssh-keygen -b 4096 -f ~adm02/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm02 -c "printf 'Host 10.0.0.2\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n\rHost 10.0.0.3\n\tStrictHostKeyChecking accept-new\nProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
su - adm02 -c "echo 'psi-adm-02' > pass-file & chmod 0400 pass-file & sshpass -f pass-file ssh-copy-id adm02@$BASTION_HOST"
