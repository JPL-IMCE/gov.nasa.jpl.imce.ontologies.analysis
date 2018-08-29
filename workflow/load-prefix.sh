#!/bin/bash

## load prefixes for running reports
[ -z "$FUSEKI_ENDPOINT" ] && echo "FUSEKI_ENDPOINT environment not set!"
[ -z "$FUSEKI_DATASET" ] && echo "FUSEKI_DATASET environment not set!"

curl -v \
    -X PUT \
    -H "Content-Type: text/turtle" \
    -G "${FUSEKI_ENDPOINT}/${FUSEKI_DATASET}/data" \
    --data-urlencode graph='default' \
    -T 'prefix-imports.ttl'
