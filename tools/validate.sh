#!/bin/bash

# Iterate all schema and validate against data (fake implementation)
for file in ./schema/**/*.schema.json; do
  DATAFILE=${file/schema\//data\/}
  DATAFILE=${DATAFILE/schema.json/json}

  if [ -f "$DATAFILE" ]; then
    echo -e "\e[0mValidating: \e[5m$file\e[0m"
    ./node_modules/.bin/validateJson -d "$DATAFILE" -s "$file"
  else
    echo -e "\e[0m\e[31mERROR: $DATAFILE does not exist!\e[0m"
  fi
done
