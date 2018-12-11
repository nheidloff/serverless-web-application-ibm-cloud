# Serverless Web Applications on the IBM Cloud

This repo explains how to build and run serverless web applications on the IBM Cloud. Business logic is implemented with IBM Cloud Functions, static web resources are stored in IBM Object Storage, authentication is handled via IBM App ID and data is stored in the managed NoSQL database IBM Cloudant.

The project contains a sample web application built with Angular which requires user authentication to access data in Cloudant. Watch the 10 seconds [video](documentation/serverless-web-app.mp4) for a short demo.

While the Angular application and the protected API are samples, the other components in this repo are generic and can be reused for other web applications, for example the login functionality and the setup of App ID, Cloudant and Object Storage.

This diagram describes the architecture with the main components:

![alt text](documentation/serverless-web-app.png "architecture diagram")

Check out my blogs and screenshots for more details:

* [Developing Serverless Web Applications on the IBM Cloud](http://heidloff.net/article/serverless-web-applications-ibm)
* [Hosting Resources for Web Applications on the IBM Cloud](http://heidloff.net/article/hosting-static-web-resources-ibm-cloud)
* [Authentication of Users in Serverless Applications](http://heidloff.net/article/user-authentication-serverless-openwhisk)
* Authorization of Users in Serverless Applications (to be done)
* [Screenshots](documentation/serverless-web-apps.pdf)

Find out more about the main components:

* [IBM Cloud Functions](https://cloud.ibm.com/openwhisk) powered by Apache OpenWhisk
* [IBM Cloud Functions API Management](https://cloud.ibm.com/openwhisk/apimanagement)
* [IBM Cloud Object Storage](https://cloud.ibm.com/catalog/services/cloud-object-storage)
* [IBM App ID](https://cloud.ibm.com/catalog/services/app-id)
* [IBM Cloudant](https://cloud.ibm.com/catalog/services/cloudant)

## Outline

* [Prerequisites](#prerequisites)
* [Local Environment Setup](#local-environment-setup)
* [App ID Setup](#app-id-setup)
* [Cloudant Setup](#cloudant-setup)
* [Cloud Functions Setup for Login](#cloud-functions-setup-for-login)
* [Cloud Functions Setup for protected API](#cloud-functions-setup-for-protected-api)
* [Setup of local Web Application](#setup-of-local-web-application)
* [Cloud Object Storage Setup](#cloud-object-storage-setup)
* [Cloud Functions Setup for HTML Function](#cloud-functions-setup-for-html-function)
* [Custom Domain Setup](#custom-domain-setup) (optional)

## Prerequisites

Create an IBM Cloud lite account (free, no credit card required):

* [IBM Cloud account](https://ibm.biz/nheidloff)

Make sure you have the following tools installed:

* [git](https://git-scm.com/downloads)
* [ibmcloud CLI](https://console.bluemix.net/docs/cli/index.html)
* [node](https://nodejs.org/en/download/)
* [curl](https://curl.haxx.se/download.html)
* [ng](https://github.com/angular/angular-cli/wiki) (only needed for the Angular sample application)

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
$ cat serverless-web-application.json
$ cp template.local.env local.env
```

In [local.env](local.env) define 'IBMCLOUD_API_KEY', 'IBMCLOUD_ORG', 'IBMCLOUD_SPACE' and 'BLUEMIX_REGION' to match the apikey in [serverless-web-application.json](serverless-web-application.json) and the org, space and region name that you're using (see the outputs in your terminal when following the steps above).

## App ID Setup

[App ID](https://console.bluemix.net/catalog/services/appid) is used to authenticate users. 

**Create new App ID service instance:**

Run the following command to create these artifacts:

* App ID service instance 'app-id-serverless'
* App ID Cloud Foundry alias 'app-id-serverless'
* App ID credentials
* App ID test user 'user@demo.email, verysecret'

```
$ scripts/setup-app-id.sh
```

**Reuse an existing App ID service instance:**

The IBM Cloud lite plan only allows one App ID instance in your organization. If you have an App ID instance, you can use it rather than creating a new one. 

In this case copy 'APPID_TENANTID', 'APPID_OAUTHURL', 'APPID_CLIENTID' and 'APPID_SECRET' from your service credentials and paste them in [local.env](local.env).

## Cloudant Setup

[IBM Cloudant](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db) is used to store data used by the web application.

**Create new Cloudant service instance:**

Run the following command to create these artifacts:

* Cloudant service instance 'cloudant-serverless'
* Cloudant database 'serverless'
* Cloudant documents and an index

```
$ scripts/setup-cloudant.sh
```

**Reuse an existing Cloudant service instance:**

The IBM Cloud lite plan only allows one Cloudant instance in your organization. If you have a Cloudant instance, you can use it rather than creating a new one. 

In this case copy 'CLOUDANT_USERNAME' and 'CLOUDANT_PASSWORD' from your service credentials and paste them in [local.env](local.env).

Additionally run this command to create the sample database and documents:

```
$ scripts/create-cloudant-db.sh
```

## Cloud Functions Setup for Login

Run the following command to create these artifacts:

* Cloud Functions sequence 'serverless-web-app-generic/login-and-redirect'
* Cloud Functions function 'serverless-web-app-generic/login'
* Cloud Functions function 'serverless-web-app-generic/redirect'
* Cloud Function API 'login'
* Redirect URL in App ID

```
$ scripts/setup-login-function.sh
```

## Cloud Functions Setup for protected API

Run the following command to create these artifacts:

* Cloud Functions function 'serverless-web-app-sample/function-protected'
* Cloud Function API 'function-protected'

```
$ scripts/setup-protected-function.sh
```

## Setup of local Web Application

To run the Angular web application locally, run these commands:

```
$ scripts/setup-local-webapp.sh
$ ng serve
```

Open http://localhost:4200 in your browser.

## Cloud Object Storage Setup

[IBM Cloud Object Storage](https://console.bluemix.net/catalog/services/cloud-object-storage) is used to store the static resources of the web application.

**Create new Object Storage service instance:**

Run the following command to create these artifacts:

* Object Storage instance 'object-storage-serverless'
* Bucket 'serverless-web-[your-app-id-tenant-id]'
* Built Angular application
* Angular files stored in Object Storage

```
$ scripts/setup-object-storage.sh
```

To try the web application, open the URL that you get in the terminal.

**Reuse an existing Object Storage service instance:**

The IBM Cloud lite plan only allows one Object Storage instance in your organization. If you have an Object Storage instance, you can use it rather than creating a new one. 

Define your service instance name in [scripts/upload-files-to-object-storage.sh](scripts/upload-files-to-object-storage.sh) (line 74) and run this command to create the bucket and to upload the files:

```
$ scripts/upload-files-to-object-storage.sh
```

## Cloud Functions Setup for HTML Function

Since Object Storage doesn't allow to pass in parameters to requested files (e.g. https://.../index.html?param=value) another function is deployed to host the index.html file of the single page web application. All other resources are stored in Object Storage.

To deploy the OpenWhisk function and the API, invoke the following command:

```
$ scripts/setup-html-function.sh
```

Open the web application with the URL that is printed in the output of the command.


## Custom Domain Setup

When following the steps above, the sample application can be invoked via URLs like https://s3.us-south.objectstorage.softlayer.net/serverless-web-65819d17-0d02-4219-af3a-9468870673cc/serverless/web. If you want to use your own domain, you need to do some additional setup.

Follow the instruction in the [documentation](https://console.bluemix.net/docs/api-management/manage_apis.html#custom_domains) or in this [blog](http://jamesthom.as/blog/2018/12/03/custom-domains-with-ibm-cloud-functions/) to set up custom domains for OpenWhisk functions.

Check out the [screenshots](documentation/) in the documentation folder for more details. Make sure to set the TXT and CNAME records in your DNS settings correctly, see this [example](documentation/dns-settings.png).

To deploy update the redirect URL, invoke the following command:

```
$ scripts/setup-domain.sh https://[yourdomain.com]
```

Open the web application via https://[yourdomain.com]/serverless/web.