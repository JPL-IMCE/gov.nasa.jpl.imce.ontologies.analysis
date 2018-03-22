#!/usr/bin/env bash

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
INPUT=$OML_IMPORT/$1
OUTPUT=ontologies

PUBLIC=$PUBLIC_IMPORT/$2
PUBLIC_ONTOLOGIES=$PUBLIC/ontologies
PUBLIC_BUNDLES=$PUBLIC/bundles

IMCE=imce.jpl.nasa.gov
PROJECT_BUNDLE_PATH=$IMCE/foundation/project
EUROPA=europa.jpl.nasa.gov
OMG_ORG=www.omg.org
PURL_ORG=purl.org
W3_ORG=www.w3.org

OMIT="
  $OUTPUT/$IMCE/math
  $OUTPUT/$IMCE/skeleton
  $OUTPUT/$IMCE/discipline/mechanical
  $OUTPUT/$IMCE/discipline/ontological-behavior
  $OUTPUT/$IMCE/discipline/risk
  $OUTPUT/$IMCE/discipline/state-analysis
  $OUTPUT/$IMCE/foundation/owl2-mof2
  $OUTPUT/$IMCE/foundation/time
  $OUTPUT/$IMCE/oml/provenance
  $OUTPUT/$IMCE/$OMG_ORG
  $OUTPUT/$IMCE/*/*/*-embedding.owl
"

echo "current path: $(pwd)"

#rm -rf $INPUT
#mkdir $INPUT
#rsync -av $1/ $INPUT

#echo "# Clear the destination folder & copy IMCE vocabularies to ./$PREV_REPO/resources/vocabulary/asserted/"
#"$TOP/target/OMLConverters/bin/omlConverter" \
#    text \
#    -c ./gov.nasa.jpl.imce.ontologies.public/converted-oml/oml.catalog.xml \
#    -out ./$PREV_REPO/resources/vocabulary/asserted --clear \
#    -t \
#    -v:files

echo "converter input path: $INPUT"
echo "converter output path: $OUTPUT"

"$TOP/target/OMLConverters/bin/omlConverter" text $INPUT/$CATALOG --output $OUTPUT --owl --clear


# overwrite vocabulary with latest OWL files
rsync -av $PUBLIC_ONTOLOGIES/$IMCE $PUBLIC_ONTOLOGIES/$PURL_ORG $PUBLIC_ONTOLOGIES/$W3_ORG $OUTPUT

# add cached project bundle
mkdir -p $OUTPUT/$PROJECT_BUNDLE_PATH
rsync -av --exclude='**-embedding*' $PUBLIC_BUNDLES/$PROJECT_BUNDLE_PATH/ $OUTPUT/$PROJECT_BUNDLE_PATH

# omit unused vocabulary
rm -rf $OMIT
