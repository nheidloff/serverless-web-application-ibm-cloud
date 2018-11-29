# Serverless Web Applications on the IBM Cloud

This repo explains how to build serverless web applications in the IBM Cloud. Static web resources are stored in IBM Object Storage, business logic is implemented via IBM Cloud Functions, authentication is handled via IBM App ID and data is stored in the managed NoSQL database IBM Cloudant.

The project contains two parts:

1) Sample web application built with Angular which requires user authentication to access data in Cloudant
2) Instructions how to build your own serverless web applications with potentially other JavaScript frameworks and other databases

This diagram shows the architecture with the main components:

![alt text](documentation/serverless-web-app.png "architecture diagram")

Find out more about the main components:

* [IBM Cloud Functions](https://console.ng.bluemix.net/openwhisk) powered by Apache OpenWhisk
* [IBM Cloud Functions API Management](https://console.bluemix.net/openwhisk/apimanagement)
* [IBM Cloud Object Storage](https://console.bluemix.net/catalog/services/cloud-object-storage)
* [IBM App ID](https://console.bluemix.net/catalog/services/appid)
* [IBM Cloudant](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db)

## Outline

* [Prerequisites](#prerequisites)
* [Local Environment Setup](#local-environment-setup)
* [App ID Setup](#app-id-setup)
* [Cloudant Setup](#cloudant-setup)
* Cloud Functions Setup (to be done)
* Web Application Setup (to be done)
* Cloud Object Storage Setup (to be done)
* Custom Domain Setup (to be done)

## Prerequisites

Create an IBM Cloud lite account (free, no credit card required):

* [IBM Cloud account](https://ibm.biz/nheidloff)

Make sure you have the following tools installed:

* [git](https://git-scm.com/downloads)
* [ibmcloud CLI](https://console.bluemix.net/docs/cli/index.html)
* [Node](https://nodejs.org/en/download/)
* [curl](https://curl.haxx.se/download.html)

## Local Environment Setup

Invoke the following commands:

```
$ git clone https://github.com/nheidloff/serverless-web-application-ibm-cloud.git
$ cd serverless-web-application-ibm-cloud
$ ibmcloud login
$ ibmcloud target --cf
$ ibmcloud iam api-key-create serverless-web-application \
  -d "serverless-web-application" \
  --file serverless-web-application.json
$ cp template.local.env local.env
$ cat serverless-web-application.json
```

In [local.env](local.env) define 'IBMCLOUD_API_KEY', 'IBMCLOUD_ORG', 'IBMCLOUD_SPACE' and 'BLUEMIX_REGION' to match the apikey in [serverless-web-application.json](serverless-web-application.json) and the org, space and region name that you're using (see the outputs in your terminal when following the steps above).

## App ID Setup

[App ID](https://console.bluemix.net/catalog/services/appid) is used to authenticate users. 

**Create new App ID service instance:**

Run the following command to create these artifacts:

* App ID service instance
* App ID Cloud Foundry alias
* App ID credentials
* App ID test user (user@demo.email, verysecret)

```
$ scripts/setup-app-id.sh
```

Copy 'APPID_TENANTID', 'APPID_OAUTHURL', 'APPID_CLIENTID' and 'APPID_SECRET' in [local.env](local.env).

**Reuse an existing App ID service instance:**

The IBM Cloud lite plan only allows one App ID instance in your organization. If you have an App ID instance you can use it rather than creating a new one. In this case copy the credentials from your instance and paste them in [local.env](local.env).

Additionally create a CF alias so that App ID can be used by Cloud Functions API Management.

```
$ ibmcloud cf services
$ ibmcloud resource service-instances
$ ibmcloud resource service-alias-create app-id-serverless --instance-name appid-webapp
$ ibmcloud cf services
```

## Cloudant Setup




