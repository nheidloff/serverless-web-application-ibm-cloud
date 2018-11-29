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
#
# Authors: Andrea Frittoli, Niklas Heidloff
##############################################################################

root_folder=$(cd $(dirname $0); pwd)

# SETUP logging (redirect stdout and stderr to a log file)
readonly LOG_FILE="${root_folder}/deploy.log"
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

function ibmcloud_login() {
  # Skip version check updates
  ibmcloud config --check-version=false

  # Obtain the API endpoint from BLUEMIX_REGION and set it as default
  _out Logging in to IBM cloud
  ibmcloud api --unset
  IBMCLOUD_API_ENDPOINT=$(ibmcloud api | awk '/'$BLUEMIX_REGION'/{ print $2 }')
  ibmcloud api $IBMCLOUD_API_ENDPOINT

  # Login to ibmcloud, generate .wskprops
  ibmcloud login --apikey $IBMCLOUD_API_KEY -a $IBMCLOUD_API_ENDPOINT
  ibmcloud target -o "$IBMCLOUD_ORG" -s "$IBMCLOUD_SPACE"
  ibmcloud fn api list > /dev/null

  # Show the result of login to stdout
  ibmcloud target
}

function setup() {
  _out Creating App ID service instance
  ibmcloud resource service-instance-create app-id-serverless appid lite $BLUEMIX_REGION
  ibmcloud resource service-alias-create app-id-serverless --instance-name app-id-serverless

  _out Creating App ID credentials
  ibmcloud resource service-key-create app-id-serverless-credentials Reader --instance-name app-id-serverless
  ibmcloud resource service-key app-id-serverless-credentials
  APPID_MGMTURL=$(ibmcloud resource service-key app-id-serverless-credentials | awk '/managementUrl/{ print $2 }')
  APPID_TENANTID=$(ibmcloud resource service-key app-id-serverless-credentials | awk '/tenantId/{ print $2 }')
  _out APPID_TENANTID: $APPID_TENANTID
  printf "\nAPPID_TENANTID=$APPID_TENANTID" >> $ENV_FILE
  APPID_OAUTHURL=$(ibmcloud resource service-key app-id-serverless-credentials | awk '/oauthServerUrl/{ print $2 }')
  _out APPID_OAUTHURL: $APPID_OAUTHURL
  printf "\nAPPID_OAUTHURL=$APPID_OAUTHURL" >> $ENV_FILE
  APPID_CLIENTID=$(ibmcloud resource service-key app-id-serverless-credentials | awk '/clientId/{ print $2 }')
  _out APPID_CLIENTID: $APPID_CLIENTID
  printf "\nAPPID_CLIENTID=$APPID_CLIENTID" >> $ENV_FILE
  APPID_SECRET=$(ibmcloud resource service-key app-id-serverless-credentials | awk '/secret/{ print $2 }')
  _out APPID_SECRET: $APPID_SECRET
  printf "\nAPPID_SECRET=$APPID_SECRET" >> $ENV_FILE
  
  DEMO_EMAIL=user@demo.email
  DEMO_PASSWORD=verysecret
  _out Creating cloud directory test user: $DEMO_EMAIL, $DEMO_PASSWORD
  IBMCLOUD_BEARER_TOKEN=$(ibmcloud iam oauth-tokens | awk '/IAM/{ print $3" "$4 }')
  curl -s -X POST \
    --header 'Content-Type: application/json' \
    --header 'Accept: application/json' \
    --header "Authorization: $IBMCLOUD_BEARER_TOKEN" \
    -d '{"emails": [
            {"value": "'$DEMO_EMAIL'","primary": true}
          ],
         "userName": "'$DEMO_EMAIL'",
         "password": "'$DEMO_PASSWORD'"
        }' \
    "${APPID_MGMTURL}/cloud_directory/Users"
}


# Main script starts here
check_tools

# Load configuration variables
if [ ! -f $ENV_FILE ]; then
  _err "Before deploying, copy template.local.env into local.env and fill in environment specific values."
  exit 1
fi
source $ENV_FILE
export TF_VAR_ibm_bx_api_key=$IBMCLOUD_API_KEY
export TF_VAR_ibm_cf_org=$IBMCLOUD_ORG
export TF_VAR_ibm_cf_space=$IBMCLOUD_SPACE
export IBMCLOUD_API_KEY BLUEMIX_REGION
export TF_VAR_appid_plan=${IBMCLOUD_APPID_PLAN:-"lite"}
export TF_VAR_cloudant_plan=${IBMCLOUD_CLOUDANT_PLAN:-"Lite"}

_out Full install output in $LOG_FILE
ibmcloud_login
setup $@
esac