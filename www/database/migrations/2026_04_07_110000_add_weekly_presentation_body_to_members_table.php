<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-004 / DASHBOARD-WEEKLY-P1 — ウィークリープレゼン原稿（プレーンテキスト）.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->text('weekly_presentation_body')->nullable()->after('ncast_profile_url');
        });
    }

    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropColumn('weekly_presentation_body');
        });
    }
};
