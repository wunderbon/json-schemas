#!/bin/bash

# Build the JSON-Schemas
./dereference-json-schemas.sh && \
./validate-json-schemas.sh && \
./validate-json-data.sh

# Now -> Create Fake data
