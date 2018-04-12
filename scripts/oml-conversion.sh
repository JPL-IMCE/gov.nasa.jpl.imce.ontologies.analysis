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
PUBLIC_IMPORT=$TOP/target/import-vocabulary

CATALOG=oml.catalog.xml
INPUT=oml-input
OUTPUT=ontologies

PUBLIC=$PUBLIC_IMPORT/$2
PUBLIC_ONTOLOGIES=$PUBLIC/ontologies
PUBLIC_BUNDLES=$PUBLIC/bundles

IMCE=imce.jpl.nasa.gov
OMG_ORG=www.omg.org

OMIT="
  $INPUT/$IMCE/math
  $INPUT/$IMCE/skeleton
  $INPUT/$IMCE/discipline/mechanical
  $INPUT/$IMCE/discipline/ontological-behavior
  $INPUT/$IMCE/discipline/risk
  $INPUT/$IMCE/discipline/state-analysis
  $INPUT/$IMCE/foundation/owl2-mof2
  $INPUT/$IMCE/foundation/time
  $INPUT/$IMCE/oml/provenance
  $INPUT/$IMCE/$OMG_ORG
  $INPUT/$IMCE/*/*/*-embedding.oml
  $INPUT/$IMCE/vocabulary
"

echo "# current path: $(pwd)"

# copy exported function list data

rm -rf $INPUT
mkdir $INPUT
rsync -av $OML_IMPORT/$1/ $INPUT

# omit unused vocabulary (workaround)
#rm -rf $OMIT

# remove bogus vocabulary extensions (workaround)

#for o in $(find $INPUT -name '*.oml')
#do
#    sed -i.bak '/extends.*owl2-mof2/d' $o
#done

echo "# converter input path: $INPUT"
echo "# converter output path: $OUTPUT"

"$TOP/target/OMLConverters/bin/omlConverter" text $INPUT/$CATALOG --output $OUTPUT --owl --clear

# overwrite vocabulary with latest OWL files
#rsync -av $PUBLIC_ONTOLOGIES/$IMCE $PUBLIC_ONTOLOGIES/$PURL_ORG $PUBLIC_ONTOLOGIES/$W3_ORG $OUTPUT

# add cached project bundle

rsync -av --exclude='**www.omg.org**' --exclude='**-embedding*' $PUBLIC_BUNDLES/ $OUTPUT/


