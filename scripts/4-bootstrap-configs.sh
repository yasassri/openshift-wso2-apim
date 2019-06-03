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
cd `dirname "$0"`

INTERNAL_DOCKER_REG_URL="docker-registry.default.svc:5000"

# Docker image locations
APIM_DOCKER_IMAGE="$INTERNAL_DOCKER_REG_URL/$K8S_NAMESPACE/$APIM_DOCKER_IMAGE:latest"
APIM_ANALYTICS_DOCKER_IMAGE="$INTERNAL_DOCKER_REG_URL/$K8S_NAMESPACE/$APIM_ANALYTICS_DOCKER_IMAGE:latest"
IS_AS_KM_DOCKER_IMAGE="$INTERNAL_DOCKER_REG_URL/$K8S_NAMESPACE/$IS_AS_KM_DOCKER_IMAGE:latest"
IS_ANALYTICS_DOCKER_IMAGE="$INTERNAL_DOCKER_REG_URL/$K8S_NAMESPACE/$IS_ANALYTICS_DOCKER_IMAGE:latest"

## Place Holders ##
## DO NOT CHANGE ## 
K8S_NAMESPACE_PH="XX_K8S_NAMESPACE_XX"

DB_URL_PH="XX_DB_URL_XX"
DB_USER_PH="XX_DB_USER_XX"
DB_USER_PASSWORD_PH="XX_DB_USER_PASSWORD_XX"

ADMIN_USER_PH="XX_ADMIN_USER_XX"
ADMIN_USER_PASSWORD_PH="XX_ADMIN_USER_PASSWORD_XX"
ADMIN_USER_PASSWORD_ENCODED_PH="XX_ADMIN_USER_PASSWORD_ENCODED_XX"

APIM_DOCKER_IMAGE_PH="XX_APIM_DOCKER_IMAGE_XX"
APIM_ANALYTICS_DOCKER_IMAGE_PH="XX_APIM_ANALYTICS_DOCKER_IMAGE_XX"
IS_ANALYTICS_DOCKER_IMAGE_PH="XX_IS_ANALYTICS_DOCKER_IMAGE_XX"
IS_AS_KM_DOCKER_IMAGE_PH="XX_IS_AS_KM_DOCKER_IMAGE_XX"

APIM_HOST_NAME_PH="XX_APIM_HOST_NAME_XX"
IS_HOST_NAME_PH="XX_IS_HOST_NAME_XX"
APIM_GW_HOST_NAME_PH="XX_APIM_GW_HOST_NAME_XX"

KEYSTORE_PASSWORD_PH="XX_KEYSTORE_PASSWORD_XX"
TRUSTORE_PASSWORD_PH="XX_TRUSTORE_PASSWORD_XX"

#################################
### Main Execution Starts Here ##
#################################
# Functions
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}

echoBold "Bootstapping the configurations files"
DESTINATION="../k8s"

echoBold "Updating the configurations located at the Destination " $DESTINATION

set +e
grep -rl ${K8S_NAMESPACE_PH} ${DESTINATION} | xargs sed -i "s&${K8S_NAMESPACE_PH}&${K8S_NAMESPACE}&g"

grep -rl ${DB_URL_PH} ${DESTINATION} | xargs sed -i "s&${DB_URL_PH}&${DB_URL}&g"
grep -rl ${DB_USER_PH} ${DESTINATION} | xargs sed -i "s&${DB_USER_PH}&${DB_USER}&g"
grep -rl ${DB_USER_PASSWORD_PH} ${DESTINATION} | xargs sed -i "s&${DB_USER_PASSWORD_PH}&${DB_USER_PASSWORD}&g"

grep -rl ${ADMIN_USER_PH} ${DESTINATION} | xargs sed -i "s&${ADMIN_USER_PH}&${ADMIN_USER}&g"
grep -rl ${ADMIN_USER_PASSWORD_PH} ${DESTINATION} | xargs sed -i "s&${ADMIN_USER_PASSWORD_PH}&${ADMIN_USER_PASSWORD}&g"
grep -rl ${ADMIN_USER_PASSWORD_ENCODED_PH} ${DESTINATION} | xargs sed -i "s&${ADMIN_USER_PASSWORD_ENCODED_PH}&${ADMIN_USER_PASSWORD_ENCODED}&g"

grep -rl ${APIM_DOCKER_IMAGE_PH} ${DESTINATION} | xargs sed -i "s&${APIM_DOCKER_IMAGE_PH}&${APIM_DOCKER_IMAGE}&g"
grep -rl ${APIM_ANALYTICS_DOCKER_IMAGE_PH} ${DESTINATION} | xargs sed -i "s&${APIM_ANALYTICS_DOCKER_IMAGE_PH}&${APIM_ANALYTICS_DOCKER_IMAGE}&g"
grep -rl ${IS_AS_KM_DOCKER_IMAGE_PH} ${DESTINATION} | xargs sed -i "s&${IS_AS_KM_DOCKER_IMAGE_PH}&${IS_AS_KM_DOCKER_IMAGE}&g"
grep -rl ${IS_ANALYTICS_DOCKER_IMAGE_PH} ${DESTINATION} | xargs sed -i "s&${IS_ANALYTICS_DOCKER_IMAGE_PH}&${IS_ANALYTICS_DOCKER_IMAGE}&g"

grep -rl ${APIM_HOST_NAME_PH} ${DESTINATION} | xargs sed -i "s&${APIM_HOST_NAME_PH}&${APIM_HOST_NAME}&g"
grep -rl ${IS_HOST_NAME_PH} ${DESTINATION} | xargs sed -i "s&${IS_HOST_NAME_PH}&${IS_HOST_NAME}&g"
grep -rl ${APIM_GW_HOST_NAME_PH} ${DESTINATION} | xargs sed -i "s&${APIM_GW_HOST_NAME_PH}&${APIM_GW_HOST_NAME}&g"

grep -rl ${KEYSTORE_PASSWORD_PH} ${DESTINATION} | xargs sed -i "s&${KEYSTORE_PASSWORD_PH}&${KEYSTORE_PASSWORD}&g"
grep -rl ${TRUSTORE_PASSWORD_PH} ${DESTINATION} | xargs sed -i "s&${TRUSTORE_PASSWORD_PH}&${TRUSTORE_PASSWORD}&g"


echoBold "Updating the configuration completed.....You can execute the deployment scripts...."
