# PHASE14 Religo DragonFly Member Model Refactor — PLAN

**Phase:** BNI DragonFly 実運用に合わせて Member 関連モデルを整理（category 正規化・role 履歴）  
**作成日:** 2026-03-05  
**SSOT:** ユーザー指示・[DATA_MODEL.md](../../SSOT/DATA_MODEL.md) 更新

---

## 1. 目的

- members テーブルに混在していた **category**（大カテゴリー）と **role_notes**（半年ごとの役職）を正規化する。
- **categories** テーブル: group_name（大カテゴリー）, name（実カテゴリー）
- **roles** / **member_roles**: 役職マスタと役職履歴（term_start / term_end）

## 2. 最終データモデル

- **categories:** id, group_name, name, timestamps
- **members:** id, name, name_kana, category_id, type, display_no, introducer_member_id, attendant_member_id, timestamps（category / role_notes 削除）
- **roles:** id, name, description, timestamps
- **member_roles:** id, member_id, role_id, term_start, term_end, timestamps

## 3. 実装ステップ

| Step | 内容 |
|------|------|
| Step1 | Category 正規化（categories migration, members.category_id, データ移行, category 削除） |
| Step2 | Role 正規化（roles / member_roles migration, role_notes 移行・削除） |
| Step3 | Backend API（member レスポンス: category オブジェクト, current_role） |
| Step4 | Admin UI（Member 一覧・編集、カテゴリー/役職 select） |
| Step5 | テスト・docs 更新 |

## 4. DoD

- [x] category 正規化完了
- [x] role 履歴管理導入
- [x] Member 一覧表示正常
- [x] DragonFlyBoard 動作確認（既存 API 互換）
- [x] docs 更新（PLAN / WORKLOG / REPORT, dragonfly_progress, INDEX）

## 5. Git

- ブランチ: `feature/phase14-1-category-normalization`（Step1〜Step5 を一括実装）
- 取り込み: develop に merge → REPORT に取り込み証跡を記録
