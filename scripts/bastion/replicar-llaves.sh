#!/bin/bash
su - web01 -c "scp -r .ssh/authorized_keys web01@10.0.0.2:~"
su - web02 -c "scp -r .ssh/authorized_keys web02@10.0.0.2:~"
su - dba01 -c "scp -r .ssh/authorized_keys dba01@10.0.0.3:~"
su - dba02 -c "scp -r .ssh/authorized_keys dba02@10.0.0.3:~"
su - adm01 -c "scp -r .ssh/authorized_keys adm01@10.0.0.2:~"
su - adm01 -c "scp -r .ssh/authorized_keys adm01@10.0.0.3:~"
su - adm02 -c "scp -r .ssh/authorized_keys adm02@10.0.0.2:~"
su - adm02 -c "scp -r .ssh/authorized_keys adm02@10.0.0.3:~"
