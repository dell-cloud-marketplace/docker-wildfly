#docker-wildfly

This image installs [Wildfly](http://wildfly.org/), an application server authored by JBoss. The image extends [`jboss/base-jdk:7`](https://github.com/JBoss-Dockerfiles/base-jdk/tree/jdk7), which adds the OpenJDK distribution on top of [`jboss/base`](https://github.com/JBoss-Dockerfiles/base). Please refer to the README.md for selected images for more information.

## Components
The software stack comprises the following components:

Name       | Version    | Description
-----------|------------|--------------
Wildfly    | 8.2        | Application Server
OpenJDK    | 7          | An open source implementation of the Java Platform

## Usage

### Start the Container
If you wish to create data volumes, which will survive a restart or recreation of the container, please follow the instructions in [Advanced Usage](#advanced-usage).

#### Basic Usage
Start your container with:

- A named container (**wildfly**).
- Ports 8080, 8443 and 9993 exposed (respectively the Wildfly HTTP, HTTPS and HTTPS Administration console ports)

As follows:

```no-highlight
sudo docker run -d  -p 8080:8080 -p 8443:8443 -p 9993:9993 --name wildfly dell/wildfly
```

<a name="advanced-usage"></a>
#### Advanced Usage
Start your container with:

- A named container (**wildfly**).
- Ports 8080, 8443 and 9993 exposed (respectively the Wildfly HTTP, HTTPS and HTTPS Administration console ports)
- 3 data volumes (which will survive a restart or recreation of the container):
    - The *Deployment* volume, for deploying applications using the WildFly Deployment Scanner, is available in **/wildfly/deployments** on the host.
    - The *Logs* volume, for viewing the Wildfly application logs, is available in **/wildfly/log** on the host.
    - The *Configuration* volume, for supplying Wildfly configuration files, is available in **/wildfly/configuration** on the host.
- A specific password for WildFly user **admin**.

As follows:

```no-highlight
sudo docker run -d \
    -p 8080:8080 \
    -p 8443:8443 \
    -p 9993:9993 \
    -v /wildfly/configuration:/opt/jboss/wildfly/standalone/configuration \
    -v /wildfly/log:/opt/jboss/wildfly/standalone/log \
    -v /wildfly/deployments:/opt/jboss/wildfly/standalone/deployments \
    -e ADMIN_PASS="mypass" \
    --name wildfly dell/wildfly
```

### Check the Container Logs
If you did not specify a password when creating the container, check the logs for the administrator credentials:

```no-highlight
sudo docker logs wildfly
```

You will see some output like the following:

```no-highlight
Modifying 'admin' user with a preset password in WildFly
=========================================================================
You can now access the admin interface using:

    user name: admin
    password : PheiBe3Eidoh

=========================================================================
```
Please make a secure note of this password (in this case, **PheiBe3Eidoh**).

### Test Your Deployment
To access the server, do:
```no-highlight
http://localhost:8080
```

Or use cURL:
```no-highlight
curl http://localhost:8080
```

The container supports SSL, via a self-signed certificate. **We strongly recommend that you connect via HTTPS**, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

```no-highlight
https://localhost:8443
```

You may also access the administrator console on port 9993:

```no-highlight
https://localhost:9993
```

Login as user **admin**, and the password you specified or read from the logs.

## Application Deployment
You may deploy a Wildfly application in [multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. Via the CLI
2. Via the administrator web console (https://localost:9993/App.html#deployments)
3. Via the management API
4. Via the deployment scanner

For example, if you created the container with volume support, copy a *WAR* file into the **/wildfly/deployment** directory (which is monitored by the deployment scanner):

```no-highlight
sudo wget \
https://github.com/dell-cloud-marketplace/docker-wildfly/blob/master/helloworld.war \
-P /wildfly/deployments/
```

View the deployed application at:

```no-highlight
https://localhost:8443/helloworld/
```

### Image Details

Inspired by [jboss/wildfly](https://github.com/JBoss-Dockerfiles/wildfly)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/wildfly](https://registry.hub.docker.com/u/dell/wildfly)
