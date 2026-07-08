# Phase 279 WORKLOG: リファーラル提案 — 再生成 force

**Branch:** `feature/phase279-referral-suggestion-force-regenerate`

## 2026-07-08 20:06 JST

- SSOT: COMMON §3「digest 重複抑制」は初回生成の既定。§4.2「再生成のトリガー」はモーダル再生成ボタン。同一 digest でも利用者が明示再生成した場合は新 run を許可するため `force` フラグで分岐。
- 実装方針: Service の digest キャッシュ lookup を `if (! $force)` で囲む。UI は `payload.run` 存在時に `force=true`。
- main 上の WIP を stash し、develop から feature ブランチで取り込む。

## 2026-07-08 20:12 JST

- 検証: `php artisan test` 592 passed、`npm run build` OK。
- `dragonfly.sql` は Phase scope 外のためコミットから除外。
