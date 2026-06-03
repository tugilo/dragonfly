<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * 1 to 1 予定キャンセル理由（Phase 185 / ONETOONES-CANCEL-API-P1）。
     * SSOT: docs/SSOT/DATA_MODEL.md §4.12
     */
    public function up(): void
    {
        Schema::table('one_to_ones', function (Blueprint $table) {
            $table->string('cancel_reason', 32)->nullable()->after('status');
            $table->text('cancel_remark')->nullable()->after('cancel_reason');
            $table->dateTime('canceled_at')->nullable()->after('cancel_remark');
        });
    }

    public function down(): void
    {
        Schema::table('one_to_ones', function (Blueprint $table) {
            $table->dropColumn(['cancel_reason', 'cancel_remark', 'canceled_at']);
        });
    }
};
