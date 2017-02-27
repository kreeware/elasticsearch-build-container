#!/bin/sh

CMD="$1"
ES_SHA=$(git --git-dir=/repos/elasticsearch/.git rev-parse HEAD)
VERSION=`echo elasticsearch-*.zip | sed 's/elasticsearch-//' | sed 's/\.[^\.]*$//'`
ES_BUILD_NAME=elasticsearch-${VERSION}
XPACK_BUILD_NAME=${XPACK_REPO}-${VERSION}
echo "Version: ${VERSION}"
echo "Elasticsearch SHA: ${ES_SHA}"
echo "Built: $(date -r elasticsearch-6.0.0-alpha1-SNAPSHOT.zip)"
echo ""

case $CMD in
  # copy the build
  copy)
  cp /repos/elasticsearch/distribution/zip/build/distributions/*.zip /build \
  && cp /repos/elasticsearch-extra/x-pack-elasticsearch/plugin/build/distributions/*.zip /build
  ;;
  # start elasticsearch
  start)
  shift
  if [ ! -f /config/elasticsearch.yml ]; then
    cp -r /elastic/${ES_BUILD_NAME}/config/* /config
  fi
  /elastic/${ES_BUILD_NAME}/bin/elasticsearch -Epath.conf=/config $*
  ;;
  *)
  echo "Please specify valid command: "
  echo "  start - Starts elasticsearch"
  echo "  copy - Copies builds to /build"
  ;;
esac
