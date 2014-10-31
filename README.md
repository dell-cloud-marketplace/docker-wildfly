#docker-wildfly

This image installs [Wildfly](http://wildfly.org/) an application server authored by JBoss.
This image extends the [`jboss/base-jdk:7`](https://github.com/JBoss-Dockerfiles/base-jdk/tree/jdk7) image which adds the OpenJDK distribution on top of the [`jboss/base`](https://github.com/JBoss-Dockerfiles/base) image. Please refer to the README.md for selected images for more info.

## Components
The stack comprises the following components:

Name       | Version                 | Description
-----------|-------------------------|------------------------------
Wildfly    | 8.1 see [jboss/base](https://registry.hub.docker.com/u/jboss/base/)  | Application Server
JDK        | 7 see [jboss/base-jdk:7](https://registry.hub.docker.com/u/jboss/base-jdk/) | Java


## Usage

### Start the Container
Start the container, as follows:

    sudo docker run -d  -p 8080:8080 -p 9990:9990 --name wildfly dell/wildfly


Next, check the container logs, in order to get the password:

    sudo docker logs wildfly

You will see some output like the following:

    =========================================================================
    You can now connect to this instance using:

       user name: admin
       password : eiR6Raetohqu

    =========================================================================


## Test your deployment

Access the Admin interface on port 9990 and use the credentials found in the logs.

The server is run as the `jboss` user which has the uid/gid set to `1000`.

WildFly is installed in the `/opt/jboss/wildfly` directory.

## Advanced configuration

To boot in standalone mode

    sudo docker run -it dell/wildfly

To boot in domain mode

    sudo docker run -it dell/wildfly /opt/jboss/wildfly/bin/domain.sh \
    -b 0.0.0.0 -bmanagement 0.0.0.0

## Application deployment

With the WildFly server you can [deploy your application in multiple ways](https://docs.jboss.org/author/display/WFLY8/Application+deployment):

1. You can use CLI
2. You can use the web console
3. You can use the management API directly
4. You can use the deployment scanner

The most popular way of deploying an application is using the deployment scanner. In WildFly this method is enabled by default and the only thing you need to do is to place your application inside of the `deployments/` directory. It can be `/opt/jboss/wildfly/standalone/deployments/` or `/opt/jboss/wildfly/domain/deployments/` depending on [which mode](https://docs.jboss.org/author/display/WFLY8/Operating+modes) you choose (standalone is default in the `dell/wildfly` image -- see above).

The simplest and cleanest way to deploy an application to WildFly running in a container started from the `dell/wildfly` image is to use the deployment scanner method mentioned above.

To do this you just need to extend the `dell/wildfly` image by creating a new one. Place your application inside the `deployments/` directory with the `ADD` command (but make sure to include the trailing slash on the deployment folder path, [more info](https://docs.docker.com/reference/builder/#add)). You can also do the changes to the configuration (if any) as additional steps (`RUN` command).  

[A simple example](https://github.com/goldmann/wildfly-docker-deployment-example) was prepared to show how to do it, but the steps are following:

1. Create `Dockerfile` with following content:

        FROM dell/wildfly
        ADD your-awesome-app.war /opt/jboss/wildfly/standalone/deployments/
2. Place your `your-awesome-app.war` file in the same directory as your `Dockerfile`.
3. Run the build with `sudo docker build --tag=wildfly-app .`
4. Run the container with `sudo docker run -it wildfly-app`. Application will be deployed on the container boot.

This way of deployment is great because of a few things:

1. It utilizes Docker as the build tool providing stable builds
2. Rebuilding image this way is very fast (once again: Docker)
3. You only need to do changes to the base WildFly image that are required to run your application

## Logging

Logging can be done in many ways. [This blog post](https://goldmann.pl/blog/2014/07/18/logging-with-the-wildfly-docker-image/) describes a lot of them.

## Customizing configuration

Sometimes you need to customize the application server configuration. There are many ways to do it and [this blog post](https://goldmann.pl/blog/2014/07/23/customizing-the-configuration-of-the-wildfly-docker-image/) tries to summarize it.

## Extending the image

To be able to create a management user to access the administration console create a Dockerfile with the following content

    FROM dell/wildfly
    RUN /opt/jboss/wildfly/bin/add-user.sh admin Admin#70365 --silent

Then you can build the image:

    sudo docker build --tag=dell/wildfly-admin .

Run it:

    sudo docker run -it -p 9990:9990 dell/wildfly-admin

The administration console should be available at http://localhost:9990.

## Building on your own

You don't need to do this on your own, because we prepared a trusted build for this repository, but if you really want:

    sudo docker build --rm=true --tag=dell/wildfly .

### Image Details

Based on  [jboss/base](https://github.com/JBoss-Dockerfiles/wildfly)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/wildfly](https://registry.hub.docker.com/u/dell/wildfly)
