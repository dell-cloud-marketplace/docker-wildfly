#!/bin/sh

# Change ownership and permissions of the deployment directory
DEPLOYMENT_DIR="/opt/jboss/wildfly/standalone/deployments"
chown -R jboss:jboss $DEPLOYMENT_DIR 
chmod -R 755 $DEPLOYMENT_DIR

# Generate a random password
ADMIN_PASSWORD=`pwgen -c -n -1 12`

echo "========================================================================="
echo "You can now connect to this instance using:"
echo
echo "    user name: admin"
echo "    password : $ADMIN_PASSWORD"
echo

# Add an admin user.
su jboss -c "/opt/jboss/wildfly/bin/add-user.sh admin $ADMIN_PASSWORD --silent"
#/opt/jboss/wildfly/bin/add-user.sh admin $ADMIN_PASSWORD --silent

# This will boot WildFly in the standalone mode and bind to all interface
su jboss -c "/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0"
#/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0
