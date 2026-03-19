<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * M7-M7: 参加者CSV import 単位の未解決→マスタ紐づけ（CSVファイルは変更しない）。
     */
    public function up(): void
    {
        Schema::create('meeting_csv_import_resolutions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_csv_import_id')->constrained('meeting_csv_imports')->cascadeOnDelete();
            $table->string('resolution_type', 16);
            $table->string('source_value', 512);
            $table->unsignedBigInteger('resolved_id');
            $table->string('resolved_label', 512)->nullable();
            $table->string('action_type', 16);
            $table->timestamps();

            $table->unique(['meeting_csv_import_id', 'resolution_type', 'source_value'], 'csv_import_resolutions_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meeting_csv_import_resolutions');
    }
};
