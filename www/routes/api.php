<?php

use App\Http\Controllers\Api\DragonFlyBreakoutAssignmentController;
use App\Http\Controllers\Api\DragonFlyBreakoutMemoController;
use App\Http\Controllers\Api\DragonFlyContactFlagController;
use App\Http\Controllers\Api\DragonFlyContactSummaryController;
use App\Http\Controllers\Api\DragonFlyMeetingController;
use App\Http\Controllers\Api\DragonFlyMemberController;
use App\Http\Controllers\Api\WorkspaceController;
use App\Http\Controllers\Religo\ContactMemoController;
use App\Http\Controllers\Religo\MeetingBreakoutController;
use App\Http\Controllers\Religo\MeetingBreakoutRoundsController;
use App\Http\Controllers\Religo\MeetingController;
use App\Http\Controllers\Religo\OneToOneController;
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
Route::delete('/dragonfly/meetings/{number}/breakout-assignments', [DragonFlyBreakoutAssignmentController::class, 'destroy'])
    ->whereNumber('number');

Route::get('/dragonfly/flags', [DragonFlyContactFlagController::class, 'index']);
Route::put('/dragonfly/flags/{target_member_id}', [DragonFlyContactFlagController::class, 'update'])
    ->whereNumber('target_member_id');

Route::get('/dragonfly/members', [DragonFlyMemberController::class, 'index']);

Route::get('/workspaces', [WorkspaceController::class, 'index']);

Route::get('/dragonfly/contacts/{target_member_id}/summary', [DragonFlyContactSummaryController::class, '__invoke'])
    ->whereNumber('target_member_id');

Route::post('/contact-memos', [ContactMemoController::class, 'store']);
Route::get('/one-to-ones', [OneToOneController::class, 'index']);
Route::post('/one-to-ones', [OneToOneController::class, 'store']);

Route::get('/meetings', [MeetingController::class, 'index']);
Route::get('/meetings/{meetingId}/breakouts', [MeetingBreakoutController::class, 'show'])
    ->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/breakouts', [MeetingBreakoutController::class, 'update'])
    ->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/breakout-rounds', [MeetingBreakoutRoundsController::class, 'show'])
    ->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/breakout-rounds', [MeetingBreakoutRoundsController::class, 'update'])
    ->whereNumber('meetingId');
