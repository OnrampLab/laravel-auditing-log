<?php

declare(strict_types=1);

namespace OnrampLab\AuditingLog;

use Illuminate\Support\ServiceProvider;

class AuditingLogServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        $this->loadMigrationsFrom(__DIR__ . '/../database/migrations');
    }
}
