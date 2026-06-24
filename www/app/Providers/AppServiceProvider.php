<?php

namespace App\Providers;

use App\Console\Commands\Sonae\BootstrapDragonFlyCommand;
use App\Console\Commands\Sonae\JmaFetchCommand;
use App\Services\Sonae\Jma\SonaeJmaFeedProviderInterface;
use App\Services\Sonae\Jma\SonaeJmaFixtureFeedProvider;
use App\Services\Sonae\Jma\SonaeJmaNormalizerRegistry;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaEarthquakeNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaFloodNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaHeavyRainNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaHeavySnowNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaLandslideNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaNankaiTroughNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaTsunamiNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaTyphoonNormalizer;
use App\Services\Sonae\Jma\Normalizers\SonaeJmaVolcanoNormalizer;
use Illuminate\Support\ServiceProvider;
use Smalot\PdfParser\Parser;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(Parser::class, fn () => new Parser);
        $this->app->bind(SonaeJmaFeedProviderInterface::class, SonaeJmaFixtureFeedProvider::class);
        $this->app->singleton(SonaeJmaNormalizerRegistry::class, function () {
            return new SonaeJmaNormalizerRegistry([
                app(SonaeJmaEarthquakeNormalizer::class),
                app(SonaeJmaTsunamiNormalizer::class),
                app(SonaeJmaHeavyRainNormalizer::class),
                app(SonaeJmaFloodNormalizer::class),
                app(SonaeJmaLandslideNormalizer::class),
                app(SonaeJmaTyphoonNormalizer::class),
                app(SonaeJmaHeavySnowNormalizer::class),
                app(SonaeJmaVolcanoNormalizer::class),
                app(SonaeJmaNankaiTroughNormalizer::class),
            ]);
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}
