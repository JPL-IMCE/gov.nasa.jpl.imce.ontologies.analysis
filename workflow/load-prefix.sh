#!/bin/bash

## load prefixes for running reports
echo "FUSEKI_BIN: $FUSEKI_BIN"

$FUSEKI_BIN/s-put 'http://'${JENA_HOST}':'${JENA_PORT}'/'${JENA_DATASET}'/data' 'default' 'prefix-imports.ttl'
