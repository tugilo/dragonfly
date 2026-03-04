<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * owner→target のメモ。meeting に紐付け可能（会の地図 SSOT）。
     */
    public function up(): void
    {
        Schema::create('contact_memos', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('target_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('meeting_id')->nullable()->constrained('meetings')->nullOnDelete();
            $table->text('body')->nullable();
            $table->timestamps();
        });

        Schema::table('contact_memos', function (Blueprint $table) {
            $table->index(['owner_member_id', 'target_member_id', 'created_at'], 'contact_memos_owner_target_created_index');
            $table->index('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('contact_memos');
    }
};
