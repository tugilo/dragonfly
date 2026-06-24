<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-017 §11: SONAE PoC データモデル（Religo 衝突回避のため sonae_* 接頭辞）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sonae_organizations', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('source_system', 16)->default('sonae');
            $table->string('external_id')->nullable();
            $table->string('status', 16)->default('active');
            $table->timestamps();

            $table->index(['source_system', 'external_id'], 'sonae_org_source_ext_idx');
        });

        Schema::create('sonae_chapters', function (Blueprint $table) {
            $table->id();
            $table->foreignId('organization_id')->constrained('sonae_organizations')->cascadeOnDelete();
            $table->string('name');
            $table->string('code', 64);
            $table->string('chapter_key', 64)->unique();
            $table->string('source_system', 16)->default('sonae');
            $table->string('external_id')->nullable();
            $table->string('prefecture')->nullable();
            $table->json('municipalities')->nullable();
            $table->string('status', 16)->default('active');
            $table->timestamps();

            $table->unique(['source_system', 'external_id'], 'sonae_chapters_source_ext_uniq');
            $table->index('code', 'sonae_chapters_code_idx');
        });

        Schema::create('sonae_users', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->nullable()->constrained('sonae_chapters')->nullOnDelete();
            $table->string('name');
            $table->string('email')->unique();
            $table->string('password')->nullable();
            $table->string('source_system', 16)->default('sonae');
            $table->string('external_id')->nullable();
            $table->string('role', 32)->default('chapter_admin');
            $table->string('status', 16)->default('active');
            $table->timestamps();

            $table->index(['source_system', 'external_id'], 'sonae_users_source_ext_idx');
        });

        Schema::create('sonae_members', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('sonae_chapters')->cascadeOnDelete();
            $table->string('name');
            $table->string('name_kana')->nullable();
            $table->string('email')->nullable();
            $table->string('phone')->nullable();
            $table->string('category')->nullable();
            $table->string('role_label')->nullable();
            $table->string('source_system', 16)->default('sonae');
            $table->string('external_id')->nullable();
            $table->string('invite_token_hash', 64)->nullable();
            $table->string('status', 16)->default('active');
            $table->timestamps();

            $table->unique(['chapter_id', 'source_system', 'external_id'], 'sonae_members_chapter_source_ext_uniq');
            $table->index(['chapter_id', 'status'], 'sonae_members_chapter_status_idx');
        });

        Schema::create('sonae_member_contacts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('member_id')->constrained('sonae_members')->cascadeOnDelete();
            $table->string('contact_type', 16);
            $table->string('value');
            $table->boolean('is_primary')->default(false);
            $table->timestamp('verified_at')->nullable();
            $table->timestamps();

            $table->index(['member_id', 'contact_type'], 'sonae_member_contacts_member_type_idx');
        });

        Schema::create('sonae_line_accounts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('sonae_chapters')->cascadeOnDelete();
            $table->string('channel_id');
            $table->text('channel_secret_encrypted')->nullable();
            $table->text('messaging_api_access_token_encrypted')->nullable();
            $table->string('webhook_url')->nullable();
            $table->string('friend_add_url')->nullable();
            $table->string('status', 16)->default('inactive');
            $table->timestamps();

            $table->unique('chapter_id', 'sonae_line_accounts_chapter_uniq');
        });

        Schema::create('sonae_line_user_links', function (Blueprint $table) {
            $table->id();
            $table->foreignId('line_account_id')->constrained('sonae_line_accounts')->cascadeOnDelete();
            $table->foreignId('member_id')->constrained('sonae_members')->cascadeOnDelete();
            $table->string('line_user_id', 64);
            $table->timestamp('linked_at');
            $table->timestamp('unlinked_at')->nullable();
            $table->string('status', 16)->default('active');
            $table->timestamps();

            $table->unique(['line_account_id', 'line_user_id'], 'sonae_line_user_links_account_user_uniq');
            $table->index(['member_id', 'status'], 'sonae_line_user_links_member_status_idx');
        });

        Schema::create('sonae_alert_types', function (Blueprint $table) {
            $table->id();
            $table->string('code', 32)->unique();
            $table->string('name');
            $table->unsignedInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        Schema::create('sonae_alert_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('alert_type_id')->constrained('sonae_alert_types')->restrictOnDelete();
            $table->string('source', 16)->default('jma');
            $table->string('source_event_key');
            $table->string('payload_hash', 64);
            $table->string('title');
            $table->string('severity')->nullable();
            $table->timestamp('occurred_at')->nullable();
            $table->timestamp('announced_at')->nullable();
            $table->json('raw_payload')->nullable();
            $table->timestamps();

            $table->unique('source_event_key', 'sonae_alert_events_source_key_uniq');
            $table->index('payload_hash', 'sonae_alert_events_payload_hash_idx');
        });

        Schema::create('sonae_alert_event_areas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('alert_event_id')->constrained('sonae_alert_events')->cascadeOnDelete();
            $table->string('prefecture')->nullable();
            $table->string('municipality')->nullable();
            $table->string('area_code')->nullable();
            $table->string('intensity')->nullable();
            $table->string('warning_level')->nullable();
            $table->timestamps();

            $table->index('alert_event_id', 'sonae_alert_event_areas_event_idx');
        });

        Schema::create('sonae_chapter_alert_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('sonae_chapters')->cascadeOnDelete();
            $table->foreignId('alert_type_id')->constrained('sonae_alert_types')->restrictOnDelete();
            $table->boolean('is_enabled')->default(false);
            $table->json('target_prefectures')->nullable();
            $table->json('target_municipalities')->nullable();
            $table->string('threshold_code', 64)->nullable();
            $table->timestamps();

            $table->unique(['chapter_id', 'alert_type_id'], 'sonae_chapter_alert_settings_uniq');
        });

        Schema::create('sonae_training_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('sonae_chapters')->cascadeOnDelete();
            $table->string('name');
            $table->text('scenario')->nullable();
            $table->timestamp('scheduled_at')->nullable();
            $table->timestamp('executed_at')->nullable();
            $table->foreignId('created_by_user_id')->nullable()->constrained('sonae_users')->nullOnDelete();
            $table->timestamps();

            $table->index(['chapter_id', 'executed_at'], 'sonae_training_events_chapter_exec_idx');
        });

        Schema::create('sonae_alert_notifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->constrained('sonae_chapters')->cascadeOnDelete();
            $table->foreignId('alert_event_id')->nullable()->constrained('sonae_alert_events')->nullOnDelete();
            $table->foreignId('training_event_id')->nullable()->constrained('sonae_training_events')->nullOnDelete();
            $table->string('notification_type', 16);
            $table->string('title');
            $table->text('body');
            $table->string('status', 16)->default('draft');
            $table->timestamp('sent_at')->nullable();
            $table->foreignId('created_by_user_id')->nullable()->constrained('sonae_users')->nullOnDelete();
            $table->timestamps();

            $table->unique(['chapter_id', 'alert_event_id'], 'sonae_alert_notifications_chapter_event_uniq');
            $table->index(['chapter_id', 'notification_type', 'sent_at'], 'sonae_alert_notifications_chapter_type_sent_idx');
        });

        Schema::create('sonae_notification_targets', function (Blueprint $table) {
            $table->id();
            $table->foreignId('alert_notification_id')->constrained('sonae_alert_notifications')->cascadeOnDelete();
            $table->foreignId('member_id')->constrained('sonae_members')->cascadeOnDelete();
            $table->foreignId('line_user_link_id')->nullable()->constrained('sonae_line_user_links')->nullOnDelete();
            $table->string('response_token_hash', 64);
            $table->string('send_status', 16)->default('pending');
            $table->timestamp('sent_at')->nullable();
            $table->timestamp('responded_at')->nullable();
            $table->text('error_message')->nullable();
            $table->timestamps();

            $table->unique(['alert_notification_id', 'member_id'], 'sonae_notification_targets_notif_member_uniq');
            $table->index('response_token_hash', 'sonae_notification_targets_token_idx');
        });

        Schema::create('sonae_safety_responses', function (Blueprint $table) {
            $table->id();
            $table->foreignId('notification_target_id')->constrained('sonae_notification_targets')->cascadeOnDelete();
            $table->foreignId('member_id')->constrained('sonae_members')->cascadeOnDelete();
            $table->string('safety_status', 32);
            $table->string('activity_status', 32);
            $table->string('meeting_attendance_status', 32);
            $table->text('comment')->nullable();
            $table->timestamp('submitted_at');
            $table->timestamps();

            $table->unique('notification_target_id', 'sonae_safety_responses_target_uniq');
        });

        Schema::create('sonae_jma_fetch_settings', function (Blueprint $table) {
            $table->id();
            $table->boolean('is_enabled')->default(false);
            $table->unsignedSmallInteger('interval_minutes')->default(5);
            $table->timestamp('last_fetched_at')->nullable();
            $table->timestamp('next_fetch_at')->nullable();
            $table->timestamps();
        });

        Schema::create('sonae_jma_fetch_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('jma_fetch_setting_id')->constrained('sonae_jma_fetch_settings')->cascadeOnDelete();
            $table->string('fetch_type', 16);
            $table->string('status', 16);
            $table->timestamp('started_at');
            $table->timestamp('finished_at')->nullable();
            $table->unsignedInteger('fetched_count')->default(0);
            $table->unsignedInteger('created_event_count')->default(0);
            $table->unsignedInteger('skipped_duplicate_count')->default(0);
            $table->text('error_message')->nullable();
            $table->timestamps();

            $table->index(['jma_fetch_setting_id', 'started_at'], 'sonae_jma_fetch_logs_setting_started_idx');
        });

        Schema::create('sonae_error_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('chapter_id')->nullable()->constrained('sonae_chapters')->nullOnDelete();
            $table->string('category', 32);
            $table->string('severity', 16)->default('error');
            $table->text('message');
            $table->json('context')->nullable();
            $table->timestamp('occurred_at');
            $table->timestamps();

            $table->index(['chapter_id', 'occurred_at'], 'sonae_error_logs_chapter_occurred_idx');
            $table->index(['category', 'severity'], 'sonae_error_logs_category_severity_idx');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sonae_error_logs');
        Schema::dropIfExists('sonae_jma_fetch_logs');
        Schema::dropIfExists('sonae_jma_fetch_settings');
        Schema::dropIfExists('sonae_safety_responses');
        Schema::dropIfExists('sonae_notification_targets');
        Schema::dropIfExists('sonae_alert_notifications');
        Schema::dropIfExists('sonae_training_events');
        Schema::dropIfExists('sonae_chapter_alert_settings');
        Schema::dropIfExists('sonae_alert_event_areas');
        Schema::dropIfExists('sonae_alert_events');
        Schema::dropIfExists('sonae_alert_types');
        Schema::dropIfExists('sonae_line_user_links');
        Schema::dropIfExists('sonae_line_accounts');
        Schema::dropIfExists('sonae_member_contacts');
        Schema::dropIfExists('sonae_members');
        Schema::dropIfExists('sonae_users');
        Schema::dropIfExists('sonae_chapters');
        Schema::dropIfExists('sonae_organizations');
    }
};
