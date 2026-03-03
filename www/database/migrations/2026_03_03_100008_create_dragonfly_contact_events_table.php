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
        Schema::create('dragonfly_contact_events', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('target_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('meeting_id')->nullable()->constrained('meetings')->nullOnDelete();
            $table->string('event_type', 32);
            $table->string('reason', 280)->nullable();
            $table->json('meta')->nullable();
            $table->timestamp('created_at')->nullable();
        });

        Schema::table('dragonfly_contact_events', function (Blueprint $table) {
            $table->index(['owner_member_id', 'target_member_id', 'created_at'], 'dragonfly_contact_events_owner_target_created_index');
            $table->index('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dragonfly_contact_events');
    }
};
