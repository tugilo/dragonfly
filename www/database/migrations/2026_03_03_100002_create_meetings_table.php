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
        Schema::create('meetings', function (Blueprint $table) {
            $table->id();
            $table->unsignedInteger('number')->nullable()->unique();
            $table->string('session_type', 64)->default('chapter_weekly');
            $table->date('held_on');
            $table->string('name', 255)->nullable();
            $table->timestamps();
        });

        Schema::table('meetings', function (Blueprint $table) {
            $table->index('held_on');
            $table->index(['session_type', 'held_on'], 'meetings_session_type_held_on_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meetings');
    }
};
