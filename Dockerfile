FROM frekele/gradle:2.13-jdk8

LABEL version="2.0"
LABEL description="Containerized build for Elasticsearch and X-pack"

# update apt, install dependencies
RUN apt-get -y update \
  && apt-get -y install git unzip

# define arguments
ARG ES_SHA
ARG BRANCH

# clone the elasticsearch repo
WORKDIR /repos
ARG ELASTICSEARCH_REPO
RUN git clone https://${ELASTICSEARCH_REPO} --branch="${BRANCH}" --depth=1

# clone the x-pack repo
ARG GH_USER
ARG GH_TOKEN
ARG XPACK_REPO
WORKDIR /repos/elasticsearch-extra
RUN git clone https://${GH_USER}:${GH_TOKEN}@${XPACK_REPO} --branch=${BRANCH} --depth=1

# set up the github token for the build secret
RUN mkdir ~/.elastic
RUN echo "${GH_TOKEN}" > ~/.elastic/github.token
RUN chmod 600 ~/.elastic/github.token

# build elasticsearch
WORKDIR /repos/elasticsearch
RUN gradle --no-daemon clean assemble -Pxpack.kibana.build=false

# remove the github token
RUN rm -rf ~/.elastic

# prepare elasticsearch for running
WORKDIR /elastic
# copy and set up the builds, install x-pack
RUN cp /repos/elasticsearch/distribution/zip/build/distributions/*.zip . \
  && cp /repos/elasticsearch-extra/x-pack-elasticsearch/plugin/build/distributions/*.zip . \
  && unzip elasticsearch*.zip \
  && VERSION=`echo elasticsearch-*.zip | sed 's/elasticsearch-//' | sed 's/\.[^\.]*$//'` \
  && ./"elasticsearch-${VERSION}"/bin/elasticsearch-plugin install -b file:///elastic/"x-pack-${VERSION}.zip"
# copy and setup helper scripts
COPY scripts/* ./
RUN chmod +x *.sh

# allow elasticsearch access on port 9200
EXPOSE 9200

# ENTRYPOINT ["/elastic/runner.sh"]

VOLUME /build
VOLUME /config
