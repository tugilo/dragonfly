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
        Schema::create('participant_breakout', function (Blueprint $table) {
            $table->id();
            $table->foreignId('participant_id')->constrained('participants')->cascadeOnDelete();
            $table->foreignId('breakout_room_id')->constrained('breakout_rooms')->cascadeOnDelete();
            $table->timestamps();
        });

        Schema::table('participant_breakout', function (Blueprint $table) {
            $table->unique(['participant_id', 'breakout_room_id']);
            $table->index('participant_id');
            $table->index('breakout_room_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('participant_breakout');
    }
};
