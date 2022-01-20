#!/bin/bash

# Environment configuration
# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)
TARGETPATH="/tmp"
GIT_REPOSITORY_BRANCH="master"
GIT_REPOSITORY_URL="https://${GIT_REPOSITORY_USERNAME}:${GIT_REPOSITORY_WRITE_ACCESS_KEY}@bitbucket.org/wunderbon/data-models-typescript.git"

# What we do
echo "Cloning data-model-typescript repository from \"${GIT_REPOSITORY_URL}\""

# Do it
git clone -b ${GIT_REPOSITORY_BRANCH} ${GIT_REPOSITORY_URL} ${TARGETPATH}/data-models-typescript 2>&1

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while cloning repository!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
