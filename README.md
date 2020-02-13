# wunderbon | smart receipts

## Documentation JSON-Schemas

This document links to documentation for project **wunderbon** `JSON-Schemas`.

## Classification

`Unrestricted`

![Unrestricted](docs/unrestricted.png){ width="128px" }

---

![Logo of data-structure-models](https://bitbucket.org/wunderbon/json-schemas/raw/master/docs/logo-large.png)

wunderbon **JSON-schemas** representing models of our provided `REST APIs`.

[![wunderbon Projects](https://img.shields.io/badge/wunderbon-Projects-green.svg?style=flat)](https://wunderbon.io/) [![wunderbon Projects](https://img.shields.io/badge/license-MIT-green?style=flat)](https://wunderbon.io/) [![wunderbon Projects](https://img.shields.io/badge/wunderbon-Open_Standard-orange?style=flat)](https://wunderbon.io/) ![CircleCI](https://img.shields.io/circleci/build/bitbucket/wunderbon/json-schemas)

---

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Install](#install)
- [Run](#run)
- [Philosophy](#philosophy)
- [Versioning](#versioning)
- [Roadmap](#roadmap)
- [Security-Issues](#security-issues)
- [License »](LICENSE)

---

## Features

 - Easy browsable `JSON-schemas` with implemented webserver (Node.JS)
 - Blueprints of data I/O for our REST APIs (standard >= [JSON Schema Draft 7](http://json-schema.org/ "JSON Schema Draft")).
 - Clean & well documented

---

## Requirements

 - `Node.js >= 9.3.0` *
 - `npm >= 5.6.0`

---

## Install
Extract or clone the repository to a directory of your choice and run the following command:

`npm install`

---

## Run
To start the server you just need to the following command:

`npm start`

After starting the server you will see a message like `@wunderbon/json-schemas server listening on port 8080 (HTTP) ...` in the console telling you that the server is listening for connections on port *8080* or the port you have configured.

**Warning!**
If you are already running a service on port *8080* you will need to define a `ENV` variable with name `WUNDERBON_JSON_SCHEMAS_PORT` and set its value to the port you will use for this service instead (e.g. *WUNDERBON_JSON_SCHEMAS_PORT=8181*).

---

## Philosophy

A lot of ♥ for code, documentation & quality. Try it, run it ... ♥ it ;)

---

## Versioning

For a consistent versioning we decided to make use of `Semantic Versioning 2.0.0` http://semver.org. Its easy to understand, very common and known from many other software projects.

---

## Roadmap
- [x] n.a.

---

## Security Issues

If you encounter a (potential) security issue don't hesitate to get in contact with us `security@wunderbon.io` before releasing it to the public. So i get a chance to prepare and release an update before the issue is getting shared. We will honor your work with an Amazon voucher :) - Thank you!

---

###### Copyright
<div>Icons made by <a href="https://www.flaticon.com/authors/chanut" title="Chanut">Chanut</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
