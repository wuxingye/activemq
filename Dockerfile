FROM java:8-jre
MAINTAINER wuxingye (23226334@qq.com)

# Application settings
ENV ACTIVEMQ_VERSION 5.15.3
ENV ACTIVEMQ apache-activemq-${ACTIVEMQ_VERSION}
ENV ACTIVEMQ_HOME /opt/activemq

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
    chown -h activemq:activemq ${ACTIVEMQ_HOME}

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

CMD ["/bin/sh", "-c", "bin/activemq console"]