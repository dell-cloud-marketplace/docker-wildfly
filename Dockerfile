# Use latest jboss/base-jdk:7 image as the base
FROM jboss/base-jdk:7

MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>
 
# The base image specifies user "jboss". We need to switch temporarily.
USER root
RUN yum -y install pwgen
USER jboss

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 8.1.0.Final

# Add the WildFly distribution to /opt, and make wildfly the owner of the
# extracted tar content.
RUN cd $HOME && curl http://download.jboss.org/wildfly/$WILDFLY_VERSION/\
wildfly-$WILDFLY_VERSION.tar.gz | tar zx && \
mv $HOME/wildfly-$WILDFLY_VERSION $HOME/wildfly

# Set the JBOSS_HOME env variable
ENV JBOSS_HOME /opt/jboss/wildfly

# Expose the ports we're interested in
EXPOSE 8080 9990

# Add our custom script.
ADD run.sh /run.sh

# Make it the default command to run on boot
CMD ["/run.sh"]

