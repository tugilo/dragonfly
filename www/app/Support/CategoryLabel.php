<?php

namespace App\Support;

use App\Models\Category;

/**
 * categories の一覧表示と同じ規則（group_name === name なら name のみ）。
 */
final class CategoryLabel
{
    public static function format(?Category $category): ?string
    {
        if ($category === null) {
            return null;
        }
        $g = (string) $category->group_name;
        $n = (string) $category->name;

        return $g === $n ? $n : $g.' / '.$n;
    }
}
