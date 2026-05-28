# M8.6: members.ncast_profile_url SSOT反映 — PLAN

**Phase ID:** M8.6  
**種別:** docs  
**作成日:** 2026-03-31  
**Related SSOT:** [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.2 members  

---

## 1. 目的

- `members.ncast_profile_url` を **DATA_MODEL.md** に明記し、既存実装・API・管理 UI と SSOT を一致させる。
- tugilo 式の **PLAN / WORKLOG / REPORT** を残し、`docs/INDEX.md` から参照可能にする。

## 2. 背景

- DB・API・UI（Members 詳細ドロワー・メンバー Show/Edit）への `ncast_profile_url` 追加は先行して完了している。
- SSOT（DATA_MODEL.md の members 節）に当該カラムが未記載のため、参照時に実装とドキュメントが食い違う状態だった。

## 3. 対象範囲

- **docs のみ。** アプリケーションコード・テストコード・マイグレーションには手を入れない。
- 変更対象: `docs/SSOT/DATA_MODEL.md`、本 PLAN / WORKLOG / REPORT、`docs/INDEX.md`。Phase 登録のため `docs/process/PHASE_REGISTRY.md` に 1 行追加する。

## 4. 変更ファイル一覧（予定）

| ファイル | 内容 |
|----------|------|
| [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) | §4.2 members の **主要カラム** に `ncast_profile_url` を追記 |
| [PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md) | 本ファイル |
| [PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md) | 作業ログ |
| [PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md](PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md) | 完了報告 |
| [INDEX.md](../../INDEX.md) | process/phases に M8.6 の 3 文書へのリンクを追加 |
| [PHASE_REGISTRY.md](../PHASE_REGISTRY.md) | M8.6 行を追加 |

## 5. DoD（Definition of Done）

- [x] `DATA_MODEL.md` の members 節（表の **主要カラム**）に `ncast_profile_url` が、既存の並び・書式に合わせて追加されている。
- [x] 記載内容が実装と矛盾しない（型・nullable・API 概要・UI の扱い）。
- [x] members 以外のセクションや他テーブル定義を不必要に変更していない。
- [x] PLAN / WORKLOG / REPORT が `docs/process/phases/` に揃い、`INDEX.md` からリンクされている。
