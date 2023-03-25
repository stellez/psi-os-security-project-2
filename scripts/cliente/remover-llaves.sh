#!/bin/bash
su - web01 -c "rm -r ~/.ssh"
su - web02 -c "rm -r ~/.ssh"
su - dba01 -c "rm -r ~/.ssh"
su - dba02 -c "rm -r ~/.ssh"
su - adm01 -c "rm -r ~/.ssh"
su - adm02 -c "rm -r ~/.ssh"