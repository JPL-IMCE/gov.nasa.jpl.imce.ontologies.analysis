#!/bin/bash

# Read-only
export ETC=$(dirname $(pwd))/etc

# Read-only
export WORKFLOW_SOURCES=$(dirname $(pwd))/workflow

# Read-only
export BUNDLES_DIR=$(dirname $(pwd))/target/workflow/artifacts/bundles

# Read-only
export ONTOLOGIES_DIR=$(dirname $(pwd))/target/workflow/artifacts/ontologies

# Read-only
FUSEKI_PROJ="$(dirname $(dirname "$(pwd)"))/gov.nasa.jpl.imce.ontologies.fuseki"
export FUSEKI_HOME="$FUSEKI_PROJ/target/fuseki"

export FUSEKI_BIN="${FUSEKI_HOME}/bin"
#export FUSEKI_BIN="/opt/local/apache-jena-fuseki-3.6.0/bin"

# Read-only
export TOOLS=$(dirname $(pwd))/target/tools

# Read/write
export WORKFLOW=$(dirname $(pwd))/target/workflow

# Read/write
export FUSEKI_BASE=$(dirname $(pwd))/target/run

[ ! -d $WORKFLOW ] && mkdir -p $WORKFLOW

[ ! -d $WORKFLOW/artifacts ] && mkdir -p $WORKFLOW/artifacts

export RUBYLIB=$TOOLS/lib/Application:\
$TOOLS/lib/Audit:\
$TOOLS/lib/BundleClosure:\
$TOOLS/lib/IMCE:\
$TOOLS/lib/Jena:\
$TOOLS/lib/Makefile:\
$TOOLS/lib/OWLAPI:\
$TOOLS/lib/OntologyBundles:\
$TOOLS/lib/Pellet:\
$TOOLS/lib/ruby-jena:\
$TOOLS/lib/ruby-owlapi:\
$TOOLS/lib/ruby-pellet:\
$TOOLS/lib/JGraphT:\
$TOOLS/lib/OMFMetadata

[ -z "$GEM_HOME" ] && echo "GEM_HOME environment not set!"
# && exit -1

[ -z "$JRUBY" ] && export JRUBY=$(which jruby)
echo "# JRUBY=$JRUBY"

export GEM_PATH="${GEM_HOME}:$(dirname $(pwd))"

export PARALLEL_MAKE_OPTS="-j8 -l16"

JENA_DATASET_NAME="europa-efse"
if [ $# -gt 0 ]; then
  JENA_DATASET_NAME="$1"
fi
export JENA_DATASET=$JENA_DATASET_NAME
echo "JENA_DATASET is ${JENA_DATASET}"

export JENA_HOST="localhost"

JENA_PORT_NUMBER="8898"

if [ $# -gt 1 ]; then
  JENA_PORT_NUMBER="$2"
fi
export JENA_PORT=$JENA_PORT_NUMBER
echo "JENA_PORT is ${JENA_PORT}"

# Add as maven dependency
export DOCBOOK_XHTML_XSL="${TOOLS}/docbook/xhtml/docbook.xsl"

AUDITS_TREE_PATH=$(dirname $(pwd))/data/Audit/export/caesar-demo
if [ $# -gt 2 ] && [ $3 != 'undefined' ]; then
   AUDITS_TREE_PATH="$3"
fi
export AUDITS_TREE_PATH
echo "AUDITS_TREE_PATH is ${AUDITS_TREE_PATH}"

REPORTS_TREE_PATH=$(dirname $(pwd))/data/Report/export/caesar-demo
if [ $# -gt 3 ] && [ $4 != 'undefined' ]; then
    REPORTS_TREE_PATH="$4"
fi
export REPORTS_TREE_PATH
echo "REPORTS_TREE_PATH is ${REPORTS_TREE_PATH}"
