#!/bin/bash
# Builds the docker image.

set -e

# Set variables
git_commit=${TRAVIS_COMMIT:-$(git rev-parse HEAD)}
version_number=${1:-"git-${git_commit}"}
build_date=$(date --rfc-3339=seconds | sed 's/ /T/')
devkitARM_url="https://downloads.sourceforge.net/project/devkitpro/devkitARM/devkitARM_r47/devkitARM_r47-x86_64-linux.tar.bz2"
citra_date="20170724"
citra_tag="untagged-3441a5634554e85a0b51"
citra_url="https://github.com/citra-emu/citra-nightly/releases/download/${citra_tag}/citra-linux-${citra_date}-$(git -C submodules/citra rev-parse --short=7 HEAD).tar.xz"

mkdir -p build

# Ensure dependencies are satisfied
command -v make > /dev/null 2>&1 || { echo >&2 "Please install make."; exit 1; }
command -v tar > /dev/null 2>&1 || { echo >&2 "Please install tar."; exit 1; }
command -v docker > /dev/null 2>&1 || { echo >&2 "Please install docker."; exit 1; }

# Download sources which aren't submodules
make -C submodules/3ds-portlibs tar-source

# Copy the sources into a compressed form while excluding the git history to
# avoid massive bloat.
tar --exclude=".git" --exclude="./build" -zcvf build/sources.tar.gz ./* ./.travis.yml
cp -r imagefs Dockerfile build

# Build the docker image
docker build \
   -t 3ds-dev \
   --build-arg "git_commit=${git_commit}" \
   --build-arg "build_date=${build_date}" \
   --build-arg "version_number=${version_number}" \
   --build-arg "devkitARM_url=${devkitARM_url}" \
   --build-arg "citra_url=${citra_url}" \
   build/
