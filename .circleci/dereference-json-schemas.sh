#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="schema/**/*.schema.json"

# What we do
echo "Dereferencing JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME=${file/schema\//build/schema\/}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  # ./node_modules/.bin/json-dereference -s $file -o $OUTPUTFILENAME
  cp $file $OUTPUTFILENAME
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while dereferencing!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
