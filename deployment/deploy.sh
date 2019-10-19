#!/bin/bash

set -exu

REGION=$TF_VAR_aws_region
SWIMLANE=$TF_VAR_swimlane

ROOT=$(pwd)
TMP_FOLDER=/tmp/deployment
rm -rf $TMP_FOLDER
mkdir -p $TMP_FOLDER
unzip -q ./terraform.zip -d $TMP_FOLDER
cp -rf $TMP_FOLDER/state.tf.template $TMP_FOLDER/state.tf

echo "Determining if a downtime deployment is needed"

./pre-migration.sh
cp backend/dist/migration.auto.tfvars $TMP_FOLDER

pushd $TMP_FOLDER
sed -i -e "s#STATE_BUCKET_REGION#$STATE_BUCKET_REGION#g" state.tf
sed -i -e "s#STATE_BUCKET_KEY#$STATE_BUCKET_KEY#g" state.tf
sed -i -e "s#STATE_BUCKET#$STATE_BUCKET#g" state.tf

terraform init
$ROOT/pre-deploy.sh
terraform apply --auto-approve -no-color
$ROOT/post-deploy.sh

[ -n "${FTD_OUTPUT_URL:-}" ] && terraform output -json | curl -f -X POST -H 'Content-Type: application/json' $FTD_OUTPUT_URL -d @-
[ ! -n "${FTD_OUTPUT_URL:-}" ] && echo "FTD_OUTPUT_URL not defined"

popd

echo "Running dynamo migrations"

./migration.sh

echo "Deploying frontend"

mkdir frontend-package
cd frontend-package

unzip -q ../frontend.zip

aws s3 cp --recursive --region $REGION --acl public-read --exclude "*.html" . s3://demo-company-demo-$SWIMLANE
aws s3 cp --recursive --region $REGION --acl public-read --exclude "*" --include "*.js" --content-encoding gzip ./static s3://demo-company-demo-$SWIMLANE/static
aws s3 cp --recursive --region $REGION --acl public-read --exclude "*" --include "*.html" --cache-control "max-age=0, must-revalidate" . s3://demo-company-demo-$SWIMLANE
aws s3 sync --region $REGION --delete . s3://demo-company-demo-$SWIMLANE

cd ..

echo "Exiting maintenance state"

pushd $TMP_FOLDER

echo under_maintenance=false > migration.auto.tfvars

terraform apply --auto-approve -no-color

popd
