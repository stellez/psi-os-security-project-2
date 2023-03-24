#!/bin/bash
groupadd -g 1200 webmasters
groupadd -g 1300 databaseadmins
groupadd -g 1400 administrators

useradd -u 1201 -s /bin/bash -d /home/web01/ -m -G webmasters web01 -p psi-web-01
useradd -u 1202 -s /bin/bash -d /home/web02/ -m -G webmasters web02 -p psi-web-02
useradd -u 1301 -s /bin/bash -d /home/dba01/ -m -G databaseadmins dba01 -p psi-dba-01
useradd -u 1302 -s /bin/bash -d /home/dba02/ -m -G databaseadmins dba02 -p psi-dba-02
useradd -u 1401 -s /bin/bash -d /home/adm01/ -m -G administrators adm01 -p psi-adm-01
useradd -u 1402 -s /bin/bash -d /home/adm02/ -m -G administrators adm02 -p psi-adm-02