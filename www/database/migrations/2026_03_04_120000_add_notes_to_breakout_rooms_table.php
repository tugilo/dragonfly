<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Phase10: ルーム単位メモを breakout_rooms に保持（1部屋=1メモ）. SSOT: DATA_MODEL §4.5 拡張.
     */
    public function up(): void
    {
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->text('notes')->nullable()->after('sort_order');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->dropColumn('notes');
        });
    }
};
