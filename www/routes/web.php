<?php

use App\Http\Controllers\DragonFlyMvpController;
use App\Http\Controllers\Sonae\SonaeLineWebhookController;
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/admin');

Route::get('/dragonfly/{number}', [DragonFlyMvpController::class, 'show'])->whereNumber('number');

Route::get('/admin', function () {
    return view('admin');
});

Route::post('/sonae/line/webhook/{chapter_key}', [SonaeLineWebhookController::class, 'handle'])
    ->middleware('sonae.line.webhook');
