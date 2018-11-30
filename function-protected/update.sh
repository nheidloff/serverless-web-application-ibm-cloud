CONFIG=`cat config.json`

ibmcloud wsk action update serverless-web-app-sample/function-protected function-protected.js --kind nodejs:8 -p config "${CONFIG}"