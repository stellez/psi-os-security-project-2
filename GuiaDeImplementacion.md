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

### Instalación de SSH
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

### Deshabilitar autenticación por contraseña

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

### Autenticación con SSH llave pública y privada
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

### Configuración de diccionario de contraseñas no permitidas





___
## **Personalización** 

___
## **Inventario de Equipos**

___
## **Inventario de Credenciales Iniciales**

___
## **Pruebas Docuentadas**

___
## **Referencias**

* **Creación de grupos y usuarios**: https://ubuntu.com/server/docs/security-users
___
## **Anexos**

