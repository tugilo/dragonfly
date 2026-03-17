<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-P2-IMPLEMENT-1: PDF解析結果保存用カラム。extracted_text = 生テキスト、extracted_result = 候補JSON。
     */
    public function up(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->longText('extracted_text')->nullable()->after('parse_status');
            $table->json('extracted_result')->nullable()->after('extracted_text');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->dropColumn(['extracted_text', 'extracted_result']);
        });
    }
};
