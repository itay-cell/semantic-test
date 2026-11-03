#!/usr/bin/env bash
# Prints the version this checkout is at: the last vX.Y.Z tag semantic-release pushed,
# with the commits since it when HEAD isn't the tagged commit (v1.0.0-2-gabc1234).
set -euo pipefail
echo "semantic-test $(git describe --tags --match 'v[0-9]*' 2>/dev/null || echo 'unreleased')"
