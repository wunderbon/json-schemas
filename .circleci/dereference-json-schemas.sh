#!/bin/bash

TARGETPATH="./schema/**/*.schema.json"

echo "Dereferencing JSON-Schemas from \"${TARGETPATH}\""
shopt -s globstar
for file in ${TARGETPATH}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME=${file/schema\//.tmp/schema\/}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/json-dereference -s $file -o $OUTPUTFILENAME
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while dereferencing!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
