<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 会／チャプター・プロジェクト単位。個人利用でも拡張できる土台（会の地図 SSOT）。
     */
    public function up(): void
    {
        Schema::create('workspaces', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255);
            $table->string('slug', 100)->nullable();
            $table->timestamps();
        });

        Schema::table('workspaces', function (Blueprint $table) {
            $table->index('slug');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('workspaces');
    }
};
