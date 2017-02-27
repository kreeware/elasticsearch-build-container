#!/bin/sh
TAG=elasticsearch-build

eval $(cat build-args)

if [[ "${GH_TOKEN}" == "" || "${GH_USER}" == "" ]]; then
  echo "GH_USER and GH_TOKEN are required"
  exit 1
fi

if [[ "${GH_BRANCH}" == "" ]]; then
  GH_BRANCH=master
fi

ES_SHA=$(git ls-remote --heads https://github.com/elastic/elasticsearch.git ${GH_BRANCH} | awk '{print $1}')

docker build \
  --build-arg BRANCH="${GH_BRANCH}" \
  --build-arg GH_USER="${GH_USER}" \
  --build-arg GH_TOKEN="${GH_TOKEN}" \
  --build-arg ELASTICSEARCH_REPO="${ELASTICSEARCH_REPO}" \
  --build-arg XPACK_REPO="${XPACK_REPO}" \
  --build-arg ES_SHA="${ES_SHA}" \
  -t ${TAG}:latest \
  .
