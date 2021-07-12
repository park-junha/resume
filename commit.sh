#!/bin/bash

# Bump this variable manually on major version changes
MAJOR_VERSION="1"

# Variables
BASE_DIR="$(cd "$(dirname "$0" )" && pwd )"
BASE_TAG=$(date +%F | sed 's/-0/-/g' | sed 's/-/\./g')
DATESTAMP=$(date +%F | sed 's/-/ /g')
PATCH_VERSION="0"

if [[ $# -lt 1 ]]; then
  echo "err: please add a message."
  exit 1
fi

cd $BASE_DIR
while git tag | grep $MAJOR_VERSION.$BASE_TAG.$PATCH_VERSION > /dev/null;
do
    PATCH_VERSION=$[$PATCH_VERSION+1]
done

git checkout main
git add $BASE_DIR/index.html
git add $BASE_DIR/static/styles.css
git commit -m "$1"
if [ $? -ne 0 ];
then
    echo "Failed to commit - aborting."
    exit 1
fi
git tag -a $MAJOR_VERSION.$BASE_TAG.$PATCH_VERSION -m "$1"
git push && git push --tags
