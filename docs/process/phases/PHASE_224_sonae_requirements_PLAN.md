# Phase 224 PLAN — SONAE 要件定義

**作成:** 2026-06-18 18:00 JST  
**Phase Type:** docs  
**Branch:** develop（既存未コミット変更あり。ユーザーから commit / merge 指示なし）  
**Related SSOT:** SPEC-017（SONAE 要件定義書）  
**Status:** in_progress

---

## Purpose

Religo の拡張モジュールとして開発する BNI チャプター向け災害安否確認サービス **SONAE** について、DragonFly 向け 20万円 MVP の要件定義を作成する。

SONAE は Religo 利用チャプターでは Religo のログイン・チャプター・メンバー情報を活用し、Religo 未利用チャプターでは単体利用できる構成とする。

---

## Scope

変更可能範囲:

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_224_sonae_requirements_*.md`

変更しない範囲:

- `www/**`
- `infra/**`
- DB dump
- 既存の 1to1 議事録・会議議事録

---

## DoD

- SONAE の要件定義書が Markdown で作成されている。
- 成果物として指定された以下の観点が含まれている。
  - SONAE 要件定義書
  - 機能一覧
  - MVP 範囲
  - 画面一覧
  - データベース設計案
  - 通知フロー
  - 気象庁連携仕様
  - LINE 連携仕様
  - 権限設計
  - 今後の拡張案
  - 概算見積もり用の開発スコープ
- 新規 SSOT として `SPEC-017` を登録する。
- `docs/INDEX.md` に SONAE 要件定義書と Phase ファイルを追記する。
- `docs/dragonfly_progress.md` に JST 時刻付きで進捗を追記する。
- コード変更を行わない。

---

## Tasks

1. 既存 SSOT Registry と Phase Registry を確認する。
2. ユーザー提供要件と参考資料の要点を、SONAE 独自の要件として再構成する。
3. `docs/SSOT/SONAE_REQUIREMENTS.md` を作成する。
4. `SSOT_REGISTRY.md` / `INDEX.md` / `PHASE_REGISTRY.md` / `dragonfly_progress.md` を同期する。
5. Phase WORKLOG / REPORT を作成する。

---

## Notes

- 参考元の既存サービス名は SONAE 要件定義書では使用しない。
- DragonFly 専用に閉じず、他チャプター横展開に必要なマルチテナント・LINE アカウント分離・Religo/単体利用分岐を最初から定義する。
