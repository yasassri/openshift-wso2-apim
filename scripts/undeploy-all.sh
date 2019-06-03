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
# methods
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}
echoBold "Cleanup Started"

oc delete configmap apim-conf
oc delete configmap apim-conf-axis2
oc delete configmap apim-conf-datasources
oc delete configmap apim-conf-tomcat
oc delete configmap apim-conf-identity
oc delete configmap apim-conf-data-bridge
oc delete configmap apim-conf-security
oc delete configmap apim-conf-bin

# delete the APIM Analytics ConfigMaps
oc delete configmap apim-analytics-conf
oc delete configmap apim-analytics-conf-bin

echoBold 'Creating ConfigMaps for APIM KM Analytics...'
# delete the IS Analytics ConfigMaps
oc delete configmap is-analytics-conf
oc delete configmap is-analytics-conf-bin

# delete the APIM IS as Key Manager ConfigMaps
oc delete configmap apim-is-as-km-conf
oc delete configmap apim-is-as-km-conf-axis2
oc delete configmap apim-is-as-km-conf-datasources
oc delete configmap apim-is-as-km-conf-tomcat
oc delete configmap apim-is-as-km-conf-identity
oc delete configmap apim-is-as-km-conf-event-publishers
oc delete configmap apim-is-as-km-conf-bin

# deploy the Kubernetes services
oc delete -f ../k8s/apim-is/is-analytics/is-analytics-service.yaml
oc delete -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-service.yaml
oc delete -f ../k8s/apim-is/apim-analytics/wso2apim-analytics-service.yaml
oc delete -f ../k8s/apim-is/apim/wso2apim-service.yaml

oc delete -f ../k8s/apim-is/apim-analytics/wso2apim-analytics-deployment.yaml

oc delete -f ../k8s/apim-is/is-analytics/is-analytics-deployment.yaml

#oc delete -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-volume-claim.yaml
oc delete -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-deployment.yaml

#oc delete -f ../k8s/apim-is/apim/wso2apim-volume-claim.yaml
oc delete -f ../k8s/apim-is/apim/wso2apim-deployment.yaml

oc delete -f ../k8s/apim-is/routes/apim-is-as-km-routes.yaml
oc delete -f ../k8s/apim-is/routes/apim-gw-external-routes.yaml
oc delete -f ../k8s/apim-is/routes/apim-store-pub-routes.yaml
