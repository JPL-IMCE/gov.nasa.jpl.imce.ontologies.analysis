#!/bin/bash

unset fuseki_protocol fuseki_host fuseki_port fuseki_dataset
while test $# -gt 0
do
    case $1 in
	--fuseki-protocol)      fuseki_protocol=$2;;
	--fuseki-host)          fuseki_host=$2;;
	--fuseki-port)          fuseki_port=$2;;
	--fuseki-dataset)       fuseki_dataset=$2;;
    esac
    shift; shift
done

export FUSEKI_PROTOCOL=${fuseki_protocol:-http:}
export FUSEKI_HOST=${fuseki_host:-localhost}
export FUSEKI_PORT=${fuseki_port:-8898}
export FUSEKI_DATASET=${fuseki_dataset:-europa-efse}

# Read-only
export ETC=$(dirname $(pwd))/etc

# Read-only
export WORKFLOW_SOURCES=$(dirname $(pwd))/workflow

# Read-only
export BUNDLES_DIR=$(dirname $(pwd))/target/workflow/artifacts/bundles

# Read-only
export ENTAILMENTS_DIR=$(dirname $(pwd))/target/workflow/artifacts/entailments

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
$tools/lib/Audit:\
$TOOLS/lib/BundleClosure:\
$TOOLS/lib/IMCE:\
$TOOLS/lib/Jena:\
$TOOLS/lib/Makefile:\
$TOOLS/lib/OWLAPI:\
$TOOLS/lib/OntologyBundles:\
$TOOLS/lib/Openllet:\
$TOOLS/lib/Pellet:\
$TOOLS/lib/ruby-jena:\
$TOOLS/lib/ruby-owlapi:\
$TOOLS/lib/ruby-openllet:\
$TOOLS/lib/ruby-pellet:\
$TOOLS/lib/JGraphT:\
$TOOLS/lib/OMFMetadata:\
$TOOLS/lib/Slf4j

[ -z "$GEM_HOME" ] && echo "GEM_HOME environment not set!"
# && exit -1

[ -z "$JRUBY" ] && export JRUBY=$(which jruby)

export GEM_PATH="${GEM_HOME}:$(dirname $(pwd))"

export PARALLEL_MAKE_OPTS="-j8 -l16"

export FUSEKI_ENDPOINT=$FUSEKI_PROTOCOL//$FUSEKI_HOST:$FUSEKI_PORT/$FUSEKI_DATASET

# Add as maven dependency
export DOCBOOK_XHTML_XSL="${TOOLS}/docbook/xhtml/docbook.xsl"

AUDITS_TREE_PATH=$(dirname $(pwd))/data/Audit/export/caesar-demo
if [ $# -gt 2 ] && [ $3 != 'undefined' ]; then
   AUDITS_TREE_PATH="$3"
fi
export AUDITS_TREE_PATH

REPORTS_TREE_PATH=$(dirname $(pwd))/data/Report/export/caesar-demo
if [ $# -gt 3 ] && [ $4 != 'undefined' ]; then
    REPORTS_TREE_PATH="$4"
fi
export REPORTS_TREE_PATH
