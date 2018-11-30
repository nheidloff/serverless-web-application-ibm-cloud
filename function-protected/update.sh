CONFIG=`cat config.json`

ibmcloud wsk action update serverless-web-app-sample/function-protected function-protected.js --kind nodejs:8 -a web-export true -p config "${CONFIG}"
