//------------------------------------------------------------------------------
// Copyright IBM Corp. 2017, 2018
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Original author: Nick Mitchell https://github.com/starpit/openwhisk-oauth/blob/master/actions/login/login.js
//------------------------------------------------------------------------------

var request = require('request');

function main(params) {

	return new Promise((resolve, reject) => {
		const code = params.code;

		let form = {
			client_id: params.config.client_id,
			client_secret: params.config.client_secret,
			code: code,
			grant_type: 'authorization_code'
		};

		let auth = new Buffer(form.client_id + ':' + form.client_secret).toString('base64');
		let options = {
			url: params.config.oauth_url + '/token',
			method: 'POST',
			headers: {
				'Authorization': 'Basic ' + auth,
				'Content-Type': 'application/json',
				'Accept': 'application/json'
			}
		};
		options.form = form;

		request(options, function (err, response, body) {
			if (err || response.statusCode >= 400) {
				const errorMessage = err || { statusCode: response.statusCode, body: body }
				console.error(JSON.stringify(errorMessage));
				reject(errorMessage);

			} else {
				if (typeof body == 'string') {
					body = JSON.parse(body);
				}

				request({
					url: params.config.oauth_url + '/userinfo',
					method: 'GET',
					headers: {
						'Accept': 'application/json',
						'Authorization': 'Bearer ' + body.access_token,
						'User-Agent': 'OpenWhisk'
					}
				}, function (err2, response2, body2) {
					console.log(body2)
					if (err2 || response2.statusCode >= 400) {
						const errorMessage = err2 || { statusCode: response2.statusCode, body: body2 }
						console.error(JSON.stringify(errorMessage));
						reject(errorMessage);

					} else {
						if (typeof body2 == 'string') {
							body2 = JSON.parse(body2);
						}

						resolve({						
							access_token: body.access_token,
							refresh_token: body.refresh_token,
							id: body2['email'],							
							access_token_body: body,
							name: body2.name,
							given_name: body2.given_name,
							family_name: body2.given_name
						});
					}
				});
			}
		});
	});
}

