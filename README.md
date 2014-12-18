#docker-wildfly

This image installs [Wildfly](http://wildfly.org/) an application server authored by JBoss.
This image extends the [`jboss/base-jdk:7`](https://github.com/JBoss-Dockerfiles/base-jdk/tree/jdk7) image which adds the OpenJDK distribution on top of the [`jboss/base`](https://github.com/JBoss-Dockerfiles/base) image. Please refer to the README.md for selected images for more information.

## Components
The stack comprises the following components:

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Wildfly    | 8.1                     | Application Server
JDK        | 7                       | Java9


## Usage

### Start the Container

To start the container with:

- A named container (**wildfly**).
- Ports 8080, 8443 and 9993 exposed (respectively Wildfly HTTP, HTTPS and HTTPS Administration console ports)

Do:

```no-highlight
sudo docker run -d  -p 8080:8080 -p 8443:8443 -p 9993:9993 --name wildfly dell/wildfly
```

To access the WildFly landing page do:

```no-highlight
 http://localhost:8080/
```

Or:
```no-highlight
https://localhost:8443
```

**We strongly recommend that you connect via HTTPS**, for this step, and all subsequent administrative tasks, if the container is running outside your local machine (e.g. in the Cloud). Your browser will warn you that the certificate is not trusted. If you are unclear about how to proceed, please consult your browser's documentation on how to accept the certificate.

Or test the response via the command-line:

```no-highlight
curl http://localhost:8080/
```
### Advanced Example

To start the container with:

- A named container (**wildfly**).
- Ports 8080, 8443 and 9993 exposed (respectively Wildfly HTTP, HTTPS and HTTPS Administration console ports)
- Data volumes (which will survive a restart or recreation of the container):
  * The *Deployment* volume for deploying applications using the WildFly Deployment Scanner is available in **/wildfly/deployments** on the host.
  * The *Logs* volume for viewing the Wildfly application logs is available in **/wildfly/log** on the host.
  * The *Configuration* volume for supplying Wildfly configuration files is available in **/wildfly/configuration** on the host.
- A specific password for WildFly user **admin**.  A preset password can be defined instead of a randomly generated one, this is done by setting the environment variable `ADMIN_PASS` to your specific password when running the container.

Do:

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

Test the deployment scanner by copying a web application *war* file into the **/wildfly/deployment** directory on the host that has been mounted to the wildfly deployment scanner directory:

```no-highlight
sudo wget https://github.com/davtrott/HelloWorldJsp/raw/master/helloWorld/helloworld.war \
-P /wildfly/deployments/
```

View the deployed application at:  

```no-highlight
https://localhost:8443/helloworld/
```

Or test the response via the command-line:

```no-highlight
curl -k https://localhost:8443/helloworld/
```

## Application deployment

With the WildFly server you can [deploy your application in multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. You can use CLI
2. You can use the web console
3. You can use the management API directly
4. You can use the deployment scanner

For example, using the admin credentials from the logs, you can access the web deployment console on port *9993*:

```no-highlight
 at: https://localhost:9993/console/App.html#deployments
```
## Administration

Check the container logs for the administrator credentials:

```no-highlight
sudo docker logs wildfly
```

You will see some output like the following:

```no-highlight
Modifying 'admin' user with a preset password in WildFly
=========================================================================
You can now access the admin interface using:

    user name: admin
    password : mypass

=========================================================================
```

In this case, **mypass** is the password that has been specified for the admin user.

Access the Administration interface on port *9993* and use the credentials found in the logs.

```no-highlight
at: https://localhost:9993/
```

### Image Details

Inspired by [jboss/wildfly](https://github.com/JBoss-Dockerfiles/wildfly)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/wildfly](https://registry.hub.docker.com/u/dell/wildfly)
