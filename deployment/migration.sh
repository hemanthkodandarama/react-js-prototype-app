#!/bin/bash

set -exu

cd middleware/dist

node node_modules/@replicon/dynamodb-migrator/dist/migrate.js -m replicon-psa-$TF_VAR_swimlane-migrations -r $TF_VAR_aws_region ./scripts/migrations