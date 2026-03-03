<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('breakout_memos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->foreignId('participant_id')->constrained('participants')->cascadeOnDelete();
            $table->foreignId('target_participant_id')->constrained('participants')->cascadeOnDelete();
            $table->foreignId('breakout_room_id')->nullable()->constrained('breakout_rooms')->nullOnDelete();
            $table->text('body')->nullable();
            $table->timestamps();
        });

        Schema::table('breakout_memos', function (Blueprint $table) {
            $table->unique(['meeting_id', 'participant_id', 'target_participant_id'], 'breakout_memos_meeting_author_target_unique');
            $table->index(['meeting_id', 'participant_id']);
            $table->index('target_participant_id');
            $table->index('breakout_room_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('breakout_memos');
    }
};
