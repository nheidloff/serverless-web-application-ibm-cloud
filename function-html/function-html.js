function main() {
        
    return { body: `
    
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>OpenwhiskAngular</title>
  <script>document.write('<base href="' + document.location + '" />');</script>

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>
<body>
  <app-root></app-root>
<script type="text/javascript" src="https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/inline.bundle.js"></script><script type="text/javascript" src="https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/polyfills.bundle.js"></script><script type="text/javascript" src="https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/styles.bundle.js"></script><script type="text/javascript" src="https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/vendor.bundle.js"></script><script type="text/javascript" src="https://s3.us-south.objectstorage.softlayer.net/serverless-webapp/main.bundle.js"></script></body>
</html>    
    
    `}
  }