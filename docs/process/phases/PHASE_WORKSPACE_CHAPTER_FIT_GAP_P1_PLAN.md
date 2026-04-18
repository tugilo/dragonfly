# PLAN — WORKSPACE_CHAPTER_FIT_GAP_P1

| 項目 | 内容 |
|------|------|
| **Phase ID** | WORKSPACE_CHAPTER_FIT_GAP_P1 |
| **種別** | docs（調査のみ・コード変更なし） |
| **目的** | `workspace` と BNI **Chapter** を同一視しない方針への移行を見据え、**現行 SSOT・DB・実装との Fit & Gap** を明文化する。**前提:** 業務ルールとして **Member は 1 つの Chapter にのみ所属する**（複数 Chapter 兼務は現スコープ外）。この前提で Fit & Gap を読み直し、多所属を想起させる表現を整理する。 |
| **成果物** | [workspace_vs_chapter_fit_gap_20260403.md](../../02_specifications/workspace_vs_chapter_fit_gap_20260403.md) |
| **Related** | DATA_MODEL, WORKSPACE_RESOLUTION_POLICY, MEMBERS_WORKSPACE_ASSIGNMENT_POLICY, USER_ME_AND_ACTOR_RESOLUTION, ONETOONES_CROSS_CHAPTER_REQUIREMENTS |

## スコープ

- リポジトリ全体の `workspace` 参照の洗い出し（grep・主要ファイル読了）
- 案 A / 案 B / 案 C 比較、Fit & Gap 表、3 段階（小・本命・理想）の推奨
- **Member 単一 Chapter 専属**の業務ルールを文書に明記し、案との相性を補足する
- INDEX / PHASE_REGISTRY / dragonfly_progress 更新（必要時）

## 非スコープ

- マイグレーション・API・フロントの実装変更
- **複数 Chapter 兼務**用のスキーマ・仕様（業務ルール上対象外）

## DoD

1. Fit & Gap ドキュメントが §0（確定業務ルール）を含め §1〜§11 の構成を満たす
2. **Member の正式所属先は Chapter、1 Member : 1 Chapter** がドキュメント上で明記されている
3. **マルチ所属を想起させる表現**が整理されている（検索範囲の広がりと区別）
4. 依存分類・DB 一覧・推奨方針・次 Phase 候補が記載されている
5. INDEX・PHASE_REGISTRY・progress が更新されている（該当時）

## 修正履歴（ドキュメント整合）

| 日付 | 内容 |
|------|------|
| 2026-04-17 | 業務ルール（Member 1 Chapter 専属・workspace ≠ chapter 常時同義でない）を PLAN 目的・DoD に反映。 |
