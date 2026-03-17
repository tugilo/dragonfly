<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-P1: 参加者PDFを Meeting に紐づけて保存するテーブル。1 Meeting = 1 PDF（初期）。
     */
    public function up(): void
    {
        Schema::create('meeting_participant_imports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->string('file_path', 512);
            $table->string('original_filename', 255);
            $table->string('status', 20)->default('uploaded');
            $table->timestamps();
        });

        Schema::table('meeting_participant_imports', function (Blueprint $table) {
            $table->unique('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meeting_participant_imports');
    }
};
