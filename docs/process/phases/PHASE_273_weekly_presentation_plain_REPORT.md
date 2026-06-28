# Phase 273 REPORT: ウィークリープレゼン リテラシ配慮版へ差し替え

## Summary

ITリテラシが高くない聞き手にも伝わるよう、次廣のウィークリープレゼンを専門用語（データベース・Webシステム等）を排した症状型（「探す・書き写す・確認する」を減らす）へ差し替えた。Intro Living Document §2.5 に推奨稿として追記し、ダッシュボードが参照する `members.id=37` の `weekly_presentation_body` を同稿へ更新した。木村杏那さんとの役割分担（現場に近い軽量改善／本格システム化）が、用語なしでも聞き手に伝わる入口に揃えた。

## Deliverables

- `docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`（§2.5.6 追記・場面別ナビ調整）
- `www/database/sync/dragonfly.sql`（member 37 weekly_presentation_body 差し替え・db-export）
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_273_weekly_presentation_plain_PLAN.md`
- `docs/process/phases/PHASE_273_weekly_presentation_plain_WORKLOG.md`
- `docs/process/phases/PHASE_273_weekly_presentation_plain_REPORT.md`

## Decisions

- ダッシュボード採用稿は §2.5.6（リテラシ配慮版）とし、§2.1 標準稿はカテゴリ表記揃えの補助稿として残す。
- 専門用語を稿本文から排し、芯のフレーズを「探す・書き写す・確認する」に統一。
- 木村杏那さんとの差別化は「作れる/作れない」ではなく入口と深さの役割分担として表現。

## DoD Check

| Item | Result |
|------|--------|
| §2.5 にリテラシ配慮版を追記・ダッシュボード採用稿明記 | OK |
| member id=37 weekly_presentation_body 更新 | OK |
| dragonfly.sql 更新（db-export） | OK |
| ダッシュボード API で新稿確認 | OK（DashboardApiTest 30 passed・DB 値 227 chars 確認） |
| php artisan test | OK（577 passed / 2126 assertions） |
| INDEX / progress / PHASE_REGISTRY 同期 | OK |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（commit / merge 未依頼） |
| source branch | feature/phase273-weekly-presentation-plain |
| target branch | develop |
| phase id | 273 |
| phase type | implement |
| related ssot | SPEC-004, Intro Living Document §2, `1to1_kimura_anna_andirich.md` |
| test command | php artisan test |
| test result | 577 passed（2126 assertions） |
| changed files | `docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`, `www/database/sync/dragonfly.sql`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_273_weekly_presentation_plain_{PLAN,WORKLOG,REPORT}.md` |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

## Notes（要確認・引き継ぎ）

- 作業開始時、develop 作業ツリーに本Phaseと無関係な `dragonfly.sql` 未コミット差分（`countries` Japan シード、複数 guest→member 区分変更、古屋周治の会社紐付け 等・2026-06-28 09:10 エクスポート分）が存在。db-export により同ファイルに本Phaseの変更と混在する。commit/merge のグルーピングはユーザー判断。
- 本番／開発DB（religo_app / religo_dev）への weekly_presentation_body 反映は未実施（スコープ外）。必要なら別途 db-push。
