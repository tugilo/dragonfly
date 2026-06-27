<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * SPEC-020 Phase A: bootstrap Default ユーザーから個人 owner 紐付けを解除する。
 * fallback 無効化と組み合わせ、未認証で次廣 owner として扱われる経路を閉じる。
 */
return new class extends Migration
{
    public function up(): void
    {
        DB::table('users')
            ->where('email', 'default@religo.local')
            ->whereNotNull('owner_member_id')
            ->update([
                'owner_member_id' => null,
                'updated_at' => now(),
            ]);
    }

    public function down(): void
    {
        // 本番 owner 紐付けは復元しない（データ依存のため不可逆）
    }
};
