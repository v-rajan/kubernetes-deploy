#!/usr/bin/env bash

# Start clustered Wildfly with the given arguments.
echo "Running clustered business-central workbench on JBoss Wildfly..."
exec ./standalone.sh -c standalone-full-ha.xml  -Dorg.uberfire.nio.git.dir=/data/niogit -Dappformer-jms-connection-mode=REMOTE  -Dappformer-jms-url="tcp://${AMQ_HOST}:61616?ha=true&retryInterval=1000&retryIntervalMultiplier=1.0&reconnectAttempts=-1" -Dappformer-jms-username=${AMQ_USER} -Dappformer-jms-password=${AMQ_PASSWORD} -b=0.0.0.0 -bmanagement=0.0.0.0
exit $?