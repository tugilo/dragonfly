<?php

use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\DragonFlyBreakoutAssignmentController;
use App\Http\Controllers\Api\DragonFlyBreakoutMemoController;
use App\Http\Controllers\Api\DragonFlyContactFlagController;
use App\Http\Controllers\Api\DragonFlyContactSummaryController;
use App\Http\Controllers\Api\DragonFlyMeetingController;
use App\Http\Controllers\Api\DragonFlyMemberController;
use App\Http\Controllers\Api\RoleController;
use App\Http\Controllers\Api\WorkspaceController;
use App\Http\Controllers\Religo\ContactMemoController;
use App\Http\Controllers\Religo\MeetingBreakoutController;
use App\Http\Controllers\Religo\MeetingBreakoutRoundsController;
use App\Http\Controllers\Religo\MeetingController;
use App\Http\Controllers\Religo\MeetingMemoController;
use App\Http\Controllers\Religo\CategorySearchController;
use App\Http\Controllers\Religo\MemberSearchController;
use App\Http\Controllers\Religo\MeetingCsvImportController;
use App\Http\Controllers\Religo\RoleSearchController;
use App\Http\Controllers\Religo\MeetingParticipantImportController;
use App\Http\Controllers\Religo\MemberRoleController;
use App\Http\Controllers\Religo\OneToOneController;
use App\Http\Controllers\Religo\DashboardController;
use App\Http\Controllers\Religo\DashboardDebugController;
use App\Http\Controllers\Religo\UserController;
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
Route::get('/dragonfly/members/one-to-one-status', [DragonFlyMemberController::class, 'oneToOneStatus']);
Route::get('/dragonfly/members/{id}', [DragonFlyMemberController::class, 'show'])->whereNumber('id');
Route::put('/dragonfly/members/{id}', [DragonFlyMemberController::class, 'update'])->whereNumber('id');

Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/categories/search', [CategorySearchController::class, 'search']);
Route::get('/categories/{id}', [CategoryController::class, 'show'])->whereNumber('id');
Route::post('/categories', [CategoryController::class, 'store']);
Route::put('/categories/{id}', [CategoryController::class, 'update'])->whereNumber('id');
Route::delete('/categories/{id}', [CategoryController::class, 'destroy'])->whereNumber('id');

Route::get('/roles', [RoleController::class, 'index']);
Route::get('/roles/search', [RoleSearchController::class, 'search']);
Route::get('/roles/{id}', [RoleController::class, 'show'])->whereNumber('id');
Route::post('/roles', [RoleController::class, 'store']);
Route::put('/roles/{id}', [RoleController::class, 'update'])->whereNumber('id');
Route::delete('/roles/{id}', [RoleController::class, 'destroy'])->whereNumber('id');

Route::get('/workspaces', [WorkspaceController::class, 'index']);

Route::get('/dashboard/stats', [DashboardController::class, 'stats']);
Route::get('/dashboard/tasks', [DashboardController::class, 'tasks']);
Route::get('/dashboard/activity', [DashboardController::class, 'activity']);
Route::get('/dashboard/weekly-presentation', [DashboardController::class, 'weeklyPresentation']);

if (app()->environment('local')) {
    Route::get('/debug/dashboard-summary', [DashboardDebugController::class, 'verifySummary']);
}

Route::get('/users/me', [UserController::class, 'showMe']);
Route::patch('/users/me', [UserController::class, 'updateMe']);

Route::get('/dragonfly/contacts/{target_member_id}/summary', [DragonFlyContactSummaryController::class, '__invoke'])
    ->whereNumber('target_member_id');

Route::get('/contact-memos', [ContactMemoController::class, 'index']);
Route::post('/contact-memos', [ContactMemoController::class, 'store']);
Route::get('/meeting-memos', [MeetingMemoController::class, 'index']);
Route::get('/one-to-ones/stats', [OneToOneController::class, 'stats']);
Route::get('/one-to-ones', [OneToOneController::class, 'index']);
Route::post('/one-to-ones', [OneToOneController::class, 'store']);
Route::get('/one-to-ones/{oneToOne}/memos', [OneToOneController::class, 'memosIndex']);
Route::post('/one-to-ones/{oneToOne}/memos', [OneToOneController::class, 'memosStore']);
Route::get('/one-to-ones/{oneToOne}', [OneToOneController::class, 'show']);
Route::patch('/one-to-ones/{oneToOne}', [OneToOneController::class, 'update']);

Route::get('/member-roles', [MemberRoleController::class, 'index']);

Route::get('/members/search', [MemberSearchController::class, 'search']);
Route::get('/meetings', [MeetingController::class, 'index']);
Route::post('/meetings', [MeetingController::class, 'store']);
Route::get('/meetings/stats', [MeetingController::class, 'stats']);
Route::get('/meetings/{meetingId}', [MeetingController::class, 'show'])->whereNumber('meetingId');
Route::patch('/meetings/{meetingId}', [MeetingController::class, 'update'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/memo', [MeetingMemoController::class, 'show'])->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/memo', [MeetingMemoController::class, 'update'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import', [MeetingCsvImportController::class, 'store'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/preview', [MeetingCsvImportController::class, 'preview'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/diff-preview', [MeetingCsvImportController::class, 'diffPreview'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/member-diff-preview', [MeetingCsvImportController::class, 'memberDiffPreview'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/role-diff-preview', [MeetingCsvImportController::class, 'roleDiffPreview'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/unresolved', [MeetingCsvImportController::class, 'unresolved'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/unresolved-suggestions', [MeetingCsvImportController::class, 'unresolvedSuggestions'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/resolutions', [MeetingCsvImportController::class, 'listResolutions'])->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/csv-import/resolutions/{resolutionId}', [MeetingCsvImportController::class, 'updateResolution'])->whereNumber('meetingId')->whereNumber('resolutionId');
Route::delete('/meetings/{meetingId}/csv-import/resolutions/{resolutionId}', [MeetingCsvImportController::class, 'destroyResolution'])->whereNumber('meetingId')->whereNumber('resolutionId');
Route::post('/meetings/{meetingId}/csv-import/resolutions', [MeetingCsvImportController::class, 'storeResolution'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/resolutions/create-member', [MeetingCsvImportController::class, 'createResolutionMember'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/resolutions/create-category', [MeetingCsvImportController::class, 'createResolutionCategory'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/resolutions/create-role', [MeetingCsvImportController::class, 'createResolutionRole'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/member-apply', [MeetingCsvImportController::class, 'memberApply'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/role-apply', [MeetingCsvImportController::class, 'roleApply'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/csv-import/apply-logs', [MeetingCsvImportController::class, 'applyLogs'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/csv-import/apply', [MeetingCsvImportController::class, 'apply'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/participants/import', [MeetingParticipantImportController::class, 'show'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/participants/import', [MeetingParticipantImportController::class, 'store'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/participants/import/parse', [MeetingParticipantImportController::class, 'parse'])->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/participants/import/candidates', [MeetingParticipantImportController::class, 'updateCandidates'])->whereNumber('meetingId');
Route::post('/meetings/{meetingId}/participants/import/apply', [MeetingParticipantImportController::class, 'apply'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/participants/import/download', [MeetingParticipantImportController::class, 'download'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/breakouts', [MeetingBreakoutController::class, 'show'])
    ->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/breakouts', [MeetingBreakoutController::class, 'update'])
    ->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/breakout-rounds', [MeetingBreakoutRoundsController::class, 'show'])
    ->whereNumber('meetingId');
Route::put('/meetings/{meetingId}/breakout-rounds', [MeetingBreakoutRoundsController::class, 'update'])
    ->whereNumber('meetingId');
