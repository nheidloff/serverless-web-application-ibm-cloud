var Cloudant = require('@cloudant/cloudant');
require('dotenv').load();

var username = process.env.CLOUDANT_USERNAME;
var password = process.env.CLOUDANT_PASSWORD;

let cloudant = new Cloudant({ account: username, password: password, plugins: 'promises' });

cloudant.db.create('serverless').then(() => {
    let db = cloudant.use('serverless');

    var people = [
        { firstname: "Niklas", lastname: "Heidloff" },
        { firstname: "Thomas", lastname: "Suedbroecker" }
    ]

    db.bulk({ docs: people }, function (err) {
        if (err) {
            console.log(err);
            throw err;
        }
    });

    var people_indexer = function (doc) {
        if (doc.firstname && doc.lastname) {
            index('lastname', doc.lastname);
            index('firstname', doc.firstname);
        }
    }

    var ddoc = {
        _id: '_design/library',
        indexes: {
            people: {
                analyzer: { name: 'standard' },
                index: people_indexer
            }
        }
    };

    db.insert(ddoc, function (err, result) {
        if (err) {
            console.log(err);
            throw err;
        }
    });

}).catch((err) => {
    console.log(err);
});