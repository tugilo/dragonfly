# PHASE12R Religo 全体ロードマップ SSOT — WORKLOG

**Phase:** Religo 全体ロードマップ SSOT 確立  
**作成日:** 2026-03-05

---

## Step 0: 前提確認

- 既存 SSOT（DATA_MODEL.md, ADMIN_UI_THEME_SSOT.md）と INDEX.md・dragonfly_progress.md を確認し、矛盾のない ROADMAP 記述を行う。
- コード変更は行わず、docs のみ作成・更新する。

## Step 1: ROADMAP.md 作成

- docs/SSOT/ROADMAP.md を新規作成。
- 章立て: 1. Purpose, 2. Scope Lock, 3. 現在地（As-Is Snapshot）, 4. Target UX（To-Be）, 5. Roadmap（Phase Map）, 6. Execution Playbook, 7. 「今週の Next 3」.
- Roadmap 表は Phase ID・目的・主要成果物・依存・DoD・テスト・スコープ外の列で、4 レーン（A: UI/IA, B: データ整合, C: 機能拡張, D: 運用品質）で記載。
- Religo＝プロダクト名で統一。

## Step 2: Phase12R の PLAN / WORKLOG / REPORT 作成

- PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md: 目的・スコープ・変更ファイル・DoD・リスク・ロールバック・Git.
- PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md: 本ファイル。Step0〜Step4 の作業ログテンプレ。
- PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md: 変更ファイル一覧・ROADMAP の要点・DoD 達成状況・コミット ID・取り込み証跡欄.

## Step 3: INDEX.md 更新

- docs/INDEX.md の「SSOT（docs/SSOT/）」セクションに ROADMAP.md の行を追加。
- 説明: Religo 全体ロードマップ SSOT。Phase 順序・DoD・依存・スコープロック・テスト規約。

## Step 4: dragonfly_progress.md 更新

- docs/dragonfly_progress.md の進捗一覧に「ロードマップ SSOT 確定（Phase12R）」を 1 行で記録。
- 日付は作業完了日。

## Step 5: 最終チェック

- ROADMAP.md の Roadmap 表が依存関係付きで矛盾していないこと。
- 既存 SSOT（DATA_MODEL 等）との整合が取れていること。
- INDEX.md の追加リンクが壊れていないこと。
