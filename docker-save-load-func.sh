#!/bin/bash

# Save docker images
ds() {
  docker images | \
    cut -d ' ' -f 1 | \
    tail -n +2 | \
    xargs -t -n 1 -I {} -P 4 \
      sh -c 'docker save {} | bzip2 > $(echo "{}" | sed "s/^.*\///").tar.bz2'
}

# Load docker images
dl() {
  ls *.bz2 | \
    xargs -t -n 1 -I {} -P 4 \
      sh -c 'bzip2 -dc {} | docker load'
}