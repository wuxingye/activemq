#!/bin/bash
docker run -e ACTIVEMQ_RMI_SERVER_HOSTNAME='localhost' --name activemq -p 61616:61616 -p 8161:8161 -p 1099:1099 -d wuxingye/activemq