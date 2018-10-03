#!/bin/sh

# create dataset on fuseki

FUSEKI_CREATE_PARAMS="$/datasets?dbType=tdb&dbName="
URL="http://$JENA_HOST:$JENA_PORT/$FUSEKI_CREATE_PARAMS$JENA_DATASET"
echo $URL

curl -X POST "$URL"
