#!/bin/bash

FILE=$(basename $0)
NAME=${FILE%.sh}
echo $NAME
SCRIPTS=$(cd $(dirname $0); pwd)
TOP=$(dirname $SCRIPTS)
echo $TOP

mkdir -p $TOP/target
cd $TOP/target

VERSION="0.10.6"
URL="https://bintray.com/jpl-imce/gov.nasa.jpl.imce/download_file?file_path=gov%2Fnasa%2Fjpl%2Fimce%2Fgov.nasa.jpl.imce.oml.converters%2F$VERSION%2Fgov.nasa.jpl.imce.oml.converters-$VERSION.tgz"
if ! test -f omlConverter.tgz; then
    echo "# Downloading OML Converter..."
    curl -L "$URL" -o omlConverter.tgz
fi

if ! test -d OMLConverters; then
    echo "# Extracting OML Converter..."
    tar zxf omlConverter.tgz
fi

./OMLConverters/bin/omlConverter --help