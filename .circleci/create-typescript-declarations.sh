#!/bin/bash

# Environment configuration
PATH_SOURCE_FILES="./build/ts-schema/**/*.schema.json"

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
  COLLECTION=$(grep -Eo 'export (enum|interface|class) ([a-zA-Z0-9]+)' ${OUTPUTFILENAME})
  EXPORTLINE=""

  main()
  {
      while IFS=" " read -r _export _type _name; do
          if [ "${_name}" = "${PASCALCONVERTNAME}" ]; then
            EXPORTNAME="${_name}"
          else
            EXPORTNAME="${_name} as ${PASCALCONVERTNAME}${_name}"
          fi

          if [ -n "${EXPORTLINE}" ]; then
            EXPORTLINE="${EXPORTLINE}, ${EXPORTNAME}"
          else
            EXPORTLINE="${EXPORTNAME}"
          fi
      done <<-EOT
      ${COLLECTION}
EOT

      echo "export { ${EXPORTLINE} } from './${TSMODELNAME}';" >> ./build/ts/index.ts
  }

  main "${@}"

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
