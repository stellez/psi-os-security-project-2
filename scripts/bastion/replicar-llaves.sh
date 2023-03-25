#!/bin/bash
apt install sshpass -y
su - web01 -c "sshpass -p psi-web-01 scp -r .ssh/ web01@10.0.0.2:~"
su - web02 -c "sshpass -p psi-web-02 scp -r .ssh/ web02@10.0.0.2:~"
su - dba01 -c "sshpass -p psi-dba-01 scp -r .ssh/ dba01@10.0.0.3:~"
su - dba02 -c "sshpass -p psi-dba-02 scp -r .ssh/ dba02@10.0.0.3:~"
su - adm01 -c "sshpass -p psi-adm-01 scp -r .ssh/ adm01@10.0.0.2:~"
su - adm01 -c "sshpass -p psi-adm-01 scp -r .ssh/ adm01@10.0.0.3:~"
su - adm02 -c "sshpass -p psi-adm-02 scp -r .ssh/ adm02@10.0.0.2:~"
su - adm02 -c "sshpass -p psi-adm-02 scp -r .ssh/ adm02@10.0.0.3:~"
