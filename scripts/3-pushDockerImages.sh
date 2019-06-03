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

## Functions ## 
####
# Function to login to the docker registry
####
function loginToDockerRegistry() {
    echo "Login to the oc and docker registry"
    oc login $OS_URL --username=$OS_USER --password=$OS_USER_PASSWORD --insecure-skip-tls-verify
    token=$(oc whoami -t)
    docker login -u $OS_USER -p $token $DOCKER_REGISTRY_URL
}

####
# Echo fucntion
####
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}

####
# Function to push to the registry.
####
function pushImage() {
    local dockerImageName=$1
    docker push $DOCKER_REGISTRY_URL/$DOCKER_REGISTRY_NAMESPACE/$dockerImageName:latest
}

### Main Execution Flow ###
echoBold "Pushing Docker images."

loginToDockerRegistry

echoBold "Pushing the apim docker image!!!"
pushImage ${APIM_DOCKER_IMAGE}

echoBold "Pushing the apim-analytics-worker docker image!!!"
pushImage ${APIM_ANALYTICS_DOCKER_IMAGE}

echoBold "Pushing the is-analytics-worker docker image!!!"
pushImage ${IS_ANALYTICS_DOCKER_IMAGE}

echoBold "Pushing the IS KM docker image!!!"
pushImage ${IS_AS_KM_DOCKER_IMAGE}

