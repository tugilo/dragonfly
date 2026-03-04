<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 紹介の記録。Phase3 拡張用・最低限スキーマ（会の地図 SSOT）。
     */
    public function up(): void
    {
        Schema::create('introductions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('from_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('to_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('meeting_id')->nullable()->constrained('meetings')->nullOnDelete();
            $table->date('introduced_at')->nullable();
            $table->text('note')->nullable();
            $table->timestamps();
        });

        Schema::table('introductions', function (Blueprint $table) {
            $table->index(['owner_member_id', 'from_member_id', 'to_member_id'], 'introductions_owner_from_to_index');
            $table->index('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('introductions');
    }
};
