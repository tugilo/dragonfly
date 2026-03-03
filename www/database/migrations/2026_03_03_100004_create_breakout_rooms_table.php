<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * (meeting_id, room_label) UNIQUE: 同一回でのルーム名重複防止のため付与。
     */
    public function up(): void
    {
        Schema::create('breakout_rooms', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->string('room_label', 50);
            $table->unsignedTinyInteger('sort_order')->nullable();
            $table->timestamps();
        });

        Schema::table('breakout_rooms', function (Blueprint $table) {
            $table->index('meeting_id');
            $table->index('sort_order');
            $table->unique(['meeting_id', 'room_label']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('breakout_rooms');
    }
};
