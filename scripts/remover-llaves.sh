#!/bin/bash
su - web01 -c "rm ~/.ssh/authorized_keys"
su - web02 -c "rm ~/.ssh/authorized_keys"
su - dba01 -c "rm ~/.ssh/authorized_keys"
su - dba02 -c "rm ~/.ssh/authorized_keys"
su - adm01 -c "rm ~/.ssh/authorized_keys"
su - adm02 -c "rm ~/.ssh/authorized_keys"