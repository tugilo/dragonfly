<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Phase 195: 横断コーパス共有設定・relationship 生成メタ・提案二経路。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('member_referral_corpus_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();
            $table->foreignId('member_id')->constrained('members')->cascadeOnDelete();
            $table->boolean('allow_cross_corpus_contribution')->default(false);
            $table->timestamps();

            $table->unique('member_id', 'member_ref_corpus_settings_member_uq');
        });

        Schema::table('one_to_one_referral_suggestion_runs', function (Blueprint $table) {
            $table->string('context_mode', 16)->default('document')->after('notes_char_count');
            $table->string('context_digest', 64)->nullable()->after('context_mode');
            $table->foreignId('subject_member_id')->nullable()->constrained('members')->nullOnDelete()->after('context_digest');
            $table->json('corpus_meta')->nullable()->after('subject_member_id');
        });

        Schema::table('meeting_referral_suggestion_runs', function (Blueprint $table) {
            $table->string('context_mode', 16)->default('document')->after('body_char_count');
            $table->string('context_digest', 64)->nullable()->after('context_mode');
            $table->foreignId('subject_member_id')->nullable()->constrained('members')->nullOnDelete()->after('context_digest');
            $table->json('corpus_meta')->nullable()->after('subject_member_id');
        });

        Schema::table('one_to_one_referral_suggestions', function (Blueprint $table) {
            $table->string('corpus_source', 24)->default('self')->after('direction');
            $table->string('suggested_contact_label')->nullable()->after('suggested_to_label');
            $table->foreignId('source_one_to_one_id')->nullable()->constrained('one_to_ones')->nullOnDelete()->after('suggested_contact_label');
            $table->foreignId('source_meeting_id')->nullable()->constrained('meetings')->nullOnDelete()->after('source_one_to_one_id');
        });

        Schema::table('meeting_referral_suggestions', function (Blueprint $table) {
            $table->string('corpus_source', 24)->default('self')->after('direction');
            $table->string('suggested_contact_label')->nullable()->after('suggested_to_label');
            $table->foreignId('source_one_to_one_id')->nullable()->constrained('one_to_ones')->nullOnDelete()->after('suggested_contact_label');
            $table->foreignId('source_meeting_id')->nullable()->constrained('meetings')->nullOnDelete()->after('source_one_to_one_id');
        });
    }

    public function down(): void
    {
        Schema::table('meeting_referral_suggestions', function (Blueprint $table) {
            $table->dropConstrainedForeignId('source_meeting_id');
            $table->dropConstrainedForeignId('source_one_to_one_id');
            $table->dropColumn(['corpus_source', 'suggested_contact_label']);
        });

        Schema::table('one_to_one_referral_suggestions', function (Blueprint $table) {
            $table->dropConstrainedForeignId('source_meeting_id');
            $table->dropConstrainedForeignId('source_one_to_one_id');
            $table->dropColumn(['corpus_source', 'suggested_contact_label']);
        });

        Schema::table('meeting_referral_suggestion_runs', function (Blueprint $table) {
            $table->dropConstrainedForeignId('subject_member_id');
            $table->dropColumn(['context_mode', 'context_digest', 'corpus_meta']);
        });

        Schema::table('one_to_one_referral_suggestion_runs', function (Blueprint $table) {
            $table->dropConstrainedForeignId('subject_member_id');
            $table->dropColumn(['context_mode', 'context_digest', 'corpus_meta']);
        });

        Schema::dropIfExists('member_referral_corpus_settings');
    }
};
