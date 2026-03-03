<?php

use App\Http\Controllers\Api\DragonFlyBreakoutAssignmentController;
use App\Http\Controllers\Api\DragonFlyBreakoutMemoController;
use App\Http\Controllers\Api\DragonFlyMeetingController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| DragonFly API (meeting 199 等)
|--------------------------------------------------------------------------
*/

Route::get('/dragonfly/meetings/{number}/attendees', [DragonFlyMeetingController::class, 'attendees'])
    ->whereNumber('number');

Route::get('/dragonfly/meetings/{number}/breakout-memos', [DragonFlyBreakoutMemoController::class, 'index'])
    ->whereNumber('number');
Route::put('/dragonfly/meetings/{number}/breakout-memos', [DragonFlyBreakoutMemoController::class, 'upsert'])
    ->whereNumber('number');
Route::get('/dragonfly/meetings/{number}/breakout-roommates/{participant_id}', [DragonFlyBreakoutMemoController::class, 'roommates'])
    ->whereNumber('number')
    ->whereNumber('participant_id');

Route::put('/dragonfly/meetings/{number}/breakout-assignments', [DragonFlyBreakoutAssignmentController::class, 'store'])
    ->whereNumber('number');
