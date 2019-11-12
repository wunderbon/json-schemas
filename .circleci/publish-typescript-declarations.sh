#!/bin/bash

# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)

# What we do
echo "Publishing typescript declarations ... "

# Do it
echo "Creating Feature Branch ..."
# Change into (systems) temp directory
cd /tmp/typescript-declarations/declarations || exit 0; # Exit in case that directory switch fails
# Checkout new branch and switch to it (name is branch name from this repository)
git checkout -b ${CIRCLE_BRANCH}
# Remove all existing files (soft reset)
rm -rf /tmp/typescript-declarations/declarations/*
# Copy all typescript declaration files from build to target repository
cp -R ./build/ts/* /tmp/typescript-declarations/declarations
# Add them
git add --all
# Commit changes
git commit -m "CI Build #${CIRCLE_BUILD_NUM} @see ${CIRCLE_BUILD_URL}"
# Push them to repository
git push -u origin ${CIRCLE_BRANCH}

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while cloning repository!" 1>&2
	# exit with error - important for ci system
	exit 1
fi

# B) PUBLISH TO DEFINITELY TYPED
