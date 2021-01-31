#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./schema/**/*.schema.json"

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

  # sed -i "s/${VERSION}/${CIRCLE_TAG}/g" ${file}
  echo "Version found: \"${VERSION}\""

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
