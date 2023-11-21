#!/usr/bin/env bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${DIR}/.."

# Build charmcraft
pushd "${ROOT_DIR}"
nix build .#charmcraft
CHARMCRAFT="${ROOT_DIR}/result/bin/charmcraft"
popd

TEST_DIR="${ROOT_DIR}/.test/charmcraft"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
git clone https://github.com/jnsgruk/parca-k8s-operator "$TEST_DIR"
pushd "$TEST_DIR"

"$CHARMCRAFT" pack --verbose
popd

rm -rf "$TEST_DIR"
