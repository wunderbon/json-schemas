#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="build/schema/**/*.schema.json"

# What we do
echo "Testing Data against JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  DATAFILE=${file/build\/schema\//data\/}
  DATAFILE=${DATAFILE/schema.json/json}

  if [ -f "$DATAFILE" ]; then
    echo -e "\e[0mValidating: \e[5m$file\e[0m"
    ./node_modules/.bin/ajv validate -s $file -d $DATAFILE 1>&2

    if [ "$?" = "1" ]; then
      # exit with error - important for ci system
      echo "Error while validating!" 1>&2
      exit 1
    fi

  else
    echo -e "\e[0m\e[31mERROR: Required data file \"$DATAFILE\" does not exist!\e[0m"
    exit 1
  fi
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while validating!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
