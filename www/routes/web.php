<?php

use App\Http\Controllers\DragonFlyMvpController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/dragonfly/{number}', [DragonFlyMvpController::class, 'show'])->whereNumber('number');

Route::get('/admin', function () {
    return view('admin');
});
