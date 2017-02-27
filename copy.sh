BUILD=$(pwd -P)/build

docker run \
  -v "${BUILD}":/build \
  elastic-build copy