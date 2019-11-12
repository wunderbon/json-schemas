#!/bin/bash

# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)

# What we do
echo "Publishing typescript declarations ... "

# Setup git
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "CircleCI"

# Do it
echo "... to Bitbucket repository ..."
# Change into (systems) temp directory
#cd /tmp/typescript-declarations/declarations || exit 0; # Exit in case that directory switch fails
# Checkout new branch and switch to it (name is branch name from this repository)
git --git-dir /tmp/typescript-declarations/.git checkout -b ${CIRCLE_BRANCH}
# Remove all existing files (soft reset)
rm -rf /tmp/typescript-declarations/declarations/*
# Copy all typescript declaration files from build to target repository
cp -R build/ts/* /tmp/typescript-declarations/declarations || exit 0;

ls -alR /tmp/typescript-declarations/declarations

# Add them
#git --git-dir /tmp/typescript-declarations/.git add --all
# Commit changes
#git --git-dir /tmp/typescript-declarations/.git commit -m "CI Build #${CIRCLE_BUILD_NUM} @see ${CIRCLE_BUILD_URL}"
# Add credentials to remote
#git --git-dir /tmp/typescript-declarations/.git remote set-url origin https://${GIT_REPOSITORY_USERNAME}:${GIT_REPOSITORY_WRITE_ACCESS_KEY}@bitbucket.org/wunderbon/typescript-declarations.git

#git --git-dir /tmp/typescript-declarations/.git branch -u origin/${CIRCLE_BRANCH}

# Local update
#echo FETCHING & PULLING
#git --git-dir /tmp/typescript-declarations/.git fetch && \
#  git --git-dir /tmp/typescript-declarations/.git pull

# Push them to repository
#echo PUSHING
#git --git-dir /tmp/typescript-declarations/.git push -u origin ${CIRCLE_BRANCH}

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
