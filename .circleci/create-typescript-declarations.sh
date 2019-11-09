#!/bin/bash

TARGETPATH=".tmp/schema/**/*.schema.json"

echo "Creating typescript declarations from JSON-Schemas from \"${TARGETPATH}\""
shopt -s globstar
for file in ${TARGETPATH}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME=${file/.tmp\/schema\//.tmp/ts\/}
  OUTPUTFILENAME=${OUTPUTFILENAME/.schema.json/.ts}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/quicktype --src-lang schema --lang ts --acronym-style pascal ${file} -o ${OUTPUTFILENAME}

  DTSFILENAME="`basename $OUTPUTFILENAME`"
  DTSFILENAME=${DTSFILENAME/.ts/}
  DTSFILENAME=.tmp/types/${DTSFILENAME}/${DTSFILENAME}.d.ts
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
