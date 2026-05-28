# Phase M7-M4: Role History 差分検知（表示のみ）— PLAN

**Phase ID:** M7-M4（ユーザー表記: M4 役職差分プレビュー）  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, DATA_MODEL.md, PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md

**モック比較:** 本 Phase は Meetings Drawer 内の CSV 連携ブロック拡張のみ。新規のモック画面はないため **MOCK_UI_VERIFICATION の個別比較は対象外**（既存 Drawer パターンに準拠）。

---

## 背景

- M7-C4.5 / MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS にて、役職は **member_roles** で管理し、毎週 CSV からの **自動上書きは危険** と整理済み。
- 第一歩として、CSV の「役職」列と **現在役職**（`Member::currentRole()`）を比較し、候補を **表示のみ** する。

## 目的

- 保存済み参加者 CSV の役職列と DB 上の現在役職を突き合わせ、変更候補・CSV のみ・現在のみ・未解決メンバーを返す **GET API** を追加する。
- Meetings Drawer に **「role差分を確認」** を追加し、summary と表で表示する。
- **member_roles / roles への書き込みは一切行わない。** `Role::firstOrCreate` 等によるマスタ自動作成も行わない。

## スコープ

**やること**

1. `MeetingCsvRoleDiffPreviewService`: プレビュー行の名前解決・種別フィルタは member 差分と同パターン。同一メンバーは **最終行優先**。CSV 役職 vs `currentRole()?->name` を比較。
2. バケット: `changed_role`, `csv_role_only`, `current_role_only`, `unchanged_role_count`（同一名は changed に含めない）, `unresolved_member`（名前未解決）。
3. `role_master_resolved`: `roles.name` に CSV 役職文字列が存在するか（照合のみ）。
4. `GET /api/meetings/{meetingId}/csv-import/role-diff-preview`（404/422 は既存 preview と同様）。
5. `MeetingsList.jsx`: 状態・fetch・Drawer UI（Alert・Chips・表）。
6. Feature テスト（形状・各バケット・404/422・役職列なし CSV）。

**やらないこと**

- Role History の確定反映 API・UI。
- participants / members の更新（本 API は GET のみ）。
- roles テーブルの自動作成。

## 変更対象ファイル

- www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（`roleDiffPreview`）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_*.md
- docs/process/PHASE_REGISTRY.md、docs/INDEX.md、docs/dragonfly_progress.md
- docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md（実装メモ 1 行）

## DoD

- [ ] GET role-diff-preview が仕様どおりの JSON を返す（DB の member_roles 件数が変わらない）。
- [ ] Drawer に「role差分を確認」と一覧表示がある（row_count>0 時）。
- [ ] `php artisan test` で本 Phase 用テストを含めグリーン。
- [ ] `npm run build` 成功。
- [ ] PLAN / WORKLOG / REPORT、REGISTRY / INDEX / progress / SSOT メモ更新。
