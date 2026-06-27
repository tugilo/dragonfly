# Phase 266 PLAN — Onboarding Preparation（SPEC-020 Phase E）

**作成:** 2026-06-27 12:10 JST  
**Phase Type:** docs  
**Branch:** `feature/phase266-onboarding-preparation`  
**Related SSOT:** SPEC-010、SPEC-011、SPEC-020 §11.6 順位 9 / §11.8 Phase E  
**Status:** completed  

---

## Purpose

SPEC-020 P0-C 順位 9（オンボーディング整備）を完了する。DragonFly メンバー試験配布の **アカウント作成方法を確定**する（B9）。

調査の結果、**自己登録 API / UI・owner 自動紐付けは実装済み**で、残課題は `members.email` 整備（運用）のみ。よって本 Phase は **docs**（方式確定）とする。

---

## Scope

### 変更可（docs のみ）

| 領域 | ファイル |
|------|----------|
| SSOT | `docs/SSOT/ONBOARDING_AND_ACCOUNT_PROVISIONING.md`（新規） |
| Phase docs | `PHASE_266_*` |
| Index/Progress/Registry | `INDEX.md`、`dragonfly_progress.md`、`PHASE_REGISTRY.md` |

### 変更しない

- コード（自己登録は実装済み・MVP で追加実装不要）
- 仮発行/招待リンク（将来拡張）

---

## DoD

- [ ] オンボーディング方式を SSOT 文書化（自己登録を正式採用）
- [ ] PoC 配布チェックリストを明記
- [ ] 必要差分（Fit & Gap）と「MVP 追加実装不要」を明記
- [ ] INDEX / 進捗 / PHASE_REGISTRY 更新
- [ ] docs フェーズのため test はスキップ

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | 現状調査（register API / service / email 整備状況） | As-Is 記載 |
| 2 | 方式確定 doc 作成 | 自己登録採用・手順・Fit&Gap |
| 3 | INDEX / 進捗 / Registry 更新 | 反映 |
