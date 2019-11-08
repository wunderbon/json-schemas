#!/bin/bash

TARGETPATH="./.tmp/schema/**/*.schema.json"

echo "Faking data by collected JSON-Schemas from \"${TARGETPATH}\""
shopt -s globstar
for file in ${TARGETPATH}; do
  # New filename and path for faked data json file
  OUTPUTFILENAME=${file/schema\//data\/}
  OUTPUTFILENAME=${OUTPUTFILENAME/.schema.json/.json}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/generate-json $file $OUTPUTFILENAME
  # Check return value in loop for quick exit
  if [ "$?" = "1" ]; then
    # exit with success - important for ci system
    exit 1
  fi
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while dereferencing!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
