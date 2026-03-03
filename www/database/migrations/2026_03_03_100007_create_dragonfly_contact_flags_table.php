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
        Schema::create('dragonfly_contact_flags', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_member_id')->constrained('members')->restrictOnDelete();
            $table->foreignId('target_member_id')->constrained('members')->restrictOnDelete();
            $table->boolean('interested')->default(false);
            $table->boolean('want_1on1')->default(false);
            $table->json('extra_status')->nullable();
            $table->timestamps();
        });

        Schema::table('dragonfly_contact_flags', function (Blueprint $table) {
            $table->unique(['owner_member_id', 'target_member_id']);
            $table->index('owner_member_id');
            $table->index('interested');
            $table->index('want_1on1');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('dragonfly_contact_flags');
    }
};
