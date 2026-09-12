<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-004 / Phase 307 — ウィークリー稿のパターンと利用履歴.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->json('weekly_presentation_patterns')->nullable()->after('weekly_presentation_body');
            $table->string('weekly_presentation_active_id', 32)->nullable()->after('weekly_presentation_patterns');
        });

        Schema::create('member_weekly_presentation_usages', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('member_id');
            $table->string('pattern_id', 32);
            $table->date('used_on');
            $table->timestamp('used_at');
            $table->timestamps();

            $table->foreign('member_id')->references('id')->on('members')->cascadeOnDelete();
            $table->unique(['member_id', 'used_on', 'pattern_id'], 'mwpu_member_on_pattern_unique');
            $table->index(['member_id', 'used_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('member_weekly_presentation_usages');

        Schema::table('members', function (Blueprint $table) {
            $table->dropColumn([
                'weekly_presentation_patterns',
                'weekly_presentation_active_id',
            ]);
        });
    }
};
