<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Zoom 連携（SPEC-012 Phase B）: one_to_ones に Zoom 突合キーと取得元を追加。
 * 再取り込みでの二重登録を防ぐ（zoom_meeting_uuid で突合）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('one_to_ones', function (Blueprint $table) {
            $table->string('zoom_meeting_id')->nullable()->after('meeting_id');
            $table->string('zoom_meeting_uuid')->nullable()->after('zoom_meeting_id');
            $table->string('external_source', 20)->default('manual')->after('zoom_meeting_uuid');

            $table->index('zoom_meeting_id');
            $table->index('zoom_meeting_uuid');
        });
    }

    public function down(): void
    {
        Schema::table('one_to_ones', function (Blueprint $table) {
            $table->dropIndex(['zoom_meeting_id']);
            $table->dropIndex(['zoom_meeting_uuid']);
            $table->dropColumn(['zoom_meeting_id', 'zoom_meeting_uuid', 'external_source']);
        });
    }
};
