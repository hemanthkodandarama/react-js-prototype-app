#!/bin/bash

set -e

echo "Install dependencies"
sudo apt-get -y -qq update
sudo apt-get -y -qq install python3.5-dev python3-setuptools
sudo easy_install3 pip
pip install awscli --upgrade --user

# Set-up Docker authentication for our private Docker repos.  The AWS command-line gives us an `ecr get-login` command that
# outputs a `docker login` command that issues a temporary (12-hour) session login to AWS ECR.  Our instance profile should
# automatically be used to grant us whatever ECR access our instance profile has.
eval $(aws ecr get-login --region us-east-1 --no-include-email)

DOCKER_REPO_BASE="434423891815.dkr.ecr.us-east-1.amazonaws.com/psa-ui/middleware-app"

APP_DOCKER_IMAGE=$DOCKER_REPO_BASE:$BRANCH_VERSION
APP_DOCKER_IMAGE_B=$DOCKER_REPO_BASE:b-$BRANCH_VERSION

echo "Set up NPM"
npm config set @replicon:registry=https://replicon.myget.org/F/replicon/npm/
npm set //replicon.myget.org/F/replicon/npm/:_password $(printf $REPLICON_MYGET_PASSWORD | base64)
npm set //replicon.myget.org/F/replicon/npm/:username $REPLICON_MYGET_USERNAME
npm set //replicon.myget.org/F/replicon/npm/:email $REPLICON_MYGET_EMAIL
npm set //replicon.myget.org/F/replicon/npm/:always-auth true

cd frontend

echo "Installing build dependencies"
npm install

echo "Builds frontend using create react app"
npm run build

cd ..

cd middleware

echo "Install build dependencies"
npm install

echo "Building middleware release using babel"
npm run build

cp -r ./locales ./dist/locales
cp -r node_modules dist
mkdir dist/public
cp -r ../frontend/build/* dist/public

echo "Building docker image for Elastic Beanstalk"
docker build -t $APP_DOCKER_IMAGE -t $APP_DOCKER_IMAGE_B -f ./Dockerfile-app .

echo "Pushing $APP_DOCKER_IMAGE..."
docker push $APP_DOCKER_IMAGE
echo "Pushing $APP_DOCKER_IMAGE_B..."
docker push $APP_DOCKER_IMAGE_B

echo "Middleware build complete"

cd ..

echo "Zipping dynamic swimlane extensions"
cd .dsextensions
zip -q -r dsextensions.zip .

echo "Uploading dsextensions artifact"
aws s3 cp --region us-west-2 ./dsextensions.zip s3://replicon-build-artifacts/psa-ui/psa-ui-$BRANCH_VERSION.zip
aws s3 cp --region us-west-2 ./dsextensions.zip s3://replicon-build-artifacts/psa-ui/psa-ui-$BRANCH_VERSION.dsextension