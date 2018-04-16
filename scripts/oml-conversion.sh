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
OMG_ORG=www.omg.org

OML_IMPORT_RESOURCES=$OML_IMPORT/$1/resources
PUBLIC_BUNDLES=$OML_IMPORT/$1/bundles

echo "# current path: $(pwd)"
echo "# oml import resources: $OML_IMPORT_RESOURCES"
echo "# public bundles: $PUBLIC_BUNDLES"


# copy exported function list data

rm -rf $INPUT
mkdir $INPUT
rsync -av $OML_IMPORT_RESOURCES $INPUT

echo "# converter input path: $INPUT"
echo "# converter output path: $OUTPUT"

"$TOP/target/OMLConverters/bin/omlConverter" text $INPUT/$CATALOG --output $OUTPUT --owl --clear

# add cached project bundle

rsync -av --exclude='**'$OMG_ORG'**' --exclude='**-embedding*' $PUBLIC_BUNDLES/ $OUTPUT/

