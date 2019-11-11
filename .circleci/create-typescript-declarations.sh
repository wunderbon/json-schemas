#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES=".tmp/schema/**/*.schema.json"

# What we do
echo "Creating typescript declarations from JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME="`basename $file`"
  OUTPUTFILENAME=.tmp/ts/${OUTPUTFILENAME/.schema.json/.ts}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/quicktype --src-lang schema --lang ts --acronym-style pascal ${file} -o ${OUTPUTFILENAME}

  DTSFILENAME="`basename $OUTPUTFILENAME`"
  DTSFILENAME=${DTSFILENAME/.ts/}
  DTSFILENAME=.tmp/ts/${DTSFILENAME}.d.ts
  mkdir -p "`dirname $DTSFILENAME`/"
  ./node_modules/.bin/dts-bundle-generator -o ${DTSFILENAME} ${OUTPUTFILENAME}

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
