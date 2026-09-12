# PLAN: Phase 307 — ウィークリー稿のパターン切替と利用履歴

| 項目 | 内容 |
|------|------|
| **Phase ID** | **307** |
| **種別** | implement |
| **Related SSOT** | SPEC-004 — [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md) |
| **参照** | [DATA_MODEL.md](../../SSOT/DATA_MODEL.md)、[MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md)、Living Document §2.5.7 / §2.5.8 |
| **ブランチ** | `feature/phase307-weekly-presentation-patterns` |
| **開始** | 2026-09-12 10:53 JST |
| **モック比較** | モック比較: [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。原稿カードはモック未収録。差分は [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) に記録する。 |

---

## 1. 背景

Living Document §2.5.8 で、ウィークリー25秒を A定番 / B 26年 / C属人化 / D士業 / E多店舗から毎週1つ選ぶ運用にした。Dashboard は `members.weekly_presentation_body` の1本文だけなので、例会前に切替できない。切替した日とパターンも残したい。

## 2. 方針

- 既存キー `weekly_presentation_body` は残す。選んだ稿の本文をここにも同期する（旧クライアント互換）。
- パターン一覧は `members.weekly_presentation_patterns`（JSON）。無いメンバーは従来どおり1本文。
- 選択中は `members.weekly_presentation_active_id`。
- 利用履歴は別テーブル `member_weekly_presentation_usages`（member_id / pattern_id / used_on JST / used_at）。切替では書かない。例会後の「この週に使った」だけ書く。同一日・同一パターンは1行に畳む。
- スタートダッシュタブは変えない。
- 次廣（`members.id=37`）だけ A〜E をシードする。他メンバーは空。
- `dragonfly.sql` の再エクスポートはしない（develop 作業ツリーが別件で dirty）。

## 3. Scope

### 含む

- migration（members 2カラム + usages テーブル）
- GET `/api/dashboard/weekly-presentation` に patterns / active_id / usages を追加
- POST `/api/dashboard/weekly-presentation/select`（pattern_id）
- Dashboard カードのパターン切替と最近の利用表示
- 次廣分シード
- SPEC-004 / DATA_MODEL / FIT_AND_GAP / Living Document / INDEX / progress / REGISTRY
- Feature テスト・`npm run build`

### 含まない

- Members 編集 UI でのパターン CRUD
- db-export / db-push / 本番
- 症状ローテ §2.5.1〜D
- commit / merge / push

## 4. DoD

- [x] パターンがある Owner はウィークリータブで A〜E を切替できる
- [x] パターンが無い Owner は従来の1本文表示のまま
- [x] 切替で `weekly_presentation_body` が同期される。利用履歴は切替では残らない
- [x] 例会後の「この週に使った」で利用履歴（日付＋パターン）が残る
- [x] 同一日・同一パターンの再選択で履歴行が増えない
- [x] 既存 GET キー `weekly_presentation_body` / `start_dash_presentation_body` が残る
- [x] `php artisan test` と `npm run build` が成功する
- [x] FIT_AND_GAP にパターン切替を記録する

## 5. 変更予定ファイル

| 種別 | パス |
|------|------|
| migration / seeder | `www/database/migrations/*_weekly_presentation_patterns.php`、`www/database/seeders/TsugihiroWeeklyPresentationPatternsSeeder.php` |
| Model / Service / API | `Member.php`、`MemberWeeklyPresentationUsage.php`、`WeeklyPresentationPatternService.php`、`DashboardController.php`、`routes/api.php` |
| Test | `www/tests/Feature/Religo/DashboardApiTest.php` |
| UI | `Dashboard.jsx`、`DashboardWeeklyPresentationPanel.jsx` |
| docs | SPEC-004、DATA_MODEL、FIT_AND_GAP、Living Document、INDEX、progress、PHASE_REGISTRY、本三点 |
