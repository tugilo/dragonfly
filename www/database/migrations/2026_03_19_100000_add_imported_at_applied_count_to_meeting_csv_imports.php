<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-C3: CSV 反映履歴（PDF import の imported_at / applied_count に揃える）
     */
    public function up(): void
    {
        Schema::table('meeting_csv_imports', function (Blueprint $table) {
            $table->timestamp('imported_at')->nullable()->after('uploaded_at');
            $table->unsignedInteger('applied_count')->nullable()->after('imported_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('meeting_csv_imports', function (Blueprint $table) {
            $table->dropColumn(['imported_at', 'applied_count']);
        });
    }
};
