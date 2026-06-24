# PHASE_244_sonae_roster_core PLAN

**作成日時:** 2026-06-24 21:09 JST  
**最終更新日時:** 2026-06-24 21:15 JST  
**Phase Type:** implement  
**Branch:** feature/phase244-sonae-roster-core  
**Related SSOT:** SPEC-017（§2.6 Member Roster、§5.5 通知対象、§9.6 閾値マスタ、§11.2 DB）  
**Related Plan:** [SONAE_IMPLEMENTATION_PLAN.md](../../SSOT/SONAE_IMPLEMENTATION_PLAN.md)  
**Status:** completed

---

## Purpose

SONAE PoC の **Religo 非依存コア層**として、名簿（Roster）まわりを完成させる。Phase 242 の DB 基盤の上に、**メンバー管理 API・CSV 取込・未紐付け可視化・通知対象 Resolver・閾値マスタ**を実装し、後続 Phase（LINE・訓練・UI）が Religo に依存せずテストできる土台を作る。

L1 達成の前提となる「名簿が正しく存在し、誰に通知できるかが判別できる」状態をこの Phase で満たす。

---

## Scope

### 変更可能

- `www/database/migrations/**`（`sonae_alert_threshold_options` 追加）
- `www/database/seeders/**`（閾値マスタ seeder）
- `www/app/Models/Sonae/**`
- `www/app/Services/Sonae/**`
- `www/app/Http/Controllers/Sonae/**`
- `www/app/Http/Requests/Sonae/**`（必要なら）
- `www/routes/api.php`（`/api/sonae/*` グループ追加）
- `www/tests/Feature/Sonae/**`
- `docs/process/phases/PHASE_244_*`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`

### 変更しない（後続 Phase）

- LINE Webhook / Push 通知（Phase 245）
- 訓練発報・回答画面・集計（Phase 246）
- 管理画面 React UI（Phase 247）
- Religo メニュー統合・chapter middleware（Phase 248）
- 気象庁取得ジョブ（Phase 249）
- `package.json` / `composer.json`
- Religo コア（`members` スキーマ変更、`App\Http\Controllers\Religo\*` の改変）

---

## DoD

- [x] `sonae_alert_threshold_options` migration + seeder が `php artisan migrate` で成功する
- [x] `SonaeMemberSyncService` が Religo `members` の **`type=member` のみ**を同期する（guest/visitor 除外）
- [x] `SonaeNotificationTargetResolver` が **LINE 紐付け済み active メンバー**のみを返す（§5.5）
- [x] CSV のみのテスト用チャプターで `sonae_members` を登録できる（Religo 非依存パス）
- [x] API: チャプター配下のメンバー一覧・詳細・無効化が動作する
- [x] API: CSV 取込（プレビュー + 確定）が動作する
- [x] API: 未紐付けメンバー一覧・紐付け率 KPI が取得できる
- [x] API: Religo sync エンドポイント（既存 sync サービス呼び出し）が動作する
- [x] Feature test が上記を検証する
- [x] `php artisan test` が通る（519 passed）

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | Migration | `sonae_alert_threshold_options` テーブル（§11.2） |
| 2 | Seeder | `SonaeAlertThresholdOptionSeeder` — 地震・津波等の閾値選択肢（PoC 初期値） |
| 3 | Sync 修正 | `SonaeMemberSyncService` に `type=member` フィルタ、`MemberEnrollmentType` または同等定数を参照 |
| 4 | Resolver | `SonaeNotificationTargetResolver` — `sonae_line_user_links` active 紐付け済みメンバー抽出 |
| 5 | MemberService | `SonaeMemberService` — 一覧・更新・無効化・KPI（名簿数・紐付け数・紐付け率） |
| 6 | CSV Import | `SonaeCsvImportService` — ヘッダ検証、プレビュー、upsert（`source_system=sonae`） |
| 7 | API | `SonaeMemberController`, `SonaeChapterController`（必要最小） |
| 8 | Routes | `Route::prefix('sonae')->middleware('auth:sanctum')` グループ |
| 9 | Tests | `SonaeMemberSyncTest`, `SonaeCsvImportTest`, `SonaeNotificationTargetResolverTest`, API feature tests |

---

## 設計判断

| 項目 | 判断 |
|------|------|
| Religo 疎結合 | ビジネスロジックは `App\Services\Sonae\*` のみ。Controller は Sonae 名前空間 |
| 実行時正 | 名簿の正は常に `sonae_members`。sync は copy upsert のみ |
| `type=member` | `MemberEnrollmentType::isBniMember()` で guest/visitor 除外（active/member/inactive は同期） |
| 通知対象 | Phase 244 では Resolver のみ実装。実際の Push は Phase 245–246 |
| CSV | `source_system=sonae`, `external_id=null` で単体利用チャプターに対応 |
| 認証 | PoC では既存 Sanctum を流用。chapter スコープ middleware は Phase 248 |
| 閾値マスタ | UI は Phase 251。本 Phase は DB + seeder + 参照 API のみ（任意: `GET alert-threshold-options`） |

---

## API 案（本 Phase）

| Method | Path | 概要 |
|--------|------|------|
| GET | `/api/sonae/chapters/{chapter}` | チャプター詳細 + KPI |
| GET | `/api/sonae/chapters/{chapter}/members` | メンバー一覧（紐付け状態付き） |
| GET | `/api/sonae/chapters/{chapter}/members/unlinked` | LINE 未紐付け一覧 |
| PATCH | `/api/sonae/chapters/{chapter}/members/{member}` | 更新・無効化 |
| POST | `/api/sonae/chapters/{chapter}/members/sync` | Religo → sonae_members 手動同期 |
| POST | `/api/sonae/chapters/{chapter}/members/import-csv` | CSV 取込（`preview=true` クエリでプレビュー） |
| GET | `/api/sonae/alert-threshold-options` | 閾値マスタ一覧（種別フィルタ可） |

**認可（PoC 暫定）:** `auth:sanctum` のみ。chapter 所属チェックは Phase 248。

---

## テスト方針

1. **Religo 非依存:** `SonaeChapter` + CSV でメンバー登録 → 一覧・KPI 検証
2. **Sync フィルタ:** guest/visitor を含む workspace で sync → member のみ `sonae_members` に存在
3. **Resolver:** 紐付けあり/なしメンバー混在で Resolver が正しい集合を返す
4. **閾値 seeder:** 地震種別に `intensity_5_lower` 等が存在

---

## 後続 Phase（参考）

| Phase | 内容 |
|-------|------|
| 245 | LINE 設定 API + Webhook + 友だち紐付け + Push |
| 246 | 手動訓練発報 + 回答 URL + 集計（L1） |
| 247 | 管理画面 React `/sonae/*` |
| 248 | Religo Shell（メニュー・chapter 解決・sync UI） |

---

## モック比較

本 Phase は API / Service のみ。**UI 変更なし**のためモック比較は対象外。UI は Phase 247 で `docs/SSOT/MOCK_UI_VERIFICATION.md` に従う。
