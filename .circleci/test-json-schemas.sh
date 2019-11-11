#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES=".tmp/schema/**/*.schema.json"

echo "Testing dereferenced JSON-Schemas from \"${PATH_SOURCE_FILES}\""
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  OUTDIR="`dirname ${file}`/"
  FILENAME="`basename ${file}`"
  OUTFILE="${OUTDIR}${FILENAME/.schema.json/.validate.js}"
  ./node_modules/.bin/ajv compile -s ${file} -o ${OUTFILE}
done

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while validating!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
