







## Setup of Angular Web Application Sample

**App ID Setup**





- new instance
- create user
- conf e.g no social
- get credentials
- copy credentials 1. web, 2. functions
- later: redirect










# to be done



**Custom Domains**

see [documentation](https://console.bluemix.net/docs/api-management/manage_apis.html#custom_domains)

**Setup App ID**

```
$ ibmcloud cf services
$ ibmcloud resource service-instances
$ ibmcloud resource service-alias-create appid-webapp --instance-name appid-webapp
```







prereqs

clone
login

1. existing sample

cloudant 
- new instance
- get credentials
- copy credentials for functions
- run setup, temp function

functions
- 2x init.sh 
- get protected api url 
- get login url 
- copy info in 1. web, 2. functions
- if custom: copy index.html, set base, 3third init.sh 

webapp
- npm install 
- ng build

cos 
- new instance
- create credentials
- create bucket via cli 
- upload files w public access 
- get base url







custom domain


2. own sample









https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42/authorization



ic resource service-instance-create  "Instance Name" \
    cloudantnosqldb Standard us-south \
    -p {"legacyCredentials": false}


>



"token": "https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42/token",
			"userinfo": "https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42/userinfo"


https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42/authorization?client_id=c842c99f-efb0-4855-b4f4-00fb6a0c3ad7&redirect_uri=http://heidloff.net&response_type=code

https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42/token





user@demo.email
  DEMO_PASSWORD=verysecret


ibmcloud resource service-alias-create appid-webapp --instance-name appid-webapp
ibmcloud resource service-instances
ibmcloud cf services


curl -X GET --header 'Accept: application/json'  'https://appid-oauth.ng.bluemix.net/oauth/v3/44d4f670-1e00-4ccb-98ad-3f03ba7e15a5/.well-known/openid-configuration'

https://www.heidloff.eu/web



{
  "apikey": "0l93RYEEWIL4G2l2Mcsywf2hGWXgAfCLRtZpX3sjq83X",
  "clientId": "c842c99f-efb0-4855-b4f4-00fb6a0c3ad7",
  "iam_apikey_description": "Auto generated apikey during resource-key operation for Instance - crn:v1:bluemix:public:appid:us-south:a/47b84451ab70b94737518f7640a9ee42:2bd10047-ab73-468b-8603-979c562abb42::",
  "iam_apikey_name": "auto-generated-apikey-c842c99f-efb0-4855-b4f4-00fb6a0c3ad7",
  "iam_role_crn": "crn:v1:bluemix:public:iam::::serviceRole:Writer",
  "iam_serviceid_crn": "crn:v1:bluemix:public:iam-identity::a/47b84451ab70b94737518f7640a9ee42::serviceid:ServiceId-bd2763d0-e4c2-4988-966c-fd5633c292bb",
  "managementUrl": "https://appid-management.ng.bluemix.net/management/v4/2bd10047-ab73-468b-8603-979c562abb42",
  "oauthServerUrl": "https://appid-oauth.ng.bluemix.net/oauth/v3/2bd10047-ab73-468b-8603-979c562abb42",
  "profilesUrl": "https://appid-profiles.ng.bluemix.net",
  "secret": "NmZjNjI0ODgtYWFhZC00NDhjLWEzOTYtMmM3MDEwMWM2MjI5",
  "tenantId": "2bd10047-ab73-468b-8603-979c562abb42",
  "version": 3
}


let url = this.authorizationUrl + "?scope=email";
      url = url + "&response_type=" + "code";
      url = url + "&client_id=" + this.clientId;
      url = url + "&access_type=" + "offline";
      url = url + "&redirect_uri=" + this.redirectUrl;








ibmcloud iam api-key-create severless-webapp --file apikey

export IBMAPIKEY=dvAHTKfrsvkzNUhubIE52ajn8Z131njBwT9PjyCQsTir

0TCjYU7lcpD52BUj5TE0kmnmVFSCE8rrSMCKgTZrCrGs





curl -X "POST" "https://iam.bluemix.net/oidc/token" \
 -H 'Accept: application/json' \
 -H 'Content-Type: application/x-www-form-urlencoded' \
 --data-urlencode "apikey=$IBMAPIKEY" \
 --data-urlencode "response_type=cloud_iam" \
 --data-urlencode "grant_type=urn:ibm:params:oauth:grant-type:apikey"

 export ACCESS_TOKEN=eyJraWQiOiIyMDE3MTAzMC0wMDowMDowMCIsImFsZyI6IlJTMjU2In0.eyJpYW1faWQiOiJJQk1pZC0wNjAwMDAwUkdIIiwiaWQiOiJJQk1pZC0wNjAwMDAwUkdIIiwicmVhbG1pZCI6IklCTWlkIiwiaWRlbnRpZmllciI6IjA2MDAwMDBSR0giLCJnaXZlbl9uYW1lIjoiTmlrbGFzIiwiZmFtaWx5X25hbWUiOiJIZWlkbG9mZiIsIm5hbWUiOiJOaWtsYXMgSGVpZGxvZmYiLCJlbWFpbCI6Im5pa2xhc19oZWlkbG9mZkBkZS5pYm0uY29tIiwic3ViIjoibmlrbGFzX2hlaWRsb2ZmQGRlLmlibS5jb20iLCJhY2NvdW50Ijp7ImJzcyI6ImE4ZWMwMjdmZjdjMzY1ZTM3ZDNlNzIwMGFhN2VkMGExIn0sImlhdCI6MTU0MzMyNzk0NywiZXhwIjoxNTQzMzMxNTQ3LCJpc3MiOiJodHRwczovL2lhbS5ibHVlbWl4Lm5ldC9pZGVudGl0eSIsImdyYW50X3R5cGUiOiJwYXNzd29yZCIsInNjb3BlIjoiaWJtIG9wZW5pZCIsImNsaWVudF9pZCI6ImJ4IiwiYWNyIjoxLCJhbXIiOlsicHdkIl19.L5ZMBDNyKuhQTPYlbI77iFNE6WaScEB7DsTS3u00XrJOJss392rx_RNN3zmE4LX7tem-PY2243yq0tCHB3Q95K3eb4lkvQuw73M20g-7u7PWBfhlJw4zzDtxTNUHXgAV4ypjSJfkwo8c4w6f-g_cS3AZ1TYGefIsi9hqIreJg2nEZsBTmsPyDuTUWtUio02HoBoaChHBpISNj9I6uIIi-vaM8n4sQk3NdnT2uC9_h6hmDMBbL0ryc6k3PiocP_U4nyAC056MKzeq3A6xeYxO4cnboCzovsg9R2VsiI-hSvDWAlMStg1r7GK-zmz19uGeMNr3tTwwRsEoVW8daSmqgg

 curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-web-app/inline.bundle.js?acl" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-web-app/HelloWorld.txt" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     -d "Hello World, this is a test."





ibmcloud iam oauth-tokens

bx resource service-instances

bx resource service-instance <instance-name>

  curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/<bucket-name>" \
       -H "Authorization: Bearer <token>" \
       -H "ibm-service-instance-id: <resource-instance-id>"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/test.txt" \
       -H "Authorization: Bearer $ACCESS_TOKEN" \
       -H "Content-Type: text/plain; charset=utf-8" \
       -d "This is a tiny object made of plain text."

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/HelloWorld.txt" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     -d "Hello World, this is a test."




curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/inline.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "inline.bundle.js"
     
curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/polyfills.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "polyfills.bundle.js"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/styles.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "styles.bundle.js"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/main.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "main.bundle.js"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/vendor.bundle.js" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "vendor.bundle.js"

curl -X "PUT" "https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/favicon.ico" \
     -H "x-amz-acl: public-read" \
     -H "Authorization: Bearer $ACCESS_TOKEN" \
     -H "Content-Type: text/plain; charset=utf-8" \
     --upload-file "favicon.ico"
