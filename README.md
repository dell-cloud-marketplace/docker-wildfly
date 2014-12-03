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

### 1. Start the Container

A. Basic Usage

Start the container with:

- A named container (**wildfly**).
- Ports 8080 AND 9990 exposed.

Do

```no-highlight
sudo docker run -d  -p 8080:8080 -p 9990:9990 --name wildfly dell/wildfly
```

## Test your deployment

View the WildFly site

```no-highlight
 at: http://localhost:8080/
```
Or test the response via CLI:

```no-highlight
curl http://localhost:8080/
```

## Administration

An admin user will be created with a random password. To get the password, check the container logs 

    sudo docker logs wildfly

You will see some output like the following:

    =========================================================================
    You can now connect to this instance using:

       user name: admin
       password : eiR6Raetohqu

    =========================================================================

In this case, **eiR6Raetohqu** is the password allocated to the admin user.

Access the Admin interface on port 9990 and use the credentials found in the logs.
```no-highlight
 at: http://localhost:9990/
```

The server is run as the `jboss` user which has the uid/gid set to `1000`.

WildFly is installed in the `/opt/jboss/wildfly` directory.


## Application deployment

With the WildFly server you can [deploy your application in multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. You can use CLI
2. You can use the web console
3. You can use the management API directly
4. You can use the deployment scanner

for example, using the admin credentials from the logs, you can access web deployment console

```no-highlight
 at: http://localhost:9990/console/App.html#deployments
```

### Image Details

Based on  [jboss/base](https://github.com/JBoss-Dockerfiles/wildfly)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/wildfly](https://registry.hub.docker.com/u/dell/wildfly)
