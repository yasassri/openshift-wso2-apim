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
oc=`which oc`

# This is for creating the secret to authenticate with the Docker registry.
DOCKER_REG_URL="docker.wso2.com"
PROJECT_NAME=$K8S_NAMESPACE
DOCKER_REG_USERNAME="DOCKER_REG_PASSWORD"
DOCKER_REG_EMAIL="dev@wso2.com"

oc new-project $PROJECT_NAME --description="Dev Project" --display-name="Dev"
oc project $PROJECT_NAME

oc create serviceaccount wso2svc-account -n $PROJECT_NAME

# Create the pvs 
# Most cases this will be created by the cluster admin, so DO NOT execute if already there.
oc create -f ../k8s/volumes/persistent-volumes.yaml

# Create the Rbac for WSO2 clustering
oc create -f ../k8s/rbac/rbac.yaml

# Creating the  ADM policy to retrieve k8s cluster information from the svc account

# We need to create a Docker registry secret if authentication is required by the registry.
#oc create secret docker-registry wso2creds --docker-server=${DOCKER_REG_URL} --docker-username=${DOCKER_REG_USERNAME} --docker-password=${DOCKER_REG_PASSWORD} --docker-email=${DOCKER_REG_EMAIL}
