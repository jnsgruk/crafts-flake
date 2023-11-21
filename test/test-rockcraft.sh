#!/usr/bin/env bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${DIR}/.."

# Build rockcraft
pushd "${ROOT_DIR}"
nix build .#rockcraft
ROCKCRAFT="${ROOT_DIR}/result/bin/rockcraft"
popd

TEST_DIR="${ROOT_DIR}/.test/rockcraft"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
git clone https://github.com/jnsgruk/zinc-k8s-operator "$TEST_DIR"
pushd "$TEST_DIR"

"$ROCKCRAFT" pack --verbose
popd

rm -rf "$TEST_DIR"
