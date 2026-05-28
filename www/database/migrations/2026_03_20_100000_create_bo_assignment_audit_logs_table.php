<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * BO-AUDIT-P1: Connections / Meetings 経由の BO（breakout）保存の監査。
 * Dashboard Activity の `bo_assigned` ソース。CSV apply ログとは別テーブル。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('bo_assignment_audit_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->restrictOnDelete();
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->unsignedBigInteger('actor_owner_member_id')->nullable();
            $table->foreign('actor_owner_member_id')->references('id')->on('members')->nullOnDelete();
            $table->unsignedBigInteger('workspace_id')->nullable();
            $table->string('source', 40);
            $table->json('payload');
            $table->dateTime('occurred_at');
            $table->timestamps();

            $table->index(['actor_owner_member_id', 'occurred_at']);
            $table->index('meeting_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('bo_assignment_audit_logs');
    }
};
