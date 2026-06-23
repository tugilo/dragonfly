# Phase 234 PLAN — チームMTG議事録 DB 化 要件整理

**作成:** 2026-06-23 19:25 JST  
**Phase Type:** docs  
**Branch:** develop（commit / merge はユーザー指示時）  
**Related SSOT:** SPEC-018（新規）、SPEC-014、MEETING_DOMAIN_IA、DATA_MODEL  
**Status:** completed

---

## Purpose

チーム MTG 議事録（`docs/meetings/team/`）を Religo DB に保存し、Meetings 履歴で種別ごとに閲覧するための要件を SSOT として整理する。提案の **meeting_types マスタ + meetings 種別/team_id** 方針を採用し、実装 Phase の DoD を確定する。

---

## Scope

変更可能:

- `docs/SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md`（新規）
- `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md`（モメンタム/BOD 取込記述整合）
- `docs/SSOT/MEETING_DOMAIN_IA.md`（種別横断 IA）
- `docs/SSOT/DATA_MODEL.md`（§4.6b meeting_types）
- `docs/meetings/team/README.md`（新規）
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_234_*`

変更しない:

- `www/**`（実装は後続 Phase A–D）
- `infra/**`

---

## DoD

- [x] SPEC-018 としてチーム MTG 議事録 DB 化 SSOT を作成
- [x] `meeting_types` / `meetings.team_id` / `meeting_minutes` 再利用のデータ要件を文書化
- [x] Markdown 取込・API フィルタ・UI 出し分け要件を文書化
- [x] 実装 Phase A–D の順序とテスト方針を確定
- [x] 関連 SSOT（SPEC-014 / IA / DATA_MODEL）を整合
- [x] INDEX / progress / PHASE_REGISTRY 更新
- [x] コード変更なし

---

## Tasks

1. SSOT_REGISTRY で次 Spec ID（SPEC-018）を確認
2. `TEAM_MEETING_MINUTES_REQUIREMENTS.md` 作成
3. 関連 SSOT 3 件を更新
4. `meetings/team/README.md` 作成
5. Phase WORKLOG / REPORT、INDEX、progress 同期
