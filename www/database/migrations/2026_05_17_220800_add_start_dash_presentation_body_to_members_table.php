<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-004 / Phase 119 — スタートダッシュプレゼン原稿（プレーンテキスト）.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->text('start_dash_presentation_body')->nullable()->after('weekly_presentation_body');
        });
    }

    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropColumn('start_dash_presentation_body');
        });
    }
};
