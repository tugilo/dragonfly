<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-P2-PREP: PDF解析状態を保持するための列追加。既存の status（アップロード状態）はそのまま。
     */
    public function up(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->timestamp('parsed_at')->nullable()->after('status');
            $table->string('parse_status', 20)->default('pending')->after('parsed_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->dropColumn(['parsed_at', 'parse_status']);
        });
    }
};
