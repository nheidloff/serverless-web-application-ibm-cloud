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
readonly LOG_FILE="${root_folder}/deploy-object-storage.log"
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
  _out Creating Object Storage service instance
  ibmcloud resource service-instance-create object-storage-serverless cloud-object-storage lite global
  
  _out Creating Object Storage credentials
  ibmcloud resource service-key-create object-storage-serverless-credentials Reader --instance-name object-storage-serverless
  
  _out Creating bucket
  IAM_TOKEN=$(ibmcloud iam oauth-tokens | awk '/IAM/{ print $4 }')
  
  COS_ID=$(ibmcloud resource service-instance object-storage-serverless | awk '/ID: /{ print $2 }')
  _out COS_ID: $COS_ID
  printf "\nCOS_ID=$COS_ID" >> $ENV_FILE

  BUCKET_NAME="serverless-web-application-${APPID_TENANTID}"
  _out BUCKET_NAME: $BUCKET_NAME
  printf "\nBUCKET_NAME=$BUCKET_NAME" >> $ENV_FILE
  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}" \
    -H "Authorization: Bearer ${IAM_TOKEN}" \
    -H "ibm-service-instance-id: ${COS_ID}"

  _out Building Angular application
  cd ${root_folder}/../angular
  ng build

  npm --prefix ${root_folder}/text-replace start ${root_folder}/text-replace ${root_folder}/../angular/dist/index.html src=\" src=\"/${BUCKET_NAME}/

  _out Uploading static web application resources
  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/index.html" \
    -H "x-amz-acl: public-read" \
    -H "Authorization: Bearer ${IAM_TOKEN}" \
    -H "Content-Type: text/html; charset=utf-8" \
    --upload-file "${root_folder}/../angular/dist/index.html"

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/inline.bundle.js" \
    -H "x-amz-acl: public-read" \
    -H "Authorization: Bearer ${IAM_TOKEN}" \
    -H "Content-Type: text/plain; charset=utf-8" \
    --upload-file "${root_folder}/../angular/dist/inline.bundle.js"

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/polyfills.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer ${IAM_TOKEN}" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "${root_folder}/../angular/dist/polyfills.bundle.js"

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/styles.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer ${IAM_TOKEN}" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "${root_folder}/../angular/dist/styles.bundle.js"

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/main.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer ${IAM_TOKEN}" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "${root_folder}/../angular/dist/main.bundle.js"

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/vendor.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer ${IAM_TOKEN}" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "${root_folder}/../angular/dist/vendor.bundle.js"

  _out Done! Open your app: https://s3.us-south.objectstorage.softlayer.net/${BUCKET_NAME}/index.html
}

# Main script starts here
check_tools

# Load configuration variables
if [ ! -f $ENV_FILE ]; then
  _err "Before deploying, copy template.local.env into local.env and fill in environment specific values."
  exit 1
fi
source $ENV_FILE
export IBMCLOUD_ORG IBMCLOUD_API_KEY BLUEMIX_REGION APPID_TENANTID APPID_OAUTHURL APPID_CLIENTID APPID_SECRET CLOUDANT_USERNAME CLOUDANT_PASSWORD IBMCLOUD_SPACE

_out Full install output in $LOG_FILE
ibmcloud_login
setup