<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-009 / DATA_MODEL §4.14 — 内部リファーラル（TYFCB 相当）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('internal_referrals', function (Blueprint $table) {
            $table->id();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('buyer_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('seller_member_id')->constrained('members')->restrictOnDelete();
            $table->string('summary');
            $table->date('closed_on')->nullable();
            $table->unsignedBigInteger('amount_yen')->nullable();
            $table->text('notes')->nullable();
            $table->timestamps();

            $table->index(['owner_member_id', 'created_at']);
            $table->index('workspace_id');
            $table->index('buyer_member_id');
            $table->index('seller_member_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('internal_referrals');
    }
};
