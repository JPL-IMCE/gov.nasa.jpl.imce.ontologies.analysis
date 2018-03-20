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
HERE="$(pwd)"

. "$SCRIPTS/caesar-git-services.sh"

CONVERTER_INFO="$($TOP/target/OMLConverters/bin/omlConverter --version)"





git clone https://github.com/JPL-IMCE/gov.nasa.jpl.imce.ontologies.public.git
(cd gov.nasa.jpl.imce.ontologies.public; git checkout feature/IMCEIS-1715-create-temporary-branch-of-ontologie; git status)



PUBLIC=$TOP/target/gov.nasa.jpl.imce.ontologies.public
PUBLIC_ONTOLOGIES=$PUBLIC/ontologies
PUBLIC_BUNDLES=$PUBLIC/bundles
IMCE=imce.jpl.nasa.gov
PROJECT_BUNDLE_PATH=$TOP/target/$IMCE/foundation/project
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






#PREV_URL="$(gitRemoteOriginURL $TOP)"
#PREV_REPO="$(basename $TOP)"

#echo $PREV_REPO

# git clone https://github.com/JPL-IMCE/gov.nasa.jpl.imce.ontologies.public.git
# (cd gov.nasa.jpl.imce.ontologies.public; git checkout feature/IMCEIS-1715-create-temporary-branch-of-ontologie; git status)

#PUBLIC_URL="$(gitRemoteOriginURL gov.nasa.jpl.imce.ontologies.public)"
#PUBLIC_BRANCH="$(gitBranch gov.nasa.jpl.imce.ontologies.public)"
#PUBLIC_TAG="$(gitTag gov.nasa.jpl.imce.ontologies.public)"
#PUBLIC_COMMIT="$(gitCommit gov.nasa.jpl.imce.ontologies.public)"



CATALOG=oml.catalog.xml
INPUT=$TOP/target/import/gov.nasa.jpl.imce.caesar.workflows.europa/resources

OUTPUT=$TOP/target/workflow/artifacts/ontologies

echo "current path: $(pwd)"
echo "input path: $INPUT"
echo "output path: $OUTPUT"

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

# target/import/oml.catalog.xml
# target/import/${OML_REPO}/resources
"$TOP/target/OMLConverters/bin/omlConverter" text $INPUT/$CATALOG --output $OUTPUT --owl --clear


# overwrite vocabulary with latest OWL files
echo "public ontologies path: $PUBLIC_ONTOLOGIES"
echo "public bundles path: $PUBLIC_BUNDLES"
echo "project bundle path: $PROJECT_BUNDLE_PATH"

rsync -av $PUBLIC_ONTOLOGIES/$IMCE $PUBLIC_ONTOLOGIES/$PURL_ORG $PUBLIC_ONTOLOGIES/$W3_ORG $OUTPUT

# add cached project bundle

mkdir -p $OUTPUT/$PROJECT_BUNDLE_PATH
rsync -av --exclude='**-embedding*' $PUBLIC_BUNDLES/$PROJECT_BUNDLE_PATH/ $OUTPUT/$PROJECT_BUNDLE_PATH

# omit unused vocabulary
rm -rf $OMIT




cd $TOP
