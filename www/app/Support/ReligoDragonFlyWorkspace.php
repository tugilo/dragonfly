<?php

namespace App\Support;

use App\Models\Workspace;
use Illuminate\Database\Eloquent\Builder;

/**
 * DragonFly チャプター（workspaces.slug = bni_dragonfly）のスコープ。
 * Members 名簿・1to1 リードなど、自チャプター在籍メンバー限定に使う。
 */
final class ReligoDragonFlyWorkspace
{
    public static function slug(): string
    {
        return (string) config('religo.dragonfly_workspace_slug', 'bni_dragonfly');
    }

    public static function id(): ?int
    {
        static $cached = null;
        static $resolved = false;
        if ($resolved) {
            return $cached;
        }
        $resolved = true;
        $id = Workspace::query()->where('slug', self::slug())->value('id');

        $cached = $id !== null ? (int) $id : null;

        return $cached;
    }

    /**
     * DragonFly 在籍メンバー: workspace_id が自チャプター、または未設定（レガシー名簿行）。
     *
     * @param  Builder<\App\Models\Member>  $query
     */
    public static function applyChapterMemberScope(Builder $query, string $column = 'workspace_id'): void
    {
        $workspaceId = self::id();
        if ($workspaceId === null) {
            return;
        }

        $query->where(function ($q) use ($workspaceId, $column) {
            $q->where($column, $workspaceId)
                ->orWhereNull($column);
        });
    }
}
