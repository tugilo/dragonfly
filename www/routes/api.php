<?php

use App\Http\Controllers\Api\AdminUserController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\AuthRegisterController;
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
use App\Http\Controllers\Religo\MeetingTypeController;
use App\Http\Controllers\Religo\MeetingMemoController;
use App\Http\Controllers\Religo\CategorySearchController;
use App\Http\Controllers\Religo\MemberSearchController;
use App\Http\Controllers\Religo\MeetingCsvImportController;
use App\Http\Controllers\Religo\RoleSearchController;
use App\Http\Controllers\Religo\MeetingParticipantImportController;
use App\Http\Controllers\Religo\MemberRoleController;
use App\Http\Controllers\Religo\IntroductionController;
use App\Http\Controllers\Religo\InternalReferralController;
use App\Http\Controllers\Religo\OneToOneController;
use App\Http\Controllers\Religo\DashboardController;
use App\Http\Controllers\Religo\DashboardDebugController;
use App\Http\Controllers\Religo\MemberMergeController;
use App\Http\Controllers\Religo\UserController;
use App\Http\Controllers\Zoom\UserZoomCredentialController;
use App\Http\Controllers\Zoom\ZoomImportController;
use App\Http\Controllers\Zoom\ZoomOAuthController;
use App\Http\Controllers\Zoom\ZoomWebhookController;
use App\Http\Controllers\Ai\UserAiCredentialController;
use App\Http\Controllers\Religo\MeetingReferralSuggestionController;
use App\Http\Controllers\Religo\OneToOneReferralSuggestionController;
use App\Http\Controllers\Religo\ReferralCorpusSettingsController;
use App\Http\Controllers\Religo\OneToOnePrepController;
use App\Http\Controllers\Sonae\SonaeAlertThresholdOptionController;
use App\Http\Controllers\Sonae\SonaeChapterController;
use App\Http\Controllers\Sonae\SonaeMemberController;
use Illuminate\Support\Facades\Route;

Route::post('/auth/login', [AuthController::class, 'login']);
Route::post('/auth/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');
Route::post('/auth/register/request', [AuthRegisterController::class, 'request'])
    ->middleware('throttle:10,1');
Route::post('/auth/register/complete', [AuthRegisterController::class, 'complete'])
    ->middleware('throttle:10,1');

Route::middleware('religo.chapter_admin')->prefix('admin')->group(function () {
    Route::patch('/users/{user}', [AdminUserController::class, 'update']);
});

/*
|--------------------------------------------------------------------------
| Admin: member merge（トークン必須・RELIGO_MEMBER_MERGE_TOKEN）
|--------------------------------------------------------------------------
*/

Route::middleware(['religo.member_merge'])->prefix('admin/member-merge')->group(function () {
    Route::post('/preview', [MemberMergeController::class, 'preview']);
    Route::post('/execute', [MemberMergeController::class, 'execute']);
});

/*
|--------------------------------------------------------------------------
| Zoom 連携（SPEC-012 / 1 to 1 取り込み）
|--------------------------------------------------------------------------
| callback は Zoom からのブラウザリダイレクト（署名 state で user 解決・ゲートなし）。
| それ以外は auth:sanctum（ユーザー単位）。
*/

Route::get('/zoom/callback', [ZoomOAuthController::class, 'callback']);
Route::post('/zoom/webhook', [ZoomWebhookController::class, 'handle'])->middleware('zoom.webhook');

// Zoom 連携・取り込みは「ログイン済みユーザー単位」。各ユーザーが自分の Zoom を連携し、
// 自分のミーティングのみ取り込む（データは actingUser=認証ユーザーにスコープ）。chapter_admin 限定ではない。
Route::middleware('auth:sanctum')->prefix('zoom')->group(function () {
    Route::get('/credentials', [UserZoomCredentialController::class, 'show']);
    Route::put('/credentials', [UserZoomCredentialController::class, 'update']);
    Route::post('/credentials/test', [UserZoomCredentialController::class, 'test']);

    Route::get('/connect', [ZoomOAuthController::class, 'connect']);
    Route::delete('/connect', [ZoomOAuthController::class, 'disconnect']);
    Route::get('/status', [ZoomOAuthController::class, 'status']);

    Route::post('/sync', [ZoomImportController::class, 'sync']);
    Route::get('/imports', [ZoomImportController::class, 'index']);
    Route::put('/imports/{import}', [ZoomImportController::class, 'update']);
    Route::post('/imports/{import}/create-member', [ZoomImportController::class, 'createMember']);
    Route::post('/imports/apply', [ZoomImportController::class, 'apply']);
    Route::post('/imports/{import}/summary', [ZoomImportController::class, 'summary']);
});

/*
|--------------------------------------------------------------------------
| AI 設定（SPEC-013・ユーザーごと BYO key）／1to1 事前準備（添付・原稿生成）
|--------------------------------------------------------------------------
| 認証済みユーザー本人のみ。1to1 操作は owner 一致が必要。
*/
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/ai/credentials', [UserAiCredentialController::class, 'show']);
    Route::put('/ai/credentials', [UserAiCredentialController::class, 'update']);
    Route::post('/ai/credentials/test', [UserAiCredentialController::class, 'test']);

    Route::get('/one-to-ones/{oneToOne}/attachments', [OneToOnePrepController::class, 'indexAttachments']);
    Route::post('/one-to-ones/{oneToOne}/attachments', [OneToOnePrepController::class, 'storePdf']);
    Route::post('/one-to-ones/{oneToOne}/attachments/url', [OneToOnePrepController::class, 'storeUrl']);
    Route::delete('/one-to-ones/{oneToOne}/attachments/{attachment}', [OneToOnePrepController::class, 'destroyAttachment']);
    Route::post('/one-to-ones/{oneToOne}/prep/generate', [OneToOnePrepController::class, 'generate']);

    Route::get('/referral-corpus-settings', [ReferralCorpusSettingsController::class, 'show']);
    Route::patch('/referral-corpus-settings', [ReferralCorpusSettingsController::class, 'update']);

    Route::post('/one-to-ones/{oneToOne}/referral-suggestions/generate', [OneToOneReferralSuggestionController::class, 'generate']);
    Route::get('/one-to-ones/{oneToOne}/referral-suggestions', [OneToOneReferralSuggestionController::class, 'index']);
    Route::patch('/one-to-one-referral-suggestions/{oneToOneReferralSuggestion}', [OneToOneReferralSuggestionController::class, 'update']);
    Route::post('/one-to-one-referral-suggestions/{oneToOneReferralSuggestion}/register-introduction', [OneToOneReferralSuggestionController::class, 'registerIntroduction']);

    Route::post('/meetings/{meeting}/referral-suggestions/generate', [MeetingReferralSuggestionController::class, 'generate']);
    Route::get('/meetings/{meeting}/referral-suggestions', [MeetingReferralSuggestionController::class, 'index']);
    Route::patch('/meeting-referral-suggestions/{meetingReferralSuggestion}', [MeetingReferralSuggestionController::class, 'update']);
    Route::post('/meeting-referral-suggestions/{meetingReferralSuggestion}/register-introduction', [MeetingReferralSuggestionController::class, 'registerIntroduction']);

    /*
    |--------------------------------------------------------------------------
    | SONAE API (SPEC-017 Phase 244+)
    |--------------------------------------------------------------------------
    */
    Route::prefix('sonae')->group(function () {
        Route::get('/alert-threshold-options', [SonaeAlertThresholdOptionController::class, 'index']);
        Route::get('/chapters/{chapter}', [SonaeChapterController::class, 'show']);
        Route::get('/chapters/{chapter}/members', [SonaeMemberController::class, 'index']);
        Route::get('/chapters/{chapter}/members/unlinked', [SonaeMemberController::class, 'unlinked']);
        Route::patch('/chapters/{chapter}/members/{member}', [SonaeMemberController::class, 'update']);
        Route::post('/chapters/{chapter}/members/sync', [SonaeMemberController::class, 'sync']);
        Route::post('/chapters/{chapter}/members/import-csv', [SonaeMemberController::class, 'importCsv']);
    });
});

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
Route::get('/one-to-ones/{oneToOne}/series-markdown', [OneToOneController::class, 'seriesMarkdown']);
Route::get('/one-to-ones/{oneToOne}/memos', [OneToOneController::class, 'memosIndex']);
Route::post('/one-to-ones/{oneToOne}/memos', [OneToOneController::class, 'memosStore']);
Route::get('/one-to-ones/{oneToOne}', [OneToOneController::class, 'show']);
Route::patch('/one-to-ones/{oneToOne}', [OneToOneController::class, 'update']);
Route::post('/one-to-ones/{oneToOne}/cancel', [OneToOneController::class, 'cancel']);

Route::get('/introductions', [IntroductionController::class, 'index']);
Route::post('/introductions', [IntroductionController::class, 'store']);
Route::get('/introductions/{introduction}', [IntroductionController::class, 'show']);
Route::patch('/introductions/{introduction}', [IntroductionController::class, 'update']);

Route::get('/internal-referrals', [InternalReferralController::class, 'index']);
Route::post('/internal-referrals', [InternalReferralController::class, 'store']);
Route::get('/internal-referrals/{internalReferral}', [InternalReferralController::class, 'show']);
Route::patch('/internal-referrals/{internalReferral}', [InternalReferralController::class, 'update']);

Route::get('/member-roles', [MemberRoleController::class, 'index']);

Route::get('/members/search', [MemberSearchController::class, 'search']);
Route::get('/meeting-types', [MeetingTypeController::class, 'index']);
Route::get('/meetings', [MeetingController::class, 'index']);
Route::post('/meetings', [MeetingController::class, 'store']);
Route::get('/meetings/stats', [MeetingController::class, 'stats']);
Route::get('/meetings/{meetingId}', [MeetingController::class, 'show'])->whereNumber('meetingId');
Route::patch('/meetings/{meetingId}', [MeetingController::class, 'update'])->whereNumber('meetingId');
Route::get('/meetings/{meetingId}/minutes', [MeetingController::class, 'minutes'])->whereNumber('meetingId');
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
