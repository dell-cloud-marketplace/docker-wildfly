#docker-wildfly

This image installs [Wildfly](http://wildfly.org/) an application server authored by JBoss.
This image extends the [`jboss/base-jdk:7`](https://github.com/JBoss-Dockerfiles/base-jdk/tree/jdk7) image which adds the OpenJDK distribution on top of the [`jboss/base`](https://github.com/JBoss-Dockerfiles/base) image. Please refer to the README.md for selected images for more info.

## Components
The stack comprises the following components:

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Wildfly    | 8.1                     | Application Server
JDK        | 7                       | Java


## Usage

### Start the Container

To start the container with:

- A named container ("wildfly").
- Host port 8080 mapped to container port 8080 (WildFly Landing Page)
- Host port 9990 mapped to container port 9990 (WildFly Administration Page)

Do:

```no-highlight
sudo docker run -d  -p 8080:8080 -p 9990:9990 --name wildfly dell/wildfly
```

To access the WildFly landing page do:

```no-highlight
 http://localhost:8080/
```
Or test the response via the commandline:

```no-highlight
curl http://localhost:8080/
```
### Advanced Example

To start the container with:

- A named container ("wildfly").
- A data volume (which will survive a restart or recreation of the container) for deploying applications using the WildFly Deployment Scanner
- Host port 8080 mapped to container port 8080 (WildFly Landing Page)
- Host port 9990 mapped to container port 9990 (WildFly Administration Page)
- A specific password for WildFly user **admin**.  A preset password can be defined instead of a randomly generated one, this is done by setting the environment variable `ADMIN_PASS` to your specific password when running the container.

Do:

```no-highlight
sudo docker run -d \
-p 8080:8080 \
-p 9990:9990 \
-v /app:/opt/jboss/wildfly/standalone/deployments/ \
-e ADMIN_PASS="mypass"  \
--name wildfly dell/wildfly
```

Test the deployment scanner by copying a web application *war* file into the **/app** directory on the host that has been mounted to the wildfly deployment scanner directory:

```no-highlight
sudo wget https://github.com/davtrott/HelloWorldJsp/raw/master/helloWorld/helloworld.war \
-P /app
```

View the deployed application at:  

```no-highlight
http://localhost:8080/helloworld/
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

Access the Admin interface on port 9990 and use the credentials found in the logs.

```no-highlight
at: http://localhost:9990/
```

## Application deployment

With the WildFly server you can [deploy your application in multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. You can use CLI
2. You can use the web console
3. You can use the management API directly
4. You can use the deployment scanner

For example, using the admin credentials from the logs, you can access web deployment console

```no-highlight
 at: http://localhost:9990/console/App.html#deployments
```

### Image Details

Based on  [jboss/base](https://github.com/JBoss-Dockerfiles/wildfly)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/wildfly](https://registry.hub.docker.com/u/dell/wildfly)
