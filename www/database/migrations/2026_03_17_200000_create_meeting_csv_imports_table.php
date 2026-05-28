<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * M7-C1: 参加者CSVを Meeting に紐づけて保存するテーブル。1 Meeting に複数CSVを許容（履歴用）。
     */
    public function up(): void
    {
        Schema::create('meeting_csv_imports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained('meetings')->cascadeOnDelete();
            $table->string('file_path', 512);
            $table->string('file_name', 255);
            $table->timestamp('uploaded_at')->nullable();
            $table->timestamps();
        });

        Schema::table('meeting_csv_imports', function (Blueprint $table) {
            $table->index('meeting_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meeting_csv_imports');
    }
};
