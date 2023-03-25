#!/bin/bash
echo "Ingrese la IP publica del BASTION HOST"
read REPLY
BASTION_HOST=$REPLY
apt install sshpass -y
su - web01 -c "ssh-keygen -b 4096 -f ~web01/.ssh/id_rsa -N 'Me encanta Linux'"
su - web01 -c "sshpass -p psi-web-01 ssh-copy-id web01@$BASTION_HOST"
su - web01 -c "printf 'Host 10.0.0.2\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"

su - web02 -c "ssh-keygen -b 4096 -f ~web02/.ssh/id_rsa -N 'Me encanta Linux'"
su - web02 -c "sshpass -p psi-web-02 ssh-copy-id web02@$BASTION_HOST"
su - web02 -c "printf 'Host 10.0.0.2\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"

su - dba01 -c "ssh-keygen -b 4096 -f ~dba01/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba01 -c "sshpass -p psi-dba-01 ssh-copy-id dba01@$BASTION_HOST"
su - dba01 -c "printf 'Host 10.0.0.3\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"

su - dba02 -c "ssh-keygen -b 4096 -f ~dba02/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba02 -c "sshpass -p psi-dba-02 ssh-copy-id dba02@$BASTION_HOST"
su - dba02 -c "printf 'Host 10.0.0.3\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"

su - adm01 -c "ssh-keygen -b 4096 -f ~adm01/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm01 -c "sshpass -p psi-adm-01 ssh-copy-id adm01@$BASTION_HOST"
su - adm01 -c "printf 'Host 10.0.0.2\n\tProxyJump $BASTION_HOST\n\rHost 10.0.0.3\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"

su - adm02 -c "ssh-keygen -b 4096 -f ~adm02/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm02 -c "sshpass -p psi-adm-02 ssh-copy-id adm02@$BASTION_HOST <<< yes"
su - adm02 -c "printf 'Host 10.0.0.2\n\tProxyJump $BASTION_HOST\n\rHost 10.0.0.3\n\tProxyJump $BASTION_HOST\n' >> ~/.ssh/config"
