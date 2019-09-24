FROM maven:3.6-jdk-8

WORKDIR /app
RUN mkdir -p /app/kafka-connect-couchbase
COPY . /app/kafka-connect-couchbase/

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]