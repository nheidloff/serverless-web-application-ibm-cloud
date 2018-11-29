CONFIG=`cat config.json`

ibmcloud wsk action update serverless-web-app-generic/login.js login.js --kind nodejs:8 -p config "${CONFIG}"

ibmcloud wsk action update serverless-web-app-generic/redirect redirect.js --kind nodejs:8 -a web-export true -p config "${CONFIG}"

ibmcloud wsk action update --sequence serverless-web-app-generic/login-and-redirect serverless-web-app-generic/login.js,serverless-web-app-generic/redirect -a web-export true 
