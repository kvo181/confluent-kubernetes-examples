FROM confluentinc/cp-kafka-connect:latest
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jms:latest \
   && confluent-hub install --no-prompt confluentinc/kafka-connect-jms-sink:latest \
   && confluent-hub install --no-prompt jcustenborder/kafka-connect-json-schema:latest
# client libraries for the source connector
COPY ./libs/aqapi-19.3.0.0.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms/lib/aqapi-19.3.0.0.jar
COPY ./libs/ojdbc8-12.2.0.1.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms/lib/ojdbc8-12.2.0.1.jar
COPY ./libs/jta-1.1.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms/lib/jta-1.1.jar
# client libraries for the sink connector
COPY ./libs/aqapi-19.3.0.0.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms-sink/lib/aqapi-19.3.0.0.jar
COPY ./libs/ojdbc8-12.2.0.1.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms-sink/lib/ojdbc8-12.2.0.1.jar
COPY ./libs/jta-1.1.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms-sink/lib/jta-1.1.jar
# Kafka connect SMT to expand JSON string
# COPY ./libs/kafka-connect-smt-expandjsonsmt-0.0.7-assemble-all.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms/lib/kafka-connect-smt-expandjsonsmt-0.0.7-assemble-all.jar
# COPY ./libs/kafka-connect-smt-expandjsonsmt-0.0.7-assemble-all.jar /usr/share/confluent-hub-components/confluentinc-kafka-connect-jms-sink/lib/kafka-connect-smt-expandjsonsmt-0.0.7-assemble-all.jar
# Application Insights
COPY ./libs/applicationinsights-agent-3.1.1.jar /usr/share/applicationinsights/lib/applicationinsights-agent-3.1.1.jar
COPY ./configs/applicationinsights.json /usr/share/applicationinsights/lib/applicationinsights.json
