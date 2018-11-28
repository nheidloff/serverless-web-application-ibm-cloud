# Serverless Web Applications on the IBM Cloud


Architecture:

![alt text](documentation/serverless-web-app.png "architecture diagram")



## Included components

* [IBM Cloud Functions](https://console.ng.bluemix.net/openwhisk) (powered by Apache OpenWhisk)
* [IBM Cloud Functions APIs](https://console.bluemix.net/openwhisk/apimanagement) (powered by Apache OpenWhisk)
* [IBM Cloudant](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db)
* [IBM App ID](https://console.bluemix.net/catalog/services/appid)

## Setup

**Prerequisites**

Make sure you have the following tools installed:

* [Node](https://nodejs.org/en/download/)
* [Docker](https://docs.docker.com/engine/installation/)
* [git](https://git-scm.com/downloads)
* [IBM Cloud account](https://ibm.biz/nheidloff)
* [ibmcloud CLI](https://console.bluemix.net/docs/cli/index.html)


**Custom Domains**

see [documentation](https://console.bluemix.net/docs/api-management/manage_apis.html#custom_domains)

**Setup App Id**

```
$ ibmcloud cf services
$ ibmcloud resource service-instances
$ ibmcloud resource service-alias-create appid-webapp --instance-name appid-webapp
```






to be continued

