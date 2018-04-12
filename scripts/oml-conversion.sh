#!/usr/bin/env bash

set -o errexit

FILE="$(basename $0)"
NAME="${FILE%.sh}"
SCRIPTS="$(cd $(dirname $0); pwd)"
TOP="$(dirname $SCRIPTS)"
echo "$TOP"

sh "$SCRIPTS/getOMLConverter.sh"

DATE="$(date)"

/bin/rm -rf "$TOP/target/$NAME"
mkdir -p "$TOP/target/$NAME"
#cd "$TOP/target/$NAME"

# The following path is required for the current analysis workflow build process
cd "$TOP/target/workflow/artifacts"
HERE="$(pwd)"

CONVERTER_INFO="$($TOP/target/OMLConverters/bin/omlConverter --version)"

OML_IMPORT=$TOP/target/import

CATALOG=oml.catalog.xml
INPUT=oml-input
OUTPUT=ontologies

IMCE=imce.jpl.nasa.gov
PROJECT_BUNDLE_PATH=$IMCE/foundation/project

echo "# current path: $(pwd)"

# copy exported function list data

rm -rf $INPUT
mkdir $INPUT
rsync -av $OML_IMPORT/$1/resources $INPUT
rsync -av $OML_IMPORT/$1/bundles $INPUT

echo "# converter input path: $INPUT"
echo "# converter output path: $OUTPUT"

"$TOP/target/OMLConverters/bin/omlConverter" text $INPUT/resources/$CATALOG --output $OUTPUT --owl --clear

# add cached project bundle

#mkdir -p $OUTPUT/$PROJECT_BUNDLE_PATH
rsync -av --exclude='**-embedding*' $INPUT/bundles/$PROJECT_BUNDLE_PATH/ $OUTPUT/$PROJECT_BUNDLE_PATH


