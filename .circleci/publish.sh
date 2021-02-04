#!/bin/bash

# Publishing to NPM
echo "1) to NPM registry ..."
npm publish --access public

# Mirroring active repository from Bitbucket to GitHub
echo "2) to GitHub mirror ..."
git fetch --prune
git push --prune https://wunderbon:${GITHUB_TOKEN}@github.com/wunderbon/json-schemas.git +refs/remotes/origin/*:refs/heads/* +refs/tags/*:refs/tags/* 1>&2

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while publishing JSON Schemas!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
