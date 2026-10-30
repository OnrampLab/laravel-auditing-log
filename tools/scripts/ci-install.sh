#!/bin/bash
# Usage: tools/scripts/ci-install.sh <laravel-major> [--with-tools]
# Installs the given Laravel major. Rewrites composer.json, so only run it in CI or a disposable copy.
set -euo pipefail

LARAVEL="$1"
case "$LARAVEL" in
  8) TESTBENCH="^6.25" ;;
  9) TESTBENCH="^7.0" ;;
  10) TESTBENCH="^8.0" ;;
  11) TESTBENCH="^9.0" ;;
  12) TESTBENCH="^10.0" ;;
  13) TESTBENCH="^11.0" ;;
  *) echo "Unsupported Laravel major: $LARAVEL" >&2; exit 1 ;;
esac

# Laravel 8-11 have unpatched security advisories, which Composer >= 2.9 blocks by default
composer config policy.advisories.block false

if [ "${2:-}" != "--with-tools" ]; then
  composer remove --dev --no-update --no-interaction \
    nunomaduro/phpinsights larastan/larastan rector/rector phpmd/phpmd \
    spatie/phpunit-watcher onramplab/onr-phpcs-laravel squizlabs/php_codesniffer
fi

composer require --dev --no-update --no-interaction \
  "laravel/framework:^${LARAVEL}.0" "orchestra/testbench:${TESTBENCH}"
composer update --prefer-dist --no-interaction --no-progress -W

installed_major() {
  composer show "$1" | sed -n 's/^versions *: \* v\{0,1\}\([0-9]*\).*/\1/p'
}
[ "$(installed_major laravel/framework)" = "$LARAVEL" ] || { echo "laravel/framework is not ${LARAVEL}.x" >&2; exit 1; }
[ "$(installed_major spatie/laravel-activitylog)" = "4" ] || { echo "spatie/laravel-activitylog is not 4.x" >&2; exit 1; }
