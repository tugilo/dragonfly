# PHASE15A Religo SSOT（DATA_MODEL）現状実装同期 — PLAN

**Phase:** DATA_MODEL.md を Phase14 正規化（categories / roles / member_roles）と矛盾しない状態にする  
**作成日:** 2026-03-05  
**SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md)

---

## 1. 目的

- docs/SSOT/DATA_MODEL.md が Phase14 の正規化と一致するように更新する。
- 「members.category は廃止され、categories がマスタ」を明記する。
- 「role_notes は廃止され、member_roles で履歴管理」を明記する。
- 「去年のプレジは誰？」が member_roles で引けることを SSOT に記載する。

## 2. 作業内容

1. **members セクションの更新**
   - members.category_id（FK）を追加。
   - category（文字列）・role_notes（文字列）は削除済みであることを明記。
   - 大カテゴリ／実カテゴリの概念整理（group_name / name）。

2. **新規セクションの追加**
   - categories（マスタ）: group_name, name。
   - roles（マスタ）: name, description。
   - member_roles（履歴）: term_start, term_end。current_role の定義（term_end IS NULL かつ term_start <= 今日の最新 1 件）。

3. **既存 API 互換の記載**
   - attendees / roommates 等で「互換のため current_role 名・category 表示用文字列を返す」ことを追記。

## 3. DoD

- [x] DATA_MODEL.md が現状実装と一致（正規化済みの事実が反映）
- [x] INDEX に Phase15A ドキュメントを反映（必要なら）
- [x] PLAN / WORKLOG / REPORT を docs/process/phases/ に作成

## 4. Git

- ブランチ: `feature/phase15a-ssot-data-model-sync`
- コミット: 1 コミット。メッセージ: `docs: sync DATA_MODEL SSOT with category/role normalization`
