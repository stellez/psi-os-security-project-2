#!/bin/bash
echo "Ingrese la IP publica del BASTION HOST"
read
BASTION_HOST=$REPLY
su - web01 -c "ssh-keygen -b 4096 -f ~web01/.ssh/id_rsa -N 'Me encanta Linux' & ssh-copy-id -o StrictHostKeyChecking=no web01@$BASTION_HOST"
su - web01 -c "printf Host 10.0.0.2\n\tProxyJump $BASTION_HOST > ~/.ssh/config"
su - web02 -c "ssh-keygen -b 4096 -f ~web02/.ssh/id_rsa -N 'Me encanta Linux'"
su - web02 -c "ssh-copy-id -o StrictHostKeyChecking=no web02@$BASTION_HOST"
su - dba01 -c "ssh-keygen -b 4096 -f ~dba01/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba01 -c "ssh-copy-id -o StrictHostKeyChecking=no dba01@$BASTION_HOST"
su - dba02 -c "ssh-keygen -b 4096 -f ~dba02/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba02 -c "ssh-copy-id -o StrictHostKeyChecking=no dba02@$BASTION_HOST"
su - adm01 -c "ssh-keygen -b 4096 -f ~adm01/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm01 -c "ssh-copy-id -o StrictHostKeyChecking=no adm01@$BASTION_HOST"
su - adm02 -c "ssh-keygen -b 4096 -f ~adm02/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm02 -c "ssh-copy-id -o StrictHostKeyChecking=no adm02@$BASTION_HOST"