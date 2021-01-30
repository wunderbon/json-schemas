#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./build/schema/**/*.schema.json"

# What we do
echo "Creating typescript declarations from JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Create directory first
mkdir -p ./build/build/ts

# One call due to namespace trouble on single file conversion
quicktype --src-lang schema --lang ts --acronym-style pascal --src ./build/schema --out ./build/build/ts/index.ts

# Add document header to file
echo -e "$(cat ./build/.circleci/doc-header.tpl)\n\n$(cat ./build/build/ts/index.ts)" > ./build/build/ts/index.ts

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while creating typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
