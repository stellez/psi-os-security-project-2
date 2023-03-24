#!/bin/bash
su - web01 -c "ssh-keygen -b 4096 -f ~web01/.ssh/id_rsa -N 'Me encanta Linux'"
su - web02 -c "ssh-keygen -b 4096 -f ~web02/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba01 -c "ssh-keygen -b 4096 -f ~dba01/.ssh/id_rsa -N 'Me encanta Linux'"
su - dba02 -c "ssh-keygen -b 4096 -f ~dba02/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm01 -c "ssh-keygen -b 4096 -f ~adm01/.ssh/id_rsa -N 'Me encanta Linux'"
su - adm02 -c "ssh-keygen -b 4096 -f ~adm02/.ssh/id_rsa -N 'Me encanta Linux'"