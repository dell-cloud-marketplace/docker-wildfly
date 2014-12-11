#!/bin/sh

CONFIG_DIR="/opt/jboss/wildfly/standalone/configuration"
STANDALONE_XML="$CONFIG_DIR/standalone.xml"

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

# Generate Self-Signed certificate for web-based applications
UNDERTOW_SSL_CERT_PWD=`pwgen -c -n -1 12`
keytool -genkey -noprompt \
-alias web_ssl \
-dname "CN=www.dell.com, OU=MarketPlace, O=Dell, C=US" \
-keyalg RSA \
-storepass $UNDERTOW_SSL_CERT_PWD \
-keypass $UNDERTOW_SSL_CERT_PWD \
-validity 360 \
-keysize 2048 \
-keystore $CONFIG_DIR/web.keystore

# Generate Self-Signed certificate for management console
CONSOLE_SSL_CERT_PWD=`pwgen -c -n -1 12`
keytool -genkey -noprompt \
-alias console_ssl \
-dname "CN=www.dell.com, OU=MarketPlace, O=Dell, C=US" \
-keyalg RSA \
-storepass $CONSOLE_SSL_CERT_PWD \
-keypass $CONSOLE_SSL_CERT_PWD \
-validity 360 \
-keysize 2048 \
-keystore $CONFIG_DIR/console.keystore

# Inject keystores passwords in standalone.xml
sed -i 's/$CONSOLE_SSL_CERT_PWD/'$CONSOLE_SSL_CERT_PWD'/g' $STANDALONE_XML
sed -i 's/$UNDERTOW_SSL_CERT_PWD/'$UNDERTOW_SSL_CERT_PWD'/g' $STANDALONE_XML

# This will boot WildFly in the standalone mode and bind to all interface
su jboss -c "/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -bmanagement 0.0.0.0"
