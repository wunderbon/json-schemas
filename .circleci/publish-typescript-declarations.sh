#!/bin/bash

# Environment configuration
# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)
TARGETPATH="/tmp"
GIT_REPOSITORY_BRANCH="master"

# What we do
echo "Publishing typescript declarations ... "

# Setup git
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "CircleCI"

# Do it
echo "... to Bitbucket repository ..."

# Checkout new branch and switch to it (name is branch name from this repository)
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations checkout -b ${GIT_REPOSITORY_BRANCH}

# Remove all existing files (soft reset)
rm -rf ${TARGETPATH}/typescript-declarations/declarations/*

# Copy all typescript declaration files from build to target repository
cp -R build/ts/* ${TARGETPATH}/typescript-declarations/declarations || exit 0;

# Retrieve tag from package.json
PACKAGE_VERSION=$(cat ${TARGETPATH}/typescript-declarations/package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

sed -i "s/${PACKAGE_VERSION}/${CIRCLE_TAG}/g" ${TARGETPATH}/typescript-declarations/package.json

# Add them
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations add --all

# Add credentials to remote
git --git-dir ${TARGETPATH}/typescript-declarations/.git remote set-url origin https://${GIT_REPOSITORY_USERNAME}:${GIT_REPOSITORY_WRITE_ACCESS_KEY}@bitbucket.org/wunderbon/typescript-declarations.git

# Set upstream link
git --git-dir ${TARGETPATH}/typescript-declarations/.git branch -u origin/${GIT_REPOSITORY_BRANCH}

# Local update
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations fetch && \
 git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations pull

# Commit changes
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations commit -m "CI Build #${CIRCLE_BUILD_NUM} @see ${CIRCLE_BUILD_URL}"

# Tag this version with tag from current build
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations tag ${CIRCLE_TAG}
git --git-dir ${TARGETPATH}/typescript-declarations/.git --work-tree=${TARGETPATH}/typescript-declarations tag -l

# Push them to repository
git --git-dir ${TARGETPATH}/typescript-declarations/.git push -u origin ${GIT_REPOSITORY_BRANCH}
git --git-dir ${TARGETPATH}/typescript-declarations/.git push origin --tags

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while publishing typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi

# B) @todo: PUBLISH TO DEFINITELY TYPED
