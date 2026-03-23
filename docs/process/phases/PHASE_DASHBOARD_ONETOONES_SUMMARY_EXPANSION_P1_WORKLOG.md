# PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1 — WORKLOG

## 判断

- **既存 `monthly_one_to_one_count`:** `status=completed` かつ `started_at` が当月 — **変更なし**（活動ペースの主指標として維持）。
- **追加:** `one_to_ones` を owner で `COUNT(*)` / `planned` / `canceled` に分け、**「登録はあるが今月実施が 0」**を数字で説明可能にした。
- **UI:** 4 枚グリッドは維持。1to1 カードのみ **2 行目 caption**（案A/B）で内訳を表示。ラベルは「今月の1to1（実施）」に変更し、主数値が「実施」であることを明示。
- **verify-summary:** `DB::table` で total / planned / canceled を `getStats` と突合。stale は従来どおり。

## 実装メモ

- `DashboardService::buildOneToOneInventorySubtext` で文言をサーバ一元化。
- `DashboardService` 先頭の重複 docblock を整理（`countStaleContacts` 前に誤った `getStats` @return があったため削除）。

## テスト・ビルド

- `DashboardApiTest`: 新キー assert + `test_stats_one_to_one_inventory_matches_status_counts`
- `php artisan test` — 329 passed（実施時点）
- `npm run build` — 成功

## merge

- develop 取り込みと REPORT §8 の Merge Evidence は merge 後に追記。
