#!/bin/bash

# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)

# What we do
echo "Publishing typescript declarations ... "

# Setup git
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "CircleCI"

# Do it
echo "... to Bitbucket repository ..."
# Checkout new branch and switch to it (name is branch name from this repository)
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations checkout -b ${CIRCLE_BRANCH}
# Remove all existing files (soft reset)
rm -rf /tmp/typescript-declarations/declarations/*
# Copy all typescript declaration files from build to target repository
cp -R build/ts/* /tmp/typescript-declarations/declarations || exit 0;
# Add them
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations add --all
# Add credentials to remote
git --git-dir /tmp/typescript-declarations/.git remote set-url origin https://${GIT_REPOSITORY_USERNAME}:${GIT_REPOSITORY_WRITE_ACCESS_KEY}@bitbucket.org/wunderbon/typescript-declarations.git
# Set upstream link
git --git-dir /tmp/typescript-declarations/.git branch -u origin/${CIRCLE_BRANCH}
# Local update
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations fetch && \
  git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations pull
# Commit changes
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations commit -m "CI Build #${CIRCLE_BUILD_NUM} @see ${CIRCLE_BUILD_URL}"
# Tag this version with tag from current build
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations tag ${CIRCLE_TAG}
git --git-dir /tmp/typescript-declarations/.git --work-tree=/tmp/typescript-declarations tag -l
# Push them to repository
git --git-dir /tmp/typescript-declarations/.git push -u origin ${CIRCLE_BRANCH}
git --git-dir /tmp/typescript-declarations/.git push origin --tags

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while publishing typescript declarations!" 1>&2
	# exit with error - important for ci system
	exit 1
fi

# B) PUBLISH TO DEFINITELY TYPED