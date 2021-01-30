#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./build/schema/**/*.schema.json"

# What we do
echo "Creating typescript declarations from JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Create directory first
mkdir -p ./build/ts

# One call due to namespace trouble on single file conversion
./node_modules/.bin/quicktype --src-lang schema --lang ts --acronym-style pascal --src ./schema --out ./build/ts/index.ts

# Add document header to file
echo -e "$(cat ./.circleci/doc-header-unlicensed.tpl)\n\n$(cat ./build/ts/index.ts)" > ./build/ts/index.ts

# MIT License -> UNLICENSED
sed -i "s/${PACKAGE_VERSION}/${CIRCLE_TAG}/g" ${TARGETPATH}/data-models-typescript/package.json

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while creating typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
