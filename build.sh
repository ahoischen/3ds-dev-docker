#!/bin/bash
# Builds the docker image.

set -e

# Set variables
git_commit=${TRAVIS_COMMIT:-$(git rev-parse HEAD)}
version_number=${1:-"git-${git_commit}"}
build_date=$(date --rfc-3339=seconds | sed 's/ /T/')

mkdir -p build

# Ensure dependencies are satisfied
command -v make > /dev/null 2>&1 || { echo >&2 "Please install make."; exit 1; }
command -v tar > /dev/null 2>&1 || { echo >&2 "Please install tar."; exit 1; }
command -v docker > /dev/null 2>&1 || { echo >&2 "Please install docker."; exit 1; }

# Download sources which aren't submodules
make -C submodules/3ds-portlibs tar-sources

# Copy the sources into a compressed form while excluding the git history to
# avoid massive bloat.
tar --exclude='.git' -zcvf build/sources.tar.gz submodules/

# Build the docker image
docker build \
   -t 3ds-dev \
   --build-arg git_commit=${git_commit} \
   --build-arg build_date=${build_date} \
   --build-arg version_number=${version_number} \
   .
