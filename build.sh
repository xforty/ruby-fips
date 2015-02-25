#!/usr/bin/env bash

if [ "$#" -ne 1 ]
then
  echo 1>&2 "Usage: $0 IMAGE_TAG"
  exit 1
fi

docker build -t "$1" "$(dirname "$0")"
