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

# Setting the necessary environment variables
export K8S_NAMESPACE="banco-pichincha-test"

export OS_URL=""
export OS_USER=""
export OS_USER_PASSWORD=""

export DOCKER_REGISTRY_URL=""
export DOCKER_REGISTRY_NAMESPACE=$K8S_NAMESPACE
export KEYSTORE_DIR_NAME="dev-env" # The directory name which contains environment specific keystores in resources/keystores
export WSO2_PACK_LOCATION="" # The directory where WSO2 packs reside

#DNS Names for the servers
export APIM_HOST_NAME="apim.wso2.com"
export APIM_GW_HOST_NAME="gw.wso2.com"
export IS_HOST_NAME="identity.wso2.com"

#DB Details 
#For all the DB's the same user will be used.
export DB_URL="10.2.1.2:1433" # host:port
export DB_USER="root"
export DB_USER_PASSWORD="root123456"

#Master admin of the WSO2 server
export ADMIN_USER="admin"
export ADMIN_USER_PASSWORD="admin"
export ADMIN_USER_PASSWORD_ENCODED="YnBhZG1pbg==" # This is the base64 encoded value of the admin password, you can use https://www.base64encode.org/ to encode.

#Keystore Details
export KEYSTORE_PASSWORD="wso2carbon"
export TRUSTORE_PASSWORD="wso2carbon"

# Docker image names # Do Not change these names
export APIM_DOCKER_IMAGE="wso2apim-2.6.0"
export APIM_ANALYTICS_DOCKER_IMAGE="wso2apim-analytics-2.6.0"
export IS_AS_KM_DOCKER_IMAGE="wso2is-km-5.7.0"
export IS_ANALYTICS_DOCKER_IMAGE="wso2is-analytics-5.7.0"
