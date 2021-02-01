#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="build/schema/**/*.schema.json"

# What we do
echo "Updating version of JSON-Schemas to \"${CIRCLE_TAG}\""

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  # Retrieve tag from package.json
  VERSION=$(cat ${file} \
    | grep version \
    | head -1 \
    | awk -F: '{ print $2 }' \
    | sed 's/[",]//g' \
    | tr -d '[[:space:]]')

  # Update version field of schema
  echo "Replacing version found: \"${VERSION}\" with new version: \"${CIRCLE_TAG}\""
  sed -i "s/${VERSION}/${CIRCLE_TAG}/g" ${file}

  # Update URL to match concrete version on later resolving
  sed -i "s/json-schemas\/raw\/master\//json-schemas\/raw\/${CIRCLE_TAG}\//g" ${file}

  if [ "$?" = "1" ]; then
    echo "Error while creating typescript declarations!" 1>&2
	  # exit with error - important for ci system
	  exit 1
  fi
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while creating typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
