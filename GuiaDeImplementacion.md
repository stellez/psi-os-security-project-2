## Proyecto Final - OS Security I

Universidad Galileo

Rodnal Tellez - 11002972

Douglas Figueroa - 13000530
___

**Índice**
- [Proyecto Final - OS Security I](#proyecto-final---os-security-i)
- [**Introducción**](#introducción)
- [**Objetivo**](#objetivo)
- [**Alcance Del Proyecto**](#alcance-del-proyecto)
- [**Audiencia**](#audiencia)
- [**Definición De La Solución Propuesta**](#definición-de-la-solución-propuesta)
- [**Requerimientos**](#requerimientos)
- [**Diagrama De Infraestructura**](#diagrama-de-infraestructura)
- [**Detalle De Instalación**](#detalle-de-instalación)
  - [Creación de grupos](#creación-de-grupos)
  - [Instalación de SSH](#instalación-de-ssh)
  - [Deshabilitar autenticación por contraseña](#deshabilitar-autenticación-por-contraseña)
  - [Autenticación con SSH llave pública y privada](#autenticación-con-ssh-llave-pública-y-privada)
  - [Configuración de diccionario de contraseñas no permitidas](#configuración-de-diccionario-de-contraseñas-no-permitidas)
  - [Configuración de acceso a servidores por medio de grupos](#configuración-de-acceso-a-servidores-por-medio-de-grupos)
  - [Configuración de ejecución de servicios sin contraseña - `systemctl`](#configuración-de-ejecución-de-servicios-sin-contraseña---systemctl)
  - [Configuración de Firewall](#configuración-de-firewall)
- [**Personalización**](#personalización)
- [**Inventario de Equipos**](#inventario-de-equipos)
- [**Inventario de Credenciales Iniciales**](#inventario-de-credenciales-iniciales)
- [**Pruebas Docuentadas**](#pruebas-docuentadas)
- [**Referencias**](#referencias)
- [**Anexos**](#anexos)



## **Introducción**

___
## **Objetivo**

Crear una infraestructura segura de equipos que estarán ejecutando servicios web y de base de datos, que los servicios puedan ser accedidos únicamente por los grupos y usuarios permitidos y bloquear el acceso a cualquier otro usuario.

Poner en práctica el uso de herramientas y configuraciones en el sistema operativo para controlar los accesos y bloqueos, tales como:

* Ubuntu Server 22.04
* SSH
* Firewal UFW
* Libpam Crack-lib
* MySQL
* Wordpress
* Systemctl

___
## **Alcance Del Proyecto**

___
## **Audiencia**

___
## **Definición De La Solución Propuesta**
Se necesita una infraestructura de 3 equipos con ubuntu server 22.04 para alojar los servicios requeridos y una máquina adicional para gestionar el acceso a dichos servicios.
* **Cliente Bastion**: este equipo será el puente seguro para conectarse al servidor web y servidor de base de datos.
* **Servidor Web**: servidor utilizado para alojar los servicios web.
* **Servidor Base de Datos**: servidor utilizado para alojar los servicios de base de datos.
* **Cliente Externo**: Para nuestro escenario, creamos una cuarta máquina virtual la cuál será utilizada como un cliente externo para acceder a Bastion y las pruebas necesarias de funcionalidad.

___
## **Requerimientos**

___
## **Diagrama De Infraestructura**
![](diagrama.png)
___
## **Detalle De Instalación**

### Creación de grupos

Utilizando el usuario `admin` crear los siguientes grupos y usuarios en cada equipo.

Se tendrán los siguientes grupos:
* `webmasters`: usuarios para administrar el servidor web
* `databaseadmins`: usuarios para administrar el servidor de base de datos
* `administrators`: usuarios con permisos de administrador para entrar al servidor web y base de datos

Los grupos deben ser creados en los 3 servidores y la máquina host cliente.

Para cada usuario, utilizaremos la contraseña inicial: `[por definir]`

Entrar a los 4 equipos y ejecutar los siguiente comandos
```
sudo groupadd -g 1200 webmasters
sudo adduser -u 1201 web01
sudo adduser -u 1202 web02
sudo usermod -a -G webmasters web01
sudo usermod -a -G webmasters web02

sudo groupadd -g 1300 databaseadmins
sudo adduser -u 1301 dba01
sudo adduser -u 1302 dba02
sudo usermod -a -G databaseadmins dba01
sudo usermod -a -G databaseadmins dba02

sudo groupadd -g 1400 administrators
sudo adduser -u 1401 adm01
sudo adduser -u 1402 adm02
sudo usermod -a -G administrators adm01
sudo usermod -a -G administrators adm02
```
___

### Instalación de SSH

Utilizando el usuario `admin`.

Para que los usuarios puedan autenticarse con llave pública y privada debe realizarse la siguiente configuración:

Si el equipo `cliente externo` no cuenta con el cliente de SSH, instalarlo de la siguiente forma.
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install openssh-client
```

Para cada servidor, bastion, base de datos y web, instalar OpenSHH server.
```
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install openssh-server
```
Habilitar e iniciar el servicio
```
sudo systemctl enable ssh
sudo systemctl start ssh
```
Verificamos que el servicio se encuentre activo
```
sudo systemctl status ssh
```
___

### Deshabilitar autenticación por contraseña

Utilizando el usuario `admin`.

Una vez tengamos los servicios de SSH instalados en Bastion, Web Server y Base de Datos, deshabilitaremos la autenticación por medio de contraseña.

En cada servidor deben realizarse las siguientes tareas.

Entrar al archivo sshd_config
```
sudo nano /etc/ssh/sshd_config
```
Buscar la línea comentada
```
#PasswordAuthentication yes
```

Descomentar la línea y cambiar el valor a `no`
```
PasswordAuthentication no
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Reiniciarmos el servicio de SSH
```
sudo systemctl restart ssh
```
___

### Autenticación con SSH llave pública y privada

Utilizando el usuario `admin`.

Una vez instalados los servicios SSH, procedemos a generar la llavé pública y privada para autenticación.

Vamos al equipo Cliente Externo y generamos la llave indicando que será generada con 4096 bits
```
ssh-keygen -b 4096
```
Nos solicitará una frase, la frase debe ser: `Me encanta Linux`

Ahora que tenemos la llave generada, la debemos copiar al equipo Bastion con la ip pública que nos haya asignado la red.
```
ssh-copy-id admin@[ip-pública-bastion]
```
Entramos al equipo Bastion que nos solicitará la frase.
```
ssh admin@[ip-pública-bastion]
```
Una vez dentro del equipo Bastion, generaremos la llave pública y privada para conectarnos al servidor web y servidor de base de datos.

Ejecutar
```
ssh-keygen -b 4096
```
Nos solicitará una frase, la frase debe ser: `Me encanta Linux`

Copiamos la llave al servidor web
```
ssh-copy-id admin@10.0.0.2
```
Copiamos la llave al servidor de base de datos
```
ssh-copy-id admin@10.0.0.3
```
Probamos conexión a cada servidor el cuál nos solicitará la frase `Me encanta Linux`, una vez dentro salimos del servidor.

Web
```
ssh admin@10.0.0.2
# Entre phrase
exit
```

Base de datos
```
ssh admin@10.0.0.3
# Entre phrase
exit
```

Estando en el cliente externo, se puede realizar una conexión directa, ya sea al servidor web o al de base de datos con el siguiente comando

Servidor web
```
ssh -J [ip-pública-bastion] 10.0.0.2
```

Servidor base de datos
```
ssh -J [ip-pública-bastion] 10.0.0.3
```
___

### Configuración de diccionario de contraseñas no permitidas

Utilizando el usuario `admin`.

La siguiente configuración debe realizarse en el equipo Bastion ingresando por medio de
```
ssh-copy-id admin@[ip-pública-bastion]
```
Y en los equipos de web server y base de datos con

Servidor web
```
ssh -J [ip-pública-bastion] 10.0.0.2
```

Servidor base de datos
```
ssh -J [ip-pública-bastion] 10.0.0.3
```

Ejecutar el siguiente comando para instalar el módulo `libpam-cracklib`.
```
sudo apt-get update
sudo apt-get install libpam-cracklib
```

Debemos crear el documento que contendrá el listado de contraseña.

```
sudo nano commonpasswords.txt
```
Agregamos al archivo
```
root
Qwerty
Qwertyuiop
Abc123
654321
123321
Password
P@ssw0rd
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Verificamos que el archivo fue creado
```
cat commonpasswords.txt
```
Agregamos el archivo al diccionario de palabras
```
sudo create-cracklib-dict commonpasswords.txt
```
Podemos verificar su funcionamiento ejecutando
```
echo "Qwertyuiop" | cracklib-check
```
___

### Configuración de acceso a servidores por medio de grupos

Los usuarios del grupo webmasters y administrators son los únicos con acceso al servidor web. Utilizando el usuario `admin`.

Entrar al servidor de web.
```
ssh -J [ip-pública-bastion] 10.0.0.2
```
Entrar al archivo de configuración `/etc/ssh/sshd_config`
```
sudo nano /etc/ssh/sshd_config
```
Al final del archivo agregar
```
AllowGroups     webmasters administrators
DenyGroups      databaseadmins
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Reiniciamos el servicio de ssh
```
sudo systemctl restart sshd
```

Los usuarios del grupo databaseadmins y administrators son los únicos con acceso al servidor de base de datos. Utilizando el usuario `admin`.

Entrar al servidor de base de datos.
```
ssh -J [ip-pública-bastion] 10.0.0.3
```
Entrar al archivo de configuración `/etc/ssh/sshd_config`
```
sudo nano /etc/ssh/sshd_config
```
Al final del archivo agregar
```
AllowGroups     databaseadmins administrators
DenyGroups      webmasters
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Reiniciamos el servicio de ssh
```
sudo systemctl restart sshd
```

Entrar al equipo Bastion.
```
ssh admin@[IP-PUBLICA-BASTION]
```
Los usuarios del grupo administrators son los únicos con acceso a Bastion. Utilizando el usuario `admin`.
Entrar al archivo de configuración `/etc/ssh/sshd_config`
```
sudo nano /etc/ssh/sshd_config
```
Al final del archivo agregar
```
AllowGroups     administrators
DenyGroups      databaseadmins webmasters
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Reiniciamos el servicio de ssh
```
sudo systemctl restart sshd
```
___

### Configuración de ejecución de servicios sin contraseña - `systemctl`

Las acciones que se pueden ejecutar sobre un servicio con `systemctl`
```
sudo systemctl enable {service-name}
sudo systemctl start {service-name}
sudo systemctl status {service-name}
sudo systemctl stop {service-name}
```

A continuación configurar los permisos sobre el servicio Apache para el grupo `webmasters` y `administrators`
Entrar a editar el archivo `/etc/sudoers`.
```
sudo nano /etc/sudoers
```
Navegar hasta encontrar el comentario `#Allow members of group sudo to execute any command`

Crear una variable para almacenar las acciones que podrán ejecutarse sobre el servicio Apache.
```
Cmnd_Alias APACHE_SERVICE = /etc/systemctl start {apache-service?},/etc/systemctl restart {apache-service?},/etc/systemctl stop {apache-service?},/etc/systemctl status {apache-service?}
```
En la siguiente línea, agregar el grupo de usuarios que podrá ejecutar las acciones configuradas.
```
%webmasters     ALL=(ALL) NOPASSWD:APACHE_SERVICE
#administrators ALL=(ALL) NOPASSWD:APACHE_SERVICE
```

A continuación configurar los permisos sobre el servicio MySQL para el grupo `databaseadmins` y `administrators`
Entrar a editar el archivo `/etc/sudoers`.
```
sudo nano /etc/sudoers
```
Navegar hasta encontrar el comentario `#Allow members of group sudo to execute any command`

Crear una variable para almacenar las acciones que podrán ejecutarse sobre el servicio Apache.
```
Cmnd_Alias MYSQL_SERVICE = /etc/systemctl start {mysql-service?},/etc/systemctl restart {mysql-service?},/etc/systemctl stop {mysql-service?},/etc/systemctl status {mysql-service?}
```
En la siguiente línea, agregar el grupo de usuarios que podrá ejecutar las acciones configuradas.
```
%databaseadmins ALL=(ALL) NOPASSWD:MYSQL_SERVICE
#administrators ALL=(ALL) NOPASSWD:MYSQL_SERVICE
```
Guardar cambios con Ctrl+O y salir con Ctrl+X

Al estar logueado con un usuario del respectivo grupo y ejecutar la acción al servicio, este no pedirá contraseña.

Por ejemplo para reiniciar el servicio de apache con un usuario del grupo webmasters.
```
sudo systemctl restart {apache-service?}
```
___
### Configuración de Firewall

El servicio `ufw` ya se encuentra instalado por defecto en un Ubuntu Server en estado inactivo.

Se aplicarán las reglas para bloquear todas las solicitudes entrantes y permitir las salientes y activaremos el servicio. Esta configuración debe realizarse en el equipo Bastion, servidor Web y Base de Datos.
```
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw enable
```

Entramos al equipo Bastion y realizaremos la configuración para que pueda ser accedido únicamente por SSH utilizando el usuario `admin`.
```
admin@[ip-pública-bastion]
```
Permitimos conexión por SSH en el puerto 22
```
sudo ufw allow 22
```

Salimos y entramos al servidor web.
```
ssh -J [ip-pública-bastion] 10.0.0.2
```
Permitimos conexión al servidor por SSH únicamente al equipo Bastion.
```
sudo ufw allow from 10.0.0.1 to any port 22
```

Salimos y entramos al servidor de base de datos.
```
ssh -J [ip-pública-bastion] 10.0.0.3
```
Permitimos conexión al servidor por SSH únicamente al equipo Bastion.
```
sudo ufw allow from 10.0.0.1 to any port 22
```

___
## **Personalización** 

___
## **Inventario de Equipos**

___
## **Inventario de Credenciales Iniciales**

Usuario administrador de cada equipo

Cliente Externo
```
usuario: admin
contraseña: PsiOS2023
```
Bastion
```
usuario: admin
contraseña: PsiOS2023bastion
```
Web
```
usuario: admin
contraseña: PsiOS2023web
```
Base de Datos
```
usuario: admin
contraseña: PsiOS2023db
```

Usuarios y grupos

Grupo administrators 
```
usuario: adm01
contraseña: psi-adm-01

usuario: adm02
contraseña: psi-adm-02
```

Grupo webmasters 
```
usuario: web01
contraseña: psi-web-01

usuario: web02
contraseña: psi-web-02
```

Grupo databaseadmins
```
usuario: dba01
contraseña: psi-dba-01

usuario: dba02
contraseña: psi-dba-02
```

___
## **Pruebas Docuentadas**

___
## **Referencias**

* **Creación de grupos y usuarios**: https://ubuntu.com/server/docs/security-users
* **Generación y autenticación SSH llave pública y privada**: https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-22-04
* **Instalación módulo libpam-cracklib**: https://howtoinstall.co/en/libpam-cracklib
* **Configuración de acceso a equipos por grupos y usuarios**: https://ostechnix.com/allow-deny-ssh-access-particular-user-group-linux/
* **Configuración de ejecución con systemctl sin contraseña**: https://serverfault.com/questions/1057463/grant-a-user-sudo-powers-to-start-stop-etc-a-systemd-service-w-o-sudo-password
* **Configuración de Firewall**: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-22-04
* **Configuración de Firewall desde un host específico**: https://ubuntu.com/server/docs/security-firewall
___
## **Anexos**

