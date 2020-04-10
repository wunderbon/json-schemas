#!/bin/bash

# Dereferencing JSON Schemas
./.circleci/dereference-json-schemas.sh && \
# Validating JSON Schemas
./.circleci/test-json-schemas.sh && \
# Validating JSON Schemas against Blueprint Model(s)
./.circleci/test-json-data.sh && \
# Faking data by JSON Schemas
./.circleci/create-fake-json-data.sh && \
# Create typescript declarations
./.circleci/create-typescript-declarations.sh && \
# Clone typescript declarations repository
./.circleci/clone-typescript-declarations-repository.sh && \
# Publish typescript declarations
#./.circleci/publish-typescript-declarations.sh
