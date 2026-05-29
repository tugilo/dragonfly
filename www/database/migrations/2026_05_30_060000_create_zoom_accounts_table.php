<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Zoom 連携（SPEC-012）: ユーザー（Owner）単位の OAuth トークン保管。
 * access_token / refresh_token は Eloquent encrypted キャストで暗号化保存する。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('zoom_accounts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('zoom_user_id')->nullable();
            $table->string('zoom_account_id')->nullable();
            $table->string('zoom_email')->nullable();
            $table->text('access_token')->nullable();
            $table->text('refresh_token')->nullable();
            $table->dateTime('token_expires_at')->nullable();
            $table->text('scopes')->nullable();
            $table->timestamps();

            $table->unique('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('zoom_accounts');
    }
};
