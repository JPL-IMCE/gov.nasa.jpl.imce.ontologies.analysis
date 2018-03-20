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
INPUT=$1

cd $TOP/target/workflow/artifacts
OUTPUT=ontologies

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

cd $TOP
