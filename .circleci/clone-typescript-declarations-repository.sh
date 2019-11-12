#!/bin/bash

# Environment configuration
# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)
TARGETPATH="/tmp"
GIT_REPOSITORY_BRANCH="develop"
GIT_REPOSITORY_URL="https://${GIT_REPOSITORY_USERNAME}@bitbucket.org/wunderbon/typescript-declarations.git"

# What we do
echo "Cloning typescript declarations repository from \"${GIT_REPOSITORY_URL}\""

# Do it
git clone -b ${GIT_REPOSITORY_BRANCH} ${GIT_REPOSITORY_URL} ${TARGETPATH}/typescript-declarations 2>&1

# Local update
git --git-dir ${TARGETPATH}/typescript-declarations/.git fetch && \
git --git-dir ${TARGETPATH}/typescript-declarations/.git pull

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while cloning repository!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
