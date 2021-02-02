#!/bin/bash

# Install tools
apk update && \
  apk add --no-cache \
  openssl \
  openssl-dev \
  libffi-dev \
  build-base \
  py3-pip \
  python2-dev \
  git \
  openssh-client \
  tar \
  nodejs \
  npm \
  curl \
  gettext \
  sed \
  grep

# Upgrade pip
pip install --upgrade pip

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error installing build-tools!" 1>&2
	# exit with error - important for ci system
	exit 1
fi


apk add --update py-pip
