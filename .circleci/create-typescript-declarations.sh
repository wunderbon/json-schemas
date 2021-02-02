#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./build/schema/**/*.schema.json"

# What we do
echo "Creating typescript declarations by JSON-Schemas from \"${PATH_SOURCE_FILES}\""

# Create directory first
mkdir -p ./build/ts

# Create an index.ts file
touch ./build/ts/index.ts

# Add document header to file
echo -e "$(cat ./.circleci/doc-header-unlicensed.tpl)\n\n$(cat ./build/ts/index.ts)" > ./build/ts/index.ts

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

  # Check for export and if exist -> Append ts file created to index
  PASCALCONVERTNAME=$(echo "${TSMODELNAME}" | sed -e "s/\b\(.\)/\u\1/")

  # Check for import just contains Convert() (e.g. for direct referenced values)
  case `grep -R "import { Convert }" ${OUTPUTFILENAME} >/dev/null; echo $?` in
  0)
    # found
    echo "export { Convert as ${PASCALCONVERTNAME}Convert } from './${TSMODELNAME}';" >> ./build/ts/index.ts
    ;;
  1)
    # not found
    echo "export { ${PASCALCONVERTNAME}, Convert as ${PASCALCONVERTNAME}Convert } from './${TSMODELNAME}';" >> ./build/ts/index.ts
    ;;
  *)
    # code if an error occurred
    echo "Error on grep export for file \"${OUTPUTFILENAME}\""
    exit 1
    ;;
  esac

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
