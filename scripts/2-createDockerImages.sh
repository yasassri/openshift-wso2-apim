#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2019 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------
#
cd $(dirname "$0")/../
REPO_HOME=$(pwd)

# keystore Directory
KEYSTORE_DIR="${REPO_HOME}/resources/keystores/$KEYSTORE_DIR_NAME"

# SQL Driver locations
DRIVER_LOCATION=${REPO_HOME}/resources/driver/sqljdbc42.jar
OSGI_DRIVER_LOCATION=${REPO_HOME}/resources/driver/osgi/sqljdbc42_1.0.0.jar

## Functions ## 

####
# Echo fucntion
####
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}

####
# Function to copy artefacts required for the docker build.
#
# product : The dokcer dir name, e.g : apim, apim-analytics
# pack : The WSO2 distribution related to the docker image
# driver : Driver needed to be added to the distribution
# keystore : keystores that needed to be added to the distribution
# 
####
function copyArtifacts() {
    local product=$1
    local pack=$2
    local driver=$3
    local keystores=$4

    # Clean if there is any pack here
    rm -rf ${REPO_HOME}/docker/$product/files/wso2*
    rm -rf ${REPO_HOME}/docker/$product/files/lib/*
    rm -rf ${REPO_HOME}/docker/$product/files/keystores/*
    echo "Copying the distribution ${pack}"
    unzip -q $pack -d ${REPO_HOME}/docker/$product/files
    #cp -r $pack ${REPO_HOME}/docker/$product/files/
    echo "Copying Keystores and Jars..."
    cp $driver ${REPO_HOME}/docker/$product/files/lib/
    cp $keystores/* ${REPO_HOME}/docker/$product/files/keystores/
}
####
# Function to build docker images tag and push to the registry.
####
function buildDockerAndPush() {
    local product=$1
    local dockerImageName=$2
    cd $REPO_HOME/docker/$product
    docker build -q -t $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_NAMESPACE/$dockerImageName:latest .
    cd -
}

### Main Execution Flow ###
echoBold "Starting To create Docker images."

echoBold "Creating the apim docker image!!!"
copyArtifacts "apim" "${WSO2_PACK_LOCATION}/wso2am-2.6.0*.zip" ${DRIVER_LOCATION} ${KEYSTORE_DIR}
buildDockerAndPush "apim" ${APIM_DOCKER_IMAGE}

echoBold "Creating the apim-analytics-worker docker image!!!"
copyArtifacts "apim-analytics-worker" "${WSO2_PACK_LOCATION}/wso2am-analytics-2.6.0*.zip" ${OSGI_DRIVER_LOCATION} ${KEYSTORE_DIR}
buildDockerAndPush "apim-analytics-worker" ${APIM_ANALYTICS_DOCKER_IMAGE}

echoBold "Creating the is-analytics-worker docker image!!!"
copyArtifacts "is-analytics-worker" "${WSO2_PACK_LOCATION}/wso2is-analytics-5.7.0*.zip" ${OSGI_DRIVER_LOCATION} ${KEYSTORE_DIR}
buildDockerAndPush "is-analytics-worker" ${IS_ANALYTICS_DOCKER_IMAGE}

echoBold "Creating the IS KM docker image!!!"
copyArtifacts "is-km" "${WSO2_PACK_LOCATION}/wso2is-km-5.7.0*.zip" ${DRIVER_LOCATION} ${KEYSTORE_DIR}
buildDockerAndPush "is-km" ${IS_AS_KM_DOCKER_IMAGE}

