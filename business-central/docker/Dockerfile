####### BASE ############
FROM jboss/business-central-workbench:7.59.0.Final

####### CONFIGURATION ############
ADD config-server.cli $JBOSS_HOME/bin/
RUN $JBOSS_HOME/bin/jboss-cli.sh --file=config-server.cli
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/*

ADD start_business-central-wb.sh $JBOSS_HOME/bin/start_business-central-wb.sh
ADD application-users.properties $JBOSS_HOME/standalone/configuration/application-users.properties
ADD application-roles.properties $JBOSS_HOME/standalone/configuration/application-roles.properties

####### Create Directory to be mapped to EFS ############
USER root
RUN mkdir -p /data/niogit
RUN chown -R jboss:jboss /data/niogit

RUN chown jboss:jboss $JBOSS_HOME/bin/start_business-central-wb.sh
RUN chown jboss:jboss $JBOSS_HOME/standalone/deployments/*
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/*
RUN chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-users.properties && \
 chown jboss:jboss $JBOSS_HOME/standalone/configuration/application-roles.properties

####### CUSTOM JBOSS USER ############
# Switchback to jboss user
USER root

####### RUNNING JBPM-WB ############
WORKDIR $JBOSS_HOME/bin/
CMD ["./start_business-central-wb.sh"]