#!/bin/bash

## load prefixes for running reports
[ -z "$FUSEKI_BIN" ] && echo "FUSEKI_BIN environment not set!"

FUSEKI_S_PUT=${FUSEKI_BIN}/s-put
$FUSEKI_S_PUT 'http://'${JENA_HOST}':'${JENA_PORT}'/'${JENA_DATASET}'/data' 'default' 'prefix-imports.ttl'
