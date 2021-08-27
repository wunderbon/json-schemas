#!/bin/bash

# Test code
npm run-script test || exit 1

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error testing software!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
