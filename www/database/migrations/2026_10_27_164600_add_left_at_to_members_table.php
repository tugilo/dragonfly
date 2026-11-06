<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Phase 321: members に退会日 left_at を追加する。
 * NULL = 在籍（または入会前の visitor/guest）。left_at <= today を退会済みとみなす。
 * members 行は履歴（participants / one_to_ones の FK）として残し、削除はしない（SPEC-008）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->date('left_at')->nullable()->after('type');
            $table->index('left_at', 'members_left_at_index');
        });
    }

    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropIndex('members_left_at_index');
            $table->dropColumn('left_at');
        });
    }
};
