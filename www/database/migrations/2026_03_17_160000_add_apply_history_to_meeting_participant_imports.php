<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-P6: participants 反映履歴。最新 1 回分のみ保持。
     */
    public function up(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->dateTime('imported_at')->nullable()->after('extracted_result');
            $table->unsignedInteger('applied_count')->nullable()->after('imported_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->dropColumn(['imported_at', 'applied_count']);
        });
    }
};
