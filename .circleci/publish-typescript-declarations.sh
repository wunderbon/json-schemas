#!/bin/bash

# Repository access data (configured at https://circleci.com/bb/organizations/wunderbon/settings#contexts)

# What we do
echo "Cloning typescript declarations repository from \"${GIT_REPOSITORY_URL}\""

# Do it
# A) PUBLISH TO OUR REPOSITORY (BASE FOR NEXT STEP B)
echo ${GIT_REPOSITORY_USERNAME}

# Return status
if [ "$?" = "0" ]; then
  # exit with success - important for ci system
  exit 0
else
	echo "Error while cloning repository!" 1>&2
	# exit with error - important for ci system
	exit 1
fi


# Send pull request with updated files  ...
#curl https://api.bitbucket.org/2.0/repositories/wunderbon/typescript-declarations/pullrequests \
#    -u ${REPOSITORY_USERNAME}:${REPOSITORY_PASSWORD} \
#    --request POST \
#    --header 'Content-Type: application/json' \
#    --data '{
#        "title": "Automatic PR from: ",
#        "source": {
#            "branch": {
#                "name": "staging"
#            }
#        }
#    }'

# B) PUBLISH TO DEFINITELY TYPED
