#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./build/schema/**/*.schema.json"

# Debug listing
ls -R schema

# What we do
echo "Creating typescript declarations by JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Create directory first
mkdir -p ./build/ts

# Create an index.ts file
touch ./build/ts/index.ts

# Add document header to file
echo -e "$(cat ./.circleci/doc-header-unlicensed.tpl)\n$(cat ./build/ts/index.ts)" > ./build/ts/index.ts

# Do it
shopt -s globstar
for file in ${PATH_SOURCE_FILES}; do
  # New filename and path for dereferenced schema
  OUTPUTFILENAME="`basename $file`"
  TSMODELNAME=${OUTPUTFILENAME/.schema.json/}
  OUTPUTFILENAME=build/ts/${OUTPUTFILENAME/.schema.json/.ts}
  mkdir -p "`dirname $OUTPUTFILENAME`/"
  ./node_modules/.bin/quicktype --src-lang schema --lang ts --acronym-style pascal ${file} -o ${OUTPUTFILENAME}

  # Add document header to file
  echo -e "$(cat .circleci/doc-header-unlicensed.tpl)\n$(cat ${OUTPUTFILENAME})" > ${OUTPUTFILENAME}

  # Append ts file created to index
  PASCALCONVERTNAME=$(echo "${TSMODELNAME}" | sed -e "s/\b\(.\)/\u\1/")
  echo "export { ${PASCALCONVERTNAME}, Convert as ${PASCALCONVERTNAME}Convert } from './${TSMODELNAME}';" >> ./build/ts/index.ts

  if [ "$?" = "1" ]; then
    echo "Error while creating typescript declarations!" 1>&2
	  # exit with error - important for ci system
	  exit 1
  fi
done

# Debug listing
ls -R build/ts

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while creating typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
