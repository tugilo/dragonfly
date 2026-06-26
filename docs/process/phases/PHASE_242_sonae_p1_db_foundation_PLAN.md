# PHASE_242_sonae_p1_db_foundation PLAN

**作成日時:** 2026-06-24 18:03:34  
**最終更新日時:** 2026-06-24 20:09:45 JST  
**Phase Type:** implement  
**Branch:** feature/phase242-sonae-p1-db-foundation  
**Related SSOT:** SPEC-017（SONAE 要件定義 §11 DB設計・§15.5 P1）  
**Status:** completed

---

## Purpose

SONAE PoC（DragonFly モデルチャプター）の **P1 前半** として、SPEC-017 §11 のデータモデルを Religo と衝突しない `sonae_*` テーブルとして実装する。Religo workspace / members との接続（`source_system` + `external_id`）と、DragonFly 初期ブートストラップ・メンバー同期の土台を作る。

---

## Scope

### 変更可能

- `www/database/migrations/**`（SONAE テーブル）
- `www/database/seeders/**`
- `www/app/Models/Sonae/**`
- `www/app/Services/Sonae/**`
- `www/app/Console/Commands/Sonae/**`
- `www/tests/**`（SONAE 関連）
- `docs/process/phases/PHASE_242_*`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`

### 変更しない（後続 Phase）

- LINE Webhook / Push 通知
- 気象庁取得ジョブ
- 管理画面 React UI
- メンバー回答画面
- `package.json` / `composer.json`

---

## DoD

- [x] `sonae_*` 全テーブル migration が `php artisan migrate` で成功する
- [x] `alert_types` マスタ（9種）が seeder で投入される
- [x] `SonaeChapter` が Religo `workspaces` と `source_system=religo` + `external_id` で接続できる
- [x] `php artisan sonae:bootstrap-dragonfly` で DragonFly chapter 作成 + メンバー同期が動く
- [x] Feature test が migration / bootstrap / sync を検証する
- [x] `php artisan test` が通る（513 passed）

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | Migration | SPEC-017 §11.2 の全テーブルを `sonae_` 接頭辞で作成 |
| 2 | Models | `App\Models\Sonae\*` Eloquent + リレーション |
| 3 | Seeder | `SonaeAlertTypeSeeder`（地震・津波等9種） |
| 4 | Bootstrap | `SonaeBootstrapService` + `sonae:bootstrap-dragonfly` |
| 5 | Member sync | Religo `members` → `sonae_members` 同期サービス |
| 6 | Tests | `SonaeBootstrapTest` |

---

## 設計判断

| 項目 | 判断 |
|------|------|
| テーブル接頭辞 | Religo `members` / `users` と衝突回避のため **`sonae_*`** |
| 認証 | PoC P1-A では Religo Sanctum を流用。`sonae_users` は standalone 用に schema のみ |
| チャプター単位 | `sonae_chapters.external_id` = `workspaces.id` |
| メンバー | `sonae_members.external_id` = Religo `members.id` |
| 暗号化 | LINE secret/token は Laravel `encrypted` キャスト（既存 Zoom パターン踏襲） |

---

## 後続 Phase 予定（参考）

| Phase | 内容 |
|-------|------|
| 244+ | LINE 設定 API + Webhook + 友だち紐付け |
| 245+ | 気象庁取得 + AlertEvent + 発報条件 |
| 246+ | 管理画面（ダッシュボード・集計・訓練発報） |
| 247+ | メンバー回答画面（トークン URL） |
