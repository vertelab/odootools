#!/bin/bash

TARGET_BRANCH="17.0"  # Change to your desired branch

for dir in */; do
  if [ -d "$dir/.git" ]; then
    echo "Switching to $TARGET_BRANCH in $dir"
    cd "$dir"
    git restore .
    git fetch origin
    git checkout "$TARGET_BRANCH"
    cd ..
  fi
done

