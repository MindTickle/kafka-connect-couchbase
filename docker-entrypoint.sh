#!/bin/bash

set -ex

env
connect_standalone_config="/app/kafka-connect-couchbase/config/connect-standalone.properties"
couchbase_sink_config="/app/kafka-connect-couchbase/config/quickstart-couchbase-sink.properties"

TICKLEDB_AUDIT_KAFKA_BOOTSTRAP_SERVER="10.0.4.125:9092"
TICKLEDB_AUDIT_CB_CLUSTER_IP="10.0.3.215"
TICKLEDB_AUDIT_CB_CLUSTER_BUCKET="tickledb-audit-logs"
TICKLEDB_AUDIT_CB_CLUSTER_USERNAME="couchbase"
TICKLEDB_AUDIT_CB_CLUSTER_PASSWORD="couchbase"
TICKLEDB_AUDIT_SOURCE_KAFKA_TOPIC="collection-id-add-test"

sed -i -e "s#_replace_bootstrap_server#${TICKLEDB_AUDIT_KAFKA_BOOTSTRAP_SERVER}#" $connect_standalone_config
sed -i -e "s#_replace_cluster_ip#${TICKLEDB_AUDIT_CB_CLUSTER_IP}#" $couchbase_sink_config
sed -i -e "s#_replace_cluster_bucket#${TICKLEDB_AUDIT_CB_CLUSTER_BUCKET}#" $couchbase_sink_config
sed -i -e "s#_replace_cluster_username#${TICKLEDB_AUDIT_CB_CLUSTER_USERNAME}#" $couchbase_sink_config
sed -i -e "s#_replace_cluster_password#${TICKLEDB_AUDIT_CB_CLUSTER_PASSWORD}#" $couchbase_sink_config
sed -i -e "s#_replace_kafka_topic#${TICKLEDB_AUDIT_SOURCE_KAFKA_TOPIC}#" $couchbase_sink_config

wget http://apachemirror.wuchna.com/kafka/2.2.0/kafka_2.12-2.2.0.tgz
tar -xzf kafka_2.12-2.2.0.tgz
export KAFKA_HOME=/app/kafka_2.12-2.2.0
export KAFKA_CONNECT_COUCHBASE_HOME=/app/kafka-connect-couchbase
cd /app/kafka-connect-couchbase
mvn package
unzip /app/kafka-connect-couchbase/target/kafka-connect-couchbase-3.4.6-SNAPSHOT.zip -d /app/kafka-connect-couchbase/target/

cp ./config/connect-standalone.properties $KAFKA_HOME/config
cp ./config/quickstart-couchbase-sink.properties $KAFKA_CONNECT_COUCHBASE_HOME/target/kafka-connect-couchbase-3.4.6-SNAPSHOT/config/

KAFKA_HEAP_OPTS="-Xms1g -Xmx1g"
exec $KAFKA_HOME/bin/connect-standalone.sh $KAFKA_HOME/config/connect-standalone.properties /app/kafka-connect-couchbase/target/kafka-connect-couchbase-3.4.6-SNAPSHOT/config/quickstart-couchbase-sink.properties

set +ex