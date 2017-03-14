
# Build if TRAVIS_TAG is unset or empty.
[ -n "${TRAVIS_TAG}" ] && exit 0;

# Get the tag for this commit
t=$(git name-rev --tags --name-only $(git rev-parse HEAD))

# Bypass the build if the tag is anything but 'undefined'.
[ "undefined" != "$t" ] && exit 0;

[ -z "${PUBLIC_ONTOLOGIES_VERSION}" ] && echo "# PUBLIC_ONTOLOGIES_VERSION is unset; exiting!" && exit -1;

rvm install jruby

source ~/.rvm/scripts/rvm

rvm use jruby

gem install gems/docbook-1.0.7.gem

echo "# PUBLIC_ONTOLOGIES_VERSION=${PUBLIC_ONTOLOGIES_VERSION}"

sbt -jvm-opts travis/jvmopts.compile setupTools setupOntologies setupFuseki
(cd workflow; . env.sh; make loadprod)
