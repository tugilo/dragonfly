<?php

use App\Console\Commands\DashboardVerifySummaryCommand;
use App\Console\Commands\ImportParticipantsCsvCommand;
use App\Console\Commands\Sonae\BootstrapDragonFlyCommand;
use App\Console\Commands\Sonae\JmaFetchCommand;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'religo.member_merge' => \App\Http\Middleware\VerifyReligoMemberMergeToken::class,
            'religo.chapter_admin' => \App\Http\Middleware\EnsureReligoChapterAdmin::class,
            'zoom.webhook' => \App\Http\Middleware\VerifyZoomWebhookSignature::class,
            'sonae.line.webhook' => \App\Http\Middleware\VerifySonaeLineWebhookSignature::class,
            'sonae.chapter' => \App\Http\Middleware\EnsureSonaeChapterAccess::class,
        ]);
        $middleware->api(prepend: [
            \App\Http\Middleware\RejectInvalidSanctumBearerToken::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })
    ->withCommands([
        DashboardVerifySummaryCommand::class,
        ImportParticipantsCsvCommand::class,
        JmaFetchCommand::class,
        BootstrapDragonFlyCommand::class,
    ])
    ->create();
