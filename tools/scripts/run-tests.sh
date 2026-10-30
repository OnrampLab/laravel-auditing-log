#!/bin/bash
# Usage: tools/scripts/run-tests.sh [phpunit args...]
# Picks the phpunit config matching the installed PHPUnit major and fails when no test ran.
set -euo pipefail

CONFIG=phpunit.xml
if vendor/bin/phpunit --version | grep -q 'PHPUnit 9\.'; then
  CONFIG=phpunit.9.xml
fi

mkdir -p build
rm -f build/junit.xml
vendor/bin/phpunit -d memory_limit=386M --configuration "$CONFIG" --log-junit build/junit.xml "$@"

grep -q 'tests="[1-9]' build/junit.xml || { echo "No tests executed" >&2; exit 1; }
