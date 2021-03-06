# ------------------------------------------------------------------------
#
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
#
# ------------------------------------------------------------------------

# set base Docker image to AdoptOpenJDK Alpine Docker image
FROM adoptopenjdk/openjdk8:jdk8u192-b12-alpine
MAINTAINER WSO2 Docker Maintainers "dev@wso2.org”
# set user configurations
ARG USER=wso2carbon
ARG USER_ID=802
ARG USER_GROUP=wso2
ARG USER_GROUP_ID=802
ARG USER_HOME=/home/${USER}

# set dependant files directory
ARG FILES=./files

# set wso2 product configurations
ARG WSO2_SERVER=wso2am-analytics
ARG WSO2_SERVER_VERSION=2.6.0
ARG WSO2_SERVER_PACK=${WSO2_SERVER}-${WSO2_SERVER_VERSION}
ARG WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER_PACK}
ENV ENV=${USER_HOME}"/.ashrc"

# set WSO2 EULA
ARG MOTD='printf "\n\
 Welcome to WSO2 Docker Resources \n\
 --------------------------------- \n\
 This Docker container comprises of a WSO2 product, running with its latest updates \n\
 which are under the End User License Agreement (EULA) 2.0. \n\
 Read more about EULA 2.0 here @ https://wso2.com/licenses/wso2-update/2.0 \n"'

# install required packages
RUN  apk add --update --no-cache netcat-openbsd && \
     rm -rf /var/cache/apk/*

# create a user group and a user
RUN  addgroup -g ${USER_GROUP_ID} ${USER_GROUP}; \
     adduser -u ${USER_ID} -D -g '' -h ${USER_HOME} -G ${USER_GROUP} ${USER} ;
# MOTD login message
RUN echo $MOTD > "$ENV"
# create Java prefs dir
# this is to avoid warning logs printed by FileSystemPreferences class
RUN mkdir -p ${USER_HOME}/.java/.systemPrefs && \
    mkdir -p ${USER_HOME}/.java/.userPrefs  && \
    chmod -R 755 ${USER_HOME}/.java && \
    chown -R ${USER}:${USER_GROUP} ${USER_HOME}/.java
# copy wso2 product distribution to user's home directory and set ownership
COPY --chown=wso2carbon:wso2 ${FILES}/${WSO2_SERVER_PACK}/ ${WSO2_SERVER_HOME}/

# copy mysql connector jar to the server as a third party library
COPY --chown=wso2carbon:wso2 ${FILES}/lib ${WSO2_SERVER_HOME}/lib/

#Copy the keystores
COPY --chown=wso2carbon:wso2 ${FILES}/keystores ${WSO2_SERVER_HOME}/resources/security

# copy init script to user home
COPY --chown=wso2carbon:wso2 init.sh ${USER_HOME}/
RUN chmod +x ${USER_HOME}/init.sh

# set environment variables
ENV WSO2_SERVER_HOME=${USER_HOME}/${WSO2_SERVER_PACK} \
    WORKING_DIRECTORY=${USER_HOME} \
    JAVA_OPTS="-Djava.util.prefs.systemRoot=${USER_HOME}/.java -Djava.util.prefs.userRoot=${USER_HOME}/.java/.userPrefs"
# set the user and work directory
USER ${USER_ID}
WORKDIR ${USER_HOME}

# expose ports
EXPOSE 9091 9444 7712 7612 9613 9713 7444 7071

# start WSO2 Carbon server
ENTRYPOINT ["/home/wso2carbon/init.sh"]
