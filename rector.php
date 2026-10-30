<?php

declare(strict_types=1);

use Rector\Config\RectorConfig;

return RectorConfig::configure()
    ->withPaths([
        __DIR__ . '/src',
        __DIR__ . '/tests',
    ])
    ->withCache('./build/cache/rector')
    // define sets of rules
    ->withPhpSets(php80: true)
    ->withPreparedSets(deadCode: true, codeQuality: true);
