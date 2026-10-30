#!/bin/bash
# Usage: tools/scripts/docker-test.sh <php> <laravel-major>
# Runs the test suite against one PHP / Laravel pair in a disposable cimg/php container.
set -euo pipefail

PHP="$1"
LARAVEL="$2"

docker run --rm -v "$(pwd)":/src:ro "cimg/php:${PHP}" bash -c "
  mkdir ~/app && tar -C /src --exclude=./.git --exclude=./vendor --exclude=./composer.lock --exclude=./build -cf - . | tar -C ~/app -xf - && cd ~/app &&
  sudo composer self-update --2 -q &&
  tools/scripts/ci-install.sh ${LARAVEL} &&
  tools/scripts/run-tests.sh
"
