#!/bin/bash

# Build the JSON-Schemas
./.circleci/dereference-json-schemas.sh && \
./.circleci/validate-json-schemas.sh && \
./.circleci/validate-json-data.sh

# Now -> Create Fake data
