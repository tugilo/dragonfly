<?php

use App\Http\Controllers\DragonFlyMvpController;
use App\Http\Controllers\Sonae\SonaeLineWebhookController;
use App\Http\Controllers\Sonae\SonaeResponseController;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin');

Route::get('/dragonfly/{number}', [DragonFlyMvpController::class, 'show'])->whereNumber('number');

Route::get('/admin', function () {
    return view('admin');
});

Route::post('/sonae/line/webhook/{chapter_key}', [SonaeLineWebhookController::class, 'handle'])
    ->middleware('sonae.line.webhook');

Route::get('/sonae/respond/{token}', [SonaeResponseController::class, 'show'])
    ->name('sonae.respond.show');
Route::post('/sonae/respond/{token}', [SonaeResponseController::class, 'store'])
    ->name('sonae.respond.store');
