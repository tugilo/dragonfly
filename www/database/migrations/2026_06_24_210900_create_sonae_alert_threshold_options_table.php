<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-017 §9.6 / §11.2: 発報条件 UI 用閾値マスタ。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sonae_alert_threshold_options', function (Blueprint $table) {
            $table->id();
            $table->foreignId('alert_type_id')->constrained('sonae_alert_types')->restrictOnDelete();
            $table->string('code');
            $table->string('label');
            $table->integer('severity_rank');
            $table->integer('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->unique(['alert_type_id', 'code'], 'sonae_alert_threshold_type_code_uniq');
            $table->index(['alert_type_id', 'is_active'], 'sonae_alert_threshold_type_active_idx');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sonae_alert_threshold_options');
    }
};
