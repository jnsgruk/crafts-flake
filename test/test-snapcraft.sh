#!/usr/bin/env bash
set -euo pipefail
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${DIR}/.."

# Build snapcraft
pushd "${ROOT_DIR}"
nix build .#snapcraft
SNAPCRAFT="${ROOT_DIR}/result/bin/snapcraft"
popd

TEST_DIR="${ROOT_DIR}/.test/snapcraft"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
git clone https://github.com/jnsgruk/terraform-snap "$TEST_DIR"
pushd "$TEST_DIR"

"$SNAPCRAFT" --use-lxd --verbose
popd

rm -rf "$TEST_DIR"

