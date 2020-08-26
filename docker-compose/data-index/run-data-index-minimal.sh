export DATA_INDEX_VERSION="0.14.0"
java \
-Dquarkus.log.console.level=DEBUG -Dquarkus.log.category.\"org.kie.kogito\".min-level=DEBUG \
-Dquarkus.log.category.\"org.kie.kogito\".level=DEBUG \
-Dquarkus.infinispan-client.server-list=localhost:11222 \
-Dkogito.protobuf.folder=/Users/mouachani/projects/credit/companies-credit/docker-compose/data-index/persistence \
-jar data-index-service-${DATA_INDEX_VERSION}-runner.jar   
