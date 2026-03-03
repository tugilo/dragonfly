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
        Schema::create('members', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255);
            $table->string('name_kana', 255)->nullable();
            $table->string('category', 255)->nullable();
            $table->string('role_notes', 500)->nullable();
            $table->string('type', 20);
            $table->string('display_no', 20)->nullable();
            $table->foreignId('introducer_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('attendant_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->timestamps();
        });

        Schema::table('members', function (Blueprint $table) {
            $table->index('type');
            $table->index('introducer_member_id');
            $table->index('attendant_member_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('members');
    }
};
