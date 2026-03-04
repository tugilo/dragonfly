<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Phase10R: breakout_rooms を round に紐付け。バックフィルで既存は round_no=1 に属させる。
     */
    public function up(): void
    {
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->foreignId('breakout_round_id')->nullable()->after('meeting_id')
                ->constrained('breakout_rounds')->cascadeOnDelete();
        });
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->index('breakout_round_id');
        });

        $meetingIds = DB::table('breakout_rooms')->distinct()->pluck('meeting_id');
        foreach ($meetingIds as $meetingId) {
            $roundId = DB::table('breakout_rounds')->insertGetId([
                'meeting_id' => $meetingId,
                'round_no' => 1,
                'label' => 'Round 1',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            DB::table('breakout_rooms')->where('meeting_id', $meetingId)->update([
                'breakout_round_id' => $roundId,
                'updated_at' => now(),
            ]);
        }

        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->dropUnique(['meeting_id', 'room_label']);
        });
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->unique(['breakout_round_id', 'room_label']);
        });
    }

    public function down(): void
    {
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->dropUnique(['breakout_round_id', 'room_label']);
        });
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->unique(['meeting_id', 'room_label']);
        });
        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->dropForeign(['breakout_round_id']);
        });
    }
};
