<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * BNI の「1 to 1」の予定と実施履歴（Religo 会の地図 SSOT）。
     */
    public function up(): void
    {
        Schema::create('one_to_ones', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('target_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('meeting_id')->nullable()->constrained('meetings')->nullOnDelete();
            $table->dateTime('scheduled_at')->nullable();
            $table->dateTime('started_at')->nullable();
            $table->dateTime('ended_at')->nullable();
            $table->string('status', 20); // planned / completed / canceled
            $table->text('notes')->nullable();
            $table->timestamps();
        });

        Schema::table('one_to_ones', function (Blueprint $table) {
            $table->index(['owner_member_id', 'target_member_id']);
            $table->index('scheduled_at');
            $table->index('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('one_to_ones');
    }
};
