#!/bin/bash

# Environment configuration
# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)
TARGETPATH="/tmp"
# We work primarly on master here
GIT_REPOSITORY_BRANCH_MASTER="master"
GIT_REPOSITORY_BRANCH_DEVELOP="develop"

# What we do
echo "Publishing data models typescript ... "

# Setup git
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "CircleCI"
git config --global pull.ff only

# Do it
echo "1) to Bitbucket repository ..."

# Checkout new branch and switch to it (name is branch name from this repository)
git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript checkout ${GIT_REPOSITORY_BRANCH_MASTER}

# Remove all existing files (soft reset)
rm -rf ${TARGETPATH}/data-models-typescript/src/*

# Copy all typescript declaration files from build to target repository
cp -R ./build/ts/* ${TARGETPATH}/data-models-typescript/src || exit 0;

# Retrieve tag from package.json
PACKAGE_VERSION=$(cat ${TARGETPATH}/data-models-typescript/package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

sed -i "s/${PACKAGE_VERSION}/${CIRCLE_TAG}/g" ${TARGETPATH}/data-models-typescript/package.json

# Create a fresh shrinkwrap with new release version
echo "Create new NPM shrinkwrap ..."
npm shrinkwrap --prefix ${TARGETPATH}/data-models-typescript

# Add credentials to remote
git --git-dir ${TARGETPATH}/data-models-typescript/.git remote set-url origin https://${GIT_REPOSITORY_USERNAME}:${GIT_REPOSITORY_WRITE_ACCESS_KEY}@bitbucket.org/wunderbon/data-models-typescript.git

# Set upstream link
git --git-dir ${TARGETPATH}/data-models-typescript/.git branch -u origin/${GIT_REPOSITORY_BRANCH_MASTER}

# Add them
git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript add --all

# Commit changes
git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript commit -m "CI Build #${CIRCLE_BUILD_NUM} @see ${CIRCLE_BUILD_URL}"

# Local update
git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript fetch && \
 git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript pull --rebase

git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript status .

# Tag this version with tag from current build
git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript tag ${CIRCLE_TAG}
# git --git-dir ${TARGETPATH}/data-models-typescript/.git --work-tree=${TARGETPATH}/data-models-typescript tag -l

# Push them to repository
git --git-dir ${TARGETPATH}/data-models-typescript/.git push -u origin ${GIT_REPOSITORY_BRANCH_MASTER}
git --git-dir ${TARGETPATH}/data-models-typescript/.git push origin --tags

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while publishing data model typescript!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
