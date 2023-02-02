#!/bin/bash
set -euo pipefail

DOCKER_IMAGE_NAME="fpga"
JSON_FILE="oss-cad-suite-build.releases.latest.json"

curl -s https://api.github.com/repos/YosysHQ/oss-cad-suite-build/releases/latest > ${JSON_FILE}
OSS_CAD_SUITE_REVISION=$(jq --raw-output ".tag_name" ${JSON_FILE})
OSS_CAD_SUITE_LINUX_URL=$(jq --raw-output ".assets[].browser_download_url | select(contains(\"linux-x64\"))" ${JSON_FILE})
OSS_CAD_SUITE_FILE="oss-cad-suite-linux-x64-${OSS_CAD_SUITE_REVISION}.tgz"

if [[ "$(docker images --quiet ${DOCKER_IMAGE_NAME}:${OSS_CAD_SUITE_REVISION} 2> /dev/null)" == "" ]]; then
    echo "Downloading and building image for new version of OSS CAD Suite found: ${OSS_CAD_SUITE_REVISION}"
    if [ ! -f "${OSS_CAD_SUITE_FILE}" ]; then
        curl --progress-bar --output ${OSS_CAD_SUITE_FILE} --location ${OSS_CAD_SUITE_LINUX_URL}
    else
        echo "Skipping download, ${OSS_CAD_SUITE_FILE} already exists"
    fi
    docker build --tag ${DOCKER_IMAGE_NAME}:latest --tag ${DOCKER_IMAGE_NAME}:${OSS_CAD_SUITE_REVISION} .
else
    echo "Docker image already built for latest OSS CAD Suite: ${DOCKER_IMAGE_NAME}:${OSS_CAD_SUITE_REVISION}"
fi

rm -rf ${JSON_FILE} # ${OSS_CAD_SUITE_FILE}
