#!/bin/bash

# Add RSA fingerprint for bitbucket.org to prevent SSH GIT CLI issues on CircleCI
mkdir -p ~/.ssh
for ip in $(dig @8.8.8.8 bitbucket.org +short); do ssh-keyscan bitbucket.org,$ip; ssh-keyscan $ip; done 2>/dev/null >> ~/.ssh/known_hosts

cat >> ~/.ssh/config << EOF
  VerifyHostKeyDNS yes
  StrictHostKeyChecking no
EOF

if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error configuring SSH!" 1>&2
	# exit with error - important for ci system
	exit 1
fi
