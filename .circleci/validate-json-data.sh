#!/bin/bash

PATH="./.tmp/schema/**/*.schema.json"

echo "Validating Data against JSON-Schemas from \"${PATH}\""
shopt -s globstar
for file in ${PATH}; do
  DATAFILE=${file/.tmp\/schema\//data\/}
  DATAFILE=${DATAFILE/schema.json/json}

  if [ -f "$DATAFILE" ]; then
    echo -e "\e[0mValidating: \e[5m$file\e[0m"
    ./node_modules/.bin/ajv validate -s $file -d $DATAFILE
  else
    echo -e "\e[0m\e[31mERROR: Required data file \"$DATAFILE\" does not exist!\e[0m"
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
