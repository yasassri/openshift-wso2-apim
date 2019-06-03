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
# Functions
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}

echoBold "Initiating deploying APIM and Identity Server along with Analytics components........"

echoBold 'Creating ConfigMaps for API Manager...'
# create the APIM  ConfigMaps
oc create configmap apim-conf --from-file=../k8s/apim-is/confs/apim/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-axis2 --from-file=../k8s/apim-is/confs/apim/axis2/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-datasources --from-file=../k8s/apim-is/confs/apim/datasources/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-tomcat --from-file=../k8s/apim-is/confs/apim/tomcat/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-identity --from-file=../k8s/apim-is/confs/apim/identity/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-data-bridge --from-file=../k8s/apim-is/confs/apim/data-bridge/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-security --from-file=../k8s/apim-is/confs/apim/security/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-conf-bin --from-file=../k8s/apim-is/confs/apim/bin/ --dry-run -o yaml | oc apply -f -

echoBold 'Creating ConfigMaps for APIM Analytics...'
# create the APIM Analytics ConfigMaps
oc create configmap apim-analytics-conf --from-file=../k8s/apim-is/confs/apim-analytics/conf/worker/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-analytics-conf-bin --from-file=../k8s/apim-is/confs/apim-analytics/conf/worker/bin/ --dry-run -o yaml | oc apply -f -

echoBold 'Creating ConfigMaps for APIM KM Analytics...'
# create the IS Analytics ConfigMaps
oc create configmap is-analytics-conf --from-file=../k8s/apim-is/confs/is-analytics/conf/worker/ --dry-run -o yaml | oc apply -f -
oc create configmap is-analytics-conf-bin --from-file=../k8s/apim-is/confs/is-analytics/conf/worker/bin/ --dry-run -o yaml | oc apply -f -

echoBold 'Creating ConfigMaps for Key Manager...'
# create the APIM IS as Key Manager ConfigMaps
oc create configmap apim-is-as-km-conf --from-file=../k8s/apim-is/confs/apim-is-as-km/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-axis2 --from-file=../k8s/apim-is/confs/apim-is-as-km/axis2/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-datasources --from-file=../k8s/apim-is/confs/apim-is-as-km/datasources/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-tomcat --from-file=../k8s/apim-is/confs/apim-is-as-km/tomcat/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-identity --from-file=../k8s/apim-is/confs/apim-is-as-km/identity/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-event-publishers --from-file=../k8s/apim-is/confs/apim-is-as-km/deployment/server/eventpublishers/ --dry-run -o yaml | oc apply -f -
oc create configmap apim-is-as-km-conf-bin --from-file=../k8s/apim-is/confs/apim-is-as-km/bin/ --dry-run -o yaml | oc apply -f -

echoBold "Creating the common PVCs..."
oc apply -f ../k8s/volume-claims/apim-is-volume-claim.yaml

echoBold 'Creating the K8S services...'
# deploy the Kubernetes services
oc apply -f ../k8s/apim-is/is-analytics/is-analytics-service.yaml
oc apply -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-service.yaml
oc apply -f ../k8s/apim-is/apim-analytics/wso2apim-analytics-service.yaml
oc apply -f ../k8s/apim-is/apim/wso2apim-service.yaml
sleep 2

echoBold 'Deploying WSO2 API Manager Analytics...'
oc apply -f ../k8s/apim-is/apim-analytics/wso2apim-analytics-deployment.yaml

echoBold 'Deploying WSO2 IS Manager Analytics...'
oc apply -f ../k8s/apim-is/is-analytics/is-analytics-deployment.yaml
echoBold "Waiting for the Analytics deployments to complete, please be patient..........."
sleep 1m

echoBold 'Deploying WSO2 API Manager Key Manager........'
oc apply -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-volume-claim.yaml
oc apply -f ../k8s/apim-is/apim-is-as-km/wso2apim-is-as-km-deployment.yaml
echoBold "Waiting for the API Manager Key Manager deployment to complete, please be patient..........."
sleep 2m

echoBold 'Deploying WSO2 API Manager......'
oc apply -f ../k8s/apim-is/apim/wso2apim-volume-claim.yaml
oc apply -f ../k8s/apim-is/apim/wso2apim-deployment.yaml

echoBold 'Deploying Routes for API Manager, Gateway and Identity Server......'
oc apply -f ../k8s/apim-is/routes/apim-is-as-km-routes.yaml
oc apply -f ../k8s/apim-is/routes/apim-gw-external-routes.yaml
oc apply -f ../k8s/apim-is/routes/apim-store-pub-routes.yaml

echoBold "Deployment is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
