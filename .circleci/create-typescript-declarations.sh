#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="build/schema/**/*.schema.json"

# What we do
echo "Creating typescript declarations from JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME="`basename $file`"
  OUTPUTFILENAME=build/ts/${OUTPUTFILENAME/.schema.json/.ts}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/quicktype --src-lang schema --lang ts --acronym-style pascal ${file} -o ${OUTPUTFILENAME}

  # Add document header to file
  echo -e "$(cat .circleci/doc-header.tpl)\n\n$(cat ${OUTPUTFILENAME})" > ${OUTPUTFILENAME}

  # Generate .d.ts file
  DTSFILENAME="`basename $OUTPUTFILENAME`"
  DTSFILENAME=${DTSFILENAME/.ts/}
  DTSFILENAME=build/ts/${DTSFILENAME}.d.ts
  mkdir -p "`dirname $DTSFILENAME`/"
  ./node_modules/.bin/dts-bundle-generator -o ${DTSFILENAME} ${OUTPUTFILENAME}

  if [ "$?" = "1" ]; then
    echo "Error while creating typescript declarations!" 1>&2
	  # exit with error - important for ci system
	  exit 1
  fi
done

# Generate single (ALL) index.d.ts file from .d.ts files
./node_modules/.bin/npm-dts generate
ALLDTSFILENAME=./index.d.ts

if [ -f "${ALLDTSFILENAME}" ]; then
  echo -e "\e[0mMoving: \e[5m${ALLDTSFILENAME}\e[0m"

  PACKAGE_VERSION="{{VERSION}}"

  # Insert version tag
  sed -i "s/${PACKAGE_VERSION}/${CIRCLE_TAG}/g" .circleci/type-definitions.tpl

  # Add document header to file
  echo -e "$(cat .circleci/type-definitions.tpl)\n\n$(cat ${ALLDTSFILENAME})" > ${ALLDTSFILENAME}

  mv ${ALLDTSFILENAME} ./build/index.d.ts 1>&2

  if [ "$?" = "1" ]; then
    # exit with error - important for ci system
    echo "Error while moving index.dt.s file!" 1>&2
    exit 1
  fi
fi

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while creating typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
