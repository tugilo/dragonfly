<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('meeting_minutes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->unique()->constrained('meetings')->cascadeOnDelete();
            $table->longText('body_markdown');
            $table->string('source_path', 512);
            $table->string('doc_type', 64)->nullable();
            $table->date('session_date')->nullable();
            $table->string('session_time_jst', 32)->nullable();
            $table->text('session_time_note')->nullable();
            $table->string('format', 32)->nullable();
            $table->string('source', 255)->nullable();
            $table->json('front_matter')->nullable();
            $table->timestamp('imported_at');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('meeting_minutes');
    }
};
