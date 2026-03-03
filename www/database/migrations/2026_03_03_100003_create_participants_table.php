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
        Schema::create('participants', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->foreignId('member_id')->constrained('members')->restrictOnDelete();
            $table->string('type', 20);
            $table->foreignId('introducer_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('attendant_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->timestamps();
        });

        Schema::table('participants', function (Blueprint $table) {
            $table->unique(['meeting_id', 'member_id']);
            $table->index('meeting_id');
            $table->index('member_id');
            $table->index('type');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('participants');
    }
};
