<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-009 / DATA_MODEL §4.13 — 外部リファーラル種別（当面 external のみ）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('introductions', function (Blueprint $table) {
            $table->string('referral_kind', 32)->default('external')->after('to_member_id');
            $table->index('referral_kind');
        });
    }

    public function down(): void
    {
        Schema::table('introductions', function (Blueprint $table) {
            $table->dropIndex(['referral_kind']);
            $table->dropColumn('referral_kind');
        });
    }
};
