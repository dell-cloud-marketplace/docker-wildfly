# Use latest jboss/base-jdk:7 image as the base
FROM jboss/base-jdk:7
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>
 
# The base image specifies user "jboss". We need to switch temporarily.
USER root
RUN yum -y install pwgen \
    && usermod -s /bin/bash jboss
USER jboss

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.2.0.Final

# Add the WildFly distribution to /opt, and make wildfly the owner of the
# extracted tar content.
RUN cd $HOME && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/\
wildfly-$WILDFLY_VERSION.tar.gz | tar zx && \
mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

# Add standalone.xml to enable SSL for console management and web applications
ADD standalone.xml /opt/jboss/wildfly/standalone/configuration/standalone.xml
RUN mkdir -p /tmp/wildfly/ && \
    cp -r /opt/jboss/wildfly/standalone /tmp/wildfly/

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Add our custom script.
ADD run.sh /run.sh

# Expose Wildfly standalone directory
VOLUME ["/opt/jboss/wildfly/standalone"]

# Expose Wildfly ports (web applications on HTTP/HTTPS and management console on HTTPS)
EXPOSE 8080 8443 9993

# Make it the default command to run on boot
USER root
CMD ["/run.sh"]
