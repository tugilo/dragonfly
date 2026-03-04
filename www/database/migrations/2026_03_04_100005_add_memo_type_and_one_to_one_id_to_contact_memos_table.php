<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * contact_memos に memo_type と one_to_one_id を追加（既存 migration は編集しない）。
     */
    public function up(): void
    {
        Schema::table('contact_memos', function (Blueprint $table) {
            $table->string('memo_type', 32)->default('other')->after('meeting_id');
            $table->foreignId('one_to_one_id')->nullable()->after('memo_type')->constrained('one_to_ones')->nullOnDelete();
        });

        Schema::table('contact_memos', function (Blueprint $table) {
            $table->index('one_to_one_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('contact_memos', function (Blueprint $table) {
            $table->dropForeign(['one_to_one_id']);
            $table->dropIndex(['one_to_one_id']);
            $table->dropColumn(['memo_type', 'one_to_one_id']);
        });
    }
};
