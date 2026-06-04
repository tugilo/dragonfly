<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-015 / SPEC-016: リファーラル提案 run ＋ suggestion 行（121・定例会）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('one_to_one_referral_suggestion_runs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('one_to_one_id')->constrained('one_to_ones')->cascadeOnDelete();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();
            $table->string('notes_digest', 64);
            $table->unsignedInteger('notes_char_count');
            $table->string('generator', 32);
            $table->string('model')->nullable();
            $table->longText('raw_response')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->index(['one_to_one_id', 'created_at'], 'o2o_ref_run_o2o_created_idx');
            $table->index('notes_digest', 'o2o_ref_run_digest_idx');
        });

        Schema::create('one_to_one_referral_suggestions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('run_id')->constrained('one_to_one_referral_suggestion_runs')->cascadeOnDelete();
            $table->foreignId('one_to_one_id')->constrained('one_to_ones')->cascadeOnDelete();
            $table->string('direction', 32);
            $table->text('summary');
            $table->text('rationale')->nullable();
            $table->text('quality_notes')->nullable();
            $table->foreignId('suggested_from_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('suggested_to_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->string('suggested_to_label')->nullable();
            $table->string('confidence', 16)->default('medium');
            $table->string('status', 16)->default('pending');
            $table->foreignId('introduction_id')->nullable()->constrained('introductions')->nullOnDelete();
            $table->timestamp('accepted_at')->nullable();
            $table->timestamp('dismissed_at')->nullable();
            $table->json('edited_snapshot')->nullable();
            $table->timestamps();

            $table->index(['one_to_one_id', 'created_at'], 'o2o_ref_sugg_o2o_created_idx');
            $table->index('run_id', 'o2o_ref_sugg_run_idx');
            $table->index('introduction_id', 'o2o_ref_sugg_intro_idx');
            $table->index('status', 'o2o_ref_sugg_status_idx');
        });

        Schema::create('meeting_referral_suggestion_runs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->foreignId('meeting_minute_id')->constrained('meeting_minutes')->cascadeOnDelete();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();
            $table->string('body_digest', 64);
            $table->unsignedInteger('body_char_count');
            $table->string('generator', 32);
            $table->string('model')->nullable();
            $table->longText('raw_response')->nullable();
            $table->timestamp('created_at')->useCurrent();

            $table->index(['meeting_id', 'created_at'], 'mtg_ref_run_mtg_created_idx');
            $table->index('body_digest', 'mtg_ref_run_digest_idx');
        });

        Schema::create('meeting_referral_suggestions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('run_id')->constrained('meeting_referral_suggestion_runs')->cascadeOnDelete();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->string('source_section', 32)->default('other');
            $table->foreignId('subject_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->string('direction', 32);
            $table->text('summary');
            $table->text('rationale')->nullable();
            $table->text('quality_notes')->nullable();
            $table->foreignId('suggested_from_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('suggested_to_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->string('suggested_to_label')->nullable();
            $table->string('confidence', 16)->default('medium');
            $table->string('status', 16)->default('pending');
            $table->foreignId('introduction_id')->nullable()->constrained('introductions')->nullOnDelete();
            $table->timestamp('accepted_at')->nullable();
            $table->timestamp('dismissed_at')->nullable();
            $table->json('edited_snapshot')->nullable();
            $table->timestamps();

            $table->index(['meeting_id', 'created_at'], 'mtg_ref_sugg_mtg_created_idx');
            $table->index('run_id', 'mtg_ref_sugg_run_idx');
            $table->index('subject_member_id', 'mtg_ref_sugg_subject_idx');
            $table->index('introduction_id', 'mtg_ref_sugg_intro_idx');
            $table->index('status', 'mtg_ref_sugg_status_idx');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('meeting_referral_suggestions');
        Schema::dropIfExists('meeting_referral_suggestion_runs');
        Schema::dropIfExists('one_to_one_referral_suggestions');
        Schema::dropIfExists('one_to_one_referral_suggestion_runs');
    }
};
