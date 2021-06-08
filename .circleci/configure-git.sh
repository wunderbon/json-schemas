#!/bin/bash

if [ -z "${GIT_USER_EMAIL}" ]; then
	echo "Please set GIT_USER_EMAIL environment variable before running build!" 1>&2
	# exit with error - important for ci system
	exit 1
fi

git config --global core.fileMode false
git config --global user.email "${GIT_USER_EMAIL}"
git config --global user.name "CircleCI"
git config --global pull.ff only

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error configuring Git!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
