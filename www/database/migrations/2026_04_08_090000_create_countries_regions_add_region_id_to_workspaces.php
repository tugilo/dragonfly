<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Country > Region > Workspace（チャプター）階層の土台。
 * SSOT: ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1 / DATA_MODEL.md
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('countries', function (Blueprint $table) {
            $table->id();
            $table->string('name', 128);
            $table->timestamps();
            $table->unique('name');
        });

        Schema::create('regions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('country_id')->constrained('countries')->cascadeOnDelete();
            $table->string('name', 255);
            $table->timestamps();
            $table->unique(['country_id', 'name']);
        });

        Schema::table('workspaces', function (Blueprint $table) {
            $table->foreignId('region_id')->nullable()->after('slug')->constrained('regions')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('workspaces', function (Blueprint $table) {
            $table->dropForeign(['region_id']);
            $table->dropColumn('region_id');
        });
        Schema::dropIfExists('regions');
        Schema::dropIfExists('countries');
    }
};
