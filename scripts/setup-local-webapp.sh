#!/bin/bash

##############################################################################
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##############################################################################

root_folder=$(cd $(dirname $0); pwd)

# SETUP logging (redirect stdout and stderr to a log file)
readonly LOG_FILE="${root_folder}/deploy-local-webapp.log"
readonly ENV_FILE="${root_folder}/../local.env"

touch $LOG_FILE
exec 3>&1 # Save stdout
exec 4>&2 # Save stderr
exec 1>$LOG_FILE 2>&1

function _out() {
  echo "$@" >&3
  echo "$(date +'%F %H:%M:%S') $@"
}

function _err() {
  echo "$@" >&4
  echo "$(date +'%F %H:%M:%S') $@"
}

function check_tools() {
    MISSING_TOOLS=""
    git --version &> /dev/null || MISSING_TOOLS="${MISSING_TOOLS} git"
    curl --version &> /dev/null || MISSING_TOOLS="${MISSING_TOOLS} curl"
    ibmcloud --version &> /dev/null || MISSING_TOOLS="${MISSING_TOOLS} ibmcloud"    
    if [[ -n "$MISSING_TOOLS" ]]; then
      _err "Some tools (${MISSING_TOOLS# }) could not be found, please install them first and then run scripts/setup-app-id.sh"
      exit 1
    fi
}

function setup() {
  _out Downloading npm modules
  npm --prefix ${root_folder}/../angular install ${root_folder}/../angular

  readonly CONFIG_FILE="${root_folder}/../angular/src/assets/config.json"
  rm $CONFIG_FILE
  touch $CONFIG_FILE

  printf "{\n" >> $CONFIG_FILE
  printf "\"authorizationUrl\": \"" >> $CONFIG_FILE
  printf $APPID_OAUTHURL >> $CONFIG_FILE
  printf "\",\n" >> $CONFIG_FILE
  printf "\"redirectUrl\": \"" >> $CONFIG_FILE
  printf $API_LOGIN >> $CONFIG_FILE
  printf "\",\n" >> $CONFIG_FILE
  printf "\"clientId\": \"" >> $CONFIG_FILE
  printf $APPID_CLIENTID >> $CONFIG_FILE
  printf "\",\n" >> $CONFIG_FILE
  printf "\"protectedUrl\": \"" >> $CONFIG_FILE
  printf $API_PROTECTED >> $CONFIG_FILE
  printf "\"\n" >> $CONFIG_FILE
  printf "}" >> $CONFIG_FILE

  _out To start the web application run ng serve in ${root_folder}/../angular
}

# Main script starts here
check_tools

# Load configuration variables
if [ ! -f $ENV_FILE ]; then
  _err "Before deploying, copy template.local.env into local.env and fill in environment specific values."
  exit 1
fi
source $ENV_FILE
export IBMCLOUD_ORG IBMCLOUD_API_KEY BLUEMIX_REGION APPID_TENANTID APPID_OAUTHURL APPID_CLIENTID APPID_SECRET CLOUDANT_USERNAME CLOUDANT_PASSWORD IBMCLOUD_SPACE APPID_MGMTURL API_LOGIN API_PROTECTED

_out Full install output in $LOG_FILE
setup