FROM java:8-jre
MAINTAINER wuxingye (23226334@qq.com)

# Application settings
ENV ACTIVEMQ_VERSION 5.15.3
ENV ACTIVEMQ apache-activemq-${ACTIVEMQ_VERSION}
ENV ACTIVEMQ_HOME /opt/activemq
ENV ACTIVEMQ_RMI_SERVER_HOSTNAME localhost

ENV BROKER_USERNAME admin
ENV BROKER_PASSWORD admin
ENV ADMIN_USERNAME admin
ENV ADMIN_PASSWORD admin

ENV BROKER_NAME default

# Install ActiveMQ software
ADD ${ACTIVEMQ}-bin.tar.gz /opt/

RUN ln -s /opt/${ACTIVEMQ} ${ACTIVEMQ_HOME} && \
    useradd -r -M -d ${ACTIVEMQ_HOME} activemq && \
    chown -R activemq:activemq /opt/${ACTIVEMQ} && \
    chown -h activemq:activemq ${ACTIVEMQ_HOME} && \
    chmod 600 ${ACTIVEMQ_HOME}/conf/jmx.access && \
    chmod 600 ${ACTIVEMQ_HOME}/conf/jmx.password

RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Djava.rmi.server.hostname=${ACTIVEMQ_RMI_SERVER_HOSTNAME} "' >> ${ACTIVEMQ_HOME}/bin/env
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.port=1099 "' >> ${ACTIVEMQ_HOME}/bin/env
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.rmi.port=1099 "' >> ${ACTIVEMQ_HOME}/bin/env
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.ssl=false "' >> ${ACTIVEMQ_HOME}/bin/env
# RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.authenticate=false "' >> ${ACTIVEMQ_HOME}/bin/env
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.access.file=$ACTIVEMQ_BASE/conf/jmx.access "' >> ${ACTIVEMQ_HOME}/bin/env
RUN echo '\nACTIVEMQ_OPTS="$ACTIVEMQ_OPTS -Dcom.sun.management.jmxremote.password.file=$ACTIVEMQ_BASE/conf/jmx.password  "' >> ${ACTIVEMQ_HOME}/bin/env

ADD mysql-connector-java-5.1.46.jar ${ACTIVEMQ_HOME}/lib/optional/
ADD activemq.xml ${ACTIVEMQ_HOME}/conf/activemq.xml

USER activemq

WORKDIR ${ACTIVEMQ_HOME}

# Expose all port
# UI
EXPOSE 8161
# TCP
EXPOSE 61616
# AMQP
EXPOSE 5672
# STOMP
EXPOSE 61613
# MQTT
EXPOSE 1883
# WS
EXPOSE 61614
# JMX
EXPOSE 1099

CMD ["/bin/sh", "-c", "bin/activemq console"]