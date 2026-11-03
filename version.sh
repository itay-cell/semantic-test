#!/usr/bin/env bash
# Prints the version this checkout is at: the last vX.Y.Z tag semantic-release pushed,
# with the commits since it when HEAD isn't the tagged commit (1.0.0-2-gabc1234).
# The leading "v" is dropped so the output can be used as a version as is.
# With --json, prints {"version": ..., "commit": ...} instead.
set -euo pipefail
TAG=$(git describe --tags --match 'v[0-9]*' 2>/dev/null || echo 'v0.0.0')
VERSION=${TAG#v}
if [ "${1:-}" = "--json" ]; then
  printf '{"version": "%s", "commit": "%s"}\n' "$VERSION" "$(git rev-parse --short HEAD)"
else
  echo "$VERSION"
fi
