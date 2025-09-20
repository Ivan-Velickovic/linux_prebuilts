#!/bin/bash

set -e

if [ "$#" -ne 1 ]; then
    echo "usage: ./release.sh VERSION"
    exit 1
fi

git tag $VERSION

git push origin tag $VERSION

gh release create $VERSION release/*.tar.gz

