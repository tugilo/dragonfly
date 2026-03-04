<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * Phase10R: Round 可変の第一級. SSOT: PHASE10R PLAN.
     */
    public function up(): void
    {
        Schema::create('breakout_rounds', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->unsignedInteger('round_no');
            $table->string('label', 100)->nullable();
            $table->timestamps();
        });
        Schema::table('breakout_rounds', function (Blueprint $table) {
            $table->unique(['meeting_id', 'round_no']);
            $table->index(['meeting_id', 'round_no']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('breakout_rounds');
    }
};
