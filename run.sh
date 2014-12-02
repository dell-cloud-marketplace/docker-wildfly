#!/bin/sh

# Change ownership and permissions of the deployment directory
DEPLOYMENT_SCANNER_PATH="/opt/jboss/wildfly/standalone/deployments"
chown -R jboss:jboss $DEPLOYMENT_SCANNER_PATH 
chmod -R 755 $DEPLOYMENT_SCANNER_PATH

# Generate a random password
PASS=${ADMIN_PASS:-$(pwgen -c -n -1 12)}
_word=$( [ ${ADMIN_PASS} ] && echo "preset" || echo "random" )
echo "=> Modifying 'admin' user with a ${_word} password in WildFly"

# Add an admin user.
su jboss -c "/opt/jboss/wildfly/bin/add-user.sh admin $PASS --silent"

echo "========================================================================="
echo "You can now access the admin interface using:"
echo
echo "    user name: admin"
echo "    password : $PASS"
echo

# This will boot WildFly in the standalone mode and bind to all interface
su jboss -c "/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0"
