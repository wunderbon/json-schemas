
![Logo of data-structure-models](https://bitbucket.org/wunderbon/json-schemas/raw/master/docs/logo-large.png)

wunderbon **JSON-schemas** representing models of our provided `REST APIs`.

[![wunderbon Projects](https://img.shields.io/badge/wunderbon-Projects-green.svg?style=flat)](https://wunderbon.io/)

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [.env](#.env)
- [Development](#development)
- [Install](#install)
- [Run](#run)
- [Philosophy](#philosophy)
- [Versioning](#versioning)
- [Roadmap](#roadmap)
- [Security-Issues](#security-issues)
- [License »](LICENSE)


## Features

 - Browsable `JSON-schemes`
 - Blueprints of data I/O for our REST APIs (standard >= [JSON Schema Draft 5](http://json-schema.org/ "JSON Schema Draft")).
 - Can easily be used as data in [SWAGGER generated documentation of an API](https://swagger.io/docs/specification/data-models/keywords/ "SWAGGER support for JSON Schema").
 - Easy browsable with implemented webserver (Node.JS)
 - Clean & well documented


## Requirements

 - `Node.js >= 9.3.0` *
 - `npm >= 5.6.0`


## Install
Extract or clone the repository to a directory of your choice and run the following command:

`npm install`

## Run
To start the server you just need to the following command:

`npm start`

After starting the server you will see a message like `@wunderbon/data-structure-models server listening on port 8080 (HTTP) ...` in the console telling you that the server is listening for connections on port *8080* or the port you have configured.

**Warning!**
If you are already running a service on port *8080* you will need to define a `ENV` variable with name `WUNDERBON_DATA_STRUCTURE_MODELS_PORT` and set its value to the port you will use for this service instead (e.g. *WUNDERBON_DATA_STRUCTURE_MODELS_PORT=8181*).


## Create a new Schema

We assume you are about to create or already created a new schema which you would like to add.

Add the schema file with extension `.schema.json` (this is important for filter!) to its corresponding directory right under `./schema` (e.g. *./schema/receipt/receipt.schema.json*). After adding the file you are able to browse and view it in the web view - instantly ofter a reload in your browser (see [Run](#run)).

**Important!**
When adding a new schema to the collection you MUST provide a valid JSON file (containing valid data) as example as well!


## Read an existing Schema

All files under `./schema` are browsable in the web view after running the server (see [Run](#run)).


## Update an existing Schema

If you have updated a schema you will just need to reload (Strg + F5) the view in your browser to see the results.


## Philosophy

A lot of ♥ for code, documentation & quality. Try it, run it ... ♥ it ;)


## Versioning

For a consistent versioning we decided to make use of `Semantic Versioning 2.0.0` http://semver.org. Its easy to understand, very common and known from many other software projects.


## Roadmap
- [x] n.a.


## Security Issues

If you encounter a (potential) security issue don't hesitate to get in contact with us `security@wunderbon.io` before releasing it to the public. So i get a chance to prepare and release an update before the issue is getting shared. We will honor your work with an Amazon voucher :) - Thank you!


###### Copyright
<div>Icons made by <a href="https://www.flaticon.com/authors/chanut" title="Chanut">Chanut</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>

